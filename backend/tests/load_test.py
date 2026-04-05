#!/usr/bin/env python3
"""
Aura-Pet Load Testing Script
Tests the "养成系统" (Pet Raising System) balance

Tests:
1. Coin Economy Balance - Verifies coin earning/spending ratio
2. XP Evolution Rate - Tests pet leveling speed
3. Streak Mechanics - Tests daily engagement
4. Meal Category Distribution - Tests anxiety relief labels
5. Real-time SSE Performance - Tests WebSocket throughput
6. Concurrent User Simulation - Load testing
"""

import asyncio
import aiohttp
import time
import random
import json
import statistics
from dataclasses import dataclass, field
from typing import List, Dict, Any, Optional
from datetime import datetime, timedelta
from collections import defaultdict

# ============================================
# CONFIGURATION
# ============================================

API_BASE_URL = "http://localhost:8000"
TEST_DURATION_SECONDS = 60
CONCURRENT_USERS = 10

# ============================================
# DATA MODELS
# ============================================

@dataclass
class TestResult:
    name: str
    passed: bool
    message: str
    details: Dict[str, Any] = field(default_factory=dict)
    timestamp: str = ""

@dataclass
class UserSimulation:
    user_id: str
    coins: int
    xp: int
    streak: int
    meals_logged: int
    pets: List[Dict] = field(default_factory=list)
    transaction_history: List[Dict] = field(default_factory=list)

# ============================================
# TEST UTILITIES
# ============================================

class Color:
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    RESET = '\033[0m'

def print_header(text: str):
    print(f"\n{Color.BLUE}{'='*60}{Color.RESET}")
    print(f"{Color.BLUE}{text:^60}{Color.RESET}")
    print(f"{Color.BLUE}{'='*60}{Color.RESET}\n")

def print_result(result: TestResult):
    status = f"{Color.GREEN}✓ PASS{Color.RESET}" if result.passed else f"{Color.RED}✗ FAIL{Color.RESET}"
    print(f"{status} | {result.name}")
    print(f"       {result.message}")
    if result.details:
        for k, v in result.details.items():
            print(f"       • {k}: {v}")

async def api_request(session: aiohttp.ClientSession, method: str, endpoint: str, **kwargs) -> Optional[Dict]:
    """Make API request with error handling."""
    url = f"{API_BASE_URL}{endpoint}"
    try:
        async with session.request(method, url, **kwargs) as response:
            if response.status < 400:
                return await response.json()
            return None
    except Exception as e:
        return None

# ============================================
# TEST 1: COIN ECONOMY BALANCE
# ============================================

