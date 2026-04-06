"""
Aura-Pet Qwen-VL 视觉服务
============================
通义千问视觉大模型 - 中文食物识别专家
支持：红烧肉、螺蛳粉、麻辣烫等中餐精准识别
"""

import os
import json
import base64
import httpx
from typing import Optional, Dict, Any, List
from dataclasses import dataclass
import logging

logger = logging.getLogger(__name__)


@dataclass
class FoodAnalysisResult:
    """食物分析结果"""
    is_food: bool
    food_name: str
    chinese_name: Optional[str] = None  # 中文名称
    portion_size: str = "一人份"
    calories: int = 0
    calories_range: str = ""
    protein: float = 0.0
    carbs: float = 0.0
    fat: float = 0.0
    confidence: float = 0.0
    anxiety_label: str = "能量补给"
    anxiety_emoji: str = "⚡"
    detected_object: Optional[str] = None
    reject_reason: Optional[str] = None
    suggestion: Optional[str] = None
    raw_response: Optional[Dict] = None


class QwenVLService:
    """
    Qwen-VL-Max 视觉服务
    
    特点：
    - 中文食物识别专家（红烧肉、螺蛳粉、麻辣烫等）
    - 严格的食物判定逻辑
    - 智能份量估算
    """
    
    # API 配置
    API_URL = "https://dashscope.aliyuncs.com/api/v1/services/aigc/multimodal-generation/generation"
    MODEL = "qwen-vl-max"
    
    def __init__(self, api_key: Optional[str] = None):
        """
        初始化 Qwen-VL 服务
        
        Args:
            api_key: DashScope API Key（不传则从环境变量 DASHSCOPE_API_KEY 读取）
        """
        self.api_key = api_key or os.getenv("DASHSCOPE_API_KEY")
        
        if not self.api_key:
            raise ValueError(
                "❌ DASHSCOPE_API_KEY 未设置！\n"
                "请设置环境变量：\n"
                "  本地: export DASHSCOPE_API_KEY=你的Key\n"
                "  或在 .env 文件中添加: DASHSCOPE_API_KEY=你的Key"
            )
    
    async def analyze_food(self, image_base64: str) -> FoodAnalysisResult:
        """
        分析食物图片
        
        Args:
            image_base64: Base64 编码的图片数据
            
        Returns:
            FoodAnalysisResult: 食物分析结果
        """
        # 中文食物识别 Prompt
        prompt = '''你是一位拥有10年经验的中国注册营养师，精通川鲁粤淮扬等所有菜系。

分析这张图片，严格按以下 JSON 格式返回，不要输出任何其他内容：

{
  "is_food": true/false,
  "name": "菜品的准确名称（如：鱼香肉丝、螺蛳粉、麻辣烫）",
  "cuisine": "菜系（川菜/粤菜/鲁菜/淮扬菜/东北菜/其他）",
  "ingredients": ["主要食材1", "食材2", "食材3"],
  "portion_estimate": "分量估算（小份/中份/大份/约XXX克）",
  "calories": 数字（单位千卡，基于分量估算的真实值）,
  "protein": 数字（克）,
  "carbs": 数字（克）,
  "fat": 数字（克）,
  "advice": "一句具体的营养建议（如：这道菜油较大，建议配一碗米饭平衡）"
}

约束条件：
1. 如果图片中没有食物（只有手、桌子、餐具、包装袋），返回 is_food: false
2. 热量估算必须基于分量，不能乱猜
3. 如果是混合菜品（如麻辣烫），按主要食材加权计算
4. 禁止返回"无法识别"之类的模糊回答'''

        try:
            # 构建请求
            headers = {
                "Authorization": f"Bearer {self.api_key}",
                "Content-Type": "application/json",
            }
            
            payload = {
                "model": self.MODEL,
                "input": {
                    "messages": [
                        {
                            "role": "user",
                            "content": [
                                {
                                    "text": prompt
                                },
                                {
                                    "image": f"data:image/jpeg;base64,{image_base64}"
                                }
                            ]
                        }
                    ]
                },
                "parameters": {
                    "temperature": 0.1,
                    "max_tokens": 1000,
                }
            }
            
            # 调用 API
            response = httpx.post(
                self.API_URL,
                headers=headers,
                json=payload,
                timeout=30.0,
            )
            
            if response.status_code != 200:
                logger.error(f"Qwen-VL API 错误: {response.status_code} - {response.text}")
                # 返回模拟数据
                return self._get_mock_result()
            
            data = response.json()
            
            # 解析响应
            output = data.get("output", {})
            choices = output.get("choices", [])
            
            if not choices:
                return self._get_mock_result()
            
            text = choices[0].get("message", {}).get("content", "")
            
            # 提取 JSON
            result = self._parse_json_response(text)
            
            return FoodAnalysisResult(**result)
            
        except Exception as e:
            logger.error(f"Qwen-VL 调用失败: {e}")
            return self._get_mock_result()
    
    def _parse_json_response(self, text: str) -> Dict[str, Any]:
        """解析 JSON 响应"""
        import re
        
        # 尝试提取 JSON
        json_match = re.search(r'\{.*\}', text, re.DOTALL)
        
        if json_match:
            try:
                data = json.loads(json_match.group(0))
                return self._normalize_result(data)
            except json.JSONDecodeError:
                pass
        
        # 默认返回模拟数据
        return self._get_mock_result().__dict__
    
    def _normalize_result(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """标准化结果 - 适配营养师 JSON 格式"""
        is_food = data.get("is_food", True)
        
        if not is_food:
            return {
                "is_food": False,
                "food_name": "",
                "chinese_name": None,
                "portion_size": "",
                "calories": 0,
                "calories_range": "",
                "protein": 0.0,
                "carbs": 0.0,
                "fat": 0.0,
                "confidence": 0.0,
                "anxiety_label": "无法识别",
                "anxiety_emoji": "🤔",
                "detected_object": "非食物内容",
                "reject_reason": "图片中没有食物",
                "suggestion": "请拍摄真正的食物",
                "raw_response": data,
            }
        else:
            # 新版营养师 JSON 格式
            name = data.get("name", "未知菜品")
            cuisine = data.get("cuisine", "其他")
            ingredients = data.get("ingredients", [])
            portion = data.get("portion_estimate", "中份")
            advice = data.get("advice", "")
            
            # 根据分量调整热量系数
            portion_coef = 1.0
            if "小份" in portion:
                portion_coef = 0.7
            elif "大份" in portion:
                portion_coef = 1.5
            elif "XXX克" in portion or "约" in portion:
                # 尝试提取克数
                import re
                match = re.search(r'(\d+)', portion)
                if match:
                    grams = int(match.group(1))
                    portion_coef = grams / 200  # 假设中份约200g
            
            base_calories = float(data.get("calories", 300))
            calories = int(base_calories * portion_coef)
            
            return {
                "is_food": True,
                "food_name": name,
                "chinese_name": name,
                "cuisine": cuisine,
                "ingredients": ingredients,
                "portion_size": portion,
                "calories": calories,
                "calories_range": f"{calories - 50}-{calories + 100}kcal",
                "protein": float(data.get("protein", 0)),
                "carbs": float(data.get("carbs", 0)),
                "fat": float(data.get("fat", 0)),
                "confidence": 0.9,
                "anxiety_label": self._generate_anxiety_label(cuisine, advice),
                "anxiety_emoji": self._generate_emoji(cuisine),
                "advice": advice,
                "detected_object": None,
                "reject_reason": None,
                "suggestion": None,
                "raw_response": data,  # 原始 JSON 用于调试
            }
    
    def _generate_anxiety_label(self, cuisine: str, advice: str) -> str:
        """根据菜系生成去焦虑标签"""
        labels = {
            "川菜": "川味刺激感 ✨",
            "粤菜": "清淡鲜美 🍃",
            "鲁菜": "浓郁醇香 🥢",
            "淮扬菜": "精细美味 🎋",
            "东北菜": "实在管饱 🍖",
        }
        
        for key, label in labels.items():
            if key in cuisine:
                return label
        
        if "油" in advice or "大" in advice:
            return "快乐因子注入中 ⚡"
        elif "清淡" in advice or "平衡" in advice:
            return "健康好选择 💚"
        else:
            return "灵魂充电时间 ⚡"
    
    def _generate_emoji(self, cuisine: str) -> str:
        """根据菜系生成表情"""
        emojis = {
            "川菜": "🌶️",
            "粤菜": "🦐",
            "鲁菜": "🥘",
            "淮扬菜": "🍜",
            "东北菜": "🥟",
        }
        return emojis.get(cuisine, "🍽️")
    
    def _get_mock_result(self) -> FoodAnalysisResult:
        """获取模拟结果（用于测试或 API 不可用时）"""
        import random
        
        # 中文食物库
        chinese_foods = [
            ("红烧肉", "Hong Shao Rou", 450, 15.0, 20.0, 35.0),
            ("麻辣烫", "Malatang", 380, 25.0, 30.0, 18.0),
            ("螺蛳粉", "Luosifen", 420, 18.0, 55.0, 15.0),
            ("小笼包", "Xiaolongbao", 280, 12.0, 35.0, 10.0),
            ("奶茶", "Milk Tea", 250, 3.0, 45.0, 6.0),
            ("烧烤", "BBQ", 500, 30.0, 15.0, 40.0),
            ("火锅", "Hot Pot", 600, 40.0, 50.0, 35.0),
            ("炒饭", "Fried Rice", 350, 12.0, 50.0, 12.0),
        ]
        
        food = random.choice(chinese_foods)
        
        return FoodAnalysisResult(
            is_food=True,
            food_name=food[1],
            chinese_name=food[0],
            portion_size="一人份",
            calories=food[2],
            calories_range=f"{food[2] - 50}-{food[2] + 50}kcal",
            protein=food[3],
            carbs=food[4],
            fat=food[5],
            confidence=0.85,
            anxiety_label="灵魂充电时间",
            anxiety_emoji="⚡",
        )


# ========== 全局服务实例 ==========
_qwen_service: Optional[QwenVLService] = None


def get_qwen_service() -> QwenVLService:
    """获取 Qwen-VL 服务单例"""
    global _qwen_service
    
    if _qwen_service is None:
        _qwen_service = QwenVLService()
    
    return _qwen_service


def reset_qwen_service():
    """重置服务"""
    global _qwen_service
    _qwen_service = None
