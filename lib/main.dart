import 'package:flutter/material.dart';
import 'dart:math' as math;

/// ============================================
/// 全局用户数据
/// ============================================
class UserMetrics {
  static String? gender;
  static String? selectedChannel;
  static String? primaryGoal;
  static final Set<String> additionalGoals = {};
  static double? height;
  static double? weight;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aura-Pet Onboarding',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
        useMaterial3: true,
      ),
      home: const OnboardingNavigator(),
    );
  }
}

/// ============================================
/// 46屏导航器
/// ============================================
class OnboardingNavigator extends StatefulWidget {
  const OnboardingNavigator({super.key});

  @override
  State<OnboardingNavigator> createState() => _OnboardingNavigatorState();
}

class _OnboardingNavigatorState extends State<OnboardingNavigator> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 46;

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 禁止手势滑动
          PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _totalPages,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return SplashScreen(onComplete: _nextPage);
                case 1:
                  return WelcomeScreen(onComplete: _nextPage);
                case 2:
                  return CalorieFeatureScreen(onComplete: _nextPage);
                case 3:
                  return FastingFeatureScreen(onComplete: _nextPage);
                case 4:
                  return WeightTrendScreen(onComplete: _nextPage);
                case 5:
                  return HydrationScreen(onComplete: _nextPage);
                case 6:
                  return NutritionScreen(onComplete: _nextPage);
                case 7:
                  return ChannelSurveyScreen(onComplete: _nextPage);
                case 8:
                  return GoalSurveyScreen(onComplete: _nextPage);
                case 9:
                  return AdditionalGoalsScreen(onComplete: _nextPage);
                case 10:
                  return GenderScreen(onComplete: _nextPage);
                default:
                  return _PlaceholderPage(pageNumber: index + 1);
              }
            },
          ),
          // 页码指示器
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentPage + 1} / $_totalPages',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================
/// P1: Splash Screen - Canvas绘制调皮小熊
/// ============================================
class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();

    // 2秒后跳转下一页
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4E3F4),
      body: Center(
        child: AnimatedBuilder(
          animation: _bounceAnimation,
          builder: (context, child) {
            final bounce = math.sin(_bounceAnimation.value * math.pi * 2) * 10;
            return Transform.translate(
              offset: Offset(0, bounce),
              child: child,
            );
          },
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: CustomPaint(
              size: const Size(250, 250),
              painter: _MischievousBearPainter(),
            ),
          ),
        ),
      ),
    );
  }
}

/// ============================================
/// P2: Welcome Screen
/// ============================================
class WelcomeScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const WelcomeScreen({super.key, required this.onComplete});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late AnimationController _floatingController;
  late List<_HeartParticle> _heartParticles;

  @override
  void initState() {
    super.initState();
    
    // 心形动画
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    // 漂浮动画
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // 生成心形粒子
    _heartParticles = List.generate(12, (index) => _HeartParticle(
      x: 0.1 + math.Random().nextDouble() * 0.8,
      y: 0.1 + math.Random().nextDouble() * 0.6,
      size: 15 + math.Random().nextDouble() * 20,
      speed: 0.5 + math.Random().nextDouble() * 1.5,
      delay: math.Random().nextDouble(),
      hue: math.Random().nextDouble(),
    ));
  }

  @override
  void dispose() {
    _heartController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA), // ← CEO指定背景
      body: SafeArea(
        child: Stack(
          children: [
            // ========== 心形粒子 ==========
            ..._heartParticles.map((particle) {
              return AnimatedBuilder(
                animation: _floatingController,
                builder: (context, child) {
                  final progress = (_floatingController.value + particle.delay) % 1.0;
                  final floatY = math.sin(progress * math.pi * 2) * 15;
                  final opacity = 0.3 + math.sin(progress * math.pi) * 0.3;
                  return Positioned(
                    left: particle.x * MediaQuery.of(context).size.width,
                    top: particle.y * MediaQuery.of(context).size.height + floatY,
                    child: Opacity(
                      opacity: opacity.clamp(0.0, 1.0),
                      child: _HeartShape(size: particle.size, hue: particle.hue),
                    ),
                  );
                },
              );
            }),

            // ========== 主内容 ==========
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 顶部食物图片 + 热量气泡
                  Row(
                    children: [
                      // 食物图片占位
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                          image: const DecorationImage(
                            image: AssetImage('assets/food_bowl.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ),
                      const SizedBox(width: 16),
                      // 热量气泡
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B6B),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6B6B).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.local_fire_department, color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text(
                              '310 kcal',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // 标题
                  const Text(
                    'Reach your\nweight goals',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      height: 1.1,
                      color: Color(0xFF2D3748),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Track calories, stay hydrated,\nenjoy fasting.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),

                  const Spacer(),

                  // Canvas比心小熊
                  Center(
                    child: AnimatedBuilder(
                      animation: _heartController,
                      builder: (context, child) {
                        final scale = 1.0 + _heartController.value * 0.1;
                        return Transform.scale(
                          scale: scale,
                          child: child,
                        );
                      },
                      child: CustomPaint(
                        size: const Size(200, 200),
                        painter: _HeartBearPainter(),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // 胶囊按钮
                  GestureDetector(
                    onTap: widget.onComplete,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4CAF50).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Get started',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 心形粒子数据
class _HeartParticle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double delay;
  final double hue;
  
  _HeartParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.delay,
    required this.hue,
  });
}

/// 心形组件
class _HeartShape extends StatelessWidget {
  final double size;
  final double hue;
  
  const _HeartShape({required this.size, required this.hue});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _HeartPainter(hue: hue),
    );
  }
}

/// 心形画笔
class _HeartPainter extends CustomPainter {
  final double hue;
  
  _HeartPainter({required this.hue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = HSVColor.fromAHSV(1.0, hue * 360, 0.7, 0.9).toColor()
      ..style = PaintingStyle.fill;

    final path = Path();
    final w = size.width;
    final h = size.height;
    
    path.moveTo(w * 0.5, h * 0.25);
    path.cubicTo(w * 0.25, 0, 0, h * 0.35, 0, h * 0.55);
    path.cubicTo(0, h * 0.7, w * 0.2, h * 0.85, w * 0.5, h);
    path.cubicTo(w * 0.8, h * 0.85, w, h * 0.7, w, h * 0.55);
    path.cubicTo(w, h * 0.35, w * 0.75, 0, w * 0.5, h * 0.25);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HeartPainter oldDelegate) => oldDelegate.hue != hue;
}

/// ============================================
/// Canvas绘制：比心小熊
/// ============================================
class _HeartBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 30;

    // 头部
    final headPaint = Paint()
      ..color = const Color(0xFFD4A574)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, headPaint);

    // 耳朵
    final earPaint = Paint()..color = const Color(0xFFD4A574);
    canvas.drawCircle(
      Offset(center.dx - radius * 0.75, center.dy - radius * 0.75),
      radius * 0.35, earPaint,
    );
    canvas.drawCircle(
      Offset(center.dx - radius * 0.75, center.dy - radius * 0.75),
      radius * 0.2, Paint()..color = const Color(0xFFE8C4A0),
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.75, center.dy - radius * 0.75),
      radius * 0.35, earPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.75, center.dy - radius * 0.75),
      radius * 0.2, Paint()..color = const Color(0xFFE8C4A0),
    );

    // 面部
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.2),
        width: radius * 1.3, height: radius * 1.1,
      ),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 比心手势 - 左手
    _drawHeartHand(canvas, Offset(center.dx - radius * 0.7, center.dy - radius * 0.1), radius * 0.3);
    
    // 比心手势 - 右手
    _drawHeartHand(canvas, Offset(center.dx + radius * 0.7, center.dy - radius * 0.1), radius * 0.3);

    // 眼睛 - 爱心眼
    _drawHeartEyes(canvas, center, radius);

    // 腮红
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.45, center.dy + radius * 0.15),
        width: radius * 0.3, height: radius * 0.18,
      ),
      Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + radius * 0.45, center.dy + radius * 0.15),
        width: radius * 0.3, height: radius * 0.18,
      ),
      Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6),
    );

    // 微笑
    final smilePath = Path();
    smilePath.moveTo(center.dx - radius * 0.25, center.dy + radius * 0.35);
    smilePath.quadraticBezierTo(
      center.dx, center.dy + radius * 0.55,
      center.dx + radius * 0.25, center.dy + radius * 0.35,
    );
    canvas.drawPath(
      smilePath,
      Paint()
        ..color = const Color(0xFF8B4513)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
  }

  /// 爱心眼
  void _drawHeartEyes(Canvas canvas, Offset center, double radius) {
    final eyeY = center.dy - radius * 0.15;
    
    // 左眼爱心
    _drawHeartOnCanvas(
      canvas,
      Offset(center.dx - radius * 0.35, eyeY),
      radius * 0.2,
    );
    
    // 右眼爱心
    _drawHeartOnCanvas(
      canvas,
      Offset(center.dx + radius * 0.35, eyeY),
      radius * 0.2,
    );
  }

  void _drawHeartOnCanvas(Canvas canvas, Offset center, double size) {
    final paint = Paint()..color = const Color(0xFFFF6B6B);
    final path = Path();
    
    path.moveTo(center.dx, center.dy + size * 0.3);
    path.cubicTo(
      center.dx - size, center.dy - size * 0.3,
      center.dx - size, center.dy - size,
      center.dx, center.dy - size * 0.3,
    );
    path.cubicTo(
      center.dx + size, center.dy - size,
      center.dx + size, center.dy - size * 0.3,
      center.dx, center.dy + size * 0.3,
    );
    
    canvas.drawPath(path, paint);
  }

  /// 比心手势
  void _drawHeartHand(Canvas canvas, Offset center, double size) {
    // 手掌
    canvas.drawCircle(center, size * 0.5, Paint()..color = const Color(0xFFD4A574));
    
    // 比心圆圈
    _drawHeartOnCanvas(canvas, center, size * 0.4);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ============================================
/// P3: Calorie Feature Screen
/// ============================================
class CalorieFeatureScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const CalorieFeatureScreen({super.key, required this.onComplete});

  @override
  State<CalorieFeatureScreen> createState() => _CalorieFeatureScreenState();
}

