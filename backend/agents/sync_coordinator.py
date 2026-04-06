"""
Aura-Pet Multi-Agent Coordination System
四智能体同步架构 - BitePal Parity

Quad-Agent Sync:
1. Vision-Agent: 食物识别 & 多模型校验
2. Logic-Agent: 奖励计算 & 数据更新
3. Persona-Agent: 情感反馈 & 对话生成
4. Animator-Agent: 动画触发 & 物理引擎

⚠️ 安全注意：API Keys 通过环境变量管理，绝不硬编码！
"""

from __future__ import annotations
import asyncio
import json
import os
import random
import uuid
from dataclasses import dataclass, field, asdict
from datetime import datetime
from enum import Enum
from typing import Optional, List, Dict, Any
from concurrent.futures import ThreadPoolExecutor

# ========== 安全：导入配置模块 ==========
try:
    from config import get_settings, require_gemini_key, get_optional_gemini_key
except ImportError:
    # 如果 config.py 不存在，使用内置方式
    def get_settings():
        class Settings:
            gemini_api_key = os.getenv("GEMINI_API_KEY")
        return Settings()
    
    def require_gemini_key():
        key = os.getenv("GEMINI_API_KEY")
        if not key:
            raise ValueError("GEMINI_API_KEY 环境变量未设置！")
        return key
    
    def get_optional_gemini_key():
        return os.getenv("GEMINI_API_KEY")

# ========== 尝试导入 Gemini SDK ==========
GEMINI_AVAILABLE = False
try:
    import google.generativeai as genai
    GEMINI_AVAILABLE = True
except ImportError:
    genai = None
    print("⚠️ google-generativeai 未安装，Gemini 功能将使用模拟模式")

# ============================================
# DATA CLASSES
# ============================================

class FoodCategory(Enum):
    PROTEIN = "protein"
    CARB = "carb"
    VEGETABLE = "vegetable"
    FRUIT = "fruit"
    DESSERT = "dessert"
    DRINK = "drink"
    SNACK = "snack"

class PetMood(Enum):
    HAPPY = "happy"
    NEUTRAL = "neutral"
    SAD = "sad"
    EXCITED = "excited"
    SLEEPY = "sleepy"
    DIZZY = "dizzy"

class AnimationTrigger(Enum):
    SPIN = "spin"
    JUMP = "jump"
    BOUNCE = "bounce"
    SHAKE = "shake"
    HUG = "hug"
    CLAP = "clap"
    SLEEP = "sleep"
    DIZZY = "dizzy"
    IDLE = "idle"

@dataclass
class VisionResult:
    """Vision Agent 输出"""
    food_name: str
    estimated_calories: int
    estimated_protein: float
    estimated_carbs: float
    estimated_fat: float
    category: FoodCategory
    color_palette: List[str]  # 主导色调
    confidence: float  # 0-1
    anxiety_relief_label: str
    anxiety_relief_emoji: str

@dataclass
class RewardResult:
    """Logic Agent 输出"""
    coins_earned: int
    xp_earned: int
    new_balance: int
    streak_continued: bool
    bonus_multiplier: float

@dataclass
class PersonaResponse:
    """Persona Agent 输出"""
    pet_action: str  # "小浣熊开心地转圈"
    dialogue: str
    emoji: str
    animation_trigger: AnimationTrigger
    emotion_update: PetMood

@dataclass
class AnimationCommand:
    """Animator Agent 输出"""
    animation_type: str
    spring_config: Dict[str, float]  # 弹簧物理参数
    duration_ms: int
    particle_effect: Optional[str] = None
    sound_effect: Optional[str] = None

@dataclass
class MealEvent:
    """完整的事件对象，在四个 Agent 间流转"""
    event_id: str
    timestamp: datetime
    
    # Input
    image_base64: Optional[str] = None
    image_url: Optional[str] = None
    
    # Vision Result
    vision_result: Optional[VisionResult] = None
    
    # Logic Result
    reward_result: Optional[RewardResult] = None
    
    # Persona Result
    persona_response: Optional[PersonaResponse] = None
    
    # Animation
    animation_command: Optional[AnimationCommand] = None
    
    # Status
    status: str = "pending"
    error: Optional[str] = None

