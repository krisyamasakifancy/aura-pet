import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'user_metrics_model.dart';

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
    return ChangeNotifierProvider(
      create: (_) => UserMetricsModel(),
      child: MaterialApp(
        title: 'Aura-Pet Onboarding',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
          useMaterial3: true,
        ),
        home: const OnboardingNavigator(),
      ),
    );
  }
}

/// ============================================
/// 46屏导航器 (MainContainer)
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

  @override
  void initState() {
    super.initState();
    // P0 Splash 特殊逻辑：2秒后自动翻页
    Timer(const Duration(seconds: 2), () {
      if (mounted && _currentPage == 0) {
        _nextPage();
      }
    });
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic, // 弹簧感平滑曲线
      );
    }
  }

  void _goToPage(int pageIndex) {
    if (pageIndex >= 0 && pageIndex < _totalPages) {
      _pageController.animateToPage(
        pageIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 禁止手势滑动 - 强力锁定
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
                case 22:
                  return HabitAnalysisScreen(onComplete: _nextPage);
                case 23:
                  return PremiumPaywallScreen(onComplete: _nextPage);
                case 24:
                  return PricingScreen(onComplete: _nextPage);
                case 25:
                  return PaymentCommitmentScreen(onComplete: _nextPage);
                case 26:
                  return WelcomeScreen(onComplete: _nextPage);
                case 27:
                  return HomeScreen(onComplete: _nextPage);
                case 28:
                  return NutrientsScreen(onComplete: _nextPage);
                case 29:
                  return MoodScreen(onComplete: _nextPage);
                case 30:
                  return FoodSearchScreen(onComplete: _nextPage);
                case 31:
                  return FoodListScreen(onComplete: _nextPage);
                case 32:
                  return CalorieCalculatorScreen(onComplete: _nextPage);
                case 33:
                  return FastingPlanScreen(onComplete: _nextPage);
                case 34:
                  return FastingTimerScreen(onComplete: _nextPage);
                case 35:
                  return WaterTrackerScreen(onComplete: _nextPage);
                case 36:
                  return WaterHistoryScreen(onComplete: _nextPage);
                case 37:
                  return AchievementsScreen(onComplete: _nextPage);
                case 38:
                  return ProfileScreen(onComplete: _nextPage);
                case 39:
                  return SettingsScreen(onComplete: _nextPage);
                case 40:
                  return GoalReachedScreen(onComplete: _nextPage);
                case 41:
                  return DressingRoomScreen(onComplete: _nextPage);
                case 42:
                  return ProgressReportScreen(onComplete: _nextPage);
                case 43:
                  return BadgeDetailScreen(onComplete: _nextPage);
                case 44:
                  return NotificationSettingsScreen(onComplete: _nextPage);
                case 45:
                  return AboutScreen(onComplete: _nextPage);
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

          // ============================================
          // 全局胶囊按钮（P0 Splash不显示，P45最后一页不显示）
          // ============================================
          if (_currentPage > 0 && _currentPage < _totalPages - 1)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 32,
              left: 40,
              right: 40,
              child: GestureDetector(
                onTap: _nextPage,
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
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                      ],
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


/// ============================================
/// P23: Habit Analysis Screen
/// ============================================
class HabitAnalysisScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const HabitAnalysisScreen({super.key, required this.onComplete});

  @override
  State<HabitAnalysisScreen> createState() => _HabitAnalysisScreenState();
}

class _HabitAnalysisScreenState extends State<HabitAnalysisScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _chartController;

  // 用户数据 (基于UserMetrics模拟)
  double get _userSteps => 5000.0;
  double get _userSleep => 6.5;
  double get _userWater => 1.8;

  // 同龄人平均数据
  double get _avgSteps => 7000.0;
  double get _avgSleep => 7.5;
  double get _avgWater => 2.2;

  final List<_HabitData> _habits = [];

  @override
  void initState() {
    super.initState();
    _habits.addAll([
      _HabitData(label: 'Daily Steps', icon: '👟', userValue: _userSteps, avgValue: _avgSteps, unit: '', maxValue: 10000),
      _HabitData(label: 'Sleep Duration', icon: '😴', userValue: _userSleep, avgValue: _avgSleep, unit: 'h', maxValue: 10),
      _HabitData(label: 'Water Intake', icon: '💧', userValue: _userWater, avgValue: _avgWater, unit: 'L', maxValue: 3),
    ]);

    _chartController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _chartController.dispose();
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
                'Based on\nyour profile...',
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
                'How you compare to peers your age',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 32),

              // 对比条形图
              Expanded(
                child: AnimatedBuilder(
                  animation: _chartController,
                  builder: (context, child) {
                    return Column(
                      children: _habits.asMap().entries.map((entry) {
                        final index = entry.key;
                        final habit = entry.value;
                        final delay = index * 0.15;
                        final itemProgress = (_chartController.value - delay).clamp(0.0, 1.0) / (1.0 - delay * 2);
                        return _HabitBarItem(
                          habit: habit,
                          progress: itemProgress.clamp(0.0, 1.0),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),

              // 图例
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendItem(color: const Color(0xFF4ECDC4), label: 'You'),
                  const SizedBox(width: 24),
                  _LegendItem(color: const Color(0xFFDDA0DD), label: 'Avg for your age'),
                ],
              ),

              const SizedBox(height: 24),

              // Next胶囊按钮
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
      ),
    );
  }
}

/// 习惯数据
class _HabitData {
  final String label;
  final String icon;
  final double userValue;
  final double avgValue;
  final String unit;
  final double maxValue;

  _HabitData({
    required this.label,
    required this.icon,
    required this.userValue,
    required this.avgValue,
    required this.unit,
    required this.maxValue,
  });
}

/// 单个习惯条形图
class _HabitBarItem extends StatelessWidget {
  final _HabitData habit;
  final double progress;

  const _HabitBarItem({
    required this.habit,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final userPercent = (habit.userValue / habit.maxValue).clamp(0.0, 1.0);
    final avgPercent = (habit.avgValue / habit.maxValue).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标签行
          Row(
            children: [
              Text(habit.icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                habit.label,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              Text(
                '${habit.userValue}${habit.unit} / ${habit.avgValue}${habit.unit}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 条形图
          SizedBox(
            height: 32,
            child: Stack(
              children: [
                // 背景
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                // 同龄人平均条
                FractionallySizedBox(
                  widthFactor: avgPercent,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFDDA0DD).withOpacity(0.6),
                          const Color(0xFFDDA0DD).withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                // 用户条 (带动画)
                FractionallySizedBox(
                  widthFactor: userPercent * progress,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4ECDC4), Color(0xFF6DD5C4)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4ECDC4).withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 图例项
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, color.withOpacity(0.6)]),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}


/// ============================================
/// P24: Premium Paywall Screen
/// ============================================
class PremiumPaywallScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const PremiumPaywallScreen({super.key, required this.onComplete});

  @override
  State<PremiumPaywallScreen> createState() => _PremiumPaywallScreenState();
}

class _PremiumPaywallScreenState extends State<PremiumPaywallScreen>
    with TickerProviderStateMixin {
  late AnimationController _cardController;
  late AnimationController _shimmerController;
  late AnimationController _pulseController;
  
  int _secondsRemaining = 900; // 15分钟
  bool _timerStarted = false;

  final List<_ProFeature> _proFeatures = [
    _ProFeature(icon: '🍽️', text: 'Unlimited diet logging'),
    _ProFeature(icon: '📊', text: 'Deep analytics reports'),
    _ProFeature(icon: '⏰', text: 'Advanced fasting timer'),
    _ProFeature(icon: '🎯', text: 'Personalized meal plans'),
    _ProFeature(icon: '💪', text: 'Progress tracking & insights'),
    _ProFeature(icon: '🔔', text: 'Smart reminders & notifications'),
  ];

  @override
  void initState() {
    super.initState();
    
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // 启动倒计时
    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && _secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
        return true;
      }
      return false;
    });
  }

  String get _formattedTime {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _cardController.dispose();
    _shimmerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 标题
              const Text(
                'Get your\npersonalized plan',
                textAlign: TextAlign.center,
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
                'Unlock all features with Pro membership',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 24),

              // 倒计时器
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = 1.0 + _pulseController.value * 0.05;
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFF6B6B).withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer, color: Color(0xFFFF6B6B), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '⏰ Limited offer: $_formattedTime',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFFFF6B6B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 金卡会员卡片
              Expanded(
                child: AnimatedBuilder(
                  animation: _cardController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - _cardController.value)),
                      child: Opacity(
                        opacity: _cardController.value,
                        child: child,
                      ),
                    );
                  },
                  child: _buildProCard(),
                ),
              ),

              const SizedBox(height: 24),

              // Get my plan 按钮
              GestureDetector(
                onTap: widget.onComplete,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD700).withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Get my plan for \$49.99',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 安全提示
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, color: Colors.white.withOpacity(0.5), size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'Secure payment • Cancel anytime',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProCard() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFD700),
                Color(0xFFFFA500),
                Color(0xFFFF8C00),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD700).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // 光泽效果
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: CustomPaint(
                    painter: _ShimmerPainter(progress: _shimmerController.value),
                  ),
                ),
              ),

              // 卡片内容
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // PRO 标签
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D3748),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '👑 PRO',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFFFFD700),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Best Value',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: const Color(0xFF2D3748).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Pro 功能列表
                    ..._proFeatures.map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D3748).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(feature.icon, style: const TextStyle(fontSize: 16)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature.text,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Color(0xFF2D3748),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(Icons.check_circle, color: Color(0xFF2D3748), size: 20),
                        ],
                      ),
                    )),

                    const Spacer(),

                    // 价格
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '\$49.99',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                            color: const Color(0xFF2D3748),
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '/ lifetime',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: const Color(0xFF2D3748).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Pro功能数据
class _ProFeature {
  final String icon;
  final String text;
  _ProFeature({required this.icon, required this.text});
}

/// 光泽效果
class _ShimmerPainter extends CustomPainter {
  final double progress;

  _ShimmerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(0.0),
        Colors.white.withOpacity(0.3),
        Colors.white.withOpacity(0.0),
      ],
      stops: [
        (progress - 0.3).clamp(0.0, 1.0),
        progress.clamp(0.0, 1.0),
        (progress + 0.3).clamp(0.0, 1.0),
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _ShimmerPainter oldDelegate) =>
      oldDelegate.progress != progress;
}


/// ============================================
/// P25: Pricing Screen
/// ============================================
class PricingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const PricingScreen({super.key, required this.onComplete});

  @override
  State<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  int _selectedPlan = 1; // 0 = Weekly, 1 = Yearly

  final List<_PricingPlan> _plans = [
    _PricingPlan(
      id: 0,
      name: 'Weekly',
      price: '\$9.99',
      period: '/week',
      badge: null,
      features: [
        'Full app access',
        'Diet tracking',
        'Basic analytics',
        'Email support',
      ],
    ),
    _PricingPlan(
      id: 1,
      name: 'Yearly',
      price: '\$49.99',
      period: '/year',
      badge: 'Most Popular',
      features: [
        'Everything in Weekly',
        'Advanced analytics',
        'Personalized plans',
        'Priority support',
        'Exclusive content',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _selectPlan(int index) {
    if (_selectedPlan != index) {
      setState(() {
        _selectedPlan = index;
      });
      _animController.reset();
      _animController.forward();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 标题
              const Text(
                'Choose your\npath',
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
                'Select the plan that works best for you',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 32),

              // 订阅选项卡
              Expanded(
                child: AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    return Column(
                      children: _plans.asMap().entries.map((entry) {
                        final index = entry.key;
                        final plan = entry.value;
                        final isSelected = _selectedPlan == index;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => _selectPlan(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutCubic,
                              margin: EdgeInsets.only(
                                bottom: 16,
                                left: isSelected ? 0 : 8,
                                right: isSelected ? 0 : 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF4CAF50)
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isSelected
                                        ? const Color(0xFF4CAF50).withOpacity(0.2)
                                        : Colors.black.withOpacity(0.08),
                                    blurRadius: isSelected ? 20 : 16,
                                    offset: const Offset(0, 8),
                                    spreadRadius: isSelected ? 2 : 0,
                                  ),
                                ],
                              ),
                              child: _PlanCard(
                                plan: plan,
                                isSelected: isSelected,
                                animProgress: _animController.value,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // 节省金额提示
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  key: ValueKey(_selectedPlan),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    _selectedPlan == 1 ? '🎉 You save \$1.99 per week!' : 'Upgrade to yearly for better savings',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: _selectedPlan == 1
                          ? const Color(0xFF4CAF50)
                          : Colors.grey.shade600,
                      fontWeight: _selectedPlan == 1 ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

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
                  child: Center(
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
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
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

/// 订阅计划数据
class _PricingPlan {
  final int id;
  final String name;
  final String price;
  final String period;
  final String? badge;
  final List<String> features;

  _PricingPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.period,
    required this.badge,
    required this.features,
  });
}

/// 计划卡片
class _PlanCard extends StatelessWidget {
  final _PricingPlan plan;
  final bool isSelected;
  final double animProgress;

  const _PlanCard({
    required this.plan,
    required this.isSelected,
    required this.animProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部行: 名称 + Badge + 价格
          Row(
            children: [
              // 选中指示器
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? const Color(0xFF4CAF50)
                      : Colors.grey.shade300,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF4CAF50)
                        : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),

              const SizedBox(width: 12),

              Text(
                plan.name,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF2D3748),
                ),
              ),

              const Spacer(),

              // Badge
              if (plan.badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    plan.badge!,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // 价格
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                plan.price,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: isSelected
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFF2D3748),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                plan.period,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 功能列表
          Expanded(
            child: Column(
              children: plan.features.asMap().entries.map((entry) {
                final index = entry.key;
                final feature = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: isSelected
                            ? const Color(0xFF4CAF50)
                            : Colors.grey.shade400,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        feature,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: isSelected
                              ? const Color(0xFF2D3748)
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}


/// ============================================
/// P26: Payment Commitment Screen
/// ============================================
class PaymentCommitmentScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const PaymentCommitmentScreen({super.key, required this.onComplete});

  @override
  State<PaymentCommitmentScreen> createState() => _PaymentCommitmentScreenState();
}

class _PaymentCommitmentScreenState extends State<PaymentCommitmentScreen>
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

  void _showPaymentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 成功图标
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF4CAF50),
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Payment processed!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your subscription is now active.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onComplete();
                },
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                'We are committed\nto your success',
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

              // Canvas郑重承诺小熊
              AnimatedBuilder(
                animation: _bearController,
                builder: (context, child) {
                  final raise = math.sin(_bearController.value * math.pi) * 10;
                  return Transform.translate(
                    offset: Offset(0, raise),
                    child: child,
                  );
                },
                child: CustomPaint(
                  size: const Size(180, 180),
                  painter: _CommitmentBearPainter(),
                ),
              ),

              const SizedBox(height: 32),

              // 退款政策卡片
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 退款政策
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4ECDC4).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text('💰', style: TextStyle(fontSize: 24)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '30-Day Money Back',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              Text(
                                'No questions asked',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Divider(color: Colors.grey.shade200),
                    const SizedBox(height: 16),

                    // 信任标识
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _TrustBadge(icon: '🔒', label: 'SSL\nEncrypted'),
                        _TrustBadge(icon: '✅', label: 'Secure\nPayment'),
                        _TrustBadge(icon: '🛡️', label: 'Protected\nData'),
                        _TrustBadge(icon: '📱', label: 'Private &\nSecure'),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Subscribe胶囊按钮
              GestureDetector(
                onTap: _showPaymentDialog,
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
                          'Subscribe',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.lock, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 副文案
              Text(
                'By subscribing, you agree to our Terms of Service',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: Colors.grey.shade500,
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

/// 信任标识
class _TrustBadge extends StatelessWidget {
  final String icon;
  final String label;

  const _TrustBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

/// Canvas: 郑重承诺小熊
class _CommitmentBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 15;

    // 身体
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 1.0), width: r * 1.6, height: r * 1.2),
      Paint()..color = const Color(0xFFD4A574),
    );

    // 头
    canvas.drawCircle(c, r * 0.9, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.75, c.dy - r * 0.7), r * 0.25, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.75, c.dy - r * 0.7), r * 0.14, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.75, c.dy - r * 0.7), r * 0.25, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.75, c.dy - r * 0.7), r * 0.14, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.15), width: r * 1.0, height: r * 0.85),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 坚定眼神 (眯着)
    _drawDeterminedEye(canvas, Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.12);
    _drawDeterminedEye(canvas, Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.12);

    // 自信微笑
    final smilePath = Path();
    smilePath.moveTo(c.dx - r * 0.2, c.dy + r * 0.3);
    smilePath.quadraticBezierTo(c.dx, c.dy + r * 0.45, c.dx + r * 0.2, c.dy + r * 0.3);
    canvas.drawPath(smilePath, Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round);

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.4, c.dy + r * 0.15), width: r * 0.2, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.4, c.dy + r * 0.15), width: r * 0.2, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));

    // 举起的小爪子
    _drawRaisedPaw(canvas, Offset(c.dx - r * 1.0, c.dy - r * 0.3), r * 0.35);
    _drawRaisedPaw(canvas, Offset(c.dx + r * 1.0, c.dy - r * 0.3), r * 0.35);
  }

  void _drawDeterminedEye(Canvas canvas, Offset center, double size) {
    // 眯眼表达坚定
    final path = Path();
    path.moveTo(center.dx - size * 1.2, center.dy);
    path.quadraticBezierTo(center.dx, center.dy - size * 0.6, center.dx + size * 1.2, center.dy);
    path.quadraticBezierTo(center.dx, center.dy + size * 0.3, center.dx - size * 1.2, center.dy);
    canvas.drawPath(path, Paint()..color = const Color(0xFF5D4037));
  }

  void _drawRaisedPaw(Canvas canvas, Offset center, double size) {
    // 爪子掌
    canvas.drawOval(
      Rect.fromCenter(center: center, width: size * 0.7, height: size * 0.9),
      Paint()..color = const Color(0xFFD4A574),
    );
    // 爪垫
    canvas.drawCircle(center + Offset(-size * 0.15, -size * 0.15), size * 0.12, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(center + Offset(size * 0.15, -size * 0.15), size * 0.12, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(center + Offset(0, -size * 0.05), size * 0.1, Paint()..color = const Color(0xFFE8C4A0));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


/// ============================================
/// P27: Welcome Screen
/// ============================================
class WelcomeScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const WelcomeScreen({super.key, required this.onComplete});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _confettiController;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _bounceAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 300.0, end: -20.0).chain(CurveTween(curve: Curves.easeOut)), weight: 40),
      TweenSequenceItem(tween: Tween(begin: -20.0, end: 10.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -5.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 15),
      TweenSequenceItem(tween: Tween(begin: -5.0, end: 0.0).chain(CurveTween(curve: Curves.bounceOut)), weight: 25),
    ]).animate(_bounceController);

    _confettiController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // 小熊弹入动画
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _bounceController.forward();
      }
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      body: Stack(
        children: [
          // 撒花背景
          AnimatedBuilder(
            animation: _confettiController,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: _WelcomeConfettiPainter(progress: _confettiController.value),
              );
            },
          ),

          // 内容
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // 标题
                  AnimatedBuilder(
                    animation: _bounceController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _bounceController.value.clamp(0.0, 1.0),
                        child: child,
                      );
                    },
                    child: const Text(
                      'Welcome to\nyour new life!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                        height: 1.1,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Canvas弹入小熊
                  AnimatedBuilder(
                    animation: _bounceAnim,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _bounceAnim.value),
                        child: child,
                      );
                    },
                    child: CustomPaint(
                      size: const Size(200, 200),
                      painter: _WelcomeBearPainter(),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Start Journey胶囊按钮
                  GestureDetector(
                    onTap: widget.onComplete,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4CAF50).withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Start Journey',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.rocket_launch,
                              color: Colors.white,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 副文案
                  Text(
                    'Your personalized plan is ready',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Canvas: 撒花庆祝小熊
class _WelcomeBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 15;

    // 身体
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 1.0), width: r * 1.6, height: r * 1.2),
      Paint()..color = const Color(0xFFD4A574),
    );

    // 头
    canvas.drawCircle(c, r * 0.9, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.75, c.dy - r * 0.7), r * 0.25, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.75, c.dy - r * 0.7), r * 0.14, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.75, c.dy - r * 0.7), r * 0.25, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.75, c.dy - r * 0.7), r * 0.14, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.15), width: r * 1.0, height: r * 0.85),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 开心眼睛 (弯弯笑眼)
    _drawHappyEye(canvas, Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.15);
    _drawHappyEye(canvas, Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.15);

    // 开心嘴
    final smilePath = Path();
    smilePath.moveTo(c.dx - r * 0.25, c.dy + r * 0.28);
    smilePath.quadraticBezierTo(c.dx, c.dy + r * 0.5, c.dx + r * 0.25, c.dy + r * 0.28);
    canvas.drawPath(smilePath, Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round);

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.4, c.dy + r * 0.15), width: r * 0.22, height: r * 0.12), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.4, c.dy + r * 0.15), width: r * 0.22, height: r * 0.12), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6));

    // 庆祝举起的双手
    _drawCelebratingArm(canvas, Offset(c.dx - r * 1.1, c.dy - r * 0.5), r * 0.35, -0.5);
    _drawCelebratingArm(canvas, Offset(c.dx + r * 1.1, c.dy - r * 0.5), r * 0.35, 0.5);
  }

  void _drawHappyEye(Canvas canvas, Offset center, double size) {
    final paint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    final path = Path();
    path.moveTo(center.dx - size, center.dy);
    path.quadraticBezierTo(center.dx, center.dy - size * 0.8, center.dx + size, center.dy);
    canvas.drawPath(path, paint);
  }

  void _drawCelebratingArm(Canvas canvas, Offset center, double size, double angle) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    
    // 手臂
    final armPath = Path();
    armPath.moveTo(0, size * 0.5);
    armPath.quadraticBezierTo(size * 0.3, 0, 0, -size * 0.8);
    canvas.drawPath(armPath, Paint()
      ..color = const Color(0xFFD4A574)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.25
      ..strokeCap = StrokeCap.round);
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Canvas: 撒花背景
class _WelcomeConfettiPainter extends CustomPainter {
  final double progress;

