# Aura-Pet 语料系统架构文档

## 1. 文件结构

```
lib/
├── main.dart                              # 主入口
├── user_metrics_model.dart                # 用户数据模型
├── services/
│   ├── quote_engine.dart                  # 语料引擎
│   ├── quote_service.dart                 # 语料服务
│   └── quote_trigger_manager.dart         # 触发管理器
└── widgets/
    └── quote_bubble.dart                  # 语料气泡组件
```

## 2. 语料库 (100条)

### 分类分布

| 分类 | 序号 | 调性 | 权重场景 |
|------|------|------|----------|
| 美食和解 | 1-25 | 玛德琳蛋糕般松软包容 | 新用户/断签后 |
| 自律之美 | 26-50 | 露水气息清澈灵动 | 喝水/禁食打卡 |
| 日常撒娇 | 51-75 | 呆萌粘人偏爱 | 打开App/疲劳 |
| 激励赞美 | 76-100 | 元气比心仪式感 | 连续3天+/成就达成 |

## 3. 智能权重算法

### 权重计算公式

```
finalWeight = baseWeight 
  × streakMultiplier(3.0)      // 连续打卡≥3天
  × lowMoraleBoost(2.0)         // 深夜/心情差
  × goalProximityBoost(1.5)    // 接近目标
  × categoryPreference(1.5)     // 新用户首次
```

### 冷却机制

- 30秒防重复机制
- 避免同一语料连续出现

## 4. UI渲染 - 莫奈滤镜

### 渐变色系

```dart
美食和解: [淡黄 #FFF8E7 → 淡粉 #FFE4E1]
自律之美: [淡蓝 #E3F2FD → 淡绿 #E8F5E9]
日常撒娇: [淡紫 #F3E5F5 → 淡粉 #FFE4E1]
激励赞美: [淡金 #FFF9E7 → 淡粉 #FFE4E1]
```

### 呼吸动效

```
渐显: 800ms easeOut
呼吸: 2000ms 循环 (透明度 0.3→0.6)
缩放: 600ms elasticOut (0.8→1.0)
显示: 5秒
淡出: 500ms
```

## 5. 触发点映射

### P1-P7 视觉预热

| 页面 | 触发器 | 语料分类 |
|------|--------|----------|
| P0 Splash | splash_complete | 日常撒娇 |
| P1 Welcome | welcome_tap | 激励赞美 |

### P8-P16 精准调研

| 页面 | 触发器 | 语料分类 |
|------|--------|----------|
| P10 Gender | gender_selected | 激励赞美 |
| P13 Weight | weight_selected | 激励赞美 |
| P14 GoalWeight | goal_selected | 激励赞美 |

### P17-P27 深度转化

| 页面 | 触发器 | 语料分类 |
|------|--------|----------|
| P17 Analyzing | analyzing_complete | 激励赞美 |
| P18 PlanReady | plan_ready | 激励赞美 |
| P20 Notification | notification_enabled | 日常撒娇 |
| P26 WelcomeBack | payment_success | 激励赞美 |

### P28-P37 高频工具

| 页面 | 触发器 | 语料分类 |
|------|--------|----------|
| P28 Home | home_viewed | 日常撒娇 |
| P29 Nutrients | food_logged | 美食和解 |
| P30 Mood | mood_selected | 日常撒娇 |
| P31 FoodSearch | log_meal | 美食和解 |
| P32 FoodList | finish_eating | 美食和解 |
| P36 WaterTracker | drink_water | 自律之美 |
| P37 WaterHistory | streak_3/streak_7 | 激励赞美 |
| P40 GoalReached | goal_reached | 激励赞美 |

### P38-P46 情感回馈

| 页面 | 触发器 | 语料分类 |
|------|--------|----------|
| P38 Achievements | achievement_unlock | 激励赞美 |
| P41 DressingRoom | costume_changed | 日常撒娇 |
| P42 ProgressReport | weekly_report_viewed | 激励赞美 |
| P45 Settings | settings_changed | 自律之美 |
| P46 About | back_to_home | 日常撒娇 |

## 6. 使用示例

### 在页面中触发语料

```dart
// 1. 导入服务
import '../services/quote_service.dart';

// 2. 在方法中调用
void _onMealLogged() {
  QuoteService.trigger(context, QuoteTriggers.mealLog);
}
```

### 自定义语料气泡

```dart
QuoteBubble(
  text: '自定义语料',
  category: '激励赞美',
  showDuration: Duration(seconds: 8),
  onDismiss: () => print('语料已消失'),
)
```

## 7. 全链路闭环验证

```
用户打开App
    ↓
P28 Home → 触发 open_app → 日常撒娇语料
    ↓
记录饮食
    ↓
P32 完成 → 触发 finish_eating → 美食和解语料
    ↓
喝水打卡
    ↓
P36 喝水 → 触发 drink_water → 自律之美语料
    ↓
连续3天
    ↓
P37 历史 → 触发 streak_3 → 激励赞美语料 (权重×3)
```

---

*Generated: 2026-04-05*
