import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:ui';
import 'dart:math' as math;

/// 全量屏幕展示器 - 45屏视觉全家桶
/// 单页垂直滚动 + 预渲染优化 + Spring Physics 转场
class AuraDemoShowcase extends StatefulWidget {
  const AuraDemoShowcase({super.key});

  @override
  State<AuraDemoShowcase> createState() => _AuraDemoShowcaseState();
}

class _AuraDemoShowcaseState extends State<AuraDemoShowcase>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  
  // 当前可见页
  int _currentPage = 0;
  
  // 预渲染控制器
  final Map<int, bool> _prerenderedPages = {};
  
  // Spring Physics 动画
  late AnimationController _springController;
  
  // 每页高度
  static const double _pageHeight = 900;
  static const int _totalPages = 45;

  @override
  void initState() {
    super.initState();
    
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    
    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    // 预渲染第一页
    _prerenderPage(0);
    _prerenderPage(1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _springController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final page = (_scrollController.offset / _pageHeight).round();
    if (page != _currentPage) {
      setState(() => _currentPage = page);
      
      // 预渲染下一页
      _prerenderPage(page - 1);
      _prerenderPage(page);
      _prerenderPage(page + 1);
    }
  }

  void _prerenderPage(int index) {
    if (index < 0 || index >= _totalPages) return;
    if (_prerenderedPages[index] == true) return;
    
    // 使用 addPostFrameCallback 预渲染
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _prerenderedPages[index] = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEDF6FA), Color(0xFFC1DDF1)],
          ),
        ),
        child: Stack(
          children: [
            // 主滚动内容
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification) {
                  _snapToPage();
                }
                return false;
              },
              child: ListView.builder(
                controller: _scrollController,
                physics: _SpringScrollPhysics(
                  damping: 14,
                  stiffness: 180,
                ),
                itemCount: _totalPages,
                itemExtent: _pageHeight,
                itemBuilder: (context, index) {
                  return _DemoPage(
                    pageIndex: index,
                    isPrerendered: _prerenderedPages[index] == true,
                  );
                },
              ),
            ),
            
            // 页面指示器
            _buildPageIndicator(),
            
            // 当前页标签
            _buildPageLabel(),
          ],
        ),
      ),
    );
  }

  void _snapToPage() {
    final targetPage = (_scrollController.offset / _pageHeight).round();
    final targetOffset = targetPage * _pageHeight;
    
    _springController.reset();
    _springController.forward();
    
    // Spring Animation
    final animation = Tween<double>(
      begin: _scrollController.offset,
      end: targetOffset,
    ).animate(CurvedAnimation(
      parent: _springController,
      curve: _SpringCurve(damping: 14, stiffness: 180),
    ));
    
    animation.addListener(() {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(animation.value.clamp(
          0,
          _scrollController.position.maxScrollExtent,
        ));
      }
    });
  }

  Widget _buildPageIndicator() {
    return Positioned(
      right: 16,
      top: MediaQuery.of(context).size.height / 2 - 100,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            _totalPages > 10 ? 10 : _totalPages,
            (index) {
              final isActive = _currentPage == index ||
                  (_currentPage >= 10 && index == 9);
              return GestureDetector(
                onTap: () {
                  _scrollController.animateTo(
                    index * _pageHeight,
                    duration: const Duration(milliseconds: 600),
                    curve: _SpringCurve(damping: 14, stiffness: 180),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  width: isActive ? 8 : 6,
                  height: isActive ? 24 : 6,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF6B9EB8)
                        : const Color(0xFFB2BEC3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPageLabel() {
    return Positioned(
      left: 16,
      top: MediaQuery.of(context).padding.top + 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Text(
          '${_currentPage + 1} / $_totalPages',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3436),
          ),
        ),
      ),
    );
  }
}

/// Spring Physics 滚动物理效果
class _SpringScrollPhysics extends ScrollPhysics {
  final double damping;
  final double stiffness;

  const _SpringScrollPhysics({
    this.damping = 14,
    this.stiffness = 180,
  });

  @override
  _SpringScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _SpringScrollPhysics(
      damping: damping,
      stiffness: stiffness,
    );
  }

  @override
  SpringDescription get spring => SpringDescription(
    mass: 1,
    stiffness: stiffness,
    damping: damping,
  );

  @override
  double get dragStartDistanceMotionThreshold => 3.5;

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return offset;
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    final tolerance = toleranceFor(position);
    
    if ((velocity.abs() < tolerance.velocity) &&
        (position.outOfRange)) {
      return SpringSimulation(
        spring,
        position.pixels,
        position.pixels < position.minScrollExtent
            ? position.minScrollExtent
            : position.maxScrollExtent,
        velocity,
        tolerance: tolerance,
      );
    }
    
    return super.createBallisticSimulation(position, velocity);
  }
}