  _WelcomeConfettiPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECDC4),
      const Color(0xFFFFE66D),
      const Color(0xFFA8E6CF),
      const Color(0xFFDDA0DD),
      const Color(0xFFFFD700),
      const Color(0xFF64B5F6),
    ];

    final random = math.Random(42);

    for (int i = 0; i < 40; i++) {
      final seed = random.nextDouble();
      final x = seed * size.width;
      final startY = -20 - random.nextDouble() * 100;
      final endY = size.height + 50;
      final y = startY + (endY - startY) * progress + random.nextDouble() * 30;
      final color = colors[i % colors.length];
      final confettiSize = 4.0 + random.nextDouble() * 8;
      final rotation = progress * math.pi * 4 + i;
      final opacity = 0.5 + random.nextDouble() * 0.5;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      // 各种形状
      final shapeType = i % 4;
      if (shapeType == 0) {
        canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: confettiSize, height: confettiSize * 0.6), paint);
      } else if (shapeType == 1) {
        canvas.drawCircle(Offset.zero, confettiSize / 2, paint);
      } else if (shapeType == 2) {
        final path = Path();
        path.moveTo(0, -confettiSize / 2);
        path.lineTo(confettiSize / 2, confettiSize / 2);
        path.lineTo(-confettiSize / 2, confettiSize / 2);
        path.close();
        canvas.drawPath(path, paint);
      } else {
        canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: confettiSize, height: confettiSize * 0.5), paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _WelcomeConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}


/// ============================================
/// P28: Home Screen (Main Tab Interface)
/// ============================================
class HomeScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const HomeScreen({super.key, required this.onComplete});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _progressController;

  // 模拟数据
  int _dailyGoal = 2000;
  int _consumed = 850;
  int get _remaining => _dailyGoal - _consumed;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // 顶部问候语
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Today',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // 设置图标
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.settings_outlined,
                      color: Color(0xFF2D3748),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 分页指示器
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade600,
                labelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                tabs: const [
                  Tab(text: 'Calories'),
                  Tab(text: 'Water'),
                  Tab(text: 'Fasting'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tab内容
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Calories Tab
                  _CaloriesTab(
                    dailyGoal: _dailyGoal,
                    consumed: _consumed,
                    remaining: _remaining,
                    progressController: _progressController,
                    onAddMeal: (meal) {
                      // 临时占位：切到P31饮食记录页
                      _nextPage();
                    },
                  ),

                  // Water Tab (占位)
                  _PlaceholderTab(
                    icon: '💧',
                    title: 'Water Tracking',
                    description: 'Track your daily water intake',
                    color: const Color(0xFF64B5F6),
                  ),

                  // Fasting Tab (占位)
                  _PlaceholderTab(
                    icon: '⏰',
                    title: 'Fasting Timer',
                    description: 'Set your fasting schedule',
                    color: const Color(0xFFFF6B6B),
                  ),
                ],
              ),
            ),

            // 底部Tab栏
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _BottomNavItem(icon: Icons.home_filled, label: 'Home', isSelected: true),
                  _BottomNavItem(icon: Icons.restaurant_menu_outlined, label: 'Diet', isSelected: false),
                  _BottomNavItem(icon: Icons.bar_chart_rounded, label: 'Progress', isSelected: false),
                  _BottomNavItem(icon: Icons.person_outline, label: 'Profile', isSelected: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning 🌅';
    if (hour < 17) return 'Good afternoon ☀️';
    return 'Good evening 🌙';
  }

  void _nextPage() {
    final currentPage = HomeScreenStateMixin._currentPage;
    if (currentPage < 46) {
      HomeScreenStateMixin._controller?.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }
}

/// HomeScreen State Mixin
mixin HomeScreenStateMixin on State<HomeScreen> {
  static int _currentPage = 27;
  static PageController? _controller;
}

/// Calories Tab内容
class _CaloriesTab extends StatelessWidget {
  final int dailyGoal;
  final int consumed;
  final int remaining;
  final AnimationController progressController;
  final Function(String) onAddMeal;

  const _CaloriesTab({
    required this.dailyGoal,
    required this.consumed,
    required this.remaining,
    required this.progressController,
    required this.onAddMeal,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // 环形进度条
          AnimatedBuilder(
            animation: progressController,
            builder: (context, child) {
              final progress = (consumed / dailyGoal) * progressController.value;
              return _CalorieRing(
                dailyGoal: dailyGoal,
                consumed: consumed,
                remaining: remaining,
                progress: progress,
                size: 220,
              );
            },
          ),

          const SizedBox(height: 32),

          // 餐食添加按钮
          Row(
            children: [
              Expanded(
                child: _MealButton(
                  icon: '🌅',
                  label: 'Breakfast',
                  calories: 350,
                  color: const Color(0xFFFFE066),
                  onTap: () => onAddMeal('breakfast'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MealButton(
                  icon: '☀️',
                  label: 'Lunch',
                  calories: 600,
                  color: const Color(0xFFFF6B6B),
                  onTap: () => onAddMeal('lunch'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MealButton(
                  icon: '🌙',
                  label: 'Dinner',
                  calories: 500,
                  color: const Color(0xFF4ECDC4),
                  onTap: () => onAddMeal('dinner'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 最近记录预览
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Recent',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _MealRecordItem(
                  icon: '🥗',
                  name: 'Greek Salad',
                  time: '12:30 PM',
                  calories: 280,
                ),
                const Divider(height: 16),
                _MealRecordItem(
                  icon: '🍎',
                  name: 'Apple',
                  time: '10:15 AM',
                  calories: 95,
                ),
              ],
            ),
          ),

          const SizedBox(height: 100), // 底部留空
        ],
      ),
    );
  }
}

/// 环形卡路里进度条
class _CalorieRing extends StatelessWidget {
  final int dailyGoal;
  final int consumed;
  final int remaining;
  final double progress;
  final double size;

  const _CalorieRing({
    required this.dailyGoal,
    required this.consumed,
    required this.remaining,
    required this.progress,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 背景环
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 16,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade200),
            ),
          ),

          // 进度环
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 16,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
              strokeCap: StrokeCap.round,
            ),
          ),

          // 中心文字
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$remaining',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 48,
                  color: Color(0xFF2D3748),
                ),
              ),
              Text(
                'kcal remaining',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$consumed / $dailyGoal kcal',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 餐食添加按钮
class _MealButton extends StatelessWidget {
  final String icon;
  final String label;
  final int calories;
  final Color color;
  final VoidCallback onTap;

  const _MealButton({
    required this.icon,
    required this.label,
    required this.calories,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '~$calories kcal',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '+ Add',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 餐食记录项
class _MealRecordItem extends StatelessWidget {
  final String icon;
  final String name;
  final String time;
  final int calories;

  const _MealRecordItem({
    required this.icon,
    required this.name,
    required this.time,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text(icon, style: const TextStyle(fontSize: 20))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF2D3748),
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
        Text(
          '$calories kcal',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF4CAF50),
          ),
        ),
      ],
    );
  }
}

/// 占位Tab
class _PlaceholderTab extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final Color color;

  const _PlaceholderTab({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 48)),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

/// 底部导航项
class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade400,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade400,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}


/// ============================================
/// P29: Nutrients Breakdown Screen
/// ============================================
class NutrientsScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const NutrientsScreen({super.key, required this.onComplete});

  @override
  State<NutrientsScreen> createState() => _NutrientsScreenState();
}

class _NutrientsScreenState extends State<NutrientsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late AnimationController _bearController;

  // 营养数据 (模拟)
  final int _remainingCalories = 1150;
  final int _totalCarbs = 250; // grams
  final int _consumedCarbs = 180;
  final int _totalProtein = 150;
  final int _consumedProtein = 85;
  final int _totalFat = 65;
  final int _consumedFat = 35;

  // 展开状态
  bool _carbsExpanded = false;
  bool _proteinExpanded = false;
  bool _fatExpanded = false;

  // 计算表情状态
  String get _bearMood {
    final carbsRatio = _consumedCarbs / _totalCarbs;
    final proteinRatio = _consumedProtein / _totalProtein;
    final fatRatio = _consumedFat / _totalFat;

    // 如果碳水超标，显示挠头
    if (carbsRatio > 0.9) return 'confused';
    // 如果蛋白质不足，显示担忧
    if (proteinRatio < 0.3) return 'worried';
    // 如果脂肪超标，显示惊讶
    if (fatRatio > 0.9) return 'shocked';
    // 正常状态开心
    return 'happy';
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    _bearController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    _bearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Macronutrients',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF2D3748),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // 剩余卡路里卡片
              AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.8 + _animController.value * 0.2,
                    child: Opacity(
                      opacity: _animController.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4CAF50).withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Remaining Calories',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_remainingCalories',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 56,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'kcal today',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Canvas小熊 + 能量条
              AnimatedBuilder(
                animation: _bearController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, math.sin(_bearController.value * math.pi * 2) * 3),
                    child: child,
                  );
                },
                child: Row(
                  children: [
                    // Canvas小熊
                    CustomPaint(
                      size: const Size(80, 80),
                      painter: _NutritionBearPainter(mood: _bearMood),
                    ),
                    const SizedBox(width: 16),
                    // 能量条
                    Expanded(
                      child: Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _remainingCalories / 2000,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Text(
                _getMoodHint(),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 32),

              // 营养素进度条列表
              _NutrientBar(
                name: 'Carbs',
                icon: '🍞',
                consumed: _consumedCarbs,
                total: _totalCarbs,
                unit: 'g',
                color: const Color(0xFFFFE066),
                isExpanded: _carbsExpanded,
                details: _getCarbsDetails(),
                onToggle: () => setState(() => _carbsExpanded = !_carbsExpanded),
                animProgress: _animController.value,
              ),

              const SizedBox(height: 16),

              _NutrientBar(
                name: 'Protein',
                icon: '🥩',
                consumed: _consumedProtein,
                total: _totalProtein,
                unit: 'g',
                color: const Color(0xFFFF6B6B),
                isExpanded: _proteinExpanded,
                details: _getProteinDetails(),
                onToggle: () => setState(() => _proteinExpanded = !_proteinExpanded),
                animProgress: _animController.value,
              ),

              const SizedBox(height: 16),

              _NutrientBar(
                name: 'Fat',
                icon: '🥑',
                consumed: _consumedFat,
                total: _totalFat,
                unit: 'g',
                color: const Color(0xFF4ECDC4),
                isExpanded: _fatExpanded,
                details: _getFatDetails(),
                onToggle: () => setState(() => _fatExpanded = !_fatExpanded),
                animProgress: _animController.value,
              ),

              const SizedBox(height: 32),

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

  String _getMoodHint() {
    switch (_bearMood) {
      case 'confused':
        return 'Your carbs are a bit high today... 🤔';
      case 'worried':
        return 'You might need more protein! 💪';
      case 'shocked':
        return 'Fat intake is on the higher side... 😮';
      default:
        return 'Great balance today! Keep it up! 🎉';
    }
  }

  List<_NutrientDetail> _getCarbsDetails() => [
    _NutrientDetail(name: 'Whole grains', amount: '45g'),
    _NutrientDetail(name: 'Fruits', amount: '30g'),
    _NutrientDetail(name: 'Vegetables', amount: '25g'),
    _NutrientDetail(name: 'Others', amount: '80g'),
  ];

  List<_NutrientDetail> _getProteinDetails() => [
    _NutrientDetail(name: 'Chicken breast', amount: '30g'),
    _NutrientDetail(name: 'Eggs', amount: '20g'),
    _NutrientDetail(name: 'Fish', amount: '15g'),
    _NutrientDetail(name: 'Plant-based', amount: '20g'),
  ];

  List<_NutrientDetail> _getFatDetails() => [
    _NutrientDetail(name: 'Healthy fats', amount: '15g'),
    _NutrientDetail(name: 'Dairy', amount: '10g'),
    _NutrientDetail(name: 'Oils', amount: '10g'),
  ];
}

/// 营养素详情数据
class _NutrientDetail {
  final String name;
  final String amount;
  _NutrientDetail({required this.name, required this.amount});
}

/// 营养素进度条
class _NutrientBar extends StatelessWidget {
  final String name;
  final String icon;
  final int consumed;
  final int total;
  final String unit;
  final Color color;
  final bool isExpanded;
  final List<_NutrientDetail> details;
  final VoidCallback onToggle;
  final double animProgress;

  const _NutrientBar({
    required this.name,
    required this.icon,
    required this.consumed,
    required this.total,
    required this.unit,
    required this.color,
    required this.isExpanded,
    required this.details,
    required this.onToggle,
    required this.animProgress,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (consumed / total).clamp(0.0, 1.0);
    final displayPercent = (percent * animProgress).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // 顶部行
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(icon, style: const TextStyle(fontSize: 22)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$consumed / $total$unit',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(percent * 100).toInt()}%',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: color,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 进度条
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: displayPercent,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),

            // 展开详情
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                children: [
                  const SizedBox(height: 16),
                  ...details.map((d) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          d.name,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          d.amount,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
              crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }
}

/// Canvas: 营养小熊 (根据表情状态变化)
class _NutritionBearPainter extends CustomPainter {
  final String mood;

  _NutritionBearPainter({required this.mood});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 5;

    // 头
    canvas.drawCircle(c, r * 0.9, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.65), r * 0.25, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.65), r * 0.14, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.65), r * 0.25, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.65), r * 0.14, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.15), width: r * 1.0, height: r * 0.85),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 根据心情绘制不同表情
    switch (mood) {
      case 'confused':
        _drawConfusedFace(canvas, c, r);
        break;
      case 'worried':
        _drawWorriedFace(canvas, c, r);
        break;
      case 'shocked':
        _drawShockedFace(canvas, c, r);
        break;
      default:
        _drawHappyFace(canvas, c, r);
    }

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.4, c.dy + r * 0.15), width: r * 0.2, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.4, c.dy + r * 0.15), width: r * 0.2, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));
  }

  void _drawHappyFace(Canvas canvas, Offset c, double r) {
    // 弯弯笑眼
    _drawHappyEye(canvas, Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.15);
    _drawHappyEye(canvas, Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.15);
    // 开心嘴
    final smilePath = Path();
    smilePath.moveTo(c.dx - r * 0.2, c.dy + r * 0.28);
    smilePath.quadraticBezierTo(c.dx, c.dy + r * 0.45, c.dx + r * 0.2, c.dy + r * 0.28);
    canvas.drawPath(smilePath, Paint()..color = const Color(0xFF8B4513)..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round);
  }

  void _drawConfusedFace(Canvas canvas, Offset c, double r) {
    // 挠头 - 一只手上抬
    _drawScratchHand(canvas, Offset(c.dx - r * 1.0, c.dy - r * 0.2), r * 0.3);
    // 大问号
    _drawQuestionMark(canvas, Offset(c.dx + r * 0.5, c.dy - r * 1.1), r * 0.25);
    // 大眼睛
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.16, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.16, Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.08, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.16, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.16, Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.08, Paint()..color = Colors.black);
    // 困惑嘴
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.32), width: r * 0.15, height: r * 0.1), Paint()..color = const Color(0xFF8B4513));
  }

  void _drawWorriedFace(Canvas canvas, Offset c, double r) {
    // 担忧眼神
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.15, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.15, Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy - r * 0.02), r * 0.08, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.15, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.15, Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy - r * 0.02), r * 0.08, Paint()..color = Colors.black);
    // 皱眉
    final browPath = Path();
    browPath.moveTo(c.dx - r * 0.4, c.dy - r * 0.3);
    browPath.quadraticBezierTo(c.dx - r * 0.28, c.dy - r * 0.38, c.dx - r * 0.15, c.dy - r * 0.32);
    canvas.drawPath(browPath, Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    final browPath2 = Path();
    browPath2.moveTo(c.dx + r * 0.15, c.dy - r * 0.32);
    browPath2.quadraticBezierTo(c.dx + r * 0.28, c.dy - r * 0.38, c.dx + r * 0.4, c.dy - r * 0.3);
    canvas.drawPath(browPath2, Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    // 担忧嘴
    final frownPath = Path();
    frownPath.moveTo(c.dx - r * 0.15, c.dy + r * 0.35);
    frownPath.quadraticBezierTo(c.dx, c.dy + r * 0.28, c.dx + r * 0.15, c.dy + r * 0.35);
    canvas.drawPath(frownPath, Paint()..color = const Color(0xFF8B4513)..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  void _drawShockedFace(Canvas canvas, Offset c, double r) {
    // 惊讶大眼
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.2, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.2, Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.12, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.2, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.2, Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.12, Paint()..color = Colors.black);
    // O型嘴
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.35), width: r * 0.2, height: r * 0.25), Paint()..color = const Color(0xFF8B4513));
  }

  void _drawHappyEye(Canvas canvas, Offset center, double size) {
    final paint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final path = Path();
    path.moveTo(center.dx - size, center.dy);
    path.quadraticBezierTo(center.dx, center.dy - size * 0.8, center.dx + size, center.dy);
    canvas.drawPath(path, paint);
  }

  void _drawScratchHand(Canvas canvas, Offset center, double size) {
    canvas.drawOval(Rect.fromCenter(center: center, width: size * 0.6, height: size * 0.8), Paint()..color = const Color(0xFFD4A574));
    // 小爪痕
    for (int i = -1; i <= 1; i++) {
      canvas.drawLine(center + Offset(i * size * 0.15, -size * 0.4), center + Offset(i * size * 0.15, -size * 0.6), Paint()..color = const Color(0xFFE8C4A0)..strokeWidth = 2);
    }
  }

  void _drawQuestionMark(Canvas canvas, Offset center, double size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '?',
        style: TextStyle(
          fontSize: size * 2,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFFFE066),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _NutritionBearPainter oldDelegate) =>
      oldDelegate.mood != mood;
}


