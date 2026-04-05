import 'package:flutter/material.dart';

/// 智能订阅与 Paywall 优化
/// 解锁小熊新世界的动态展示页
class SmartPaywall extends StatefulWidget {
  final VoidCallback? onSubscribe;
  final VoidCallback? onClose;

  const SmartPaywall({
    super.key,
    this.onSubscribe,
    this.onClose,
  });

  @override
  State<SmartPaywall> createState() => _SmartPaywallState();
}

class _SmartPaywallState extends State<SmartPaywall>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _petAnimationController;
  int _currentIndex = 0;

  final List<SubscriptionPlan> _plans = [
    SubscriptionPlan(
      id: 'monthly',
      name: '月光会员',
      price: 3.99,
      period: '/月',
      originalPrice: 5.99,
      features: [
        '🐻 基础小熊皮肤',
        '📊 高级数据分析',
        '💬 无限语料互动',
        '🌙 深夜模式',
      ],
      petSkin: 'basic',
      petEmoji: '🐻',
      accentColor: const Color(0xFF7BC4FF),
      popular: false,
    ),
    SubscriptionPlan(
      id: 'yearly',
      name: '年度至尊',
      price: 35.99,
      period: '/年',
      originalPrice: 71.88,
      features: [
        '👑 皇冠限定皮肤',
        '📊 全功能高级分析',
        '💬 无限语料互动',
        '🎁 优先体验新功能',
        '🏆 专属成就徽章',
        '📱 家庭共享(5设备)',
      ],
      petSkin: 'crown',
      petEmoji: '🐻‍👑',
      accentColor: const Color(0xFFFFD700),
      popular: true,
      badge: '最佳选择',
    ),
    SubscriptionPlan(
      id: 'lifetime',
      name: '永恒典藏',
      price: 99.99,
      period: '一次性',
      originalPrice: null,
      features: [
        '🌟 全部限定皮肤',
        '👗 丝绸披风装扮',
        '📊 终身高级分析',
        '💬 终身语料互动',
        '🎁 未来所有新功能',
        '💎 专属钻石标识',
        '🆕 优先内测资格',
      ],
      petSkin: 'royal',
      petEmoji: '🐻✨',
      accentColor: const Color(0xFFE8B5FF),
      popular: false,
      badge: '永久会员',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _petAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _petAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFFF8E1),
            const Color(0xFFFFE0B2),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 顶部关闭按钮
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 20),
                  ),
                ),
              ),
            ),

            // 标题
            const SizedBox(height: 20),
            const Text(
              '🌟 解锁小熊新世界',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A4063),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '选择你的专属成长方案',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF7A7590),
              ),
            ),

            // 小熊预览区域
            const SizedBox(height: 30),
            SizedBox(
              height: 200,
              child: AnimatedBuilder(
                animation: _petAnimationController,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // 光晕
                      Container(
                        width: 180 + _petAnimationController.value * 20,
                        height: 180 + _petAnimationController.value * 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              _plans[_currentIndex].accentColor
                                  .withValues(alpha: 0.4),
                              _plans[_currentIndex].accentColor
                                  .withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                      // 宠物
                      Transform.scale(
                        scale: 1 + _petAnimationController.value * 0.05,
                        child: Text(
                          _plans[_currentIndex].petEmoji,
                          style: TextStyle(fontSize: 120),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // 订阅卡片
            const SizedBox(height: 30),
            SizedBox(
              height: 380,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _plans.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  return _PlanCard(
                    plan: _plans[index],
                    isSelected: index == _currentIndex,
                  );
                },
              ),
            ),

            // 指示器
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _plans.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: index == _currentIndex ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == _currentIndex
                        ? _plans[index].accentColor
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // 订阅按钮
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: widget.onSubscribe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _plans[_currentIndex].accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    '立即解锁 ${_plans[_currentIndex].name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // 底部提示
            const Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Text(
                '随时可取消 · 7天无理由退款',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFB2BEC3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 订阅方案
class SubscriptionPlan {
  final String id;
  final String name;
  final double price;
  final String period;
  final double? originalPrice;
  final List<String> features;
  final String petSkin;
  final String petEmoji;
  final Color accentColor;
  final bool popular;
  final String? badge;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.period,
    this.originalPrice,
    required this.features,
    required this.petSkin,
    required this.petEmoji,
    required this.accentColor,
    this.popular = false,
    this.badge,
  });

  String get priceText => '\$$price';
}

/// 方案卡片
class _PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isSelected;

  const _PlanCard({
    required this.plan,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(
        horizontal: isSelected ? 0 : 8,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? plan.accentColor : Colors.transparent,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: plan.accentColor.withValues(alpha: isSelected ? 0.3 : 0.1),
            blurRadius: isSelected ? 20 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          if (plan.badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: plan.accentColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                plan.badge!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

          const SizedBox(height: 12),

          // 名称
          Text(
            plan.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A4063),
            ),
          ),

          const SizedBox(height: 8),

          // 价格
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                plan.priceText,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: plan.accentColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  plan.period,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7A7590),
                  ),
                ),
              ),
              if (plan.originalPrice != null) ...[
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '\$${plan.originalPrice}',
                    style: const TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.lineThrough,
                      color: Color(0xFFB2BEC3),
                    ),
                  ),
                ),
              ],
            ],
          ),

          if (plan.originalPrice != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '节省 \$${(plan.originalPrice! - plan.price).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12,
                  color: plan.accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),

          // 功能列表
          ...plan.features.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 18,
                  color: plan.accentColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    feature,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF636E72),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

/// Paywall 状态管理器
class PaywallManager {
  static PaywallManager? _instance;
  static PaywallManager get instance => _instance ??= PaywallManager._();
  PaywallManager._();

  /// 检查用户是否已订阅
  bool isSubscribed = false;
  String? currentPlan;

  /// 订阅成功回调
  void onSubscribe(String planId) {
    isSubscribed = true;
    currentPlan = planId;
    // 保存到本地存储
  }

  /// 检查订阅状态
  Future<bool> checkSubscriptionStatus() async {
    // 实际项目中检查服务器或本地存储
    return isSubscribed;
  }

  /// 获取当前订阅方案
  String? getCurrentPlan() => currentPlan;

  /// 获取小熊皮肤
  String getPetSkin() {
    switch (currentPlan) {
      case 'monthly':
        return 'basic';
      case 'yearly':
        return 'crown';
      case 'lifetime':
        return 'royal';
      default:
        return 'default';
    }
  }

  /// 解锁皮肤
  void unlockSkin(String skinId) {
    // 实际项目中保存解锁状态
  }
}