/// Spring 曲线
class _SpringCurve extends Curve {
  final double damping;
  final double stiffness;

  const _SpringCurve({
    this.damping = 14,
    this.stiffness = 180,
  });

  @override
  double transformInternal(double t) {
    // 模拟弹簧衰减
    final omega = (stiffness / 1)math.sqrt();
    final zeta = damping / (2 * (1 * stiffness)math.sqrt());
    
    if (zeta < 1) {
      // 欠阻尼
      final omegaD = omega * (1 - zeta * zeta)math.sqrt();
      return 1 - ((-zeta * omega * t)math.exp() *
          ((zeta * omega / omegaD)math.sin() * tmath.cos() + tmath.sin() * omegaD));
    }
    
    // 默认平滑曲线
    return t * t * (3 - 2 * t);
  }
}

/// 单个演示页面
class _DemoPage extends StatelessWidget {
  final int pageIndex;
  final bool isPrerendered;

  const _DemoPage({
    required this.pageIndex,
    required this.isPrerendered,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 900,
      child: Stack(
        children: [
          // 背景装饰
          _buildBackground(),
          
          // 页面内容
          _buildPageContent(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    // 不同页面使用不同的装饰
    final colors = [
      const Color(0xFFEDF6FA),
      const Color(0xFFFFF8E1),
      const Color(0xFFFCE4EC),
      const Color(0xFFE8F5E9),
      const Color(0xFFE3F2FD),
    ];
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colors[pageIndex % colors.length],
            colors[(pageIndex + 1) % colors.length],
          ],
        ),
      ),
      child: Stack(
        children: [
          // 光斑
          Positioned(
            top: pageIndex.isEven ? 50 : 200,
            right: pageIndex.isEven ? -50 : 100,
            child: Container(
              width: 200 + (pageIndex % 3) * 50,
              height: 200 + (pageIndex % 3) * 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFB4C4).withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: pageIndex.isEven ? 100 : 50,
            left: pageIndex.isEven ? -100 : 50,
            child: Container(
              width: 150 + (pageIndex % 4) * 30,
              height: 150 + (pageIndex % 4) * 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF8FBDD3).withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent() {
    // 使用模板填充
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 页面标题
            _buildPageTitle(),
            
            const SizedBox(height: 24),
            
            // 页面内容卡片
            Expanded(
              child: _buildPageCard(),
            ),
            
            const SizedBox(height: 24),
            
            // 底部导航模拟
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageTitle() {
    final titles = [
      '🏠 首页',
      '📸 拍照记录',
      '🍽️ 饮食历史',
      '⏰ 禁食计时',
      '💧 喝水追踪',
      '⚖️ 体重记录',
      '📊 BMI计算',
      '📈 进度统计',
      '🏆 成就系统',
      '🛒 商店',
      '💳 订阅',
      '🐻 宠物详情',
      '👤 个人中心',
      '⚙️ 设置',
      '🔔 通知',
      '🎯 目标',
      '📱 拍照',
      '🍎 食物详情',
      '🎁 奖励',
      '🌟 每日任务',
      '📅 日历',
      '📰 新闻',
      '🎮 互动',
      '💬 聊天',
      '🎨 装扮',
      '🧬 健康',
      '🏃 运动',
      '😴 睡眠',
      '🧘 冥想',
      '📱 应用',
      '🔐 登录',
      '📝 注册',
      '🎉 庆祝',
      '💝 感谢',
      '🌙 晚安',
      '☀️ 早安',
      '🎊 新年',
      '❤️ 情人节',
      '🎂 生日',
      '🍀 幸运',
      '🌈 彩虹',
      '⭐ 星星',
      '🔥 热门',
      '💫 特效',
      '✨ 完成',
      '🎊 恭喜',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Text(
        titles[pageIndex % titles.length],
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Color(0xFF2D3436),
        ),
      ),
    );
  }

  Widget _buildPageCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B9EB8).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // 小熊展示
          _buildPetSection(),
          
          const SizedBox(height: 24),
          
          // 数据卡片
          _buildDataCards(),
          
          const SizedBox(height: 16),
          
          // 操作按钮
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildPetSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF9EC4).withOpacity(0.2),
            const Color(0xFFFFB4C4).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // 小熊
          _buildPetAvatar(),
          
          const SizedBox(width: 16),
          
          // 信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '小熊 · Lv.${5 + pageIndex % 10}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '✨ ${70 + pageIndex % 30} Aura',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B9EB8),
                  ),
                ),
                const SizedBox(height: 8),
                // 语料
                Text(
                  _getQuote(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF636E72),
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetAvatar() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF8E9EAB),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9EC4).withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 脸部
          Positioned(
            top: 20,
            child: Container(
              width: 50,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          // 眼睛
          Positioned(
            top: 28,
            left: 20,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2D3436),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 14),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2D3436),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          // 比心
          Positioned(
            bottom: 10,
            right: 5,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9EC4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('💕', style: TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataCards() {
    final items = [
      {'icon': '🔥', 'value': '${1000 + pageIndex * 50}', 'label': 'kcal'},
      {'icon': '💧', 'value': '${pageIndex % 10}', 'label': 'cups'},
      {'icon': '⏰', 'value': '${pageIndex % 18}:00', 'label': 'fast'},
      {'icon': '⚖️', 'value': '${60 + pageIndex % 20}', 'label': 'kg'},
    ];

    return Row(
      children: items.map((item) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5FAFC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(item['icon']!, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 4),
                Text(
                  item['value']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3436),
                  ),
                ),
                Text(
                  item['label']!,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFFB2BEC3),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    final buttons = [
      {'icon': '📸', 'label': '拍照'},
      {'icon': '💧', 'label': '喝水'},
      {'icon': '💕', 'label': '抚摸'},
    ];

    return Row(
      children: buttons.map((btn) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B9EB8),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(btn['icon']!),
                  const SizedBox(width: 4),
                  Text(
                    btn['label']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': '🏠', 'label': '首页'},
      {'icon': '📸', 'label': '记录'},
      {'icon': '⏰', 'label': '禁食'},
      {'icon': '👤', 'label': '我的'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((entry) {
          final isActive = entry.key == _currentPage % items.length;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF6B9EB8).withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  entry.value['icon']!,
                  style: const TextStyle(fontSize: 20),
                ),
                if (isActive) ...[
                  const SizedBox(width: 6),
                  Text(
                    entry.value['label']!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B9EB8),
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getQuote() {
    final quotes = [
      '这口奶油里藏着云朵的吻，吃掉它，你的心情就会变成粉色啦！✨',
      '咕嘟咕嘟...你喝下的每一口清泉，都在帮我洗亮莫奈花园里的倒影哦。🌊',
      '好想钻出屏幕抱抱你呀，感受你掌心的温度，那一定比棉花糖还软。',
      '叮！恭喜你获得\'光之追随者\'徽章。你的生命力已经溢出屏幕啦！✨',
      '你是坠入凡间的星辰，偶尔需要一点奶茶的甜来补充星际燃料呀～',
      '碳Carbon是快乐的开关。听，你的大脑正在为你疯狂鼓掌呢！',
      '别焦虑，身体只是想借这顿火锅的热气，给你一个暖洋洋的拥抱。',
      '吃饱了才有力气去追逐落日，你是最棒的食光旅行者。',
    ];
    return quotes[pageIndex % quotes.length];
  }
}