/// ============================================
/// P30: Mood Tracking Screen
/// ============================================
class MoodScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const MoodScreen({super.key, required this.onComplete});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bearController;
  late Animation<double> _bounceAnim;
  String? _selectedMood;

  final List<_MoodOption> _moods = [
    _MoodOption(id: 'happy', emoji: '😊', label: 'Happy'),
    _MoodOption(id: 'calm', emoji: '😌', label: 'Calm'),
    _MoodOption(id: 'tired', emoji: '😴', label: 'Tired'),
    _MoodOption(id: 'energetic', emoji: '💪', label: 'Energetic'),
    _MoodOption(id: 'stressed', emoji: '😰', label: 'Stressed'),
  ];

  final List<String> _affirmations = [
    'Every feeling is welcome here 💜',
    'You are doing better than you think 🌟',
    'Take a deep breath. You\'ve got this 🌸',
    'Progress, not perfection ✨',
    'Your effort matters every day 💫',
    'Be kind to yourself today 🌻',
    'Small steps lead to big changes 🌱',
    'You are stronger than you feel 💪',
  ];

  late String _currentAffirmation;

  @override
  void initState() {
    super.initState();
    _currentAffirmation = _affirmations[DateTime.now().second % _affirmations.length];
    
    _bearController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _bounceAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -15.0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: -15.0, end: 8.0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -4.0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: -4.0, end: 0.0), weight: 25),
    ]).animate(CurvedAnimation(parent: _bearController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _bearController.dispose();
    super.dispose();
  }

  void _selectMood(String moodId) {
    if (_selectedMood != moodId) {
      setState(() {
        _selectedMood = moodId;
      });
      _bearController.reset();
      _bearController.forward();
      _currentAffirmation = _affirmations[DateTime.now().millisecond % _affirmations.length];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Mood',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF2D3748),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // 标题
              const Text(
                'How are you\nfeeling today?',
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

              // Canvas表情小熊
              AnimatedBuilder(
                animation: _bounceAnim,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _bounceAnim.value),
                    child: child,
                  );
                },
                child: CustomPaint(
                  size: const Size(160, 160),
                  painter: _MoodBearPainter(mood: _selectedMood ?? 'neutral'),
                ),
              ),

              const SizedBox(height: 32),

              // 情绪安抚文案
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Text(
                  _currentAffirmation,
                  key: ValueKey(_currentAffirmation),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 情绪选择器
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Tap to select your mood',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _moods.map((mood) {
                        final isSelected = _selectedMood == mood.id;
                        return GestureDetector(
                          onTap: () => _selectMood(mood.id),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? _getMoodColor(mood.id).withOpacity(0.15)
                                  : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? _getMoodColor(mood.id)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  mood.emoji,
                                  style: TextStyle(
                                    fontSize: isSelected ? 36 : 28,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  mood.label,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                    color: isSelected
                                        ? _getMoodColor(mood.id)
                                        : Colors.grey,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Next胶囊按钮
              GestureDetector(
                onTap: _selectedMood != null ? widget.onComplete : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: _selectedMood != null
                        ? const LinearGradient(
                            colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                          )
                        : null,
                    color: _selectedMood == null ? Colors.grey.shade300 : null,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: _selectedMood != null
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
                            color: _selectedMood != null
                                ? Colors.white
                                : Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: _selectedMood != null
                              ? Colors.white
                              : Colors.grey.shade500,
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

  Color _getMoodColor(String moodId) {
    switch (moodId) {
      case 'happy':
        return const Color(0xFFFFD700);
      case 'calm':
        return const Color(0xFF4ECDC4);
      case 'tired':
        return const Color(0xFF9B59B6);
      case 'energetic':
        return const Color(0xFFFF6B6B);
      case 'stressed':
        return const Color(0xFFE67E22);
      default:
        return Colors.grey;
    }
  }
}

/// 情绪选项
class _MoodOption {
  final String id;
  final String emoji;
  final String label;

  _MoodOption({required this.id, required this.emoji, required this.label});
}

/// Canvas: 表情小熊
class _MoodBearPainter extends CustomPainter {
  final String mood;

  _MoodBearPainter({required this.mood});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 10;

    // 头
    canvas.drawCircle(c, r * 0.9, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.65), r * 0.25, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.65), r * 0.14, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.65), r * 0.25, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.65), r * 0.14, Paint()..color = const Color(0xFFE8C4A0));

    // 身体
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 1.1), width: r * 1.4, height: r * 1.0),
      Paint()..color = const Color(0xFFD4A574),
    );

    // 面部
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.15), width: r * 1.0, height: r * 0.85),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 根据心情绘制表情
    switch (mood) {
      case 'happy':
        _drawHappyFace(canvas, c, r);
        break;
      case 'calm':
        _drawCalmFace(canvas, c, r);
        break;
      case 'tired':
        _drawTiredFace(canvas, c, r);
        break;
      case 'energetic':
        _drawEnergeticFace(canvas, c, r);
        break;
      case 'stressed':
        _drawStressedFace(canvas, c, r);
        break;
      default:
        _drawNeutralFace(canvas, c, r);
    }

    // 腮红
    if (mood == 'happy' || mood == 'energetic') {
      canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.4, c.dy + r * 0.15), width: r * 0.2, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));
      canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.4, c.dy + r * 0.15), width: r * 0.2, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));
    }
  }

  void _drawHappyFace(Canvas canvas, Offset c, double r) {
    // 弯弯笑眼
    _drawHappyEye(canvas, Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.15);
    _drawHappyEye(canvas, Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.15);
    // 开心嘴
    final smilePath = Path();
    smilePath.moveTo(c.dx - r * 0.2, c.dy + r * 0.28);
    smilePath.quadraticBezierTo(c.dx, c.dy + r * 0.45, c.dx + r * 0.2, c.dy + r * 0.28);
    canvas.drawPath(smilePath, Paint()..color = const Color(0xFF8B4513)..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round);
  }

  void _drawCalmFace(Canvas canvas, Offset c, double r) {
    // 平静半闭眼
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.28, c.dy - r * 0.05), width: r * 0.3, height: r * 0.1), Paint()..color = const Color(0xFF5D4037));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.28, c.dy - r * 0.05), width: r * 0.3, height: r * 0.1), Paint()..color = const Color(0xFF5D4037));
    // 微笑
    final smilePath = Path();
    smilePath.moveTo(c.dx - r * 0.15, c.dy + r * 0.28);
    smilePath.quadraticBezierTo(c.dx, c.dy + r * 0.38, c.dx + r * 0.15, c.dy + r * 0.28);
    canvas.drawPath(smilePath, Paint()..color = const Color(0xFF8B4513)..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round);
  }

  void _drawTiredFace(Canvas canvas, Offset c, double r) {
    // 疲惫半闭眼
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.28, c.dy - r * 0.02), width: r * 0.25, height: r * 0.08), Paint()..color = const Color(0xFF5D4037));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.28, c.dy - r * 0.02), width: r * 0.25, height: r * 0.08), Paint()..color = const Color(0xFF5D4037));
    // 直线嘴
    canvas.drawLine(Offset(c.dx - r * 0.12, c.dy + r * 0.35), Offset(c.dx + r * 0.12, c.dy + r * 0.35), Paint()..color = const Color(0xFF8B4513)..strokeWidth = 2..strokeCap = StrokeCap.round);
    // 眼袋
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.28, c.dy + r * 0.1), width: r * 0.2, height: r * 0.06), Paint()..color = const Color(0xFF9B59B6).withOpacity(0.3));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.28, c.dy + r * 0.1), width: r * 0.2, height: r * 0.06), Paint()..color = const Color(0xFF9B59B6).withOpacity(0.3));
  }

  void _drawEnergeticFace(Canvas canvas, Offset c, double r) {
    // 闪亮大眼睛
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy - r * 0.08), r * 0.18, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy - r * 0.08), r * 0.14, Paint()..color = const Color(0xFF5D4037));
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy - r * 0.08), r * 0.08, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(c.dx - r * 0.32, c.dy - r * 0.12), r * 0.04, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy - r * 0.08), r * 0.18, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy - r * 0.08), r * 0.14, Paint()..color = const Color(0xFF5D4037));
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy - r * 0.08), r * 0.08, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(c.dx + r * 0.24, c.dy - r * 0.12), r * 0.04, Paint()..color = Colors.white);
    // 大笑嘴
    final laughPath = Path();
    laughPath.moveTo(c.dx - r * 0.25, c.dy + r * 0.25);
    laughPath.quadraticBezierTo(c.dx, c.dy + r * 0.55, c.dx + r * 0.25, c.dy + r * 0.25);
    canvas.drawPath(laughPath, Paint()..color = const Color(0xFF8B4513)..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round);
    // 星星特效
    _drawSparkle(canvas, Offset(c.dx - r * 0.9, c.dy - r * 0.9), r * 0.15);
    _drawSparkle(canvas, Offset(c.dx + r * 0.9, c.dy - r * 0.8), r * 0.12);
  }

  void _drawStressedFace(Canvas canvas, Offset c, double r) {
    // 紧张眼睛
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.15, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.15, Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.07, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.15, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.15, Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.07, Paint()..color = Colors.black);
    // 冒汗
    canvas.drawOval(Rect.fromLTWH(c.dx + r * 0.6, c.dy - r * 0.4, r * 0.15, r * 0.2), Paint()..color = const Color(0xFF64B5F6));
    canvas.drawOval(Rect.fromLTWH(c.dx + r * 0.4, c.dy - r * 0.6), r * 0.12, Paint()..color = const Color(0xFF64B5F6));
    // 紧绑嘴
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.35), width: r * 0.12, height: r * 0.08), Paint()..color = const Color(0xFF8B4513));
  }

  void _drawNeutralFace(Canvas canvas, Offset c, double r) {
    // 普通眼睛
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.12, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.12, Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.06, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.12, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.12, Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.06, Paint()..color = Colors.black);
    // 直线嘴
    canvas.drawLine(Offset(c.dx - r * 0.12, c.dy + r * 0.32), Offset(c.dx + r * 0.12, c.dy + r * 0.32), Paint()..color = const Color(0xFF8B4513)..strokeWidth = 2..strokeCap = StrokeCap.round);
  }

  void _drawHappyEye(Canvas canvas, Offset center, double size) {
    final paint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final path = Path();
    path.moveTo(center.dx - size, center.dy);
    path.quadraticBezierTo(center.dx, center.dy - size * 0.8, center.dx + size, center.dy);
    canvas.drawPath(path, paint);
  }

  void _drawSparkle(Canvas canvas, Offset center, double size) {
    final paint = Paint()..color = const Color(0xFFFFD700);
    // 星形
    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      canvas.drawLine(
        center + Offset(math.cos(angle) * size * 0.3, math.sin(angle) * size * 0.3),
        center + Offset(math.cos(angle) * size, math.sin(angle) * size),
        Paint()..color = const Color(0xFFFFD700)..strokeWidth = 2..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MoodBearPainter oldDelegate) =>
      oldDelegate.mood != mood;
}


/// ============================================
/// P31: Food Search Screen
/// ============================================
class FoodSearchScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const FoodSearchScreen({super.key, required this.onComplete});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bearController;
  late Animation<double> _bearAnim;
  late Animation<double> _eyeAnim;

  @override
  void initState() {
    super.initState();
    _bearController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _bearAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -5.0, end: 5.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 5.0, end: -5.0), weight: 50),
    ]).animate(_bearController);

    _eyeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.15), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.15, end: 0.0), weight: 50),
    ]).animate(_bearController);
  }

  @override
  void dispose() {
    _bearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Add Food',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF2D3748),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Canvas探头大熊
              AnimatedBuilder(
                animation: Listenable.merge([_bearAnim, _eyeAnim]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _bearAnim.value),
                    child: child,
                  );
                },
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // 身体在屏幕外
                    const SizedBox(height: 60),
                    // 头部
                    CustomPaint(
                      size: const Size(120, 120),
                      painter: _PeekingBearPainter(eyeOpenness: _eyeAnim.value),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 搜索框
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey.shade400, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Search for food',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.mic,
                        color: Color(0xFF4CAF50),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 快速扫描选项
              const Text(
                'Or try these',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF2D3748),
                ),
              ),

              const SizedBox(height: 16),

              // Quick Scan 卡片
              _ScanCard(
                icon: '📸',
                title: 'Quick Scan',
                description: 'AI-powered photo recognition',
                color: const Color(0xFF4ECDC4),
                onTap: () {
                  // TODO: 相机扫描
                },
              ),

              const SizedBox(height: 16),

              // Scan Barcode 卡片
              _ScanCard(
                icon: '📊',
                title: 'Scan Barcode',
                description: 'Scan food product barcode',
                color: const Color(0xFFFF6B6B),
                onTap: () {
                  // TODO: 条码扫描
                },
              ),

              const SizedBox(height: 24),

              // 最近扫描
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Recent Scans',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'See all',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _RecentScanItem(
                      icon: '🥗',
                      name: 'Caesar Salad',
                      calories: 320,
                      time: '2h ago',
                    ),
                    const Divider(height: 16),
                    _RecentScanItem(
                      icon: '🍎',
                      name: 'Organic Apple',
                      calories: 95,
                      time: '4h ago',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Next胶囊按钮
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
      ),
    );
  }
}

/// 扫描卡片
class _ScanCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _ScanCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

/// 最近扫描项
class _RecentScanItem extends StatelessWidget {
  final String icon;
  final String name;
  final int calories;
  final String time;

  const _RecentScanItem({
    required this.icon,
    required this.name,
    required this.calories,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: Text(icon, style: const TextStyle(fontSize: 22))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF2D3748),
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
        Text(
          '$calories kcal',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF4CAF50),
          ),
        ),
      ],
    );
  }
}

/// Canvas: 探头大熊 (期待眼神)
class _PeekingBearPainter extends CustomPainter {
  final double eyeOpenness;

  _PeekingBearPainter({required this.eyeOpenness});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    // 身体 (部分在屏幕外)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 1.3), width: r * 2.0, height: r * 1.8),
      Paint()..color = const Color(0xFFD4A574),
    );

    // 头
    canvas.drawCircle(c, r * 0.9, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.6), r * 0.25, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.6), r * 0.14, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.6), r * 0.25, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.6), r * 0.14, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.2), width: r * 1.0, height: r * 0.8),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 期待大眼睛
    final eyeHeight = r * 0.22 * (1 + eyeOpenness);
    // 左眼
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx - r * 0.3, c.dy), width: r * 0.28, height: eyeHeight),
      Paint()..color = Colors.white,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx - r * 0.3, c.dy), width: r * 0.28, height: eyeHeight),
      Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2,
    );
    canvas.drawCircle(Offset(c.dx - r * 0.3, c.dy), r * 0.1, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(c.dx - r * 0.35, c.dy - r * 0.05), r * 0.03, Paint()..color = Colors.white);

    // 右眼
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx + r * 0.3, c.dy), width: r * 0.28, height: eyeHeight),
      Paint()..color = Colors.white,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx + r * 0.3, c.dy), width: r * 0.28, height: eyeHeight),
      Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2,
    );
    canvas.drawCircle(Offset(c.dx + r * 0.3, c.dy), r * 0.1, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(c.dx + r * 0.25, c.dy - r * 0.05), r * 0.03, Paint()..color = Colors.white);

    // 期待嘴 (小圆形)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.4), width: r * 0.15, height: r * 0.12),
      Paint()..color = const Color(0xFF8B4513),
    );

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.45, c.dy + r * 0.25), width: r * 0.2, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.45, c.dy + r * 0.25), width: r * 0.2, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6));

    // 举起的双手 (期待)
    _drawRaisingArm(canvas, Offset(c.dx - r * 1.0, c.dy + r * 0.3), r * 0.3, -0.3);
    _drawRaisingArm(canvas, Offset(c.dx + r * 1.0, c.dy + r * 0.3), r * 0.3, 0.3);
  }

  void _drawRaisingArm(Canvas canvas, Offset center, double size, double angle) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.drawOval(Rect.fromCenter(center: Offset(0, -size * 0.3), width: size * 0.5, height: size * 0.7), Paint()..color = const Color(0xFFD4A574));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PeekingBearPainter oldDelegate) =>
      oldDelegate.eyeOpenness != eyeOpenness;
}


