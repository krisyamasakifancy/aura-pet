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
  static int? age;
  static double? goalWeight;
  static String? activityLevel;
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
                case 11:
                  return AgeScreen(onComplete: _nextPage);
                case 12:
                  return HeightScreen(onComplete: _nextPage);
                case 13:
                  return WeightScreen(onComplete: _nextPage);
                case 14:
                  return GoalWeightScreen(onComplete: _nextPage);
                case 15:
                  return ActivityScreen(onComplete: _nextPage);
                case 16:
                  return AnalyzingScreen(onComplete: _nextPage);
                case 17:
                  return PlanReadyScreen(onComplete: _nextPage);
                case 18:
                  return ReviewsScreen(onComplete: _nextPage);
                case 19:
                  return NotificationScreen(onComplete: _nextPage);
                case 20:
                  return CreatingPlanScreen(onComplete: _nextPage);
                case 21:
                  return WeightPredictionScreen(onComplete: _nextPage);
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
/// P12: Age Input Screen
/// ============================================
class AgeScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const AgeScreen({super.key, required this.onComplete});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> with SingleTickerProviderStateMixin {
  late FixedExtentScrollController _scrollController;
  late AnimationController _bearController;
  
  int _selectedAge = 25;
  final int _minAge = 18;
  final int _maxAge = 80;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(initialItem: _selectedAge - _minAge);
    _bearController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
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

              // 标题
              const Text(
                'How old\nare you?',
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
                'Slide to select your age',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 24),

              // Canvas好奇小熊
              Center(
                child: AnimatedBuilder(
                  animation: _bearController,
                  builder: (context, child) {
                    final tilt = math.sin(_bearController.value * math.pi * 2) * 0.05;
                    return Transform.rotate(
                      angle: tilt,
                      child: child,
                    );
                  },
                  child: CustomPaint(
                    size: const Size(100, 100),
                    painter: _CuriousBearPainter(),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 年龄显示
              Center(
                child: TweenAnimationBuilder<int>(
                  tween: IntTween(begin: _selectedAge, end: _selectedAge),
                  duration: const Duration(milliseconds: 100),
                  builder: (context, value, child) {
                    return Text(
                      '$value',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 72,
                        color: Color(0xFF4CAF50),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // 刻度尺选择器
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 刻度尺
                    Container(
                      height: 100,
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
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        physics: const FixedExtentScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        itemCount: _maxAge - _minAge + 1,
                        itemBuilder: (context, index) {
                          final age = _minAge + index;
                          final isSelected = age == _selectedAge;
                          return GestureDetector(
                            onTap: () {
                              _scrollController.animateToItem(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 50,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: isSelected ? 4 : 2,
                                    height: isSelected ? 60 : 40,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF4CAF50)
                                          : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 200),
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: isSelected ? 16 : 12,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected
                                          ? const Color(0xFF4CAF50)
                                          : Colors.grey.shade500,
                                    ),
                                    child: Text('$age'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // 中间指示器
                    Container(
                      width: 3,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4CAF50).withOpacity(0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 胶囊按钮
              GestureDetector(
                onTap: () {
                  UserMetrics.age = _selectedAge;
                  widget.onComplete();
                },
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
      ),
    );
  }
}

/// ============================================
/// Canvas: 好奇小熊
/// ============================================
class _CuriousBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // 身体
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + radius * 1.0), width: radius * 1.8, height: radius * 1.2),
      Paint()..color = const Color(0xFFD4A574),
    );

    // 头部
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(center.dx - radius * 0.75, center.dy - radius * 0.75), radius * 0.28, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(center.dx - radius * 0.75, center.dy - radius * 0.75), radius * 0.16, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(center.dx + radius * 0.75, center.dy - radius * 0.75), radius * 0.28, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(center.dx + radius * 0.75, center.dy - radius * 0.75), radius * 0.16, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + radius * 0.12), width: radius * 1.1, height: radius * 0.9),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 好奇眼睛 - 一大一小
    _drawCuriousEye(canvas, Offset(center.dx - radius * 0.3, center.dy - radius * 0.1), radius * 0.22);
    _drawCuriousEye(canvas, Offset(center.dx + radius * 0.3, center.dy - radius * 0.15), radius * 0.18);

    // 问号表情
    _drawQuestionMouth(canvas, center, radius);

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(center.dx - radius * 0.45, center.dy + radius * 0.1), width: radius * 0.25, height: radius * 0.12), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));
    canvas.drawOval(Rect.fromCenter(center: Offset(center.dx + radius * 0.45, center.dy + radius * 0.1), width: radius * 0.25, height: radius * 0.12), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));
  }

  void _drawCuriousEye(Canvas canvas, Offset center, double radius) {
    // 眼白
    canvas.drawCircle(center, radius, Paint()..color = Colors.white);
    // 眼眶
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    // 大瞳孔
    canvas.drawCircle(center, radius * 0.6, Paint()..color = Colors.black);
    // 高光
    canvas.drawCircle(center + Offset(-radius * 0.2, -radius * 0.2), radius * 0.25, Paint()..color = Colors.white);
  }

  void _drawQuestionMouth(Canvas canvas, Offset center, double radius) {
    // 小O型好奇嘴
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + radius * 0.4), width: radius * 0.2, height: radius * 0.15),
      Paint()..color = const Color(0xFF8B4513),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + radius * 0.42), width: radius * 0.12, height: radius * 0.08),
      Paint()..color = const Color(0xFFFF6B6B),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ============================================

/// ============================================
/// P12: Age Input Screen
/// ============================================
class AgeScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const AgeScreen({super.key, required this.onComplete});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> with SingleTickerProviderStateMixin {
  late FixedExtentScrollController _scrollController;
  late AnimationController _bearController;
  
  int _selectedAge = 25;
  final int _minAge = 18;
  final int _maxAge = 80;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(initialItem: _selectedAge - _minAge);
    _bearController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
                'How old\nare you?',
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
                'Slide to select your age',
                style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              Center(
                child: AnimatedBuilder(
                  animation: _bearController,
                  builder: (context, child) {
                    final tilt = math.sin(_bearController.value * math.pi * 2) * 0.05;
                    return Transform.rotate(angle: tilt, child: child);
                  },
                  child: CustomPaint(size: const Size(100, 100), painter: _CuriousBearPainter()),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  '$_selectedAge',
                  style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 72, color: Color(0xFF4CAF50)),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        physics: const FixedExtentScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        itemCount: _maxAge - _minAge + 1,
                        itemBuilder: (context, index) {
                          final age = _minAge + index;
                          final isSelected = age == _selectedAge;
                          return GestureDetector(
                            onTap: () => _scrollController.animateToItem(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOut),
                            child: AnimatedBuilder(
                              animation: _scrollController,
                              builder: (context, child) {
                                final currentIndex = _scrollController.hasClients ? _scrollController.selectedItem : 7;
                                final selected = (currentIndex + _minAge) == age;
                                if (age == _selectedAge && age != (currentIndex + _minAge)) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    if (mounted) setState(() {});
                                  });
                                }
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 50,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        width: selected ? 4 : 2,
                                        height: selected ? 60 : 40,
                                        decoration: BoxDecoration(
                                          color: selected ? const Color(0xFF4CAF50) : Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      AnimatedDefaultTextStyle(
                                        duration: const Duration(milliseconds: 200),
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: selected ? 16 : 12,
                                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                                          color: selected ? const Color(0xFF4CAF50) : Colors.grey.shade500,
                                        ),
                                        child: Text('$age'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      width: 3,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [BoxShadow(color: const Color(0xFF4CAF50).withOpacity(0.5), blurRadius: 8)],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  UserMetrics.age = _selectedAge;
                  widget.onComplete();
                },
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

/// Canvas: 好奇小熊
class _CuriousBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 10;
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy + r * 1.0), width: r * 1.8, height: r * 1.2), Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(c, r, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.75, c.dy - r * 0.75), r * 0.28, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.75, c.dy - r * 0.75), r * 0.16, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.75, c.dy - r * 0.75), r * 0.28, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.75, c.dy - r * 0.75), r * 0.16, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.12), width: r * 1.1, height: r * 0.9), Paint()..color = const Color(0xFFE8C4A0));
    _drawCuriousEye(canvas, Offset(c.dx - r * 0.3, c.dy - r * 0.1), r * 0.22);
    _drawCuriousEye(canvas, Offset(c.dx + r * 0.3, c.dy - r * 0.15), r * 0.18);
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.4), width: r * 0.2, height: r * 0.15), Paint()..color = const Color(0xFF8B4513));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.42), width: r * 0.12, height: r * 0.08), Paint()..color = const Color(0xFFFF6B6B));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.45, c.dy + r * 0.1), width: r * 0.25, height: r * 0.12), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.45, c.dy + r * 0.1), width: r * 0.25, height: r * 0.12), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));
  }
  void _drawCuriousEye(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius, Paint()..color = Colors.white);
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    canvas.drawCircle(center, radius * 0.6, Paint()..color = Colors.black);
    canvas.drawCircle(center + Offset(-radius * 0.2, -radius * 0.2), radius * 0.25, Paint()..color = Colors.white);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


