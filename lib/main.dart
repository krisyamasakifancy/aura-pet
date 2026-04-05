import 'package:flutter/material.dart';
import 'dart:math' as math;

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