# ============================================
# VISION AGENT (多模型校验)
# ============================================

class VisionAgent:
    """
    AI 视觉识别 Agent
    - 调用 GPT-4o + Gemini 双模型
    - 交叉验证结果
    - 去罪化标签生成
    """
    
    # 去焦虑标签映射
    ANXIETY_RELIEF_TEMPLATES = {
        FoodCategory.DESSERT: [
            {"label": "灵魂充电时间", "emoji": "⚡", "color": "#FFD700"},
            {"label": "快乐因子注入中", "emoji": "💫", "color": "#FF69B4"},
            {"label": "尊享犒劳时刻", "emoji": "👑", "color": "#FF1493"},
            {"label": "甜蜜小确幸", "emoji": "🌸", "color": "#FFB6C1"},
        ],
        FoodCategory.SNACK: [
            {"label": "心情助推器启动", "emoji": "🚀", "color": "#FF6347"},
            {"label": "庆典模式开启", "emoji": "🎉", "color": "#FF1493"},
            {"label": "放纵许可生效", "emoji": "✨", "color": "#FFD700"},
        ],
        FoodCategory.CARB: [
            {"label": "碳水安慰拥抱", "emoji": "🤗", "color": "#DEB887"},
            {"label": "能量储备充足", "emoji": "🔋", "color": "#F0E68C"},
        ],
        FoodCategory.PROTEIN: [
            {"label": "力量积攒中", "emoji": "💪", "color": "#FF6B6B"},
            {"label": "肌肉燃料补给", "emoji": "🏋️", "color": "#FFA07A"},
        ],
        FoodCategory.VEGETABLE: [
            {"label": "绿色能量满格", "emoji": "🌿", "color": "#90EE90"},
            {"label": "营养堡垒建设", "emoji": "🏰", "color": "#32CD32"},
        ],
        FoodCategory.FRUIT: [
            {"label": "大自然糖果", "emoji": "🍬", "color": "#FFA500"},
            {"label": "维C炸弹来袭", "emoji": "💣", "color": "#FF4500"},
        ],
        FoodCategory.DRINK: [
            {"label": "水分祝福达成", "emoji": "💧", "color": "#87CEEB"},
            {"label": "咖啡因伙伴上线", "emoji": "☕", "color": "#8B4513"},
        ],
    }
    
    def __init__(self):
        self.name = "VisionAgent"
    
    async def analyze(self, image_data: str) -> VisionResult:
        """
        多模型分析入口
        模拟实际 GPT-4o + Gemini 调用
        """
        # 并发调用双模型
        gpt4o_task = self._call_gpt4o(image_data)
        gemini_task = self._call_gemini(image_data)
        
        gpt4o_result, gemini_result = await asyncio.gather(
            gpt4o_task, gemini_task
        )
        
        # 交叉验证
        final_result = self._cross_validate(gpt4o_result, gemini_result)
        
        # 生成去焦虑标签
        anxiety_label = self._generate_anxiety_relief(final_result)
        
        return VisionResult(
            food_name=final_result["food_name"],
            estimated_calories=final_result["calories"],
            estimated_protein=final_result["protein"],
            estimated_carbs=final_result["carbs"],
            estimated_fat=final_result["fat"],
            category=final_result["category"],
            color_palette=final_result["colors"],
            confidence=final_result["confidence"],
            anxiety_relief_label=anxiety_label["label"],
            anxiety_relief_emoji=anxiety_label["emoji"]
        )
    
    async def _call_gpt4o(self, image_data: str) -> Dict[str, Any]:
        """
        模拟 GPT-4o Vision API
        """
        # 实际项目中调用 OpenAI Vision API
        await asyncio.sleep(0.1)  # 模拟延迟
        
        # 模拟识别结果
        return {
            "food_name": "芝士蛋糕",
            "calories": 420,
            "protein": 8.5,
            "carbs": 45.0,
            "fat": 22.0,
            "category": FoodCategory.DESSERT,
            "colors": ["#F5DEB3", "#FFD700", "#8B4513"],  # 奶油色调
            "confidence": 0.92
        }
    
    async def _call_gemini(self, image_data: str) -> Dict[str, Any]:
        """
        调用 Gemini Vision API
        
        ⚠️ API Key 从环境变量读取，绝不在代码中硬编码！
        """
        gemini_key = get_optional_gemini_key()
        
        if not gemini_key:
            # 没有 API Key 时使用模拟数据
            print("⚠️ 未配置 GEMINI_API_KEY，使用模拟数据")
            return await self._mock_gemini(image_data)
        
        if not GEMINI_AVAILABLE:
            print("⚠️ google-generativeai 未安装，使用模拟数据")
            return await self._mock_gemini(image_data)
        
        try:
            # 配置 Gemini（使用环境变量的 Key）
            genai.configure(api_key=gemini_key)
            model = genai.GenerativeModel('gemini-pro-vision')
            
            # 准备图片数据
            image_bytes = self._decode_base64_image(image_data)
            
            # 调用 API
            response = model.generate_content([
                "分析这张食物图片，返回JSON格式："
                '{"food_name":"名称","calories":热量,"protein":蛋白质,"carbs":碳水,"fat":脂肪,"confidence":置信度}',
                {"mime_type": "image/jpeg", "data": image_bytes}
            ])
            
            # 解析响应
            result_text = response.text.strip()
            if "```json" in result_text:
                result_text = result_text.split("```json")[1].split("```")[0]
            
            result = json.loads(result_text)
            
            print(f"✓ Gemini 识别: {result.get('food_name')} ({result.get('calories')} kcal)")
            
            return {
                "food_name": result.get("food_name", "奶酪蛋糕"),
                "calories": int(result.get("calories", 400)),
                "protein": float(result.get("protein", 7.8)),
                "carbs": float(result.get("carbs", 43.0)),
                "fat": float(result.get("fat", 21.0)),
                "category": FoodCategory.DESSERT,
                "colors": ["#FFFACD", "#FFD700", "#A0522D"],
                "confidence": float(result.get("confidence", 0.88))
            }
            
        except Exception as e:
            print(f"⚠️ Gemini API 调用失败: {e}，使用模拟数据")
            return await self._mock_gemini(image_data)
    
    async def _mock_gemini(self, image_data: str) -> Dict[str, Any]:
        """
        模拟 Gemini Vision API（当无 API Key 时使用）
        """
        await asyncio.sleep(0.1)  # 模拟延迟
        
        return {
            "food_name": "奶酪蛋糕",
            "calories": 400,
            "protein": 7.8,
            "carbs": 43.0,
            "fat": 21.0,
            "category": FoodCategory.DESSERT,
            "colors": ["#FFFACD", "#FFD700", "#A0522D"],
            "confidence": 0.88
        }
    
    def _decode_base64_image(self, image_data: str) -> bytes:
        """
        解码 Base64 图片数据
        """
        import base64
        # 处理 data URI 格式
        if "," in image_data:
            image_data = image_data.split(",", 1)[1]
        return base64.b64decode(image_data)
    
    def _cross_validate(self, r1: Dict, r2: Dict) -> Dict[str, Any]:
        """
        交叉验证双模型结果
        取加权平均值
        """
        confidence_weight = r1["confidence"] / (r1["confidence"] + r2["confidence"])
        
        return {
            "food_name": r1["food_name"] if r1["confidence"] >= r2["confidence"] else r2["food_name"],
            "calories": int(r1["calories"] * confidence_weight + r2["calories"] * (1 - confidence_weight)),
            "protein": round(r1["protein"] * confidence_weight + r2["protein"] * (1 - confidence_weight), 1),
            "carbs": round(r1["carbs"] * confidence_weight + r2["carbs"] * (1 - confidence_weight), 1),
            "fat": round(r1["fat"] * confidence_weight + r2["fat"] * (1 - confidence_weight), 1),
            "category": r1["category"],  # 使用置信度更高的模型结果
            "colors": list(set(r1["colors"] + r2["colors"]))[:5],  # 合并去重
            "confidence": (r1["confidence"] + r2["confidence"]) / 2
        }
    
    def _generate_anxiety_relief(self, result: Dict) -> Dict[str, str]:
        """
        生成去罪化标签
        Calorie-to-Energy 转换逻辑
        """
        category = result["category"]
        calories = result["calories"]
        
        # 高热量食物 -> 正向标签
        if calories > 500:
            templates = self.ANXIETY_RELIEF_TEMPLATES.get(category, [])
            selected = random.choice(templates) if templates else {"label": "能量补给", "emoji": "⚡", "color": "#FFD700"}
        elif calories > 300:
            templates = self.ANXIETY_RELIEF_TEMPLATES.get(category, [])
            selected = random.choice(templates) if templates else {"label": "心情加油", "emoji": "💪", "color": "#FF6B6B"}
        else:
            selected = {"label": "健康之选", "emoji": "✨", "color": "#90EE90"}
        
        return selected

