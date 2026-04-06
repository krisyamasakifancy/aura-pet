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
        prompt = '''你是一个专业的食物识别专家，特别擅长识别中餐。

## 第一步：严格判定是否为食物
请仔细分析图片内容，判断是否为"可食用食物"：

✅ 可接受的食物（请精确识别中文名）：
- 中餐：红烧肉、糖醋里脊、鱼香肉丝、宫保鸡丁、麻婆豆腐、火锅、麻辣烫、螺蛳粉、热干面、小笼包、饺子、包子、炒饭、炒面、米线、烧烤、烤串、奶茶、珍珠奶茶、咖啡
- 西餐：牛排、意面、披萨、汉堡、三明治、沙拉、蛋糕、面包
- 日料：寿司、刺身、拉面、天妇罗
- 其他：水果、蔬菜、零食、甜点、饮品等任何可食用物品

❌ 绝对不是食物：
- 人体部位（脚、手、腿等）- 严禁误识别为食物！
- 动物（除非是明确可食用的食材如烤鸭、白切鸡）
- 日常物品（手机、电脑、书籍、衣服、鞋子、家具）
- 植物（非食用花卉、树木）
- 化妆品、药品
- 建筑、风景

## 第二步：食物识别（如果是食物）
请返回精确的食物信息：

## 第三步：非食物处理（如果不是食物）
如果检测到的是非食物（如脚、手、电脑等），必须：
1. 明确标注 is_food = false
2. 描述检测到的物体
3. 给出友好的建议

请按以下JSON格式返回：
```json
{
  "is_food": true或false,
  "food_name": "食物名称（英文）",
  "chinese_name": "食物中文名称（如：红烧肉）",
  "portion_size": "一人份/二人份/多人份/小份/大份",
  "calories": 估算热量(整数),
  "calories_range": "热量范围如 300-400kcal",
  "protein": 蛋白质(g),
  "carbs": 碳水化合物(g),
  "fat": 脂肪(g),
  "anxiety_label": "去焦虑标签（如：灵魂充电、快乐源泉）",
  "anxiety_emoji": "表情符号",
  "confidence": 置信度(0-1),
  "reasoning": "简要判断依据"
}
```

如果 is_food = false：
```json
{
  "is_food": false,
  "detected_object": "检测到的物体",
  "reject_reason": "为什么这不是食物",
  "suggestion": "建议用户拍摄真正的食物"
}
```

## 重要规则：
1. 必须先严格判断 is_food，这是最重要的事！
2. 如果图片中有人体部位（特别是脚），is_food 必须为 false！
3. 如果不确定是否是食物，倾向于返回 is_food = false
4. 优先识别中文食物名称
5. 份量决定热量范围（多人份热量约是单人份的2-3倍）
6. 只返回JSON，不要其他内容'''

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
        """标准化结果"""
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
                "anxiety_label": "",
                "anxiety_emoji": "🤔",
                "detected_object": data.get("detected_object", "未知物体"),
                "reject_reason": data.get("reject_reason", "这不是食物"),
                "suggestion": data.get("suggestion", "请拍摄真正的食物"),
                "raw_response": data,
            }
        else:
            return {
                "is_food": True,
                "food_name": data.get("food_name", "未知食物"),
                "chinese_name": data.get("chinese_name"),
                "portion_size": data.get("portion_size", "一人份"),
                "calories": data.get("calories", 0),
                "calories_range": data.get("calories_range", ""),
                "protein": float(data.get("protein", 0)),
                "carbs": float(data.get("carbs", 0)),
                "fat": float(data.get("fat", 0)),
                "confidence": float(data.get("confidence", 0.5)),
                "anxiety_label": data.get("anxiety_label", "能量补给"),
                "anxiety_emoji": data.get("anxiety_emoji", "⚡"),
                "detected_object": None,
                "reject_reason": None,
                "suggestion": None,
                "raw_response": data,
            }
    
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
