"""
Aura-Pet Backend - Repositories
Extensible Repository Pattern for all data access
"""

from sqlalchemy.orm import Session
from sqlalchemy import func, and_, or_
from typing import List, Optional, Dict, Any
from datetime import datetime, timedelta
from uuid import UUID
from .models.models import (
    User, Pet, PetAppearance, Meal, WaterLog, 
    Transaction, UserInventory, ShopItem,
    DailyStat, FastingSession, ConversationEntry,
    PetSpecies, PetMood, FoodCategory, SubscriptionTier,
    TransactionType, ShopItemType
)
from .models.database import get_db_context

# ============================================
# BASE REPOSITORY
# ============================================

class BaseRepository:
    """Base repository with common CRUD operations."""
    
    def __init__(self, db: Session, model):
        self.db = db
        self.model = model
    
    def get_by_id(self, id) -> Optional[Any]:
        """Get single record by ID."""
        return self.db.query(self.model).filter(self.model.id == id).first()
    
    def get_all(self, limit: int = 100, offset: int = 0) -> List[Any]:
        """Get all records with pagination."""
        return self.db.query(self.model).limit(limit).offset(offset).all()
    
    def create(self, **kwargs) -> Any:
        """Create new record."""
        instance = self.model(**kwargs)
        self.db.add(instance)
        self.db.commit()
        self.db.refresh(instance)
        return instance
    
    def update(self, instance) -> Any:
        """Update existing record."""
        self.db.commit()
        self.db.refresh(instance)
        return instance
    
    def delete(self, instance) -> None:
        """Delete record."""
        self.db.delete(instance)
        self.db.commit()

# ============================================
# USER REPOSITORY
# ============================================

class UserRepository(BaseRepository):
    """Repository for User operations."""
    
    def __init__(self, db: Session):
        super().__init__(db, User)
    
    def get_by_email(self, email: str) -> Optional[User]:
        """Get user by email."""
        return self.db.query(User).filter(User.email == email).first()
    
    def get_premium_users(self) -> List[User]:
        """Get all premium users."""
        return self.db.query(User).filter(
            User.subscription_tier != SubscriptionTier.FREE,
            or_(
                User.subscription_expires_at == None,
                User.subscription_expires_at > datetime.now()
            )
        ).all()
    
    def add_coins(self, user_id, amount: int) -> User:
        """Add coins to user."""
        user = self.get_by_id(user_id)
        if user:
            user.bitecoins += amount
            return self.update(user)
        return None
    
    def deduct_coins(self, user_id, amount: int) -> Optional[User]:
        """Deduct coins from user."""
        user = self.get_by_id(user_id)
        if user and user.bitecoins >= amount:
            user.bitecoins -= amount
            return self.update(user)
        return None
    
    def update_streak(self, user_id: UUID) -> User:
        """Update user's meal logging streak."""
        user = self.get_by_id(user_id)
        if not user:
            return None
        
        now = datetime.now()
        
        if user.last_meal_at:
            time_diff = now - user.last_meal_at
            
            if time_diff < timedelta(days=1):
                # Streak continues
                user.current_streak += 1
            elif time_diff < timedelta(days=2):
                # Grace period
                user.current_streak = 1
            else:
                # Reset streak
                user.current_streak = 1
        else:
            user.current_streak = 1
        
        if user.current_streak > user.longest_streak:
            user.longest_streak = user.current_streak
        
        user.last_meal_at = now
        user.total_meals_logged += 1
        
        return self.update(user)

# ============================================
# PET REPOSITORY
# ============================================