# ============================================
# LOGIC AGENT (奖励 & 数据更新)
# ============================================

class LogicAgent:
    """
    逻辑计算 Agent
    - 奖励金币/XP计算
    - streak管理
    - 数据持久化
    """
    
    BASE_COINS = 10
    BASE_XP = 15
    STREAK_BONUS_COINS = 5
    STREAK_BONUS_XP = 5
    
    CALORIE_TIERS = [
        (0, 200, 1.0),
        (200, 400, 1.2),  # 中等热量额外奖励
        (400, 600, 1.5),  # 高热量不惩罚，反而奖励（去罪化）
        (600, 9999, 2.0),  # 超高热量额外奖励（心理疏导）
    ]
    
    def __init__(self):
        self.name = "LogicAgent"
    
    async def calculate_rewards(
        self, 
        vision_result: VisionResult,
        current_streak: int,
        current_balance: int
    ) -> RewardResult:
        """
        计算奖励
        """
        # 基础奖励
        coins = self.BASE_COINS
        xp = self.BASE_XP
        
        # 热量倍率
        calorie_multiplier = 1.0
        for low, high, mult in self.CALORIE_TIERS:
            if low <= vision_result.estimated_calories < high:
                calorie_multiplier = mult
                break
        
        # Streak 奖励
        streak_bonus = current_streak > 0
        
        # 计算最终奖励
        final_coins = int(coins * calorie_multiplier) + (self.STREAK_BONUS_COINS if streak_bonus else 0)
        final_xp = int(xp * calorie_multiplier) + (self.STREAK_BONUS_XP if streak_bonus else 0)
        
        # 特殊标签额外奖励
        if "灵魂充电" in vision_result.anxiety_relief_label or "犒劳" in vision_result.anxiety_relief_label:
            final_coins += 5  # 额外奖励选择"善待自己"的用户
        
        return RewardResult(
            coins_earned=final_coins,
            xp_earned=final_xp,
            new_balance=current_balance + final_coins,
            streak_continued=streak_bonus,
            bonus_multiplier=calorie_multiplier
        )
    
    async def update_pet_stats(self, pet_state: Dict, reward: RewardResult) -> Dict:
        """
        更新宠物五维数值
        """
        new_state = pet_state.copy()
        
        # 基于奖励更新数值
        new_state["joy"] = min(100, pet_state.get("joy", 50) + int(reward.coins_earned / 2))
        new_state["affinity"] = min(100, pet_state.get("affinity", 0) + 1)
        new_state["evolution_xp"] = pet_state.get("evolution_xp", 0) + reward.xp_earned
        
        # 特殊动画触发
        if reward.bonus_multiplier >= 2.0:
            new_state["current_mood"] = PetMood.EXCITED
        elif reward.bonus_multiplier >= 1.5:
            new_state["current_mood"] = PetMood.HAPPY
        else:
            new_state["current_mood"] = PetMood.NEUTRAL
        
        # 检查进化
        if new_state["evolution_xp"] >= new_state.get("next_evolution_threshold", 100):
            new_state["evolution_level"] = new_state.get("evolution_level", 1) + 1
            new_state["evolution_xp"] = 0
            new_state["next_evolution_threshold"] = new_state["evolution_level"] * 100
        
        return new_state

