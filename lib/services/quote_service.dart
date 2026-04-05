import 'package:flutter/material.dart';
import 'quote_engine.dart';
import '../widgets/quote_bubble.dart';

/// 语料服务 - 全链路闭环
class QuoteService {
  static QuoteLibrary? _library;
  static final QuoteEngine _engine = QuoteEngine();
  static bool _initialized = false;

  /// 初始化
  static Future<void> init(BuildContext context) async {
    if (_initialized) return;
    _library = await QuoteLibrary.load();
    _initialized = true;
  }

  /// 触发语料
  static Future<void> trigger(BuildContext context, String trigger, {String? mood}) async {
    if (_library == null) {
      _library = await QuoteLibrary.load();
    }

    final quote = await _engine.getQuote(
      trigger: trigger,
      library: _library!,
      mood: mood,
    );

    if (quote != null) {
      QuoteBubbleOverlay.show(
        context,
        text: quote.text,
        category: quote.category,
      );
    }
  }

  /// 更新用户行为
  static void updateStreak(int days) => _engine.updateStreak(days);
  static void updateWaterStreak(int days) => _engine.updateWaterStreak(days);
  static void recordLog() => _engine.recordLog();
}

/// 语料气泡混入类 - 为页面提供语料能力
mixin QuoteBubbleMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late AnimationController _quoteAnimController;
  late Animation<double> _quoteFadeAnim;
  String? _pendingTrigger;

  void initQuoteAnimation() {
    _quoteAnimController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _quoteFadeAnim = CurvedAnimation(
      parent: _quoteAnimController,
      curve: Curves.easeOut,
    );
  }

  void disposeQuoteAnimation() {
    _quoteAnimController.dispose();
  }

  /// 触发语料
  Future<void> showQuote(BuildContext context, String trigger) async {
    if (_library == null) {
      _library = await QuoteLibrary.load();
    }

    final quote = await _engine.getQuote(
      trigger: trigger,
      library: _library!,
    );

    if (quote != null && mounted) {
      QuoteBubbleOverlay.show(
        context,
        text: quote.text,
        category: quote.category,
      );
    }
  }
}

/// 语料触发快捷方法
class QuoteTriggers {
  // 核心触发点
  static const String appOpen = 'open_app';
  static const String mealLog = 'log_meal';
  static const String mealFinish = 'finish_eating';
  static const String waterDrink = 'drink_water';
  static const String fastingStart = 'fasting_start';
  static const String fastingEnd = 'fasting_end';
  static const String streak3 = 'streak_3';
  static const String streak7 = 'streak_7';
  static const String streak30 = 'streak_30';
  static const String achievementUnlock = 'achievement_unlock';
  static const String goalReached = 'goal_reached';
  static const String moodHappy = 'mood_happy';
  static const String moodSad = 'mood_sad';
  static const String moodTired = 'mood_tired';
  static const String moodStressed = 'mood_stressed';
}
