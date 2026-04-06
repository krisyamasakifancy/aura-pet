import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

/// Smart Quote Engine - 甜心莫奈语料库引擎
/// 根据用户行为自动提升权重，智能抽取最适合的语料
class QuoteEngine {
  static QuoteEngine? _instance;
  static QuoteEngine get instance => _instance ??= QuoteEngine._();
  QuoteEngine._();

  final Random _random = Random();
  
  Map<String, dynamic>? _quotesData;
  Map<String, int> _actionCounts = {};
  Map<String, DateTime> _lastQuoteTime = {};
  
  // 权重提升阈值
  static const int STREAK_THRESHOLD = 3;
  static const int WEIGHT_BOOST_MULTIPLIER = 3;
  
  // 防重复时间（毫秒）
  static const int COOLDOWN_MS = 30000;

  /// 初始化引擎
  Future<void> init() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/quotes.json');
      _quotesData = json.decode(jsonString);
    } catch (e) {
      print('QuoteEngine: Failed to load quotes: $e');
      _quotesData = _getFallbackData();
    }
  }

  /// 记录用户行为
  void trackAction(String action) {
    _actionCounts[action] = (_actionCounts[action] ?? 0) + 1;
  }

  /// 获取激励语料
  String getQuote({
    String? trigger,
    String? category,
    int? auraScore,
    String? mood,
  }) {
    // 检查冷却时间
    final now = DateTime.now().millisecondsSinceEpoch;
    final lastTime = _lastQuoteTime[trigger ?? 'default'] ?? 0;
    if (now - lastTime < COOLDOWN_MS && _random.nextDouble() > 0.3) {
      return _getDefaultQuote();
    }
    _lastQuoteTime[trigger ?? 'default'] = now;

    List<Map<String, dynamic>> candidates = [];

    if (category != null && _quotesData?['categories']?[category]?['quotes'] != null) {
      candidates = List<Map<String, dynamic>>.from(
        _quotesData!['categories'][category]['quotes']
      );
    } else if (trigger != null) {
      candidates = _getQuotesByTrigger(trigger);
    }

    if (candidates.isEmpty) {
      candidates = _getAllQuotes();
    }

    // 根据Aura Score筛选
    if (auraScore != null) {
      candidates = _filterByAuraScore(candidates, auraScore);
    }

    // 应用智能权重
    final weightedCandidates = _applyWeights(candidates, trigger);

    if (weightedCandidates.isEmpty) {
      return _getDefaultQuote();
    }

    return weightedCandidates[_random.nextInt(weightedCandidates.length)]['text'];
  }

  /// 根据触发器获取语料
  List<Map<String, dynamic>> _getQuotesByTrigger(String trigger) {
    final List<Map<String, dynamic>> result = [];
    
    if (_quotesData == null) return result;

    final categories = _quotesData!['categories'] as Map<String, dynamic>;
    
    for (final categoryEntry in categories.entries) {
      final quotes = categoryEntry.value['quotes'] as List<dynamic>?;
      if (quotes == null) continue;
      
      for (final quote in quotes) {
        final triggers = quote['triggers'] as List<dynamic>?;
        if (triggers?.contains(trigger) == true) {
          result.add(Map<String, dynamic>.from(quote));
        }
      }
    }
    
    return result;
  }

  /// 获取所有语料
  List<Map<String, dynamic>> _getAllQuotes() {
    final List<Map<String, dynamic>> result = [];
    
    if (_quotesData == null) return result;

    final categories = _quotesData!['categories'] as Map<String, dynamic>;
    
    for (final categoryEntry in categories.entries) {
      final quotes = categoryEntry.value['quotes'] as List<dynamic>?;
      if (quotes == null) continue;
      
      for (final quote in quotes) {
        result.add(Map<String, dynamic>.from(quote));
      }
    }
    
    return result;
  }

  /// 根据Aura Score筛选
  List<Map<String, dynamic>> _filterByAuraScore(
    List<Map<String, dynamic>> quotes,
    int auraScore,
  ) {
    if (auraScore >= 80) {
      // 高分用户 - 返回优秀语料
      return quotes.where((q) {
        final triggers = q['triggers'] as List<dynamic>?;
        return triggers?.contains('excellent') == true ||
            triggers?.contains('achievement') == true;
      }).toList();
    } else if (auraScore >= 50) {
      // 中等用户 - 返回鼓励语料
      return quotes.where((q) {
        final triggers = q['triggers'] as List<dynamic>?;
        return triggers?.contains('encouragement') == true ||
            triggers?.contains('comfort') == true;
      }).toList();
    } else {
      // 低分用户 - 返回安慰语料
      return quotes.where((q) {
        final triggers = q['triggers'] as List<dynamic>?;
        return triggers?.contains('comfort') == true ||
            triggers?.contains('emotional') == true;
      }).toList();
    }
  }

  /// 应用智能权重
  List<Map<String, dynamic>> _applyWeights(
    List<Map<String, dynamic>> quotes,
    String? trigger,
  ) {
    final streak = _actionCounts['streak'] ?? 0;
    final hasStreakBoost = streak >= STREAK_THRESHOLD;
    
    return quotes.map((q) {
      final triggers = q['triggers'] as List<dynamic>?;
      int weight = 1;
      
      // 连续行为权重提升
      if (hasStreakBoost && triggers?.contains('achievement') == true) {
        weight *= WEIGHT_BOOST_MULTIPLIER;
      }
      
      // 匹配当前触发器的权重提升
      if (trigger != null && triggers?.contains(trigger) == true) {
        weight *= 2;
      }
      
      // 返回带权重的副本
      return {...q, 'weight': weight};
    }).toList();
  }

  /// 获取默认语料
  String _getDefaultQuote() {
    const defaults = [
      '🐻 小熊一直陪着你~',
      '💖 你今天做得很好！',
      '✨ 相信自己，你可以的！',
      '🌟 新的一天，新的开始！',
      '💪 加油，小熊为你打气！',
    ];
    return defaults[_random.nextInt(defaults.length)];
  }

  /// 获取分类语料
  List<Map<String, dynamic>> getQuotesByCategory(String category) {
    if (_quotesData?['categories']?[category]?['quotes'] == null) {
      return [];
    }
    return List<Map<String, dynamic>>.from(
      _quotesData!['categories'][category]['quotes']
    );
  }

  /// 获取分类颜色
  String getCategoryColor(String category) {
    return _quotesData?['categories']?[category]?['color'] ?? '#FFB5B5';
  }

  /// 获取分类名称
  String getCategoryName(String category) {
    return _quotesData?['categories']?[category]?['name'] ?? '默认';
  }

  /// 清除冷却（用于测试）
  void clearCooldown() {
    _lastQuoteTime.clear();
  }

  /// 回退数据
  Map<String, dynamic> _getFallbackData() {
    return {
      'categories': {
        'food_peace': {
          'name': '美食与身体和解',
          'quotes': [
            {'id': 1, 'text': '这口奶油里藏着云朵的吻，吃掉它，你的心情就会变成粉色啦！✨', 'triggers': ['eating']},
          ],
        },
      },
    };
  }
}

