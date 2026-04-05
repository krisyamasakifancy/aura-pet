"""
AURA-PET: FastAPI 后端
Quad-Agent 并行协作系统
"""

from fastapi import FastAPI, WebSocket, WebSocketDisconnect, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional, Dict
import asyncio
import redis.asyncio as redis
import json
import random
from datetime import datetime
import os

app = FastAPI(title="Aura-Pet API", version="1.0.0")

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Redis 连接
redis_client: Optional[redis.Redis] = None

@app.on_event("startup")
async def startup():
    global redis_client
    try:
        redis_client = await redis.from_url(
            os.getenv("REDIS_URL", "redis://localhost:6379"),
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

class PetState(BaseModel):
    name: str = "毛毛"
    level: int = 1
    xp: int = 0
    xp_to_next: int = 100
    coins: int = 100
    joy: int = 80
    fullness: int = 70
    water_intake: int = 0
    water_goal: int = 2000
    streak: int = 0
    meals_today: int = 0
    mood: str = "happy"
    nutrition_balance: float = 0
    equipped_item: Optional[str] = None
    evolution_stage: str = "幼年期"

class MealAnalysisRequest(BaseModel):
    image: str  # Base64 编码的图片

class MealRecord(BaseModel):
    food_name: str
    emoji: str
    calories: int
    anxiety_label: str
    phrases: List[str]
    coins_earned: int
    xp_earned: int

# ========== 去焦虑语料库 (100+ 条) ==========

CORPUS = {
    "dessert": [
        {"emoji": "🍰", "name": "芝士蛋糕", "cal": 420, "label": "灵魂充电时间 ⚡",
         "phrases": ["哇！是你最爱的甜点诶！！", "生活已经这么苦了当然要对自己好一点呀～", "吃吧吃吧，小浣熊批准了！👑✨"]},
        {"emoji": "🍫", "name": "巧克力", "cal": 550, "label": "快乐因子注入中 💫",
         "phrases": ["哦～是巧克力呀！", "研究表明黑巧克力含有抗氧化物质哦～", "科学认证的养生甜点！📚💪"]},
        {"emoji": "🍦", "name": "冰淇淋", "cal": 320, "label": "夏日快乐源泉 🌞",
         "phrases": ["夏天的快乐来啦！", "卡路里什么的先放一边～", "这一刻的满足感才是真正的财富呀～"]},
        {"emoji": "🍩", "name": "甜甜圈", "cal": 380, "label": "快乐圈循环 🔄",
         "phrases": ["甜甜圈！快乐圈！", "甜食会刺激多巴胺分泌呢～", "这是科学让你开心的！🤪✨"]},
        {"emoji": "🧁", "name": "杯子蛋糕", "cal": 350, "label": "精致小确幸 ✨",
         "phrases": ["好精致的蛋糕！", "一口一个刚刚好～", "小浣熊也想咬一口呢！"]},
        {"emoji": "🍮", "name": "布丁", "cal": 180, "label": "丝滑治愈时光 🍮",
         "phrases": ["布丁！滑滑嫩嫩的～", "一口下去烦恼都没啦！", "小浣熊的甜蜜推荐！"]},
        {"emoji": "🍪", "name": "曲奇饼干", "cal": 290, "label": "酥脆好心情 🍪",
         "phrases": ["酥脆的曲奇！", "配牛奶绝了！", "小浣熊闻到香味啦～"]},
    ],
    "main": [
        {"emoji": "🍕", "name": "披萨", "cal": 680, "label": "尊享犒劳时刻 👑",
         "phrases": ["披萨！永远的经典！", "碳水+脂肪的完美组合，怪不得叫 comfort food！", "大口吃起来！🤤"]},
        {"emoji": "🍔", "name": "汉堡", "cal": 550, "label": "能量补给站 ⚡",
         "phrases": ["汉堡侠出击！", "牛肉饼提供蛋白质，面包提供能量～", "这可是正经的一顿营养餐呢！"]},
        {"emoji": "🍜", "name": "拉面", "cal": 450, "label": "暖心治愈系 💕",
         "phrases": ["热腾腾的拉面！", "碳水化合物的快乐～", "吃完浑身都暖和了！"]},
        {"emoji": "🍛", "name": "咖喱饭", "cal": 520, "label": "元气充电中 🔋",
         "phrases": ["咖喱的香气！", "浓郁的味道正在唤醒味蕾～", "好满足的一餐呀！"]},
        {"emoji": "🍝", "name": "意面", "cal": 480, "label": "浪漫西餐时光 🍝",
         "phrases": ["意面！优雅的选择！", "番茄酱的酸甜刚刚好～", "小浣熊也想来一口呢～"]},
        {"emoji": "🥘", "name": "火锅", "cal": 850, "label": "饕餮盛宴 🔥",
         "phrases": ["火锅！冬日必备！", "什么都涮一涮，快乐翻倍！", "和朋友一起吃最香啦～🍲"]},
        {"emoji": "🍲", "name": "砂锅粥", "cal": 280, "label": "温润养胃 🌿",
         "phrases": ["暖暖的砂锅粥～", "养胃又暖心！", "小浣熊也想喝一碗～"]},
    ],
    "fast": [
        {"emoji": "🍗", "name": "炸鸡", "cal": 620, "label": "快乐炸裂 ✨",
         "phrases": ["酥脆的外皮，多汁的鸡肉...", "今天的你看起来需要一点酥脆的治愈感～", "卡路里什么的不存在的，只有快乐！"]},
        {"emoji": "🍟", "name": "薯条", "cal": 380, "label": "黄金能量棒 💛",
         "phrases": ["薯条！薯条！薯条！", "黄金酥脆的外表下是满满的土豆能量～", "偶尔放纵一下也是生活的一部分嘛！"]},
        {"emoji": "🌭", "name": "热狗", "cal": 290, "label": "轻量快乐 🎉",
         "phrases": ["简单又美味！", "小浣熊的标准快餐选择～", "刚刚好的分量！"]},
        {"emoji": "🥪", "name": "三明治", "cal": 320, "label": "快捷能量包 🥪",
         "phrases": ["三明治！营养均衡！", "蔬菜蛋白质碳水全都有～", "小浣熊的午餐常客！"]},
    ],
    "healthy": [
        {"emoji": "🥗", "name": "蔬菜沙拉", "cal": 180, "label": "绿色能量满格 🌿",
         "phrases": ["蔬菜侠出击！🧑‍🌾", "今天的你又在为身体健康投资啦～", "小浣熊给你点一个大大的赞！"]},
        {"emoji": "🥑", "name": "牛油果", "cal": 160, "label": "健身达人之选 💪",
         "phrases": ["牛油果！健身达人的最爱！", "单不饱和脂肪酸，对心脏超友好～", "小浣熊也想来一片呢（悄悄流口水）"]},
        {"emoji": "🍎", "name": "水果拼盘", "cal": 150, "label": "大自然糖果 🍬",
         "phrases": ["新鲜的水果！", "天然的甜味最健康啦～", "维生素满满！"]},
        {"emoji": "🥚", "name": "水煮蛋", "cal": 140, "label": "蛋白质仓库 💎",
         "phrases": ["简单却营养！", "蛋白质是生命的基础呀～", "小浣熊的早餐常客！"]},
        {"emoji": "🥦", "name": "西兰花", "cal": 55, "label": "超级蔬菜 💚",
         "phrases": ["西兰花！蔬菜界的超级英雄！", "富含维生素C和膳食纤维～", "吃了感觉自己棒棒的！"]},
        {"emoji": "🍠", "name": "烤红薯", "cal": 200, "label": "甜蜜暖手宝 🍠",
         "phrases": ["热乎乎的烤红薯！", "冬天的快乐源泉～", "又甜又暖好幸福！"]},
        {"emoji": "🥛", "name": "牛奶", "cal": 150, "label": "成长助推器 📈",
         "phrases": ["牛奶时间到！", "钙质和蛋白质双管齐下～", "喝了会变得更强壮哦！"]},
    ],
    "drinks": [
        {"emoji": "☕", "name": "咖啡", "cal": 50, "label": "清醒模式启动 ⚡",
         "phrases": ["早安咖啡时间到！☕", "咖啡因正在唤醒你的每一个脑细胞～", "今天的效率一定超高！"]},
        {"emoji": "🧋", "name": "奶茶", "cal": 350, "label": "快乐肥宅水 🥤",
         "phrases": ["奶茶侠来啦！", "珍珠+奶茶=双重快乐组合！", "糖分警告...但是好喝就完事了！🧋💕"]},
        {"emoji": "🫖", "name": "水果茶", "cal": 120, "label": "清爽无负担 🌊",
         "phrases": ["清爽的水果茶！", "好喝又健康的选择～", "小浣熊也喜欢这种清新感！"]},
        {"emoji": "🥤", "name": "可乐", "cal": 140, "label": "气泡快乐水 🥤",
         "phrases": ["可乐！气泡的快乐！", "冰镇的更爽哦～", "小浣熊也在偷偷喝呢（被发现了）"]},
        {"emoji": "🍵", "name": "抹茶", "cal": 80, "label": "禅意时光 🍵",
         "phrases": ["抹茶！日式美学！", "淡淡的苦味刚刚好～", "静下心来，慢慢品味！"]},
    ],
    "snacks": [
        {"emoji": "🍿", "name": "爆米花", "cal": 180, "label": "影院必备 🍿",
         "phrases": ["爆米花！电影搭档！", "咔嚓咔嚓停不下来～", "小浣熊的追剧神器！"]},
        {"emoji": "🥜", "name": "坚果", "cal": 200, "label": "健康零食 🥜",
         "phrases": ["坚果！天然的能量球！", "不饱和脂肪酸的好处多多的～", "每天一小把，健康又美味！"]},
        {"emoji": "🍫", "name": "能量棒", "cal": 220, "label": "便携能量站 ⚡",
         "phrases": ["能量棒！随时补充能量！", "运动后的最佳搭档～", "小浣熊的外出必备！"]},
    ],
}

# 随机关怀语料
RANDOM_CARE = [
    "好久没见你来了，想我了没？🦝",
    "今天也要好好吃饭哦～",
    "小浣熊在这里一直陪着你！",
    "记得多喝水，身体棒棒的！💧",
    "不要太累了，偶尔休息一下也是必要的～",
    "你已经很努力了，给自己一个大大的拥抱！",
    "小浣熊相信你，一切都会好起来的！✨",
    "保持好心情，这是最重要的事～",
]


# ========== Quad-Agent 并行协作系统 ==========

class QuadAgentCoordinator:
    """
    四智能体协调器：
    1. Vision-Agent - 视觉识别
    2. Logic-Agent - 逻辑计算
    3. Persona-Agent - 人格对话
    4. Animator-Agent - 动画参数
    """
    
    @staticmethod
    async def analyze_meal(image_base64: str) -> Dict:
        """
        并行执行四个 Agent 的任务
        """
        # 并行执行所有 Agent
        results = await asyncio.gather(
            QuadAgentCoordinator.vision_agent(image_base64),
            QuadAgentCoordinator.logic_agent(),
            QuadAgentCoordinator.persona_agent(),
            QuadAgentCoordinator.animator_agent(),
        )
        
        vision, logic, persona, animator = results
        
        return {
            **vision,  # 食物信息
            **logic,  # 计算结果
            "phrases": persona["phrases"],  # 对话语料
            "animation_params": animator,   # 动画参数
        }
    
    @staticmethod
    async def vision_agent(image_base64: str) -> Dict:
        """
        Vision-Agent: 视觉识别
        模拟：从图片中识别食物（实际需要接 AI 视觉模型）
        """
        await asyncio.sleep(0.1)  # 模拟处理时间
        
        # 随机选择一种食物
        category = random.choice(list(CORPUS.keys()))
        food = random.choice(CORPUS[category])
        
        return {
            "food_name": food["name"],
            "emoji": food["emoji"],
            "calories": food["cal"],
            "anxiety_label": food["label"],
        }
    
    @staticmethod
    async def logic_agent() -> Dict:
        """
        Logic-Agent: 逻辑计算
        计算奖励、营养平衡等
        """
        await asyncio.sleep(0.1)
        
        # 基础奖励
        return {
            "coins_earned": 10 + random.randint(5, 15),
            "xp_earned": random.randint(10, 30),
            "nutrition_balance": random.uniform(-0.3, 0.3),
        }
    
    @staticmethod
    async def persona_agent() -> Dict:
        """
        Persona-Agent: 人格对话
        根据时间和上下文生成个性化回复
        """
        await asyncio.sleep(0.1)
        
        hour = datetime.now().hour
        
        # 根据时间选择不同语料
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
        else:
            # 从语料库随机选
            category = random.choice(list(CORPUS.keys()))
            food = random.choice(CORPUS[category])
            phrases = food["phrases"]
        
        return {
            "phrases": phrases,
            "selected_phrase": random.choice(phrases),
        }
    
    @staticmethod
    async def animator_agent() -> Dict:
        """
        Animator-Agent: 动画参数
        根据上下文生成动画参数
        """
        await asyncio.sleep(0.05)
        
        return {
            "animation_type": random.choice(["spin", "bounce", "jump", "hug"]),
            "emotion": random.choice(["happy", "excited", "loved"]),
            "duration_ms": random.randint(800, 1500),
        }


# ========== API 端点 ==========

@app.get("/")
async def root():
    return {"message": "Aura-Pet API", "version": "1.0.0"}


@app.get("/health")
async def health():
    return {"status": "ok", "redis": redis_client is not None}


# ========== 餐食分析 ==========

@app.post("/api/v1/meal/analyze")
async def analyze_meal(request: MealAnalysisRequest):
    """
    Quad-Agent 并行分析餐食
    """
    result = await QuadAgentCoordinator.analyze_meal(request.image)
    return result


@app.post("/api/v1/pet/feed")
async def feed_pet(meal: MealRecord):
    """
    记录喂食，更新宠物状态
    """
    # 获取当前状态
    state = await _get_pet_state()
    
    # 更新状态
    state["coins"] += meal.coins_earned
    state["xp"] += meal.xp_earned
    state["meals_today"] += 1
    state["streak"] += 1
    state["fullness"] = min(100, state["fullness"] + meal.calories // 20)
    
    # 检查升级
    if state["xp"] >= state["xp_to_next"]:
        state["level"] += 1
        state["xp"] = state["xp"] - state["xp_to_next"]
        state["xp_to_next"] = int(state["xp_to_next"] * 1.5)
    
    # 保存状态
    await _save_pet_state(state)
    
    return state


# ========== 宠物状态 ==========

@app.get("/api/v1/pet/state")
async def get_pet_state():
    """获取宠物状态"""
    return await _get_pet_state()


@app.post("/api/v1/pet/coins")
async def add_coins(body: dict):
    """添加金币"""
    amount = body.get("amount", 0)
    state = await _get_pet_state()
    state["coins"] += amount
    await _save_pet_state(state)
    return {"coins": state["coins"]}


@app.post("/api/v1/pet/water")
async def add_water(body: dict):
    """添加饮水量"""
    amount = body.get("amount", 250)
    state = await _get_pet_state()
    state["water_intake"] = min(state["water_goal"], state["water_intake"] + amount)
    
    if state["water_intake"] >= state["water_goal"]:
        state["joy"] = min(100, state["joy"] + 10)
        state["coins"] += 5
    
    await _save_pet_state(state)
    return state


# ========== 商店 ==========

@app.get("/api/v1/shop/items")
async def get_shop_items():
    """获取商店物品"""
    return {
        "items": [
            {"id": "glasses_1", "name": "圆框眼镜", "emoji": "👓", "category": "accessories", "price": 100, "description": "文艺小清新"},
            {"id": "glasses_2", "name": "墨镜", "emoji": "🕶️", "category": "accessories", "price": 200, "description": "酷酷的"},
            {"id": "bow_1", "name": "粉色蝴蝶结", "emoji": "🎀", "category": "accessories", "price": 150, "description": "可爱满分"},
            {"id": "bg_1", "name": "莫奈花园", "emoji": "🌸", "category": "backgrounds", "price": 300, "description": "睡莲池畔"},
            {"id": "bg_2", "name": "星空", "emoji": "✨", "category": "backgrounds", "price": 250, "description": "银河璀璨"},
            {"id": "bg_3", "name": "海洋", "emoji": "🌊", "category": "backgrounds", "price": 280, "description": "波光粼粼"},
            {"id": "hat_1", "name": "小浣熊帽子", "emoji": "🎩", "category": "accessories", "price": 180, "description": "同款！"},
            {"id": "scarf_1", "name": "格子围巾", "emoji": "🧣", "category": "accessories", "price": 120, "description": "英伦风"},
        ]
    }


@app.post("/api/v1/shop/purchase")
async def purchase_item(body: dict):
    """购买物品"""
    item_id = body.get("itemId")
    state = await _get_pet_state()
    
    # 简化实现
    return {"success": True, "coins": state["coins"]}


@app.post("/api/v1/shop/equip")
async def equip_item(body: dict):
    """装备物品"""
    item_id = body.get("itemId")
    state = await _get_pet_state()
    state["equipped_item"] = item_id
    await _save_pet_state(state)
    return {"success": True}


# ========== Redis 辅助 ==========

async def _get_pet_state() -> Dict:
    """从 Redis 获取宠物状态"""
    if redis_client:
        try:
            data = await redis_client.get("pet_state")
            if data:
                return json.loads(data)
        except Exception:
            pass
    return PetState().dict()

async def _save_pet_state(state: Dict):
    """保存宠物状态到 Redis"""
    if redis_client:
        try:
            await redis_client.set("pet_state", json.dumps(state))
        except Exception:
            pass


# ========== WebSocket ==========

class ConnectionManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def broadcast(self, message: str):
        for connection in self.active_connections:
            await connection.send_text(message)

manager = ConnectionManager()

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_text()
            # 处理消息并广播
            await manager.broadcast(data)
    except WebSocketDisconnect:
        manager.disconnect(websocket)


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
