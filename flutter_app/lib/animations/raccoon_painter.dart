import 'package:flutter/material.dart';
import 'dart:math' as math;

/// ============================================
// AURA-PET: 原创小浣熊动画渲染引擎
// CustomPainter 实现 - 无静态图片依赖
// ============================================

class RaccoonPainter extends CustomPainter {
  // 动画参数
  final double breathPhase;
  final double blinkProgress; // 0=闭合, 1=全开
  final double tailWag;
  final double earTwitch;
  final double floatY;
  final double joyLevel; // 0-1, 影响动画幅度
  final double waterIntake; // 影响呼吸频率
  final double nutritionBalance; // 影响颜色偏移
  
  RaccoonPainter({
    required this.breathPhase,
    required this.blinkProgress,
    required this.tailWag,
    required this.earTwitch,
    required this.floatY,
    required this.joyLevel,
    required this.waterIntake,
    required this.nutritionBalance,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // 呼吸缩放 - 水分摄入影响频率
    final waterRatio = (waterIntake / 2000).clamp(0.5, 1.5);
    final breathScale = 1.0 + math.sin(breathPhase * waterRatio) * 0.025;
    final amplitude = 6.0 + joyLevel * 4.0; // 快乐程度影响浮动幅度
    
    canvas.save();
    canvas.translate(center.dx, center.dy + math.sin(breathPhase * 0.6) * amplitude);
    canvas.scale(breathScale);
    
    // ===== 影子 =====
    _drawShadow(canvas);
    
    // ===== 尾巴 =====
    _drawTail(canvas);
    
    // ===== 身体 =====
    _drawBody(canvas);
    
    // ===== 脸部 =====
    _drawFace(canvas);
    
    // ===== 耳朵 =====
    _drawEars(canvas);
    
    // ===== 浣熊面具 =====
    _drawMask(canvas);
    
    // ===== 眼睛 =====
    _drawEyes(canvas);
    
    // ===== 鼻子 =====
    _drawNose(canvas);
    
    // ===== 嘴巴 =====
    _drawMouth(canvas);
    
    // ===== 腮红 =====
    _drawBlush(canvas);
    
    canvas.restore();
  }
  
  void _drawShadow(Canvas canvas) {
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, 75), width: 100, height: 30),
      shadowPaint,
    );
  }
  
  void _drawTail(Canvas canvas) {
    canvas.save();
    canvas.translate(-55, 45);
    canvas.rotate(-0.3 + tailWag);
    
    // 尾巴渐变 - 营养平衡影响色调
    final tailColor = Color.lerp(
      const Color(0xFFD4A5A5),
      const Color(0xFFB8E0D2),
      nutritionBalance,
    )!;
    
    final tailGrad = Paint()
      ..shader = RadialGradient(
        colors: [tailColor, tailColor.withOpacity(0.8)],
      ).createShader(const Rect.fromLTWH(-25, -18, 50, 36));
    
    // 毛茸茸的尾巴
    for (int i = -2; i <= 2; i++) {
      final offset = math.sin(breathPhase + i * 0.5) * 2;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(i * 10.0, offset), width: 20, height: 35),
        tailGrad,
      );
    }
    
    // 条纹
    final stripePaint = Paint()..color = const Color(0xFFA08080);
    for (int i = -1; i <= 1; i++) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(i * 12.0, 0), width: 8, height: 25),
        stripePaint,
      );
    }
    
    canvas.restore();
  }
  
  void _drawBody(Canvas canvas) {
    // 身体渐变 - 莫奈玫瑰色系
    final bodyGrad = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.4),
        radius: 1.2,
        colors: [
          const Color(0xFFFFE8F0),
          const Color(0xFFF5D0C5),
          const Color(0xFFE8B4B8),
        ],
      ).createShader(const Rect.fromLTWH(-70, -55, 140, 160));
    
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, 25), width: 140, height: 160),
      bodyGrad,
    );
    
    // 高光
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(-25, 5), width: 50, height: 80),
      highlightPaint,
    );
    
    // 肚子
    final bellyPaint = Paint()..color = Colors.white.withOpacity(0.4);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, 40), width: 60, height: 50),
      bellyPaint,
    );
  }
  
  void _drawFace(Canvas canvas) {
    final faceGrad = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.4),
        radius: 1.0,
        colors: [
          Colors.white,
          const Color(0xFFFFF5F8),
          const Color(0xFFFFE8F0),
        ],
      ).createShader(const Rect.fromLTWH(-58, -75, 116, 110));
    
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, -20), width: 116, height: 110),
      faceGrad,
    );
  }
  
  void _drawEars(Canvas canvas) {
    // 左耳
    canvas.save();
    canvas.translate(-40, -65);
    canvas.rotate(-0.2 + earTwitch);
    
    final earPaint = Paint()..color = const Color(0xFFE8B4B8);
    final innerEarPaint = Paint()..color = const Color(0xFFFFB6C1);
    
    final earPath = Path()
      ..moveTo(-5, 10)
      ..quadraticBezierTo(-20, -35, 0, -25)
      ..quadraticBezierTo(10, -15, -5, 10);
    canvas.drawPath(earPath, earPaint);
    
    final innerPath = Path()
      ..moveTo(-3, 5)
      ..quadraticBezierTo(-12, -20, 0, -15)
      ..quadraticBezierTo(5, -8, -3, 5);
    canvas.drawPath(innerPath, innerEarPaint);
    
    canvas.restore();
    
    // 右耳
    canvas.save();
    canvas.translate(40, -65);
    canvas.rotate(0.2 - earTwitch);
    
    final earPath2 = Path()
      ..moveTo(5, 10)
      ..quadraticBezierTo(20, -35, 0, -25)
      ..quadraticBezierTo(-10, -15, 5, 10);
    canvas.drawPath(earPath2, earPaint);
    
    final innerPath2 = Path()
      ..moveTo(3, 5)
      ..quadraticBezierTo(12, -20, 0, -15)
      ..quadraticBezierTo(-5, -8, 3, 5);
    canvas.drawPath(innerPath2, innerEarPaint);
    
    canvas.restore();
  }
  
  void _drawMask(Canvas canvas) {
    final maskPaint = Paint()
      ..color = const Color(0xFF5A5A5A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    
    // 眼罩
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(-22, -22), width: 32, height: 26),
      maskPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(22, -22), width: 32, height: 26),
      maskPaint,
    );
    
    // 鼻梁
    final noseBridgePath = Path()
      ..moveTo(-8, -28)
      ..quadraticBezierTo(0, -32, 8, -28);
    canvas.drawPath(noseBridgePath, maskPaint);
  }
  
  void _drawEyes(Canvas canvas) {
    const eyeY = -22.0;
    const eyeSpacing = 22.0;
    final eyeHeight = 10.0 * blinkProgress;
    
    // 眼珠
    final eyePaint = Paint()..color = const Color(0xFF2D1B4E);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(-eyeSpacing, eyeY), width: 16, height: eyeHeight),
      eyePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(eyeSpacing, eyeY), width: 16, height: eyeHeight),
      eyePaint,
    );
    
    if (blinkProgress > 0.3) {
      // 高光
      final highlightPaint = Paint()..color = Colors.white.withOpacity(0.95);
      canvas.drawCircle(
        Offset(-eyeSpacing - 2, eyeY - 3),
        3,
        highlightPaint,
      );
      canvas.drawCircle(
        Offset(eyeSpacing - 2, eyeY - 3),
        3,
        highlightPaint,
      );
      
      // 次高光
      final smallHighlight = Paint()..color = Colors.white.withOpacity(0.5);
      canvas.drawCircle(
        Offset(-eyeSpacing + 2, eyeY + 2),
        1.5,
        smallHighlight,
      );
      canvas.drawCircle(
        Offset(eyeSpacing + 2, eyeY + 2),
        1.5,
        smallHighlight,
      );
    }
  }
  
  void _drawNose(Canvas canvas) {
    final noseGrad = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.5),
        colors: [const Color(0xFFFFB6C1), const Color(0xFFD4A5A5)],
      ).createShader(const Rect.fromLTWH(-5, -10, 10, 8));
    
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, -6), width: 10, height: 8),
      noseGrad,
    );
    
    // 鼻头高光
    final noseHighlight = Paint()..color = Colors.white.withOpacity(0.5);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(-1, -7), width: 4, height: 3),
      noseHighlight,
    );
  }
  
  void _drawMouth(Canvas canvas) {
    final mouthPaint = Paint()
      ..color = const Color(0xFFD4A5A5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    
    // 微笑
    final smilePath = Path()
      ..moveTo(-12, -2)
      ..quadraticBezierTo(0, 10, 12, -2);
    canvas.drawPath(smilePath, mouthPaint);
  }
  
  void _drawBlush(Canvas canvas) {
    final blushPaint = Paint()..color = const Color(0xFFFF9696).withOpacity(0.35);
    
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(-40, -10), width: 28, height: 16),
      blushPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(40, -10), width: 28, height: 16),
      blushPaint,
    );
  }

  @override
  bool shouldRepaint(covariant RaccoonPainter oldDelegate) {
    return breathPhase != oldDelegate.breathPhase ||
        blinkProgress != oldDelegate.blinkProgress ||
        tailWag != oldDelegate.tailWag ||
        joyLevel != oldDelegate.joyLevel ||
        waterIntake != oldDelegate.waterIntake;
  }
}