# ============================================
# PERSONA AGENT (情感 & 对话生成)
# ============================================

class PersonaAgent:
    """
    角色情感 Agent
    - 宠物个性管理
    - 去焦虑对话生成
    - 拟人化点评
    """
    
    # 去焦虑对话语料库
    CONVERSATION_CORPUS = {
        (FoodCategory.DESSERT, "high"): [
            {
                "action": "小浣熊兴奋地原地转圈⭕",
                "dialogue": "哇！！是你最爱的甜点诶！！生活已经这么苦了当然要对自己好一点呀～🍰✨",
                "emoji": "😍",
                "trigger": AnimationTrigger.SPIN
            },
            {
                "action": "小浣熊眼睛亮晶晶地盯着",
                "dialogue": "嘿嘿这个看起来也太美味了吧！知道吗，吃甜食会释放快乐多巴胺哦～这是科学认证的！💕",
                "emoji": "🤤",
                "trigger": AnimationTrigger.BOUNCE
            },
            {
                "action": "小浣熊给你一个大大的拥抱",
                "dialogue": "想吃就吃呀～今天的卡路里明天再算！现在的快乐最重要！🤗💗",
                "emoji": "🫂",
                "trigger": AnimationTrigger.HUG
            }
        ],
        (FoodCategory.VEGETABLE, "any"): [
            {
                "action": "小浣熊竖起大拇指👍",
                "dialogue": "蔬菜侠出击！今天的你又在为身体健康加油啦～继续保持呀！🌿💪",
                "emoji": "🥬",
                "trigger": AnimationTrigger.JUMP
            },
            {
                "action": "小浣熊认真地点点头",
                "dialogue": "均衡饮食，智慧选择！你的身体正在悄悄感谢你呢～💚",
                "emoji": "✨",
                "trigger": AnimationTrigger.IDLE
            }
        ],
        (FoodCategory.CARB, "any"): [
            {
                "action": "小浣熊元气满满地蹦跶",
                "dialogue": "碳水是力量的源泉呀！吃饱了才有力气追逐梦想嘛～🍚⚡",
                "emoji": "🐰",
                "trigger": AnimationTrigger.BOUNCE
            },
            {
                "action": "小浣熊温柔地蹭蹭你",
                "dialogue": "晚餐的碳水是温暖的陪伴～好好享受这份满足感吧！🌙💕",
                "emoji": "🌙",
                "trigger": AnimationTrigger.HUG
            }
        ],
        "default": [
            {
                "action": "小浣熊开心地摇尾巴",
                "dialogue": "记录本身就是自律的表现呀！你已经在好好照顾自己了！👏💖",
                "emoji": "🎉",
                "trigger": AnimationTrigger.CLAP
            },
            {
                "action": "小浣熊微笑点头",
                "dialogue": "每一餐都是爱自己的表现～今天的你很棒呢！💝",
                "emoji": "😊",
                "trigger": AnimationTrigger.IDLE
            }
        ]
    }
    
    def __init__(self):
        self.name = "PersonaAgent"
    
    async def generate_response(
        self,
        vision_result: VisionResult,
        reward_result: RewardResult,
        pet_state: Dict
    ) -> PersonaResponse:
        """
        生成情感反馈
        """
        # 查找匹配的语料
        key = (vision_result.category, "high" if vision_result.estimated_calories > 400 else "any")
        corpus = self.CONVERSATION_CORPUS.get(key, self.CONVERSATION_CORPUS["default"])
        
        # 高奖励时优先选激动类语料
        if reward_result.bonus_multiplier >= 2.0:
            corpus = [c for c in corpus if c["trigger"] in [AnimationTrigger.SPIN, AnimationTrigger.EXCITED]]
            if not corpus:
                corpus = self.CONVERSATION_CORPUS.get(key, self.CONVERSATION_CORPUS["default"])
        
        # 随机选一条
        selected = random.choice(corpus)
        
        # 个性化修改（基于宠物状态）
        if pet_state.get("affinity", 0) > 50:
            selected["dialogue"] += f"\n\n（悄悄话：我们越来越有默契了呢～）"
        
        return PersonaResponse(
            pet_action=selected["action"],
            dialogue=selected["dialogue"],
            emoji=selected["emoji"],
            animation_trigger=selected["trigger"],
            emotion_update=PetMood.HAPPY if reward_result.bonus_multiplier >= 1.5 else PetMood.NEUTRAL
        )
    
    def generate_humor_comment(self, vision_result: VisionResult) -> str:
        """
        生成幽默点评
        """
        comments = []
        
        # 基于食物类型
        if vision_result.category == FoodCategory.DESSERT:
            comments.append("今天的糖分指数爆表呢～小浣熊表示：这很OK！")
        elif vision_result.category == FoodCategory.VEGETABLE:
            comments.append("绿色力量注入！小浣熊想问问：能不能分我一片叶子？🥬")
        elif vision_result.category == FoodCategory.DRINK:
            comments.append("水分补给完成！小浣熊表示想干杯～☕")
        
        # 基于颜色
        if "#FFD700" in vision_result.color_palette:  # 金色
            comments.append("检测到金色元素！今天的你很贵气呀～👑")
        if "#FF69B4" in vision_result.color_palette:  # 粉色
            comments.append("满满的少女心！小浣熊被甜到了～💕")
        
        return random.choice(comments) if comments else ""