/// ============================================
/// P13: Height Input Screen
/// ============================================
class HeightScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const HeightScreen({super.key, required this.onComplete});

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> with SingleTickerProviderStateMixin {
  late FixedExtentScrollController _cmController;
  late AnimationController _bearController;
  
  bool _isCm = true;
  int _selectedCm = 170;
  int _selectedFt = 5;
  int _selectedIn = 7;
  
  final int _minCm = 100;
  final int _maxCm = 220;

  @override
  void initState() {
    super.initState();
    _cmController = FixedExtentScrollController(initialItem: _selectedCm - _minCm);
    _bearController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cmController.dispose();
    _bearController.dispose();
    super.dispose();
  }

  String get _displayHeight {
    if (_isCm) {
      return '$_selectedCm cm';
    } else {
      return "$_selectedFt' $_selectedIn\"";
    }
  }

  double get _heightInCm {
    if (_isCm) return _selectedCm.toDouble();
    return (_selectedFt * 30.48) + (_selectedIn * 2.54);
  }

  void _toggleUnit() {
    setState(() {
      _isCm = !_isCm;
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
              const SizedBox(height: 20),
              
              // 标题
              const Text(
                'How tall\nare you?',
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
                'Slide to measure your height',
                style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: Colors.grey.shade600),
              ),

              const SizedBox(height: 16),

              // CM/FT切换按钮
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _UnitButton(label: 'CM', isSelected: _isCm, onTap: () { if (!_isCm) _toggleUnit(); }),
                      _UnitButton(label: 'FT', isSelected: !_isCm, onTap: () { if (_isCm) _toggleUnit(); }),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 主内容区
              Expanded(
                child: Row(
                  children: [
                    // Canvas小熊 (高度随标尺浮动)
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: Listenable.merge([_bearController, _cmController]),
                          builder: (context, child) {
                            // 小熊高度随标尺数值变化 (100-220 -> 0.5-1.2)
                            final heightRatio = ((_heightInCm - 100) / 120).clamp(0.0, 1.0);
                            final bearScale = 0.7 + heightRatio * 0.5;
                            final floatY = math.sin(_bearController.value * math.pi * 2) * 5;
                            return Transform.translate(
                              offset: Offset(0, floatY),
                              child: Transform.scale(
                                scale: bearScale,
                                child: child,
                              ),
                            );
                          },
                          child: CustomPaint(
                            size: const Size(150, 200),
                            painter: _MeasuringBearPainter(),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // 垂直标尺
                    Expanded(
                      flex: 1,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 刻度尺
                          Container(
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                            ),
                            child: _isCm
                                ? ListView.builder(
                                    controller: _cmController,
                                    physics: const FixedExtentScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(vertical: 60),
                                    itemCount: _maxCm - _minCm + 1,
                                    itemBuilder: (context, index) {
                                      final cm = _minCm + index;
                                      final isSelected = cm == _selectedCm;
                                      return GestureDetector(
                                        onTap: () => _cmController.animateToItem(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOut),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          height: 20,
                                          alignment: Alignment.centerRight,
                                          padding: const EdgeInsets.only(right: 8),
                                          child: Column(
                                            children: [
                                              AnimatedContainer(
                                                duration: const Duration(milliseconds: 200),
                                                width: isSelected ? 30 : (cm % 10 == 0 ? 20 : 10),
                                                height: isSelected ? 3 : (cm % 10 == 0 ? 2 : 1),
                                                color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade400,
                                              ),
                                              if (cm % 10 == 0)
                                                AnimatedDefaultTextStyle(
                                                  duration: const Duration(milliseconds: 200),
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: isSelected ? 14 : 10,
                                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                    color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade500,
                                                  ),
                                                  child: Text('$cm'),
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : _FtPicker(
                                    selectedFt: _selectedFt,
                                    selectedIn: _selectedIn,
                                    onFtChanged: (ft) => setState(() => _selectedFt = ft),
                                    onInChanged: ( inch) => setState(() => _selectedIn = inch),
                                  ),
                          ),

                          // 中间指示器
                          Container(
                            width: 40,
                            height: 3,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50),
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [BoxShadow(color: const Color(0xFF4CAF50).withOpacity(0.5), blurRadius: 8)],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 身高显示
              Center(
                child: Text(
                  _displayHeight,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Next胶囊按钮
              GestureDetector(
                onTap: () {
                  UserMetrics.height = _heightInCm;
                  widget.onComplete();
                },
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

/// 单位切换按钮
class _UnitButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _UnitButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}

/// FT选择器
class _FtPicker extends StatelessWidget {
  final int selectedFt;
  final int selectedIn;
  final Function(int) onFtChanged;
  final Function(int) onInChanged;

  const _FtPicker({
    required this.selectedFt,
    required this.selectedIn,
    required this.onFtChanged,
    required this.onInChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$selectedFt\' ${selectedIn}"', style: const TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50))),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _MiniWheelPicker(
              value: selectedFt,
              min: 3,
              max: 7,
              onChanged: onFtChanged,
              label: 'ft',
            ),
            const SizedBox(width: 8),
            _MiniWheelPicker(
              value: selectedIn,
              min: 0,
              max: 11,
              onChanged: onInChanged,
              label: 'in',
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniWheelPicker extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final Function(int) onChanged;
  final String label;

  const _MiniWheelPicker({required this.value, required this.min, required this.max, required this.onChanged, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.builder(
        itemCount: max - min + 1,
        itemBuilder: (context, index) {
          final v = min + index;
          final isSelected = v == value;
          return GestureDetector(
            onTap: () => onChanged(v),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 30,
              alignment: Alignment.center,
              color: isSelected ? const Color(0xFF4CAF50).withOpacity(0.2) : Colors.transparent,
              child: Text(
                '$v',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: isSelected ? 16 : 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? const Color(0xFF4CAF50) : Colors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Canvas: 测量小熊 (直立姿势)
class _MeasuringBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 10;

    // 身体 (直立)
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.8), width: r * 1.5, height: r * 2), Paint()..color = const Color(0xFFD4A574));

    // 头部
    canvas.drawCircle(Offset(c.dx, c.dy - r * 0.5), r * 0.8, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.6, c.dy - r * 1.1), r * 0.25, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.6, c.dy - r * 1.1), r * 0.15, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.6, c.dy - r * 1.1), r * 0.25, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.6, c.dy - r * 1.1), r * 0.15, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy - r * 0.4), width: r * 1.0, height: r * 0.8), Paint()..color = const Color(0xFFE8C4A0));

    // 测量眼睛 (认真表情)
    _drawMeasuringEye(canvas, Offset(c.dx - r * 0.25, c.dy - r * 0.55), r * 0.15);
    _drawMeasuringEye(canvas, Offset(c.dx + r * 0.25, c.dy - r * 0.55), r * 0.15);

    // 认真嘴
    final smilePath = Path();
    smilePath.moveTo(c.dx - r * 0.15, c.dy - r * 0.15);
    smilePath.lineTo(c.dx + r * 0.15, c.dy - r * 0.15);
    canvas.drawPath(smilePath, Paint()..color = const Color(0xFF8B4513)..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round);

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.35, c.dy - r * 0.3), width: r * 0.2, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.35, c.dy - r * 0.3), width: r * 0.2, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));

    // 手 (举起来测量姿势)
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.8, c.dy - r * 0.2), width: r * 0.4, height: r * 0.25), Paint()..color = const Color(0xFFD4A574));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.8, c.dy - r * 0.2), width: r * 0.4, height: r * 0.25), Paint()..color = const Color(0xFFD4A574));

    // 脚
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.4, c.dy + r * 1.6), width: r * 0.5, height: r * 0.3), Paint()..color = const Color(0xFFD4A574));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.4, c.dy + r * 1.6), width: r * 0.5, height: r * 0.3), Paint()..color = const Color(0xFFD4A574));
  }

  void _drawMeasuringEye(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius, Paint()..color = Colors.black);
    canvas.drawCircle(center + Offset(-radius * 0.3, -radius * 0.3), radius * 0.3, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


/// ============================================
/// P14: Weight Input Screen
/// ============================================
class WeightScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const WeightScreen({super.key, required this.onComplete});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> with SingleTickerProviderStateMixin {
  late AnimationController _dialController;
  late AnimationController _bearController;
  
  double _selectedWeight = 65.0;
  final double _minWeight = 30.0;
  final double _maxWeight = 200.0;
  final double _precision = 0.5;

  @override
  void initState() {
    super.initState();
    _dialController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _bearController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _dialController.dispose();
    _bearController.dispose();
    super.dispose();
  }

  void _updateWeight(double delta) {
    setState(() {
      _selectedWeight = (_selectedWeight + delta).clamp(_minWeight, _maxWeight);
      _selectedWeight = double.parse(_selectedWeight.toStringAsFixed(1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748), // 深色背景模拟机械秤
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // 标题
              const Text(
                "What's your\ncurrent weight?",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  height: 1.1,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Turn the dial to adjust',
                style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: Colors.white.withOpacity(0.7)),
              ),

              const Spacer(),

              // 主内容区
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Canvas小熊
                    AnimatedBuilder(
                      animation: _bearController,
                      builder: (context, child) {
                        final tilt = math.sin(_bearController.value * math.pi * 2) * 0.03;
                        return Transform.rotate(
                          angle: tilt,
                          child: child,
                        );
                      },
                      child: CustomPaint(
                        size: const Size(120, 120),
                        painter: _ScaleBearPainter(),
                      ),
                    ),

                    const SizedBox(width: 32),

                    // 弧形转盘
                    GestureDetector(
                      onPanUpdate: (details) {
                        // 根据拖动方向调整体重
                        final center = const Offset(120, 120);
                        final touchPos = details.localPosition;
                        final angle = math.atan2(touchPos.dy - center.dy, touchPos.dx - center.dx);
                        
                        // 拖动增量
                        final delta = -details.delta.dy * 0.2;
                        _updateWeight(delta);
                      },
                      child: CustomPaint(
                        size: const Size(240, 240),
                        painter: _WeightDialPainter(
                          weight: _selectedWeight,
                          minWeight: _minWeight,
                          maxWeight: _maxWeight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // +/- 按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // - 按钮
                  _WeightButton(
                    icon: Icons.remove,
                    onTap: () => _updateWeight(-_precision),
                    onLongPressStart: () => _dialController.repeat(),
                    onLongPressEnd: () => _dialController.stop(),
                  ),
                  const SizedBox(width: 24),
                  
                  // 体重显示
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${_selectedWeight.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 48,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'kg',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 24),
                  
                  // + 按钮
                  _WeightButton(
                    icon: Icons.add,
                    onTap: () => _updateWeight(_precision),
                    onLongPressStart: () => _dialController.repeat(),
                    onLongPressEnd: () => _dialController.stop(),
                  ),
                ],
              ),

              const Spacer(),

              // Next胶囊按钮
              GestureDetector(
                onTap: () {
                  UserMetrics.weight = _selectedWeight;
                  widget.onComplete();
                },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)]),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: const Color(0xFF4CAF50).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))],
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

/// 加减按钮
class _WeightButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback onLongPressStart;
  final VoidCallback onLongPressEnd;

  const _WeightButton({
    required this.icon,
    required this.onTap,
    required this.onLongPressStart,
    required this.onLongPressEnd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPressStart: (_) => onLongPressStart(),
      onLongPressEnd: (_) => onLongPressEnd(),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}

/// Canvas: 转盘
class _WeightDialPainter extends CustomPainter {
  final double weight;
  final double minWeight;
  final double maxWeight;

  _WeightDialPainter({required this.weight, required this.minWeight, required this.maxWeight});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // 外圈
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFF3D4F5F)
        ..style = PaintingStyle.fill,
    );

    // 刻度环
    canvas.drawCircle(
      center,
      radius - 5,
      Paint()
        ..color = const Color(0xFF2D3748)
        ..style = PaintingStyle.fill,
    );

    // 绘制刻度
    final totalRange = maxWeight - minWeight;
    final angleRange = 270.0; // 270度范围
    const startAngle = 135.0; // 从左下开始

    for (int i = 0; i <= (totalRange / 5).toInt(); i++) {
      final tickWeight = minWeight + i * 5;
      final progress = (tickWeight - minWeight) / totalRange;
      final angle = (startAngle + progress * angleRange) * math.pi / 180;

      final isMainTick = i % 2 == 0;
      final tickLength = isMainTick ? 15.0 : 8.0;
      final tickWidth = isMainTick ? 3.0 : 1.5;

      final outerRadius = radius - 15;
      final innerRadius = outerRadius - tickLength;

      final outerX = center.dx + outerRadius * math.cos(angle);
      final outerY = center.dy + outerRadius * math.sin(angle);
      final innerX = center.dx + innerRadius * math.cos(angle);
      final innerY = center.dy + innerRadius * math.sin(angle);

      canvas.drawLine(
        Offset(outerX, outerY),
        Offset(innerX, innerY),
        Paint()
          ..color = isMainTick ? Colors.white : Colors.white54
          ..strokeWidth = tickWidth
          ..strokeCap = StrokeCap.round,
      );

      // 刻度数字
      if (isMainTick) {
        final textRadius = innerRadius - 15;
        final textX = center.dx + textRadius * math.cos(angle);
        final textY = center.dy + textRadius * math.sin(angle);

        final textPainter = TextPainter(
          text: TextSpan(
            text: '${tickWeight.toInt()}',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              color: Colors.white70,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        canvas.save();
        canvas.translate(textX - textPainter.width / 2, textY - textPainter.height / 2);
        canvas.rotate(angle + math.pi / 2);
        textPainter.paint(canvas, Offset.zero);
        canvas.restore();
      }
    }

    // 中心圆
    canvas.drawCircle(
      center,
      radius * 0.35,
      Paint()
        ..color = const Color(0xFF1A202C)
        ..style = PaintingStyle.fill,
    );

    // 指针 (指向当前体重)
    final progress = (weight - minWeight) / totalRange;
    final pointerAngle = (startAngle + progress * angleRange) * math.pi / 180;
    final pointerRadius = radius - 30;

    canvas.drawLine(
      center,
      Offset(
        center.dx + pointerRadius * math.cos(pointerAngle),
        center.dy + pointerRadius * math.sin(pointerAngle),
      ),
      Paint()
        ..color = const Color(0xFFFF6B6B)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );

    // 指针圆头
    canvas.drawCircle(
      Offset(
        center.dx + pointerRadius * math.cos(pointerAngle),
        center.dy + pointerRadius * math.sin(pointerAngle),
      ),
      6,
      Paint()..color = const Color(0xFFFF6B6B),
    );
  }

  @override
  bool shouldRepaint(covariant _WeightDialPainter oldDelegate) =>
      oldDelegate.weight != weight;
}

/// Canvas: 体重秤旁小熊
class _ScaleBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 10;

    // 身体
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.8), width: r * 1.6, height: r * 1.2), Paint()..color = const Color(0xFFD4A574));

    // 头
    canvas.drawCircle(c, r, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.75, c.dy - r * 0.75), r * 0.28, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.75, c.dy - r * 0.75), r * 0.16, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.75, c.dy - r * 0.75), r * 0.28, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.75, c.dy - r * 0.75), r * 0.16, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.12), width: r * 1.1, height: r * 0.9), Paint()..color = const Color(0xFFE8C4A0));

    // 眼睛 (期待表情)
    canvas.drawCircle(Offset(c.dx - r * 0.3, c.dy - r * 0.1), r * 0.18, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(c.dx - r * 0.35, c.dy - r * 0.18), r * 0.08, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(c.dx + r * 0.3, c.dy - r * 0.1), r * 0.18, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(c.dx + r * 0.25, c.dy - r * 0.18), r * 0.08, Paint()..color = Colors.white);

    // 期待嘴 (微微张开)
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.38), width: r * 0.2, height: r * 0.15), Paint()..color = const Color(0xFF8B4513));

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.45, c.dy + r * 0.1), width: r * 0.25, height: r * 0.12), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.45, c.dy + r * 0.1), width: r * 0.25, height: r * 0.12), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));

    // 手 (扶着秤的姿势)
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 1.0, c.dy + r * 0.5), width: r * 0.4, height: r * 0.25), Paint()..color = const Color(0xFFD4A574));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ============================================
/// P15: Goal Weight Screen
/// ============================================
class GoalWeightScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const GoalWeightScreen({super.key, required this.onComplete});

  @override
  State<GoalWeightScreen> createState() => _GoalWeightScreenState();
}

