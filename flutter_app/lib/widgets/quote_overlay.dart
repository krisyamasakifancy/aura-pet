import 'package:flutter/material.dart';
import '../services/quote_engine.dart';
import '../utils/theme.dart';

/// 语料气泡管理器 - 全局Overlay集成示例
class QuoteOverlayManager {
  static QuoteOverlayManager? _instance;
  static QuoteOverlayManager get instance => _instance ??= QuoteOverlayManager._();
  QuoteOverlayManager._();

  final List<OverlayEntry> _activeOverlays = [];
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// 显示语料气泡
  void showQuote({
    required String trigger,
    String? category,
    int? auraScore,
    String? mood,
    Duration? displayDuration,
  }) {
    final quote = QuoteEngine.instance.getQuote(
      trigger: trigger,
      category: category,
      auraScore: auraScore,
      mood: mood,
    );

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 120, // 底部导航上方
        left: 16,
        right: 16,
        child: QuoteBubble(
          text: quote,
          category: category,
          displayDuration: displayDuration ?? const Duration(seconds: 5),
          onDismiss: () => _removeOverlay(overlayEntry),
        ),
      ),
    );

    _activeOverlays.add(overlayEntry);
    navigatorKey.currentState?.overlay?.insert(overlayEntry);
    
    // 记录行为
    QuoteEngine.instance.trackAction(trigger);
  }

  void _removeOverlay(OverlayEntry entry) {
    entry.remove();
    _activeOverlays.remove(entry);
  }

  /// 清除所有气泡
  void clearAll() {
    for (final entry in _activeOverlays) {
      entry.remove();
    }
    _activeOverlays.clear();
  }
}

/// 在任意页面使用的语料气泡助手 Widget
class QuoteHelper extends StatelessWidget {
  final Widget child;
  final String? trigger;
  final String? category;
  final int? auraScore;
  final bool autoShow;

  const QuoteHelper({
    super.key,
    required this.child,
    this.trigger,
    this.category,
    this.auraScore,
    this.autoShow = false,
  });

  @override
  Widget build(BuildContext context) {
    // 使用 Provider 获取 Aura Score
    int? effectiveAuraScore = auraScore;
    if (effectiveAuraScore == null) {
      // TODO: 从 Provider 获取
    }

    return Stack(
      children: [
        child,
        // 语料气泡会自动显示在底部
      ],
    );
  }
}

/// 莫奈风格文字动效 Widget
class MonetTextAnimation extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;

  const MonetTextAnimation({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<MonetTextAnimation> createState() => _MonetTextAnimationState();
}

class _MonetTextAnimationState extends State<MonetTextAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFB5B5).withOpacity(_glowAnimation.value),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              widget.text,
              style: widget.style ?? const TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}

/// 全链路语料触发集成示例
/// 
/// 在以下场景自动触发语料：
/// 
/// 1. 打开App → 问候语
/// 2. 记录饮食 → 美食语料
/// 3. 完成饮食 → 赞美语料  
/// 4. 喝水提醒 → 喝水语料
/// 5. 禁食开始 → 自律语料
/// 6. 禁食完成 → 成就语料
/// 7. 达成成就 → 激励语料
/// 8. 连续打卡 → 连续激励
/// 9. 心情变化 → 情感语料
/// 
/// 使用方法：
/// 
/// ```dart
/// // 在任意页面触发
/// QuoteOverlayManager.instance.showQuote(
///   trigger: 'log_meal',
///   category: 'food_peace',
///   auraScore: 85,
/// );
/// ```
mixin QuoteTriggers<T extends StatefulWidget> {
  /// 触发问候语
  void triggerGreeting(T context) {
    QuoteOverlayManager.instance.showQuote(
      trigger: 'open_app',
      category: 'emotional_connection',
    );
  }

  /// 触发饮食记录语料
  void triggerMealQuote(T context, {required int auraScore}) {
    QuoteOverlayManager.instance.showQuote(
      trigger: 'log_meal',
      category: 'food_peace',
      auraScore: auraScore,
    );
  }

  /// 触发喝水语料
  void triggerWaterQuote(T context) {
    QuoteOverlayManager.instance.showQuote(
      trigger: 'drink_water',
      category: 'water_fasting',
    );
  }

  /// 触发禁食语料
  void triggerFastingQuote(T context, {bool completed = false}) {
    QuoteOverlayManager.instance.showQuote(
      trigger: completed ? 'complete_fasting' : 'start_fasting',
      category: 'water_fasting',
    );
  }

  /// 触发成就语料
  void triggerAchievementQuote(T context) {
    QuoteOverlayManager.instance.showQuote(
      trigger: 'achievement_unlock',
      category: 'achievement_motivation',
    );
  }

  /// 触发连续打卡语料
  void triggerStreakQuote(T context, {required int days}) {
    QuoteEngine.instance.trackAction('streak');
    QuoteOverlayManager.instance.showQuote(
      trigger: 'streak',
      category: 'achievement_motivation',
    );
  }
}
