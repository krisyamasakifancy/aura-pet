"""
Aura-Pet Quad-Agent 食物识别与宠物动画系统
============================================

架构：
  Vision-Agent   → 识别食物，返回结构化数据
  Logic-Agent    → 计算营养/热量，决定宠物状态
  Persona-Agent  → 生成宠物对话/反馈
  Animator-Agent → 计算动画参数，触发宠物动作

Author: Aura-Pet Team
"""

import asyncio
import uuid
import random
from datetime import datetime
from typing import Optional, List
from dataclasses import dataclass, field, asdict
from enum import Enum

from fastapi import FastAPI, HTTPException, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import httpx


# ============================================================
# 数据模型
# ============================================================

class MealType(str, Enum):
    BREAKFAST = "breakfast"
    LUNCH = "lunch"
    DINNER = "dinner"
    SNACK = "snack"


class PetMood(str, Enum):
    SLEEPING = "sleeping"
    EATING = "eating"
    HAPPY = "happy"
    EXCITED = "excited"
    SAD = "sad"
    TIRED = "tired"
    SWIMMING = "swimming"
    DANCING = "dancing"


class AnimationType(str, Enum):
    WAVE = "wave"
    JUMP = "jump"
    SPIN = "spin"
    BOUNCE = "bounce"
    HUG = "hug"
    HEART_EYES = "heart_eyes"
    EATING = "eating"
    SLEEPING = "sleeping"
    SWIMMING = "swimming"
    DANCING = "dancing"


@dataclass
class FoodData:
    """Vision-Agent 输出的食物数据结构"""
    food_id: str
    name: str
    emoji: str
    calories: int
    protein_g: float
    carbs_g: float
    fat_g: float
    fiber_g: float = 0
    portion_size: str = "1份"
    portion_grams: float = 100
    confidence: float = 0.95
    aura_score: int = 0  # 0-100


@dataclass
class NutritionAnalysis:
    """Logic-Agent 输出的营养分析"""
    daily_calories: int
    daily_goal: int
    calorie_remaining: int
    calorie_deficit: int  # 负数表示超了
    protein_status: str  # "low" / "ok" / "high"
    carbs_status: str
    fat_status: str
    balance_score: float  # 0.0 - 1.0
    feedback: str
    recommendations: List[str] = field(default_factory=list)


@dataclass
class PetStateUpdate:
    """Animator-Agent 输出的宠物状态更新"""
    mood: PetMood
    happiness_delta: int
    xp_gained: int
    coins_earned: int
    animation: AnimationType
    animation_duration_ms: int
    size_delta: float  # 进食后体型的微小变化
    trigger_message: str  # 宠物说的话
    evolution_progress: float = 0  # 进化进度 0-100%


@dataclass
class MealLogResult:
    """最终输出的完整结果"""
    meal_id: str
    food: FoodData
    nutrition: NutritionAnalysis
    pet_state: PetStateUpdate
    timestamp: str


# ============================================================
# Vision-Agent: 食物识别
# ============================================================