# ============================================
# ANIMATOR AGENT (动画 & 物理引擎)
# ============================================

class AnimatorAgent:
    """
    动画 Agent
    - Spring Physics 弹簧物理
    - 触控反馈
    - 粒子特效
    """
    
    SPRING_CONFIGS = {
        AnimationTrigger.SPIN: {
            "mass": 1.0,
            "stiffness": 180,
            "damping": 12,
            "duration": 2000
        },
        AnimationTrigger.JUMP: {
            "mass": 1.2,
            "stiffness": 200,
            "damping": 15,
            "duration": 600
        },
        AnimationTrigger.BOUNCE: {
            "mass": 0.8,
            "stiffness": 150,
            "damping": 8,
            "duration": 800
        },
        AnimationTrigger.HUG: {
            "mass": 1.5,
            "stiffness": 100,
            "damping": 20,
            "duration": 1000
        },
        AnimationTrigger.DIZZY: {
            "mass": 0.5,
            "stiffness": 50,
            "damping": 3,
            "duration": 3000
        }
    }
    
    PARTICLE_EFFECTS = {
        AnimationTrigger.SPIN: "sparkle",
        AnimationTrigger.JUMP: "confetti",
        AnimationTrigger.BOUNCE: "hearts",
        AnimationTrigger.HUG: "warm_glow",
        AnimationTrigger.CLAP: "star_burst"
    }
    
    def __init__(self):
        self.name = "AnimatorAgent"
    
    def generate_animation(
        self,
        trigger: AnimationTrigger,
        intensity: float = 1.0
    ) -> AnimationCommand:
        """
        生成动画命令
        """
        spring_config = self.SPRING_CONFIGS.get(trigger, self.SPRING_CONFIGS[AnimationTrigger.BOUNCE])
        
        # 根据强度调整
        adjusted_config = {
            "mass": spring_config["mass"],
            "stiffness": spring_config["stiffness"] * (1 + (intensity - 0.5) * 0.2),
            "damping": spring_config["damping"] * (1 - (intensity - 0.5) * 0.1),
            "duration": int(spring_config["duration"] * (1 + (1 - intensity) * 0.3))
        }
        
        return AnimationCommand(
            animation_type=trigger.value,
            spring_config=adjusted_config,
            duration_ms=adjusted_config["duration"],
            particle_effect=self.PARTICLE_EFFECTS.get(trigger),
            sound_effect=self._get_sound_for_trigger(trigger)
        )
    
    def generate_touch_feedback(
        self,
        touch_type: str,  # "head_pat", "poke_belly", "shake"
        pet_mood: PetMood
    ) -> AnimationCommand:
        """
        生成触控反馈动画
        """
        touch_animations = {
            "head_pat": AnimationTrigger.BOUNCE,
            "poke_belly": AnimationTrigger.DIZZY,
            "shake": AnimationTrigger.SPIN
        }
        
        trigger = touch_animations.get(touch_type, AnimationTrigger.BOUNCE)
        
        return self.generate_animation(trigger, intensity=0.8)
    
    def _get_sound_for_trigger(self, trigger: AnimationTrigger) -> str:
        """
        触发音效映射
        """
        sound_map = {
            AnimationTrigger.SPIN: "sparkle_chime",
            AnimationTrigger.JUMP: "boing",
            AnimationTrigger.BOUNCE: "pop",
            AnimationTrigger.HUG: "warm_melody",
            AnimationTrigger.CLAP: "tada"
        }
        return sound_map.get(trigger, "ui_click")

