#!/usr/bin/env python3
"""
Aura-Pet Quad-Agent 测试脚本

测试 Vision → Logic → Animator + Persona 并行流程

运行方式:
    cd backend
    python3 test_quad_agent.py
"""

import asyncio
import sys
import os

# 添加 backend 目录到路径
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

# 单独测试核心 Agent 模块（不启动 FastAPI）
from agents.meal_quad_agent import MealQuadAgent, MealType, PetMood, AnimationType


async def test_quad_agent():
    """测试 Quad-Agent 完整流程"""
    
    print("=" * 60)
    print("🐻 Aura-Pet Quad-Agent 测试")
    print("=" * 60)
    
    # 创建 Agent 协调器
    quad = MealQuadAgent()
    
    # 模拟数据
    user_id = "test_user_123"
    user_profile = {
        "daily_calorie_goal": 2000,
        "daily_protein_goal_g": 60,
        "daily_carbs_goal_g": 250,
        "daily_fat_goal_g": 65,
    }
    current_pet_state = {
        "current_xp": 45,
        "xp_to_next_level": 100,
        "level": 1,
        "mood": "happy",
    }
    
    print("\n📋 测试数据:")
    print(f"   用户: {user_id}")
    print(f"   每日目标: {user_profile['daily_calorie_goal']} kcal")
    print(f"   宠物等级: {current_pet_state['level']}")
    print()
    
    # 测试 1: 顺序执行（带日志）
    print("-" * 60)
    print("🧪 测试 1: 顺序执行（调试模式）")
    print("-" * 60)
    
    result = await quad.process_meal_sequential(
        image_bytes=b"test_image",
        user_id=user_id,
        user_profile=user_profile,
        current_pet_state=current_pet_state
    )
    
    print("\n📊 结果:")
    print(f"   餐次 ID: {result.meal_id}")
    print(f"   食物: {result.food.emoji} {result.food.name}")
    print(f"   卡路里: {result.food.calories} kcal")
    print(f"   Aura 评分: {result.food.aura_score}")
    print()
    print(f"   今日总热量: {result.nutrition.daily_calories}/{result.nutrition.daily_goal}")
    print(f"   营养平衡: {result.nutrition.balance_score:.2%}")
    print(f"   反馈: {result.nutrition.feedback}")
    print()
    print(f"   宠物心情: {result.pet_state.mood.value}")
    print(f"   动画: {result.pet_state.animation.value}")
    print(f"   XP +: {result.pet_state.xp_gained}")
    print(f"   金币 +: {result.pet_state.coins_earned}")
    print(f"   消息: {result.pet_state.trigger_message}")
    
    # 测试 2: 并行执行（性能测试）
    print("\n" + "-" * 60)
    print("🧪 测试 2: 并行执行（3次）")
    print("-" * 60)
    
    import time
    
    start = time.time()
    tasks = [
        quad.process_meal(
            image_bytes=b"test",
            user_id=f"user_{i}",
            user_profile=user_profile,
            current_pet_state=current_pet_state,
            meal_type=MealType.SNACK
        )
        for i in range(3)
    ]
    results = await asyncio.gather(*tasks)
    elapsed = time.time() - start
    
    print(f"   并行执行耗时: {elapsed:.3f}s")
    print(f"   平均每次: {elapsed/3:.3f}s")
    print()
    print("   结果汇总:")
    for i, r in enumerate(results):
        print(f"   [{i+1}] {r.food.name}: XP+{r.pet_state.xp_gained}, {r.pet_state.trigger_message}")
    
    print("\n" + "=" * 60)
    print("✅ 测试完成!")
    print("=" * 60)


async def test_vision_agent_only():
    """单独测试 Vision Agent"""
    print("\n" + "=" * 60)
    print("📸 Vision-Agent 单独测试")
    print("=" * 60)
    
    from agents.meal_quad_agent import VisionAgent
    
    vision = VisionAgent()
    
    # 测试多次识别
    foods = []
    for i in range(5):
        food = await vision.analyze(b"test_image", "user_test")
        foods.append(food)
        print(f"   [{i+1}] {food.emoji} {food.name}: {food.calories} kcal, Aura={food.aura_score}")
    
    print(f"\n   识别成功率: {len(foods)}/5")