class VisionAgent:
    """
    负责识别食物图像，返回结构化数据
    在实际部署时，这里会调用 OpenAI/Gemini Vision API
    """
    
    # 食物数据库（演示用）
    FOOD_DATABASE = {
        "apple": {"name": "苹果", "emoji": "🍎", "calories": 52, "protein": 0.3, "carbs": 14, "fat": 0.2},
        "banana": {"name": "香蕉", "emoji": "🍌", "calories": 89, "protein": 1.1, "carbs": 23, "fat": 0.3},
        "chicken_breast": {"name": "鸡胸肉", "emoji": "🍗", "calories": 165, "protein": 31, "carbs": 0, "fat": 3.6},
        "rice": {"name": "米饭", "emoji": "🍚", "calories": 130, "protein": 2.7, "carbs": 28, "fat": 0.3},
        "broccoli": {"name": "西兰花", "emoji": "🥦", "calories": 34, "protein": 2.8, "carbs": 7, "fat": 0.4},
        "egg": {"name": "鸡蛋", "emoji": "🥚", "calories": 78, "protein": 6, "carbs": 0.6, "fat": 5},
        "salmon": {"name": "三文鱼", "emoji": "🍣", "calories": 208, "protein": 20, "carbs": 0, "fat": 13},
        "salad": {"name": "沙拉", "emoji": "🥗", "calories": 45, "protein": 2, "carbs": 8, "fat": 1},
        "burger": {"name": "汉堡", "emoji": "🍔", "calories": 295, "protein": 15, "carbs": 24, "fat": 14},
        "pizza": {"name": "披萨", "emoji": "🍕", "calories": 266, "protein": 11, "carbs": 33, "fat": 10},
        "noodles": {"name": "面条", "emoji": "🍜", "calories": 220, "protein": 6, "carbs": 40, "fat": 3},
        "steak": {"name": "牛排", "emoji": "🥩", "calories": 271, "protein": 26, "carbs": 0, "fat": 18},
    }
    
    async def analyze(self, image_bytes: bytes, user_id: str) -> FoodData:
        """
        分析食物图像
        实际实现会调用 Vision API，这里用随机选择演示
        """
        # 模拟 Vision API 调用延迟
        await asyncio.sleep(0.5)
        
        # 随机选择一种食物（演示用）
        import random
        food_key = random.choice(list(self.FOOD_DATABASE.keys()))
        food_info = self.FOOD_DATABASE[food_key]
        
        # 计算 Aura 评分（基于营养平衡）
        aura_score = self._calculate_aura_score(food_info)
        
        return FoodData(
            food_id=str(uuid.uuid4()),
            name=food_info["name"],
            emoji=food_info["emoji"],
            calories=food_info["calories"],
            protein_g=food_info["protein"],
            carbs_g=food_info["carbs"],
            fat_g=food_info["fat"],
            portion_size="1份",
            portion_grams=100,
            confidence=random.uniform(0.85, 0.99),
            aura_score=aura_score
        )
    
    def _calculate_aura_score(self, food_info: dict) -> int:
        """计算 Aura 评分"""
        score = 70  # 基础分
        
        # 高蛋白加分
        if food_info["protein"] >= 15:
            score += 15
        elif food_info["protein"] >= 5:
            score += 8
        
        # 适量碳水
        if food_info["carbs"] <= 30:
            score += 10
        elif food_info["carbs"] > 50:
            score -= 10
        
        # 低脂肪加分
        if food_info["fat"] <= 5:
            score += 10
        elif food_info["fat"] > 15:
            score -= 15
        
        # 蔬菜/健康食物加分
        healthy_foods = ["broccoli", "salad", "apple"]
        if any(k in food_info.get("name", "").lower() for k in ["西兰花", "沙拉", "苹果"]):
            score += 10
        
        return min(100, max(0, score))


# ============================================================
# Logic-Agent: 营养计算
# ============================================================