# ============================================
# SYNC COORDINATOR (四智能体协调器)
# ============================================

class SyncCoordinator:
    """
    四智能体同步协调器
    
    核心流程:
    1. Vision-Agent: 识别食物 + 多模型校验
    2. Logic-Agent: 计算奖励 + 更新数据
    3. Persona-Agent: 生成情感反馈 + 对话
    4. Animator-Agent: 生成动画命令
    """
    
    def __init__(self):
        self.vision_agent = VisionAgent()
        self.logic_agent = LogicAgent()
        self.persona_agent = PersonaAgent()
        self.animator_agent = AnimatorAgent()
        
        self.executor = ThreadPoolExecutor(max_workers=4)
    
    async def process_meal_event(
        self,
        image_data: str,
        user_state: Dict
    ) -> MealEvent:
        """
        处理餐食拍照事件
        完整四 Agent 协同流程
        """
        event = MealEvent(
            event_id=str(uuid.uuid4()),
            timestamp=datetime.now(),
            image_base64=image_data
        )
        
        try:
            # ========================================
            # PHASE 1: Vision (并发)
            # ========================================
            print(f"[SyncCoordinator] Phase 1: Vision Agent analyzing...")
            vision_result = await self.vision_agent.analyze(image_data)
            event.vision_result = vision_result
            print(f"[SyncCoordinator] ✓ Detected: {vision_result.food_name} ({vision_result.estimated_calories}kcal)")
            print(f"[SyncCoordinator] ✓ Anxiety Relief: {vision_result.anxiety_relief_label}")
            
            # ========================================
            # PHASE 2: Logic (依赖 Vision)
            # ========================================
            print(f"[SyncCoordinator] Phase 2: Logic Agent calculating rewards...")
            reward_result = await self.logic_agent.calculate_rewards(
                vision_result=vision_result,
                current_streak=user_state.get("current_streak", 0),
                current_balance=user_state.get("bitecoins", 0)
            )
            event.reward_result = reward_result
            print(f"[SyncCoordinator] ✓ Coins earned: +{reward_result.coins_earned}")
            print(f"[SyncCoordinator] ✓ XP earned: +{reward_result.xp_earned}")
            print(f"[SyncCoordinator] ✓ Streak continued: {reward_result.streak_continued}")
            
            # 更新宠物状态
            pet_state = user_state.get("pet_state", {})
            new_pet_state = await self.logic_agent.update_pet_stats(pet_state, reward_result)
            
            # ========================================
            # PHASE 3: Persona (依赖 Vision + Logic)
            # ========================================
            print(f"[SyncCoordinator] Phase 3: Persona Agent generating response...")
            persona_response = await self.persona_agent.generate_response(
                vision_result=vision_result,
                reward_result=reward_result,
                pet_state=new_pet_state
            )
            event.persona_response = persona_response
            print(f"[SyncCoordinator] ✓ Pet action: {persona_response.pet_action}")
            print(f"[SyncCoordinator] ✓ Dialogue: {persona_response.dialogue[:50]}...")
            
            # 额外幽默点评
            humor = self.persona_agent.generate_humor_comment(vision_result)
            print(f"[SyncCoordinator] ✓ Humor: {humor[:50]}...")
            
            # ========================================
            # PHASE 4: Animator (依赖 Persona)
            # ========================================
            print(f"[SyncCoordinator] Phase 4: Animator Agent generating animation...")
            animation_cmd = self.animator_agent.generate_animation(
                trigger=persona_response.animation_trigger,
                intensity=min(1.0, reward_result.bonus_multiplier / 2.0)
            )
            event.animation_command = animation_cmd
            print(f"[SyncCoordinator] ✓ Animation: {animation_cmd.animation_type}")
            print(f"[SyncCoordinator] ✓ Spring config: mass={animation_cmd.spring_config['mass']}, stiffness={animation_cmd.spring_config['stiffness']}")
            print(f"[SyncCoordinator] ✓ Particles: {animation_cmd.particle_effect}")
            
            # 完成
            event.status = "completed"
            print(f"[SyncCoordinator] ✓ Event {event.event_id} completed successfully!")
            
        except Exception as e:
            event.status = "failed"
            event.error = str(e)
            print(f"[SyncCoordinator] ✗ Error: {e}")
        
        return event
    
    def process_touch_interaction(
        self,
        touch_type: str,
        pet_state: Dict
    ) -> AnimationCommand:
        """
        处理触控交互
        """
        current_mood = PetMood(pet_state.get("current_mood", "neutral"))
        return self.animator_agent.generate_touch_feedback(touch_type, current_mood)