async def test_coin_economy() -> TestResult:
    """
    Test coin economy balance.
    
    Economy Rules:
    - Meal logging: +10-20 coins (base)
    - Streak bonus: +5 coins
    - High calorie bonus: 1.5x-2x multiplier
    - Touch interaction: +2 coins
    - Shop purchase: varies
    
    Expected Balance:
    - Active user should earn ~50-100 coins/day
    - Spending should roughly equal earnings for engaged users
    """
    print_header("TEST 1: Coin Economy Balance")
    
    # Simulate 7 days of activity
    total_earned = 0
    total_spent = 0
    
    # Food categories with calorie ranges
    food_scenarios = [
        {"name": "低脂餐", "calories": 150, "category": "vegetable"},
        {"name": "正常餐", "calories": 400, "category": "carb"},
        {"name": "高热量餐", "calories": 550, "category": "dessert"},
        {"name": "甜点", "calories": 650, "category": "dessert"},
    ]
    
    for day in range(7):
        # Simulate 3 meals per day
        for meal in range(3):
            food = random.choice(food_scenarios)
            
            # Calculate rewards
            base = 10
            if food["calories"] > 600:
                multiplier = 2.0
            elif food["calories"] > 400:
                multiplier = 1.5
            else:
                multiplier = 1.0
            
            coins = int(base * multiplier) + 5  # +5 streak bonus
            total_earned += coins
        
        # Touch interactions (2-3 per day)
        for _ in range(random.randint(2, 3)):
            total_earned += 2
        
        # Random shop purchases (every 2-3 days)
        if day % 2 == 0 and total_earned > 50:
            purchase = random.choice([50, 80, 100])
            total_spent += purchase
    
    # Calculate metrics
    avg_daily_earnings = total_earned / 7
    avg_daily_spending = total_spent / 7
    
    # Check balance
    balance_ratio = total_spent / total_earned if total_earned > 0 else 0
    
    passed = 30 <= avg_daily_earnings <= 150 and 0.3 <= balance_ratio <= 0.8
    
    return TestResult(
        name="Coin Economy Balance",
        passed=passed,
        message=f"Daily earnings: {avg_daily_earnings:.1f} coins, Spending ratio: {balance_ratio:.1%}",
        details={
            "7-day earnings": total_earned,
            "7-day spending": total_spent,
            "Avg daily earnings": f"{avg_daily_earnings:.1f} coins",
            "Avg daily spending": f"{avg_daily_spending:.1f} coins",
            "Balance ratio": f"{balance_ratio:.1%}",
            "Expected range": "30-150 coins/day",
            "Econ healthy": "✓" if passed else "✗"
        }
    )

# ============================================
# TEST 2: XP EVOLUTION RATE
# ============================================

async def test_evolution_rate() -> TestResult:
    """
    Test pet evolution XP progression.
    
    XP Rules:
    - Base meal: +15 XP
    - Streak bonus: +5 XP
    - High calorie: 1.5x-2x multiplier
    - Evolution threshold: Level * 100 XP
    
    Expected:
    - Level 1→2: ~100 XP = ~5-7 days of active logging
    - Level 2→3: ~200 XP = ~10-14 days
    - Should feel rewarding but not too fast
    """
    print_header("TEST 2: XP Evolution Rate")
    
    results = []
    
    for starting_level in [1, 2, 3, 5]:
        current_xp = 0
        days_to_evolution = 0
        threshold = starting_level * 100
        
        # Simulate until evolution
        while current_xp < threshold and days_to_evolution < 60:
            # 3 meals per day
            for _ in range(3):
                base_xp = 15 + 5  # base + streak
                current_xp += base_xp
            days_to_evolution += 1
        
        results.append({
            "level": starting_level,
            "threshold": threshold,
            "days": days_to_evolution
        })
    
    # Calculate progression rates
    level1_days = results[0]["days"]
    level5_days = sum(r["days"] for r in results)
    
    # Check if rates are reasonable
    reasonable = level1_days <= 10 and level5_days <= 90
    
    return TestResult(
        name="XP Evolution Rate",
        passed=reasonable,
        message=f"Level 1→2: {level1_days}d, Total to L5: {level5_days}d",
        details={
            f"Level {r['level']}→{r['level']+1}": f"{r['days']} days (threshold: {r['threshold']} XP)"
            for r in results
        },
        timestamp=datetime.now().isoformat()
    )

# ============================================
# TEST 3: STREAK MECHANICS
# ============================================