class _GoalWeightScreenState extends State<GoalWeightScreen> with SingleTickerProviderStateMixin {
  late AnimationController _bearController;
  
  double _goalWeight = 60.0;
  final double _minWeight = 30.0;
  final double _maxWeight = 200.0;
  final double _precision = 0.5;

  // 从UserMetrics获取当前体重
  double get _currentWeight => UserMetrics.weight ?? 65.0;
  double get _weightDiff => _currentWeight - _goalWeight;
  String get _diffText {
    final diff = _weightDiff;
    if (diff > 0) {
      return '目标：减重 ${diff.toStringAsFixed(1)} kg';
    } else if (diff < 0) {
      return '目标：增重 ${(-diff).toStringAsFixed(1)} kg';
    } else {
      return '目标：保持当前体重';
    }
  }

  @override
  void initState() {
    super.initState();
    // 初始目标比当前少5kg
    _goalWeight = (_currentWeight - 5.0).clamp(_minWeight, _maxWeight);
    _goalWeight = double.parse(_goalWeight.toStringAsFixed(1));
    
    _bearController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bearController.dispose();
    super.dispose();
  }

  void _updateWeight(double delta) {
    setState(() {
      _goalWeight = (_goalWeight + delta).clamp(_minWeight, _maxWeight);
      _goalWeight = double.parse(_goalWeight.toStringAsFixed(1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A3728), // 暖色深棕背景
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // 标题
              const Text(
                "What's your\ngoal weight?",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  height: 1.1,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 12),

              // 自动计算的副标题
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _diffText,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFFB74D), // 暖橙色
                  ),
                ),
              ),

              const Spacer(),

              // 主内容区
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Canvas期待小熊
                    AnimatedBuilder(
                      animation: _bearController,
                      builder: (context, child) {
                        final tilt = math.sin(_bearController.value * math.pi * 2) * 0.03;
                        final bounce = math.sin(_bearController.value * math.pi * 4) * 3;
                        return Transform.translate(
                          offset: Offset(0, bounce),
                          child: Transform.rotate(
                            angle: tilt,
                            child: child,
                          ),
                        );
                      },
                      child: CustomPaint(
                        size: const Size(120, 120),
                        painter: _HopefulBearPainter(),
                      ),
                    ),

                    const SizedBox(width: 32),