class LogicAgent:
    """
    负责计算营养、热量缺口、营养平衡
    """
    
    # 黄金分割比例（用于判断营养平衡）
    GOLDEN_RATIO_PROTEIN = 0.30  # 蛋白质 30% 热量
    GOLDEN_RATIO_CARBS = 0.45    # 碳水 45% 热量
    GOLDEN_RATIO_FAT = 0.25       # 脂肪 25% 热量
    
    async def analyze(
        self,
        food: FoodData,
        user_id: str,
        user_profile: dict
    ) -> NutritionAnalysis:
        """
        分析食物对用户今日营养的影响
        """
        # 获取用户每日目标
        daily_goal = user_profile.get("daily_calorie_goal", 2000)
        protein_goal = user_profile.get("daily_protein_goal_g", 60)
        carbs_goal = user_profile.get("daily_carbs_goal_g", 250)
        fat_goal = user_profile.get("daily_fat_goal_g", 65)
        
        # 模拟获取用户今日已摄入
        # 实际应从数据库查询
        daily_calories = 800  # 演示用
        
        # 计算
        new_daily_calories = daily_calories + food.calories
        calorie_remaining = daily_goal - new_daily_calories
        calorie_deficit = new_daily_calories - daily_goal
        
        # 计算营养状态
        protein_status = self._check_status(food.protein_g, protein_goal / 3, protein_goal / 2)
        carbs_status = self._check_status(food.carbs_g, carbs_goal / 3, carbs_goal / 2)
        fat_status = self._check_status(food.fat_g, fat_goal / 3, fat_goal / 2)
        
        # 计算平衡分数
        balance_score = self._calculate_balance_score(
            food.protein_g, food.carbs_g, food.fat_g
        )
        
        # 生成反馈
        feedback, recommendations = self._generate_feedback(
            food, protein_status, carbs_status, fat_status, balance_score
        )
        
        return NutritionAnalysis(
            daily_calories=new_daily_calories,
            daily_goal=daily_goal,
            calorie_remaining=calorie_remaining,
            calorie_deficit=calorie_deficit,
            protein_status=protein_status,
            carbs_status=carbs_status,
            fat_status=fat_status,
            balance_score=balance_score,
            feedback=feedback,
            recommendations=recommendations
        )
    
    def _check_status(self, value: float, low: float, high: float) -> str:
        """检查营养状态"""
        if value < low:
            return "low"
        elif value > high:
            return "high"
        return "ok"
    
    def _calculate_balance_score(self, protein: float, carbs: float, fat: float) -> float:
        """计算营养平衡分数"""
        # 计算总热量
        total_cal = protein * 4 + carbs * 4 + fat * 9
        if total_cal == 0:
            return 0.5
        
        # 计算实际比例
        protein_ratio = (protein * 4) / total_cal
        carbs_ratio = (carbs * 4) / total_cal
        fat_ratio = (fat * 9) / total_cal
        
        # 与黄金分割比较
        protein_diff = abs(protein_ratio - self.GOLDEN_RATIO_PROTEIN)
        carbs_diff = abs(carbs_ratio - self.GOLDEN_RATIO_CARBS)
        fat_diff = abs(fat_ratio - self.GOLDEN_RATIO_FAT)
        
        # 计算分数（差异越小分数越高）
        score = 1 - (protein_diff + carbs_diff + fat_diff) / 3
        return max(0, min(1, score))
    
    def _generate_feedback(
        self,
        food: FoodData,
        protein_status: str,
        carbs_status: str,
        fat_status: str,
        balance_score: float
    ) -> tuple[str, List[str]]:
        """生成营养反馈"""
        feedback_parts = []
        recommendations = []
        
        # 基于 Aura 评分反馈
        if food.aura_score >= 85:
            feedback_parts.append("太棒了！✨")
        elif food.aura_score >= 70:
            feedback_parts.append("不错的搭配！")
        elif food.aura_score >= 50:
            feedback_parts.append("还可以哦～")
        else:
            feedback_parts.append("下次试试更均衡的选择？")
        
        # 蛋白质反馈
        if protein_status == "low":
            feedback_parts.append(f"{food.emoji} 蛋白质偏少")
            recommendations.append("可以加个鸡蛋或鸡胸肉 🥚")
        elif protein_status == "high":
            feedback_parts.append(f"{food.emoji} 蛋白质丰富")
        
        # 碳水反馈
        if carbs_status == "high":
            feedback_parts.append("碳水较多")
            recommendations.append("今晚可以少吃点主食 🍚")
        
        # 脂肪反馈
        if fat_status == "high":
            feedback_parts.append("油脂有点多")
            recommendations.append("下次选低脂版本 🫒")
        
        # 平衡分数
        if balance_score >= 0.8:
            feedback_parts.append("营养比例完美！⚖️")
        elif balance_score < 0.5:
            recommendations.append("试试更均衡的搭配 ⚖️")
        
        feedback = " ".join(feedback_parts)
        return feedback, recommendations


# ============================================================
# Persona-Agent: 宠物人格
# ============================================================