class _CalorieFeatureScreenState extends State<CalorieFeatureScreen>
    with TickerProviderStateMixin {
  late AnimationController _excitedController;
  late AnimationController _floatingController;

  // 食物标签数据
  final List<_FoodTag> _foodTags = [
    _FoodTag(name: 'Sweet potato', calories: 120, emoji: '🍠'),
    _FoodTag(name: 'Avocado', calories: 100, emoji: '🥑'),
    _FoodTag(name: 'Chicken', calories: 165, emoji: '🍗'),
    _FoodTag(name: 'Quinoa', calories: 120, emoji: '🌾'),
  ];

  @override
  void initState() {
    super.initState();
    
    _excitedController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _excitedController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      body: SafeArea(
        child: Stack(
          children: [
            // ========== 食物标签 ==========
            ..._buildFoodTags(),

            // ========== 主内容 ==========
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // 标题
                  const Text(
                    'Track calories\nwith ease',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      height: 1.1,
                      color: Color(0xFF2D3748),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 副标题
                  Text(
                    'Just snap a photo of your meal\nand we\'ll do the rest',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),

                  const Spacer(),

                  // Canvas小熊 + 沙拉碗
                  Center(
                    child: AnimatedBuilder(
                      animation: _excitedController,
                      builder: (context, child) {
                        // 开心激动动画 - 上下弹跳 + 轻微旋转
                        final bounce = math.sin(_excitedController.value * math.pi * 2) * 8;
                        final rotate = math.sin(_excitedController.value * math.pi * 4) * 0.03;
                        return Transform.translate(
                          offset: Offset(0, bounce),
                          child: Transform.rotate(
                            angle: rotate,
                            child: child,
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 沙拉碗
                          Positioned(
                            bottom: 0,
                            child: CustomPaint(
                              size: const Size(200, 120),
                              painter: _SaladBowlPainter(),
                            ),
                          ),
                          // 小熊 - 双手合十
                          CustomPaint(
                            size: const Size(180, 180),
                            painter: _PrayingBearPainter(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // 胶囊按钮
                  GestureDetector(
                    onTap: widget.onComplete,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4CAF50).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFoodTags() {
    final positions = [
      Offset(0.15, 0.25),
      Offset(0.55, 0.20),
      Offset(0.70, 0.40),
      Offset(0.20, 0.45),
    ];

    return List.generate(_foodTags.length, (index) {
      final tag = _foodTags[index];
      final pos = positions[index];

      return AnimatedBuilder(
        animation: _floatingController,
        builder: (context, child) {
          final floatY = math.sin(_floatingController.value * math.pi * 2 + index) * 8;
          return Positioned(
            left: pos.dx * MediaQuery.of(context).size.width,
            top: pos.dy * MediaQuery.of(context).size.height + floatY,
            child: child!,
          );
        },
        child: _FoodTagWidget(tag: tag),
      );
    });
  }
}

/// 食物标签数据
class _FoodTag {
  final String name;
  final int calories;
  final String emoji;
  
  _FoodTag({
    required this.name,
    required this.calories,
    required this.emoji,
  });
}

/// 食物标签组件
class _FoodTagWidget extends StatelessWidget {
  final _FoodTag tag;
  
  const _FoodTagWidget({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tag.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tag.name,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2D3748),
                ),
              ),
              Text(
                '${tag.calories} kcal',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6B6B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ============================================
/// Canvas: 沙拉碗
/// ============================================
class _SaladBowlPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);

    // 碗身
    final bowlPath = Path();
    bowlPath.moveTo(size.width * 0.1, 0);
    bowlPath.quadraticBezierTo(
      size.width * 0.5, size.height * 0.8,
      size.width * 0.9, 0,
    );
    bowlPath.lineTo(size.width * 0.85, 0);
    bowlPath.quadraticBezierTo(
      size.width * 0.5, size.height * 0.7,
      size.width * 0.15, 0,
    );
    bowlPath.close();
    
    canvas.drawPath(
      bowlPath,
      Paint()..color = const Color(0xFFE8E8E8),
    );

    // 碗边
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.3),
      Paint()..color = Colors.white,
    );
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.3),
      Paint()
        ..color = const Color(0xFFDDDDDD)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // 碗内食物
    // 生菜
    _drawLeaf(canvas, Offset(center.dx - 30, 25), 20, const Color(0xFF90EE90));
    _drawLeaf(canvas, Offset(center.dx + 20, 20), 18, const Color(0xFF7CCD7C));
    _drawLeaf(canvas, Offset(center.dx - 10, 30), 22, const Color(0xFF66CD66));
    
    // 番茄
    canvas.drawCircle(
      Offset(center.dx + 35, 28),
      10,
      Paint()..color = const Color(0xFFFF6347),
    );
    canvas.drawCircle(
      Offset(center.dx + 35, 28),
      10,
      Paint()
        ..color = const Color(0xFFFF6347).withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // 蓝莓
    canvas.drawCircle(Offset(center.dx - 20, 35), 5, Paint()..color = const Color(0xFF4169E1));
    canvas.drawCircle(Offset(center.dx - 8, 32), 5, Paint()..color = const Color(0xFF1E90FF));
    canvas.drawCircle(Offset(center.dx + 5, 38), 4, Paint()..color = const Color(0xFF6495ED));

    // 燕麦
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx + 10, 25), width: 8, height: 5),
      Paint()..color = const Color(0xFFDEB887),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx - 25, 28), width: 7, height: 4),
      Paint()..color = const Color(0xFFD2B48C),
    );
  }

  void _drawLeaf(Canvas canvas, Offset center, double size, Color color) {
    final path = Path();
    path.moveTo(center.dx, center.dy - size);
    path.quadraticBezierTo(
      center.dx + size * 0.8, center.dy,
      center.dx, center.dy + size * 0.3,
    );
    path.quadraticBezierTo(
      center.dx - size * 0.8, center.dy,
      center.dx, center.dy - size,
    );
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ============================================
/// Canvas: 双手合十小熊
/// ============================================
class _PrayingBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // 头部
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(
      Offset(center.dx - radius * 0.75, center.dy - radius * 0.75),
      radius * 0.35, Paint()..color = const Color(0xFFD4A574),
    );
    canvas.drawCircle(
      Offset(center.dx - radius * 0.75, center.dy - radius * 0.75),
      radius * 0.2, Paint()..color = const Color(0xFFE8C4A0),
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.75, center.dy - radius * 0.75),
      radius * 0.35, Paint()..color = const Color(0xFFD4A574),
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.75, center.dy - radius * 0.75),
      radius * 0.2, Paint()..color = const Color(0xFFE8C4A0),
    );

    // 面部
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.2),
        width: radius * 1.3, height: radius * 1.1,
      ),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 惊喜眼睛 - 大圆睁眼
    _drawExcitedEye(canvas, Offset(center.dx - radius * 0.35, center.dy - radius * 0.1), radius * 0.22);
    _drawExcitedEye(canvas, Offset(center.dx + radius * 0.35, center.dy - radius * 0.1), radius * 0.22);

    // 惊讶O型嘴
    final mouthCenter = Offset(center.dx, center.dy + radius * 0.4);
    canvas.drawOval(
      Rect.fromCenter(center: mouthCenter, width: radius * 0.35, height: radius * 0.25),
      Paint()..color = const Color(0xFF8B4513),
    );
    canvas.drawOval(
      Rect.fromCenter(center: mouthCenter + const Offset(0, 3), width: radius * 0.25, height: radius * 0.15),
      Paint()..color = const Color(0xFFFF6B6B),
    );

    // 腮红
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.5, center.dy + radius * 0.1),
        width: radius * 0.35, height: radius * 0.2,
      ),
      Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + radius * 0.5, center.dy + radius * 0.1),
        width: radius * 0.35, height: radius * 0.2,
      ),
      Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6),
    );

    // ========== 双手合十 ==========
    final handY = center.dy + radius * 0.1;
    final handCenterX = center.dx;
    
    // 左手
    _drawPrayingHand(canvas, Offset(handCenterX - 25, handY), 18, -0.2);
    // 右手
    _drawPrayingHand(canvas, Offset(handCenterX + 25, handY), 18, 0.2);
  }

  void _drawExcitedEye(Canvas canvas, Offset center, double radius) {
    // 眼白
    canvas.drawCircle(center, radius, Paint()..color = Colors.white);
    // 眼眶
    canvas.drawCircle(
      center, radius,
      Paint()
        ..color = const Color(0xFF5D4037)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    // 瞳孔 - 小而圆
    canvas.drawCircle(center, radius * 0.5, Paint()..color = Colors.black);
    // 高光
    canvas.drawCircle(
      center + Offset(-radius * 0.2, -radius * 0.2),
      radius * 0.2,
      Paint()..color = Colors.white,
    );
  }

  void _drawPrayingHand(Canvas canvas, Offset center, double size, double angle) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    
    // 手掌
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: size * 1.2, height: size * 0.8),
      Paint()..color = const Color(0xFFD4A574),
    );
    
    // 手指
    for (int i = -2; i <= 2; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(i * size * 0.2, -size * 0.5),
            width: size * 0.35,
            height: size * 0.5,
          ),
          const Radius.circular(4),
        ),
        Paint()..color = const Color(0xFFD4A574),
      );
    }
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ============================================
/// P4: Fasting Feature Screen
/// ============================================
class FastingFeatureScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const FastingFeatureScreen({super.key, required this.onComplete});

  @override
  State<FastingFeatureScreen> createState() => _FastingFeatureScreenState();
}

