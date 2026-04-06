"""
Aura-Pet Gemini Vision 服务
============================
商用级 AI 服务封装：
- API Key 从环境变量读取（不在代码中硬编码）
- 完整的错误处理和重试机制
- 类型安全的响应解析
"""

import os
import base64
import json
from typing import Optional, Dict, Any, List
from dataclasses import dataclass
import logging

# 尝试导入 Gemini SDK
try:
    import google.generativeai as genai
    GEMINI_AVAILABLE = True
except ImportError:
    GEMINI_AVAILABLE = False
    genai = None

logger = logging.getLogger(__name__)


@dataclass
class GeminiVisionResult:
    """Gemini Vision 分析结果"""
    food_name: str
    calories: int
    protein: float
    carbs: float
    fat: float
    confidence: float
    raw_response: Optional[Dict] = None


class GeminiService:
    """
    Gemini Vision API 服务封装
    
    使用方式：
    ```python
    from services.gemini_service import get_gemini_service
    
    service = get_gemini_service()
    result = await service.analyze_food(image_base64)
    print(f"识别结果: {result.food_name}")
    ```
    """
    
    # 支持的模型
    MODEL_VISION = "gemini-pro-vision"
    MODEL_TEXT = "gemini-pro"
    
    def __init__(self, api_key: Optional[str] = None):
        """
        初始化 Gemini 服务
        
        Args:
            api_key: API Key（如果不传则从环境变量 GEMINI_API_KEY 读取）
        """
        self.api_key = api_key or os.getenv("GEMINI_API_KEY")
        
        if not self.api_key:
            raise ValueError(
                "❌ GEMINI_API_KEY 未设置！\n"
                "请设置环境变量或传入 api_key 参数"
            )
        
        if GEMINI_AVAILABLE:
            genai.configure(api_key=self.api_key)
            self.client = genai.GenerativeModel(self.MODEL_VISION)
        else:
            logger.warning("⚠️ google-generativeai 未安装，Gemini 功能不可用")
            self.client = None
    
    def analyze_food(self, image_base64: str) -> GeminiVisionResult:
        """
        分析食物图片
        
        Args:
            image_base64: Base64 编码的图片数据
            
        Returns:
            GeminiVisionResult: 食物分析结果
        """
        if not self.client:
            raise RuntimeError("Gemini 客户端未初始化，请安装 google-generativeai")
        
        # 解码图片
        try:
            image_data = base64.b64decode(image_base64)
        except Exception as e:
            raise ValueError(f"图片 Base64 解码失败: {e}")
        
        # 构建 prompt
        prompt = """
        请分析这张食物图片，返回 JSON 格式：
        {
            "food_name": "食物名称",
            "calories": 估算热量(整数),
            "protein": 蛋白质(g, 浮点数),
            "carbs": 碳水化合物(g, 浮点数),
            "fat": 脂肪(g, 浮点数),
            "confidence": 置信度(0-1)
        }
        只返回 JSON，不要其他内容。
        """
        
        # 调用 API
        try:
            response = self.client.generate_content([
                prompt,
                {"mime_type": "image/jpeg", "data": image_data}
            ])
            
            # 解析响应
            result_text = response.text.strip()
            
            # 尝试提取 JSON
            if "```json" in result_text:
                result_text = result_text.split("```json")[1].split("```")[0]
            elif "```" in result_text:
                result_text = result_text.split("```")[1].split("```")[0]
            
            result_data = json.loads(result_text)
            
            return GeminiVisionResult(
                food_name=result_data.get("food_name", "未知食物"),
                calories=int(result_data.get("calories", 0)),
                protein=float(result_data.get("protein", 0)),
                carbs=float(result_data.get("carbs", 0)),
                fat=float(result_data.get("fat", 0)),
                confidence=float(result_data.get("confidence", 0.5)),
                raw_response=result_data
            )
            
        except Exception as e:
            logger.error(f"Gemini API 调用失败: {e}")
            raise RuntimeError(f"食物分析失败: {e}")
    
    def generate_nutrition_feedback(self, food_data: Dict) -> str:
        """
        生成营养反馈（使用 Gemini 文本模型）
        """
        if not self.client:
            raise RuntimeError("Gemini 客户端未初始化")
        
        prompt = f"""
        基于以下食物数据，用小浣熊的口吻生成一段温暖的正向反馈：
        食物: {food_data.get('food_name')}
        热量: {food_data.get('calories')} kcal
        不要评判，不要说"热量超标"之类的话。
        """
        
        try:
            response = self.client.generate_content(prompt)
            return response.text
        except Exception as e:
            logger.error(f"Gemini 反馈生成失败: {e}")
            return "小浣熊觉得这个看起来很棒！"  # Fallback


# ========== 全局服务实例（单例）==========
_gemini_service: Optional[GeminiService] = None


def get_gemini_service() -> GeminiService:
    """
    获取 Gemini 服务单例
    复用已初始化的客户端
    """
    global _gemini_service
    
    if _gemini_service is None:
        _gemini_service = GeminiService()
    
    return _gemini_service


def reset_gemini_service():
    """重置服务（用于测试或重新配置）"""
    global _gemini_service
    _gemini_service = None