class PersonaAgent:
    """
    负责生成宠物的对话和反馈
    """
    
    MOOD_MESSAGES = {
        PetMood.HAPPY: [
            "好香呀！🐻",
            "看起来好好吃！",
            "主人吃得好健康～",
            "小熊也想吃！🤤",
        ],
        PetMood.EXCITED: [
            "哇！最喜欢这个了！🎉",
            "好开心呀！小熊最爱了！",
            "主人最棒了！✨",
        ],
        PetMood.SAD: [
            "这个...不太健康哦 😢",
            "小熊有点担心...",
            "下次选更健康的吧～",
        ],
        PetMood.EATING: [
            "吧唧吧唧～🍽️",
            "好好味！😋",
            "小熊替你尝一口～",
        ],
        "heart_eyes": [
            "爱你哟！❤️",
            "主人最懂吃了！💕",
            "小熊感动哭！🥹",
        ],
    }
    
    async def generate_message(
        self,
        food: FoodData,
        nutrition: NutritionAnalysis,
        current_mood: PetMood = PetMood.HAPPY
    ) -> str:
        """根据食物和营养分析生成宠物消息"""
        import random
        
        # 确定最终心情
        if food.aura_score >= 85:
            mood = PetMood.EXCITED
        elif food.aura_score >= 60:
            mood = PetMood.HAPPY
        else:
            mood = PetMood.SAD
        
        # 选择消息
        messages = self.MOOD_MESSAGES.get(mood, self.MOOD_MESSAGES[PetMood.HAPPY])
        base_message = random.choice(messages)
        
        # 添加营养提示
        if nutrition.recommendations:
            rec = random.choice(nutrition.recommendations)
            return f"{base_message} {rec}"
        
        return base_message


# ============================================================
# Animator-Agent: 动画控制
# ============================================================

class AnimatorAgent:
    """
    负责计算宠物动画参数和状态变化
    """
    
    # 动画时长配置
    ANIMATION_DURATIONS = {
        AnimationType.EATING: 2000,
        AnimationType.JUMP: 1500,
        AnimationType.SPIN: 1200,
        AnimationType.BOUNCE: 1800,
        AnimationType.HEART_EYES: 2500,
        AnimationType.DANCING: 3000,
        AnimationType.HUG: 2000,
    }
    
    async def calculate_state_update(
        self,
        food: FoodData,
        nutrition: NutritionAnalysis,
        current_pet_state: dict
    ) -> PetStateUpdate:
        """
        计算宠物状态更新
        """
        import random
        
        # 确定动画类型
        animation = self._choose_animation(food.aura_score, nutrition.balance_score)
        
        # 计算经验值奖励
        xp_gained = self._calculate_xp(food, nutrition)
        
        # 计算金币奖励
        coins_earned = self._calculate_coins(nutrition)
        
        # 计算心情变化
        happiness_delta = self._calculate_happiness_delta(food.aura_score, nutrition.balance_score)
        
        # 计算体型变化（非常微小）
        size_delta = food.calories / 100000  # 每100卡路里增加0.001
        
        # 计算进化进度
        evolution_progress = self._calculate_evolution_progress(
            current_pet_state.get("current_xp", 0),
            current_pet_state.get("xp_to_next_level", 100),
            xp_gained
        )
        
        # 确定心情
        mood = self._choose_mood(food.aura_score, nutrition.balance_score)
        
        # 获取动画时长
        duration = self.ANIMATION_DURATIONS.get(animation, 2000)
        
        return PetStateUpdate(
            mood=mood,
            happiness_delta=happiness_delta,
            xp_gained=xp_gained,
            coins_earned=coins_earned,
            animation=animation,
            animation_duration_ms=duration,
            size_delta=size_delta,
            trigger_message="",  # 后续由 Persona-Agent 填充
            evolution_progress=evolution_progress
        )
    
    def _choose_animation(self, aura_score: int, balance_score: float) -> AnimationType:
        """选择动画"""
        import random
        
        if aura_score >= 85 and balance_score >= 0.8:
            return AnimationType.HEART_EYES
        elif aura_score >= 70:
            return random.choice([AnimationType.JUMP, AnimationType.BOUNCE, AnimationType.DANCING])
        elif aura_score >= 50:
            return AnimationType.EATING
        else:
            return AnimationType.SPIN
    
    def _calculate_xp(self, food: FoodData, nutrition: NutritionAnalysis) -> int:
        """计算获得的经验值"""
        base_xp = 10
        
        # Aura 高分加成
        if food.aura_score >= 85:
            base_xp += 20
        elif food.aura_score >= 70:
            base_xp += 10
        
        # 营养平衡加成
        if nutrition.balance_score >= 0.8:
            base_xp += 15
        elif nutrition.balance_score >= 0.6:
            base_xp += 5
        
        # 完整餐次加成
        if nutrition.protein_status == "ok" and nutrition.carbs_status == "ok" and nutrition.fat_status == "ok":
            base_xp += 10
        
        return base_xp
    
    def _calculate_coins(self, nutrition: NutritionAnalysis) -> int:
        """计算获得的金币"""
        if nutrition.balance_score >= 0.8:
            return 5
        elif nutrition.balance_score >= 0.6:
            return 2
        return 0
    
    def _calculate_happiness_delta(self, aura_score: int, balance_score: float) -> int:
        """计算心情变化"""
        if aura_score >= 70:
            return random.randint(5, 15)
        elif aura_score >= 50:
            return random.randint(0, 5)
        else:
            return random.randint(-5, 0)
    
    def _calculate_evolution_progress(self, current_xp: int, xp_to_next: int, xp_gained: int) -> float:
        """计算进化进度"""
        new_total = current_xp + xp_gained
        if new_total >= xp_to_next:
            return 100.0  # 触发进化
        return (new_total / xp_to_next) * 100
    
    def _choose_mood(self, aura_score: int, balance_score: float) -> PetMood:
        """选择宠物心情"""
        if aura_score >= 85:
            return PetMood.EXCITED
        elif aura_score >= 60:
            return PetMood.HAPPY
        elif aura_score >= 40:
            return PetMood.EATING
        else:
            return PetMood.SAD


