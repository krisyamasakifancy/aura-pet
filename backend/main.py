"""
Aura-Pet Backend - Main FastAPI Application
Complete REST API with all endpoints
"""

from fastapi import FastAPI, HTTPException, Depends, UploadFile, File, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime, timedelta
from uuid import UUID, uuid4
import asyncio
import random

# ============================================
# APP INITIALIZATION
# ============================================

app = FastAPI(
    title="Aura-Pet API",
    description="智能宠物养成 - BitePal Parity",
    version="2.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ============================================
# IN-MEMORY STORE (Demo Mode)
# ============================================

class DemoStore:
    """In-memory store for demo mode without database."""
    
    def __init__(self):
        self.users = {
            "demo_user": {
                "id": "demo_user",
                "email": "demo@aura-pet.com",
                "display_name": "Demo User",
                "bitecoins": 150,
                "subscription_tier": "free",
                "current_streak": 5,
                "total_meals_logged": 23,
                "password_hash": "demo123"
            }
        }
        
        self.pets = {
            "demo_user": {
                "id": "pet_001",
                "name": "小浣熊",
                "species": "raccoon",
                "hunger": 70,
                "joy": 80,
                "vigor": 65,
                "affinity": 45,
                "evolution_xp": 120,
                "evolution_level": 2,
                "current_mood": "happy",
                "is_sleeping": False,
                "is_dizzy": False
            }
        }
        
        self.meals = []
        self.water_today = 1200
        self.inventory = {}
        self.transactions = []
    
    def get_user(self):
        return self.users["demo_user"]
    
    def get_pet(self):
        return self.pets["demo_user"]
    
    def update_pet(self, updates):
        pet = self.get_pet()
        pet.update(updates)
        return pet

store = DemoStore()

# ============================================
# PYDANTIC MODELS
# ============================================

class UserResponse(BaseModel):
    id: str
    email: str
    display_name: str
    bitecoins: int
    subscription_tier: str
    current_streak: int
    total_meals_logged: int

class PetStateResponse(BaseModel):
    id: str
    name: str
    species: str
    hunger: int
    joy: int
    vigor: int
    affinity: int
    evolution_xp: int
    evolution_level: int
    current_mood: str
    is_sleeping: bool
    is_dizzy: bool

class MealLogRequest(BaseModel):
    food_name: str
    calories: int
    category: str
    anxiety_relief_label: str
    anxiety_relief_emoji: str

class MealLogResponse(BaseModel):
    id: str
    food_name: str
    calories: int
    category: str
    anxiety_relief_label: str
    anxiety_relief_emoji: str
    coins_earned: int
    xp_earned: int
    pet_state: PetStateResponse
    dialogue: str
    animation_trigger: str

class FoodAnalysisResponse(BaseModel):
    success: bool
    food_name: str
    calories: int
    category: str
    anxiety_relief_label: str
    anxiety_relief_emoji: str
    confidence: float
    colors_detected: List[str]

class TouchRequest(BaseModel):
    touch_type: str

class TouchResponse(BaseModel):
    animation_trigger: str
    dialogue: str
    coins_earned: int

class WaterRequest(BaseModel):
    amount_ml: int

class WaterResponse(BaseModel):
    success: bool
    amount_ml: int
    today_total: int
    goal_achieved: bool

class ShopItemResponse(BaseModel):
    id: str
    item_key: str
    name: str
    description: str
    item_type: str
    price_bitecoins: int

class PurchaseRequest(BaseModel):
    item_id: str

class PurchaseResponse(BaseModel):
    success: bool
    new_balance: int
    item_id: str
    message: str

class DailyStatsResponse(BaseModel):
    date: str
    meals_count: int
    total_calories: int
    coins_earned_today: int
    water_ml: int
    water_goal: int
    streak: int
    pet_state: PetStateResponse

class AuthRequest(BaseModel):
    email: str
    password: str

class AuthResponse(BaseModel):
    access_token: str
    token_type: str
    user: UserResponse

# ============================================
# HELPER FUNCTIONS
# ============================================

def calculate_rewards(calories: int, streak: int):
    """Calculate rewards based on calories and streak."""
    base_coins = 10
    base_xp = 15
    
    # Calorie multiplier (de-anxiety logic)
    if calories > 600:
        multiplier = 2.0
    elif calories > 400:
        multiplier = 1.5
    elif calories > 200:
        multiplier = 1.2
    else:
        multiplier = 1.0
    
    coins = int(base_coins * multiplier)
    xp = int(base_xp * multiplier)
    
    # Streak bonus
    if streak > 0:
        coins += 5
        xp += 5
    
    return {"coins": coins, "xp": xp, "multiplier": multiplier}

def generate_dialogue(category: str, calories: int):
    """Generate dialogue based on food category."""
    dialogues = {
        "dessert": [
            "哇！！是你最爱的甜点诶！！生活已经这么苦了当然要对自己好一点呀～",
            "嘿嘿这个看起来也太美味了吧！知道吗，吃甜食会释放快乐多巴胺哦～",
            "想吃就吃呀～今天的卡路里明天再算！现在的快乐最重要！"
        ],
        "vegetable": [
            "蔬菜侠出击！今天的你又在为身体健康加油啦～继续保持呀！",
            "均衡饮食，智慧选择！你的身体正在悄悄感谢你呢～"
        ],
        "fruit": [
            "水果派对！天然的甜蜜才是真正的快乐源泉呀！",
            "大自然糖果来啦～维C炸弹准备发射！"
        ],
        "protein": [
            "蛋白质补给完成！你正在变得更强壮呢～",
            "力量积攒中！肌肉燃料补给成功！"
        ],
        "carb": [
            "碳水是力量的源泉呀！吃饱了才有力气追逐梦想嘛～",
            "晚餐的碳水是温暖的陪伴～好好享受这份满足感吧！"
        ],
        "drink": [
            "水分祝福达成！咖啡因正在唤醒你的每一个细胞～",
            "早安咖啡时间到！今天的效率一定超高的！"
        ],
        "snack": [
            "小小冒险奖励！偶尔的放纵是为了更长久的坚持呀～",
            "心情助推器启动！庆典模式开启！"
        ]
    }
    
    category_dialogues = dialogues.get(category, dialogues["snack"])
    return random.choice(category_dialogues)

def get_animation_for_reward(multiplier: float):
    """Get animation trigger based on reward multiplier."""
    if multiplier >= 2.0:
        return "spin"
    elif multiplier >= 1.5:
        return "bounce"
    elif multiplier >= 1.2:
        return "jump"
    return "idle"

# ============================================
# API ENDPOINTS
# ============================================

@app.get("/")
async def root():
    return {
        "name": "Aura-Pet API",
        "version": "2.0.0",
        "status": "running"
    }

@app.get("/health")
async def health_check():
    return {"status": "healthy", "timestamp": datetime.now().isoformat()}

# ----------------------------------------
# AUTH ENDPOINTS
# ----------------------------------------

@app.post("/api/v1/auth/login", response_model=AuthResponse)
async def login(request: AuthRequest):
    """
    User login endpoint.
    Returns access token and user info.
    """
    # Demo mode: accept demo credentials
    if request.email == "demo@aura-pet.com" and request.password == "demo123":
        user = store.get_user()
        return AuthResponse(
            access_token="demo_token_" + str(uuid4()),
            token_type="bearer",
            user=UserResponse(**user)
        )
    
    raise HTTPException(status_code=401, detail="Invalid credentials")

@app.post("/api/v1/auth/register", response_model=AuthResponse)
async def register(request: AuthRequest):
    """User registration endpoint."""
    # Demo mode: return demo user
    return AuthResponse(
        access_token="demo_token_" + str(uuid4()),
        token_type="bearer",
        user=UserResponse(**store.get_user())
    )

# ----------------------------------------
# USER ENDPOINTS
# ----------------------------------------

@app.get("/api/v1/user/me", response_model=UserResponse)
async def get_current_user():
    """Get current user information."""
    return UserResponse(**store.get_user())

@app.post("/api/v1/user/coins/add")
async def add_coins(amount: int):
    """Add coins to user balance (admin/testing)."""
    user = store.get_user()
    user["bitecoins"] += amount
    return {"success": True, "new_balance": user["bitecoins"]}

# ----------------------------------------
# PET ENDPOINTS
# ----------------------------------------

@app.get("/api/v1/pet", response_model=PetStateResponse)
async def get_pet():
    """Get current pet state."""
    return PetStateResponse(**store.get_pet())

@app.patch("/api/v1/pet/state")
async def update_pet_state(mood: Optional[str] = None):
    """Update pet state."""
    updates = {}
    if mood:
        updates["current_mood"] = mood
    pet = store.update_pet(updates)
    return {"success": True, "pet": pet}

@app.patch("/api/v1/pet/stats")
async def update_pet_stats(
    hunger: Optional[int] = None,
    joy: Optional[int] = None,
    vigor: Optional[int] = None,
    affinity: Optional[int] = None
):
    """Update pet stats."""
    updates = {}
    if hunger is not None:
        updates["hunger"] = max(0, min(100, hunger))
    if joy is not None:
        updates["joy"] = max(0, min(100, joy))
    if vigor is not None:
        updates["vigor"] = max(0, min(100, vigor))
    if affinity is not None:
        updates["affinity"] = max(0, min(100, affinity))
    
    pet = store.update_pet(updates)
    return {"success": True, "pet": pet}

# ----------------------------------------
# MEAL ENDPOINTS
# ----------------------------------------

@app.post("/api/v1/meals", response_model=MealLogResponse)
async def log_meal(request: MealLogRequest):
    """
    Log a meal and trigger Quad-Agent coordination.
    
    Flow:
    1. Vision Agent (pre-processed): Get food info
    2. Logic Agent: Calculate rewards
    3. Persona Agent: Generate dialogue
    4. Animator Agent: Return animation
    """
    user = store.get_user()
    pet = store.get_pet()
    
    # 1. Calculate rewards (Logic Agent)
    rewards = calculate_rewards(request.calories, user["current_streak"])
    
    # 2. Update user
    user["bitecoins"] += rewards["coins"]
    user["current_streak"] += 1
    user["total_meals_logged"] += 1
    
    # 3. Update pet
    pet["joy"] = min(100, pet["joy"] + rewards["coins"] // 2)
    pet["affinity"] = min(100, pet["affinity"] + 1)
    pet["evolution_xp"] += rewards["xp"]
    
    # Check evolution
    if pet["evolution_xp"] >= pet["evolution_level"] * 100:
        pet["evolution_level"] += 1
        pet["evolution_xp"] = pet["evolution_xp"] - pet["evolution_level"] * 100
    
    # Set mood based on multiplier
    if rewards["multiplier"] >= 2.0:
        pet["current_mood"] = "excited"
    elif rewards["multiplier"] >= 1.5:
        pet["current_mood"] = "happy"
    
    # 4. Generate dialogue (Persona Agent)
    dialogue = generate_dialogue(request.category, request.calories)
    
    # 5. Get animation (Animator Agent)
    animation = get_animation_for_reward(rewards["multiplier"])
    
    # Save meal
    meal_id = str(uuid4())
    store.meals.append({
        "id": meal_id,
        "food_name": request.food_name,
        "calories": request.calories,
        "category": request.category,
        "coins_earned": rewards["coins"],
        "xp_earned": rewards["xp"],
        "logged_at": datetime.now().isoformat()
    })
    
    return MealLogResponse(
        id=meal_id,
        food_name=request.food_name,
        calories=request.calories,
        category=request.category,
        anxiety_relief_label=request.anxiety_relief_label,
        anxiety_relief_emoji=request.anxiety_relief_emoji,
        coins_earned=rewards["coins"],
        xp_earned=rewards["xp"],
        pet_state=PetStateResponse(**pet),
        dialogue=dialogue,
        animation_trigger=animation
    )

@app.post("/api/v1/meals/analyze")
async def analyze_food_image(file: UploadFile = File(...)):
    """
    Analyze food image using AI (Vision Agent).
    
    In production, this would:
    1. Upload image to storage
    2. Call GPT-4o Vision API
    3. Call Gemini Vision API
    4. Cross-validate results
    5. Generate anxiety-relief label
    """
    # Simulate AI processing
    await asyncio.sleep(1.5)
    
    # Mock results based on random selection
    foods = [
        {"name": "芝士蛋糕", "calories": 420, "category": "dessert", 
         "label": "灵魂充电时间 ⚡", "emoji": "🍰", 
         "colors": ["#F5DEB3", "#FFD700", "#8B4513"]},
        {"name": "蔬菜沙拉", "calories": 180, "category": "vegetable",
         "label": "绿色能量满格 🌿", "emoji": "🥗",
         "colors": ["#90EE90", "#228B22", "#006400"]},
        {"name": "巧克力", "calories": 550, "category": "dessert",
         "label": "快乐因子注入中 💫", "emoji": "🍫",
         "colors": ["#8B4513", "#D2691E", "#FFD700"]},
        {"name": "水果拼盘", "calories": 150, "category": "fruit",
         "label": "大自然糖果 🍬", "emoji": "🍎",
         "colors": ["#FF6347", "#FFD700", "#FFA500"]},
        {"name": "披萨", "calories": 680, "category": "carb",
         "label": "尊享犒劳时刻 👑", "emoji": "🍕",
         "colors": ["#FFD700", "#FF6347", "#8B4513"]},
    ]
    
    result = random.choice(foods)
    
    return FoodAnalysisResponse(
        success=True,
        food_name=result["name"],
        calories=result["calories"],
        category=result["category"],
        anxiety_relief_label=result["label"],
        anxiety_relief_emoji=result["emoji"],
        confidence=0.92,
        colors_detected=result["colors"]
    )

@app.get("/api/v1/meals/history")
async def get_meal_history(limit: int = 10):
    """Get meal history."""
    meals = store.meals[-limit:][::-1]
    return {"meals": meals, "count": len(meals)}

# ----------------------------------------
# INTERACTION ENDPOINTS
# ----------------------------------------

@app.post("/api/v1/interactions/touch", response_model=TouchResponse)
async def touch_interaction(request: TouchRequest):
    """
    Handle touch interactions with the pet.
    
    Animations:
    - head_pat: bounce
    - poke_belly: dizzy
    - shake: spin
    """
    user = store.get_user()
    pet = store.get_pet()
    
    interactions = {
        "head_pat": {
            "animation": "bounce",
            "dialogues": ["舒服～", "好开心呀～", "继续摸～", "嘿嘿～"],
            "coins": 2
        },
        "poke_belly": {
            "animation": "dizzy",
            "dialogues": ["哎呦！", "别戳我肚子啦～", "痒痒的！"],
            "coins": 2
        },
        "shake": {
            "animation": "spin",
            "dialogues": ["呜～头晕了...", "转晕了..."],
            "coins": 0
        }
    }
    
    data = interactions.get(request.touch_type, interactions["head_pat"])
    dialogue = random.choice(data["dialogues"])
    
    # Update pet
    if request.touch_type == "shake":
        pet["is_dizzy"] = True
        pet["current_mood"] = "dizzy"
    else:
        pet["joy"] = min(100, pet["joy"] + 5)
        pet["affinity"] = min(100, pet["affinity"] + 1)
    
    # Update coins
    if data["coins"] > 0:
        user["bitecoins"] += data["coins"]
    
    return TouchResponse(
        animation_trigger=data["animation"],
        dialogue=dialogue,
        coins_earned=data["coins"]
    )

# ----------------------------------------
# WATER TRACKING ENDPOINTS
# ----------------------------------------

@app.post("/api/v1/water", response_model=WaterResponse)
async def log_water(request: WaterRequest):
    """Log water intake."""
    store.water_today += request.amount_ml
    
    goal_achieved = store.water_today >= 2000
    
    if goal_achieved and store.water_today - request.amount_ml < 2000:
        # Just achieved goal
        pet = store.get_pet()
        pet["current_mood"] = "excited"
    
    return WaterResponse(
        success=True,
        amount_ml=request.amount_ml,
        today_total=store.water_today,
        goal_achieved=goal_achieved
    )

@app.get("/api/v1/water/today")
async def get_water_today():
    """Get today's water intake."""
    return {
        "today_total": store.water_today,
        "goal": 2000,
        "progress": min(100, int(store.water_today / 2000 * 100))
    }

# ----------------------------------------
# SHOP ENDPOINTS
# ----------------------------------------

SHOP_ITEMS = [
    {"id": "item_001", "item_key": "basic_hat", "name": "小浣熊帽", 
     "description": "经典款棒球帽", "item_type": "hat", "price_bitecoins": 50},
    {"id": "item_002", "item_key": "sunglasses", "name": "酷炫墨镜",
     "description": "超酷太阳镜", "item_type": "glasses", "price_bitecoins": 80},
    {"id": "item_003", "item_key": "rainbow_scarf", "name": "彩虹围巾",
     "description": "七色彩虹围巾", "item_type": "scarf", "price_bitecoins": 100},
    {"id": "item_004", "item_key": "night_sky_bg", "name": "夜空背景",
     "description": "璀璨星空背景", "item_type": "background", "price_bitecoins": 150},
    {"id": "item_005", "item_key": "golden_crown", "name": "金色皇冠",
     "description": "尊贵皇冠", "item_type": "hat", "price_bitecoins": 500},
    {"id": "item_006", "item_key": "heart_glasses", "name": "爱心眼镜",
     "description": "粉红爱心眼镜", "item_type": "glasses", "price_bitecoins": 120},
]

@app.get("/api/v1/shop/items", response_model=List[ShopItemResponse])
async def get_shop_items():
    """Get available shop items."""
    return [ShopItemResponse(**item) for item in SHOP_ITEMS]

@app.get("/api/v1/shop/items/{item_type}")
async def get_shop_items_by_type(item_type: str):
    """Get shop items by type."""
    items = [item for item in SHOP_ITEMS if item["item_type"] == item_type]
    return items

@app.post("/api/v1/shop/purchase", response_model=PurchaseResponse)
async def purchase_item(request: PurchaseRequest):
    """Purchase an item from the shop."""
    user = store.get_user()
    
    item = next((i for i in SHOP_ITEMS if i["id"] == request.item_id), None)
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")
    
    if user["bitecoins"] < item["price_bitecoins"]:
        return PurchaseResponse(
            success=False,
            new_balance=user["bitecoins"],
            item_id=request.item_id,
            message=f"金币不足！还差 {item['price_bitecoins'] - user['bitecoins']} 金币"
        )
    
    # Deduct coins
    user["bitecoins"] -= item["price_bitecoins"]
    
    # Add to inventory
    if request.item_id not in store.inventory:
        store.inventory[request.item_id] = 0
    store.inventory[request.item_id] += 1
    
    return PurchaseResponse(
        success=True,
        new_balance=user["bitecoins"],
        item_id=request.item_id,
        message=f"购买成功！{item['name']} 已添加到背包"
    )

@app.get("/api/v1/shop/inventory")
async def get_inventory():
    """Get user's inventory."""
    items = [{"item_id": k, "quantity": v} for k, v in store.inventory.items()]
    return {"items": items, "count": len(items)}

# ----------------------------------------
# ANALYTICS ENDPOINTS
# ----------------------------------------

@app.get("/api/v1/analytics/daily", response_model=DailyStatsResponse)
async def get_daily_stats():
    """Get today's statistics."""
    user = store.get_user()
    pet = store.get_pet()
    
    today_meals = store.meals[-10:]  # Simplified
    today_calories = sum(m["calories"] for m in today_meals)
    today_coins = sum(m["coins_earned"] for m in today_meals)
    
    return DailyStatsResponse(
        date=datetime.now().strftime("%Y-%m-%d"),
        meals_count=len(today_meals),
        total_calories=today_calories,
        coins_earned_today=today_coins,
        water_ml=store.water_today,
        water_goal=2000,
        streak=user["current_streak"],
        pet_state=PetStateResponse(**pet)
    )

@app.get("/api/v1/analytics/weekly")
async def get_weekly_stats():
    """Get weekly statistics."""
    return {
        "week_start": (datetime.now() - timedelta(days=7)).strftime("%Y-%m-%d"),
        "week_end": datetime.now().strftime("%Y-%m-%d"),
        "total_meals": 21,
        "total_calories": 10500,
        "avg_water": 1800,
        "streak_days": 7,
        "pet_evolution_progress": 65
    }

# ----------------------------------------
# AI ENDPOINTS (Vision Agent)
# ----------------------------------------

@app.post("/api/v1/ai/analyze-food")
async def ai_analyze_food(
    image_url: Optional[str] = None,
    food_name: Optional[str] = None
):
    """
    AI-powered food analysis (Vision Agent).
    
    In production:
    1. Download image from URL
    2. Call GPT-4o Vision
    3. Call Gemini Vision
    4. Cross-validate
    5. Return consensus
    """
    if not image_url and not food_name:
        raise HTTPException(status_code=400, detail="Provide image_url or food_name")
    
    # Simulate AI processing
    await asyncio.sleep(2)
    
    # Generate mock analysis
    categories = ["dessert", "vegetable", "fruit", "protein", "carb", "drink", "snack"]
    
    return {
        "analysis_id": str(uuid4()),
        "timestamp": datetime.now().isoformat(),
        "food_name": food_name or "分析食物",
        "estimated_calories": random.randint(100, 800),
        "nutrients": {
            "protein": random.randint(5, 40),
            "carbs": random.randint(20, 100),
            "fat": random.randint(5, 50)
        },
        "category": random.choice(categories),
        "anxiety_relief_label": "灵魂充电时间 ⚡",
        "anxiety_relief_emoji": "🍰",
        "confidence": 0.92,
        "colors_detected": ["#F5DEB3", "#FFD700"],
        "gpt4o_result": {"food_name": "蛋糕", "confidence": 0.95},
        "gemini_result": {"food_name": "芝士蛋糕", "confidence": 0.88},
        "consensus": {"food_name": "芝士蛋糕", "confidence": 0.92}
    }

# ============================================
# STARTUP
# ============================================

@app.on_event("startup")
async def startup_event():
    print("""
    ╔═══════════════════════════════════════════════╗
    ║                                               ║
    ║   🦝 Aura-Pet API Started Successfully!      ║
    ║                                               ║
    ║   📍 http://localhost:8000                    ║
    ║   📚 Docs: http://localhost:8000/docs         ║
    ║                                               ║
    ║   Demo: demo@aura-pet.com / demo123          ║
    ║                                               ║
    ╚═══════════════════════════════════════════════╝
    """)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
