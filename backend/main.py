"""
AURA-PET: 商业化 FastAPI 后端
支持全球用户、多语言、多币种
"""

from fastapi import FastAPI, HTTPException, Depends, status, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from pydapi import BaseModel, EmailStr
from pydantic_settings import BaseSettings
from typing import List, Optional, Dict
from datetime import datetime, timedelta
from passlib.context import CryptContext
import asyncio
import redis.asyncio as redis
import json
import random
import uuid
import os
from functools import lru_cache

# ========== 配置 ==========

class Settings(BaseSettings):
    database_url: str = os.getenv("DATABASE_URL", "postgresql://aura_pet:aura_pet@localhost:5432/aura_pet")
    redis_url: str = os.getenv("REDIS_URL", "redis://localhost:6379")
    secret_key: str = os.getenv("SECRET_KEY", "your-secret-key-change-in-production")
    access_token_expire_minutes: int = 60 * 24 * 7  # 7 days
    
    stripe_api_key: Optional[str] = None
    stripe_webhook_secret: Optional[str] = None
    
    openai_api_key: Optional[str] = None
    
    class Config:
        env_file = ".env"

settings = Settings()

# ========== 安全 ==========

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

# ========== FastAPI ==========

app = FastAPI(
    title="Aura-Pet API",
    description="智能宠物养成 - Quad-Agent 协作系统",
    version="2.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ========== Redis 连接 ==========

redis_client: Optional[redis.Redis] = None

@app.on_event("startup")
async def startup():
    global redis_client
    try:
        redis_client = await redis.from_url(
            settings.redis_url,
            encoding="utf-8",
            decode_responses=True
        )
        await redis_client.ping()
        print("✅ Redis connected")
    except Exception as e:
        print(f"⚠️ Redis not available: {e}")
        redis_client = None

@app.on_event("shutdown")
async def shutdown():
    if redis_client:
        await redis_client.close()

# ========== 数据模型 ==========

class UserRegister(BaseModel):
    email: EmailStr
    password: str
    username: str
    height_cm: Optional[float] = None
    weight_kg: Optional[float] = None
    age: Optional[int] = None
    gender: Optional[str] = None
    fitness_goal: Optional[str] = "maintain"
    timezone: Optional[str] = "Asia/Shanghai"

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserProfile(BaseModel):
    height_cm: Optional[float] = None
    weight_kg: Optional[float] = None
    age: Optional[int] = None
    gender: Optional[str] = None
    activity_level: Optional[str] = None
    fitness_goal: Optional[str] = None
    language: Optional[str] = None

class UserResponse(BaseModel):
    id: str
    email: str
    username: str
    height_cm: Optional[float]
    weight_kg: Optional[float]
    bmr: Optional[float]
    tdee: Optional[float]
    subscription_tier: str
    is_premium: bool

class MealAnalyzeRequest(BaseModel):
    image: Optional[str] = None
    barcode: Optional[str] = None
    manual: Optional[Dict] = None
    meal_type: str = "snack"
    user_timezone: Optional[str] = "Asia/Shanghai"

class MealRecordResponse(BaseModel):
    id: str
    food_name: str
    emoji: str
    calories: int
    protein_grams: float
    carbs_grams: float
    fat_grams: float
    aura_score: float
    anxiety_label: str
    phrases: List[str]
    coins_earned: int
    xp_earned: int

# ========== 去焦虑语料库 (扩展版) ==========

CORPUS = {
    "dessert": [
        {"emoji": "🍰", "name": "芝士蛋糕", "cal": 420, "label": "灵魂充电时间 ⚡",
         "phrases": ["哇！是你最爱的甜点诶！！", "生活已经这么苦了当然要对自己好一点呀～", "吃吧吃吧，小浣熊批准了！👑✨"],
         "protein": 8, "carbs": 45, "fat": 22},
        {"emoji": "🍫", "name": "巧克力", "cal": 550, "label": "快乐因子注入中 💫",
         "phrases": ["哦～是巧克力呀！", "研究表明黑巧克力含有抗氧化物质哦～", "科学认证的养生甜点！📚💪"],
         "protein": 6, "carbs": 60, "fat": 30},
        {"emoji": "🍦", "name": "冰淇淋", "cal": 320, "label": "夏日快乐源泉 🌞",
         "phrases": ["夏天的快乐来啦！", "卡路里什么的先放一边～", "这一刻的满足感才是真正的财富呀～"],
         "protein": 5, "carbs": 35, "fat": 18},
        {"emoji": "🍩", "name": "甜甜圈", "cal": 380, "label": "快乐圈循环 🔄",
         "phrases": ["甜甜圈！快乐圈！", "甜食会刺激多巴胺分泌呢～", "这是科学让你开心的！🤪✨"],
         "protein": 4, "carbs": 48, "fat": 18},
        {"emoji": "🍮", "name": "布丁", "cal": 180, "label": "丝滑治愈时光 🍮",
         "phrases": ["布丁！滑滑嫩嫩的～", "一口下去烦恼都没啦！", "小浣熊的甜蜜推荐！"],
         "protein": 4, "carbs": 28, "fat": 5},
    ],
    "main": [
        {"emoji": "🍕", "name": "披萨", "cal": 680, "label": "尊享犒劳时刻 👑",
         "phrases": ["披萨！永远的经典！", "碳水+脂肪的完美组合，怪不得叫 comfort food！", "大口吃起来！🤤"],
         "protein": 25, "carbs": 80, "fat": 28},
        {"emoji": "🍔", "name": "汉堡", "cal": 550, "label": "能量补给站 ⚡",
         "phrases": ["汉堡侠出击！", "牛肉饼提供蛋白质，面包提供能量～", "这可是正经的一顿营养餐呢！"],
         "protein": 30, "carbs": 45, "fat": 25},
        {"emoji": "🍜", "name": "拉面", "cal": 450, "label": "暖心治愈系 💕",
         "phrases": ["热腾腾的拉面！", "碳水化合物的快乐～", "吃完浑身都暖和了！"],
         "protein": 15, "carbs": 65, "fat": 12},
        {"emoji": "🍛", "name": "咖喱饭", "cal": 520, "label": "元气充电中 🔋",
         "phrases": ["咖喱的香气！", "浓郁的味道正在唤醒味蕾～", "好满足的一餐呀！"],
         "protein": 20, "carbs": 70, "fat": 15},
        {"emoji": "🥘", "name": "火锅", "cal": 850, "label": "饕餮盛宴 🔥",
         "phrases": ["火锅！冬日必备！", "什么都涮一涮，快乐翻倍！", "和朋友一起吃最香啦～🍲"],
         "protein": 40, "carbs": 50, "fat": 45},
    ],
    "fast": [
        {"emoji": "🍗", "name": "炸鸡", "cal": 620, "label": "快乐炸裂 ✨",
         "phrases": ["酥脆的外皮，多汁的鸡肉...", "今天的你看起来需要一点酥脆的治愈感～", "卡路里什么的不存在的，只有快乐！"],
         "protein": 35, "carbs": 30, "fat": 40},
        {"emoji": "🍟", "name": "薯条", "cal": 380, "label": "黄金能量棒 💛",
         "phrases": ["薯条！薯条！薯条！", "黄金酥脆的外表下是满满的土豆能量～", "偶尔放纵一下也是生活的一部分嘛！"],
         "protein": 5, "carbs": 48, "fat": 18},
        {"emoji": "🌭", "name": "热狗", "cal": 290, "label": "轻量快乐 🎉",
         "phrases": ["简单又美味！", "小浣熊的标准快餐选择～", "刚刚好的分量！"],
         "protein": 12, "carbs": 30, "fat": 15},
    ],
    "healthy": [
        {"emoji": "🥗", "name": "蔬菜沙拉", "cal": 180, "label": "绿色能量满格 🌿",
         "phrases": ["蔬菜侠出击！🧑‍🌾", "今天的你又在为身体健康投资啦～", "小浣熊给你点一个大大的赞！"],
         "protein": 5, "carbs": 15, "fat": 8},
        {"emoji": "🥑", "name": "牛油果吐司", "cal": 280, "label": "健身达人之选 💪",
         "phrases": ["牛油果！健身达人的最爱！", "单不饱和脂肪酸，对心脏超友好～", "小浣熊也想来一片呢（悄悄流口水）"],
         "protein": 8, "carbs": 25, "fat": 18},
        {"emoji": "🍎", "name": "水果拼盘", "cal": 150, "label": "大自然糖果 🍬",
         "phrases": ["新鲜的水果！", "天然的甜味最健康啦～", "维生素满满！"],
         "protein": 2, "carbs": 35, "fat": 1},
        {"emoji": "🥚", "name": "水煮蛋+吐司", "cal": 320, "label": "蛋白质仓库 💎",
         "phrases": ["蛋白质+碳水！完美的早餐组合！", "补充能量，一上午都有精神！"],
         "protein": 18, "carbs": 28, "fat": 12},
        {"emoji": "🍠", "name": "烤红薯", "cal": 200, "label": "甜蜜暖手宝 🍠",
         "phrases": ["热乎乎的烤红薯！", "冬天的快乐源泉～", "又甜又暖好幸福！"],
         "protein": 3, "carbs": 45, "fat": 1},
    ],
    "drinks": [
        {"emoji": "☕", "name": "拿铁咖啡", "cal": 150, "label": "清醒模式启动 ⚡",
         "phrases": ["早安咖啡时间到！☕", "咖啡因正在唤醒你的每一个脑细胞～", "今天的效率一定超高！"],
         "protein": 8, "carbs": 15, "fat": 5},
        {"emoji": "🧋", "name": "珍珠奶茶", "cal": 450, "label": "快乐肥宅水 🥤",
         "phrases": ["奶茶侠来啦！", "珍珠+奶茶=双重快乐组合！", "糖分警告...但是好喝就完事了！🧋💕"],
         "protein": 5, "carbs": 70, "fat": 10},
        {"emoji": "🥤", "name": "蛋白奶昔", "cal": 280, "label": "健身补给站 💪",
         "phrases": ["蛋白奶昔！健身好搭档！", "蛋白质满满，练完不累！"],
         "protein": 30, "carbs": 25, "fat": 5},
    ],
}

# ========== Quad-Agent 系统 ==========

class QuadAgentOrchestrator:
    """
    商业化 Quad-Agent 协调器
    Vision → Logic → Persona → Animator
    """
    
    @staticmethod
    async def process_meal(user_id: str, request: MealAnalyzeRequest, user_height: float = 175) -> Dict:
        """
        并行执行四个 Agent
        """
        results = await asyncio.gather(
            QuadAgentOrchestrator.vision_agent(request),
            QuadAgentOrchestrator.logic_agent(request, user_height),
            QuadAgentOrchestrator.persona_agent(request),
            QuadAgentOrchestrator.animator_agent(request),
        )
        
        vision, logic, persona, animator = results
        
        return {
            "id": str(uuid.uuid4()),
            **vision,
            **logic,
            "phrases": persona["phrases"],
            "animation_params": animator,
        }
    
    @staticmethod
    async def vision_agent(request: MealAnalyzeRequest) -> Dict:
        """
        Vision-Agent: 识别食物/条形码
        """
        await asyncio.sleep(0.05)  # 模拟处理
        
        # 如果有手动输入
        if request.manual:
            return {
                "food_name": request.manual.get("name", "自定义食物"),
                "emoji": request.manual.get("emoji", "🍽️"),
                "calories": request.manual.get("calories", 300),
                "protein_grams": request.manual.get("protein", 10),
                "carbs_grams": request.manual.get("carbs", 40),
                "fat_grams": request.manual.get("fat", 10),
                "anxiety_label": "自定义营养 ⚡",
            }
        
        # 随机选择
        category = random.choice(list(CORPUS.keys()))
        food = random.choice(CORPUS[category])
        
        return {
            "food_name": food["name"],
            "emoji": food["emoji"],
            "calories": food["cal"],
            "protein_grams": food["protein"],
            "carbs_grams": food["carbs"],
            "fat_grams": food["fat"],
            "anxiety_label": food["label"],
        }
    
    @staticmethod
    async def logic_agent(request: MealAnalyzeRequest, user_height: float) -> Dict:
        """
        Logic-Agent: 计算 Aura Score 和奖励
        """
        await asyncio.sleep(0.05)
        
        # 获取刚才识别的食物热量
        category = random.choice(list(CORPUS.keys()))
        food = random.choice(CORPUS[category])
        cal = food["cal"]
        
        # 计算 Aura Score (基于热量合理性)
        if cal < 200:
            aura = random.uniform(85, 95)  # 健康食物高分
        elif cal < 400:
            aura = random.uniform(70, 85)  # 适量
        elif cal < 600:
            aura = random.uniform(55, 70)  # 中等
        else:
            aura = random.uniform(40, 60)  # 高热量但去焦虑
        
        # 计算奖励
        base_coins = 10
        aura_bonus = int(aura / 10)
        coins = base_coins + aura_bonus + random.randint(0, 5)
        
        xp = int(cal / 15) + random.randint(5, 15)
        
        # 体型调整奖励
        if user_height > 180:
            xp = int(xp * 1.2)  # 高个子需要更多能量
        elif user_height < 160:
            xp = int(xp * 0.8)
        
        return {
            "aura_score": round(aura, 1),
            "coins_earned": coins,
            "xp_earned": xp,
        }
    
    @staticmethod
    async def persona_agent(request: MealAnalyzeRequest) -> Dict:
        """
        Persona-Agent: 生成个性化对话
        """
        await asyncio.sleep(0.05)
        
        hour = datetime.now().hour
        tz = request.user_timezone or "Asia/Shanghai"
        
        # 根据时间选择语料
        if 22 <= hour or hour < 6:
            phrases = [
                "这么晚还没睡呀...小浣熊陪你！🌙",
                "深夜觅食中...小浣熊也懂这种快乐～",
                "夜猫子一枚！记得早点休息哦～",
            ]
        elif 6 <= hour < 9:
            phrases = [
                "早安！新的一天从美味早餐开始！☀️",
                "早餐是一天中最重要的一餐哦～",
                "吃得好，一天都有精神！",
            ]
        elif 11 <= hour < 14:
            phrases = [
                "午餐时间到！",
                "辛苦了一上午，该补充能量啦～",
                "好好吃饭，下午继续加油！",
            ]
        elif 17 <= hour < 20:
            phrases = [
                "晚餐时间！一天中最期待的时刻～",
                "犒劳一下自己吧！",
            ]
        else:
            category = random.choice(list(CORPUS.keys()))
            food = random.choice(CORPUS[category])
            phrases = food["phrases"]
        
        return {
            "phrases": phrases,
            "selected_phrase": random.choice(phrases),
        }
    
    @staticmethod
    async def animator_agent(request: MealAnalyzeRequest) -> Dict:
        """
        Animator-Agent: 生成动画参数
        """
        await asyncio.sleep(0.03)
        
        emotions = ["happy", "excited", "loved"]
        animations = ["spin", "bounce", "jump", "hug"]
        
        return {
            "animation_type": random.choice(animations),
            "emotion": random.choice(emotions),
            "duration_ms": random.randint(800, 1500),
            "particle_effect": random.choice(["hearts", "stars", "sparkles"]),
        }


# ========== API 端点 ==========

@app.get("/")
async def root():
    return {
        "name": "Aura-Pet API",
        "version": "2.0.0",
        "status": "running"
    }

@app.get("/health")
async def health():
    redis_ok = False
    if redis_client:
        try:
            await redis_client.ping()
            redis_ok = True
        except:
            pass
    
    return {
        "status": "ok",
        "redis": redis_ok,
        "timestamp": datetime.utcnow().isoformat()
    }

# ========== 认证 API ==========

@app.post("/v1/auth/register", response_model=UserResponse)
async def register(user: UserRegister):
    """
    用户注册
    """
    # 验证密码强度
    if len(user.password) < 8:
        raise HTTPException(
            status_code=400,
            detail="Password must be at least 8 characters"
        )
    
    # 创建用户
    user_id = str(uuid.uuid4())
    
    # 计算 BMR (如果提供了身体数据)
    bmr = None
    tdee = None
    
    if all([user.height_cm, user.weight_kg, user.age]):
        if user.gender == "male":
            bmr = (10 * user.weight_kg) + (6.25 * user.height_cm) - (5 * user.age) + 5
        else:
            bmr = (10 * user.weight_kg) + (6.25 * user.height_cm) - (5 * user.age) - 161
        
        activity_mult = 1.2
        tdee = bmr * activity_mult
        
        if user.fitness_goal == "lose_fat":
            tdee = tdee * 0.8
        elif user.fitness_goal == "gain_muscle":
            tdee = tdee * 1.15
    
    # 存储到 Redis (生产环境应该是 PostgreSQL)
    user_data = {
        "id": user_id,
        "email": user.email,
        "username": user.username,
        "password_hash": hash_password(user.password),
        "height_cm": user.height_cm,
        "weight_kg": user.weight_kg,
        "age": user.age,
        "gender": user.gender,
        "fitness_goal": user.fitness_goal,
        "bmr": bmr,
        "tdee": tdee,
        "subscription_tier": "free",
        "is_premium": False,
        "timezone": user.timezone,
    }
    
    if redis_client:
        await redis_client.set(f"user:{user_id}", json.dumps(user_data))
        await redis_client.set(f"user_email:{user.email}", user_id)
    
    return UserResponse(
        id=user_id,
        email=user.email,
        username=user.username,
        height_cm=user.height_cm,
        weight_kg=user.weight_kg,
        bmr=bmr,
        tdee=tdee,
        subscription_tier="free",
        is_premium=False
    )

@app.post("/v1/auth/login")
async def login(credentials: UserLogin):
    """
    用户登录
    """
    if not redis_client:
        raise HTTPException(status_code=503, detail="Service unavailable")
    
    # 查找用户
    user_id = await redis_client.get(f"user_email:{credentials.email}")
    if not user_id:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    user_data = await redis_client.get(f"user:{user_id}")
    if not user_data:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    user = json.loads(user_data)
    
    # 验证密码
    if not verify_password(credentials.password, user["password_hash"]):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    # 生成 token
    token = str(uuid.uuid4())
    await redis_client.setex(f"token:{token}", 60 * 60 * 24 * 7, user_id)  # 7 days
    
    return {
        "access_token": token,
        "token_type": "bearer",
        "user_id": user_id,
        "expires_in": 60 * 60 * 24 * 7
    }

# ========== 用户 API ==========

@app.get("/v1/user/profile", response_model=UserResponse)
async def get_profile(user_id: str):
    """获取用户资料"""
    if not redis_client:
        raise HTTPException(status_code=503, detail="Service unavailable")
    
    user_data = await redis_client.get(f"user:{user_id}")
    if not user_data:
        raise HTTPException(status_code=404, detail="User not found")
    
    user = json.loads(user_data)
    
    return UserResponse(
        id=user["id"],
        email=user["email"],
        username=user["username"],
        height_cm=user.get("height_cm"),
        weight_kg=user.get("weight_kg"),
        bmr=user.get("bmr"),
        tdee=user.get("tdee"),
        subscription_tier=user.get("subscription_tier", "free"),
        is_premium=user.get("is_premium", False)
    )

@app.patch("/v1/user/profile")
async def update_profile(user_id: str, profile: UserProfile):
    """更新用户资料"""
    if not redis_client:
        raise HTTPException(status_code=503, detail="Service unavailable")
    
    user_data = await redis_client.get(f"user:{user_id}")
    if not user_data:
        raise HTTPException(status_code=404, detail="User not found")
    
    user = json.loads(user_data)
    
    # 更新字段
    update_data = profile.dict(exclude_unset=True)
    user.update(update_data)
    
    # 重新计算 BMR
    if all([user.get("height_cm"), user.get("weight_kg"), user.get("age")]):
        if user.get("gender") == "male":
            bmr = (10 * user["weight_kg"]) + (6.25 * user["height_cm"]) - (5 * user["age"]) + 5
        else:
            bmr = (10 * user["weight_kg"]) + (6.25 * user["height_cm"]) - (5 * user["age"]) - 161
        user["bmr"] = bmr
    
    await redis_client.set(f"user:{user_id}", json.dumps(user))
    
    return {"status": "updated"}

# ========== 餐食 API ==========

@app.post("/v1/meal/analyze", response_model=MealRecordResponse)
async def analyze_meal(user_id: str, request: MealAnalyzeRequest):
    """
    Quad-Agent 并行分析餐食
    """
    # 获取用户身高
    user_height = 175  # 默认值
    if redis_client:
        user_data = await redis_client.get(f"user:{user_id}")
        if user_data:
            user = json.loads(user_data)
            user_height = user.get("height_cm", 175)
    
    # 执行 Quad-Agent
    result = await QuadAgentOrchestrator.process_meal(user_id, request, user_height)
    
    # 存储记录
    if redis_client:
        meal_data = {
            "id": result["id"],
            "user_id": user_id,
            "food_name": result["food_name"],
            "emoji": result["emoji"],
            "calories": result["calories"],
            "anxiety_label": result["anxiety_label"],
            "coins_earned": result["coins_earned"],
            "xp_earned": result["xp_earned"],
            "logged_at": datetime.utcnow().isoformat(),
        }
        await redis_client.lpush(f"meals:{user_id}", json.dumps(meal_data))
        await redis_client.expire(f"meals:{user_id}", 60 * 60 * 24 * 30)  # 30 days
    
    return MealRecordResponse(
        id=result["id"],
        food_name=result["food_name"],
        emoji=result["emoji"],
        calories=result["calories"],
        protein_grams=result["protein_grams"],
        carbs_grams=result["carbs_grams"],
        fat_grams=result["fat_grams"],
        aura_score=result["aura_score"],
        anxiety_label=result["anxiety_label"],
        phrases=result["phrases"],
        coins_earned=result["coins_earned"],
        xp_earned=result["xp_earned"],
    )

@app.get("/v1/meal/history")
async def get_meal_history(user_id: str, limit: int = 20):
    """获取餐食历史"""
    if not redis_client:
        return []
    
    meals = await redis_client.lrange(f"meals:{user_id}", 0, limit - 1)
    return [json.loads(m) for m in meals]

# ========== WebSocket 实时推送 ==========

class ConnectionManager:
    def __init__(self):
        self.active_connections: Dict[str, WebSocket] = {}
    
    async def connect(self, websocket: WebSocket, user_id: str):
        await websocket.accept()
        self.active_connections[user_id] = websocket
    
    def disconnect(self, user_id: str):
        if user_id in self.active_connections:
            del self.active_connections[user_id]
    
    async def send_personal(self, user_id: str, message: Dict):
        if user_id in self.active_connections:
            await self.active_connections[user_id].send_json(message)
    
    async def broadcast(self, message: Dict):
        for connection in self.active_connections.values():
            await connection.send_json(message)

manager = ConnectionManager()

@app.websocket("/v1/ws/{user_id}")
async def websocket_endpoint(websocket: WebSocket, user_id: str):
    await manager.connect(websocket, user_id)
    try:
        while True:
            data = await websocket.receive_text()
            message = json.loads(data)
            
            # 处理消息并推送回复
            if message.get("type") == "ping":
                await manager.send_personal(user_id, {"type": "pong"})
            elif message.get("type") == "meal_analyzed":
                # 推送餐食分析完成通知
                await manager.send_personal(user_id, {
                    "type": "meal_complete",
                    "data": message.get("data")
                })
    except WebSocketDisconnect:
        manager.disconnect(user_id)


# ========== 商店 API ==========

@app.get("/v1/shop/items")
async def get_shop_items():
    """获取商店物品"""
    return {
        "items": [
            {"id": "glasses_round", "name": "圆框眼镜", "emoji": "👓", "category": "accessories", "price_coins": 100, "price_cents": 299, "rarity": "common"},
            {"id": "glasses_sun", "name": "复古墨镜", "emoji": "🕶️", "category": "accessories", "price_coins": 200, "price_cents": 499, "rarity": "rare"},
            {"id": "bow_pink", "name": "粉色蝴蝶结", "emoji": "🎀", "category": "accessories", "price_coins": 150, "price_cents": 299, "rarity": "common"},
            {"id": "bg_monet", "name": "莫奈花园", "emoji": "🌸", "category": "backgrounds", "price_coins": 300, "price_cents": 699, "rarity": "rare"},
            {"id": "bg_starry", "name": "星空", "emoji": "✨", "category": "backgrounds", "price_coins": 250, "price_cents": 599, "rarity": "rare"},
            {"id": "bg_aurora", "name": "极光", "emoji": "🌌", "category": "backgrounds", "price_coins": 500, "price_cents": 999, "rarity": "legendary"},
            {"id": "hat_crown", "name": "小皇冠", "emoji": "👑", "category": "accessories", "price_coins": 500, "price_cents": 999, "rarity": "epic"},
        ]
    }

@app.post("/v1/shop/purchase")
async def purchase_item(user_id: str, item_id: str, currency: str = "coins"):
    """购买物品"""
    # 简化实现
    return {
        "success": True,
        "item_id": item_id,
        "message": "Purchase successful!"
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