class _FastingFeatureScreenState extends State<FastingFeatureScreen>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _ringPulseController;

  @override
  void initState() {
    super.initState();
    
    // 深眠呼吸动画 - 缓慢起伏
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    
    // 进度环脉冲动画
    _ringPulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _ringPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0033), // 深紫色背景
      body: SafeArea(
        child: Stack(
          children: [
            // ========== 绿色草地 ==========
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 150),
                painter: _GrassPainter(),
              ),
            ),

            // ========== 主内容 ==========
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // 标题
                  const Text(
                    'Enjoy fasting\nwithout the struggle',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      height: 1.1,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 副标题
                  Text(
                    'Build a healthy habit that sticks',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.4,
                    ),
                  ),

                  const Spacer(),

                  // Canvas小熊 + 禁食环
                  Center(
                    child: AnimatedBuilder(
                      animation: _breathingController,
                      builder: (context, child) {
                        // 深眠呼吸起伏
                        final breathScale = 1.0 + _breathingController.value * 0.03;
                        return Transform.scale(
                          scale: breathScale,
                          child: child,
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 禁食进度环
                          AnimatedBuilder(
                            animation: _ringPulseController,
                            builder: (context, _) {
                              final pulse = 1.0 + _ringPulseController.value * 0.05;
                              return Transform.scale(
                                scale: pulse,
                                child: CustomPaint(
                                  size: const Size(280, 280),
                                  painter: _FastingRingPainter(
                                    progress: 0.15, // 15% 完成度
                                  ),
                                ),
                              );
                            },
                          ),
                          
                          // Canvas睡熊
                          CustomPaint(
                            size: const Size(200, 180),
                            painter: _SleepingBearPainter(),
                          ),
                          
                          // 时间显示
                          Positioned(
                            bottom: 40,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '00:01:20',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // 胶囊按钮
                  GestureDetector(
                    onTap: widget.onComplete,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF9C27B0).withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================
/// Canvas: 睡帽小熊
/// ============================================
class _SleepingBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 20);
    final radius = size.width / 2 - 30;

    // ========== 身体 ==========
    // 躺着的身体
    final bodyPath = Path();
    bodyPath.moveTo(center.dx - radius * 1.2, center.dy + radius * 0.5);
    bodyPath.quadraticBezierTo(
      center.dx - radius * 0.5,
      center.dy + radius * 0.8,
      center.dx + radius * 0.3,
      center.dy + radius * 0.5,
    );
    bodyPath.quadraticBezierTo(
      center.dx + radius * 0.8,
      center.dy + radius * 0.3,
      center.dx + radius * 1.2,
      center.dy + radius * 0.2,
    );
    bodyPath.lineTo(center.dx + radius * 1.2, center.dy + radius * 0.8);
    bodyPath.lineTo(center.dx - radius * 1.2, center.dy + radius * 0.8);
    bodyPath.close();
    
    canvas.drawPath(bodyPath, Paint()..color = const Color(0xFFD4A574));

    // ========== 头部 ==========
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(
      Offset(center.dx - radius * 0.75, center.dy - radius * 0.7),
      radius * 0.3, Paint()..color = const Color(0xFFD4A574),
    );
    canvas.drawCircle(
      Offset(center.dx - radius * 0.75, center.dy - radius * 0.7),
      radius * 0.18, Paint()..color = const Color(0xFFE8C4A0),
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.75, center.dy - radius * 0.7),
      radius * 0.3, Paint()..color = const Color(0xFFD4A574),
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.75, center.dy - radius * 0.7),
      radius * 0.18, Paint()..color = const Color(0xFFE8C4A0),
    );

    // 面部
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.15),
        width: radius * 1.2, height: radius,
      ),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // ========== 睡帽 ==========
    _drawSleepingHat(canvas, Offset(center.dx, center.dy - radius * 1.0), radius * 0.8);

    // 闭眼表情 - Zzz
    _drawClosedEye(canvas, Offset(center.dx - radius * 0.35, center.dy - radius * 0.1), radius * 0.15);
    _drawClosedEye(canvas, Offset(center.dx + radius * 0.35, center.dy - radius * 0.1), radius * 0.15);

    // 微笑
    final smilePath = Path();
    smilePath.moveTo(center.dx - radius * 0.2, center.dy + radius * 0.35);
    smilePath.quadraticBezierTo(
      center.dx, center.dy + radius * 0.5,
      center.dx + radius * 0.2, center.dy + radius * 0.35,
    );
    canvas.drawPath(
      smilePath,
      Paint()
        ..color = const Color(0xFF8B4513)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    // 腮红
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.5, center.dy + radius * 0.1),
        width: radius * 0.3, height: radius * 0.15,
      ),
      Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + radius * 0.5, center.dy + radius * 0.1),
        width: radius * 0.3, height: radius * 0.15,
      ),
      Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5),
    );

    // Zzz 动画
    _drawZzz(canvas, Offset(center.dx + radius * 0.8, center.dy - radius * 0.5));
  }

  void _drawClosedEye(Canvas canvas, Offset center, double size) {
    final path = Path();
    path.moveTo(center.dx - size, center.dy);
    path.quadraticBezierTo(
      center.dx, center.dy + size,
      center.dx + size, center.dy,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF5D4037)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawSleepingHat(Canvas canvas, Offset center, double size) {
    // 帽身
    final hatPath = Path();
    hatPath.moveTo(center.dx - size * 0.6, center.dy + size * 0.5);
    hatPath.quadraticBezierTo(
      center.dx - size * 0.3, center.dy - size * 0.5,
      center.dx, center.dy - size,
    );
    hatPath.quadraticBezierTo(
      center.dx + size * 0.3, center.dy - size * 0.5,
      center.dx + size * 0.6, center.dy + size * 0.5,
    );
    hatPath.close();
    
    canvas.drawPath(hatPath, Paint()..color = const Color(0xFF9C27B0));

    // 帽边
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + size * 0.4),
        width: size * 1.4,
        height: size * 0.4,
      ),
      Paint()..color = const Color(0xFF7B1FA2),
    );

    // 帽子装饰球
    canvas.drawCircle(
      Offset(center.dx, center.dy - size),
      size * 0.15,
      Paint()..color = const Color(0xFFE1BEE7),
    );
  }

  void _drawZzz(Canvas canvas, Offset start) {
    // Zzz 文字效果
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Zzz',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF9C27B0),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, start);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ============================================
/// Canvas: 禁食进度环
/// ============================================
class _FastingRingPainter extends CustomPainter {
  final double progress;
  
  _FastingRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // 背景环
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;
    
    canvas.drawCircle(center, radius, bgPaint);

    // 进度环
    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -1.57,
        endAngle: 3.14,
        colors: const [
          Color(0xFF9C27B0),
          Color(0xFFE91E63),
          Color(0xFFFF5722),
        ],
        tileMode: TileMode.clamp,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.57, // 从12点钟方向开始
      progress * 2 * 3.14159,
      false,
      progressPaint,
    );

    // 发光效果
    final glowPaint = Paint()
      ..color = const Color(0xFFE91E63).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.57,
      progress * 2 * 3.14159,
      false,
      glowPaint,
    );

    // 开始点高光
    final startAngle = -1.57;
    final startX = center.dx + radius * math.cos(startAngle);
    final startY = center.dy + radius * math.sin(startAngle);
    canvas.drawCircle(
      Offset(startX, startY),
      10,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _FastingRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// ============================================
/// Canvas: 草地
/// ============================================
class _GrassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 草地背景
    final grassPath = Path();
    grassPath.moveTo(0, size.height * 0.3);
    
    // 波浪形草地边缘
    for (int i = 0; i <= size.width.toInt(); i += 20) {
      final y = size.height * 0.3 + math.sin(i * 0.05) * 10;
      grassPath.lineTo(i.toDouble(), y);
    }
    
    grassPath.lineTo(size.width, size.height);
    grassPath.lineTo(0, size.height);
    grassPath.close();
    
    canvas.drawPath(
      grassPath,
      Paint()..color = const Color(0xFF4CAF50),
    );

    // 小草
    for (int i = 0; i < size.width.toInt(); i += 15) {
      final grassHeight = 10.0 + math.Random(i).nextDouble() * 15;
      final x = i.toDouble();
      final y = size.height * 0.35 + math.sin(i * 0.05) * 10;
      
      final grass = Path();
      grass.moveTo(x, y);
      grass.quadraticBezierTo(
        x - 3, y - grassHeight * 0.6,
        x, y - grassHeight,
      );
      grass.quadraticBezierTo(
        x + 3, y - grassHeight * 0.6,
        x, y,
      );
      
      canvas.drawPath(
        grass,
        Paint()..color = const Color(0xFF66BB6A),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ============================================
/// P5: Weight Trend Screen
/// ============================================
class WeightTrendScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const WeightTrendScreen({super.key, required this.onComplete});

  @override
  State<WeightTrendScreen> createState() => _WeightTrendScreenState();
}

class _WeightTrendScreenState extends State<WeightTrendScreen>
    with TickerProviderStateMixin {
  late AnimationController _chartController;
  late AnimationController _bearController;

  final List<double> _weightData = [60, 62, 58, 55, 53, 51];

  @override
  void initState() {
    super.initState();
    _chartController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..forward();
    _bearController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _chartController.dispose();
    _bearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'See results\nthat inspire you',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  height: 1.1,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Watch your progress with\nbeautiful charts',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  AnimatedBuilder(
                    animation: _bearController,
                    builder: (context, child) {
                      final bounce = math.sin(_bearController.value * math.pi * 2) * 5;
                      return Transform.translate(
                        offset: Offset(0, bounce),
                        child: CustomPaint(
                          size: const Size(100, 100),
                          painter: _ExcitedHeartBearPainter(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _chartController,
                      builder: (context, child) {
                        return CustomPaint(
                          size: const Size(double.infinity, 180),
                          painter: _WeightChartPainter(
                            data: _weightData,
                            progress: _chartController.value,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatCard(label: 'Start', value: '${_weightData.first.toInt()} kg', color: const Color(0xFF4ECDC4)),
                  _StatCard(label: 'Current', value: '${_weightData.last.toInt()} kg', color: const Color(0xFFFF6B6B)),
                  _StatCard(label: 'Lost', value: '${(_weightData.first - _weightData.last).toInt()} kg', color: const Color(0xFF4CAF50)),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: widget.onComplete,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)]),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: const Color(0xFF4CAF50).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
                  ),
                  child: const Center(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Next', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ],
                  )),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: color)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14, color: color)),
        ],
      ),
    );
  }
}