/// ============================================
/// P32: Food List Screen
/// ============================================
class FoodListScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const FoodListScreen({super.key, required this.onComplete});

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen>
    with TickerProviderStateMixin {
  late AnimationController _bearController;

  final Set<String> _selectedFoods = {};

  final List<_FoodItem> _foods = [
    _FoodItem(name: 'Sweet potato', calories: 120, emoji: '🍠'),
    _FoodItem(name: 'Apple', calories: 95, emoji: '🍎'),
    _FoodItem(name: 'Avocado', calories: 240, emoji: '🥑'),
    _FoodItem(name: 'Banana', calories: 105, emoji: '🍌'),
    _FoodItem(name: 'Grilled chicken', calories: 165, emoji: '🍗'),
    _FoodItem(name: 'Brown rice', calories: 215, emoji: '🍚'),
    _FoodItem(name: 'Salmon', calories: 208, emoji: '🐟'),
    _FoodItem(name: 'Egg', calories: 78, emoji: '🥚'),
  ];

  String? _lastAddedFood;
  int? _lastAddedCalories;

  @override
  void initState() {
    super.initState();
    _bearController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _bearController.dispose();
    super.dispose();
  }

  void _toggleFood(String foodId, int calories) {
    setState(() {
      if (_selectedFoods.contains(foodId)) {
        _selectedFoods.remove(foodId);
      } else {
        _selectedFoods.add(foodId);
        _lastAddedFood = foodId;
        _lastAddedCalories = calories;
        _bearController.reset();
        _bearController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Add to your meal',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF2D3748),
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Clear',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Color(0xFFFF6B6B),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Canvas小熊 + 热量泡泡
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  // Canvas小熊
                  AnimatedBuilder(
                    animation: _bearController,
                    builder: (context, child) {
                      final bounce = math.sin(_bearController.value * math.pi * 2) * 3;
                      return Transform.translate(
                        offset: Offset(0, bounce),
                        child: child,
                      );
                    },
                    child: CustomPaint(
                      size: const Size(60, 60),
                      painter: _FoodBearPainter(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // 热量泡泡
                  AnimatedBuilder(
                    animation: _bearController,
                    builder: (context, child) {
                      final opacity = _bearController.value < 0.3
                          ? _bearController.value / 0.3
                          : _bearController.value > 0.7
                              ? (1 - _bearController.value) / 0.3
                              : 1.0;
                      final scale = 0.5 + _bearController.value * 0.5;
                      return Opacity(
                        opacity: opacity.clamp(0.0, 1.0),
                        child: Transform.scale(
                          scale: scale.clamp(0.5, 1.0),
                          child: child,
                        ),
                      );
                    },
                    child: _lastAddedCalories != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Good choice! +$_lastAddedCalories kcal',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            // 标题
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  const Text(
                    'Suggested foods',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_selectedFoods.length} selected',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 食物列表
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _foods.length,
                itemBuilder: (context, index) {
                  final food = _foods[index];
                  final isSelected = _selectedFoods.contains(food.id);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _FoodListItem(
                      food: food,
                      isSelected: isSelected,
                      onToggle: () => _toggleFood(food.id, food.calories),
                    ),
                  );
                },
              ),
            ),

            // 已选摘要
            if (_selectedFoods.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text(
                      '${_selectedFoods.length} items',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_getTotalCalories()} kcal',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Next胶囊按钮
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
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
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  int _getTotalCalories() {
    return _foods
        .where((f) => _selectedFoods.contains(f.id))
        .fold(0, (sum, f) => sum + f.calories);
  }
}

/// 食物数据
class _FoodItem {
  final String id;
  final String name;
  final int calories;
  final String emoji;

  _FoodItem({required this.name, required this.calories, required this.emoji})
      : id = name.toLowerCase().replaceAll(' ', '_');
}

/// 食物列表项
class _FoodListItem extends StatefulWidget {
  final _FoodItem food;
  final bool isSelected;
  final VoidCallback onToggle;

  const _FoodListItem({
    required this.food,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  State<_FoodListItem> createState() => _FoodListItemState();
}

class _FoodListItemState extends State<_FoodListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _checkController;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _checkAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.easeOutBack),
    );

    if (widget.isSelected) {
      _checkController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_FoodListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _checkController.forward();
      } else {
        _checkController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? const Color(0xFF4CAF50).withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.isSelected
                ? const Color(0xFF4CAF50)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Emoji
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(widget.food.emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 16),
            // 名称和热量
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.food.name,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: widget.isSelected
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFF2D3748),
                    ),
                  ),
                  Text(
                    '${widget.food.calories} kcal',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            // 加号/勾号按钮
            AnimatedBuilder(
              animation: _checkAnimation,
              builder: (context, child) {
                return Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? const Color(0xFF4CAF50)
                        : Colors.grey.shade200,
                    shape: BoxShape.circle,
                    boxShadow: widget.isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF4CAF50).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: widget.isSelected
                        ? Transform.scale(
                            scale: _checkAnimation.value,
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            ),
                          )
                        : Icon(
                            Icons.add,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Canvas: 食物小熊
class _FoodBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 5;

    // 头
    canvas.drawCircle(c, r * 0.9, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.65), r * 0.22, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.65), r * 0.12, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.65), r * 0.22, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.65), r * 0.12, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.15), width: r * 1.0, height: r * 0.85),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 开心眯眼
    _drawHappyEye(canvas, Offset(c.dx - r * 0.28, c.dy), r * 0.12);
    _drawHappyEye(canvas, Offset(c.dx + r * 0.28, c.dy), r * 0.12);

    // 微笑
    final smilePath = Path();
    smilePath.moveTo(c.dx - r * 0.15, c.dy + r * 0.28);
    smilePath.quadraticBezierTo(c.dx, c.dy + r * 0.42, c.dx + r * 0.15, c.dy + r * 0.28);
    canvas.drawPath(smilePath, Paint()..color = const Color(0xFF8B4513)..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round);

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.4, c.dy + r * 0.15), width: r * 0.18, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.4, c.dy + r * 0.15), width: r * 0.18, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));

    // 身体
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 1.2), width: r * 1.4, height: r * 0.8),
      Paint()..color = const Color(0xFFD4A574),
    );
  }

  void _drawHappyEye(Canvas canvas, Offset center, double size) {
    final paint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final path = Path();
    path.moveTo(center.dx - size, center.dy);
    path.quadraticBezierTo(center.dx, center.dy - size * 0.6, center.dx + size, center.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


/// ============================================
/// P33: Calorie Calculator Screen
/// ============================================
class CalorieCalculatorScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const CalorieCalculatorScreen({super.key, required this.onComplete});

  @override
  State<CalorieCalculatorScreen> createState() => _CalorieCalculatorScreenState();
}

class _CalorieCalculatorScreenState extends State<CalorieCalculatorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  // 选定食物 (默认Sweet Potato)
  final String _foodName = 'Sweet Potato';
  final String _foodEmoji = '🍠';
  final double _caloriesPerGram = 1.2; // kcal per gram

  double _weight = 100.0; // grams
  late double _totalCalories;

  @override
  void initState() {
    super.initState();
    _totalCalories = _weight * _caloriesPerGram;

    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.1), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutBack));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _updateWeight(double value) {
    setState(() {
      _weight = value;
      _totalCalories = _weight * _caloriesPerGram;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Calculator',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF2D3748),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // 食物卡片
              AnimatedBuilder(
                animation: _scaleAnim,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnim.value,
                    child: child,
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFE066), Color(0xFFFFD700)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFE066).withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Emoji
                      Text(
                        _foodEmoji,
                        style: const TextStyle(fontSize: 64),
                      ),
                      const SizedBox(height: 12),
                      // 食物名称
                      Text(
                        _foodName,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // 动态热量数值
                      Text(
                        '${_totalCalories.toStringAsFixed(0)} kcal',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 48,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'per ${_weight.toStringAsFixed(0)}g',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: const Color(0xFF2D3748).withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 克数滑动条
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Adjust weight',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF2D3748),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 克数显示
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${_weight.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 48,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'g',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 滑动条
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: const Color(0xFF4CAF50),
                        inactiveTrackColor: Colors.grey.shade200,
                        thumbColor: const Color(0xFF4CAF50),
                        overlayColor: const Color(0xFF4CAF50).withOpacity(0.2),
                        trackHeight: 8,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
                      ),
                      child: Slider(
                        value: _weight,
                        min: 0,
                        max: 500,
                        divisions: 100,
                        onChanged: _updateWeight,
                      ),
                    ),

                    // 刻度标签
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('0g', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey.shade500)),
                        Text('250g', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey.shade500)),
                        Text('500g', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey.shade500)),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 快捷按钮
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _QuickWeightButton(label: '50g', onTap: () => _updateWeight(50)),
                        _QuickWeightButton(label: '100g', onTap: () => _updateWeight(100)),
                        _QuickWeightButton(label: '200g', onTap: () => _updateWeight(200)),
                        _QuickWeightButton(label: '250g', onTap: () => _updateWeight(250)),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Add to diary按钮
              GestureDetector(
                onTap: widget.onComplete,
                child: Container(
                  height: 56,
                  width: double.infinity,
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
                        Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Add to diary',
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
            ],
          ),
        ),
      ),
    );
  }
}

/// 快捷重量按钮
class _QuickWeightButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickWeightButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF4CAF50).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4CAF50),
          ),
        ),
      ),
    );
  }
}


/// ============================================
/// P34: Fasting Plan Screen
/// ============================================
class FastingPlanScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const FastingPlanScreen({super.key, required this.onComplete});

  @override
  State<FastingPlanScreen> createState() => _FastingPlanScreenState();
}

class _FastingPlanScreenState extends State<FastingPlanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgAnimController;
  String? _selectedPlan;

  final List<_FastingPlan> _plans = [
    _FastingPlan(id: '16_8', name: '16:8', description: '16h fasting, 8h eating', hours: 16, color: const Color(0xFF4CAF50)),
    _FastingPlan(id: '14_10', name: '14:10', description: '14h fasting, 10h eating', hours: 14, color: const Color(0xFF4ECDC4)),
    _FastingPlan(id: '12_12', name: '12:12', description: '12h fasting, 12h eating', hours: 12, color: const Color(0xFFFFE066)),
    _FastingPlan(id: '20_4', name: '20:4', description: '20h fasting, 4h eating', hours: 20, color: const Color(0xFFFF6B6B)),
  ];

  @override
  void initState() {
    super.initState();
    _bgAnimController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _bgAnimController.dispose();
    super.dispose();
  }

  void _selectPlan(String planId) {
    setState(() {
      _selectedPlan = planId;
    });
    _bgAnimController.reset();
    _bgAnimController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bgAnimController,
      builder: (context, child) {
        // 从浅蓝到深蓝的lerp
        final bgColor = Color.lerp(
          const Color(0xFFEDF6FA),
          const Color(0xFF1a2a3a),
          _bgAnimController.value,
        )!;

        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // 标题
                  Text(
                    'Choose your\nfasting plan',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      height: 1.1,
                      color: Color.lerp(const Color(0xFF2D3748), Colors.white, _bgAnimController.value),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Select the fasting schedule that fits your lifestyle',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Color.lerp(Colors.grey.shade600, Colors.white70, _bgAnimController.value),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 方案卡片
                  Expanded(
                    child: Column(
                      children: _plans.asMap().entries.map((entry) {
                        final index = entry.key;
                        final plan = entry.value;
                        final isSelected = _selectedPlan == plan.id;

                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: index < _plans.length - 1 ? 12 : 0),
                            child: _FastingPlanCard(
                              plan: plan,
                              isSelected: isSelected,
                              progress: _bgAnimController.value,
                              onTap: () => _selectPlan(plan.id),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Start胶囊按钮
                  GestureDetector(
                    onTap: _selectedPlan != null ? widget.onComplete : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 56,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: _selectedPlan != null
                            ? LinearGradient(
                                colors: [
                                  _plans.firstWhere((p) => p.id == _selectedPlan).color,
                                  _plans.firstWhere((p) => p.id == _selectedPlan).color.withOpacity(0.7),
                                ],
                              )
                            : null,
                        color: _selectedPlan == null ? Colors.grey.shade400 : null,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: _selectedPlan != null
                            ? [
                                BoxShadow(
                                  color: _plans.firstWhere((p) => p.id == _selectedPlan).color.withOpacity(0.3),
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
                              'Start',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: _selectedPlan != null ? Colors.white : Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: _selectedPlan != null ? Colors.white : Colors.grey.shade600,
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
      },
    );
  }
}

/// 禁食方案数据
class _FastingPlan {
  final String id;
  final String name;
  final String description;
  final int hours;
  final Color color;

  _FastingPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.hours,
    required this.color,
  });
}

/// 禁食方案卡片
class _FastingPlanCard extends StatelessWidget {
  final _FastingPlan plan;
  final bool isSelected;
  final double progress;
  final VoidCallback onTap;

  const _FastingPlanCard({
    required this.plan,
    required this.isSelected,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? plan.color.withOpacity(0.15)
              : Color.lerp(Colors.white, plan.color.withOpacity(0.1), progress),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? plan.color : Color.lerp(Colors.transparent, plan.color.withOpacity(0.3), progress),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: plan.color.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // 极简时钟图标
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected ? plan.color : Color.lerp(Colors.grey.shade100, plan.color.withOpacity(0.2), progress),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomPaint(
                  size: const Size(32, 32),
                  painter: _MinimalClockPainter(
                    hours: plan.hours,
                    color: isSelected ? Colors.white : Color.lerp(Colors.grey.shade600, Colors.white, progress),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // 文字
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    plan.name,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: isSelected
                          ? plan.color
                          : Color.lerp(const Color(0xFF2D3748), Colors.white, progress),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    plan.description,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: isSelected
                          ? plan.color.withOpacity(0.7)
                          : Color.lerp(Colors.grey.shade600, Colors.white70, progress),
                    ),
                  ),
                ],
              ),
            ),

            // 选中指示
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? plan.color : Colors.transparent,
                border: Border.all(
                  color: isSelected ? plan.color : Color.lerp(Colors.grey.shade400, plan.color.withOpacity(0.5), progress),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// Canvas: 极简时钟
class _MinimalClockPainter extends CustomPainter {
  final int hours;
  final Color color;

  _MinimalClockPainter({required this.hours, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    // 表盘
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // 时针 (根据禁食小时数)
    final hourAngle = (hours / 12) * math.pi * 2 - math.pi / 2;
    final hourEnd = Offset(
      center.dx + radius * 0.5 * math.cos(hourAngle),
      center.dy + radius * 0.5 * math.sin(hourAngle),
    );
    canvas.drawLine(
      center,
      hourEnd,
      Paint()
        ..color = color
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    // 分针
    final minuteAngle = -math.pi / 2;
    final minuteEnd = Offset(
      center.dx + radius * 0.7 * math.cos(minuteAngle),
      center.dy + radius * 0.7 * math.sin(minuteAngle),
    );
    canvas.drawLine(
      center,
      minuteEnd,
      Paint()
        ..color = color
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );

    // 中心点
    canvas.drawCircle(center, 2, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _MinimalClockPainter oldDelegate) =>
      oldDelegate.hours != hours || oldDelegate.color != color;
}


/// ============================================
/// P35: Fasting Timer Screen
/// ============================================
class FastingTimerScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const FastingTimerScreen({super.key, required this.onComplete});

  @override
  State<FastingTimerScreen> createState() => _FastingTimerScreenState();
}

class _FastingTimerScreenState extends State<FastingTimerScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _pulseController;
  late AnimationController _bearController;
  late Animation<double> _waveAnim;
  late Animation<double> _pulseAnim;

  bool _isStarted = false;
  int _remainingSeconds = 16 * 60 * 60; // 16小时

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _waveAnim = Tween<double>(begin: 0, end: 1).animate(_waveController);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _bearController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    _bearController.dispose();
    super.dispose();
  }

  void _startFasting() {
    setState(() {
      _isStarted = true;
    });
    _waveController.repeat();

    // 开始倒计时
    _startCountdown();
  }

  void _startCountdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && _remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
        return true;
      }
      return false;
    });
  }

  String get _formattedTime {
    final hours = _remainingSeconds ~/ 3600;
    final minutes = (_remainingSeconds % 3600) ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isStarted ? const Color(0xFF1a2a3a) : const Color(0xFFEDF6FA),
      body: SafeArea(
        child: Column(
          children: [
            // 顶部
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: _isStarted ? Colors.white : const Color(0xFF2D3748),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  Text(
                    _isStarted ? 'Fasting in progress' : 'Start fasting',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: _isStarted ? Colors.white70 : const Color(0xFF2D3748),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // 主计时器
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: Listenable.merge([_waveAnim, _pulseAnim]),
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isStarted ? _pulseAnim.value : 1.0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 波纹背景
                          if (_isStarted)
                            CustomPaint(
                              size: const Size(320, 320),
                              painter: _WaveRipplePainter(
                                progress: _waveAnim.value,
                                color: const Color(0xFF4CAF50),
                              ),
                            ),

                          // 圆环
                          CustomPaint(
                            size: const Size(280, 280),
                            painter: _FastingRingPainter(
                              progress: _isStarted
                                  ? 1 - (_remainingSeconds / (16 * 60 * 60))
                                  : 0,
                              isStarted: _isStarted,
                            ),
                          ),

                          // 中心内容
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!_isStarted) ...[
                                // Canvas睡帽小熊
                                AnimatedBuilder(
                                  animation: _bearController,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(
                                        math.sin(_bearController.value * math.pi * 2) * 3,
                                        0,
                                      ),
                                      child: child,
                                    );
                                  },
                                  child: CustomPaint(
                                    size: const Size(80, 80),
                                    painter: _SleepingBearPainter(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'START FASTING',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                              ] else ...[
                                // 倒计时显示
                                Text(
                                  _formattedTime,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 42,
                                    color: Colors.white,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'hours remaining',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ],
                          ),

                          // 点击区域
                          if (!_isStarted)
                            Positioned.fill(
                              child: GestureDetector(
                                onTap: _startFasting,
                                behavior: HitTestBehavior.opaque,
                                child: Container(),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // 底部提示
            if (!_isStarted)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Tap the circle to begin your fasting journey',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Fasting mode active',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Canvas: 睡帽小熊
class _SleepingBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 5;

    // 睡帽
    final hatPath = Path();
    hatPath.moveTo(c.dx - r * 0.6, c.dy - r * 0.6);
    hatPath.quadraticBezierTo(c.dx - r * 0.3, c.dy - r * 1.3, c.dx, c.dy - r * 1.0);
    hatPath.quadraticBezierTo(c.dx + r * 0.3, c.dy - r * 1.3, c.dx + r * 0.6, c.dy - r * 0.6);
    hatPath.close();
    canvas.drawPath(hatPath, Paint()..color = const Color(0xFF4ECDC4));
    // 帽子绒球
    canvas.drawCircle(Offset(c.dx, c.dy - r * 1.15), r * 0.12, Paint()..color = const Color(0xFFFFE066));

    // 头
    canvas.drawCircle(c, r * 0.8, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.65, c.dy - r * 0.5), r * 0.2, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.65, c.dy - r * 0.5), r * 0.12, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.65, c.dy - r * 0.5), r * 0.2, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.65, c.dy - r * 0.5), r * 0.12, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.15), width: r * 0.9, height: r * 0.75),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 睡眠眼睛 (闭着)
    canvas.drawLine(
      Offset(c.dx - r * 0.35, c.dy - r * 0.05),
      Offset(c.dx - r * 0.15, c.dy - r * 0.05),
      Paint()..color = const Color(0xFF5D4037)..strokeWidth = 2..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(c.dx + r * 0.15, c.dy - r * 0.05),
      Offset(c.dx + r * 0.35, c.dy - r * 0.05),
      Paint()..color = const Color(0xFF5D4037)..strokeWidth = 2..strokeCap = StrokeCap.round,
    );

    // 睡眠Z动画
    _drawSleepZ(canvas, Offset(c.dx + r * 0.7, c.dy - r * 0.3), r * 0.15);
    _drawSleepZ(canvas, Offset(c.dx + r * 0.85, c.dy - r * 0.6), r * 0.1);

    // 微笑
    final smilePath = Path();
    smilePath.moveTo(c.dx - r * 0.12, c.dy + r * 0.25);
    smilePath.quadraticBezierTo(c.dx, c.dy + r * 0.38, c.dx + r * 0.12, c.dy + r * 0.25);
    canvas.drawPath(smilePath, Paint()..color = const Color(0xFF8B4513)..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round);

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.35, c.dy + r * 0.12), width: r * 0.18, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.35, c.dy + r * 0.12), width: r * 0.18, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6));
  }

  void _drawSleepZ(Canvas canvas, Offset center, double size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'z',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: size * 2,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF4ECDC4).withOpacity(0.7),
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

