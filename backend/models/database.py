"""
Aura-Pet Backend - Database Configuration & Repositories
"""

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session
from contextlib import contextmanager
from typing import Generator, Optional
import os

# ============================================
# DATABASE CONFIGURATION
# ============================================

DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://postgres:postgres@localhost:5432/aura_pet"
)

engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,
    pool_size=10,
    max_overflow=20,
    echo=os.getenv("SQL_ECHO", "false").lower() == "true"
)

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

# ============================================
# DEPENDENCY INJECTION
# ============================================

def get_db() -> Generator[Session, None, None]:
    """
    FastAPI dependency for database sessions.
    Yields a session and ensures it's closed after use.
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@contextmanager
def get_db_context() -> Generator[Session, None, None]:
    """
    Context manager for database sessions.
    Use this outside of FastAPI dependency injection.
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ============================================
# REPOSITORY PATTERN BASE
# ============================================

class BaseRepository:
    """Base repository with common CRUD operations."""
    
    def __init__(self, db: Session):
        self.db = db
    
    def get_by_id(self, model, id):
        """Get a single record by ID."""
        return self.db.query(model).filter(model.id == id).first()
    
    def get_all(self, model, limit: int = 100, offset: int = 0):
        """Get all records with pagination."""
        return self.db.query(model).limit(limit).offset(offset).all()
    
    def create(self, model_instance):
        """Create a new record."""
        self.db.add(model_instance)
        self.db.commit()
        self.db.refresh(model_instance)
        return model_instance
    
    def update(self, model_instance):
        """Update an existing record."""
        self.db.commit()
        self.db.refresh(model_instance)
        return model_instance
    
    def delete(self, model_instance):
        """Delete a record."""
        self.db.delete(model_instance)
        self.db.commit()

# ============================================
# USER REPOSITORY
# ============================================

from .models import User, Pet, Meal, WaterLog, Transaction, UserInventory, ShopItem

class UserRepository(BaseRepository):
    model = User
    
    def get_by_email(self, email: str) -> Optional[User]:
        """Get user by email."""
        return self.db.query(User).filter(User.email == email).first()
    
    def add_coins(self, user_id, amount: int) -> User:
        """Add coins to user balance."""
        user = self.get_by_id(User, user_id)
        if user:
            user.bitecoins += amount
            return self.update(user)
        return None
    
    def deduct_coins(self, user_id, amount: int) -> Optional[User]:
        """Deduct coins from user balance."""
        user = self.get_by_id(User, user_id)
        if user and user.bitecoins >= amount:
            user.bitecoins -= amount
            return self.update(user)
        return None
    
    def update_streak(self, user_id) -> User:
        """Update user streak."""
        from datetime import datetime, timedelta
        
        user = self.get_by_id(User, user_id)
        if not user:
            return None
        
        now = datetime.now(user.last_meal_at.tzinfo) if user.last_meal_at else None
        
        if now and (now - user.last_meal_at) < timedelta(days=1):
            # Streak continues
            user.current_streak += 1
            if user.current_streak > user.longest_streak:
                user.longest_streak = user.current_streak
        elif now and (now - user.last_meal_at) < timedelta(days=2):
            # Streak broken but continue (grace period)
            user.current_streak = 1
        else:
            # Reset streak
            user.current_streak = 1
        
        user.last_meal_at = datetime.now()
        user.total_meals_logged += 1
        
        return self.update(user)

# ============================================
# PET REPOSITORY
# ============================================

class PetRepository(BaseRepository):
    model = Pet
    
    def get_by_user(self, user_id) -> list[Pet]:
        """Get all pets for a user."""
        return self.db.query(Pet).filter(Pet.user_id == user_id).all()
    
    def get_primary_pet(self, user_id) -> Optional[Pet]:
        """Get user's primary pet (slot 0)."""
        return self.db.query(Pet).filter(
            Pet.user_id == user_id,
            Pet.slot_index == 0
        ).first()
    
    def update_mood(self, pet_id, mood: str) -> Pet:
        """Update pet mood."""
        from .models import PetMood
        pet = self.get_by_id(Pet, pet_id)
        if pet:
            pet.current_mood = PetMood(mood)
            return self.update(pet)
        return None
    
    def add_xp(self, pet_id, xp: int) -> Pet:
        """Add XP and check for evolution."""
        pet = self.get_by_id(Pet, pet_id)
        if pet:
            pet.evolution_xp += xp
            
            # Check for evolution
            threshold = pet.evolution_level * 100
            if pet.evolution_xp >= threshold:
                pet.evolution_level += 1
                pet.evolution_xp = pet.evolution_xp - threshold
            
            return self.update(pet)
        return None
    
    def update_stats(self, pet_id, **kwargs) -> Pet:
        """Update pet stats (hunger, joy, vigor, affinity)."""
        pet = self.get_by_id(Pet, pet_id)
        if pet:
            for key, value in kwargs.items():
                if hasattr(pet, key):
                    setattr(pet, key, max(0, min(100, value)))
            return self.update(pet)
        return None