/// 语料气泡 Widget
class QuoteBubble extends StatefulWidget {
  final String text;
  final String? category;
  final VoidCallback? onDismiss;
  final Duration displayDuration;

  const QuoteBubble({
    super.key,
    required this.text,
    this.category,
    this.onDismiss,
    this.displayDuration = const Duration(seconds: 5),
  });

  @override
  State<QuoteBubble> createState() => _QuoteBubbleState();
}

class _QuoteBubbleState extends State<QuoteBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // 淡入 + 缩放
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    // 光晕呼吸效果
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    // 自动消失
    if (widget.displayDuration.inMilliseconds > 0) {
      Future.delayed(widget.displayDuration, () {
        if (mounted) _dismiss();
      });
    }
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      widget.onDismiss?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getCategoryColor() {
    if (widget.category == null) return const Color(0xFFFFB5B5);
    
    final colorHex = QuoteEngine.instance.getCategoryColor(widget.category!);
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor();
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    categoryColor.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: categoryColor.withOpacity(_glowAnimation.value),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: categoryColor.withOpacity(_glowAnimation.value * 0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 宠物头像
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('🐻', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // 语料内容
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.category != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              QuoteEngine.instance.getCategoryName(widget.category!),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: categoryColor,
                              ),
                            ),
                          ),
                        Text(
                          widget.text,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Color(0xFF2D3436),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // 关闭按钮
                  GestureDetector(
                    onTap: _dismiss,
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