# ============================================
# DEMO EXECUTION
# ============================================

async def demo_cheesecake_flow():
    """
    演示：用户拍摄"芝士蛋糕"时的四 Agent 协同流程
    """
    print("\n" + "="*60)
    print("🦝 Aura-Pet 四智能体协同演示")
    print("="*60)
    print("\n场景：用户拍摄了一张芝士蛋糕照片\n")
    
    coordinator = SyncCoordinator()
    
    # 模拟用户状态
    user_state = {
        "user_id": "user_001",
        "display_name": "小明",
        "bitecoins": 150,
        "current_streak": 5,  # 连续5天记录
        "pet_state": {
            "name": "小浣熊",
            "species": "raccoon",
            "hunger": 70,
            "joy": 80,
            "vigor": 65,
            "affinity": 45,
            "evolution_xp": 120,
            "evolution_level": 2,
            "current_mood": "happy"
        }
    }
    
    # 模拟图片数据（实际会是 base64）
    fake_image_data = "data:image/jpeg;base64,/9j/4AAQ..."
    
    # 执行四 Agent 协同
    event = await coordinator.process_meal_event(fake_image_data, user_state)
    
    # 输出最终结果
    print("\n" + "="*60)
    print("📋 最终输出汇总")
    print("="*60)
    
    print(f"""
🎯 Vision Agent 结果:
   • 食物: {event.vision_result.food_name}
   • 热量: {event.vision_result.estimated_calories} kcal
   • 色调: {event.vision_result.color_palette}
   • 置信度: {event.vision_result.confidence:.2%}
   • 去焦虑标签: {event.vision_result.anxiety_relief_label} {event.vision_result.anxiety_relief_emoji}

💰 Logic Agent 结果:
   • 获得金币: +{event.reward_result.coins_earned}
   • 获得XP: +{event.reward_result.xp_earned}
   • 新余额: {event.reward_result.new_balance}
   • Streak: {'✓ 继续' if event.reward_result.streak_continued else '✗ 中断'}
   • 倍率: {event.reward_result.bonus_multiplier}x

💬 Persona Agent 结果:
   • 动作: {event.persona_response.pet_action}
   • 对话: {event.persona_response.dialogue}
   • 动画: {event.persona_response.animation_trigger.value}

🎬 Animator Agent 结果:
   • 动画类型: {event.animation_command.animation_type}
   • 弹簧参数: mass={event.animation_command.spring_config['mass']}, stiffness={event.animation_command.spring_config['stiffness']}
   • 粒子特效: {event.animation_command.particle_effect}
   • 音效: {event.animation_command.sound_effect}
""")
    
    return event

if __name__ == "__main__":
    asyncio.run(demo_cheesecake_flow())