# ============================================================
# Quad-Agent 协调器
# ============================================================

class MealQuadAgent:
    """
    Quad-Agent 协调器
    负责并行调用四个 Agent 并协调结果
    """
    
    def __init__(self):
        self.vision = VisionAgent()
        self.logic = LogicAgent()
        self.persona = PersonaAgent()
        self.animator = AnimatorAgent()
    
    async def process_meal(
        self,
        image_bytes: bytes,
        user_id: str,
        user_profile: dict,
        current_pet_state: dict,
        meal_type: MealType = MealType.SNACK
    ) -> MealLogResult:
        """
        处理一餐的完整流程
        
        流程：
        1. Vision-Agent: 识别食物
        2. Logic-Agent: 分析营养
        3. Animator-Agent: 计算宠物状态
        4. Persona-Agent: 生成宠物消息
        """
        # 阶段 1: 并行调用 Vision 和 Logic（无依赖）
        vision_task = asyncio.create_task(
            self.vision.analyze(image_bytes, user_id)
        )
        logic_task = asyncio.create_task(
            self.logic.analyze(
                food=None,  # 暂时传 None，等 vision 完成
                user_id=user_id,
                user_profile=user_profile
            )
        )
        
        # 等待 Vision 完成
        food = await vision_task
        
        # 完成 Logic（此时已有 food 数据）
        logic_task = asyncio.create_task(
            self.logic.analyze(food, user_id, user_profile)
        )
        nutrition = await logic_task
        
        # 阶段 2: 并行调用 Animator 和 Persona（依赖 Vision+Logic 结果）
        animator_task = asyncio.create_task(
            self.animator.calculate_state_update(food, nutrition, current_pet_state)
        )
        persona_task = asyncio.create_task(
            self.persona.generate_message(food, nutrition)
        )
        
        pet_state = await animator_task
        pet_message = await persona_task
        
        # 填充宠物消息
        pet_state.trigger_message = pet_message
        
        # 生成餐次记录 ID
        meal_id = str(uuid.uuid4())
        
        return MealLogResult(
            meal_id=meal_id,
            food=food,
            nutrition=nutrition,
            pet_state=pet_state,
            timestamp=datetime.utcnow().isoformat()
        )
    
    async def process_meal_sequential(
        self,
        image_bytes: bytes,
        user_id: str,
        user_profile: dict,
        current_pet_state: dict
    ) -> MealLogResult:
        """
        顺序执行流程（用于调试）
        """
        # Step 1: Vision
        print("📸 Vision-Agent: 分析食物图像...")
        food = await self.vision.analyze(image_bytes, user_id)
        print(f"   识别结果: {food.name} {food.emoji}")
        
        # Step 2: Logic
        print("🧮 Logic-Agent: 计算营养...")
        nutrition = await self.logic.analyze(food, user_id, user_profile)
        print(f"   热量: {nutrition.daily_calories}/{nutrition.daily_goal} kcal")
        print(f"   平衡分: {nutrition.balance_score:.2f}")
        
        # Step 3: Animator
        print("🎬 Animator-Agent: 计算宠物动画...")
        pet_state = await self.animator.calculate_state_update(
            food, nutrition, current_pet_state
        )
        print(f"   动画: {pet_state.animation.value}")
        print(f"   XP: +{pet_state.xp_gained}")
        
        # Step 4: Persona
        print("💬 Persona-Agent: 生成宠物消息...")
        message = await self.persona.generate_message(food, nutrition)
        pet_state.trigger_message = message
        print(f"   消息: {message}")
        
        return MealLogResult(
            meal_id=str(uuid.uuid4()),
            food=food,
            nutrition=nutrition,
            pet_state=pet_state,
            timestamp=datetime.utcnow().isoformat()
        )


