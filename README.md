# Aura-Pet 🦝
## 智能宠物养成 - 通过 Quad-Agent 协作消除摄入焦虑

> **"喂养宠物，而非记录数据" —— 用可爱对抗卡路里焦虑**

---

## 🎯 核心理念：用 AI 协作消除摄入焦虑

### 传统食物记录的问题

| 传统方式 | Aura-Pet 方案 |
|---------|--------------|
| ❌ "热量超标" | ✅ "灵魂充电时间" |
| ❌ "碳水过高" | ✅ "能量储备充足" |
| ❌ "脂肪警告" | ✅ "快乐因子注入中" |
| ❌ 冷冰冰的数字 | ✅ 小浣熊的温暖陪伴 |

### Quad-Agent 如何消除焦虑

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│    用户拍照 🍰                                                   │
│        │                                                        │
│        ▼                                                        │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │              VISION AGENT                                 │    │
│  │  • 多模型交叉验证 (GPT-4o + Gemini)                      │    │
│  │  • 识别食物 + 估算热量                                   │    │
│  │  • 检测色调 → 预测"满足感"                               │    │
│  │                                                          │    │
│  │  【焦虑消除第一步】                                       │    │
│  │  "这是芝士蛋糕，不是'热量炸弹'"                            │    │
│  │  "检测到奶油色调，说明是好吃的"                            │    │
│  └───────────────────────────┬─────────────────────────────┘    │
│                              │                                   │
│                              ▼                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │              LOGIC AGENT                                  │    │
│  │  • Calorie-to-Energy 转换                               │    │
│  │  • 计算奖励 (coins/XP)                                   │    │
│  │  • 高热量 → 高奖励倍率 (去罪化)                          │    │
│  │                                                          │    │
│  │  【焦虑消除第二步】                                       │    │
│  │  "检测到 550kcal → 2.0x 奖励倍率"                       │    │
│  │  "越'放纵' = 越值得被奖励"                               │    │
│  │  "你做了明智的选择让自己快乐"                              │    │
│  └───────────────────────────┬─────────────────────────────┘    │
│                              │                                   │
│                              ▼                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │              PERSONA AGENT                               │    │
│  │  • 生成温暖对话                                         │    │
│  │  • 小浣熊拟人化吐槽                                     │    │
│  │  • "去焦虑"语料库匹配                                    │    │
│  │                                                          │    │
│  │  【焦虑消除第三步】                                       │    │
│  │  "哇！！是你最爱的甜点诶！！"                             │    │
│  │  "生活已经这么苦了当然要对自己好一点呀～"                  │    │
│  │  "吃吧吃吧，小浣熊批准了！👑✨"                           │    │
│  └───────────────────────────┬─────────────────────────────┘    │
│                              │                                   │
│                              ▼                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │              ANIMATOR AGENT                              │    │
│  │  • 触发开心动画 (幸福转圈)                                │    │
│  │  • Spring Physics 物理反馈                               │    │
│  │  • 粒子特效 + 情绪滤镜                                    │    │
│  │                                                          │    │
│  │  【焦虑消除第四步】                                       │    │
│  │  "🦝 小浣熊兴奋地原地转圈⭕"                              │    │
│  │  "看到你这么开心，我也好幸福呀！"                          │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │              最终用户感受                                  │    │
│  │                                                          │    │
│  │  ✨ 我拍了想吃的食物                                      │    │
│  │  ✨ 宠物很开心地转圈                                     │    │
│  │  ✨ 还获得了奖励                                          │    │
│  │  ✨ 没有任何负面评价                                      │    │
│  │  ✨ 只有温暖和陪伴                                        │    │
│  │                                                          │    │
│  │  → 焦虑消失了，取而代之的是满足感                          │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🧬 焦虑消除机制详解

### 1. Calorie-to-Energy 转换

```python
# 传统思维：热量 = 需要担心的数字
# Aura-Pet 思维：热量 = 快乐的量化指标

def calorie_to_energy(calories: int) -> float:
    """
    高热量 = 高快乐 = 高奖励
    
    0-200 kcal:   1.0x (健康之选)
    200-400 kcal: 1.2x (心情加油)
    400-600 kcal: 1.5x (快乐因子)
    600+ kcal:    2.0x (灵魂充电)
    
    → 越满足，越奖励
    """
    if calories > 600:
        return 2.0
    elif calories > 400:
        return 1.5
    elif calories > 200:
        return 1.2
    return 1.0
```

### 2. 去焦虑标签系统

| 食物类型 | 传统标签 | Aura-Pet 标签 |
|---------|---------|--------------|
| 甜点 (>400kcal) | ⚠️ 热量超标 | ⚡ 灵魂充电时间 |
| 炸鸡 (>600kcal) | ❌ 油炸食品 | 👑 尊享犒劳时刻 |
| 披萨 (>500kcal) | ⚠️ 高碳水 | 🤗 碳水安慰拥抱 |
| 沙拉 (<200kcal) | ✅ 健康 | 🌿 绿色能量满格 |

### 3. 小浣熊的陪伴哲学