/// Canvas: 心形眼神惊喜小熊
class _ExcitedHeartBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 10;
    canvas.drawCircle(c, r, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.75, c.dy - r * 0.75), r * 0.3, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.75, c.dy - r * 0.75), r * 0.18, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.75, c.dy - r * 0.75), r * 0.3, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.75, c.dy - r * 0.75), r * 0.18, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.15), width: r * 1.2, height: r), Paint()..color = const Color(0xFFE8C4A0));
    _drawHeartEye(canvas, Offset(c.dx - r * 0.32, c.dy - r * 0.15), r * 0.25);
    _drawHeartEye(canvas, Offset(c.dx + r * 0.32, c.dy - r * 0.15), r * 0.25);
    _drawStar(canvas, Offset(c.dx - r * 0.65, c.dy - r * 0.5), 8);
    _drawStar(canvas, Offset(c.dx + r * 0.65, c.dy - r * 0.5), 8);
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.35), width: r * 0.3, height: r * 0.2), Paint()..color = const Color(0xFF8B4513));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.37), width: r * 0.2, height: r * 0.12), Paint()..color = const Color(0xFFFF6B6B));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.45, c.dy + r * 0.1), width: r * 0.3, height: r * 0.18), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.45, c.dy + r * 0.1), width: r * 0.3, height: r * 0.18), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6));
  }
  void _drawHeartEye(Canvas canvas, Offset center, double size) {
    final p = Paint()..color = const Color(0xFFFF6B6B);
    final path = Path();
    path.moveTo(center.dx, center.dy + size * 0.3);
    path.cubicTo(center.dx - size * 1.2, center.dy - size * 0.3, center.dx - size * 1.2, center.dy - size * 1.2, center.dx, center.dy - size * 0.3);
    path.cubicTo(center.dx + size * 1.2, center.dy - size * 1.2, center.dx + size * 1.2, center.dy - size * 0.3, center.dx, center.dy + size * 0.3);
    canvas.drawPath(path, p);
    canvas.drawCircle(center + Offset(-size * 0.3, -size * 0.5), size * 0.2, Paint()..color = Colors.white.withOpacity(0.6));
  }
  void _drawStar(Canvas canvas, Offset center, double size) {
    final p = Paint()..color = const Color(0xFFFFD700);
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * math.pi / 5) - math.pi / 2;
      final r = i % 2 == 0 ? size : size * 0.4;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, p);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Canvas: 莫奈渐变Bezier体重曲线
class _WeightChartPainter extends CustomPainter {
  final List<double> data;
  final double progress;
  _WeightChartPainter({required this.data, required this.progress});
  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    const pad = 35.0;
    final w = size.width - pad * 2;
    final h = size.height - pad * 2;
    final maxW = data.reduce((a, b) => a > b ? a : b);
    final minW = data.reduce((a, b) => a < b ? a : b);
    final range = maxW - minW;
    List<Offset> pts = [];
    for (int i = 0; i < data.length; i++) {
      final x = pad + (i / (data.length - 1)) * w;
      final y = pad + h - ((data[i] - minW) / range) * h;
      pts.add(Offset(x, y));
    }
    if (progress < 1.0) pts = pts.sublist(0, (pts.length * progress).ceil());
    if (pts.isEmpty) return;
    
    // 填充
    final fill = Path();
    fill.moveTo(pts.first.dx, size.height - pad);
    fill.lineTo(pts.first.dx, pts.first.dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final p0 = i > 0 ? pts[i - 1] : pts[i];
      final p1 = pts[i], p2 = pts[i + 1];
      final p3 = i + 2 < pts.length ? pts[i + 2] : p2;
      fill.cubicTo(p1.dx + (p2.dx - p0.dx) / 6, p1.dy + (p2.dy - p0.dy) / 6,
                   p2.dx - (p3.dx - p1.dx) / 6, p2.dy - (p3.dy - p1.dy) / 6, p2.dx, p2.dy);
    }
    fill.lineTo(pts.last.dx, size.height - pad);
    fill.close();
    canvas.drawPath(fill, Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [const Color(0xFFB8D4E3).withOpacity(0.6), const Color(0xFFF4A460).withOpacity(0.4), const Color(0xFFE6B89C).withOpacity(0.3)]).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
    
    // 曲线
    final curve = Path();
    curve.moveTo(pts.first.dx, pts.first.dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final p0 = i > 0 ? pts[i - 1] : pts[i];
      final p1 = pts[i], p2 = pts[i + 1];
      final p3 = i + 2 < pts.length ? pts[i + 2] : p2;
      curve.cubicTo(p1.dx + (p2.dx - p0.dx) / 6, p1.dy + (p2.dy - p0.dy) / 6,
                    p2.dx - (p3.dx - p1.dx) / 6, p2.dy - (p3.dy - p1.dy) / 6, p2.dx, p2.dy);
    }
    canvas.drawPath(curve, Paint()..shader = LinearGradient(colors: [const Color(0xFF4ECDC4), const Color(0xFFFF6B6B), const Color(0xFF4CAF50)]).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke ..strokeWidth = 4 ..strokeCap = StrokeCap.round);
    
    // 数据点
    for (final pt in pts) {
      canvas.drawCircle(pt, 7, Paint()..color = Colors.white);
      canvas.drawCircle(pt, 4, Paint()..color = const Color(0xFF4CAF50));
    }
    
