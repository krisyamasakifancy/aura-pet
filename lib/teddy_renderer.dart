// ═══════════════════════════════════════════════════════════════════════════
// 🧸 ClassicTeddyBear Renderer - 经典泰迪熊 安静陪伴版
// Pure Brown #8B4513 | 眯眯眼 | 3D充气质感
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'dart:math' as math;

class ClassicTeddyBear extends StatefulWidget {
  final double size;
  final String mode; // default, notebook, sleepy, celebrate
  final Color? color;
  
  const ClassicTeddyBear({
    super.key,
    this.size = 150,
    this.mode = 'default',
    this.color,
  });
  
  @override
  State<ClassicTeddyBear> createState() => _ClassicTeddyBearState();
}

class _ClassicTeddyBearState extends State<ClassicTeddyBear>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
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
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: TeddyPainter(
            time: _controller.value,
            mode: widget.mode,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class TeddyPainter extends CustomPainter {
  final double time;
  final String mode;
  final Color? overrideColor;
  
  static const brown = Color(0xFF8B4513);
  static const brownLight = Color(0xFFA0522D);
  static const brownDark = Color(0xFF6B3410);
  static const noseColor = Color(0xFF4A2810);
  
  TeddyPainter({required this.time, this.mode = 'default', this.overrideColor});
  
  Color get mainBrown => overrideColor ?? brown;
  
  double get breathY => math.sin(time * 2 * math.pi) * 3;
  double get breathScale => 1 + math.sin(time * 2 * math.pi) * 0.03;
  
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    
    switch (mode) {
      case 'notebook':
        _drawNotebookMode(canvas, cx, cy);
        break;
      case 'sleepy':
        _drawSleepyMode(canvas, cx, cy);
        break;
      case 'celebrate':
        _drawCelebrateMode(canvas, cx, cy);
        break;
      default:
        _drawDefaultMode(canvas, cx, cy);
    }
  }
  
  void _drawDefaultMode(Canvas canvas, double cx, double cy) {
    final bodyCy = cy + 25 + breathY * 0.5;
    _drawBody(canvas, cx, bodyCy, 65, 50);
    _drawLegs(canvas, cx, bodyCy + 35, 13);
    _drawHead(canvas, cx, cy - 18 + breathY, 52);
    _drawArms(canvas, cx, bodyCy + 8, 11);
  }
  
  void _drawNotebookMode(Canvas canvas, double cx, double cy) {
    final bodyCy = cy + 28 + breathY * 0.5;
    _drawBody(canvas, cx, bodyCy, 60, 48);
    _drawLegs(canvas, cx, bodyCy + 32, 12);
    _drawHead(canvas, cx, cy - 12 + breathY, 48);
    _drawArms(canvas, cx, bodyCy + 5, 10);
    _drawNotebook(canvas, cx + 50, cy + 8, 38, 52);
  }
  
  void _drawSleepyMode(Canvas canvas, double cx, double cy) {
    final bellyBreath = math.sin(time * 1.5 * math.pi) * 4;
    final bodyCy = cy + 28;
    
    canvas.save();
    canvas.translate(cx, bodyCy);
    canvas.scale(1, 1 + bellyBreath * 0.025);
    canvas.translate(-cx, -bodyCy);
    _drawBody(canvas, cx, bodyCy, 68, 50);
    canvas.restore();
    
    _drawLegs(canvas, cx, bodyCy + 36, 14);
    _drawSleepyHead(canvas, cx, cy - 15 + breathY * 0.5, 50);
    _drawSleepHat(canvas, cx, cy - 60 + breathY * 0.5, 22);
  }
  
  void _drawCelebrateMode(Canvas canvas, double cx, double cy) {
    final bodyCy = cy + 28 + breathY * 0.5;
    _drawBody(canvas, cx, bodyCy, 65, 50);
    _drawLegs(canvas, cx, bodyCy + 35, 13);
    _drawHappyHead(canvas, cx, cy - 18 + breathY, 52);
    _drawCelebrateArms(canvas, cx, bodyCy - 5, 11);
  }
  
  void _drawBody(Canvas canvas, double cx, double cy, double w, double h) {
    final bw = w * breathScale;
    final bh = h * breathScale;
    
    final bodyGrad = RadialGradient(
      center: const Alignment(-0.3, -0.3),
      radius: 1.0,
      colors: [brownLight, mainBrown, brownDark],
    );
    
    final bodyPaint = Paint()
      ..shader = bodyGrad.createShader(Rect.fromCircle(center: Offset(cx, cy), radius: math.max(bw, bh)));
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: bw * 2, height: bh * 2), bodyPaint);
    
    // Inner shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 4);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 5), width: bw * 2, height: bh * 2), shadowPaint);
  }
  
  void _drawLegs(Canvas canvas, double cx, double cy, double size) {
    final legPaint = Paint()..color = mainBrown;
    
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - 28, cy), width: size * 2.2, height: size * 1.8),
      legPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + 28, cy), width: size * 2.2, height: size * 1.8),
      legPaint,
    );
  }
  
  void _drawHead(Canvas canvas, double cx, double cy, double size) {
    // Ears
    _drawEar(canvas, cx - size * 0.85, cy - size * 0.65, size * 0.35);
    _drawEar(canvas, cx + size * 0.85, cy - size * 0.65, size * 0.35);
    
    // Head
    final headGrad = RadialGradient(
      center: const Alignment(-0.3, -0.3),
      radius: 1.0,
      colors: [brownLight, mainBrown],
    );
    final headPaint = Paint()
      ..shader = headGrad.createShader(Rect.fromCircle(center: Offset(cx, cy), radius: size));
    canvas.drawCircle(Offset(cx, cy), size, headPaint);
    
    // Inner shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 3);
    canvas.drawCircle(Offset(cx, cy + size * 0.1), size, shadowPaint);
    
    // Mochi Eyes - 眯眯眼
    _drawMochiEyes(canvas, cx, cy - size * 0.08, size * 0.18);
    
    // Nose
    _drawNose(canvas, cx, cy + size * 0.2, size * 0.12);
    
    // Y Smile
    _drawYSmile(canvas, cx, cy + size * 0.38, size * 0.18);
  }
  
  void _drawHappyHead(Canvas canvas, double cx, double cy, double size) {
    _drawHead(canvas, cx, cy, size);
    // Happy eyes - bigger smile
    _drawHappyMochiEyes(canvas, cx, cy - size * 0.08, size * 0.2);
  }
  
  void _drawSleepyHead(Canvas canvas, double cx, double cy, double size) {
    _drawEar(canvas, cx - size * 0.85, cy - size * 0.6, size * 0.32);
    _drawEar(canvas, cx + size * 0.85, cy - size * 0.6, size * 0.32);
    
    final headGrad = RadialGradient(
      center: const Alignment(-0.3, -0.3),
      radius: 1.0,
      colors: [brownLight, mainBrown],
    );
    final headPaint = Paint()
      ..shader = headGrad.createShader(Rect.fromCircle(center: Offset(cx, cy), radius: size));
    canvas.drawCircle(Offset(cx, cy), size, headPaint);
    
    // Closed eyes - curved lines
    final eyePaint = Paint()
      ..color = noseColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    
    final leftEyePath = Path();
    leftEyePath.moveTo(cx - size * 0.5, cy - size * 0.05);
    leftEyePath.quadraticBezierTo(cx - size * 0.3, cy - size * 0.2, cx - size * 0.1, cy - size * 0.05);
    canvas.drawPath(leftEyePath, eyePaint);
    
    final rightEyePath = Path();
    rightEyePath.moveTo(cx + size * 0.1, cy - size * 0.05);
    rightEyePath.quadraticBezierTo(cx + size * 0.3, cy - size * 0.2, cx + size * 0.5, cy - size * 0.05);
    canvas.drawPath(rightEyePath, eyePaint);
    
    _drawNose(canvas, cx, cy + size * 0.2, size * 0.12);
    _drawYSmile(canvas, cx, cy + size * 0.38, size * 0.18);
  }
  
  void _drawEar(Canvas canvas, double cx, double cy, double size) {
    final earGrad = RadialGradient(
      center: const Alignment(-0.3, -0.3),
      radius: 1.0,
      colors: [brownLight, mainBrown],
    );
    final earPaint = Paint()
      ..shader = earGrad.createShader(Rect.fromCircle(center: Offset(cx, cy), radius: size));
    canvas.drawCircle(Offset(cx, cy), size, earPaint);
  }
  
  void _drawArms(Canvas canvas, double cx, double cy, double size) {
    final armPaint = Paint()..color = mainBrown;
    
    // Left arm
    canvas.save();
    canvas.translate(cx - size * 4, cy);
    canvas.rotate(-0.3);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: size * 1.8, height: size * 2), armPaint);
    canvas.restore();
    
    // Right arm
    canvas.save();
    canvas.translate(cx + size * 4, cy);
    canvas.rotate(0.3);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: size * 1.8, height: size * 2), armPaint);
    canvas.restore();
  }
  
  void _drawCelebrateArms(Canvas canvas, double cx, double cy, double size) {
    final armPaint = Paint()..color = mainBrown;
    
    // Left arm - raised
    canvas.save();
    canvas.translate(cx - size * 4, cy);
    canvas.rotate(-1.2);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: size * 1.8, height: size * 2), armPaint);
    canvas.restore();
    
    // Right arm - raised
    canvas.save();
    canvas.translate(cx + size * 4, cy);
    canvas.rotate(1.2);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: size * 1.8, height: size * 2), armPaint);
    canvas.restore();
  }
  
  void _drawMochiEyes(Canvas canvas, double cx, double cy, double size) {
    final eyePaint = Paint()
      ..color = noseColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    
    // Left eye - curved line
    final leftEyePath = Path();
    leftEyePath.moveTo(cx - size * 1.2, cy);
    leftEyePath.arcToPoint(
      Offset(cx - size * 0.3, cy - size * 0.3),
      radius: Radius.circular(size * 0.5),
      clockwise: false,
    );
    canvas.drawPath(leftEyePath, eyePaint);
    
    // Right eye
    final rightEyePath = Path();
    rightEyePath.moveTo(cx + size * 0.3, cy - size * 0.3);
    rightEyePath.arcToPoint(
      Offset(cx + size * 1.2, cy),
      radius: Radius.circular(size * 0.5),
      clockwise: false,
    );
    canvas.drawPath(rightEyePath, eyePaint);
  }
  
  void _drawHappyMochiEyes(Canvas canvas, double cx, double cy, double size) {
    final eyePaint = Paint()
      ..color = noseColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    // Bigger smile eyes
    final leftEyePath = Path();
    leftEyePath.moveTo(cx - size * 1.3, cy);
    leftEyePath.arcToPoint(
      Offset(cx - size * 0.2, cy - size * 0.4),
      radius: Radius.circular(size * 0.6),
      clockwise: false,
    );
    canvas.drawPath(leftEyePath, eyePaint);
    
    final rightEyePath = Path();
    rightEyePath.moveTo(cx + size * 0.2, cy - size * 0.4);
    rightEyePath.arcToPoint(
      Offset(cx + size * 1.3, cy),
      radius: Radius.circular(size * 0.6),
      clockwise: false,
    );
    canvas.drawPath(rightEyePath, eyePaint);
  }
  
  void _drawNose(Canvas canvas, double cx, double cy, double size) {
    final nosePaint = Paint()..color = noseColor;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: size * 2, height: size * 1.5),
      nosePaint,
    );
    
    // Highlight
    final highlightPaint = Paint()..color = Colors.white.withValues(alpha: 0.2);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - size * 0.3, cy - size * 0.3), width: size * 0.6, height: size * 0.4),
      highlightPaint,
    );
  }
  
  void _drawYSmile(Canvas canvas, double cx, double cy, double size) {
    final smilePaint = Paint()
      ..color = noseColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    // Left Y
    final leftY = Path();
    leftY.moveTo(cx - size, cy - size * 0.5);
    leftY.lineTo(cx - size * 0.3, cy);
    leftY.lineTo(cx - size * 0.6, cy + size * 0.8);
    canvas.drawPath(leftY, smilePaint);
    
    // Right Y
    final rightY = Path();
    rightY.moveTo(cx + size, cy - size * 0.5);
    rightY.lineTo(cx + size * 0.3, cy);
    rightY.lineTo(cx + size * 0.6, cy + size * 0.8);
    canvas.drawPath(rightY, smilePaint);
    
    // Smile arc
    final arcPath = Path();
    arcPath.moveTo(cx - size * 0.3, cy);
    arcPath.quadraticBezierTo(cx, cy + size * 0.3, cx + size * 0.3, cy);
    canvas.drawPath(arcPath, smilePaint);
  }
  
  void _drawSleepHat(Canvas canvas, double cx, double cy, double size) {
    final hatPath = Path();
    hatPath.moveTo(cx, cy - size * 1.4);
    hatPath.quadraticBezierTo(cx - size * 0.7, cy - size * 0.4, cx - size * 0.5, cy + size * 0.2);
    hatPath.lineTo(cx + size * 0.5, cy + size * 0.2);
    hatPath.quadraticBezierTo(cx + size * 0.7, cy - size * 0.4, cx, cy - size * 1.4);
    hatPath.close();
    
    final hatPaint = Paint()..color = mainBrown;
    canvas.drawPath(hatPath, hatPaint);
    
    // Brim
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + size * 0.15), width: size * 1.4, height: size * 0.4),
      Paint()..color = brownDark,
    );
    
    // Pom pom
    canvas.drawCircle(Offset(cx, cy - size * 1.5), size * 0.3, hatPaint);
  }
  
  void _drawNotebook(Canvas canvas, double cx, double cy, double w, double h) {
    // Cover
    final coverPaint = Paint()..color = mainBrown;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy), width: w, height: h), const Radius.circular(6)),
      coverPaint,
    );
    
    // Spine
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy), width: w, height: h), const Radius.circular(6)),
      Paint()
        ..color = brownDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    
    // Spiral rings
    final ringPaint = Paint()..color = brownDark;
    for (int i = 0; i < 4; i++) {
      canvas.drawCircle(
        Offset(cx - w/2 - 2, cy - h/2 + 12 + i * 16),
        3,
        ringPaint,
      );
    }
    
    // Paper
    final paperPaint = Paint()..color = const Color(0xFFF5F0E8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - w/2 + 8, cy - h/2 + 8, w - 16, h - 16), const Radius.circular(3)),
      paperPaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant TeddyPainter oldDelegate) {
    return oldDelegate.time != time || oldDelegate.mode != mode;
  }
}
