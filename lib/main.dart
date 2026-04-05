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
      title: 'Splash Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE4E3F4)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

/// Splash Screen - Canvas绘制小熊头像
/// 
/// 表情：翻白眼 + 露齿笑 + 调皮
/// 停留2秒后自动推入下一页（占位）
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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
    
    // 弹性缩放动画
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
    
    // 上下弹跳动画
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    _controller.forward();
    
    // 2秒后跳转下一页
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const _NextPagePlaceholder(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
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
      backgroundColor: const Color(0xFFE4E3F4), // ← CEO指定背景色
      body: Center(
        child: AnimatedBuilder(
          animation: _bounceAnimation,
          builder: (context, child) {
            // 上下弹跳效果
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
/// Canvas绘制：翻白眼 + 露齿笑 + 调皮小熊
/// ============================================
class _MischievousBearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // ========== 头部 ==========
    final headPaint = Paint()
      ..color = const Color(0xFFD4A574) // 蜂蜜棕
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius, headPaint);

    // 头部阴影
    final shadowPaint = Paint()
      ..color = const Color(0xFFD4A574).withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(
      Offset(center.dx, center.dy + 5),
      radius,
      shadowPaint,
    );

    // ========== 耳朵 ==========
    final earPaint = Paint()
      ..color = const Color(0xFFD4A574)
      ..style = PaintingStyle.fill;

    // 左耳
    canvas.drawCircle(
      Offset(center.dx - radius * 0.75, center.dy - radius * 0.75),
      radius * 0.35,
      earPaint,
    );
    // 左耳内
    canvas.drawCircle(
      Offset(center.dx - radius * 0.75, center.dy - radius * 0.75),
      radius * 0.2,
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // 右耳
    canvas.drawCircle(
      Offset(center.dx + radius * 0.75, center.dy - radius * 0.75),
      radius * 0.35,
      earPaint,
    );
    // 右耳内
    canvas.drawCircle(
      Offset(center.dx + radius * 0.75, center.dy - radius * 0.75),
      radius * 0.2,
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // ========== 面部背景 ==========
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.2),
        width: radius * 1.3,
        height: radius * 1.1,
      ),
      Paint()..color = const Color(0xFFE8C4A0),
    );

    // ========== 眼睛 - 翻白眼效果 ==========
    _drawRollingEyes(canvas, center, radius);

    // ========== 嘴巴 - 露齿大笑 ==========
    _drawGrinningMouth(canvas, center, radius);

    // ========== 调皮元素 ==========
    _drawMischievousDetails(canvas, center, radius);
  }

  /// 翻白眼眼睛
  void _drawRollingEyes(Canvas canvas, Offset center, double radius) {
    final eyeY = center.dy - radius * 0.15;
    final eyeSpacing = radius * 0.4;
    
    // 左眼
    _drawSingleRollingEye(
      canvas,
      Offset(center.dx - eyeSpacing, eyeY),
      radius * 0.18,
    );
    
    // 右眼
    _drawSingleRollingEye(
      canvas,
      Offset(center.dx + eyeSpacing, eyeY),
      radius * 0.18,
    );
  }

  /// 单只翻白眼
  void _drawSingleRollingEye(Canvas canvas, Offset center, double eyeRadius) {
    // 眼白
    canvas.drawCircle(
      center,
      eyeRadius,
      Paint()..color = Colors.white,
    );
    
    // 眼眶
    canvas.drawCircle(
      center,
      eyeRadius,
      Paint()
        ..color = const Color(0xFF5D4037)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    
    // 黑眼珠（向上翻，露出下眼白）
    final pupilOffset = Offset(0, -eyeRadius * 0.3);
    canvas.drawCircle(
      center + pupilOffset,
      eyeRadius * 0.5,
      Paint()..color = Colors.black,
    );
    
    // 眼珠高光
    canvas.drawCircle(
      center + pupilOffset + const Offset(-3, -3),
      eyeRadius * 0.15,
      Paint()..color = Colors.white,
    );
    
    // 下眼白（翻白眼效果）
    final bottomWhite = Path();
    bottomWhite.moveTo(center.dx - eyeRadius * 0.7, center.dy);
    bottomWhite.quadraticBezierTo(
      center.dx,
      center.dy + eyeRadius * 0.3,
      center.dx + eyeRadius * 0.7,
      center.dy,
    );
    canvas.drawPath(
      bottomWhite,
      Paint()..color = const Color(0xFFFFCDD2),
    );
  }

  /// 露齿大笑嘴巴
  void _drawGrinningMouth(Canvas canvas, Offset center, double radius) {
    final mouthY = center.dy + radius * 0.35;
    
    // 大嘴巴弧形
    final mouthWidth = radius * 0.7;
    final mouthPath = Path();
    mouthPath.moveTo(center.dx - mouthWidth, mouthY);
    mouthPath.quadraticBezierTo(
      center.dx,
      mouthY + radius * 0.5,
      center.dx + mouthWidth,
      mouthY,
    );
    mouthPath.quadraticBezierTo(
      center.dx,
      mouthY - radius * 0.1,
      center.dx - mouthWidth,
      mouthY,
    );
    
    // 嘴巴填充（深色）
    canvas.drawPath(
      mouthPath,
      Paint()..color = const Color(0xFF8B4513),
    );
    
    // 上排牙齿
    final upperTeeth = Path();
    upperTeeth.moveTo(center.dx - mouthWidth * 0.85, mouthY);
    upperTeeth.lineTo(center.dx - mouthWidth * 0.85, mouthY + radius * 0.15);
    upperTeeth.lineTo(center.dx - mouthWidth * 0.65, mouthY + radius * 0.15);
    upperTeeth.lineTo(center.dx - mouthWidth * 0.65, mouthY);
    
    upperTeeth.moveTo(center.dx - mouthWidth * 0.55, mouthY);
    upperTeeth.lineTo(center.dx - mouthWidth * 0.55, mouthY + radius * 0.18);
    upperTeeth.lineTo(center.dx - mouthWidth * 0.35, mouthY + radius * 0.18);
    upperTeeth.lineTo(center.dx - mouthWidth * 0.35, mouthY);
    
    // 中间大门牙
    upperTeeth.moveTo(center.dx - mouthWidth * 0.25, mouthY);
    upperTeeth.lineTo(center.dx - mouthWidth * 0.25, mouthY + radius * 0.2);
    upperTeeth.lineTo(center.dx - mouthWidth * 0.05, mouthY + radius * 0.2);
    upperTeeth.lineTo(center.dx - mouthWidth * 0.05, mouthY);
    
    upperTeeth.moveTo(center.dx + mouthWidth * 0.05, mouthY);
    upperTeeth.lineTo(center.dx + mouthWidth * 0.05, mouthY + radius * 0.2);
    upperTeeth.lineTo(center.dx + mouthWidth * 0.25, mouthY + radius * 0.2);
    upperTeeth.lineTo(center.dx + mouthWidth * 0.25, mouthY);
    
    upperTeeth.moveTo(center.dx + mouthWidth * 0.35, mouthY);
    upperTeeth.lineTo(center.dx + mouthWidth * 0.35, mouthY + radius * 0.18);
    upperTeeth.lineTo(center.dx + mouthWidth * 0.55, mouthY + radius * 0.18);
    upperTeeth.lineTo(center.dx + mouthWidth * 0.55, mouthY);
    
    upperTeeth.moveTo(center.dx + mouthWidth * 0.65, mouthY);
    upperTeeth.lineTo(center.dx + mouthWidth * 0.65, mouthY + radius * 0.15);
    upperTeeth.lineTo(center.dx + mouthWidth * 0.85, mouthY + radius * 0.15);
    upperTeeth.lineTo(center.dx + mouthWidth * 0.85, mouthY);
    
    canvas.drawPath(
      upperTeeth,
      Paint()..color = Colors.white,
    );
    
    // 下排牙齿
    final lowerTeeth = Path();
    lowerTeeth.moveTo(center.dx - mouthWidth * 0.7, mouthY + radius * 0.35);
    lowerTeeth.lineTo(center.dx - mouthWidth * 0.7, mouthY + radius * 0.25);
    lowerTeeth.lineTo(center.dx - mouthWidth * 0.4, mouthY + radius * 0.25);
    lowerTeeth.lineTo(center.dx - mouthWidth * 0.4, mouthY + radius * 0.35);
    
    lowerTeeth.moveTo(center.dx - mouthWidth * 0.3, mouthY + radius * 0.35);
    lowerTeeth.lineTo(center.dx - mouthWidth * 0.3, mouthY + radius * 0.22);
    lowerTeeth.lineTo(center.dx + mouthWidth * 0.3, mouthY + radius * 0.22);
    lowerTeeth.lineTo(center.dx + mouthWidth * 0.3, mouthY + radius * 0.35);
    
    lowerTeeth.moveTo(center.dx + mouthWidth * 0.4, mouthY + radius * 0.35);
    lowerTeeth.lineTo(center.dx + mouthWidth * 0.4, mouthY + radius * 0.25);
    lowerTeeth.lineTo(center.dx + mouthWidth * 0.7, mouthY + radius * 0.25);
    lowerTeeth.lineTo(center.dx + mouthWidth * 0.7, mouthY + radius * 0.35);
    
    canvas.drawPath(
      lowerTeeth,
      Paint()..color = Colors.white,
    );
    
    // 嘴巴边框
    canvas.drawPath(
      mouthPath,
      Paint()
        ..color = const Color(0xFF5D4037)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  /// 调皮细节
  void _drawMischievousDetails(Canvas canvas, Offset center, double radius) {
    // 左眉毛（上扬 - 调皮）
    final leftBrow = Path();
    leftBrow.moveTo(center.dx - radius * 0.6, center.dy - radius * 0.45);
    leftBrow.quadraticBezierTo(
      center.dx - radius * 0.4,
      center.dy - radius * 0.55, // 向上挑
      center.dx - radius * 0.2,
      center.dy - radius * 0.45,
    );
    canvas.drawPath(
      leftBrow,
      Paint()
        ..color = const Color(0xFF5D4037)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    
    // 右眉毛（平 - 配合）
    final rightBrow = Path();
    rightBrow.moveTo(center.dx + radius * 0.2, center.dy - radius * 0.4);
    rightBrow.lineTo(center.dx + radius * 0.6, center.dy - radius * 0.4);
    canvas.drawPath(
      rightBrow,
      Paint()
        ..color = const Color(0xFF5D4037)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    
    // 歪嘴效果（嘴的一侧上扬）
    final smirkOffset = radius * 0.08;
    // 在嘴巴附近添加腮红
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.5, center.dy + radius * 0.15),
        width: radius * 0.25,
        height: radius * 0.15,
      ),
      Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + radius * 0.5, center.dy + radius * 0.15),
        width: radius * 0.25,
        height: radius * 0.15,
      ),
      Paint()..color = const Color(0xFFFFCDD2).withOpacity(0.5),
    );
    
    // 调皮的小舌头
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + smirkOffset, center.dy + radius * 0.55),
        width: radius * 0.25,
        height: radius * 0.2,
      ),
      Paint()..color = const Color(0xFFFF6B6B),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ============================================
/// 临时下一页占位符（后续替换）
/// ============================================
class _NextPagePlaceholder extends StatelessWidget {
  const _NextPagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4E3F4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🦞',
              style: TextStyle(fontSize: 100),
            ),
            const SizedBox(height: 24),
            const Text(
              'Next Page',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Page transition animation included',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