    // 坐标轴
    canvas.drawLine(Offset(pad, pad), Offset(pad, size.height - pad), Paint()..color = Colors.grey.withOpacity(0.3));
    canvas.drawLine(Offset(pad, size.height - pad), Offset(size.width - pad, size.height - pad), Paint()..color = Colors.grey.withOpacity(0.3));
    
    // 标签
    for (int i = 0; i <= 3; i++) {
      final y = pad + (h / 3) * i;
      final val = maxW - (range / 3) * i;
      final tp = TextPainter(text: TextSpan(text: '${val.toInt()}', style: TextStyle(fontFamily: 'Inter', fontSize: 9, color: Colors.grey.shade500)), textDirection: TextDirection.ltr);
      tp.layout(); tp.paint(canvas, Offset(2, y - tp.height / 2));
    }
    final weeks = ['W1', 'W2', 'W3', 'W4', 'W5', 'W6'];
    for (int i = 0; i < weeks.length && i < data.length; i++) {
      final x = pad + (i / (data.length - 1)) * w;
      final tp = TextPainter(text: TextSpan(text: weeks[i], style: TextStyle(fontFamily: 'Inter', fontSize: 9, color: Colors.grey.shade500)), textDirection: TextDirection.ltr);
      tp.layout(); tp.paint(canvas, Offset(x - tp.width / 2, size.height - pad + 6));
    }
  }
  @override
  bool shouldRepaint(covariant _WeightChartPainter oldDelegate) => oldDelegate.progress != progress;
}

/// ============================================
/// P6: Hydration Feature Screen
/// ============================================
class HydrationScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const HydrationScreen({super.key, required this.onComplete});

  @override
  State<HydrationScreen> createState() => _HydrationScreenState();
}

class _HydrationScreenState extends State<HydrationScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _bubbleController;
  late AnimationController _diverController;

  double _waterLevel = 0.25; // 初始25%

  @override
  void initState() {
    super.initState();
    
    _waveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _bubbleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _diverController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    _bubbleController.dispose();
    _diverController.dispose();
    super.dispose();
  }

  void _addWater() {
    setState(() {
      _waterLevel = (_waterLevel + 0.15).clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB), // 天蓝色
      body: SafeArea(
        child: Stack(
          children: [
            // ========== 水位背景 ==========
            Positioned.fill(
              bottom: 0,
              child: AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size.infinite,
                    painter: _WaterLevelPainter(
                      level: _waterLevel,
                      wavePhase: _waveController.value,
                    ),
                  );
                },
              ),
            ),

            // ========== 主内容 ==========
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // 标题
                  const Text(
                    'Stay hydrated\neffortlessly',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      height: 1.1,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 副标题
                  Text(
                    'Easily track your\nwater intake',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.4,
                    ),
                  ),

                  const Spacer(),

                  // Canvas潜水小熊 + 心形气泡
                  Center(
                    child: AnimatedBuilder(
                      animation: _diverController,
                      builder: (context, child) {
                        // 轻微上下浮动
                        final floatY = math.sin(_diverController.value * math.pi) * 8;
                        return Transform.translate(
                          offset: Offset(0, floatY),
                          child: child,
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 心形气泡
                          AnimatedBuilder(
                            animation: _bubbleController,
                            builder: (context, _) {
                              return CustomPaint(
                                size: const Size(200, 250),
                                painter: _HeartBubblesPainter(
                                  progress: _bubbleController.value,
                                ),
                              );
                            },
                          ),
                          // 潜水小熊
                          CustomPaint(
                            size: const Size(160, 180),
                            painter: _DivingBearPainter(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // + 按钮
                  Center(
                    child: GestureDetector(
                      onTap: _addWater,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            '+',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 36,
                              color: Color(0xFF2196F3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 水量显示
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${(_waterLevel * 8).toInt()} / 8 glasses',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 胶囊按钮
                  GestureDetector(
                    onTap: widget.onComplete,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2196F3).withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================
/// Canvas: 潜水小熊 (泳镜+呼吸管)
/// ============================================
class _DivingBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 20);
    final radius = size.width / 2 - 25;

    // 身体
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + radius * 0.8), width: radius * 2, height: radius * 1.5),
      Paint()..color = const Color(0xFFD4A574),
    );

    // 头部
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(center.dx - radius * 0.75, center.dy - radius * 0.7), radius * 0.28, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(center.dx - radius * 0.75, center.dy - radius * 0.7), radius * 0.16, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(center.dx + radius * 0.75, center.dy - radius * 0.7), radius * 0.28, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(center.dx + radius * 0.75, center.dy - radius * 0.7), radius * 0.16, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + radius * 0.12), width: radius * 1.1, height: radius * 0.9),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 泳镜
    _drawGoggles(canvas, center, radius);

    // 嘴 (开心)
    final smilePath = Path();
    smilePath.moveTo(center.dx - radius * 0.15, center.dy + radius * 0.45);
    smilePath.quadraticBezierTo(center.dx, center.dy + radius * 0.6, center.dx + radius * 0.15, center.dy + radius * 0.45);
    canvas.drawPath(smilePath, Paint()..color = const Color(0xFF8B4513)..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round);

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(center.dx - radius * 0.45, center.dy + radius * 0.1), width: radius * 0.25, height: radius * 0.12), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));
    canvas.drawOval(Rect.fromCenter(center: Offset(center.dx + radius * 0.45, center.dy + radius * 0.1), width: radius * 0.25, height: radius * 0.12), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));

    // 呼吸管
    _drawSnorkel(canvas, Offset(center.dx + radius * 0.3, center.dy - radius * 0.3), radius * 0.6);

    // 小翅膀/手
    canvas.drawOval(Rect.fromCenter(center: Offset(center.dx - radius * 1.0, center.dy + radius * 0.3), width: radius * 0.5, height: radius * 0.25), Paint()..color = const Color(0xFFD4A574));
    canvas.drawOval(Rect.fromCenter(center: Offset(center.dx + radius * 1.0, center.dy + radius * 0.3), width: radius * 0.5, height: radius * 0.25), Paint()..color = const Color(0xFFD4A574));
  }

  void _drawGoggles(Canvas canvas, Offset center, double radius) {
    // 左眼泳镜
    canvas.drawCircle(Offset(center.dx - radius * 0.32, center.dy - radius * 0.1), radius * 0.25, Paint()..color = const Color(0xFF2196F3));
    canvas.drawCircle(Offset(center.dx - radius * 0.32, center.dy - radius * 0.1), radius * 0.25, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 3);
    canvas.drawCircle(Offset(center.dx - radius * 0.38, center.dy - radius * 0.18), radius * 0.08, Paint()..color = Colors.white.withOpacity(0.8));

    // 右眼泳镜
    canvas.drawCircle(Offset(center.dx + radius * 0.32, center.dy - radius * 0.1), radius * 0.25, Paint()..color = const Color(0xFF2196F3));
    canvas.drawCircle(Offset(center.dx + radius * 0.32, center.dy - radius * 0.1), radius * 0.25, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 3);
    canvas.drawCircle(Offset(center.dx + radius * 0.26, center.dy - radius * 0.18), radius * 0.08, Paint()..color = Colors.white.withOpacity(0.8));

    // 泳镜带
    canvas.drawLine(Offset(center.dx - radius * 0.6, center.dy - radius * 0.1), Offset(center.dx + radius * 0.6, center.dy - radius * 0.1), Paint()..color = const Color(0xFF333333)..strokeWidth = 4);
  }

  void _drawSnorkel(Canvas canvas, Offset start, double length) {
    final path = Path();
    path.moveTo(start.dx, start.dy);
    path.quadraticBezierTo(start.dx + length * 0.3, start.dy + length * 0.5, start.dx, start.dy + length);
    canvas.drawPath(path, Paint()..color = const Color(0xFFFF6B6B)..style = PaintingStyle.stroke..strokeWidth = 6..strokeCap = StrokeCap.round);

    // 咬嘴
    canvas.drawOval(Rect.fromCenter(center: Offset(start.dx + 5, start.dy + length - 5), width: 15, height: 10), Paint()..color = const Color(0xFFFF6B6B));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ============================================
/// Canvas: 心形气泡
/// ============================================
class _HeartBubblesPainter extends CustomPainter {
  final double progress;
  _HeartBubblesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // 生成多个心形气泡
    final hearts = [
      _HeartBubble(x: 0.15, y: 0.7, size: 15, speed: 1.0, phase: 0),
      _HeartBubble(x: 0.3, y: 0.75, size: 12, speed: 1.3, phase: 0.3),
      _HeartBubble(x: 0.75, y: 0.65, size: 18, speed: 0.8, phase: 0.6),
      _HeartBubble(x: 0.85, y: 0.8, size: 10, speed: 1.1, phase: 0.9),
      _HeartBubble(x: 0.5, y: 0.85, size: 14, speed: 0.9, phase: 1.2),
    ];

    for (final heart in hearts) {
      final animProgress = (progress * heart.speed + heart.phase) % 1.0;
      final y = size.height * (1 - animProgress);
      final opacity = (1 - animProgress) * 0.7;
      final scale = 0.5 + animProgress * 0.5;

      _drawHeart(canvas, Offset(size.width * heart.x, y), heart.size * scale, opacity);
    }
  }

  void _drawHeart(Canvas canvas, Offset center, double size, double opacity) {
    final paint = Paint()..color = const Color(0xFFFF6B6B).withOpacity(opacity);
    final path = Path();
    path.moveTo(center.dx, center.dy + size * 0.3);
    path.cubicTo(center.dx - size * 1.2, center.dy - size * 0.3, center.dx - size * 1.2, center.dy - size * 1.2, center.dx, center.dy - size * 0.3);
    path.cubicTo(center.dx + size * 1.2, center.dy - size * 1.2, center.dx + size * 1.2, center.dy - size * 0.3, center.dx, center.dy + size * 0.3);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HeartBubblesPainter oldDelegate) => oldDelegate.progress != progress;
}