                    // 弧形转盘 (暖色调)
                    GestureDetector(
                      onPanUpdate: (details) {
                        final delta = -details.delta.dy * 0.2;
                        _updateWeight(delta);
                      },
                      child: CustomPaint(
                        size: const Size(240, 240),
                        painter: _GoalDialPainter(
                          weight: _goalWeight,
                          minWeight: _minWeight,
                          maxWeight: _maxWeight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // +/- 按钮 + 体重显示
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _GoalWeightButton(
                    icon: Icons.remove,
                    onTap: () => _updateWeight(-_precision),
                  ),
                  const SizedBox(width: 24),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${_goalWeight.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 48,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'kg',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 24),
                  
                  _GoalWeightButton(
                    icon: Icons.add,
                    onTap: () => _updateWeight(_precision),
                  ),
                ],
              ),

              const Spacer(),

              // Next胶囊按钮
              GestureDetector(
                onTap: () {
                  UserMetrics.goalWeight = _goalWeight;
                  widget.onComplete();
                },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFFF8A65), Color(0xFFFFB74D)]), // 暖色渐变
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: const Color(0xFFFF8A65).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))],
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

/// 加减按钮
class _GoalWeightButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GoalWeightButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFFFB74D).withOpacity(0.5), width: 2),
        ),
        child: Icon(icon, color: const Color(0xFFFFB74D), size: 28),
      ),
    );
  }
}

/// Canvas: 暖色转盘
class _GoalDialPainter extends CustomPainter {
  final double weight;
  final double minWeight;
  final double maxWeight;