```
【不评判】
传统: "你今天摄入了 1800kcal，超标了 300kcal"
Aura:  "记录本身就是自律的表现呀！你已经在好好照顾自己了！💕"

【共情而非说教】
传统: "建议减少甜食摄入"
Aura:  "想吃就吃呀～今天的卡路里明天再算！现在的快乐最重要！🤗"

【正向强化】
传统: "连续 3 天未达标"
Aura:  "没关系呀～小浣熊会一直等你的，我们明天继续！🌙"
```

---

## 📊 养成系统平衡性

### 经济系统参数

| 参数 | 值 | 说明 |
|------|-----|------|
| 基础奖励 | +10 coins | 每餐记录 |
| Streak 奖励 | +5 coins | 连续记录 |
| 高热量倍率 | 1.5x-2.0x | 去罪化设计 |
| 互动奖励 | +2 coins | 摸头/戳 |
| 商店道具 | 50-500 coins | 多样化消费 |

### XP 进化曲线

| 等级 | XP 需求 | 预计时间 | 感觉 |
|------|---------|----------|------|
| 1 → 2 | 100 XP | ~5 天 | 快速入门 |
| 2 → 3 | 200 XP | ~10 天 | 稳定成长 |
| 3 → 5 | 300-400 XP | ~15-20 天 | 中期目标 |
| 5 → 10 | 500-900 XP | ~30-50 天 | 长期陪伴 |

### 衰减机制

| 状态 | 衰减率 | 说明 |
|------|--------|------|
| 活跃 (3餐/天) | 0 | 数值稳定 |
| 轻度不活跃 (12h) | -1/小时 | 轻微提醒 |
| 中度不活跃 (24h) | -2/小时 | 需要回来 |
| 重度不活跃 (72h+) | -3/小时 | 小浣熊想你了 |

---

## 🚀 快速开始

### Docker Compose (一键启动)

```bash
cd aura-pet
docker-compose up -d

# 访问服务
# API: http://localhost:8000
# API Docs: http://localhost:8000/docs
# Frontend: http://localhost:8080
```

### 本地开发

```bash
# 1. 数据库
psql -U postgres -c "CREATE DATABASE aura_pet;"

# 2. 后端
cd backend
pip install -r requirements.txt
uvicorn main:app --reload --port 8000

# 3. 前端
cd frontend
python -m http.server 8080
```

### 运行压测

```bash
cd backend/tests
pip install aiohttp
python load_test.py
```

---

## 🧪 压测脚本说明

### 测试项目

1. **Coin Economy Balance** - 金币经济平衡
2. **XP Evolution Rate** - XP 进化速率
3. **Streak Mechanics** - 连击机制
4. **Anxiety Relief Labels** - 去焦虑标签分布
5. **Pet Decay System** - 宠物衰减系统
6. **Concurrent Users** - 并发用户模拟

### 运行示例

```bash
$ python load_test.py

============================================================
# Aura-Pet Load Testing Suite
# Testing: Economic Balance & System Stability
============================================================

TEST 1: Coin Economy Balance
✓ PASS | Daily earnings: 45.7 coins, Spending ratio: 45%
       • 7-day earnings: 320
       • 7-day spending: 145
       • Balance ratio: 45%

TEST 2: XP Evolution Rate
✓ PASS | Level 1→2: 6d, Total to L5: 52d
       • Level 1→2: 6 days (threshold: 100 XP)
       • Level 2→3: 11 days (threshold: 200 XP)

TEST 3: Streak Mechanics
✓ PASS | Average streak efficiency: 85%
       • Daily Active: Max: 7d (100%)
       • Almost Daily: Max: 6d (85%)

============================================================
TEST SUMMARY: 6/6 Passed
============================================================
```

---

## 🏗️ 技术架构

```
aura-pet/
├── backend/
│   ├── main.py              # FastAPI 应用
│   ├── repositories.py     # Repository 模式
│   ├── routers/
│   │   └── sse.py         # SSE 实时推送
│   ├── agents/
│   │   └── sync_coordinator.py  # Quad-Agent
│   └── tests/
│       └── load_test.py   # 压测脚本
│
├── frontend/
│   ├── index.html         # Web 预览
│   └── flutter_app/       # Flutter App
│
└── database/
    └── schema.sql         # PostgreSQL
```

---

## 📈 商业化指标目标

| 指标 | 目标值 | 说明 |
|------|--------|------|
| D7 Retention | > 60% | 一周后仍活跃 |
| Avg Session | > 5 min | 沉浸式体验 |
| Daily Meals | 2.5 次 | 接近真实饮食 |
| Premium Rate | > 5% | 付费转化 |
| NPS Score | > 50 | 用户推荐度 |

---

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

```bash
# 克隆仓库
git clone https://github.com/aura-pet/aura-pet.git

# 创建分支
git checkout -b feature/your-feature

# 提交
git commit -m "feat: Add your feature"

# 推送
git push origin feature/your-feature
```

---

## 📄 License

MIT License - see [LICENSE](LICENSE)

---

**Built with ❤️ | Powered by Quad-Agent AI | Digital Impressionism Edition**

*消除焦虑，拥抱满足感。*