/// Canvas: 禁食圆环
class _FastingRingPainter extends CustomPainter {
  final double progress;
  final bool isStarted;

  _FastingRingPainter({required this.progress, required this.isStarted});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // 背景环
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = isStarted ? Colors.white.withOpacity(0.1) : Colors.grey.shade200
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12,
    );

    // 进度环
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        progress * math.pi * 2,
        false,
        Paint()
          ..color = const Color(0xFF4CAF50)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12
          ..strokeCap = StrokeCap.round,
      );
    }

    // 开始环 (虚线)
    if (!isStarted) {
      canvas.drawCircle(
        center,
        radius + 20,
        Paint()
          ..color = const Color(0xFF4CAF50).withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FastingRingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.isStarted != isStarted;
}

/// Canvas: 波纹扩散
class _WaveRipplePainter extends CustomPainter {
  final double progress;
  final Color color;

  _WaveRipplePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 绘制多层波纹
    for (int i = 0; i < 3; i++) {
      final waveProgress = (progress + i * 0.33) % 1.0;
      final radius = waveProgress * size.width / 2;
      final opacity = (1 - waveProgress) * 0.3;

      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = color.withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveRipplePainter oldDelegate) =>
      oldDelegate.progress != progress;
}


/// ============================================
/// P36: Water Tracker Screen
/// ============================================
class WaterTrackerScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const WaterTrackerScreen({super.key, required this.onComplete});

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  late Animation<double> _waveAnim;
  late Animation<double> _waveOffsetAnim;

  double _currentWater = 1.2; // L
  final double _goalWater = 2.5; // L

  final List<_WaterOption> _options = [
    _WaterOption(amount: 0.25, label: '250ml', icon: '🥛'),
    _WaterOption(amount: 0.5, label: '500ml', icon: '🥤'),
    _WaterOption(amount: 1.0, label: '1L', icon: '🍶'),
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _waveAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeOutBack),
    );
    _waveOffsetAnim = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _addWater(double amount) {
    setState(() {
      _currentWater = (_currentWater + amount).clamp(0.0, _goalWater * 1.5);
    });
    _waveController.reset();
    _waveController.forward();
  }

  double get _progress => (_currentWater / _goalWater).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Water',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF2D3748),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // 水量显示
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    '${_currentWater.toStringAsFixed(1)}L',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                      color: Color(0xFF64B5F6),
                    ),
                  ),
                  Text(
                    '/ ${_goalWater.toStringAsFixed(1)}L today',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 进度百分比
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF64B5F6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${(_progress * 100).toInt()}% of daily goal',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64B5F6),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 水波纹Canvas
            Expanded(
              child: AnimatedBuilder(
                animation: Listenable.merge([_waveAnim, _waveOffsetAnim]),
                builder: (context, child) {
                  return Stack(
                    children: [
                      // 水波纹背景
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _WaterWavePainter(
                            progress: _progress + _waveOffsetAnim.value,
                            wavePhase: _waveAnim.value,
                          ),
                        ),
                      ),

                      // 水滴图标
                      Center(
                        child: AnimatedBuilder(
                          animation: _waveAnim,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1 + _waveAnim.value * 0.2,
                              child: Opacity(
                                opacity: 1 - _waveAnim.value * 0.3,
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '💧',
                                style: TextStyle(
                                  fontSize: 64 * (0.5 + _progress * 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // 快速添加选项
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Quick add',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _options.map((option) {
                      return _WaterButton(
                        option: option,
                        onTap: () => _addWater(option.amount),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Next胶囊按钮
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: widget.onComplete,
                child: Container(
                  height: 56,
                  width: double.infinity,
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
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// 饮水选项
class _WaterOption {
  final double amount;
  final String label;
  final String icon;

  _WaterOption({required this.amount, required this.label, required this.icon});
}

/// 饮水按钮
class _WaterButton extends StatefulWidget {
  final _WaterOption option;
  final VoidCallback onTap;

  const _WaterButton({required this.option, required this.onTap});

  @override
  State<_WaterButton> createState() => _WaterButtonState();
}

class _WaterButtonState extends State<_WaterButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;
  late Animation<double> _rippleAnim;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _rippleAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        _rippleController.reset();
        _rippleController.forward();
      },
      child: AnimatedBuilder(
        animation: _rippleAnim,
        builder: (context, child) {
          return Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFF64B5F6).withOpacity(0.1 + _rippleAnim.value * 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF64B5F6).withOpacity(0.3 + _rippleAnim.value * 0.4),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.option.icon,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.option.label,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64B5F6),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Canvas: 水波纹
class _WaterWavePainter extends CustomPainter {
  final double progress;
  final double wavePhase;

  _WaterWavePainter({required this.progress, required this.wavePhase});

  @override
  void paint(Canvas canvas, Size size) {
    // 水位高度 (从底部开始)
    final waterHeight = size.height * progress;
    final waterTop = size.height - waterHeight;

    // 波浪路径
    final wavePath = Path();
    wavePath.moveTo(0, size.height);

    // 第一层波浪
    for (double x = 0; x <= size.width; x++) {
      final y = waterTop + math.sin((x / size.width * 2 * math.pi) + wavePhase * math.pi * 2) * 8;
      wavePath.lineTo(x, y);
    }

    wavePath.lineTo(size.width, size.height);
    wavePath.close();

    // 渐变
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF64B5F6).withOpacity(0.3),
        const Color(0xFF64B5F6).withOpacity(0.6),
        const Color(0xFF64B5F6).withOpacity(0.8),
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, waterTop, size.width, waterHeight));

    canvas.drawPath(wavePath, paint);

    // 第二层波浪 (叠加)
    final wavePath2 = Path();
    wavePath2.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y = waterTop + math.sin((x / size.width * 3 * math.pi) - wavePhase * math.pi * 2) * 5 + 3;
      wavePath2.lineTo(x, y);
    }

    wavePath2.lineTo(size.width, size.height);
    wavePath2.close();

    canvas.drawPath(
      wavePath2,
      Paint()
        ..color = const Color(0xFF64B5F6).withOpacity(0.2),
    );
  }

  @override
  bool shouldRepaint(covariant _WaterWavePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.wavePhase != wavePhase;
}


/// ============================================
/// P37: Water History Screen
/// ============================================
class WaterHistoryScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const WaterHistoryScreen({super.key, required this.onComplete});

  @override
  State<WaterHistoryScreen> createState() => _WaterHistoryScreenState();
}

class _WaterHistoryScreenState extends State<WaterHistoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  int? _selectedDay;
  String? _feedbackMessage;

  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<double> _waterData = [2.1, 1.8, 2.4, 1.9, 2.2, 1.5, 2.0];
  final double _goal = 2.5;

  final Map<String, String> _feedbacks = {
    'Mon': 'Great start on Monday! 💪',
    'Tue': 'Amazing work on Tuesday! 🌟',
    'Wed': 'Wonderful on Wednesday! 🎉',
    'Thu': 'Keep it up on Thursday! ✨',
    'Fri': 'Fantastic Friday effort! 🌈',
    'Sat': 'Super Saturday! 🏆',
    'Sun': 'Relaxing Sunday vibes! 🧘',
  };

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _selectDay(int index) {
    setState(() {
      _selectedDay = _selectedDay == index ? null : index;
      _feedbackMessage = _feedbacks[_days[index]];
    });
    _animController.reset();
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Water History',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF2D3748),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // 标题
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Weekly Water\nIntake',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    height: 1.1,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 小熊反馈
            AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                if (_selectedDay == null) return const SizedBox.shrink();
                final bounce = math.sin(_animController.value * math.pi * 2) * 5;
                return Transform.translate(
                  offset: Offset(0, bounce),
                  child: Opacity(
                    opacity: _animController.value,
                    child: child,
                  ),
                );
              },
              child: _selectedDay != null
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF64B5F6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          CustomPaint(
                            size: const Size(40, 40),
                            painter: _HappyWaterBearPainter(),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _feedbackMessage ?? '',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64B5F6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 24),

            // 柱状图
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size.infinite,
                      painter: _WaterBarChartPainter(
                        data: _waterData,
                        days: _days,
                        goal: _goal,
                        progress: _animController.value,
                        selectedDay: _selectedDay,
                        onBarTap: _selectDay,
                      ),
                    );
                  },
                ),
              ),
            ),

            // 图例
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF64B5F6),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Water intake',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Goal: ${_goal}L',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Next胶囊按钮
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: widget.onComplete,
                child: Container(
                  height: 56,
                  width: double.infinity,
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
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Canvas: 饮水柱状图
class _WaterBarChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> days;
  final double goal;
  final double progress;
  final int? selectedDay;
  final Function(int) onBarTap;

  _WaterBarChartPainter({
    required this.data,
    required this.days,
    required this.goal,
    required this.progress,
    required this.selectedDay,
    required this.onBarTap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = (size.width - 60) / data.length - 10;
    final maxValue = data.reduce((a, b) => a > b ? a : b) * 1.2;
    final chartHeight = size.height - 60;
    final chartBottom = size.height - 30;

    // 绘制目标线
    final goalY = chartBottom - (goal / maxValue) * chartHeight;
    final goalPaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeDashArray = [6, 4];

    canvas.drawLine(
      Offset(30, goalY),
      Offset(size.width - 10, goalY),
      goalPaint,
    );

    // 绘制柱子
    for (int i = 0; i < data.length; i++) {
      final barHeight = (data[i] / maxValue) * chartHeight * progress;
      final x = 35 + i * ((size.width - 60) / data.length) + 5;
      final y = chartBottom - barHeight;

      final isSelected = selectedDay == i;
      final isAboveGoal = data[i] >= goal;

      // 柱子颜色
      Color barColor;
      if (isSelected) {
        barColor = const Color(0xFF64B5F6);
      } else if (isAboveGoal) {
        barColor = const Color(0xFF64B5F6).withOpacity(0.7);
      } else {
        barColor = const Color(0xFF64B5F6).withOpacity(0.4);
      }

      // 绘制圆角矩形柱子
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        topLeft: const Radius.circular(8),
        topRight: const Radius.circular(8),
      );

      // 渐变
      final gradientPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            barColor,
            barColor.withOpacity(0.6),
          ],
        ).createShader(Rect.fromLTWH(x, y, barWidth, barHeight));

      canvas.drawRRect(rect, gradientPaint);

      // 选中时的边框
      if (isSelected) {
        canvas.drawRRect(
          rect,
          Paint()
            ..color = const Color(0xFF64B5F6)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }

      // 数值标签
      if (isSelected) {
        final valuePainter = TextPainter(
          text: TextSpan(
            text: '${data[i]}L',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64B5F6),
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        valuePainter.layout();
        valuePainter.paint(
          canvas,
          Offset(x + barWidth / 2 - valuePainter.width / 2, y - 20),
        );
      }

      // X轴标签
      final dayPainter = TextPainter(
        text: TextSpan(
          text: days[i],
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: isSelected ? const Color(0xFF64B5F6) : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      dayPainter.layout();
      dayPainter.paint(
        canvas,
        Offset(x + barWidth / 2 - dayPainter.width / 2, chartBottom + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaterBarChartPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.selectedDay != selectedDay;
}

/// Canvas: 开心饮水小熊
class _HappyWaterBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 3;

    // 头
    canvas.drawCircle(c, r * 0.85, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.6), r * 0.22, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.6), r * 0.12, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.6), r * 0.22, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.6), r * 0.12, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.15), width: r * 0.9, height: r * 0.8),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 开心眯眼
    _drawHappyEye(canvas, Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.12);
    _drawHappyEye(canvas, Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.12);

    // 开心嘴
    final smilePath = Path();
    smilePath.moveTo(c.dx - r * 0.15, c.dy + r * 0.25);
    smilePath.quadraticBezierTo(c.dx, c.dy + r * 0.4, c.dx + r * 0.15, c.dy + r * 0.25);
    canvas.drawPath(smilePath, Paint()..color = const Color(0xFF8B4513)..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round);

    // 水滴
    _drawWaterDrop(canvas, Offset(c.dx + r * 0.8, c.dy - r * 0.3), r * 0.15);

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.38, c.dy + r * 0.12), width: r * 0.18, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.38, c.dy + r * 0.12), width: r * 0.18, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6));
  }

  void _drawHappyEye(Canvas canvas, Offset center, double size) {
    final paint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final path = Path();
    path.moveTo(center.dx - size, center.dy);
    path.quadraticBezierTo(center.dx, center.dy - size * 0.6, center.dx + size, center.dy);
    canvas.drawPath(path, paint);
  }

  void _drawWaterDrop(Canvas canvas, Offset center, double size) {
    final paint = Paint()..color = const Color(0xFF64B5F6);
    final path = Path();
    path.moveTo(center.dx, center.dy - size);
    path.quadraticBezierTo(center.dx - size, center.dy, center.dx, center.dy + size * 0.8);
    path.quadraticBezierTo(center.dx + size, center.dy, center.dx, center.dy - size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


/// ============================================
/// P38: Achievements Screen
/// ============================================
class AchievementsScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const AchievementsScreen({super.key, required this.onComplete});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  int? _selectedAchievement;

  final List<_Achievement> _achievements = [
    _Achievement(id: 0, icon: '🏆', name: 'First Step', unlocked: true, color: const Color(0xFFFFD700)),
    _Achievement(id: 1, icon: '🔥', name: '7 Day Streak', unlocked: true, color: const Color(0xFFFF6B6B)),
    _Achievement(id: 2, icon: '💧', name: 'Hydration Hero', unlocked: true, color: const Color(0xFF64B5F6)),
    _Achievement(id: 3, icon: '🥗', name: 'Healthy Eater', unlocked: true, color: const Color(0xFF4ECDC4)),
    _Achievement(id: 4, icon: '⏰', name: 'Early Bird', unlocked: true, color: const Color(0xFFFFE066)),
    _Achievement(id: 5, icon: '📊', name: 'Data Master', unlocked: false, color: const Color(0xFF9B59B6)),
    _Achievement(id: 6, icon: '🎯', name: 'Goal Crusher', unlocked: false, color: const Color(0xFFE67E22)),
    _Achievement(id: 7, icon: '💪', name: 'Fitness Pro', unlocked: false, color: const Color(0xFF4CAF50)),
    _Achievement(id: 8, icon: '⭐', name: 'Super Star', unlocked: false, color: const Color(0xFFDDA0DD)),
  ];

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  void _tapAchievement(int id) {
    final achievement = _achievements[id];
    if (achievement.unlocked) {
      setState(() {
        _selectedAchievement = _selectedAchievement == id ? null : id;
      });
      if (_selectedAchievement != null) {
        _particleController.reset();
        _particleController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 标题
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your\nAchievements',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    height: 1.1,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text(
                    '${_achievements.where((a) => a.unlocked).length}/${_achievements.length} unlocked',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 勋章网格
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Stack(
                  children: [
                    GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: _achievements.length,
                      itemBuilder: (context, index) {
                        final achievement = _achievements[index];
                        final isSelected = _selectedAchievement == index;
                        return _AchievementCard(
                          achievement: achievement,
                          isSelected: isSelected,
                          onTap: () => _tapAchievement(index),
                        );
                      },
                    ),

                    // 心形粒子特效
                    if (_selectedAchievement != null)
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: _particleController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: _HeartFountainPainter(
                                progress: _particleController.value,
                                color: _achievements[_selectedAchievement!].color,
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Next胶囊按钮
            Padding(
              padding: const EdgeInsets.all(24),
              child: GestureDetector(
                onTap: widget.onComplete,
                child: Container(
                  height: 56,
                  width: double.infinity,
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
            ),
          ],
        ),
      ),
    );
  }
}

/// 成就数据
class _Achievement {
  final int id;
  final String icon;
  final String name;
  final bool unlocked;
  final Color color;

  _Achievement({
    required this.id,
    required this.icon,
    required this.name,
    required this.unlocked,
    required this.color,
  });
}

/// 成就卡片
class _AchievementCard extends StatelessWidget {
  final _Achievement achievement;
  final bool isSelected;
  final VoidCallback onTap;

  const _AchievementCard({
    required this.achievement,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: achievement.unlocked
              ? achievement.color.withOpacity(0.15)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? achievement.color
                : achievement.unlocked
                    ? achievement.color.withOpacity(0.3)
                    : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: achievement.color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 磨砂玻璃效果
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: achievement.unlocked
                    ? Colors.white.withOpacity(0.8)
                    : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: achievement.unlocked
                    ? Text(
                        achievement.icon,
                        style: const TextStyle(fontSize: 28),
                      )
                    : Icon(
                        Icons.lock,
                        color: Colors.grey.shade500,
                        size: 24,
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              achievement.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: achievement.unlocked
                    ? const Color(0xFF2D3748)
                    : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Canvas: 心形喷泉
class _HeartFountainPainter extends CustomPainter {
  final double progress;
  final Color color;

  _HeartFountainPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.8);
    final random = math.Random(42);

    for (int i = 0; i < 20; i++) {
      final seed = random.nextDouble();
      final angle = (seed - 0.5) * math.pi * 0.8 - math.pi / 2;
      final speed = 50 + random.nextDouble() * 100;

      final x = center.dx + math.cos(angle) * speed * progress;
      final y = center.dy + math.sin(angle) * speed * progress - 100 * progress * progress;
      final opacity = (1 - progress) * (0.5 + random.nextDouble() * 0.5);
      final heartSize = 6.0 + random.nextDouble() * 8;

      _drawHeart(canvas, Offset(x, y), heartSize, color.withOpacity(opacity));
    }
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(center.dx, center.dy + size * 0.3);
    path.cubicTo(
      center.dx - size * 1.2, center.dy - size * 0.3,
      center.dx - size * 1.2, center.dy - size * 1.2,
      center.dx, center.dy - size * 0.3,
    );
    path.cubicTo(
      center.dx + size * 1.2, center.dy - size * 1.2,
      center.dx + size * 1.2, center.dy - size * 0.3,
      center.dx, center.dy + size * 0.3,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HeartFountainPainter oldDelegate) =>
      oldDelegate.progress != progress;
}


/// ============================================
/// P39: Profile Core Data Screen
/// ============================================
class ProfileScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const ProfileScreen({super.key, required this.onComplete});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // 从UserMetrics获取数据
  double get _height => UserMetrics.height ?? 170.0;
  double get _weight => UserMetrics.weight ?? 65.0;
  
  // BMI计算
  double get _bmi {
    final heightM = _height / 100;
    return _weight / (heightM * heightM);
  }
  
  String get _bmiCategory {
    if (_bmi < 18.5) return 'Underweight';
    if (_bmi < 24.9) return 'Normal';
    if (_bmi < 29.9) return 'Overweight';
    return 'Obese';
  }
  
  Color get _bmiColor {
    if (_bmi < 18.5) return const Color(0xFFFFE066);
    if (_bmi < 24.9) return const Color(0xFF4CAF50);
    if (_bmi < 29.9) return const Color(0xFFFF6B6B);
    return const Color(0xFFFF6B6B);
  }

  // 连续打卡天数 (模拟)
  final int _streakDays = 15;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // 标题
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // 用户头像
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4ECDC4), Color(0xFF6DD5C4)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4ECDC4).withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  UserMetrics.gender == 'male' ? 'Colvin' : 'Colvin',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Color(0xFF2D3748),
                  ),
                ),

                const SizedBox(height: 32),

                // 核心数据卡片
                Row(
                  children: [
                    Expanded(
                      child: _DataCard(
                        title: 'BMI',
                        value: _bmi.toStringAsFixed(1),
                        subtitle: _bmiCategory,
                        color: _bmiColor,
                        icon: '📊',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _DataCard(
                        title: 'Streak',
                        value: '$_streakDays',
                        subtitle: 'days',
                        color: const Color(0xFFFF6B6B),
                        icon: '🔥',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 健康报告入口
                GestureDetector(
                  onTap: () {
                    // 切回P22预测曲线页
                    _goToPage(21); // P22 is index 21
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF4CAF50).withOpacity(0.1),
                          const Color(0xFF8BC34A).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF4CAF50).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text('📋', style: TextStyle(fontSize: 24)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Health Report',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'View your detailed progress',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey.shade400,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 用户详情列表
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _ProfileListItem(
                        icon: '📏',
                        title: 'Height',
                        value: '${_height.toStringAsFixed(0)} cm',
                        color: const Color(0xFF64B5F6),
                      ),
                      Divider(color: Colors.grey.shade200, height: 1),
                      _ProfileListItem(
                        icon: '⚖️',
                        title: 'Weight',
                        value: '${_weight.toStringAsFixed(1)} kg',
                        color: const Color(0xFF4ECDC4),
                      ),
                      Divider(color: Colors.grey.shade200, height: 1),
                      _ProfileListItem(
                        icon: '🎂',
                        title: 'Age',
                        value: '${UserMetrics.age ?? 25} years',
                        color: const Color(0xFFFFE066),
                      ),
                      Divider(color: Colors.grey.shade200, height: 1),
                      _ProfileListItem(
                        icon: '🎯',
                        title: 'Goal',
                        value: '${UserMetrics.goalWeight?.toStringAsFixed(1) ?? '65.0'} kg',
                        color: const Color(0xFFFF6B6B),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Settings胶囊按钮
                GestureDetector(
                  onTap: widget.onComplete,
                  child: Container(
                    height: 56,
                    width: double.infinity,
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
                          Icon(Icons.settings, color: Colors.white, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Settings',
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

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goToPage(int pageIndex) {
    // 找到PageController并跳转
    // 简化处理：直接调用onComplete多次
    for (int i = 0; i < 46 - pageIndex - 1; i++) {
      // 向上跳转需要负向
    }
    // 直接返回主页
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

/// 数据卡片
class _DataCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final String icon;

  const _DataCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// 列表项
class _ProfileListItem extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final Color color;

  const _ProfileListItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Color(0xFF2D3748),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }
}


/// ============================================
/// P40: Settings Screen
/// ============================================
class SettingsScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const SettingsScreen({super.key, required this.onComplete});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  bool _notifications = true;
  bool _unitKg = true; // kg=true, lb=false
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // SharedPreferences would load here in production
    // For demo, using default values
  }

  Future<void> _saveSettings() async {
    // SharedPreferences would save here in production
  }

  void _toggle(int index) {
    setState(() {
      switch (index) {
        case 0:
          _notifications = !_notifications;
          break;
        case 1:
          _unitKg = !_unitKg;
          break;
        case 2:
          _darkMode = !_darkMode;
          break;
      }
    });
    _saveSettings();
    // 系统级震动反馈
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF2D3748),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              const SizedBox(height: 16),

              // 标题
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'System\nSettings',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      height: 1.1,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // 设置列表
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _SettingsToggleItem(
                        icon: '🔔',
                        title: 'Notifications',
                        subtitle: 'Meal & water reminders',
                        value: _notifications,
                        onToggle: () => _toggle(0),
                        index: 0,
                      ),
                      Divider(color: Colors.grey.shade200, height: 1, indent: 70),
                      _SettingsToggleItem(
                        icon: '⚖️',
                        title: 'Unit',
                        subtitle: _unitKg ? 'Kilograms (kg)' : 'Pounds (lb)',
                        value: _unitKg,
                        onToggle: () => _toggle(1),
                        index: 1,
                        showUnitLabel: true,
                      ),
                      Divider(color: Colors.grey.shade200, height: 1, indent: 70),
                      _SettingsToggleItem(
                        icon: '🌙',
                        title: 'Dark Mode',
                        subtitle: 'Easier on the eyes',
                        value: _darkMode,
                        onToggle: () => _toggle(2),
                        index: 2,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 小熊插画
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(60, 60),
                      painter: _SettingsBearPainter(),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Customize your\nexperience!',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Next胶囊按钮
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GestureDetector(
                  onTap: widget.onComplete,
                  child: Container(
                    height: 56,
                    width: double.infinity,
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
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// 设置开关项
class _SettingsToggleItem extends StatefulWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool value;
  final VoidCallback onToggle;
  final int index;
  final bool showUnitLabel;

  const _SettingsToggleItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onToggle,
    required this.index,
    this.showUnitLabel = false,
  });

  @override
  State<_SettingsToggleItem> createState() => _SettingsToggleItemState();
}

class _SettingsToggleItemState extends State<_SettingsToggleItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(
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
    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onToggle();
        },
        onTapCancel: () => _controller.reverse(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF4ECDC4).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    widget.icon,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // 单位标签 (kg/lb)
              if (widget.showUnitLabel)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ECDC4).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.value ? 'kg' : 'lb',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4ECDC4),
                    ),
                  ),
                ),
              // 开关
              _CustomSwitch(value: widget.value),
            ],
          ),
        ),
      ),
    );
  }
}

