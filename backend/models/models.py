"""
Aura-Pet Backend - Database Models & ORM
SQLAlchemy Models for PostgreSQL
"""

from sqlalchemy import (
    Column, String, Integer, Boolean, DateTime, Text, 
    ForeignKey, Numeric, ARRAY, JSON, Enum, Index
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import uuid
import enum

Base = declarative_base()

# ============================================
# ENUMS
# ============================================

class PetSpecies(str, enum.Enum):
    RACCOON = "raccoon"
    CAT = "cat"
    DOG = "dog"
    BUNNY = "bunny"
    FOX = "fox"
    OWL = "owl"

class PetMood(str, enum.Enum):
    HAPPY = "happy"
    NEUTRAL = "neutral"
    SAD = "sad"
    EXCITED = "excited"
    SLEEPY = "sleepy"
    DIZZY = "dizzy"

class FoodCategory(str, enum.Enum):
    PROTEIN = "protein"
    CARB = "carb"
    VEGETABLE = "vegetable"
    FRUIT = "fruit"
    DESSERT = "dessert"
    DRINK = "drink"
    SNACK = "snack"

class SubscriptionTier(str, enum.Enum):
    FREE = "free"
    PREMIUM = "premium"
    PRO = "pro"

class ShopItemType(str, enum.Enum):
    HAT = "hat"
    GLASSES = "glasses"
    SCARF = "scarf"
    BACKGROUND = "background"
    PET_FOOD = "pet_food"
    EMOTION = "emotion"

class TransactionType(str, enum.Enum):
    MEAL_REWARD = "meal_reward"
    STREAK_BONUS = "streak_bonus"
    PURCHASE = "purchase"
    REFUND = "refund"
    SUBSCRIPTION = "subscription"

# ============================================
# USER MODEL
# ============================================

class User(Base):
    __tablename__ = "users"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    email = Column(String(255), unique=True, nullable=False, index=True)
    password_hash = Column(String(255), nullable=False)
    display_name = Column(String(100))
    avatar_url = Column(Text)
    
    # Subscription
    subscription_tier = Column(Enum(SubscriptionTier), default=SubscriptionTier.FREE)
    subscription_expires_at = Column(DateTime(timezone=True), nullable=True)
    stripe_customer_id = Column(String(255), nullable=True)
    
    # Virtual Currency
    bitecoins = Column(Integer, default=100)
    
    # Stats
    total_meals_logged = Column(Integer, default=0)
    current_streak = Column(Integer, default=0)
    longest_streak = Column(Integer, default=0)
    last_meal_at = Column(DateTime(timezone=True), nullable=True)
    
    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    deleted_at = Column(DateTime(timezone=True), nullable=True)
    
    # Relationships
    pets = relationship("Pet", back_populates="owner", cascade="all, delete-orphan")
    meals = relationship("Meal", back_populates="user", cascade="all, delete-orphan")
    water_logs = relationship("WaterLog", back_populates="user", cascade="all, delete-orphan")
    transactions = relationship("Transaction", back_populates="user", cascade="all, delete-orphan")
    inventory = relationship("UserInventory", back_populates="user", cascade="all, delete-orphan")
    
    def __repr__(self):
        return f"<User {self.email}>"
    
    @property
    def is_premium(self):
        if self.subscription_tier == SubscriptionTier.FREE:
            return False
        if self.subscription_expires_at and self.subscription_expires_at < func.now():
            return False
        return True

# ============================================
# PET MODEL
# ============================================

class Pet(Base):
    __tablename__ = "pets"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    
    # Identity
    name = Column(String(50), nullable=False)
    species = Column(Enum(PetSpecies), default=PetSpecies.RACCOON)
    nickname = Column(String(50))
    
    # 五维数值 (0-100)
    hunger = Column(Integer, default=50)
    joy = Column(Integer, default=50)
    vigor = Column(Integer, default=50)
    affinity = Column(Integer, default=0)
    evolution_xp = Column(Integer, default=0)
    
    # Evolution
    evolution_level = Column(Integer, default=1)
    
    # State
    current_mood = Column(Enum(PetMood), default=PetMood.NEUTRAL)
    is_sleeping = Column(Boolean, default=False)
    is_dizzy = Column(Boolean, default=False)
    
    # Position
    slot_index = Column(Integer, default=0)
    
    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    
    # Relationships
    owner = relationship("User", back_populates="pets")
    appearance = relationship("PetAppearance", back_populates="pet", uselist=False, cascade="all, delete-orphan")
    
    # Indexes
    __table_args__ = (
        Index("idx_pets_user", "user_id"),
    )
    
    def __repr__(self):
        return f"<Pet {self.name} (Lv.{self.evolution_level})>"

# ============================================
# PET APPEARANCE MODEL
# ============================================

class PetAppearance(Base):
    __tablename__ = "pet_appearances"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    pet_id = Column(UUID(as_uuid=True), ForeignKey("pets.id", ondelete="CASCADE"), nullable=False, unique=True)
    
    # Equipped items
    equipped_hat_id = Column(UUID(as_uuid=True), ForeignKey("shop_items.id"), nullable=True)
    equipped_glasses_id = Column(UUID(as_uuid=True), ForeignKey("shop_items.id"), nullable=True)
    equipped_scarf_id = Column(UUID(as_uuid=True), ForeignKey("shop_items.id"), nullable=True)
    equipped_background_id = Column(UUID(as_uuid=True), ForeignKey("shop_items.id"), nullable=True)
    
    # Colors
    primary_color = Column(String(7))  # Hex
    secondary_color = Column(String(7))
    
    # Timestamps
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    
    # Relationships
    pet = relationship("Pet", back_populates="appearance")
    equipped_hat = relationship("ShopItem", foreign_keys=[equipped_hat_id])
    equipped_glasses = relationship("ShopItem", foreign_keys=[equipped_glasses_id])
    equipped_scarf = relationship("ShopItem", foreign_keys=[equipped_scarf_id])
    equipped_background = relationship("ShopItem", foreign_keys=[equipped_background_id])

# ============================================
# MEAL MODEL
# ============================================

class Meal(Base):
    __tablename__ = "meals"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    
    # Food Info
    food_name = Column(String(255), nullable=False)
    food_category = Column(Enum(FoodCategory))
    estimated_calories = Column(Integer)
    estimated_protein = Column(Numeric(6, 2))
    estimated_carbs = Column(Numeric(6, 2))
    estimated_fat = Column(Numeric(6, 2))
    
    # AI Results
    vision_gpt4o_result = Column(JSON)
    vision_gemini_result = Column(JSON)
    vision_confidence_score = Column(Numeric(3, 2))
    vision_final_consensus = Column(JSON)
    
    # Image
    image_url = Column(Text)
    image_thumbnail_url = Column(Text)
    
    # Tags & Mood
    tags = Column(ARRAY(String))
    anxiety_relief_label = Column(String(100))
    anxiety_relief_emoji = Column(String(50))
    
    # Rewards
    coins_earned = Column(Integer, default=0)
    xp_earned = Column(Integer, default=0)
    
    # Timestamps
    logged_at = Column(DateTime(timezone=True), server_default=func.now())
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relationships
    user = relationship("User", back_populates="meals")
    
    # Indexes
    __table_args__ = (
        Index("idx_meals_user", "user_id"),
        Index("idx_meals_logged_at", "logged_at"),
    )
    
    def __repr__(self):
        return f"<Meal {self.food_name} ({self.estimated_calories}kcal)>"

# ============================================
# WATER LOG MODEL
# ============================================

class WaterLog(Base):
    __tablename__ = "water_logs"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    amount_ml = Column(Integer, nullable=False)
    logged_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relationships
    user = relationship("User", back_populates="water_logs")
    
    # Indexes
    __table_args__ = (
        Index("idx_water_user_date", "user_id", "logged_at"),
    )

# ============================================
# FASTING SESSION MODEL
# ============================================

class FastingSession(Base):
    __tablename__ = "fasting_sessions"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    
    started_at = Column(DateTime(timezone=True), nullable=False)
    ended_at = Column(DateTime(timezone=True), nullable=True)
    target_hours = Column(Integer, default=16)
    actual_hours = Column(Numeric(5, 2))
    completed = Column(Boolean, default=False)
    
    # Indexes
    __table_args__ = (
        Index("idx_fasting_user", "user_id"),
    )

# ============================================
# SHOP ITEM MODEL
# ============================================

class ShopItem(Base):
    __tablename__ = "shop_items"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    
    # Item Info
    item_key = Column(String(100), unique=True, nullable=False)
    name = Column(String(100), nullable=False)
    description = Column(Text)
    item_type = Column(Enum(ShopItemType), nullable=False)
    
    # Compatibility
    applicable_species = Column(ARRAY(String))
    evolution_level_required = Column(Integer, default=1)
    
    # Economy
    price_bitecoins = Column(Integer, nullable=False)
    is_limited = Column(Boolean, default=False)
    limited_quantity = Column(Integer, nullable=True)
    limited_remaining = Column(Integer, nullable=True)
    
    # Visual
    preview_image_url = Column(Text)
    layers = Column(JSON)  # For layered rendering
    
    # Timestamps
    available_from = Column(DateTime(timezone=True), nullable=True)
    available_until = Column(DateTime(timezone=True), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relationships
    purchasers = relationship("UserInventory", back_populates="item")
    
    def __repr__(self):
        return f"<ShopItem {self.name} ({self.price_bitecoins} coins)>"

# ============================================
# USER INVENTORY MODEL
# ============================================

class UserInventory(Base):
    __tablename__ = "user_inventory"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    item_id = Column(UUID(as_uuid=True), ForeignKey("shop_items.id"), nullable=False)
    quantity = Column(Integer, default=1)
    purchased_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relationships
    user = relationship("User", back_populates="inventory")
    item = relationship("ShopItem", back_populates="purchasers")
    
    # Unique constraint
    __table_args__ = (
        Index("idx_inventory_user", "user_id"),
    )

# ============================================
# TRANSACTION MODEL
# ============================================

class Transaction(Base):
    __tablename__ = "transactions"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    
    transaction_type = Column(Enum(TransactionType), nullable=False)
    amount = Column(Integer, nullable=False)  # Positive for income, negative for expense
    balance_after = Column(Integer, nullable=False)
    
    # References
    meal_id = Column(UUID(as_uuid=True), ForeignKey("meals.id"), nullable=True)
    shop_item_id = Column(UUID(as_uuid=True), ForeignKey("shop_items.id"), nullable=True)
    
    description = Column(String(255))
    metadata = Column(JSON)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relationships
    user = relationship("User", back_populates="transactions")
    
    # Indexes
    __table_args__ = (
        Index("idx_transactions_user", "user_id"),
        Index("idx_transactions_type", "transaction_type"),
    )
    
    def __repr__(self):
        return f"<Transaction {self.transaction_type} ({self.amount:+d})>"

# ============================================
# DAILY STATS MODEL
# ============================================

class DailyStat(Base):
    __tablename__ = "daily_stats"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    stat_date = Column(DateTime(timezone=True), nullable=False)
    
    # Meals
    meals_count = Column(Integer, default=0)
    total_calories = Column(Integer, default=0)
    nutrition_balance_score = Column(Numeric(5, 2))
    
    # Water
    water_ml = Column(Integer, default=0)
    water_goal_achieved = Column(Boolean, default=False)
    
    # Streak
    streak_continued = Column(Boolean, default=False)
    
    # Pet Stats Snapshot
    pet_hunger_avg = Column(Integer, nullable=True)
    pet_joy_avg = Column(Integer, nullable=True)
    pet_vigor_avg = Column(Integer, nullable=True)
    
    # Unique constraint
    __table_args__ = (
        Index("idx_daily_stats_user", "user_id", "stat_date", unique=True),
    )

# ============================================
# CONVERSATION CORPUS MODEL
# ============================================

class ConversationEntry(Base):
    __tablename__ = "conversation_corpus"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    
    # Trigger conditions
    food_category = Column(Enum(FoodCategory), nullable=True)
    anxiety_level = Column(String(20))  # 'low', 'medium', 'high'
    pet_mood = Column(Enum(PetMood), nullable=True)
    time_of_day = Column(String(20))  # 'morning', 'noon', 'afternoon', 'evening', 'night'
    
    # Persona & Response
    persona_action = Column(String(255))  # "小浣熊开心地转圈"
    dialogue_text = Column(Text, nullable=False)
    dialogue_emoji = Column(String(50))
    
    # Animation hint
    animation_trigger = Column(String(100))  # "spin", "jump", "bounce", "sleepy"
    
    frequency_weight = Column(Integer, default=1)
    
    def __repr__(self):
        return f"<ConversationEntry {self.dialogue_text[:50]}>"