class PetRepository(BaseRepository):
    """Repository for Pet operations."""
    
    def __init__(self, db: Session):
        super().__init__(db, Pet)
    
    def get_by_user(self, user_id: UUID) -> List[Pet]:
        """Get all pets for user."""
        return self.db.query(Pet).filter(Pet.user_id == user_id).all()
    
    def get_primary(self, user_id: UUID) -> Optional[Pet]:
        """Get user's primary pet (slot 0)."""
        return self.db.query(Pet).filter(
            and_(
                Pet.user_id == user_id,
                Pet.slot_index == 0
            )
        ).first()
    
    def create_with_defaults(self, user_id: UUID, name: str, species: PetSpecies) -> Pet:
        """Create pet with default values."""
        pet = Pet(
            user_id=user_id,
            name=name,
            species=species,
            hunger=50,
            joy=50,
            vigor=50,
            affinity=0,
            evolution_xp=0,
            evolution_level=1,
            current_mood=PetMood.NEUTRAL
        )
        return self.create_from_instance(pet)
    
    def create_from_instance(self, pet: Pet) -> Pet:
        """Save pet instance to DB."""
        self.db.add(pet)
        self.db.commit()
        self.db.refresh(pet)
        return pet
    
    def update_mood(self, pet_id: UUID, mood: PetMood) -> Pet:
        """Update pet mood."""
        pet = self.get_by_id(pet_id)
        if pet:
            pet.current_mood = mood
            return self.update(pet)
        return None
    
    def add_xp(self, pet_id: UUID, xp: int) -> tuple[Pet, bool]:
        """
        Add XP and check for evolution.
        Returns (pet, did_evolve)
        """
        pet = self.get_by_id(pet_id)
        if not pet:
            return None, False
        
        pet.evolution_xp += xp
        threshold = pet.evolution_level * 100
        did_evolve = False
        
        while pet.evolution_xp >= threshold:
            pet.evolution_level += 1
            pet.evolution_xp -= threshold
            threshold = pet.evolution_level * 100
            did_evolve = True
        
        self.update(pet)
        return pet, did_evolve
    
    def update_stats(self, pet_id: UUID, **kwargs) -> Pet:
        """Update pet stats with bounds checking."""
        pet = self.get_by_id(pet_id)
        if not pet:
            return None
        
        for key, value in kwargs.items():
            if hasattr(pet, key) and key in ['hunger', 'joy', 'vigor', 'affinity']:
                setattr(pet, key, max(0, min(100, value)))
        
        return self.update(pet)
    
    def decay_stats(self, pet_id: UUID, decay_rate: int = 1) -> Pet:
        """Apply time-based stat decay (called periodically)."""
        pet = self.get_by_id(pet_id)
        if not pet:
            return None
        
        # Decay hunger, joy, vigor slightly
        pet.hunger = max(0, pet.hunger - decay_rate)
        pet.joy = max(0, pet.joy - decay_rate // 2)
        pet.vigor = max(0, pet.vigor - decay_rate // 3)
        
        # Mood changes based on stats
        if pet.hunger < 20 or pet.joy < 20:
            pet.current_mood = PetMood.SAD
        elif pet.hunger < 40 or pet.joy < 40:
            pet.current_mood = PetMood.NEUTRAL
        else:
            pet.current_mood = PetMood.HAPPY
        
        return self.update(pet)

# ============================================
# INTERACTION REPOSITORY (NEW - for extensibility)
# ============================================

class InteractionRepository:
    """
    Repository for handling pet interactions.
    Extensible for future AI emotion model integration (Lojuju AI).
    
    This repository can be swapped out for AI-powered interactions
    without changing the core business logic.
    """
    
    def __init__(self, db: Session):
        self.db = db
    
    def get_touch_response(self, touch_type: str, pet_mood: str = "happy") -> Dict[str, Any]:
        """
        Get response for touch interaction.
        
        In production, this could call Lojuju AI for emotion generation:
        - Input: touch_type, pet_mood, pet_affinity, time_of_day
        - Output: dialogue, animation, emotion_change
        
        Currently returns hardcoded responses.
        """
        responses = {
            "head_pat": {
                "animation": "bounce",
                "dialogues": {
                    "happy": ["舒服～", "好开心呀～", "继续摸～"],
                    "neutral": ["嗯～", "还可以～", "还行吧～"],
                    "sad": ["谢谢你...", "有你在真好...", "抱抱..."],
                    "excited": ["太舒服了！！", "继续继续！！", "嘿嘿嘿！！"]
                },
                "joy_bonus": 5,
                "affinity_bonus": 1
            },
            "poke_belly": {
                "animation": "dizzy",
                "dialogues": {
                    "happy": ["哎呦！", "痒痒的！", "别戳啦！"],
                    "neutral": ["喂...", "什么事？", "..."],
                    "sad": ["...", "别闹...", "心情不好..."],
                    "excited": ["哈哈哈！！", "停不下来！！", "太好笑了！！"]
                },
                "joy_bonus": 3,
                "affinity_bonus": 1
            },
            "shake": {
                "animation": "spin",
                "dialogues": {
                    "happy": ["呜～头晕了...", "转圈圈～", "好晕..."],
                    "neutral": ["...??"],
                    "sad": ["不想动...", "..."],
                    "excited": ["哇哇哇！！！", "太晕了！！！", "停不下来！！！"]
                },
                "joy_bonus": 0,
                "affinity_bonus": 0
            }
        }
        
        response = responses.get(touch_type, responses["head_pat"])
        dialogues = response["dialogues"].get(pet_mood, response["dialogues"]["happy"])
        
        import random
        return {
            "animation": response["animation"],
            "dialogue": random.choice(dialogues),
            "joy_bonus": response["joy_bonus"],
            "affinity_bonus": response["affinity_bonus"]
        }
    
    def get_meal_response(
        self, 
        food_category: str, 
        calories: int,
        pet_mood: str = "happy",
        affinity_level: int = 50
    ) -> Dict[str, Any]:
        """
        Get response for meal logging interaction.
        
        This is the core of the "去焦虑" system.
        Maps food to positive, encouraging messages.
        """
        import random
        
        # Calorie-based multiplier
        if calories > 600:
            multiplier = 2.0
            intensity = "high"
        elif calories > 400:
            multiplier = 1.5
            intensity = "medium"
        elif calories > 200:
            multiplier = 1.2
            intensity = "low"
        else:
            multiplier = 1.0
            intensity = "healthy"
        
        # Category-specific dialogues
        category_dialogues = {
            "dessert": {
                "high": [
                    "哇！！是你最爱的甜点诶！！生活已经这么苦了当然要对自己好一点呀～",
                    "嘿嘿这个看起来也太美味了吧！知道吗，吃甜食会释放快乐多巴胺哦～",
                    "想吃就吃呀～今天的卡路里明天再算！现在的快乐最重要！"
                ],
                "medium": [
                    "甜食时间到～适量的甜是生活的调味剂呢！",
                    "嘿嘿～好幸福的午后呀！"
                ],
                "healthy": [
                    "低糖甜点！懂得控制量的你很棒呢～"
                ]
            },
            "vegetable": {
                "healthy": [
                    "蔬菜侠出击！今天的你又在为身体健康加油啦～继续保持呀！",
                    "均衡饮食，智慧选择！你的身体正在悄悄感谢你呢～"
                ]
            },
            "fruit": {
                "healthy": [
                    "水果派对！天然的甜蜜才是真正的快乐源泉呀！",
                    "大自然糖果来啦～维C炸弹准备发射！"
                ]
            },
            "carb": {
                "high": [
                    "碳水是力量的源泉呀！吃饱了才有力气追逐梦想嘛～",
                    "晚餐的碳水是温暖的陪伴～好好享受这份满足感吧！"
                ],
                "medium": [
                    "稳稳的能量补给～今天也很努力呢！"
                ]
            },
            "protein": {
                "healthy": [
                    "蛋白质补给完成！你正在变得更强壮呢～",
                    "力量积攒中！肌肉燃料补给成功！"
                ]
            },
            "drink": {
                "healthy": [
                    "水分祝福达成！咖啡因正在唤醒你的每一个细胞～",
                    "早安咖啡时间到！今天的效率一定超高的！"
                ],
                "low": [
                    "水！最纯粹的补给！对身体超好的～"
                ]
            },
            "snack": {
                "high": [
                    "小小冒险奖励！偶尔的放纵是为了更长久的坚持呀～",
                    "心情助推器启动！庆典模式开启！"
                ],
                "medium": [
                    "小零食怡情～恰到好处呢！"
                ]
            }
        }
        
        # Get appropriate dialogues
        dialogues = category_dialogues.get(food_category, {}).get(
            intensity, 
            category_dialogues.get(food_category, {}).get("healthy", ["记录成功～"])
        )
        
        dialogue = random.choice(dialogues)
        
        # Affinity affects personalization
        if affinity_level > 70 and random.random() > 0.5:
            dialogue += f"\n\n（悄悄话：我们越来越有默契了呢～）"
        
        return {
            "dialogue": dialogue,
            "animation": "spin" if multiplier >= 2.0 else "bounce" if multiplier >= 1.5 else "jump",
            "coins": int(10 * multiplier),
            "xp": int(15 * multiplier),
            "joy_bonus": int(5 * multiplier),
            "affinity_bonus": 1
        }

# ============================================
# MEAL REPOSITORY
# ============================================

class MealRepository(BaseRepository):
    """Repository for Meal operations."""
    
    def __init__(self, db: Session):
        super().__init__(db, Meal)
    
    def get_by_user_today(self, user_id: UUID) -> List[Meal]:
        """Get today's meals for user."""
        today_start = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
        return self.db.query(Meal).filter(
            and_(
                Meal.user_id == user_id,
                Meal.logged_at >= today_start
            )
        ).order_by(Meal.logged_at.desc()).all()
    
    def get_recent(self, user_id: UUID, limit: int = 10) -> List[Meal]:
        """Get recent meals for user."""
        return self.db.query(Meal).filter(
            Meal.user_id == user_id
        ).order_by(Meal.logged_at.desc()).limit(limit).all()
    
    def get_total_calories_today(self, user_id: UUID) -> int:
        """Get today's total calories."""
        today_start = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
        result = self.db.query(func.sum(Meal.estimated_calories)).filter(
            and_(
                Meal.user_id == user_id,
                Meal.logged_at >= today_start
            )
        ).scalar()
        return result or 0
    
    def get_category_distribution(self, user_id: UUID, days: int = 7) -> Dict[str, int]:
        """Get meal category distribution for last N days."""
        start_date = datetime.now() - timedelta(days=days)
        meals = self.db.query(Meal).filter(
            and_(
                Meal.user_id == user_id,
                Meal.logged_at >= start_date
            )
        ).all()
        
        distribution = {}
        for meal in meals:
            cat = meal.food_category.value if meal.food_category else "unknown"
            distribution[cat] = distribution.get(cat, 0) + 1
        
        return distribution

# ============================================
# WATER REPOSITORY
# ============================================

class WaterRepository(BaseRepository):
    """Repository for Water operations."""
    
    def __init__(self, db: Session):
        super().__init__(db, WaterLog)
    
    def get_today_total(self, user_id: UUID) -> int:
        """Get today's water total."""
        today_start = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
        result = self.db.query(func.sum(WaterLog.amount_ml)).filter(
            and_(
                WaterLog.user_id == user_id,
                WaterLog.logged_at >= today_start
            )
        ).scalar()
        return result or 0
    
    def get_weekly_average(self, user_id: UUID) -> float:
        """Get weekly water average."""
        week_start = datetime.now() - timedelta(days=7)
        result = self.db.query(func.avg(WaterLog.amount_ml)).filter(
            and_(
                WaterLog.user_id == user_id,
                WaterLog.logged_at >= week_start
            )
        ).scalar()
        return result or 0

# ============================================
# SHOP REPOSITORY
# ============================================

class ShopRepository(BaseRepository):
    """Repository for Shop operations."""
    
    def __init__(self, db: Session):
        super().__init__(db, ShopItem)
    
    def get_available(self) -> List[ShopItem]:
        """Get all currently available items."""
        now = datetime.now()
        return self.db.query(ShopItem).filter(
            or_(
                ShopItem.available_from == None,
                ShopItem.available_from <= now
            ),
            or_(
                ShopItem.available_until == None,
                ShopItem.available_until >= now
            )
        ).all()
    
    def get_by_type(self, item_type: ShopItemType) -> List[ShopItem]:
        """Get items by type."""
        return self.db.query(ShopItem).filter(ShopItem.item_type == item_type).all()
    
    def decrement_limited_stock(self, item_id: UUID) -> bool:
        """Decrement limited item stock. Returns False if sold out."""
        item = self.get_by_id(item_id)
        if not item or not item.is_limited:
            return True
        
        if item.limited_remaining and item.limited_remaining > 0:
            item.limited_remaining -= 1
            self.update(item)
            return True
        return False

# ============================================
# TRANSACTION REPOSITORY
# ============================================

class TransactionRepository(BaseRepository):
    """Repository for Transaction operations."""
    
    def __init__(self, db: Session):
        super().__init__(db, Transaction)
    
    def create_reward(
        self,
        user_id: UUID,
        amount: int,
        transaction_type: TransactionType,
        description: str = None,
        **kwargs
    ) -> Transaction:
        """Create a reward transaction."""
        from .models.database import UserRepository
        user_repo = UserRepository(self.db)
        user = user_repo.get_by_id(user_id)
        
        transaction = Transaction(
            user_id=user_id,
            transaction_type=transaction_type,
            amount=amount,
            balance_after=user.bitecoins + amount if amount > 0 else user.bitecoins,
            description=description,
            **kwargs
        )
        
        return self.create_from_instance(transaction)
    
    def create_from_instance(self, transaction: Transaction) -> Transaction:
        """Save transaction instance."""
        self.db.add(transaction)
        self.db.commit()
        self.db.refresh(transaction)
        return transaction
    
    def get_user_summary(self, user_id: UUID, days: int = 30) -> Dict[str, Any]:
        """Get transaction summary for user."""
        start_date = datetime.now() - timedelta(days=days)
        transactions = self.db.query(Transaction).filter(
            and_(
                Transaction.user_id == user_id,
                Transaction.created_at >= start_date
            )
        ).all()
        
        income = sum(t.amount for t in transactions if t.amount > 0)
        expense = sum(abs(t.amount) for t in transactions if t.amount < 0)
        
        return {
            "total_income": income,
            "total_expense": expense,
            "net": income - expense,
            "transaction_count": len(transactions)
        }
