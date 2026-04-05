import 'dart:convert';
import 'package:flutter/services.dart';

/// 语料数据模型
class Quote {
  final int id;
  final String text;
  final String category;
  final List<String> triggers;

  Quote({
    required this.id,
    required this.text,
    required this.category,
    required this.triggers,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      category: json['category'] ?? '',
      triggers: List<String>.from(json['triggers'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'category': category,
    'triggers': triggers,
  };
}

/// 语料库
class QuoteLibrary {
  final List<Quote> _quotes;
  final Map<String, List<Quote>> _byCategory;
  final Map<String, List<Quote>> _byTrigger;

  static QuoteLibrary? _instance;

  QuoteLibrary._internal(this._quotes)
      : _byCategory = _groupByCategory(_quotes),
        _byTrigger = _groupByTrigger(_quotes);

  static Future<QuoteLibrary> load() async {
    if (_instance != null) return _instance!;
    
    final String jsonString = await rootBundle.loadString('assets/data/aura_quotes.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    final List<Quote> quotes = (data['quotes'] as List)
        .map((q) => Quote.fromJson(q))
        .toList();
    
    _instance = QuoteLibrary._internal(quotes);
    return _instance!;
  }

  static Map<String, List<Quote>> _groupByCategory(List<Quote> quotes) {
    final Map<String, List<Quote>> map = {};
    for (final q in quotes) {
      map.putIfAbsent(q.category, () => []).add(q);
    }
    return map;
  }

  static Map<String, List<Quote>> _groupByTrigger(List<Quote> quotes) {
    final Map<String, List<Quote>> map = {};
    for (final q in quotes) {
      for (final trigger in q.triggers) {
        map.putIfAbsent(trigger, () => []).add(q);
      }
    }
    return map;
  }

  List<Quote> get all => _quotes;
  List<Quote> byCategory(String category) => _byCategory[category] ?? [];
  List<Quote> byTrigger(String trigger) => _byTrigger[trigger] ?? [];
}

/// 智能权重引擎
class QuoteEngine {
  // 用户行为数据
  int _streakDays = 0;      // 连续打卡天数
  int _totalLogs = 0;        // 总记录次数
  int _waterStreak = 0;      // 喝水连续天数
  int _calorieDeficit = 0;   // 累计热量缺口
  DateTime? _lastLogTime;    // 上次记录时间

  // 权重参数
  static const double _baseWeight = 1.0;
  static const double _streakMultiplier = 3.0;  // 连续打卡权重倍增
  static const double _lowMoraleBoost = 2.0;    // 低士气提升
  static const double _goalProximityBoost = 1.5; // 接近目标提升

  // 冷却机制
  DateTime? _lastQuoteTime;
  static const int _cooldownSeconds = 30;

  /// 更新用户行为数据
  void updateStreak(int days) {
    _streakDays = days;
  }

  void updateWaterStreak(int days) {
    _waterStreak = days;
  }

  void recordLog() {
    _totalLogs++;
    _lastLogTime = DateTime.now();
  }

  void updateCalorieDeficit(int deficit) {
    _calorieDeficit = deficit;
  }

  /// 获取语料（智能权重筛选）
  Future<Quote?> getQuote({
    required String trigger,
    required QuoteLibrary library,
    String? mood,
  }) async {
    // 冷却检查
    if (_lastQuoteTime != null) {
      final diff = DateTime.now().difference(_lastQuoteTime!).inSeconds;
      if (diff < _cooldownSeconds) return null;
    }

    // 获取匹配语料
    List<Quote> candidates = library.byTrigger(trigger);
    if (candidates.isEmpty) {
      candidates = library.all;
    }

    // 根据权重排序
    candidates.shuffle();
    candidates.sort((a, b) => _calculateWeight(b).compareTo(_calculateWeight(a)));

    _lastQuoteTime = DateTime.now();
    return candidates.firstOrNull;
  }

  /// 根据用户状态计算语料权重
  double _calculateWeight(Quote quote) {
    double weight = _baseWeight;

    // 1. 连续打卡权重
    if (_streakDays >= 3 && quote.category == '激励赞美') {
      weight *= _streakMultiplier;
    }

    // 2. 喝水连续权重
    if (_waterStreak >= 3 && quote.triggers.contains('drink_water')) {
      weight *= _streakMultiplier;
    }

    // 3. 深夜时段权重
    if (_isLateNight() && quote.triggers.contains('late_night')) {
      weight *= _lowMoraleBoost;
    }

    // 4. 疲劳状态权重
    if (mood == 'tired' && quote.category == '日常撒娇') {
      weight *= _lowMoraleBoost;
    }

    // 5. 接近目标时权重
    if (_calorieDeficit > 500 && quote.triggers.contains('log_meal')) {
      weight *= _goalProximityBoost;
    }

    // 6. 分类偏好权重
    if (_streakDays == 0 && quote.category == '激励赞美') {
      weight *= 1.5; // 新用户/断签后首次登录
    }

    return weight;
  }

  bool _isLateNight() {
    final hour = DateTime.now().hour;
    return hour >= 22 || hour < 6;
  }

  /// 获取当前士气等级 (0-100)
  double get moraleLevel {
    double morale = 50.0;
    morale += (_streakDays * 5).clamp(0, 30);
    morale += (_waterStreak * 3).clamp(0, 20);
    morale += ((_totalLogs ~/ 10) * 2).clamp(0, 20);
    return morale.clamp(0, 100);
  }

  /// 获取推荐分类
  String get recommendedCategory {
    if (moraleLevel >= 80) return '激励赞美';
    if (moraleLevel >= 50) return '日常撒娇';
    return '美食和解';
  }
}

/// 语料触发器枚举
class QuoteTriggers {
  static const String openApp = 'open_app';
  static const String logMeal = 'log_meal';
  static const String finishEating = 'finish_eating';
  static const String drinkWater = 'drink_water';
  static const String fasting = 'fasting';
  static const String streak = 'streak';
  static const String achievement = 'achievement';
  static const String progress = 'progress';
  static const String goalReached = 'goal_reached';
  static const String moodBad = 'mood_bad';
  static const String tired = 'tired';
  static const String lateNight = 'late_night';
}