/// 自定义开关
class _CustomSwitch extends StatefulWidget {
  final bool value;

  const _CustomSwitch({required this.value});

  @override
  State<_CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<_CustomSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnim;
  late Animation<Color?> _colorAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _slideAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _colorAnim = ColorTween(
      begin: Colors.grey.shade300,
      end: const Color(0xFF4CAF50),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    
    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_CustomSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
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
        return Container(
          width: 52,
          height: 30,
          decoration: BoxDecoration(
            color: _colorAnim.value,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 3 + _slideAnim.value * 22,
                top: 3,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Canvas: 设置小熊
class _SettingsBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 3;

    // 头
    canvas.drawCircle(c, r * 0.85, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.6), r * 0.22, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.6), r * 0.12, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.6), r * 0.22, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.6), r * 0.12, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.15), width: r * 0.9, height: r * 0.8),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 眼睛
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.1, Paint()..color = const Color(0xFF5D4037));
    canvas.drawCircle(Offset(c.dx - r * 0.26, c.dy - r * 0.08), r * 0.04, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.1, Paint()..color = const Color(0xFF5D4037));
    canvas.drawCircle(Offset(c.dx + r * 0.3, c.dy - r * 0.08), r * 0.04, Paint()..color = Colors.white);

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.38, c.dy + r * 0.12), width: r * 0.18, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.38, c.dy + r * 0.12), width: r * 0.18, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));

    // 微笑
    final smilePath = Path();
    smilePath.moveTo(c.dx - r * 0.15, c.dy + r * 0.25);
    smilePath.quadraticBezierTo(c.dx, c.dy + r * 0.4, c.dx + r * 0.15, c.dy + r * 0.25);
    canvas.drawPath(smilePath, Paint()..color = const Color(0xFF8B4513)..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


/// ============================================
/// P41: Goal Reached Screen
/// ============================================
class GoalReachedScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const GoalReachedScreen({super.key, required this.onComplete});

  @override
  State<GoalReachedScreen> createState() => _GoalReachedScreenState();
}

class _GoalReachedScreenState extends State<GoalReachedScreen>
    with TickerProviderStateMixin {
  late AnimationController _bearController;
  late AnimationController _confettiController;
  late Animation<double> _bearBounce;
  late Animation<double> _bearScale;
  late Animation<double> _confettiAnim;

  // 模拟数据
  final int _caloriesGoal = 1850;
  final int _caloriesActual = 1850;
  final double _waterGoal = 2.5;
  final double _waterActual = 2.5;

  @override
  void initState() {
    super.initState();

    // 小熊欢呼动画
    _bearController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _bearBounce = Tween<double>(begin: 0, end: 15).animate(
      CurvedAnimation(parent: _bearController, curve: Curves.easeInOut),
    );

    _bearScale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _bearController, curve: Curves.elasticOut),
    );

    // Confetti动画
    _confettiController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();

    _confettiAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _confettiController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _bearController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      body: Stack(
        children: [
          // 莫奈色渐变背景
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFF8E7), // 淡黄
                  Color(0xFFE8F5E9), // 淡绿
                  Color(0xFFE3F2FD), // 淡蓝
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 32),

                // 标题
                const Text(
                  '🎉 Daily Goal Reached! 🎉',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Color(0xFF2D3748),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Amazing work today!',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 32),

                // 达标卡片
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // 卡路里达标
                      _GoalCard(
                        emoji: '🔥',
                        title: 'Calories',
                        current: _caloriesActual,
                        goal: _caloriesGoal,
                        unit: 'kcal',
                        color: const Color(0xFFFF6B6B),
                        progress: _caloriesActual / _caloriesGoal,
                      ),

                      const SizedBox(height: 16),

                      // 饮水达标
                      _GoalCard(
                        emoji: '💧',
                        title: 'Water',
                        current: _waterActual,
                        goal: _waterGoal,
                        unit: 'L',
                        color: const Color(0xFF64B5F6),
                        progress: _waterActual / _waterGoal,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Canvas小熊欢呼动画
                AnimatedBuilder(
                  animation: _bearController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -_bearBounce.value),
                      child: Transform.scale(
                        scale: _bearScale.value,
                        alignment: Alignment.bottomCenter,
                        child: CustomPaint(
                          size: const Size(120, 120),
                          painter: _CelebratingBearPainter(
                            waveProgress: _bearController.value,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // 鼓励语
                Text(
                  'You\'re unstoppable! 🌟',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF6B6B),
                  ),
                ),

                const Spacer(),

                // Next胶囊按钮
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: GestureDetector(
                    onTap: widget.onComplete,
                    child: Container(
                      height: 56,
                      width: double.infinity,
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
                ),
              ],
            ),
          ),

          // 全屏Confetti
          AnimatedBuilder(
            animation: _confettiAnim,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: _MonetConfettiPainter(progress: _confettiAnim.value),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// 达标卡片
class _GoalCard extends StatelessWidget {
  final String emoji;
  final String title;
  final num current;
  final num goal;
  final String unit;
  final Color color;
  final double progress;

  const _GoalCard({
    required this.emoji,
    required this.title,
    required this.current,
    required this.goal,
    required this.unit,
    required this.color,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              // 勾选标记
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 数值
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${unit == 'kcal' ? current.toStringAsFixed(0) : current.toStringAsFixed(1)}',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  color: color,
                ),
              ),
              Text(
                ' / ${unit == 'kcal' ? goal.toStringAsFixed(0) : goal.toStringAsFixed(1)} $unit',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 进度条
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

/// Canvas: 欢呼小熊
class _CelebratingBearPainter extends CustomPainter {
  final double waveProgress;

  _CelebratingBearPainter({required this.waveProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 3;

    // 身体
    final bodyPath = Path();
    bodyPath.addOval(Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.3), width: r * 1.2, height: r * 1.0));
    canvas.drawPath(bodyPath, Paint()..color = const Color(0xFFD4A574));

    // 头
    canvas.drawCircle(c, r * 0.85, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.6), r * 0.22, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.6), r * 0.12, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.6), r * 0.22, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.6), r * 0.12, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.15), width: r * 0.9, height: r * 0.8),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 欢呼手臂 (左右摇摆)
    final armWave = math.sin(waveProgress * math.pi * 2) * 0.3;
    
    // 左臂
    canvas.save();
    canvas.translate(c.dx - r * 0.8, c.dy);
    canvas.rotate(-0.5 + armWave);
    canvas.drawOval(Rect.fromCenter(center: Offset(0, -r * 0.3), width: r * 0.4, height: r * 0.7), Paint()..color = const Color(0xFFD4A574));
    canvas.restore();

    // 右臂
    canvas.save();
    canvas.translate(c.dx + r * 0.8, c.dy);
    canvas.rotate(0.5 - armWave);
    canvas.drawOval(Rect.fromCenter(center: Offset(0, -r * 0.3), width: r * 0.4, height: r * 0.7), Paint()..color = const Color(0xFFD4A574));
    canvas.restore();

    // 开心眼睛 (眯眼笑)
    final eyeY = c.dy - r * 0.05;
    _drawHappyEye(canvas, Offset(c.dx - r * 0.28, eyeY), r * 0.12);
    _drawHappyEye(canvas, Offset(c.dx + r * 0.28, eyeY), r * 0.12);

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.38, c.dy + r * 0.12), width: r * 0.18, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.38, c.dy + r * 0.12), width: r * 0.18, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.6));

    // 张嘴大笑
    final mouthPath = Path();
    mouthPath.moveTo(c.dx - r * 0.2, c.dy + r * 0.25);
    mouthPath.quadraticBezierTo(c.dx, c.dy + r * 0.5, c.dx + r * 0.2, c.dy + r * 0.25);
    mouthPath.quadraticBezierTo(c.dx, c.dy + r * 0.35, c.dx - r * 0.2, c.dy + r * 0.25);
    canvas.drawPath(mouthPath, Paint()..color = const Color(0xFFFF6B6B));

    // 星星装饰
    _drawStar(canvas, Offset(c.dx - r * 1.2, c.dy - r * 0.5), 8, const Color(0xFFFFD700));
    _drawStar(canvas, Offset(c.dx + r * 1.2, c.dy - r * 0.8), 6, const Color(0xFFFFD700));
    _drawStar(canvas, Offset(c.dx - r * 0.5, c.dy - r * 1.2), 5, const Color(0xFFFFD700));
  }

  void _drawHappyEye(Canvas canvas, Offset center, double size) {
    final paint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final path = Path();
    path.moveTo(center.dx - size, center.dy);
    path.quadraticBezierTo(center.dx, center.dy - size * 0.6, center.dx + size, center.dy);
    canvas.drawPath(path, paint);
  }

  void _drawStar(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()..color = color;
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 144 - 90) * math.pi / 180;
      final x = center.dx + math.cos(angle) * size;
      final y = center.dy + math.sin(angle) * size;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CelebratingBearPainter oldDelegate) =>
      oldDelegate.waveProgress != waveProgress;
}

/// Canvas: 莫奈彩纸
class _MonetConfettiPainter extends CustomPainter {
  final double progress;
  final math.Random _random = math.Random(42);

  // 莫奈色系
  static const _colors = [
    Color(0xFFFF6B6B), // 红
    Color(0xFFFFE066), // 黄
    Color(0xFF4ECDC4), // 青
    Color(0xFF64B5F6), // 蓝
    Color(0xFFDDA0DD), // 紫
    Color(0xFFFFB5B5), // 粉
    Color(0xFF8BC34A), // 绿
  ];

  _MonetConfettiPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 60; i++) {
      final seed = _random.nextDouble();
      final startX = _random.nextDouble() * size.width;
      final startY = -20.0 - _random.nextDouble() * 100;
      final endY = size.height + 50;

      final x = startX + math.sin(seed * 10 + progress * 5) * 30;
      final y = startY + (endY - startY) * progress + _random.nextDouble() * 50 * progress;
      final opacity = (1 - progress).clamp(0.0, 1.0);
      final color = _colors[_random.nextInt(_colors.length)].withOpacity(opacity);
      final shapeSize = 4.0 + _random.nextDouble() * 8;

      // 旋转
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(progress * math.pi * 2 + seed * 10);

      final paint = Paint()..color = color;
      final shapeType = _random.nextInt(4);

      switch (shapeType) {
        case 0: // 圆形
          canvas.drawCircle(Offset.zero, shapeSize / 2, paint);
          break;
        case 1: // 矩形
          canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: shapeSize, height: shapeSize * 0.6), paint);
          break;
        case 2: // 三角形
          final path = Path();
          path.moveTo(0, -shapeSize / 2);
          path.lineTo(-shapeSize / 2, shapeSize / 2);
          path.lineTo(shapeSize / 2, shapeSize / 2);
          path.close();
          canvas.drawPath(path, paint);
          break;
        case 3: // 椭圆
          canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: shapeSize, height: shapeSize * 0.5), paint);
          break;
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _MonetConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}


/// ============================================
/// P42: Dressing Room Screen
/// ============================================
class DressingRoomScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const DressingRoomScreen({super.key, required this.onComplete});

  @override
  State<DressingRoomScreen> createState() => _DressingRoomScreenState();
}