  _GoalDialPainter({required this.weight, required this.minWeight, required this.maxWeight});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // 外圈 (暖色调)
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFF5D4037)
        ..style = PaintingStyle.fill,
    );

    // 刻度环
    canvas.drawCircle(
      center,
      radius - 5,
      Paint()
        ..color = const Color(0xFF4A3728)
        ..style = PaintingStyle.fill,
    );

    // 绘制刻度
    final totalRange = maxWeight - minWeight;
    const angleRange = 270.0;
    const startAngle = 135.0;

    for (int i = 0; i <= (totalRange / 5).toInt(); i++) {
      final tickWeight = minWeight + i * 5;
      final progress = (tickWeight - minWeight) / totalRange;
      final angle = (startAngle + progress * angleRange) * math.pi / 180;

      final isMainTick = i % 2 == 0;
      final tickLength = isMainTick ? 15.0 : 8.0;
      final tickWidth = isMainTick ? 3.0 : 1.5;

      final outerRadius = radius - 15;
      final innerRadius = outerRadius - tickLength;

      final outerX = center.dx + outerRadius * math.cos(angle);
      final outerY = center.dy + outerRadius * math.sin(angle);
      final innerX = center.dx + innerRadius * math.cos(angle);
      final innerY = center.dy + innerRadius * math.sin(angle);

      canvas.drawLine(
        Offset(outerX, outerY),
        Offset(innerX, innerY),
        Paint()
          ..color = isMainTick ? const Color(0xFFFFB74D) : const Color(0xFFBCAAA4)
          ..strokeWidth = tickWidth
          ..strokeCap = StrokeCap.round,
      );

      if (isMainTick) {
        final textRadius = innerRadius - 15;
        final textX = center.dx + textRadius * math.cos(angle);
        final textY = center.dy + textRadius * math.sin(angle);

        final textPainter = TextPainter(
          text: TextSpan(
            text: '${tickWeight.toInt()}',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              color: Color(0xFFBCAAA4),
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        canvas.save();
        canvas.translate(textX - textPainter.width / 2, textY - textPainter.height / 2);
        canvas.rotate(angle + math.pi / 2);
        textPainter.paint(canvas, Offset.zero);
        canvas.restore();
      }
    }

    // 中心圆
    canvas.drawCircle(
      center,
      radius * 0.35,
      Paint()
        ..color = const Color(0xFF3E2723)
        ..style = PaintingStyle.fill,
    );

    // 指针 (暖橙色)
    final progress = (weight - minWeight) / totalRange;
    final pointerAngle = (startAngle + progress * angleRange) * math.pi / 180;
    final pointerRadius = radius - 30;

    canvas.drawLine(
      center,
      Offset(
        center.dx + pointerRadius * math.cos(pointerAngle),
        center.dy + pointerRadius * math.sin(pointerAngle),
      ),
      Paint()
        ..color = const Color(0xFFFFB74D)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawCircle(
      Offset(
        center.dx + pointerRadius * math.cos(pointerAngle),
        center.dy + pointerRadius * math.sin(pointerAngle),
      ),
      6,
      Paint()..color = const Color(0xFFFF8A65),
    );
  }

  @override
  bool shouldRepaint(covariant _GoalDialPainter oldDelegate) =>
      oldDelegate.weight != weight;
}

/// Canvas: 期待眼神小熊
class _HopefulBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 10;

    // 身体
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.8), width: r * 1.6, height: r * 1.2), Paint()..color = const Color(0xFFD4A574));

    // 头
    canvas.drawCircle(c, r, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.75, c.dy - r * 0.75), r * 0.28, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.75, c.dy - r * 0.75), r * 0.16, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.75, c.dy - r * 0.75), r * 0.28, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.75, c.dy - r * 0.75), r * 0.16, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.12), width: r * 1.1, height: r * 0.9), Paint()..color = const Color(0xFFE8C4A0));

    // 期待眼睛 - 星星眼
    _drawStarEye(canvas, Offset(c.dx - r * 0.3, c.dy - r * 0.1), r * 0.2);
    _drawStarEye(canvas, Offset(c.dx + r * 0.3, c.dy - r * 0.1), r * 0.2);

    // 期待嘴 (W型)
    final mouthPath = Path();
    mouthPath.moveTo(c.dx - r * 0.15, c.dy + r * 0.3);
    mouthPath.quadraticBezierTo(c.dx - r * 0.08, c.dy + r * 0.45, c.dx, c.dy + r * 0.35);
    mouthPath.quadraticBezierTo(c.dx + r * 0.08, c.dy + r * 0.45, c.dx + r * 0.15, c.dy + r * 0.3);
    canvas.drawPath(mouthPath, Paint()..color = const Color(0xFF8B4513)..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round);

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.45, c.dy + r * 0.1), width: r * 0.25, height: r * 0.12), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.45, c.dy + r * 0.1), width: r * 0.25, height: r * 0.12), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6));

    // 手 (双手捧脸期待)
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.9, c.dy + r * 0.3), width: r * 0.4, height: r * 0.25), Paint()..color = const Color(0xFFD4A574));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.9, c.dy + r * 0.3), width: r * 0.4, height: r * 0.25), Paint()..color = const Color(0xFFD4A574));
  }

  void _drawStarEye(Canvas canvas, Offset center, double size) {
    // 星星眼 - 期待效果
    canvas.drawCircle(center, size * 0.8, Paint()..color = Colors.white);
    // 星星形状瞳孔
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * math.pi / 5) - math.pi / 2;
      final r = i % 2 == 0 ? size : size * 0.4;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFFFD700));
    // 高光
    canvas.drawCircle(center + Offset(-size * 0.2, -size * 0.3), size * 0.2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


/// ============================================
/// P16: Activity Level Screen
/// ============================================
class ActivityScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const ActivityScreen({super.key, required this.onComplete});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String? _selectedActivity;

  final List<_ActivityOption> _activities = [
    _ActivityOption(
      id: 'sedentary',
      name: 'Sedentary',
      emoji: '🛋️',
      description: 'Little or no exercise',
      detail: 'Office work, mostly sitting',
    ),
    _ActivityOption(
      id: 'lightly',
      name: 'Lightly active',
      emoji: '🚶',
      description: '1-3 days/week',
      detail: 'Light exercise or sports 1-3 days a week',
    ),
    _ActivityOption(
      id: 'moderately',
      name: 'Moderately active',
      emoji: '🏃',
      description: '3-5 days/week',
      detail: 'Moderate exercise or sports 3-5 days a week',
    ),
    _ActivityOption(
      id: 'very',
      name: 'Very active',
      emoji: '💪',
      description: 'Daily exercise',
      detail: 'Hard exercise or sports 6-7 days a week',
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
              const SizedBox(height: 20),
              
              // 标题
              const Text(
                "What's your\nactivity level?",
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
                'This helps us calculate your calories',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 32),

              // 选项列表
              Expanded(
                child: ListView.separated(
                  itemCount: _activities.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final activity = _activities[index];
                    final isSelected = _selectedActivity == activity.id;
                    return _ActivityCard(
                      activity: activity,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedActivity = activity.id;
                        });
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Next胶囊按钮
              GestureDetector(
                onTap: _selectedActivity != null
                    ? () {
                        UserMetrics.activityLevel = _selectedActivity;
                        widget.onComplete();
                      }
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: _selectedActivity != null
                        ? const LinearGradient(
                            colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                          )
                        : null,
                    color: _selectedActivity == null ? Colors.grey.shade300 : null,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: _selectedActivity != null
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
                            color: _selectedActivity != null ? Colors.white : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: _selectedActivity != null ? Colors.white : Colors.grey.shade600,
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

/// 活跃程度选项
class _ActivityOption {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final String detail;
  _ActivityOption({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.detail,
  });
}

/// 活跃程度卡片
class _ActivityCard extends StatelessWidget {
  final _ActivityOption activity;
  final bool isSelected;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.activity,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CAF50).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF4CAF50).withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Emoji图标
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4CAF50).withOpacity(0.2)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  activity.emoji,
                  style: const TextStyle(fontSize: 28),
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
                    activity.name,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    activity.description,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: isSelected ? const Color(0xFF4CAF50).withOpacity(0.8) : Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    activity.detail,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.grey.shade500,
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
/// P17: Analyzing Loading Screen
/// ============================================
class AnalyzingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const AnalyzingScreen({super.key, required this.onComplete});

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();

    // 进度动画 (2秒)
    _progressController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    // 粒子动画
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // 2秒后自动切页
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E), // 深蓝紫背景
      body: SafeArea(
        child: Stack(
          children: [
            // 莫奈色系粒子背景
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _MonetParticlesPainter(
                    progress: _particleController.value,
                  ),
                );
              },
            ),

            // 主内容
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),

                  // Canvas小熊
                  AnimatedBuilder(
                    animation: _particleController,
                    builder: (context, child) {
                      final floatY = math.sin(_particleController.value * math.pi * 2) * 5;
                      return Transform.translate(
                        offset: Offset(0, floatY),
                        child: child,
                      );
                    },
                    child: CustomPaint(
                      size: const Size(150, 150),
                      painter: _AnalyzingBearPainter(),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 标题
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      // 文字闪烁效果
                      final opacity = 0.7 + _progressController.value * 0.3;
                      return Opacity(
                        opacity: opacity,
                        child: child,
                      );
                    },
                    child: const Text(
                      'Analyzing your profile...',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 进度条
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        return Column(
                          children: [
                            // 进度条背景
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FractionallySizedBox(
                                    widthFactor: _progressController.value,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF4ECDC4),
                                            Color(0xFFFF6B6B),
                                            Color(0xFFFFE66D),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // 百分比
                            Text(
                              '${(_progressController.value * 100).toInt()}%',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const Spacer(flex: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Canvas: 莫奈色系粒子
class _MonetParticlesPainter extends CustomPainter {
  final double progress;

  _MonetParticlesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // 莫奈色系
    final colors = [
      const Color(0xFF4ECDC4), // 青色
      const Color(0xFFFF6B6B), // 珊瑚红
      const Color(0xFFFFE66D), // 金黄
      const Color(0xFFA8E6CF), // 薄荷绿
      const Color(0xFFDDA0DD), // 梅红
      const Color(0xFF87CEEB), // 天蓝
    ];

    // 生成粒子
    final random = math.Random(42);
    for (int i = 0; i < 30; i++) {
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final particleSize = 5.0 + random.nextDouble() * 10;
      final color = colors[i % colors.length];

      // 浮动动画
      final floatX = math.sin((progress * 2 + i) * math.pi) * 20;
      final floatY = math.cos((progress * 2 + i * 0.5) * math.pi) * 30;

      // 透明度变化
      final opacity = 0.3 + 0.4 * math.sin((progress + i * 0.1) * math.pi * 2);

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      // 绘制圆形粒子
      canvas.drawCircle(
        Offset(baseX + floatX, baseY + floatY),
        particleSize,
        paint,
      );

      // 绘制数据流线条
      if (i % 3 == 0) {
        final linePaint = Paint()
          ..color = color.withOpacity(opacity * 0.5)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;

        final path = Path();
        final startX = baseX + floatX;
        final startY = baseY + floatY;
        path.moveTo(startX, startY);

        for (int j = 1; j <= 3; j++) {
          final px = startX + j * 15 + math.sin((progress * 3 + i + j) * math.pi) * 5;
          final py = startY - j * 10 + math.cos((progress * 2 + i + j) * math.pi) * 8;
          path.lineTo(px, py);
        }

        canvas.drawPath(path, linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MonetParticlesPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Canvas: 分析中的小熊
class _AnalyzingBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 15;

    // 身体
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.9), width: r * 1.6, height: r * 1.2),
      Paint()..color = const Color(0xFFD4A574),
    );

    // 头
    canvas.drawCircle(c, r, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.75, c.dy - r * 0.75), r * 0.28, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.75, c.dy - r * 0.75), r * 0.16, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.75, c.dy - r * 0.75), r * 0.28, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.75, c.dy - r * 0.75), r * 0.16, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.12), width: r * 1.1, height: r * 0.9),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 分析眼神 - 眯眼思考
    _drawThinkingEye(canvas, Offset(c.dx - r * 0.3, c.dy - r * 0.1), r * 0.12);
    _drawThinkingEye(canvas, Offset(c.dx + r * 0.3, c.dy - r * 0.1), r * 0.12);

    // 思考嘴 (抿嘴)
    canvas.drawLine(
      Offset(c.dx - r * 0.1, c.dy + r * 0.4),
      Offset(c.dx + r * 0.1, c.dy + r * 0.4),
      Paint()
        ..color = const Color(0xFF8B4513)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.45, c.dy + r * 0.1), width: r * 0.25, height: r * 0.12), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.45, c.dy + r * 0.1), width: r * 0.25, height: r * 0.12), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));

    // 思考手势 (托腮)
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.85, c.dy + r * 0.3), width: r * 0.35, height: r * 0.4), Paint()..color = const Color(0xFFD4A574));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.85, c.dy + r * 0.3), width: r * 0.35, height: r * 0.4), Paint()..color = const Color(0xFFD4A574));
  }

  void _drawThinkingEye(Canvas canvas, Offset center, double radius) {
    // 眯眼
    final path = Path();
    path.moveTo(center.dx - radius, center.dy);
    path.quadraticBezierTo(center.dx, center.dy - radius * 0.5, center.dx + radius, center.dy);
    canvas.drawPath(path, Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


/// ============================================
/// P18: Plan Ready Screen
/// ============================================
class PlanReadyScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const PlanReadyScreen({super.key, required this.onComplete});

  @override
  State<PlanReadyScreen> createState() => _PlanReadyScreenState();
}

class _PlanReadyScreenState extends State<PlanReadyScreen>
    with TickerProviderStateMixin {
  late AnimationController _confettiController;
  late AnimationController _bearController;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _bearController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _bearController.dispose();
    super.dispose();
  }

  // 计算预计达成日期 (3个月后)
  String get _targetDate {
    final now = DateTime.now();
    final target = now.add(const Duration(days: 90));
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return '${months[target.month - 1]} ${target.day}, ${target.year}';
  }

  // 根据用户数据计算每日卡路里
  int get _dailyCalories {
    final weight = UserMetrics.weight ?? 65.0;
    final height = UserMetrics.height ?? 170.0;
    final age = UserMetrics.age ?? 25;
    final isMale = UserMetrics.gender == 'male';
    
    // BMR计算 ( Mifflin-St Jeor Equation )
    double bmr;
    if (isMale) {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }
    
    // 活动系数
    final activityMultipliers = {
      'sedentary': 1.2,
      'lightly': 1.375,
      'moderately': 1.55,
      'very': 1.725,
    };
    final activity = UserMetrics.activityLevel ?? 'moderately';
    final tdee = bmr * (activityMultipliers[activity] ?? 1.55);
    
    // 目标：减重 = TDEE - 500
    return (tdee - 500).round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      body: SafeArea(
        child: Stack(
          children: [
            // 撒花背景
            AnimatedBuilder(
              animation: _confettiController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _ConfettiPainter(progress: _confettiController.value),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // 标题
                  const Text(
                    'Your personalized\nplan is ready!',
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

                  // Canvas撒花小熊
                  AnimatedBuilder(
                    animation: _bearController,
                    builder: (context, child) {
                      final bounce = math.sin(_bearController.value * math.pi * 2) * 8;
                      return Transform.translate(
                        offset: Offset(0, bounce),
                        child: child,
                      );
                    },
                    child: CustomPaint(
                      size: const Size(150, 150),
                      painter: _CelebratingBearPainter(),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 计划卡片
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // 预计达成日期
                        _PlanItem(
                          icon: '📅',
                          label: 'Target date',
                          value: _targetDate,
                          color: const Color(0xFF4ECDC4),
                        ),
                        
                        const Divider(height: 32),

                        // 每日卡路里
                        _PlanItem(
                          icon: '🔥',
                          label: 'Daily calories',
                          value: '${_dailyCalories.toString()} kcal',
                          color: const Color(0xFFFF6B6B),
                        ),
                        
                        const Divider(height: 32),

                        // 每日饮水
                        _PlanItem(
                          icon: '💧',
                          label: 'Daily water',
                          value: '2.5 L',
                          color: const Color(0xFF64B5F6),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Continue胶囊按钮
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
                              'Continue',
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

/// 计划项组件
class _PlanItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;

  const _PlanItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 图标
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(icon, style: const TextStyle(fontSize: 24)),
          ),
        ),

        const SizedBox(width: 16),

        // 标签和值
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Canvas: 撒花粒子
class _ConfettiPainter extends CustomPainter {
  final double progress;

  _ConfettiPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECDC4),
      const Color(0xFFFFE66D),
      const Color(0xFFA8E6CF),
      const Color(0xFFFF8A65),
      const Color(0xFF64B5F6),
    ];

    final random = math.Random(42);
    for (int i = 0; i < 40; i++) {
      final baseX = random.nextDouble() * size.width;
      final baseY = (progress + i * 0.02) % 1.0 * size.height;
      final particleSize = 4.0 + random.nextDouble() * 6;
      final color = colors[i % colors.length];

      final paint = Paint()
        ..color = color.withOpacity(0.6)
        ..style = PaintingStyle.fill;

      // 撒花形状
      if (i % 3 == 0) {
        // 圆形
        canvas.drawCircle(Offset(baseX, baseY), particleSize, paint);
      } else if (i % 3 == 1) {
        // 方形
        canvas.drawRect(Rect.fromCenter(center: Offset(baseX, baseY), width: particleSize * 1.5, height: particleSize * 1.5), paint);
      } else {
        // 三角形
        final path = Path();
        path.moveTo(baseX, baseY - particleSize);
        path.lineTo(baseX - particleSize, baseY + particleSize);
        path.lineTo(baseX + particleSize, baseY + particleSize);
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Canvas: 撒花比心小熊
class _CelebratingBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 15;

    // 身体
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.9), width: r * 1.6, height: r * 1.2),
      Paint()..color = const Color(0xFFD4A574),
    );

    // 头
    canvas.drawCircle(c, r, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.75, c.dy - r * 0.75), r * 0.28, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.75, c.dy - r * 0.75), r * 0.16, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.75, c.dy - r * 0.75), r * 0.28, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.75, c.dy - r * 0.75), r * 0.16, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.12), width: r * 1.1, height: r * 0.9),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 开心眼睛 (弯弯的笑眼)
    _drawHappyEye(canvas, Offset(c.dx - r * 0.3, c.dy - r * 0.1), r * 0.15);
    _drawHappyEye(canvas, Offset(c.dx + r * 0.3, c.dy - r * 0.1), r * 0.15);

    // 开心嘴
    final smilePath = Path();
    smilePath.moveTo(c.dx - r * 0.2, c.dy + r * 0.35);
    smilePath.quadraticBezierTo(c.dx, c.dy + r * 0.55, c.dx + r * 0.2, c.dy + r * 0.35);
    canvas.drawPath(smilePath, Paint()..color = const Color(0xFF8B4513)..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round);

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.45, c.dy + r * 0.1), width: r * 0.3, height: r * 0.15), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.7));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.45, c.dy + r * 0.1), width: r * 0.3, height: r * 0.15), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.7));

    // 举起的双手 (撒花姿势)
    _drawCelebratingArm(canvas, Offset(c.dx - r * 1.1, c.dy), r * 0.5, -0.8);
    _drawCelebratingArm(canvas, Offset(c.dx + r * 1.1, c.dy), r * 0.5, 0.8);
  }

  void _drawHappyEye(Canvas canvas, Offset center, double size) {
    // 弯弯的笑眼
    final path = Path();
    path.moveTo(center.dx - size, center.dy);
    path.quadraticBezierTo(center.dx, center.dy - size, center.dx + size, center.dy);
    canvas.drawPath(path, Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round);
  }

  void _drawCelebratingArm(Canvas canvas, Offset center, double size, double angle) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    
    // 手臂
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, -size * 0.5), width: size * 0.4, height: size * 0.6),
      Paint()..color = const Color(0xFFD4A574),
    );
    
    // 小手
    canvas.drawCircle(Offset(0, -size * 0.9), size * 0.2, Paint()..color = const Color(0xFFD4A574));
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


