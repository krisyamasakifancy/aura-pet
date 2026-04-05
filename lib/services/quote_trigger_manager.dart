import 'package:flutter/material.dart';
import 'quote_engine.dart';
import '../widgets/quote_bubble.dart';

/// 语料触发管理器
/// 负责全链路语料推送
class QuoteTriggerManager {
  final QuoteEngine _engine = QuoteEngine();
  QuoteLibrary? _library;
  BuildContext? _context;

  /// 初始化
  Future<void> init(BuildContext context) async {
    _context = context;
    _library = await QuoteLibrary.load();
  }

  /// 触发语料显示
  Future<void> trigger(String trigger, {String? mood}) async {
    if (_library == null || _context == null) return;

    final quote = await _engine.getQuote(
      trigger: trigger,
      library: _library!,
      mood: mood,
    );

    if (quote != null) {
      QuoteBubbleOverlay.show(
        _context!,
        text: quote.text,
        category: quote.category,
      );
    }
  }

  /// 更新用户数据
  void updateStreak(int days) => _engine.updateStreak(days);
  void updateWaterStreak(int days) => _engine.updateWaterStreak(days);
  void recordLog() => _engine.recordLog();
  void updateCalorieDeficit(int deficit) => _engine.updateCalorieDeficit(deficit);
}

// 全局实例
class GlobalQuoteManager {
  static final QuoteTriggerManager _instance = QuoteTriggerManager();
  static QuoteTriggerManager get instance => _instance;
}

/// 46屏关键节点触发点列表
class TriggerPoints {
  // P1-P7: 视觉预热
  static const splashComplete = 'splash_complete';
  static const welcomeTap = 'welcome_tap';

  // P8-P16: 精准调研
  static const genderSelected = 'gender_selected';
  static const ageSelected = 'age_selected';
  static const heightSelected = 'height_selected';
  static const weightSelected = 'weight_selected';
  static const goalSelected = 'goal_selected';
  static const activitySelected = 'activity_selected';

  // P17-P27: 深度转化
  static const analyzingComplete = 'analyzing_complete';
  static const planReady = 'plan_ready';
  static const reviewViewed = 'review_viewed';
  static const notificationEnabled = 'notification_enabled';
  static const subscriptionViewed = 'subscription_viewed';
  static const paymentSuccess = 'payment_success';

  // P28-P37: 高频工具
  static const homeViewed = 'home_viewed';
  static const foodLogged = 'food_logged';
  static const moodSelected = 'mood_selected';
  static const waterLogged = 'water_logged';
  static const fastingStarted = 'fasting_started';
  static const fastingCompleted = 'fasting_completed';
  static const calorieGoalReached = 'calorie_goal_reached';

  // P38-P46: 情感回馈
  static const achievementUnlocked = 'achievement_unlocked';
  static const costumeChanged = 'costume_changed';
  static const weeklyReportViewed = 'weekly_report_viewed';
  static const settingsChanged = 'settings_changed';
  static const backToHome = 'back_to_home';
}