# ============================================
# MEAL REPOSITORY
# ============================================

class MealRepository(BaseRepository):
    model = Meal
    
    def get_by_user_today(self, user_id) -> list[Meal]:
        """Get all meals for user today."""
        from datetime import datetime
        from sqlalchemy import func
        
        today_start = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
        
        return self.db.query(Meal).filter(
            Meal.user_id == user_id,
            Meal.logged_at >= today_start
        ).all()
    
    def get_recent(self, user_id, limit: int = 10) -> list[Meal]:
        """Get recent meals for user."""
        return self.db.query(Meal).filter(
            Meal.user_id == user_id
        ).order_by(Meal.logged_at.desc()).limit(limit).all()
    
    def get_total_calories_today(self, user_id) -> int:
        """Get total calories for today."""
        from datetime import datetime
        
        today_start = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
        
        result = self.db.query(func.sum(Meal.estimated_calories)).filter(
            Meal.user_id == user_id,
            Meal.logged_at >= today_start
        ).scalar()
        
        return result or 0

# ============================================
# WATER REPOSITORY
# ============================================

class WaterRepository(BaseRepository):
    model = WaterLog
    
    def get_today_total(self, user_id) -> int:
        """Get total water intake for today."""
        from datetime import datetime
        from sqlalchemy import func
        
        today_start = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
        
        result = self.db.query(func.sum(WaterLog.amount_ml)).filter(
            WaterLog.user_id == user_id,
            WaterLog.logged_at >= today_start
        ).scalar()
        
        return result or 0
    
    def add_water(self, user_id, amount_ml: int) -> WaterLog:
        """Log water intake."""
        water_log = WaterLog(user_id=user_id, amount_ml=amount_ml)
        return self.create(water_log)

# ============================================
# SHOP REPOSITORY
# ============================================

class ShopRepository(BaseRepository):
    model = ShopItem
    
    def get_by_type(self, item_type: str) -> list[ShopItem]:
        """Get items by type."""
        return self.db.query(ShopItem).filter(
            ShopItem.item_type == item_type
        ).all()
    
    def get_available(self) -> list[ShopItem]:
        """Get all available items."""
        from datetime import datetime
        now = datetime.now()
        
        return self.db.query(ShopItem).filter(
            (ShopItem.available_from == None) | (ShopItem.available_from <= now),
            (ShopItem.available_until == None) | (ShopItem.available_until >= now)
        ).all()

# ============================================
# INVENTORY REPOSITORY
# ============================================

class InventoryRepository(BaseRepository):
    model = UserInventory
    
    def get_user_inventory(self, user_id) -> list[UserInventory]:
        """Get user's inventory."""
        return self.db.query(UserInventory).filter(
            UserInventory.user_id == user_id
        ).all()
    
    def has_item(self, user_id, item_id) -> bool:
        """Check if user owns an item."""
        item = self.db.query(UserInventory).filter(
            UserInventory.user_id == user_id,
            UserInventory.item_id == item_id
        ).first()
        return item is not None
    
    def add_item(self, user_id, item_id) -> UserInventory:
        """Add item to user inventory."""
        existing = self.has_item(user_id, item_id)
        if existing:
            # Increment quantity
            existing.quantity += 1
            return self.update(existing)
        
        item = UserInventory(user_id=user_id, item_id=item_id)
        return self.create(item)

# ============================================
# TRANSACTION REPOSITORY
# ============================================

class TransactionRepository(BaseRepository):
    model = Transaction
    
    def create_transaction(
        self,
        user_id,
        transaction_type: str,
        amount: int,
        balance_after: int,
        description: str = None,
        meal_id = None,
        shop_item_id = None,
        metadata: dict = None
    ) -> Transaction:
        """Create a new transaction."""
        from .models import TransactionType
        
        transaction = Transaction(
            user_id=user_id,
            transaction_type=TransactionType(transaction_type),
            amount=amount,
            balance_after=balance_after,
            description=description,
            meal_id=meal_id,
            shop_item_id=shop_item_id,
            metadata=metadata
        )
        return self.create(transaction)
    
    def get_user_transactions(self, user_id, limit: int = 50) -> list[Transaction]:
        """Get user's recent transactions."""
        return self.db.query(Transaction).filter(
            Transaction.user_id == user_id
        ).order_by(Transaction.created_at.desc()).limit(limit).all()