class _HeartBubble {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double phase;
  _HeartBubble({required this.x, required this.y, required this.size, required this.speed, required this.phase});
}

/// ============================================
/// Canvas: 水位
/// ============================================
class _WaterLevelPainter extends CustomPainter {
  final double level;
  final double wavePhase;
  _WaterLevelPainter({required this.level, required this.wavePhase});

  @override
  void paint(Canvas canvas, Size size) {
    if (level <= 0) return;

    final waterHeight = size.height * level;

    // 波浪路径
    final wavePath = Path();
    wavePath.moveTo(0, size.height - waterHeight);

    for (double x = 0; x <= size.width; x += 5) {
      final y = size.height - waterHeight + math.sin((x / size.width * 4 * math.pi) + wavePhase * 2 * math.pi) * 8;
      wavePath.lineTo(x, y);
    }

    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    // 水渐变
    canvas.drawPath(
      wavePath,
      Paint()..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF64B5F6).withOpacity(0.7),
          const Color(0xFF2196F3),
          const Color(0xFF1565C0),
        ],
      ).createShader(Rect.fromLTWH(0, size.height - waterHeight, size.width, waterHeight)),
    );

    // 水面高光
    final highlightPath = Path();
    highlightPath.moveTo(0, size.height - waterHeight);
    for (double x = 0; x <= size.width; x += 5) {
      final y = size.height - waterHeight + math.sin((x / size.width * 4 * math.pi) + wavePhase * 2 * math.pi) * 8;
      highlightPath.lineTo(x, y);
    }
    canvas.drawPath(highlightPath, Paint()..color = Colors.white.withOpacity(0.3)..style = PaintingStyle.stroke..strokeWidth = 3);
  }

  @override
  bool shouldRepaint(covariant _WaterLevelPainter oldDelegate) => oldDelegate.level != level || oldDelegate.wavePhase != wavePhase;
}

/// ============================================
/// P7: Nutrition Breakdown Screen
/// ============================================
class NutritionScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const NutritionScreen({super.key, required this.onComplete});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late AnimationController _progressController;

  // 营养数据
  final Map<String, _Nutrient> _nutrients = {
    'Carbs': _Nutrient(value: 75, max: 100, color: const Color(0xFFFFB74D), label: 'Carbs'),
    'Protein': _Nutrient(value: 45, max: 80, color: const Color(0xFF4FC3F7), label: 'Protein'),
    'Fats': _Nutrient(value: 28, max: 65, color: const Color(0xFFFF8A65), label: 'Fats'),
  };

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _heartController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      body: SafeArea(
        child: Stack(
          children: [
            // 背景装饰
            Positioned(
              top: 100,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: 200,
              left: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFB74D).withOpacity(0.1),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // 标题
                  const Text(
                    'What a well-balanced\nplate! Good job!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      height: 1.2,
                      color: Color(0xFF2D3748),
                    ),
                  ),

                  const Spacer(),

                  // Canvas小熊 + 沙拉碗
                  Center(
                    child: AnimatedBuilder(
                      animation: _heartController,
                      builder: (context, child) {
                        final scale = 1.0 + _heartController.value * 0.05;
                        final rotation = math.sin(_heartController.value * math.pi * 2) * 0.03;
                        return Transform.scale(
                          scale: scale,
                          child: Transform.rotate(
                            angle: rotation,
                            child: child,
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 沙拉碗
                          Positioned(
                            bottom: 0,
                            child: CustomPaint(
                              size: const Size(180, 100),
                              painter: _SaladBowlPainter(),
                            ),
                          ),
                          // 比心小熊
                          CustomPaint(
                            size: const Size(160, 160),
                            painter: _DoubleHeartBearPainter(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 营养进度条
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Nutrition Breakdown',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ..._nutrients.entries.map((entry) {
                              final nutrient = entry.value;
                              final progress = (nutrient.value / nutrient.max) * _progressController.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _NutrientBar(
                                  label: nutrient.label,
                                  value: nutrient.value.toInt(),
                                  progress: progress,
                                  color: nutrient.color,
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),

                  const Spacer(),

                  // 胶囊按钮
                  GestureDetector(
                    onTap: widget.onComplete,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4CAF50).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 营养数据模型
class _Nutrient {
  final double value;
  final double max;
  final Color color;
  final String label;
  _Nutrient({required this.value, required this.max, required this.color, required this.label});
}

/// 营养进度条组件
class _NutrientBar extends StatelessWidget {
  final String label;
  final int value;
  final double progress;
  final Color color;

  const _NutrientBar({
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            Text(
              '${value}g',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            // 背景
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            // 进度
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// ============================================
/// Canvas: 比心小熊 (双手比心)
/// ============================================
class _DoubleHeartBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 15;

    // 身体
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + radius * 1.0), width: radius * 1.8, height: radius * 1.2),
      Paint()..color = const Color(0xFFD4A574),
    );

    // 头部
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(center.dx - radius * 0.75, center.dy - radius * 0.75), radius * 0.3, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(center.dx - radius * 0.75, center.dy - radius * 0.75), radius * 0.18, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(center.dx + radius * 0.75, center.dy - radius * 0.75), radius * 0.3, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(center.dx + radius * 0.75, center.dy - radius * 0.75), radius * 0.18, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + radius * 0.12), width: radius * 1.1, height: radius * 0.9),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 爱心眼
    _drawHeartEye(canvas, Offset(center.dx - radius * 0.3, center.dy - radius * 0.1), radius * 0.2);
    _drawHeartEye(canvas, Offset(center.dx + radius * 0.3, center.dy - radius * 0.1), radius * 0.2);

    // 微笑嘴
    final smilePath = Path();
    smilePath.moveTo(center.dx - radius * 0.15, center.dy + radius * 0.35);
    smilePath.quadraticBezierTo(center.dx, center.dy + radius * 0.5, center.dx + radius * 0.15, center.dy + radius * 0.35);
    canvas.drawPath(smilePath, Paint()..color = const Color(0xFF8B4513)..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round);

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(center.dx - radius * 0.45, center.dy + radius * 0.05), width: radius * 0.25, height: radius * 0.12), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6));
    canvas.drawOval(Rect.fromCenter(center: Offset(center.dx + radius * 0.45, center.dy + radius * 0.05), width: radius * 0.25, height: radius * 0.12), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6));

    // ========== 双手比心 ==========
    // 左手比心
    _drawHeartHand(canvas, Offset(center.dx - radius * 0.9, center.dy + radius * 0.4), radius * 0.35, -0.3);
    // 右手比心
    _drawHeartHand(canvas, Offset(center.dx + radius * 0.9, center.dy + radius * 0.4), radius * 0.35, 0.3);
  }

  void _drawHeartEye(Canvas canvas, Offset center, double size) {
    final paint = Paint()..color = const Color(0xFFFF6B6B);
    final path = Path();
    path.moveTo(center.dx, center.dy + size * 0.3);
    path.cubicTo(center.dx - size * 1.2, center.dy - size * 0.3, center.dx - size * 1.2, center.dy - size * 1.2, center.dx, center.dy - size * 0.3);
    path.cubicTo(center.dx + size * 1.2, center.dy - size * 1.2, center.dx + size * 1.2, center.dy - size * 0.3, center.dx, center.dy + size * 0.3);
    canvas.drawPath(path, paint);
    canvas.drawCircle(center + Offset(-size * 0.3, -size * 0.5), size * 0.2, Paint()..color = Colors.white.withOpacity(0.6));
  }

  void _drawHeartHand(Canvas canvas, Offset center, double size, double angle) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    
    // 爱心形状的手
    final paint = Paint()..color = const Color(0xFFFF6B6B);
    final path = Path();
    final cx = 0.0;
    final cy = -size * 0.2;
    path.moveTo(cx, cy + size * 0.5);
    path.cubicTo(cx - size * 0.8, cy - size * 0.2, cx - size * 0.8, cy - size * 0.8, cx, cy - size * 0.2);
    path.cubicTo(cx + size * 0.8, cy - size * 0.8, cx + size * 0.8, cy - size * 0.2, cx, cy + size * 0.5);
    canvas.drawPath(path, paint);
    
    // 手腕
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(0, size * 0.5), width: size * 0.5, height: size * 0.8),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFD4A574),
    );
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ============================================
/// Canvas: 沙拉碗
/// ============================================
class _SaladBowlPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);

    // 碗身
    final bowlPath = Path();
    bowlPath.moveTo(size.width * 0.1, 0);
    bowlPath.quadraticBezierTo(size.width * 0.5, size.height * 0.8, size.width * 0.9, 0);
    bowlPath.lineTo(size.width * 0.85, 0);
    bowlPath.quadraticBezierTo(size.width * 0.5, size.height * 0.7, size.width * 0.15, 0);
    bowlPath.close();
    canvas.drawPath(bowlPath, Paint()..color = const Color(0xFFE8E8E8));

    // 碗边
    canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height * 0.35), Paint()..color = Colors.white);
    canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height * 0.35), Paint()..color = const Color(0xFFDDDDDD)..style = PaintingStyle.stroke..strokeWidth = 3);

    // 食物
    _drawLeaf(canvas, Offset(center.dx - 25, 20), 18, const Color(0xFF90EE90));
    _drawLeaf(canvas, Offset(center.dx + 15, 15), 16, const Color(0xFF7CCD7C));
    _drawLeaf(canvas, Offset(center.dx - 5, 25), 20, const Color(0xFF66CD66));
    canvas.drawCircle(Offset(center.dx + 30, 22), 8, Paint()..color = const Color(0xFFFF6347));
    canvas.drawCircle(Offset(center.dx - 15, 28), 4, Paint()..color = const Color(0xFF4169E1));
    canvas.drawCircle(Offset(center.dx - 5, 30), 4, Paint()..color = const Color(0xFF6495ED));
  }

  void _drawLeaf(Canvas canvas, Offset center, double size, Color color) {
    final path = Path();
    path.moveTo(center.dx, center.dy - size);
    path.quadraticBezierTo(center.dx + size * 0.8, center.dy, center.dx, center.dy + size * 0.3);
    path.quadraticBezierTo(center.dx - size * 0.8, center.dy, center.dx, center.dy - size);
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ============================================
/// P8: Channel Survey Screen
/// ============================================
class ChannelSurveyScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const ChannelSurveyScreen({super.key, required this.onComplete});

  @override
  State<ChannelSurveyScreen> createState() => _ChannelSurveyScreenState();
}