class _DressingRoomScreenState extends State<DressingRoomScreen>
    with TickerProviderStateMixin {
  late AnimationController _spinController;
  late Animation<double> _spinAnim;
  late AnimationController _breatheController;

  String? _selectedItem;

  final List<_CostumeItem> _costumes = [
    _CostumeItem(id: 'hat', emoji: '🎩', name: 'Top Hat'),
    _CostumeItem(id: 'bowtie', emoji: '🎀', name: 'Bow Tie'),
    _CostumeItem(id: 'sunglasses', emoji: '🕶️', name: 'Sunglasses'),
    _CostumeItem(id: 'scarf', emoji: '🧣', name: 'Scarf'),
    _CostumeItem(id: 'crown', emoji: '👑', name: 'Crown'),
    _CostumeItem(id: 'flower', emoji: '🌸', name: 'Flower'),
    _CostumeItem(id: 'bow', emoji: '🎗️', name: 'Bow'),
    _CostumeItem(id: 'star', emoji: '⭐', name: 'Star'),
  ];

  Color _auraColor = const Color(0xFF4ECDC4);

  final Map<String, Color> _auraColors = {
    'hat': const Color(0xFF8B7355), // 棕色
    'bowtie': const Color(0xFFFF6B6B), // 红色
    'sunglasses': const Color(0xFF2D3436), // 黑色
    'scarf': const Color(0xFFE67E22), // 橙色
    'crown': const Color(0xFFFFD700), // 金色
    'flower': const Color(0xFFFFB5E8), // 粉色
    'bow': const Color(0xFFDDA0DD), // 紫色
    'star': const Color(0xFFFFE066), // 黄色
  };

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _spinAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _spinController, curve: Curves.easeInOut),
    );
    _spinController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _spinController.reset();
      }
    });

    _breatheController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _spinController.dispose();
    _breatheController.dispose();
    super.dispose();
  }

  void _selectCostume(String id) {
    setState(() {
      _selectedItem = _selectedItem == id ? null : id;
      _auraColor = _auraColors[id] ?? const Color(0xFF4ECDC4);
    });
    _spinController.reset();
    _spinController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _auraColor.withOpacity(0.2),
              const Color(0xFFEDF6FA),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 标题
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Aura-Pet\nDressing Room',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      height: 1.1,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                _selectedItem != null
                    ? 'Looking fabulous! ✨'
                    : 'Tap to dress up your pet!',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),

              const Spacer(),

              // Canvas小熊换装
              AnimatedBuilder(
                animation: Listenable.merge([_spinAnim, _breatheController]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1 + _breatheController.value * 0.03,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_spinAnim.value * math.pi * 2),
                      child: CustomPaint(
                        size: const Size(180, 180),
                        painter: _DressedBearPainter(
                          costume: _selectedItem,
                          breathePhase: _breatheController.value,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // 当前装扮名称
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: _selectedItem != null
                      ? _auraColor.withOpacity(0.15)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _selectedItem != null
                      ? _costumes.firstWhere((c) => c.id == _selectedItem).name
                      : 'No costume selected',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: _selectedItem != null ? _auraColor : Colors.grey,
                  ),
                ),
              ),

              const Spacer(),

              // 装备栏
              Container(
                height: 120,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _costumes.length,
                  itemBuilder: (context, index) {
                    final costume = _costumes[index];
                    final isSelected = _selectedItem == costume.id;
                    return _CostumeCard(
                      costume: costume,
                      isSelected: isSelected,
                      onTap: () => _selectCostume(costume.id),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Next胶囊按钮
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GestureDetector(
                  onTap: widget.onComplete,
                  child: Container(
                    height: 56,
                    width: double.infinity,
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
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// 装扮数据
class _CostumeItem {
  final String id;
  final String emoji;
  final String name;

  _CostumeItem({required this.id, required this.emoji, required this.name});
}

/// 装扮卡片
class _CostumeCard extends StatefulWidget {
  final _CostumeItem costume;
  final bool isSelected;
  final VoidCallback onTap;

  const _CostumeCard({
    required this.costume,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CostumeCard> createState() => _CostumeCardState();
}

class _CostumeCardState extends State<_CostumeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(_CostumeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 80,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? const Color(0xFF4ECDC4).withOpacity(0.2)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected
                  ? const Color(0xFF4ECDC4)
                  : Colors.grey.shade200,
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF4ECDC4).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.costume.emoji,
                style: TextStyle(
                  fontSize: widget.isSelected ? 32 : 28,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.costume.name,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  color: widget.isSelected
                      ? const Color(0xFF4ECDC4)
                      : Colors.grey.shade600,
                  fontWeight:
                      widget.isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Canvas: 换装小熊
class _DressedBearPainter extends CustomPainter {
  final String? costume;
  final double breathePhase;

  _DressedBearPainter({required this.costume, required this.breathePhase});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 3;

    // Aura光晕
    _drawAura(canvas, c, r);

    // 身体
    final bodyPath = Path();
    bodyPath.addOval(Rect.fromCenter(
      center: Offset(c.dx, c.dy + r * 0.4),
      width: r * 1.4,
      height: r * 1.2,
    ));
    canvas.drawPath(bodyPath, Paint()..color = const Color(0xFFD4A574));

    // 头部
    canvas.drawCircle(c, r * 0.85, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.6), r * 0.22, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.6), r * 0.12, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.6), r * 0.22, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.6), r * 0.12, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(c.dx, c.dy + r * 0.15),
        width: r * 0.9,
        height: r * 0.8,
      ),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 装扮绘制
    if (costume != null) {
      _drawCostume(canvas, c, r);
    }

    // 眼睛
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.1, Paint()..color = const Color(0xFF5D4037));
    canvas.drawCircle(Offset(c.dx - r * 0.26, c.dy - r * 0.08), r * 0.04, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.1, Paint()..color = const Color(0xFF5D4037));
    canvas.drawCircle(Offset(c.dx + r * 0.3, c.dy - r * 0.08), r * 0.04, Paint()..color = Colors.white);

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.38, c.dy + r * 0.12), width: r * 0.18, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.38, c.dy + r * 0.12), width: r * 0.18, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));

    // 微笑
    final smilePath = Path();
    smilePath.moveTo(c.dx - r * 0.15, c.dy + r * 0.25);
    smilePath.quadraticBezierTo(c.dx, c.dy + r * 0.4, c.dx + r * 0.15, c.dy + r * 0.25);
    canvas.drawPath(smilePath, Paint()..color = const Color(0xFF8B4513)..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round);
  }

  void _drawAura(Canvas canvas, Offset c, double r) {
    final breathe = math.sin(breathePhase * math.pi * 2) * 0.1 + 0.9;
    final auraPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF4ECDC4).withOpacity(0.3 * breathe),
          const Color(0xFF4ECDC4).withOpacity(0.1 * breathe),
          const Color(0xFF4ECDC4).withOpacity(0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: c, radius: r * 1.5));
    canvas.drawCircle(c, r * 1.5 * breathe, auraPaint);
  }

  void _drawCostume(Canvas canvas, Offset c, double r) {
    switch (costume) {
      case 'hat': // 礼帽
        canvas.drawRect(
          Rect.fromLTWH(c.dx - r * 0.4, c.dy - r * 1.2, r * 0.8, r * 0.15),
          Paint()..color = const Color(0xFF2D3436),
        );
        canvas.drawRect(
          Rect.fromLTWH(c.dx - r * 0.25, c.dy - r * 1.8, r * 0.5, r * 0.6),
          Paint()..color = const Color(0xFF2D3436),
        );
        // 帽子缎带
        canvas.drawRect(
          Rect.fromLTWH(c.dx - r * 0.25, c.dy - r * 1.25, r * 0.5, r * 0.08),
          Paint()..color = const Color(0xFFFF6B6B),
        );
        break;

      case 'bowtie': // 领结
        final bowPath = Path();
        bowPath.moveTo(c.dx - r * 0.1, c.dy + r * 0.5);
        bowPath.quadraticBezierTo(c.dx - r * 0.4, c.dy + r * 0.35, c.dx - r * 0.5, c.dy + r * 0.5);
        bowPath.quadraticBezierTo(c.dx - r * 0.4, c.dy + r * 0.65, c.dx - r * 0.1, c.dy + r * 0.5);
        bowPath.moveTo(c.dx + r * 0.1, c.dy + r * 0.5);
        bowPath.quadraticBezierTo(c.dx + r * 0.4, c.dy + r * 0.35, c.dx + r * 0.5, c.dy + r * 0.5);
        bowPath.quadraticBezierTo(c.dx + r * 0.4, c.dy + r * 0.65, c.dx + r * 0.1, c.dy + r * 0.5);
        canvas.drawPath(bowPath, Paint()..color = const Color(0xFFFF6B6B));
        // 中心圆
        canvas.drawCircle(Offset(c.dx, c.dy + r * 0.5), r * 0.08, Paint()..color = const Color(0xFFFF6B6B));
        break;

      case 'sunglasses': // 墨镜
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(c.dx - r * 0.55, c.dy - r * 0.2, r * 0.4, r * 0.25),
            Radius.circular(r * 0.05),
          ),
          Paint()..color = const Color(0xFF2D3436),
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(c.dx + r * 0.15, c.dy - r * 0.2, r * 0.4, r * 0.25),
            Radius.circular(r * 0.05),
          ),
          Paint()..color = const Color(0xFF2D3436),
        );
        // 镜框连接
        canvas.drawLine(
          Offset(c.dx - r * 0.15, c.dy - r * 0.08),
          Offset(c.dx + r * 0.15, c.dy - r * 0.08),
          Paint()
            ..color = const Color(0xFF2D3436)
            ..strokeWidth = 3,
        );
        break;

      case 'scarf': // 围巾
        final scarfPath = Path();
        scarfPath.addRect(Rect.fromLTWH(c.dx - r * 0.5, c.dy + r * 0.35, r * 1.0, r * 0.2));
        scarfPath.addRect(Rect.fromLTWH(c.dx + r * 0.3, c.dy + r * 0.5, r * 0.2, r * 0.6));
        canvas.drawPath(scarfPath, Paint()..color = const Color(0xFFE67E22));
        // 围巾条纹
        canvas.drawLine(
          Offset(c.dx - r * 0.4, c.dy + r * 0.4),
          Offset(c.dx + r * 0.4, c.dy + r * 0.4),
          Paint()..color = const Color(0xFFE67E22).withOpacity(0.6)..strokeWidth = 2,
        );
        break;

      case 'crown': // 皇冠
        final crownPath = Path();
        crownPath.moveTo(c.dx - r * 0.4, c.dy - r * 0.7);
        crownPath.lineTo(c.dx - r * 0.4, c.dy - r * 1.1);
        crownPath.lineTo(c.dx - r * 0.2, c.dy - r * 0.85);
        crownPath.lineTo(c.dx, c.dy - r * 1.2);
        crownPath.lineTo(c.dx + r * 0.2, c.dy - r * 0.85);
        crownPath.lineTo(c.dx + r * 0.4, c.dy - r * 1.1);
        crownPath.lineTo(c.dx + r * 0.4, c.dy - r * 0.7);
        crownPath.close();
        canvas.drawPath(crownPath, Paint()..color = const Color(0xFFFFD700));
        // 宝石
        canvas.drawCircle(Offset(c.dx, c.dy - r * 1.0), r * 0.06, Paint()..color = const Color(0xFFFF6B6B));
        canvas.drawCircle(Offset(c.dx - r * 0.25, c.dy - r * 0.85), r * 0.04, Paint()..color = const Color(0xFF64B5F6));
        canvas.drawCircle(Offset(c.dx + r * 0.25, c.dy - r * 0.85), r * 0.04, Paint()..color = const Color(0xFF64B5F6));
        break;

      case 'flower': // 花朵
        for (int i = 0; i < 5; i++) {
          final angle = (i * 72 - 90) * math.pi / 180;
          final x = c.dx + math.cos(angle) * r * 0.25;
          final y = c.dy - r * 0.9 + math.sin(angle) * r * 0.25;
          canvas.drawOval(
            Rect.fromCenter(center: Offset(x, y), width: r * 0.2, height: r * 0.25),
            Paint()..color = const Color(0xFFFFB5E8),
          );
        }
        canvas.drawCircle(Offset(c.dx, c.dy - r * 0.9), r * 0.1, Paint()..color = const Color(0xFFFFE066));
        break;

      case 'bow': // 蝴蝶结
        final bowPath = Path();
        bowPath.moveTo(c.dx, c.dy - r * 0.75);
        bowPath.quadraticBezierTo(c.dx - r * 0.35, c.dy - r * 0.95, c.dx - r * 0.5, c.dy - r * 0.75);
        bowPath.quadraticBezierTo(c.dx - r * 0.35, c.dy - r * 0.55, c.dx, c.dy - r * 0.75);
        bowPath.moveTo(c.dx, c.dy - r * 0.75);
        bowPath.quadraticBezierTo(c.dx + r * 0.35, c.dy - r * 0.95, c.dx + r * 0.5, c.dy - r * 0.75);
        bowPath.quadraticBezierTo(c.dx + r * 0.35, c.dy - r * 0.55, c.dx, c.dy - r * 0.75);
        canvas.drawPath(bowPath, Paint()..color = const Color(0xFFDDA0DD));
        canvas.drawCircle(Offset(c.dx, c.dy - r * 0.75), r * 0.08, Paint()..color = const Color(0xFFDDA0DD));
        break;

      case 'star': // 星星发夹
        _drawStar(canvas, Offset(c.dx + r * 0.55, c.dy - r * 0.5), r * 0.2, const Color(0xFFFFE066));
        _drawStar(canvas, Offset(c.dx - r * 0.5, c.dy - r * 0.55), r * 0.15, const Color(0xFFFFE066));
        _drawStar(canvas, Offset(c.dx + r * 0.35, c.dy - r * 0.7), r * 0.12, const Color(0xFFFFE066));
        break;
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()..color = color;
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 144 - 90) * math.pi / 180;
      final x = center.dx + math.cos(angle) * size;
      final y = center.dy + math.sin(angle) * size;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DressedBearPainter oldDelegate) =>
      oldDelegate.costume != costume || oldDelegate.breathePhase != breathePhase;
}


/// ============================================
/// P43: Progress Report Screen
/// ============================================
class ProgressReportScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const ProgressReportScreen({super.key, required this.onComplete});

  @override
  State<ProgressReportScreen> createState() => _ProgressReportScreenState();
}

class _ProgressReportScreenState extends State<ProgressReportScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _chartAnim;

  final List<String> _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final List<double> _calories = [1850, 2100, 1900, 1750, 2000, 1950, 1800];
  final List<double> _weightTrend = [68.5, 68.2, 67.9, 67.6, 67.4, 67.2, 67.0];

  String _currentQuote = 'Your calorie intake is well balanced!';
  
  final List<String> _quotes = [
    'Your calorie intake is well balanced! 📊',
    'Great progress on your weight trend! 💪',
    'Keep up the consistent effort! 🎯',
    'Your nutrition is on track! 🥗',
    'Excellent weekly performance! 🌟',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _chartAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic);
    _animController.forward();

    // 轮换语料
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        setState(() {
          _currentQuote = _quotes[DateTime.now().second % _quotes.length];
        });
        return true;
      }
      return false;
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // 标题
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Your Progress\nReport',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        height: 1.1,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 统计卡片
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Avg Calories',
                          value: '${_calories.reduce((a, b) => a + b) ~/ 7}',
                          unit: 'kcal/day',
                          color: const Color(0xFFFF6B6B),
                          icon: '🔥',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Weight Lost',
                          value: '${(68.5 - 67.0).toStringAsFixed(1)}',
                          unit: 'kg this week',
                          color: const Color(0xFF4ECDC4),
                          icon: '📉',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 图表区域
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B6B),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Calories',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4ECDC4),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Weight',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: AnimatedBuilder(
                          animation: _chartAnim,
                          builder: (context, child) {
                            return CustomPaint(
                              size: Size.infinite,
                              painter: _CombinedChartPainter(
                                calories: _calories,
                                weight: _weightTrend,
                                days: _days,
                                progress: _chartAnim.value,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 专业分析小熊 + 语料
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ECDC4).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF4ECDC4).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomPaint(
                        size: const Size(70, 70),
                        painter: _AnalysisBearPainter(),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'AI Analysis',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF4ECDC4),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _currentQuote,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: Color(0xFF2D3748),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Next胶囊按钮
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GestureDetector(
                    onTap: widget.onComplete,
                    child: Container(
                      height: 56,
                      width: double.infinity,
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
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 统计卡片
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final Color color;
  final String icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: color,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Canvas: 组合图表
class _CombinedChartPainter extends CustomPainter {
  final List<double> calories;
  final List<double> weight;
  final List<String> days;
  final double progress;

  _CombinedChartPainter({
    required this.calories,
    required this.weight,
    required this.days,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (calories.isEmpty) return;

    final barWidth = (size.width - 60) / calories.length - 12;
    final maxCal = calories.reduce((a, b) => a > b ? a : b) * 1.2;
    final maxWeight = weight.reduce((a, b) => a > b ? a : b);
    final minWeight = weight.reduce((a, b) => a < b ? a : b);
    final weightRange = maxWeight - minWeight;
    final chartBottom = size.height - 30;
    final chartTop = 20.0;

    // 绘制柱状图
    for (int i = 0; i < calories.length; i++) {
      final barHeight = ((calories[i] / maxCal) * (chartBottom - chartTop) * progress).clamp(0.0, chartBottom - chartTop);
      final x = 35 + i * ((size.width - 60) / calories.length) + 6;
      final y = chartBottom - barHeight;

      // 渐变柱子
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
      );

      final gradientPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            const Color(0xFFFF6B6B).withOpacity(0.6),
            const Color(0xFFFF6B6B),
          ],
        ).createShader(Rect.fromLTWH(x, y, barWidth, barHeight));

      canvas.drawRRect(rect, gradientPaint);

      // X轴标签
      final dayPainter = TextPainter(
        text: TextSpan(
          text: days[i],
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      dayPainter.layout();
      dayPainter.paint(
        canvas,
        Offset(x + barWidth / 2 - dayPainter.width / 2, chartBottom + 8),
      );
    }

    // 绘制折线图 (体重趋势)
    if (progress > 0.3) {
      final lineProgress = ((progress - 0.3) / 0.7).clamp(0.0, 1.0);
      final linePath = Path();
      final dotPaint = Paint()..color = const Color(0xFF4ECDC4);

      for (int i = 0; i < weight.length; i++) {
        final x = 35 + i * ((size.width - 60) / calories.length) + barWidth / 2 + 6;
        final normalizedWeight = (weight[i] - minWeight) / (weightRange == 0 ? 1 : weightRange);
        final y = chartBottom - (normalizedWeight * (chartBottom - chartTop - 40) * lineProgress) - 20;

        if (i == 0) {
          linePath.moveTo(x, y);
        } else {
          linePath.lineTo(x, y);
        }

        // 绘制数据点
        if (lineProgress > 0.5) {
          canvas.drawCircle(Offset(x, y), 4, dotPaint);
          canvas.drawCircle(Offset(x, y), 2, Paint()..color = Colors.white);
        }
      }

      // 绘制线条
      final linePaint = Paint()
        ..color = const Color(0xFF4ECDC4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(linePath, linePaint);
    }

    // Y轴标签
    for (int i = 0; i <= 4; i++) {
      final value = (maxCal * i / 4).toInt();
      final y = chartBottom - (chartBottom - chartTop) * i / 4;
      final labelPainter = TextPainter(
        text: TextSpan(
          text: '${value ~/ 1000}k',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            color: Colors.grey.shade500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      labelPainter.layout();
      labelPainter.paint(canvas, Offset(0, y - 5));
    }
  }

  @override
  bool shouldRepaint(covariant _CombinedChartPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Canvas: 专业分析小熊
class _AnalysisBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 3;

    // 头
    canvas.drawCircle(c, r * 0.85, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.6), r * 0.22, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.6), r * 0.12, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.6), r * 0.22, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.6), r * 0.12, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.15), width: r * 0.9, height: r * 0.8),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 专业眼神 (眯眼+眼镜)
    // 眼镜框
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(c.dx - r * 0.55, c.dy - r * 0.18, r * 0.35, r * 0.22),
        Radius.circular(r * 0.05),
      ),
      Paint()..color = const Color(0xFF2D3436)..style = PaintingStyle.stroke..strokeWidth = 2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(c.dx + r * 0.2, c.dy - r * 0.18, r * 0.35, r * 0.22),
        Radius.circular(r * 0.05),
      ),
      Paint()..color = const Color(0xFF2D3436)..style = PaintingStyle.stroke..strokeWidth = 2,
    );
    // 镜框连接
    canvas.drawLine(
      Offset(c.dx - r * 0.2, c.dy - r * 0.07),
      Offset(c.dx + r * 0.2, c.dy - r * 0.07),
      Paint()..color = const Color(0xFF2D3436)..strokeWidth = 2,
    );
    // 眯眼
    final eyeY = c.dy - r * 0.05;
    _drawThinEye(canvas, Offset(c.dx - r * 0.38, eyeY), r * 0.1);
    _drawThinEye(canvas, Offset(c.dx + r * 0.38, eyeY), r * 0.1);

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.38, c.dy + r * 0.12), width: r * 0.15, height: r * 0.08), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.4));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.38, c.dy + r * 0.12), width: r * 0.15, height: r * 0.08), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.4));

    // 微笑
    final smilePath = Path();
    smilePath.moveTo(c.dx - r * 0.12, c.dy + r * 0.28);
    smilePath.quadraticBezierTo(c.dx, c.dy + r * 0.38, c.dx + r * 0.12, c.dy + r * 0.28);
    canvas.drawPath(smilePath, Paint()..color = const Color(0xFF8B4513)..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round);

    // 指指点点的动作
    // 右手伸出
    final armPath = Path();
    armPath.moveTo(c.dx + r * 0.5, c.dy + r * 0.2);
    armPath.quadraticBezierTo(c.dx + r * 1.2, c.dy - r * 0.3, c.dx + r * 1.3, c.dy - r * 0.5);
    canvas.drawPath(armPath, Paint()..color = const Color(0xFFD4A574)..style = PaintingStyle.stroke..strokeWidth = 8..strokeCap = StrokeCap.round);

    // 手指尖
    canvas.drawCircle(Offset(c.dx + r * 1.3, c.dy - r * 0.5), 4, Paint()..color = const Color(0xFFE8C4A0));
  }

  void _drawThinEye(Canvas canvas, Offset center, double size) {
    final paint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx - size, center.dy),
      Offset(center.dx + size, center.dy),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