/// ============================================
/// P19: User Reviews Screen
/// ============================================
class ReviewsScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const ReviewsScreen({super.key, required this.onComplete});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _autoScrollController;
  late PageController _pageController;
  
  final List<_Review> _reviews = [
    _Review(
      name: 'Sarah M.',
      avatar: '👩',
      rating: 5,
      text: 'This app changed my life! The personalized plan fits perfectly into my busy schedule. Highly recommend!',
    ),
    _Review(
      name: 'James K.',
      avatar: '👨',
      rating: 5,
      text: 'Lost 10 pounds in 6 weeks! The calorie tracking is so easy and the fasting timer works flawlessly.',
    ),
    _Review(
      name: 'Emma L.',
      avatar: '👩‍🦰',
      rating: 5,
      text: 'Love the cute bear mascot! It makes tracking my water intake actually fun. Best health app ever!',
    ),
    _Review(
      name: 'Michael T.',
      avatar: '👨‍🦱',
      rating: 5,
      text: 'The radar chart shows all my progress at a glance. Great motivation to keep going every day!',
    ),
    _Review(
      name: 'Lisa W.',
      avatar: '👩‍🦱',
      rating: 5,
      text: 'Finally an app that understands my goals. The fasting feature is exactly what I needed.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    
    _autoScrollController = AnimationController(
      duration: Duration(seconds: 3 + _reviews.length * 2),
      vsync: this,
    )..repeat();
    
    _autoScrollController.addListener(() {
      if (_pageController.hasClients) {
        final page = _autoScrollController.value * (_reviews.length - 1);
        _pageController.animateToPage(
          page.round() % _reviews.length,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollController.dispose();
    _pageController.dispose();
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

              // 标题
              const Text(
                'What our\nusers say',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  height: 1.1,
                  color: Color(0xFF2D3748),
                ),
              ),

              const SizedBox(height: 32),

              // 评价卡片流
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _reviews.length,
                  itemBuilder: (context, index) {
                    return _ReviewCard(review: _reviews[index]);
                  },
                ),
              ),

              const SizedBox(height: 24),

              // 页码指示器
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _reviews.length,
                  (index) => AnimatedBuilder(
                    animation: _autoScrollController,
                    builder: (context, child) {
                      final currentPage = (_autoScrollController.value * (_reviews.length - 1)).round() % _reviews.length;
                      final isActive = index == currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFF4CAF50) : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Continue胶囊按钮
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
                          'Continue',
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
      ),
    );
  }
}

/// 评价数据
class _Review {
  final String name;
  final String avatar;
  final int rating;
  final String text;
  _Review({
    required this.name,
    required this.avatar,
    required this.rating,
    required this.text,
  });
}

/// 评价卡片
class _ReviewCard extends StatelessWidget {
  final _Review review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头像和用户名
          Row(
            children: [
              // 头像
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    review.avatar,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // 用户名和评分
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // 五星
                    Row(
                      children: List.generate(
                        5,
                        (index) => Text(
                          '⭐',
                          style: TextStyle(
                            fontSize: 14,
                            color: index < review.rating
                                ? const Color(0xFFFFD700)
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 评价文案
          Expanded(
            child: Text(
              '"${review.text}"',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                color: Colors.grey.shade700,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/// ============================================
/// P20: Notification Permission Screen
/// ============================================
class NotificationScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const NotificationScreen({super.key, required this.onComplete});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bearController;

  @override
  void initState() {
    super.initState();
    _bearController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bearController.dispose();
    super.dispose();
  }

  void _requestPermission() async {
    // 模拟触发通知权限请求
    // 在真实环境中，这里会调用 flutter_local_notifications 或 permission_handler
    // 无论结果如何，2秒后自动切页
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // 标题
              const Text(
                'Stay on\ntrack!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  height: 1.1,
                  color: Color(0xFF2D3748),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Enable notifications to get\nreminders and stay motivated',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),

              const Spacer(),

              // Canvas小熊拿闹钟
              AnimatedBuilder(
                animation: _bearController,
                builder: (context, child) {
                  // 轻微摇晃动画
                  final shake = math.sin(_bearController.value * math.pi * 4) * 3;
                  return Transform.translate(
                    offset: Offset(shake, 0),
                    child: child,
                  );
                },
                child: CustomPaint(
                  size: const Size(200, 200),
                  painter: _AlarmBearPainter(),
                ),
              ),

              const Spacer(),

              // Enable Notifications 按钮
              GestureDetector(
                onTap: _requestPermission,
                child: Container(
                  width: double.infinity,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                    ),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4CAF50).withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_active,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Enable Notifications',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Skip 文字按钮
              GestureDetector(
                onTap: widget.onComplete,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Skip for now',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.grey.shade500,
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

/// Canvas: 拿闹钟呆萌小熊
class _AlarmBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 20;

    // 身体
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 1.0), width: r * 1.8, height: r * 1.4),
      Paint()..color = const Color(0xFFD4A574),
    );

    // 头
    canvas.drawCircle(Offset(c.dx, c.dy - r * 0.3), r * 0.85, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.65, c.dy - r * 1.0), r * 0.28, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.65, c.dy - r * 1.0), r * 0.16, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.65, c.dy - r * 1.0), r * 0.28, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.65, c.dy - r * 1.0), r * 0.16, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy - r * 0.15), width: r * 1.1, height: r * 0.9),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 呆萌眼睛 - 圆睁
    _drawCuteEye(canvas, Offset(c.dx - r * 0.28, c.dy - r * 0.35), r * 0.18);
    _drawCuteEye(canvas, Offset(c.dx + r * 0.28, c.dy - r * 0.35), r * 0.18);

    // 呆萌嘴 (小O)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.15), width: r * 0.18, height: r * 0.12),
      Paint()..color = const Color(0xFF8B4513),
    );

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.4, c.dy - r * 0.05), width: r * 0.25, height: r * 0.12), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.4, c.dy - r * 0.05), width: r * 0.25, height: r * 0.12), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6));

    // 左手 (扶着闹钟)
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 1.1, c.dy + r * 0.2), width: r * 0.4, height: r * 0.25), Paint()..color = const Color(0xFFD4A574));

    // 右手 (扶着闹钟)
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 1.1, c.dy + r * 0.2), width: r * 0.4, height: r * 0.25), Paint()..color = const Color(0xFFD4A574));

    // 小闹钟
    _drawAlarmClock(canvas, Offset(c.dx + r * 1.3, c.dy + r * 0.1), r * 0.4);
  }

  void _drawCuteEye(Canvas canvas, Offset center, double radius) {
    // 眼白
    canvas.drawCircle(center, radius, Paint()..color = Colors.white);
    // 眼眶
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    // 大瞳孔
    canvas.drawCircle(center, radius * 0.7, Paint()..color = Colors.black);
    // 高光
    canvas.drawCircle(center + Offset(-radius * 0.3, -radius * 0.3), radius * 0.25, Paint()..color = Colors.white);
  }

  void _drawAlarmClock(Canvas canvas, Offset center, double size) {
    // 闹钟主体
    canvas.drawCircle(center, size, Paint()..color = const Color(0xFF64B5F6));
    canvas.drawCircle(center, size, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 3);

    // 数字12
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '🔔',
        style: TextStyle(fontSize: 16),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));

    // 铃铛
    canvas.drawCircle(center + Offset(0, -size - 5), size * 0.3, Paint()..color = const Color(0xFFFFD700));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