# ============================================================
# FastAPI 应用
# ============================================================

app = FastAPI(title="Aura-Pet Quad-Agent API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 全局 Agent 协调器
quad_agent = MealQuadAgent()


class MealLogRequest(BaseModel):
    user_id: str
    meal_type: MealType = MealType.SNACK
    user_profile: dict = Field(default_factory=lambda: {
        "daily_calorie_goal": 2000,
        "daily_protein_goal_g": 60,
        "daily_carbs_goal_g": 250,
        "daily_fat_goal_g": 65,
    })
    current_pet_state: dict = Field(default_factory=lambda: {
        "current_xp": 0,
        "xp_to_next_level": 100,
        "level": 1,
        "mood": "happy",
    })


class MealLogResponse(BaseModel):
    success: bool
    data: Optional[MealLogResult] = None
    error: Optional[str] = None


@app.get("/")
async def root():
    return {"message": "Aura-Pet Quad-Agent API 🐻", "version": "1.0.0"}


@app.post("/api/v1/meal/log", response_model=MealLogResponse)
async def log_meal(request: MealLogRequest):
    """
    记录一餐
    触发完整 Quad-Agent 流程
    """
    try:
        # 模拟图片数据（实际会从上传的文件读取）
        dummy_image = b"dummy_image_bytes"
        
        # 调用 Quad-Agent
        result = await quad_agent.process_meal(
            image_bytes=dummy_image,
            user_id=request.user_id,
            user_profile=request.user_profile,
            current_pet_state=request.current_pet_state,
            meal_type=request.meal_type
        )
        
        return MealLogResponse(success=True, data=result)
    
    except Exception as e:
        return MealLogResponse(success=False, error=str(e))


@app.post("/api/v1/meal/log-debug", response_model=MealLogResponse)
async def log_meal_debug(request: MealLogRequest):
    """
    调试模式：顺序执行并打印日志
    """
    try:
        dummy_image = b"dummy_image_bytes"
        
        result = await quad_agent.process_meal_sequential(
            image_bytes=dummy_image,
            user_id=request.user_id,
            user_profile=request.user_profile,
            current_pet_state=request.current_pet_state
        )
        
        return MealLogResponse(success=True, data=result)
    
    except Exception as e:
        return MealLogResponse(success=False, error=str(e))


@app.post("/api/v1/meal/upload")
async def upload_meal_image(
    file: UploadFile = File(...),
    user_id: str = "",
    meal_type: MealType = MealType.SNACK
):
    """
    上传食物图片并记录
    """
    try:
        # 读取图片
        image_bytes = await file.read()
        
        # 用户资料（演示用）
        user_profile = {
            "daily_calorie_goal": 2000,
            "daily_protein_goal_g": 60,
            "daily_carbs_goal_g": 250,
            "daily_fat_goal_g": 65,
        }
        
        current_pet_state = {
            "current_xp": 50,
            "xp_to_next_level": 100,
            "level": 1,
            "mood": "happy",
        }
        
        # 处理
        result = await quad_agent.process_meal(
            image_bytes=image_bytes,
            user_id=user_id,
            user_profile=user_profile,
            current_pet_state=current_pet_state,
            meal_type=meal_type
        )
        
        return {
            "success": True,
            "meal_id": result.meal_id,
            "food": asdict(result.food),
            "nutrition": asdict(result.nutrition),
            "pet_state": asdict(result.pet_state),
            "timestamp": result.timestamp
        }
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# ============================================================
# 健康检查
# ============================================================

@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "agents": {
            "vision": "ready",
            "logic": "ready",
            "persona": "ready",
            "animator": "ready"
        }
    }


# ============================================================
# 运行
# ============================================================

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