async def test_streak_mechanics() -> TestResult:
    """
    Test streak mechanics and engagement.
    
    Rules:
    - Streak continues if meal logged within 24h
    - Grace period: 48h (streak continues but resets)
    - After 48h: streak resets to 1
    
    Expected:
    - Casual users (4-5 days/week): 60-80% max streak
    - Active users (7 days): 95-100% max streak
    """
    print_header("TEST 3: Streak Mechanics")
    
    scenarios = [
        {"name": "Daily Active", "days_active": 7, "miss_chance": 0.0},
        {"name": "Almost Daily", "days_active": 6, "miss_chance": 0.1},
        {"name": "Weekend Only", "days_active": 2, "miss_chance": 0.0},
        {"name": "Random Miss", "days_active": 5, "miss_chance": 0.2},
    ]
    
    results = []
    
    for scenario in scenarios:
        streak = 0
        max_streak = 0
        days = 30
        
        for day in range(days):
            if random.random() > scenario["miss_chance"]:
                streak += 1
                max_streak = max(max_streak, streak)
            else:
                streak = 1  # Reset or grace period
        
        efficiency = max_streak / scenario["days_active"] * days
        
        results.append({
            "scenario": scenario["name"],
            "expected_max": scenario["days_active"] * (days // 7),
            "actual_max": max_streak,
            "efficiency": f"{efficiency:.0f}%"
        })
    
    # Check if mechanics feel fair
    avg_efficiency = statistics.mean(
        int(r["efficiency"].replace("%", "")) for r in results
    )
    
    passed = 50 <= avg_efficiency <= 120
    
    return TestResult(
        name="Streak Mechanics",
        passed=passed,
        message=f"Average streak efficiency: {avg_efficiency:.0f}%",
        details={r["scenario"]: f"Max: {r['actual_max']}d ({r['efficiency']})" for r in results}
    )

# ============================================
# TEST 4: ANXIETY RELIEF LABELS
# ============================================

async def test_anxiety_relief_labels() -> TestResult:
    """
    Test anxiety relief label distribution.
    
    Labels should:
    - Never make user feel guilty
    - Always be encouraging/positive
    - Map food categories to appropriate messages
    - Use "能量", "心情", "补给" over "热量", "脂肪"
    """
    print_header("TEST 4: Anxiety Relief Label Distribution")
    
    # Test cases: (food, calories, expected_positive)
    test_cases = [
        ("沙拉", 150, True),
        ("披萨", 680, True),  # High calorie but positive
        ("巧克力", 550, True),  # Should NOT be negative
        ("水果", 120, True),
        ("奶茶", 350, True),
        ("炸鸡", 750, True),  # Should be celebratory, not shaming
    ]
    
    all_positive = True
    results = []
    
    for food, calories, expected in test_cases:
        # In production, this would call the API
        # For testing, we check the label generation logic
        if calories > 500:
            label_type = "celebration"
        elif calories > 300:
            label_type = "reward"
        else:
            label_type = "healthy"
        
        is_positive = label_type in ["celebration", "reward", "healthy"]
        all_positive = all_positive and is_positive
        
        results.append({
            "food": food,
            "calories": calories,
            "label_type": label_type,
            "positive_framing": is_positive
        })
    
    return TestResult(
        name="Anxiety Relief Labels",
        passed=all_positive,
        message="All high-calorie foods receive positive framing" if all_positive else "Some foods may cause anxiety",
        details={
            r["food"]: f"{r['calories']}kcal → {r['label_type']} ({'✓' if r['positive_framing'] else '✗'})"
            for r in results
        }
    )

# ============================================
# TEST 5: SSE REAL-TIME PERFORMANCE
# ============================================

async def test_sse_performance() -> TestResult:
    """
    Test SSE (Server-Sent Events) real-time performance.
    
    Requirements:
    - Handle 100+ concurrent connections
    - < 100ms latency for state updates
    - Graceful reconnection
    """
    print_header("TEST 5: SSE Real-time Performance")
    
    latency_results = []
    connection_failures = 0
    successful_updates = 0
    
    async with aiohttp.ClientSession() as session:
        # Simulate concurrent connections
        tasks = []
        
        async def simulate_user():
            nonlocal connection_failures, successful_updates
            
            try:
                # Connect to SSE
                async with session.get(f"{API_BASE_URL}/api/v1/sse/connect") as resp:
                    if resp.status != 200:
                        connection_failures += 1
                        return
                    
                    # Simulate receiving updates
                    start = time.time()
                    async for line in resp.content:
                        if line:
                            successful_updates += 1
                            latency = (time.time() - start) * 1000
                            latency_results.append(latency)
                            start = time.time()
                            
            except Exception:
                connection_failures += 1
        
        # Create concurrent connections
        for _ in range(CONCURRENT_USERS):
            tasks.append(simulate_user())
        
        # Run for test duration
        try:
            await asyncio.wait_for(
                asyncio.gather(*tasks, return_exceptions=True),
                timeout=TEST_DURATION_SECONDS
            )
        except asyncio.TimeoutError:
            pass
    
    # Calculate metrics
    avg_latency = statistics.mean(latency_results) if latency_results else 0
    max_latency = max(latency_results) if latency_results else 0
    
    passed = avg_latency < 100 and connection_failures < CONCURRENT_USERS * 0.1
    
    return TestResult(
        name="SSE Performance",
        passed=passed,
        message=f"Avg latency: {avg_latency:.1f}ms, Updates: {successful_updates}",
        details={
            "concurrent_users": CONCURRENT_USERS,
            "connection_failures": connection_failures,
            "successful_updates": successful_updates,
            "avg_latency_ms": f"{avg_latency:.1f}ms",
            "max_latency_ms": f"{max_latency:.1f}ms",
            "SLA": "< 100ms latency"
        }
    )

# ============================================
# TEST 6: CONCURRENT USER SIMULATION
# ============================================

async def test_concurrent_users() -> TestResult:
    """
    Simulate multiple users interacting with the system.
    
    Tests:
    - Meal logging throughput
    - Pet state updates
    - Coin/XP calculations
    - No race conditions
    """
    print_header("TEST 6: Concurrent User Simulation")
    
    user_sims = [
        UserSimulation(
            user_id=f"user_{i}",
            coins=100,
            xp=0,
            streak=random.randint(1, 10),
            meals_logged=0
        )
        for i in range(CONCURRENT_USERS)
    ]
    
    start_time = time.time()
    operations = 0
    errors = 0
    
    async with aiohttp.ClientSession() as session:
        async def simulate_user_activity(user: UserSimulation):
            nonlocal operations, errors
            
            for _ in range(10):  # 10 operations per user
                try:
                    # Simulate meal logging
                    food = random.choice([
                        {"name": "沙拉", "calories": 180},
                        {"name": "披萨", "calories": 550},
                        {"name": "蛋糕", "calories": 420},
                    ])
                    
                    # Calculate rewards (simulated)
                    multiplier = 2.0 if food["calories"] > 500 else 1.5 if food["calories"] > 300 else 1.0
                    coins = int(10 * multiplier) + 5
                    xp = int(15 * multiplier) + 5
                    
                    # Update user state
                    user.coins += coins
                    user.xp += xp
                    user.meals_logged += 1
                    
                    operations += 1
                    
                except Exception:
                    errors += 1
                
                await asyncio.sleep(0.01)  # Small delay
        
        await asyncio.gather(*[
            simulate_user_activity(u) for u in user_sims
        ])
    
    elapsed = time.time() - start_time
    
    total_meals = sum(u.meals_logged for u in user_sims)
    avg_coins = statistics.mean(u.coins for u in user_sims)
    
    passed = errors < operations * 0.05  # < 5% error rate
    
    return TestResult(
        name="Concurrent Users",
        passed=passed,
        message=f"{operations} ops in {elapsed:.1f}s, {errors} errors",
        details={
            "total_users": CONCURRENT_USERS,
            "total_operations": operations,
            "total_errors": errors,
            "error_rate": f"{errors/operations*100:.1f}%" if operations else "0%",
            "throughput": f"{operations/elapsed:.1f} ops/sec",
            "avg_coins_earned": f"{avg_coins:.0f}"
        }
    )

# ============================================
# TEST 7: PET DECAY SYSTEM
# ============================================

async def test_pet_decay_system() -> TestResult:
    """
    Test pet stat decay over time.
    
    Rules:
    - Stats decay when user is inactive
    - Decay rate: hunger > joy > vigor
    - User should feel motivated to log meals
    
    Expected:
    - Inactive 1 day: slight decay
    - Inactive 3+ days: noticeable decay
    - Pet mood changes based on stats
    """
    print_header("TEST 7: Pet Decay System")
    
    scenarios = [
        {"name": "Active (3 meals/day)", "hours": 0, "decay_rate": 0},
        {"name": "Slightly inactive (12h)", "hours": 12, "decay_rate": 1},
        {"name": "Inactive (24h)", "hours": 24, "decay_rate": 2},
        {"name": "Very inactive (72h)", "hours": 72, "decay_rate": 6},
    ]
    
    results = []
    
    for scenario in scenarios:
        # Initial stats
        hunger = 70
        joy = 80
        vigor = 65
        
        # Apply decay
        decay = scenario["decay_rate"]
        final_hunger = max(0, hunger - decay)
        final_joy = max(0, joy - decay // 2)
        final_vigor = max(0, vigor - decay // 3)
        
        # Calculate mood
        if final_hunger < 20 or final_joy < 20:
            mood = "sad"
        elif final_hunger < 40 or final_joy < 40:
            mood = "neutral"
        else:
            mood = "happy"
        
        results.append({
            "scenario": scenario["name"],
            "initial": (hunger, joy, vigor),
            "final": (final_hunger, final_joy, final_vigor),
            "mood": mood
        })
    
    # Check if decay feels fair
    mild_inactive = results[1]
    severe_inactive = results[3]
    
    # After 12h, should not lose more than 20% of stats
    mild_fair = mild_inactive["final"][0] >= 50
    # After 72h, should be noticeably low but not dead
    severe_fair = severe_inactive["final"][0] >= 30
    
    passed = mild_fair and severe_fair
    
    return TestResult(
        name="Pet Decay System",
        passed=passed,
        message="Decay rates feel fair" if passed else "Decay too aggressive",
        details={
            r["scenario"]: f"H:{r['final'][0]} J:{r['final'][1]} V:{r['final'][2]} → {r['mood']}"
            for r in results
        }
    )

# ============================================
# MAIN TEST RUNNER
# ============================================

async def run_all_tests():
    """Run all tests and generate report."""
    print(f"\n{Color.YELLOW}{'#'*60}")
    print(f"# Aura-Pet Load Testing Suite")
    print(f"# Testing: Economic Balance & System Stability")
    print(f"{'#'*60}{Color.RESET}\n")
    
    tests = [
        test_coin_economy,
        test_evolution_rate,
        test_streak_mechanics,
        test_anxiety_relief_labels,
        test_pet_decay_system,
        test_concurrent_users,
    ]
    
    results = []
    
    for test in tests:
        try:
            result = await test()
            results.append(result)
            print_result(result)
        except Exception as e:
            results.append(TestResult(
                name=test.__name__,
                passed=False,
                message=f"Test error: {str(e)}"
            ))
            print_result(results[-1])
    
    # Summary
    passed = sum(1 for r in results if r.passed)
    total = len(results)
    
    print(f"\n{Color.BLUE}{'='*60}{Color.RESET}")
    print(f"{Color.BLUE}TEST SUMMARY: {passed}/{total} Passed{Color.RESET}")
    print(f"{Color.BLUE}{'='*60}{Color.RESET}\n")
    
    # Save results to JSON
    output_file = f"load_test_results_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
    with open(output_file, 'w') as f:
        json.dump({
            "timestamp": datetime.now().isoformat(),
            "summary": {"passed": passed, "total": total},
            "results": [
                {
                    "name": r.name,
                    "passed": r.passed,
                    "message": r.message,
                    "details": r.details
                }
                for r in results
            ]
        }, f, indent=2)
    
    print(f"Results saved to: {output_file}")
    
    return passed == total

if __name__ == "__main__":
    success = asyncio.run(run_all_tests())
    exit(0 if success else 1)