/// ============================================
/// P44: Badge Detail Screen
/// ============================================
class BadgeDetailScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const BadgeDetailScreen({super.key, required this.onComplete});

  @override
  State<BadgeDetailScreen> createState() => _BadgeDetailScreenState();
}

class _BadgeDetailScreenState extends State<BadgeDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late Animation<double> _rotateAnim;
  late AnimationController _floatController;
  late Animation<double> _floatAnim;
  bool _showSharePanel = false;

  // 示例勋章数据
  final _badge = _BadgeData(
    icon: '⏰',
    name: 'Early Bird',
    description: 'Completed 7 consecutive days of logging before 9 AM',
    unlockedDate: DateTime(2025, 3, 15),
    reward: '7-day streak badge + 50 coins',
    color: const Color(0xFFFFE066),
    glowColor: const Color(0xFFFFD700),
  );

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _rotateAnim = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut),
    );

    _floatController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _showSharePanel() {
    setState(() {
      _showSharePanel = true;
    });
  }

  void _hideSharePanel() {
    setState(() {
      _showSharePanel = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Badge Detail',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF2D3748),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Color(0xFF2D3748)),
            onPressed: _showSharePanel,
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // 勋章展示区
                  AnimatedBuilder(
                    animation: Listenable.merge([_rotateAnim, _floatAnim]),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatAnim.value),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(_rotateAnim.value),
                          child: child,
                        ),
                      );
                    },
                    child: _BadgeDisplay(badge: _badge),
                  ),

                  const SizedBox(height: 32),

                  // 勋章名称
                  Text(
                    _badge.name,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Color(0xFF2D3748),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 描述
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      _badge.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 解锁信息卡片
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _InfoRow(
                          icon: '📅',
                          label: 'Unlocked on',
                          value: _formatDate(_badge.unlockedDate),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Color(0xFFF0F0F0), height: 1),
                        const SizedBox(height: 16),
                        _InfoRow(
                          icon: '🎁',
                          label: 'Reward',
                          value: _badge.reward,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Share按钮
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GestureDetector(
                      onTap: _showSharePanel,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ECDC4).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: const Color(0xFF4ECDC4),
                            width: 2,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.share, color: Color(0xFF4ECDC4), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Share Achievement',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color(0xFF4ECDC4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Back胶囊按钮
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GestureDetector(
                      onTap: widget.onComplete,
                      child: Container(
                        height: 56,
                        width: double.infinity,
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
                              Icon(Icons.arrow_back, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Back',
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
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // 分享面板
          if (_showSharePanel)
            GestureDetector(
              onTap: _hideSharePanel,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: GestureDetector(
                    onTap: () {}, // 防止点击穿透
                    child: Container(
                      margin: const EdgeInsets.all(32),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Share to',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _ShareOption(icon: '📱', name: 'Messages'),
                              _ShareOption(icon: '📘', name: 'Facebook'),
                              _ShareOption(icon: '🐦', name: 'Twitter'),
                              _ShareOption(icon: '📸', name: 'Instagram'),
                            ],
                          ),
                          const SizedBox(height: 24),
                          GestureDetector(
                            onTap: _hideSharePanel,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

/// 勋章数据
class _BadgeData {
  final String icon;
  final String name;
  final String description;
  final DateTime unlockedDate;
  final String reward;
  final Color color;
  final Color glowColor;

  _BadgeData({
    required this.icon,
    required this.name,
    required this.description,
    required this.unlockedDate,
    required this.reward,
    required this.color,
    required this.glowColor,
  });
}

/// 勋章展示组件
class _BadgeDisplay extends StatelessWidget {
  final _BadgeData badge;

  const _BadgeDisplay({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: badge.glowColor.withOpacity(0.4),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              badge.color.withOpacity(0.3),
              badge.color.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: badge.color.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                badge.icon,
                style: const TextStyle(fontSize: 64),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 信息行
class _InfoRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF4ECDC4).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 分享选项
class _ShareOption extends StatelessWidget {
  final String icon;
  final String name;

  const _ShareOption({
    required this.icon,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(icon, style: const TextStyle(fontSize: 28)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}


/// ============================================
/// P45: Notification Settings Screen
/// ============================================
class NotificationSettingsScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const NotificationSettingsScreen({super.key, required this.onComplete});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  bool _mealReminders = true;
  bool _waterReminders = true;
  bool _weightReminders = false;
  bool _weeklyReport = true;

  // 莫奈绿颜色
  static const Color _monetGreen = Color(0xFF4ECDC4);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggle(int index) {
    setState(() {
      switch (index) {
        case 0:
          _mealReminders = !_mealReminders;
          break;
        case 1:
          _waterReminders = !_waterReminders;
          break;
        case 2:
          _weightReminders = !_weightReminders;
          break;
        case 3:
          _weeklyReport = !_weeklyReport;
          break;
      }
    });
    // SharedPreferences would save here
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF2D3748),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              const SizedBox(height: 16),

              // 标题
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Notifications &\nPreferences',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      height: 1.1,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _monetGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.notifications_active, color: _monetGreen, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            '${[_mealReminders, _waterReminders, _weightReminders, _weeklyReport].where((v) => v).length} active',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _monetGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 设置列表
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _NotificationItem(
                        icon: '🍽️',
                        title: 'Meal reminders',
                        subtitle: 'Get notified before meal times',
                        value: _mealReminders,
                        onToggle: () => _toggle(0),
                        color: const Color(0xFFFF6B6B),
                      ),
                      Divider(color: Colors.grey.shade200, height: 1, indent: 70),
                      _NotificationItem(
                        icon: '💧',
                        title: 'Water reminders',
                        subtitle: 'Stay hydrated throughout the day',
                        value: _waterReminders,
                        onToggle: () => _toggle(1),
                        color: const Color(0xFF64B5F6),
                      ),
                      Divider(color: Colors.grey.shade200, height: 1, indent: 70),
                      _NotificationItem(
                        icon: '⚖️',
                        title: 'Weight tracking reminder',
                        subtitle: 'Daily weight check-in prompt',
                        value: _weightReminders,
                        onToggle: () => _toggle(2),
                        color: _monetGreen,
                      ),
                      Divider(color: Colors.grey.shade200, height: 1, indent: 70),
                      _NotificationItem(
                        icon: '📊',
                        title: 'Weekly report',
                        subtitle: 'Summary of your progress',
                        value: _weeklyReport,
                        onToggle: () => _toggle(3),
                        color: const Color(0xFFDDA0DD),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 小熊插画
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(50, 50),
                      painter: _NotificationBearPainter(),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Customize your\nnotification preferences',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Next胶囊按钮
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GestureDetector(
                  onTap: widget.onComplete,
                  child: Container(
                    height: 56,
                    width: double.infinity,
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
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// 通知项
class _NotificationItem extends StatefulWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool value;
  final VoidCallback onToggle;
  final Color color;

  const _NotificationItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onToggle,
    required this.color,
  });

  @override
  State<_NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<_NotificationItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(
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
    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onToggle();
        },
        onTapCancel: () => _controller.reverse(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    widget.icon,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              _MonetSwitch(value: widget.value, activeColor: widget.color),
            ],
          ),
        ),
      ),
    );
  }
}

/// 莫奈风格开关
class _MonetSwitch extends StatefulWidget {
  final bool value;
  final Color activeColor;

  const _MonetSwitch({required this.value, required this.activeColor});

  @override
  State<_MonetSwitch> createState() => _MonetSwitchState();
}

class _MonetSwitchState extends State<_MonetSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnim;
  late Animation<Color?> _colorAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _slideAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _colorAnim = ColorTween(
      begin: Colors.grey.shade300,
      end: widget.activeColor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    
    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_MonetSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
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
        return Container(
          width: 52,
          height: 30,
          decoration: BoxDecoration(
            color: _colorAnim.value,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 3 + _slideAnim.value * 22,
                top: 3,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Canvas: 通知小熊
class _NotificationBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 3;

    // 头
    canvas.drawCircle(c, r * 0.85, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.6), r * 0.22, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.6), r * 0.12, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.6), r * 0.22, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.6), r * 0.12, Paint()..color = const Color(0xFFE8C4A0));

    // 面部
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.15), width: r * 0.9, height: r * 0.8),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 眼睛
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy - r * 0.05), r * 0.1, Paint()..color = const Color(0xFF5D4037));
    canvas.drawCircle(Offset(c.dx - r * 0.26, c.dy - r * 0.08), r * 0.04, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy - r * 0.05), r * 0.1, Paint()..color = const Color(0xFF5D4037));
    canvas.drawCircle(Offset(c.dx + r * 0.3, c.dy - r * 0.08), r * 0.04, Paint()..color = Colors.white);

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.38, c.dy + r * 0.12), width: r * 0.18, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.38, c.dy + r * 0.12), width: r * 0.18, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));

    // 微笑
    final smilePath = Path();
    smilePath.moveTo(c.dx - r * 0.15, c.dy + r * 0.25);
    smilePath.quadraticBezierTo(c.dx, c.dy + r * 0.4, c.dx + r * 0.15, c.dy + r * 0.25);
    canvas.drawPath(smilePath, Paint()..color = const Color(0xFF8B4513)..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round);

    // 通知图标装饰
    canvas.drawCircle(Offset(c.dx + r * 0.65, c.dy - r * 0.55), r * 0.15, Paint()..color = const Color(0xFFFF6B6B));
    canvas.drawCircle(Offset(c.dx + r * 0.65, c.dy - r * 0.55), r * 0.08, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


/// ============================================
/// P46: About & Support Screen
/// ============================================
class AboutScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const AboutScreen({super.key, required this.onComplete});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  late Animation<double> _waveAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _fadeOutAnim;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _waveAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    _fadeAnim = CurvedAnimation(
      parent: AnimationController(duration: const Duration(milliseconds: 1000), vsync: this)..forward(),
      curve: Curves.easeOut,
    );

    _fadeOutAnim = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.privacy_tip, color: Color(0xFF4ECDC4)),
            SizedBox(width: 12),
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Last updated: March 2025',
                style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(
                'Your privacy is important to us. Aura-Pet collects minimal data necessary to provide personalized health tracking services.\n\n'
                '• We store your health metrics securely\n'
                '• Your data is encrypted in transit and at rest\n'
                '• We never sell your personal information\n'
                '• You can delete your data anytime\n\n'
                'For more information, please visit our website.',
                style: TextStyle(fontFamily: 'Inter', fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF4ECDC4)),
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.description, color: Color(0xFF4ECDC4)),
            SizedBox(width: 12),
            Text(
              'Terms of Service',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Last updated: March 2025',
                style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(
                'By using Aura-Pet, you agree to the following terms:\n\n'
                '• Aura-Pet provides health tracking for informational purposes only\n'
                '• This app is not a substitute for professional medical advice\n'
                '• You are responsible for the accuracy of the data you enter\n'
                '• Please consult healthcare professionals for medical decisions\n\n'
                'We strive to provide the best experience while respecting your privacy.',
                style: TextStyle(fontFamily: 'Inter', fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF4ECDC4)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'About',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF2D3748),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Logo区
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4ECDC4), Color(0xFF6DD5C4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4ECDC4).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Text('🐻', style: TextStyle(fontSize: 48)),
              ),
            ),

            const SizedBox(height: 16),

            // App名称
            const Text(
              'Aura-Pet',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Color(0xFF2D3748),
              ),
            ),

            const SizedBox(height: 4),

            // 版本号
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF4ECDC4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4ECDC4),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 链接列表
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _LinkItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: _showPrivacyDialog,
                  ),
                  Divider(color: Colors.grey.shade200, height: 1, indent: 70),
                  _LinkItem(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    onTap: _showTermsDialog,
                  ),
                  Divider(color: Colors.grey.shade200, height: 1, indent: 70),
                  _LinkItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Contact: support@aura-pet.com'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Canvas小熊挥手告别
            AnimatedBuilder(
              animation: Listenable.merge([_waveAnim, _fadeOutAnim]),
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeOutAnim.value,
                  child: Transform.translate(
                    offset: Offset(math.sin(_waveAnim.value * math.pi * 2) * 5, 0),
                    child: child,
                  ),
                );
              },
              child: CustomPaint(
                size: const Size(80, 80),
                painter: _WavingBearPainter(waveProgress: _waveAnim.value),
              ),
            ),

            const SizedBox(height: 8),

            // 底部语
            const Text(
              'Made with ♥ for your health',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Color(0xFF4ECDC4),
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 24),

            // Back to Home胶囊按钮
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: widget.onComplete,
                child: Container(
                  height: 56,
                  width: double.infinity,
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
                        Icon(Icons.home, color: Colors.white, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Back to Home',
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
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// 链接项
class _LinkItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _LinkItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF4ECDC4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(icon, color: const Color(0xFF4ECDC4), size: 22),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  color: Color(0xFF2D3748),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

/// Canvas: 挥手告别小熊
class _WavingBearPainter extends CustomPainter {
  final double waveProgress;

  _WavingBearPainter({required this.waveProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 3;

    // 头
    canvas.drawCircle(c, r * 0.85, Paint()..color = const Color(0xFFD4A574));

    // 耳朵
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.6), r * 0.22, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx - r * 0.7, c.dy - r * 0.6), r * 0.12, Paint()..color = const Color(0xFFE8C4A0));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.6), r * 0.22, Paint()..color = const Color(0xFFD4A574));
    canvas.drawCircle(Offset(c.dx + r * 0.7, c.dy - r * 0.6), r * 0.12, Paint()..color = const Color(0xFFE8C4A0));

    // 身体
    final bodyPath = Path();
    bodyPath.addOval(Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.5), width: r * 1.2, height: r * 1.0));
    canvas.drawPath(bodyPath, Paint()..color = const Color(0xFFD4A574));

    // 面部
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.15), width: r * 0.9, height: r * 0.8),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 挥手的手臂 (左右摇摆)
    final waveAngle = math.sin(waveProgress * math.pi * 2) * 0.5;

    // 左臂 (挥手)
    canvas.save();
    canvas.translate(c.dx - r * 0.7, c.dy + r * 0.2);
    canvas.rotate(-1.2 + waveAngle);
    canvas.drawOval(Rect.fromCenter(center: Offset(0, -r * 0.4), width: r * 0.35, height: r * 0.6), Paint()..color = const Color(0xFFD4A574));
    // 手掌
    canvas.drawCircle(Offset(0, -r * 0.6), r * 0.15, Paint()..color = const Color(0xFFE8C4A0));
    canvas.restore();

    // 右臂
    canvas.save();
    canvas.translate(c.dx + r * 0.7, c.dy + r * 0.2);
    canvas.rotate(1.2 - waveAngle);
    canvas.drawOval(Rect.fromCenter(center: Offset(0, -r * 0.4), width: r * 0.35, height: r * 0.6), Paint()..color = const Color(0xFFD4A574));
    canvas.restore();

    // 眼睛 (开心眯眼)
    final eyeY = c.dy - r * 0.05;
    _drawHappyEye(canvas, Offset(c.dx - r * 0.28, eyeY), r * 0.12);
    _drawHappyEye(canvas, Offset(c.dx + r * 0.28, eyeY), r * 0.12);

    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx - r * 0.38, c.dy + r * 0.12), width: r * 0.18, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx + r * 0.38, c.dy + r * 0.12), width: r * 0.18, height: r * 0.1), Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5));

    // 微笑
    final smilePath = Path();
    smilePath.moveTo(c.dx - r * 0.15, c.dy + r * 0.28);
    smilePath.quadraticBezierTo(c.dx, c.dy + r * 0.42, c.dx + r * 0.15, c.dy + r * 0.28);
    canvas.drawPath(smilePath, Paint()..color = const Color(0xFF8B4513)..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round);

    // 心形装饰
    _drawHeart(canvas, Offset(c.dx - r * 1.0, c.dy - r * 0.8), r * 0.15);
    _drawHeart(canvas, Offset(c.dx + r * 1.0, c.dy - r * 0.5), r * 0.1);
  }

  void _drawHappyEye(Canvas canvas, Offset center, double size) {
    final paint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final path = Path();
    path.moveTo(center.dx - size, center.dy);
    path.quadraticBezierTo(center.dx, center.dy - size * 0.6, center.dx + size, center.dy);
    canvas.drawPath(path, paint);
  }

  void _drawHeart(Canvas canvas, Offset center, double size) {
    final paint = Paint()..color = const Color(0xFFFF6B6B).withOpacity(0.7);
    final path = Path();
    path.moveTo(center.dx, center.dy + size * 0.3);
    path.cubicTo(
      center.dx - size * 1.2, center.dy - size * 0.3,
      center.dx - size * 1.2, center.dy - size * 1.2,
      center.dx, center.dy - size * 0.3,
    );
    path.cubicTo(
      center.dx + size * 1.2, center.dy - size * 1.2,
      center.dx + size * 1.2, center.dy - size * 0.3,
      center.dx, center.dy + size * 0.3,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavingBearPainter oldDelegate) =>
      oldDelegate.waveProgress != waveProgress;
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