/// ============================================
/// P21: Creating Plan Loading Screen
/// ============================================
class CreatingPlanScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const CreatingPlanScreen({super.key, required this.onComplete});

  @override
  State<CreatingPlanScreen> createState() => _CreatingPlanScreenState();
}

class _CreatingPlanScreenState extends State<CreatingPlanScreen>
    with TickerProviderStateMixin {
  late AnimationController _spiralController;
  late AnimationController _checkController;
  
  final List<_CheckItem> _checkItems = [
    _CheckItem(text: 'Analyzing BMI...', completed: false),
    _CheckItem(text: 'Optimizing calorie intake...', completed: false),
    _CheckItem(text: 'Creating meal plan...', completed: false),
  ];

  @override
  void initState() {
    super.initState();
    
    _spiralController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _checkController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();

    // 逐条显示检查项
    _animateChecks();
    
    // 3秒后自动切页
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  void _animateChecks() async {
    for (int i = 0; i < _checkItems.length; i++) {
      await Future.delayed(Duration(milliseconds: 600 + i * 800));
      if (mounted) {
        setState(() {
          _checkItems[i] = _CheckItem(text: _checkItems[i].text.replaceAll('...', ''), completed: true);
        });
      }
    }
  }

  @override
  void dispose() {
    _spiralController.dispose();
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748), // 深色背景
      body: SafeArea(
        child: Stack(
          children: [
            // 螺旋粒子背景
            AnimatedBuilder(
              animation: _spiralController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _SpiralParticlesPainter(progress: _spiralController.value),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  // 标题
                  AnimatedBuilder(
                    animation: _checkController,
                    builder: (context, child) {
                      final opacity = 0.7 + _checkController.value * 0.3;
                      return Opacity(
                        opacity: opacity,
                        child: child,
                      );
                    },
                    child: const Text(
                      'Your plan is being\ncreated...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 28,
                        height: 1.2,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Canvas思考小熊
                  AnimatedBuilder(
                    animation: _spiralController,
                    builder: (context, child) {
                      final floatY = math.sin(_spiralController.value * math.pi * 2) * 5;
                      final glow = 0.5 + _spiralController.value * 0.5;
                      return Transform.translate(
                        offset: Offset(0, floatY),
                        child: Opacity(
                          opacity: glow,
                          child: child,
                        ),
                      );
                    },
                    child: CustomPaint(
                      size: const Size(160, 160),
                      painter: _ThinkingBearPainter(),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // 检查项列表
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: _checkItems.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return _CheckItemWidget(
                          text: item.text,
                          completed: item.completed,
                          delay: index * 0.2,
                        );
                      }).toList(),
                    ),
                  ),

                  const Spacer(flex: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 检查项数据
class _CheckItem {
  final String text;
  final bool completed;
  _CheckItem({required this.text, required this.completed});
}

/// 检查项组件
class _CheckItemWidget extends StatefulWidget {
  final String text;
  final bool completed;
  final double delay;

  const _CheckItemWidget({
    required this.text,
    required this.completed,
    required this.delay,
  });

  @override
  State<_CheckItemWidget> createState() => _CheckItemWidgetState();
}

class _CheckItemWidgetState extends State<_CheckItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _checkAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt() + 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // 勾选框
            AnimatedBuilder(
              animation: _checkAnimation,
              builder: (context, child) {
                return Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.completed
                        ? const Color(0xFF4CAF50)
                        : Colors.white.withOpacity(0.2),
                    border: Border.all(
                      color: widget.completed
                          ? const Color(0xFF4CAF50)
                          : Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: widget.completed
                      ? Transform.scale(
                          scale: _checkAnimation.value,
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18,
                          ),
                        )
                      : null,
                );
              },
            ),

            const SizedBox(width: 16),

            // 文字
            Text(
              widget.text,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: widget.completed
                    ? Colors.white
                    : Colors.white.withOpacity(0.7),
                fontWeight:
                    widget.completed ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Canvas: 螺旋粒子
class _SpiralParticlesPainter extends CustomPainter {
  final double progress;

  _SpiralParticlesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      const Color(0xFF4ECDC4),
      const Color(0xFFFF6B6B),
      const Color(0xFFFFE66D),
      const Color(0xFFA8E6CF),
      const Color(0xFFDDA0DD),
    ];

    final center = Offset(size.width / 2, size.height / 2);
    final random = math.Random(42);

    // 绘制螺旋粒子
    for (int i = 0; i < 25; i++) {
      final baseAngle = i * 0.3;
      final spiralAngle = baseAngle + progress * math.pi * 4;
      final radius = 50 + i * 12 + math.sin(progress * math.pi * 2 + i) * 20;

      final x = center.dx + radius * math.cos(spiralAngle);
      final y = center.dy + radius * math.sin(spiralAngle);

      final particleSize = 4.0 + random.nextDouble() * 8;
      final color = colors[i % colors.length];
      final opacity = 0.3 + 0.4 * math.sin(progress * math.pi * 2 + i * 0.5);

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), particleSize, paint);

      // 绘制连接线
      if (i > 0) {
        final prevAngle = baseAngle - 0.3 + progress * math.pi * 4;
        final prevRadius = 50 + (i - 1) * 12 + math.sin(progress * math.pi * 2 + i - 1) * 20;
        final prevX = center.dx + prevRadius * math.cos(prevAngle);
        final prevY = center.dy + prevRadius * math.sin(prevAngle);

        canvas.drawLine(
          Offset(prevX, prevY),
          Offset(x, y),
          Paint()
            ..color = color.withOpacity(opacity * 0.3)
            ..strokeWidth = 1.5,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SpiralParticlesPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Canvas: 思考计算小熊
class _ThinkingBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 15;

    // 身体
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.9), width: r * 1.6, height: r * 1.2),
      Paint()..color = const Color(0xFFD4A574),
    );

    // 头
    canvas.drawCircle(c, r, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.75, c.dy - r * 0.75), r * 0.28, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.75, c.dy - r * 0.75), r * 0.16, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.75, c.dy - r * 0.75), r * 0.28, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.75, c.dy - r * 0.75), r * 0.16, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.12), width: r * 1.1, height: r * 0.9),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 思考眼睛 - 一边眯
    _drawThinkingEye(canvas, Offset(c.dx - r * 0.3, c.dy - r * 0.1), r * 0.15, isLeft: true);
    _drawThinkingEye(canvas, Offset(c.dx + r * 0.3, c.dy - r * 0.1), r * 0.15, isLeft: false);

    // 思考嘴
    final mouthPath = Path();
    mouthPath.moveTo(c.dx - r * 0.1, c.dy + r * 0.4);
    mouthPath.quadraticBezierTo(c.dx, c.dy + r * 0.35, c.dx + r * 0.1, c.dy + r * 0.4);
    canvas.drawPath(mouthPath, Paint()..color = const Color(0xFF8B4513)..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round);

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.45, c.dy + r * 0.1), width: r * 0.25, height: r * 0.12), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.45, c.dy + r * 0.1), width: r * 0.25, height: r * 0.12), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));

    // 思考手势 (托腮)
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.85, c.dy + r * 0.25), width: r * 0.35, height: r * 0.4), Paint()..color = const Color(0xFFD4A574));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.85, c.dy + r * 0.25), width: r * 0.35, height: r * 0.4), Paint()..color = const Color(0xFFD4A574));

    // 头顶问号
    _drawQuestionMark(canvas, Offset(c.dx + r * 0.5, c.dy - r * 1.3), r * 0.2);
  }

  void _drawThinkingEye(Canvas canvas, Offset center, double size, {required bool isLeft}) {
    if (isLeft) {
      // 左眼眯着
      final path = Path();
      path.moveTo(center.dx - size, center.dy);
      path.quadraticBezierTo(center.dx, center.dy - size * 0.5, center.dx + size, center.dy);
      canvas.drawPath(path, Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    } else {
      // 右眼圆睁
      canvas.drawCircle(center, size, Paint()..color = Colors.white);
      canvas.drawCircle(center, size, Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
      canvas.drawCircle(center, size * 0.6, Paint()..color = Colors.black);
      canvas.drawCircle(center + Offset(-size * 0.25, -size * 0.25), size * 0.2, Paint()..color = Colors.white);
    }
  }

  void _drawQuestionMark(Canvas canvas, Offset center, double size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '?',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: size * 2,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFFFE66D),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


/// ============================================
/// P22: Weight Prediction Screen
/// ============================================
class WeightPredictionScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const WeightPredictionScreen({super.key, required this.onComplete});

  @override
  State<WeightPredictionScreen> createState() => _WeightPredictionScreenState();
}

class _WeightPredictionScreenState extends State<WeightPredictionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _chartController;
  late AnimationController _bearController;

  // 从UserMetrics获取体重数据
  double get _startWeight => UserMetrics.weight ?? 70.0;
  double get _goalWeight => UserMetrics.goalWeight ?? 65.0;
  double get _weightLoss => _startWeight - _goalWeight;

  // 生成12周预测数据
  List<double> get _predictionData {
    final data = <double>[];
    for (int i = 0; i <= 12; i++) {
      final progress = i / 12;
      // 使用缓动曲线模拟真实减肥过程
      final eased = 1 - math.pow(1 - progress, 2);
      final weight = _startWeight - (_weightLoss * eased);
      data.add(double.parse(weight.toStringAsFixed(1)));
    }
    return data;
  }

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

              // 标题
              const Text(
                'Believe in\nyourself!',
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
                'Your projected weight journey',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 24),

              // 统计卡片
              Row(
                children: [
                  _StatCard(
                    label: 'Start',
                    value: '${_startWeight.toStringAsFixed(1)} kg',
                    color: const Color(0xFF64B5F6),
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: 'Goal',
                    value: '${_goalWeight.toStringAsFixed(1)} kg',
                    color: const Color(0xFF4CAF50),
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: 'To lose',
                    value: '${_weightLoss.toStringAsFixed(1)} kg',
                    color: const Color(0xFFFF6B6B),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 体重预测图表
              Expanded(
                child: AnimatedBuilder(
                  animation: _chartController,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        // 图表
                        CustomPaint(
                          size: Size.infinite,
                          painter: _WeightChartPainter(
                            data: _predictionData,
                            progress: _chartController.value,
                            startWeight: _startWeight,
                            goalWeight: _goalWeight,
                          ),
                        ),
                        // 终点比心小熊
                        Positioned(
                          right: 40,
                          bottom: 60 + (_goalWeight - _startWeight).abs() * 2,
                          child: AnimatedBuilder(
                            animation: _bearController,
                            builder: (context, child) {
                              final bounce = math.sin(_bearController.value * math.pi * 2) * 5;
                              return Transform.translate(
                                offset: Offset(0, bounce),
                                child: child,
                              );
                            },
                            child: CustomPaint(
                              size: const Size(60, 60),
                              painter: _HeartBearPainter(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // 时间轴
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Week 1', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey.shade500)),
                  Text('Week 6', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey.shade500)),
                  Text('Week 12', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),

              const SizedBox(height: 24),

              // Continue胶囊按钮
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
                          'Continue',
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
      ),
    );
  }
}

/// 统计卡片
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Canvas: 体重预测曲线图
class _WeightChartPainter extends CustomPainter {
  final List<double> data;
  final double progress;
  final double startWeight;
  final double goalWeight;

  _WeightChartPainter({
    required this.data,
    required this.progress,
    required this.startWeight,
    required this.goalWeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final padding = 50.0;
    final chartWidth = size.width - padding * 2;
    final chartHeight = size.height - padding * 2;

    // 找到数据范围
    final maxWeight = data.reduce((a, b) => a > b ? a : b);
    final minWeight = data.reduce((a, b) => a < b ? a : b);
    final weightRange = maxWeight - minWeight;

    // 坐标转换
    List<Offset> points = [];
    for (int i = 0; i < data.length; i++) {
      final x = padding + (i / (data.length - 1)) * chartWidth;
      final y = padding + chartHeight - ((data[i] - minWeight) / weightRange) * chartHeight;
      points.add(Offset(x, y));
    }

    // 裁剪动画进度
    if (progress < 1.0) {
      final visiblePoints = 2 + (points.length - 2) * progress;
      points = points.sublist(0, visiblePoints.ceil().clamp(2, points.length));
    }

    if (points.length < 2) return;

    // 绘制渐变填充
    final fillPath = Path();
    fillPath.moveTo(points.first.dx, size.height - padding);
    fillPath.lineTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      fillPath.lineTo(points[i + 1].dx, points[i + 1].dy);
    }

    fillPath.lineTo(points.last.dx, size.height - padding);
    fillPath.close();

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF4CAF50).withOpacity(0.4),
          const Color(0xFF4CAF50).withOpacity(0.1),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, gradientPaint);

    // 绘制曲线
    final curvePath = Path();
    curvePath.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      curvePath.lineTo(points[i + 1].dx, points[i + 1].dy);
    }

    canvas.drawPath(
      curvePath,
      Paint()
        ..color = const Color(0xFF4CAF50)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // 数据点
    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      final isStart = i == 0;
      final isEnd = i == points.length - 1;

      // 外圈
      canvas.drawCircle(
        point,
        isEnd ? 10 : 6,
        Paint()..color = Colors.white,
      );
      // 内圈
      canvas.drawCircle(
        point,
        isEnd ? 7 : 4,
        Paint()..color = isStart ? const Color(0xFF64B5F6) : (isEnd ? const Color(0xFF4CAF50) : const Color(0xFF4CAF50).withOpacity(0.5)),
      );
    }

    // 绘制坐标轴
    final axisPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(padding, padding),
      Offset(padding, size.height - padding),
      axisPaint,
    );
    canvas.drawLine(
      Offset(padding, size.height - padding),
      Offset(size.width - padding, size.height - padding),
      axisPaint,
    );

    // Y轴标签
    for (int i = 0; i <= 4; i++) {
      final y = padding + (chartHeight / 4) * i;
      final weight = maxWeight - (weightRange / 4) * i;

      final textPainter = TextPainter(
        text: TextSpan(
          text: '${weight.toInt()}',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            color: Colors.grey.shade500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(5, y - textPainter.height / 2));

      // 网格线
      canvas.drawLine(
        Offset(padding, y),
        Offset(size.width - padding, y),
        Paint()..color = Colors.grey.withOpacity(0.1),
      );
    }

    // X轴标签
    final weeks = ['W1', 'W4', 'W8', 'W12'];
    final indices = [0, 3, 7, 11];
    for (int i = 0; i < weeks.length; i++) {
      if (indices[i] < points.length) {
        final x = points[indices[i]].dx;
        final textPainter = TextPainter(
          text: TextSpan(
            text: weeks[i],
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              color: Colors.grey.shade500,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, size.height - padding + 8),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WeightChartPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.data != data;
}

/// Canvas: 比心小熊
class _HeartBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    // 头
    canvas.drawCircle(c, r * 0.8, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.6, c.dy - r * 0.6), r * 0.22, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.6, c.dy - r * 0.6), r * 0.12, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.6, c.dy - r * 0.6), r * 0.22, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.6, c.dy - r * 0.6), r * 0.12, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.1), width: r * 0.9, height: r * 0.7), Paint()..color = const Color(0xFFE8C4A0));

    // 爱心眼
    _drawHeartEye(canvas, Offset(c.dx - r * 0.25, c.dy - r * 0.1), r * 0.18);
    _drawHeartEye(canvas, Offset(c.dx + r * 0.25, c.dy - r * 0.1), r * 0.18);

    // 微笑嘴
    final smilePath = Path();
    smilePath.moveTo(c.dx - r * 0.15, c.dy + r * 0.3);
    smilePath.quadraticBezierTo(c.dx, c.dy + r * 0.45, c.dx + r * 0.15, c.dy + r * 0.3);
    canvas.drawPath(smilePath, Paint()..color = const Color(0xFF8B4513)..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round);

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.35, c.dy + r * 0.1), width: r * 0.2, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.35, c.dy + r * 0.1), width: r * 0.2, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6));

    // 比心手势
    _drawHeartHand(canvas, Offset(c.dx - r * 0.7, c.dy + r * 0.2), r * 0.3, -0.3);
    _drawHeartHand(canvas, Offset(c.dx + r * 0.7, c.dy + r * 0.2), r * 0.3, 0.3);
  }

  void _drawHeartEye(Canvas canvas, Offset center, double size) {
    final paint = Paint()..color = const Color(0xFFFF6B6B);
    final path = Path();
    path.moveTo(center.dx, center.dy + size * 0.3);
    path.cubicTo(center.dx - size * 1.2, center.dy - size * 0.3, center.dx - size * 1.2, center.dy - size * 1.2, center.dx, center.dy - size * 0.3);
    path.cubicTo(center.dx + size * 1.2, center.dy - size * 1.2, center.dx + size * 1.2, center.dy - size * 0.3, center.dx, center.dy + size * 0.3);
    canvas.drawPath(path, paint);
  }

  void _drawHeartHand(Canvas canvas, Offset center, double size, double angle) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    final paint = Paint()..color = const Color(0xFFFF6B6B);
    final path = Path();
    path.moveTo(0, size * 0.5);
    path.cubicTo(-size * 0.8, size * 0.2, -size * 0.8, -size * 0.8, 0, -size * 0.2);
    path.cubicTo(size * 0.8, -size * 0.8, size * 0.8, size * 0.2, 0, size * 0.5);
    canvas.drawPath(path, paint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(0, size * 0.5), width: size * 0.4, height: size * 0.6), const Radius.circular(6)), Paint()..color = const Color(0xFFD4A574));

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

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
