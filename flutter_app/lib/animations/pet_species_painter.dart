import 'package:flutter/material.dart';
import 'dart:math' as math;

/// ============================================
// AURA-PET: 通用宠物渲染引擎
// 支持多种宠物品种
/// ============================================

enum PetSpecies { raccoon, cat, dragon, bunny, fox }

class PetSpeciesPainter extends CustomPainter {
  final PetSpecies species;
  final double breathPhase;
  final double blinkProgress;
  final double tailWag;
  final double earTwitch;
  final double joyLevel;
  final Color primaryColor;
  final Color secondaryColor;
  
  PetSpeciesPainter({
    required this.species,
    required this.breathPhase,
    required this.blinkProgress,
    required this.tailWag,
    required this.earTwitch,
    required this.joyLevel,
    required this.primaryColor,
    required this.secondaryColor,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final breathScale = 1.0 + math.sin(breathPhase) * 0.025;
    final amplitude = 6.0 + joyLevel * 4.0;
    final floatY = math.sin(breathPhase * 0.6) * amplitude;
    
    canvas.save();
    canvas.translate(center.dx, center.dy + floatY);
    canvas.scale(breathScale);
    
    // 绘制阴影
    _drawShadow(canvas);
    
    // 根据品种绘制
    switch (species) {
      case PetSpecies.raccoon:
        _drawRaccoon(canvas);
        break;
      case PetSpecies.cat:
        _drawCat(canvas);
        break;
      case PetSpecies.dragon:
        _drawDragon(canvas);
        break;
      case PetSpecies.bunny:
        _drawBunny(canvas);
        break;
      case PetSpecies.fox:
        _drawFox(canvas);
        break;
    }
    
    canvas.restore();
  }
  
  void _drawShadow(Canvas canvas) {
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, 80), width: 100, height: 25),
      shadowPaint,
    );
  }
  
  void _drawRaccoon(Canvas canvas) {
    // 尾巴
    canvas.save();
    canvas.translate(-55, 50);
    canvas.rotate(-0.3 + tailWag);
    _drawFluffyTail(canvas, secondaryColor);
    canvas.restore();
    
    // 身体
    _drawBody(canvas, primaryColor);
    
    // 脸部
    _drawFace(canvas, const Color(0xFFFFF5F8));
    
    // 耳朵
    _drawRaccoonEars(canvas);
    
    // 浣熊面具
    _drawMask(canvas);
    
    // 眼睛
    _drawEyes(canvas);
    
    // 鼻子
    _drawNose(canvas, const Color(0xFFD4A5A5));
    
    // 嘴巴
    _drawSmile(canvas);
    
    // 腮红
    _drawBlush(canvas);
  }
  
  void _drawCat(Canvas canvas) {
    // 尾巴
    canvas.save();
    canvas.translate(55, 30);
    canvas.rotate(0.5 - tailWag * 0.5);
    _drawCatTail(canvas, primaryColor);
    canvas.restore();
    
    // 身体
    _drawBody(canvas, primaryColor);
    
    // 脸部
    _drawFace(canvas, const Color(0xFFFFFFFF));
    
    // 猫耳朵
    _drawCatEars(canvas);
    
    // 眼睛
    _drawCatEyes(canvas);
    
    // 鼻子
    _drawNose(canvas, const Color(0xFFFFB6C1));
    
    // 嘴巴
    _drawCatMouth(canvas);
    
    // 胡须
    _drawWhiskers(canvas);
    
    // 腮红
    _drawBlush(canvas);
  }
  
  void _drawDragon(Canvas canvas) {
    // 尾巴（带刺）
    canvas.save();
    canvas.translate(-60, 40);
    canvas.rotate(-0.4 + tailWag);
    _drawDragonTail(canvas, primaryColor);
    canvas.restore();
    
    // 翅膀
    _drawWings(canvas);
    
    // 身体
    _drawBody(canvas, primaryColor);
    
    // 脸部
    _drawFace(canvas, const Color(0xFFFFF0E0));
    
    // 龙角
    _drawDragonHorns(canvas);
    
    // 眼睛
    _drawDragonEyes(canvas);
    
    // 鼻子
    _drawNose(canvas, const Color(0xFFE8A090));
    
    // 嘴巴（龙息效果）
    _drawDragonMouth(canvas);
    
    // 腮红
    _drawBlush(canvas);
  }
  
  void _drawBunny(Canvas canvas) {
    // 短尾巴
    canvas.save();
    canvas.translate(0, 70);
    canvas.rotate(tailWag * 0.3);
    _drawBunnyTail(canvas);
    canvas.restore();
    
    // 身体
    _drawBody(canvas, primaryColor);
    
    // 脸部
    _drawFace(canvas, const Color(0xFFFFFFFF));
    
    // 长耳朵
    _drawBunnyEars(canvas);
    
    // 眼睛
    _drawEyes(canvas, isRound: true);
    
    // 鼻子
    _drawNose(canvas, const Color(0xFFFFB6C1));
    
    // 嘴巴
    _drawSmile(canvas);
    
    // 胡须
    _drawWhiskers(canvas);
  }
  
  void _drawFox(Canvas canvas) {
    // 大尾巴
    canvas.save();
    canvas.translate(-60, 45);
    canvas.rotate(-0.3 + tailWag);
    _drawFoxTail(canvas);
    canvas.restore();
    
    // 身体
    _drawBody(canvas, primaryColor);
    
    // 脸部
    _drawFace(canvas, const Color(0xFFFFF5E6));
    
    // 狐狸耳朵
    _drawFoxEars(canvas);
    
    // 眼睛
    _drawEyes(canvas);
    
    // 鼻子
    _drawNose(canvas, Colors.black);
    
    // 嘴巴
    _drawFoxMouth(canvas);
    
    // 腮红
    _drawBlush(canvas);
  }
  
  // ========== 通用组件 ==========
  
  void _drawBody(Canvas canvas, Color color) {
    final bodyGrad = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.4),
        radius: 1.2,
        colors: [
          Color.lerp(color, Colors.white, 0.3)!,
          color,
          Color.lerp(color, Colors.black, 0.2)!,
        ],
      ).createShader(const Rect.fromLTWH(-70, -55, 140, 160));
    
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, 30), width: 140, height: 160),
      bodyGrad,
    );
    
    // 高光
    final highlightPaint = Paint()..color = Colors.white.withOpacity(0.3);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(-25, 5), width: 50, height: 80),
      highlightPaint,
    );
    
    // 肚子
    final bellyPaint = Paint()..color = Colors.white.withOpacity(0.4);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, 45), width: 60, height: 50),
      bellyPaint,
    );
  }
  
  void _drawFace(Canvas canvas, Color faceColor) {
    final faceGrad = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.4),
        radius: 1.0,
        colors: [
          faceColor,
          Color.lerp(faceColor, const Color(0xFFFFE8F0), 0.3)!,
        ],
      ).createShader(const Rect.fromLTWH(-55, -70, 110, 100));
    
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, -15), width: 110, height: 100),
      faceGrad,
    );
  }
  
  void _drawEyes(Canvas canvas, {bool isRound = false}) {
    const eyeY = -20.0;
    const eyeSpacing = 22.0;
    final eyeHeight = 10.0 * blinkProgress;
    
    final eyePaint = Paint()..color = const Color(0xFF2D1B4E);
    
    if (isRound) {
      canvas.drawCircle(Offset(-eyeSpacing, eyeY), 10 * blinkProgress, eyePaint);
      canvas.drawCircle(Offset(eyeSpacing, eyeY), 10 * blinkProgress, eyePaint);
    } else {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(-eyeSpacing, eyeY), width: 16, height: eyeHeight * 2),
        eyePaint,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(eyeSpacing, eyeY), width: 16, height: eyeHeight * 2),
        eyePaint,
      );
    }
    
    if (blinkProgress > 0.3) {
      final highlightPaint = Paint()..color = Colors.white.withOpacity(0.95);
      canvas.drawCircle(Offset(-eyeSpacing - 2, eyeY - 3), 3, highlightPaint);
      canvas.drawCircle(Offset(eyeSpacing - 2, eyeY - 3), 3, highlightPaint);
    }
  }
  
  void _drawNose(Canvas canvas, Color noseColor) {
    final noseGrad = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.5),
        colors: [Color.lerp(noseColor, Colors.white, 0.3)!, noseColor],
      ).createShader(const Rect.fromLTWH(-5, -10, 10, 8));
    
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, -4), width: 10, height: 8),
      noseGrad,
    );
  }
  
  void _drawSmile(Canvas canvas) {
    final smilePaint = Paint()
      ..color = const Color(0xFFD4A5A5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    
    final smilePath = Path()
      ..moveTo(-12, 0)
      ..quadraticBezierTo(0, 12, 12, 0);
    canvas.drawPath(smilePath, smilePaint);
  }
  
  void _drawBlush(Canvas canvas) {
    final blushPaint = Paint()..color = const Color(0xFFFF9696).withOpacity(0.35);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(-38, -8), width: 28, height: 16),
      blushPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(38, -8), width: 28, height: 16),
      blushPaint,
    );
  }
  
  void _drawRaccoonEars(Canvas canvas) {
    canvas.save();
    canvas.translate(-40, -60);
    canvas.rotate(-0.2 + earTwitch);
    _drawPointedEar(canvas, const Color(0xFFE8B4B8), const Color(0xFFFFB6C1));
    canvas.restore();
    
    canvas.save();
    canvas.translate(40, -60);
    canvas.rotate(0.2 - earTwitch);
    _drawPointedEar(canvas, const Color(0xFFE8B4B8), const Color(0xFFFFB6C1));
    canvas.restore();
  }
  
  void _drawCatEars(Canvas canvas) {
    canvas.save();
    canvas.translate(-35, -55);
    canvas.rotate(-0.3);
    _drawTriangularEar(canvas, primaryColor, const Color(0xFFFFB6C1));
    canvas.restore();
    
    canvas.save();
    canvas.translate(35, -55);
    canvas.rotate(0.3);
    _drawTriangularEar(canvas, primaryColor, const Color(0xFFFFB6C1));
    canvas.restore();
  }
  
  void _drawFoxEars(Canvas canvas) {
    canvas.save();
    canvas.translate(-38, -58);
    canvas.rotate(-0.2);
    _drawTriangularEar(canvas, primaryColor, const Color(0xFFFFF0E0));
    canvas.restore();
    
    canvas.save();
    canvas.translate(38, -58);
    canvas.rotate(0.2);
    _drawTriangularEar(canvas, primaryColor, const Color(0xFFFFF0E0));
    canvas.restore();
  }
  
  void _drawBunnyEars(Canvas canvas) {
    // 长耳朵
    canvas.save();
    canvas.translate(-20, -70);
    canvas.rotate(-0.15 + earTwitch * 0.5);
    _drawLongEar(canvas, primaryColor, const Color(0xFFFFB6C1));
    canvas.restore();
    
    canvas.save();
    canvas.translate(20, -70);
    canvas.rotate(0.15 - earTwitch * 0.5);
    _drawLongEar(canvas, primaryColor, const Color(0xFFFFB6C1));
    canvas.restore();
  }
  
  void _drawDragonHorns(Canvas canvas) {
    final hornPaint = Paint()..color = const Color(0xFFFFD700);
    
    canvas.save();
    canvas.translate(-30, -65);
    canvas.rotate(-0.4);
    final hornPath1 = Path()
      ..moveTo(0, 0)
      ..lineTo(-8, -35)
      ..lineTo(8, 0);
    canvas.drawPath(hornPath1, hornPaint);
    canvas.restore();
    
    canvas.save();
    canvas.translate(30, -65);
    canvas.rotate(0.4);
    final hornPath2 = Path()
      ..moveTo(0, 0)
      ..lineTo(-8, -35)
      ..lineTo(8, 0);
    canvas.drawPath(hornPath2, hornPaint);
    canvas.restore();
  }
  
  void _drawMask(Canvas canvas) {
    final maskPaint = Paint()
      ..color = const Color(0xFF5A5A5A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(-20, -20), width: 32, height: 26),
      maskPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(20, -20), width: 32, height: 26),
      maskPaint,
    );
  }
  
  void _drawWhiskers(Canvas canvas) {
    final whiskerPaint = Paint()
      ..color = const Color(0xFFCCCCCC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    // 左边
    canvas.drawLine(Offset(-30, -5), Offset(-60, -10), whiskerPaint);
    canvas.drawLine(Offset(-30, -2), Offset(-58, -2), whiskerPaint);
    canvas.drawLine(Offset(-30, 1), Offset(-60, 8), whiskerPaint);
    
    // 右边
    canvas.drawLine(Offset(30, -5), Offset(60, -10), whiskerPaint);
    canvas.drawLine(Offset(30, -2), Offset(58, -2), whiskerPaint);
    canvas.drawLine(Offset(30, 1), Offset(60, 8), whiskerPaint);
  }
  
  // ========== 辅助绘制方法 ==========
  
  void _drawPointedEar(Canvas canvas, Color outer, Color inner) {
    final outerPaint = Paint()..color = outer;
    final innerPaint = Paint()..color = inner;
    
    final path = Path()
      ..moveTo(-5, 10)
      ..quadraticBezierTo(-18, -30, 0, -22)
      ..quadraticBezierTo(8, -15, -5, 10);
    canvas.drawPath(path, outerPaint);
    
    final innerPath = Path()
      ..moveTo(-3, 5)
      ..quadraticBezierTo(-10, -18, 0, -14)
      ..quadraticBezierTo(5, -8, -3, 5);
    canvas.drawPath(innerPath, innerPaint);
  }
  
  void _drawTriangularEar(Canvas canvas, Color outer, Color inner) {
    final outerPaint = Paint()..color = outer;
    final innerPaint = Paint()..color = inner;
    
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(-20, 35)
      ..lineTo(20, 35)
      ..close();
    canvas.drawPath(path, outerPaint);
    
    final innerPath = Path()
      ..moveTo(0, 8)
      ..lineTo(-12, 30)
      ..lineTo(12, 30)
      ..close();
    canvas.drawPath(innerPath, innerPaint);
  }
  
  void _drawLongEar(Canvas canvas, Color outer, Color inner) {
    final outerPaint = Paint()..color = outer;
    final innerPaint = Paint()..color = inner;
    
    final path = Path()
      ..moveTo(-12, 0)
      ..quadraticBezierTo(-15, -40, 0, -70)
      ..quadraticBezierTo(15, -40, 12, 0)
      ..close();
    canvas.drawPath(path, outerPaint);
    
    final innerPath = Path()
      ..moveTo(-6, 5)
      ..quadraticBezierTo(-8, -30, 0, -55)
      ..quadraticBezierTo(8, -30, 6, 5)
      ..close();
    canvas.drawPath(innerPath, innerPaint);
  }
  
  void _drawFluffyTail(Canvas canvas, Color color) {
    final tailGrad = Paint()
      ..shader = RadialGradient(
        colors: [color, color.withOpacity(0.8)],
      ).createShader(const Rect.fromLTWH(-25, -20, 50, 40));
    
    for (int i = -2; i <= 2; i++) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(i * 10.0, math.sin(breathPhase + i) * 3), width: 22, height: 38),
        tailGrad,
      );
    }
    
    // 条纹
    final stripePaint = Paint()..color = const Color(0xFFA08080);
    for (int i = -1; i <= 1; i++) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(i * 12.0, 0), width: 6, height: 28),
        stripePaint,
      );
    }
  }
  
  void _drawCatTail(Canvas canvas, Color color) {
    final tailGrad = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color, Color.lerp(color, Colors.white, 0.3)!],
      ).createShader(const Rect.fromLTWH(-8, -60, 16, 60));
    
    final path = Path()
      ..moveTo(-8, 0)
      ..quadraticBezierTo(15, -30, 0, -60)
      ..quadraticBezierTo(-15, -30, -8, 0);
    canvas.drawPath(path, tailGrad);
  }
  
  void _drawDragonTail(Canvas canvas, Color color) {
    final tailPaint = Paint()..color = color;
    
    final path = Path()
      ..moveTo(-10, 0)
      ..quadraticBezierTo(-30, -20, -25, -50)
      ..quadraticBezierTo(-20, -70, -10, -65);
    canvas.drawPath(path, tailPaint);
    
    // 背刺
    final spinePaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < 3; i++) {
      final y = -15 - i * 18;
      final path = Path()
        ..moveTo(-20 + i * 3, y)
        ..lineTo(-15 + i * 3, y - 12)
        ..lineTo(-10 + i * 3, y);
      canvas.drawPath(path, spinePaint);
    }
  }
  
  void _drawBunnyTail(Canvas canvas) {
    final tailPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(0, 0), 15, tailPaint);
  }
  
  void _drawFoxTail(Canvas canvas) {
    final tailGrad = Paint()
      ..shader = RadialGradient(
        colors: [secondaryColor, primaryColor],
      ).createShader(const Rect.fromLTWH(-30, -25, 60, 50));
    
    // 大毛茸茸的尾巴
    for (int i = -2; i <= 2; i++) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(i * 12.0, math.sin(breathPhase + i * 0.7) * 4), width: 28, height: 45),
        tailGrad,
      );
    }
    
    // 白色尖端
    final tipPaint = Paint()..color = Colors.white;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(-5, -22), width: 20, height: 25),
      tipPaint,
    );
  }
  
  void _drawWings(Canvas canvas) {
    final wingPaint = Paint()
      ..color = secondaryColor.withOpacity(0.6)
      ..style = PaintingStyle.fill];
    
    // 左翼
    canvas.save();
    canvas.translate(-50, -10);
    canvas.rotate(-0.3 + tailWag * 0.2);
    final leftWing = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(-40, -30, -50, 0)
      ..quadraticBezierTo(-40, 10, 0, 0);
    canvas.drawPath(leftWing, wingPaint);
    canvas.restore();
    
    // 右翼
    canvas.save();
    canvas.translate(50, -10);
    canvas.rotate(0.3 - tailWag * 0.2);
    final rightWing = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(40, -30, 50, 0)
      ..quadraticBezierTo(40, 10, 0, 0);
    canvas.drawPath(rightWing, wingPaint);
    canvas.restore();
  }
  
  void _drawCatEyes(Canvas canvas) {
    const eyeY = -18.0;
    const eyeSpacing = 20.0;
    
    // 猫眼形状
    final eyePaint = Paint()..color = const Color(0xFF2D1B4E);
    
    if (blinkProgress > 0.1) {
      // 竖瞳
      final leftEye = Path()
        ..moveTo(-eyeSpacing - 8, eyeY)
        ..quadraticBezierTo(-eyeSpacing, eyeY - 12 * blinkProgress, -eyeSpacing + 8, eyeY)
        ..quadraticBezierTo(-eyeSpacing, eyeY + 3 * blinkProgress, -eyeSpacing - 8, eyeY);
      canvas.drawPath(leftEye, eyePaint);
      
      final rightEye = Path()
        ..moveTo(eyeSpacing - 8, eyeY)
        ..quadraticBezierTo(eyeSpacing, eyeY - 12 * blinkProgress, eyeSpacing + 8, eyeY)
        ..quadraticBezierTo(eyeSpacing, eyeY + 3 * blinkProgress, eyeSpacing - 8, eyeY);
      canvas.drawPath(rightEye, eyePaint);
      
      // 高光
      final highlightPaint = Paint()..color = Colors.white.withOpacity(0.9);
      canvas.drawCircle(Offset(-eyeSpacing - 2, eyeY - 4), 2.5, highlightPaint);
      canvas.drawCircle(Offset(eyeSpacing - 2, eyeY - 4), 2.5, highlightPaint);
    }
  }
  
  void _drawDragonEyes(Canvas canvas) {
    const eyeY = -20.0;
    const eyeSpacing = 25.0;
    
    final eyePaint = Paint()..color = const Color(0xFFFFD700);
    final pupilPaint = Paint()..color = Colors.black;
    
    // 龙眼
    canvas.drawOval(
      Rect.fromCenter(center: Offset(-eyeSpacing, eyeY), width: 20, height: 14 * blinkProgress),
      eyePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(eyeSpacing, eyeY), width: 20, height: 14 * blinkProgress),
      eyePaint,
    );
    
    if (blinkProgress > 0.3) {
      // 竖瞳
      canvas.drawOval(
        Rect.fromCenter(center: Offset(-eyeSpacing, eyeY), width: 4, height: 10 * blinkProgress),
        pupilPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(eyeSpacing, eyeY), width: 4, height: 10 * blinkProgress),
        pupilPaint,
      );
    }
  }
  
  void _drawCatMouth(Canvas canvas) {
    final mouthPaint = Paint()
      ..color = const Color(0xFFD4A5A5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    // M 形嘴巴
    final path = Path()
      ..moveTo(-15, 5)
      ..lineTo(-5, 12)
      ..lineTo(0, 5)
      ..lineTo(5, 12)
      ..lineTo(15, 5);
    canvas.drawPath(path, mouthPaint);
  }
  
  void _drawFoxMouth(Canvas canvas) {
    final mouthPaint = Paint()
      ..color = const Color(0xFFD4A5A5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    
    // 狐狸嘴巴
    final path = Path()
      ..moveTo(-10, 3)
      ..quadraticBezierTo(0, 15, 10, 3);
    canvas.drawPath(path, mouthPaint);
    
    // 鼻子到嘴巴的线
    canvas.drawLine(Offset(0, -4), Offset(0, 5), mouthPaint);
  }
  
  void _drawDragonMouth(Canvas canvas) {
    final mouthPaint = Paint()
      ..color = const Color(0xFFE8A090)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    // 龙息效果
    final path = Path()
      ..moveTo(-15, 3)
      ..quadraticBezierTo(0, 18, 15, 3);
    canvas.drawPath(path, mouthPaint);
    
    // 火苗效果
    if (blinkProgress > 0.5) {
      final flamePaint = Paint()
        ..shader = RadialGradient(
          colors: [const Color(0xFFFF6B00), const Color(0xFFFFD700), Colors.transparent],
        ).createShader(const Rect.fromLTWH(-20, 5, 40, 30));
      
      canvas.drawOval(
        Rect.fromCenter(center: const Offset(0, 20), width: 25, height: 20),
        flamePaint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant PetSpeciesPainter oldDelegate) => true;
}