class _ChannelSurveyScreenState extends State<ChannelSurveyScreen> {
  String? _selectedChannel;

  final List<_ChannelOption> _channels = [
    _ChannelOption(id: 'tiktok', name: 'TikTok', icon: '🎵'),
    _ChannelOption(id: 'instagram', name: 'Instagram', icon: '📷'),
    _ChannelOption(id: 'youtube', name: 'YouTube', icon: '📺'),
    _ChannelOption(id: 'friends', name: 'Friends', icon: '👫'),
    _ChannelOption(id: 'other', name: 'Other', icon: '✨'),
  ];

  void _selectChannel(String id) {
    setState(() {
      _selectedChannel = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // 标题
              const Text(
                'How did you\nhear about us?',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  height: 1.1,
                  color: Color(0xFF2D3748),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Select one option',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 32),

              // 渠道选项列表
              Expanded(
                child: ListView.separated(
                  itemCount: _channels.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final channel = _channels[index];
                    final isSelected = _selectedChannel == channel.id;
                    return _ChannelCard(
                      channel: channel,
                      isSelected: isSelected,
                      onTap: () => _selectChannel(channel.id),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // 胶囊按钮
              GestureDetector(
                onTap: _selectedChannel != null ? widget.onComplete : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: _selectedChannel != null
                        ? const LinearGradient(
                            colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                          )
                        : null,
                    color: _selectedChannel == null ? Colors.grey.shade300 : null,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: _selectedChannel != null
                        ? [
                            BoxShadow(
                              color: const Color(0xFF4CAF50).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: _selectedChannel != null ? Colors.white : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: _selectedChannel != null ? Colors.white : Colors.grey.shade600,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// 渠道数据模型
class _ChannelOption {
  final String id;
  final String name;
  final String icon;
  _ChannelOption({required this.id, required this.name, required this.icon});
}

/// 渠道卡片组件
class _ChannelCard extends StatelessWidget {
  final _ChannelOption channel;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChannelCard({
    required this.channel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CAF50).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // 图标
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4CAF50).withOpacity(0.2)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  channel.icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // 名称
            Expanded(
              child: Text(
                channel.name,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFF2D3748),
                ),
              ),
            ),

            // 选中指示
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent,
                border: Border.all(
                  color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================
/// P9: Goal Survey Screen
/// ============================================
class GoalSurveyScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const GoalSurveyScreen({super.key, required this.onComplete});

  @override
  State<GoalSurveyScreen> createState() => _GoalSurveyScreenState();
}

class _GoalSurveyScreenState extends State<GoalSurveyScreen> {
  String? _selectedGoal;

  final List<_GoalOption> _goals = [
    _GoalOption(
      id: 'lose_weight',
      name: 'Lose weight',
      emoji: '⚖️',
      description: 'Burn fat and slim down',
    ),
    _GoalOption(
      id: 'maintain',
      name: 'Maintain weight',
      emoji: '🎯',
      description: 'Keep your current shape',
    ),
    _GoalOption(
      id: 'build_muscle',
      name: 'Build muscle',
      emoji: '💪',
      description: 'Get stronger and bigger',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // 标题
              const Text(
                'What is your\nmain goal?',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  height: 1.1,
                  color: Color(0xFF2D3748),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Choose your primary objective',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 40),

              // 目标选项列表
              Expanded(
                child: ListView.separated(
                  itemCount: _goals.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final goal = _goals[index];
                    return _GoalCard(
                      goal: goal,
                      isSelected: _selectedGoal == goal.id,
                      onTap: () {
                        setState(() {
                          _selectedGoal = goal.id;
                        });
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // 胶囊按钮
              GestureDetector(
                onTap: _selectedGoal != null ? widget.onComplete : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: _selectedGoal != null
                        ? const LinearGradient(
                            colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                          )
                        : null,
                    color: _selectedGoal == null ? Colors.grey.shade300 : null,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: _selectedGoal != null
                        ? [
                            BoxShadow(
                              color: const Color(0xFF4CAF50).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: _selectedGoal != null ? Colors.white : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: _selectedGoal != null ? Colors.white : Colors.grey.shade600,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// 目标数据模型
class _GoalOption {
  final String id;
  final String name;
  final String emoji;
  final String description;
  _GoalOption({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
  });
}

/// 目标卡片组件
class _GoalCard extends StatelessWidget {
  final _GoalOption goal;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalCard({
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CAF50).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Emoji图标
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4CAF50).withOpacity(0.2)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  goal.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // 名称和描述
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.name,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    goal.description,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // 选中指示
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent,
                border: Border.all(
                  color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================
/// P10: Additional Goals Screen (Multi-select)
/// ============================================
class AdditionalGoalsScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const AdditionalGoalsScreen({super.key, required this.onComplete});

  @override
  State<AdditionalGoalsScreen> createState() => _AdditionalGoalsScreenState();
}

class _AdditionalGoalsScreenState extends State<AdditionalGoalsScreen> {
  final Set<String> _selectedGoals = {};

  final List<_AdditionalGoal> _goals = [
    _AdditionalGoal(id: 'healthy_food', name: 'Build healthy relationship with food', emoji: '🥗'),
    _AdditionalGoal(id: 'energy', name: 'Boost daily energy', emoji: '⚡'),
    _AdditionalGoal(id: 'sleep', name: 'Improve sleep quality', emoji: '😴'),
    _AdditionalGoal(id: 'stress', name: 'Reduce stress', emoji: '🧘'),
  ];

  void _toggleGoal(String id) {
    setState(() {
      if (_selectedGoals.contains(id)) {
        _selectedGoals.remove(id);
      } else {
        _selectedGoals.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // 标题
              const Text(
                'Any additional\ngoals?',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  height: 1.1,
                  color: Color(0xFF2D3748),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Select all that apply',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 40),

              // 目标选项列表
              Expanded(
                child: ListView.separated(
                  itemCount: _goals.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final goal = _goals[index];
                    final isSelected = _selectedGoals.contains(goal.id);
                    return _AdditionalGoalCard(
                      goal: goal,
                      isSelected: isSelected,
                      onTap: () => _toggleGoal(goal.id),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // 胶囊按钮
              GestureDetector(
                onTap: _selectedGoals.isNotEmpty ? widget.onComplete : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: _selectedGoals.isNotEmpty
                        ? const LinearGradient(
                            colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                          )
                        : null,
                    color: _selectedGoals.isEmpty ? Colors.grey.shade300 : null,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: _selectedGoals.isNotEmpty
                        ? [
                            BoxShadow(
                              color: const Color(0xFF4CAF50).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: _selectedGoals.isNotEmpty ? Colors.white : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: _selectedGoals.isNotEmpty ? Colors.white : Colors.grey.shade600,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// 附加目标数据模型
class _AdditionalGoal {
  final String id;
  final String name;
  final String emoji;
  _AdditionalGoal({required this.id, required this.name, required this.emoji});
}

/// 附加目标卡片组件
class _AdditionalGoalCard extends StatelessWidget {
  final _AdditionalGoal goal;
  final bool isSelected;
  final VoidCallback onTap;

  const _AdditionalGoalCard({
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CAF50).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Emoji
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4CAF50).withOpacity(0.2)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  goal.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // 名称
            Expanded(
              child: Text(
                goal.name,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFF2D3748),
                ),
              ),
            ),

            // 复选框
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================
/// P11: Gender Selection Screen
/// ============================================
class GenderScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const GenderScreen({super.key, required this.onComplete});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // 标题
              const Text(
                "What's your\ngender?",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  height: 1.1,
                  color: Color(0xFF2D3748),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'This helps us personalize your plan',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 48),

              // 性别选项
              Expanded(
                child: Row(
                  children: [
                    // Male
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGender = 'male';
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: _selectedGender == 'male'
                                ? const Color(0xFF64B5F6).withOpacity(0.15)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: _selectedGender == 'male'
                                  ? const Color(0xFF64B5F6)
                                  : Colors.grey.shade300,
                              width: _selectedGender == 'male' ? 3 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _selectedGender == 'male'
                                    ? const Color(0xFF64B5F6).withOpacity(0.2)
                                    : Colors.black.withOpacity(0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Male图标
                              CustomPaint(
                                size: const Size(100, 100),
                                painter: _MaleIconPainter(
                                  isSelected: _selectedGender == 'male',
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Male',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: _selectedGender == 'male'
                                      ? const Color(0xFF64B5F6)
                                      : const Color(0xFF2D3748),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Female
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGender = 'female';
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: _selectedGender == 'female'
                                ? const Color(0xFFFF8A65).withOpacity(0.15)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: _selectedGender == 'female'
                                  ? const Color(0xFFFF8A65)
                                  : Colors.grey.shade300,
                              width: _selectedGender == 'female' ? 3 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _selectedGender == 'female'
                                    ? const Color(0xFFFF8A65).withOpacity(0.2)
                                    : Colors.black.withOpacity(0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Female图标
                              CustomPaint(
                                size: const Size(100, 100),
                                painter: _FemaleIconPainter(
                                  isSelected: _selectedGender == 'female',
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Female',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: _selectedGender == 'female'
                                      ? const Color(0xFFFF8A65)
                                      : const Color(0xFF2D3748),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 胶囊按钮
              GestureDetector(
                onTap: _selectedGender != null
                    ? () {
                        UserMetrics.gender = _selectedGender;
                        widget.onComplete();
                      }
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: _selectedGender != null
                        ? const LinearGradient(
                            colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                          )
                        : null,
                    color: _selectedGender == null ? Colors.grey.shade300 : null,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: _selectedGender != null
                        ? [
                            BoxShadow(
                              color: const Color(0xFF4CAF50).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: _selectedGender != null ? Colors.white : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: _selectedGender != null ? Colors.white : Colors.grey.shade600,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// ============================================
/// Canvas: Male Icon
/// ============================================
class _MaleIconPainter extends CustomPainter {
  final bool isSelected;
  _MaleIconPainter({required this.isSelected});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final color = isSelected ? const Color(0xFF64B5F6) : const Color(0xFF2D3748);

    // 圆圈
    canvas.drawCircle(
      center,
      size.width / 2 - 5,
      Paint()
        ..color = color.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    // 箭头 (简化男性符号)
    final paint = Paint()
      ..color = color
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    // 横线
    canvas.drawLine(
      Offset(center.dx - 20, center.dy),
      Offset(center.dx + 20, center.dy),
      paint,
    );
    // 右上箭头
    canvas.drawLine(
      Offset(center.dx + 10, center.dy - 10),
      Offset(center.dx + 20, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + 10, center.dy + 10),
      Offset(center.dx + 20, center.dy),
      paint,
    );
    // 左箭头
    canvas.drawLine(
      Offset(center.dx - 20, center.dy),
      Offset(center.dx - 10, center.dy - 10),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - 20, center.dy),
      Offset(center.dx - 10, center.dy + 10),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _MaleIconPainter oldDelegate) =>
      oldDelegate.isSelected != isSelected;
}

/// ============================================
/// Canvas: Female Icon
/// ============================================
class _FemaleIconPainter extends CustomPainter {
  final bool isSelected;
  _FemaleIconPainter({required this.isSelected});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final color = isSelected ? const Color(0xFFFF8A65) : const Color(0xFF2D3748);

    // 外圆
    canvas.drawCircle(
      center,
      size.width / 2 - 5,
      Paint()
        ..color = color.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    // 十字 (简化女性符号)
    final paint = Paint()
      ..color = color
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    // 竖线
    canvas.drawLine(
      Offset(center.dx, center.dy - 20),
      Offset(center.dx, center.dy + 20),
      paint,
    );
    // 横线
    canvas.drawLine(
      Offset(center.dx - 15, center.dy - 5),
      Offset(center.dx + 15, center.dy - 5),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _FemaleIconPainter oldDelegate) =>
      oldDelegate.isSelected != isSelected;
}

/// ============================================
/// 占位页
/// ============================================
class _PlaceholderPage extends StatelessWidget {
  final int pageNumber;
  const _PlaceholderPage({required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'P$pageNumber',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 64,
                color: Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '等待CEO指令...',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================
/// Canvas绘制：翻白眼小熊（复用）
/// ============================================
class _MischievousBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // 头部
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(
      Offset(center.dx - radius * 0.75, center.dy - radius * 0.75),
      radius * 0.35, Paint()..color = const Color(0xFFD4A574),
    );
    canvas.drawCircle(
      Offset(center.dx - radius * 0.75, center.dy - radius * 0.75),
      radius * 0.2, Paint()..color = const Color(0xFFE8C4A0),
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.75, center.dy - radius * 0.75),
      radius * 0.35, Paint()..color = const Color(0xFFD4A574),
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.75, center.dy - radius * 0.75),
      radius * 0.2, Paint()..color = const Color(0xFFE8C4A0),
    );

    // 面部
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.2),
        width: radius * 1.3, height: radius * 1.1,
      ),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 翻白眼
    final eyeY = center.dy - radius * 0.15;
    for (final dx in [-1.0, 1.0]) {
      final eyeCenter = Offset(center.dx + radius * 0.35 * dx, eyeY);
      canvas.drawCircle(eyeCenter, radius * 0.18, Paint()..color = Colors.white);
      canvas.drawCircle(
        eyeCenter + Offset(0, -radius * 0.06),
        radius * 0.09, Paint()..color = Colors.black,
      );
      // 下眼白
      final bottomWhite = Path();
      bottomWhite.moveTo(eyeCenter.dx - radius * 0.12, eyeCenter.dy);
      bottomWhite.quadraticBezierTo(
        eyeCenter.dx, eyeCenter.dy + radius * 0.08,
        eyeCenter.dx + radius * 0.12, eyeCenter.dy,
      );
      canvas.drawPath(bottomWhite, Paint()..color = const Color(0xFFFFCDD2));
    }

    // 嘴巴
    final mouthY = center.dy + radius * 0.35;
    final mouthPath = Path();
    mouthPath.moveTo(center.dx - radius * 0.3, mouthY);
    mouthPath.quadraticBezierTo(center.dx, mouthY + radius * 0.25, center.dx + radius * 0.3, mouthY);
    canvas.drawPath(mouthPath, Paint()..color = const Color(0xFF8B4513));
    canvas.drawPath(
      mouthPath,
      Paint()
        ..color = const Color(0xFF5D4037)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // 牙齿
    final teeth = Path();
    teeth.moveTo(center.dx - radius * 0.2, mouthY);
    teeth.lineTo(center.dx - radius * 0.2, mouthY + radius * 0.12);
    teeth.lineTo(center.dx + radius * 0.2, mouthY + radius * 0.12);
    teeth.lineTo(center.dx + radius * 0.2, mouthY);
    canvas.drawPath(teeth, Paint()..color = Colors.white);

    // 腮红
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.5, center.dy + radius * 0.15),
        width: radius * 0.25, height: radius * 0.15,
      ),
      Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + radius * 0.5, center.dy + radius * 0.15),
        width: radius * 0.25, height: radius * 0.15,
      ),
      Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5),
    );

    // 调皮舌头
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.55),
        width: radius * 0.25, height: radius * 0.2,
      ),
      Paint()..color = const Color(0xFFFF6B6B),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