async def test_logic_agent_only():
    """单独测试 Logic Agent"""
    print("\n" + "=" * 60)
    print("🧮 Logic-Agent 单独测试")
    print("=" * 60)
    
    from agents.meal_quad_agent import LogicAgent, FoodData
    
    logic = LogicAgent()
    
    test_foods = [
        FoodData("1", "鸡胸肉", "🍗", 165, 31, 0, 3.6, 0, "100g", 100, 0.95, 0),
        FoodData("2", "汉堡", "🍔", 295, 15, 24, 14, 2, "1个", 150, 0.90, 0),
        FoodData("3", "沙拉", "🥗", 45, 2, 8, 1, 3, "1碗", 120, 0.98, 0),
    ]
    
    user_profile = {
        "daily_calorie_goal": 2000,
        "daily_protein_goal_g": 60,
        "daily_carbs_goal_g": 250,
        "daily_fat_goal_g": 65,
    }
    
    for food in test_foods:
        result = await logic.analyze(food, "test_user", user_profile)
        print(f"\n   {food.emoji} {food.name}:")
        print(f"      热量: {result.daily_calories}/{result.daily_goal} kcal")
        print(f"      平衡分: {result.balance_score:.2%}")
        print(f"      蛋白质: {result.protein_status}")
        print(f"      反馈: {result.feedback}")


async def test_animator_agent():
    """单独测试 Animator Agent"""
    print("\n" + "=" * 60)
    print("🎬 Animator-Agent 单独测试")
    print("=" * 60)
    
    from agents.meal_quad_agent import AnimatorAgent, FoodData, NutritionAnalysis, PetMood
    
    animator = AnimatorAgent()
    
    food = FoodData("1", "苹果", "🍎", 52, 0.3, 14, 0.2, 0, "1个", 100, 0.95, 90)
    nutrition = NutritionAnalysis(
        daily_calories=852, daily_goal=2000, calorie_remaining=1148,
        calorie_deficit=-852, protein_status="low", carbs_status="ok",
        fat_status="ok", balance_score=0.75, feedback="不错！", recommendations=[]
    )
    pet_state = {"current_xp": 50, "xp_to_next_level": 100, "level": 1, "mood": "happy"}
    
    # 测试不同 Aura 评分
    for aura in [95, 75, 55, 35]:
        food.aura_score = aura
        result = await animator.calculate_state_update(food, nutrition, pet_state)
        print(f"   Aura={aura}: {result.animation.value} | XP+{result.xp_gained} | {result.trigger_message}")


async def test_persona_agent():
    """单独测试 Persona Agent"""
    print("\n" + "=" * 60)
    print("💬 Persona-Agent 单独测试")
    print("=" * 60)
    
    from agents.meal_quad_agent import PersonaAgent, FoodData, NutritionAnalysis
    
    persona = PersonaAgent()
    
    food = FoodData("1", "鸡胸肉", "🍗", 165, 31, 0, 3.6, 0, "100g", 100, 0.95, 90)
    nutrition = NutritionAnalysis(
        daily_calories=800, daily_goal=2000, calorie_remaining=1200,
        calorie_deficit=-800, protein_status="ok", carbs_status="ok",
        fat_status="ok", balance_score=0.85, feedback="完美！", recommendations=[]
    )
    
    messages = []
    for _ in range(3):
        msg = await persona.generate_message(food, nutrition)
        messages.append(msg)
    
    print("   生成的宠物消息:")
    for msg in messages:
        print(f"   • {msg}")


async def main():
    """运行所有测试"""
    print("\n" + "🌟" * 30)
    print("Aura-Pet Quad-Agent System Test Suite")
    print("🌟" * 30)
    
    try:
        # 单独测试各 Agent
        await test_vision_agent_only()
        await test_logic_agent_only()
        await test_animator_agent()
        await test_persona_agent()
        
        # 完整流程测试
        await test_quad_agent()
        
        print("\n🎉 所有测试通过!")
        
    except Exception as e:
        print(f"\n❌ 测试失败: {e}")
        import traceback
        traceback.print_exc()


if __name__ == "__main__":
    asyncio.run(main())
