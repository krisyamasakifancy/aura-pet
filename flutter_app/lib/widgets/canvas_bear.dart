import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Bear mood states for Canvas animation
enum BearMood {
  defaultMood,    // Default friendly
  heartEyes,      // 😍 Excited
  sleeping,       // 😴 Sleeping
  diving,         // 🤿 Diving with goggles
  heartHand,      // 🤗 Heart hand gesture
  sunglasses,      // 😎 Cool with sunglasses
  curious,        // 🤔 Curious
  celebrating,    // 🎉 Celebrating
 潜水,           // Diving
}

/// Canvas-drawn bear mascot for BitePal
class CanvasBear extends StatefulWidget {
  final BearMood mood;
  final double size;
  final bool animated;
  
  const CanvasBear({
    super.key,
    this.mood = BearMood.defaultMood,
    this.size = 200,
    this.animated = true,
  });
  
  @override
  State<CanvasBear> createState() => _CanvasBearState();
}

class _CanvasBearState extends State<CanvasBear> 
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _breathController;
  late AnimationController _heartController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _breathAnimation;
  late Animation<double> _heartAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
    
    _breathController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);
    _breathAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
    
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _heartAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
    );
    
    if (widget.animated) {
      _bounceController.forward();
    }
  }
  
  @override
  void dispose() {
    _bounceController.dispose();
    _breathController.dispose();
    _heartController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _bounceAnimation,
        _breathAnimation,
        _heartAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value * _breathAnimation.value,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _BearPainter(
              mood: widget.mood,
              heartScale: _heartAnimation.value,
            ),
          ),
        );
      },
    );
  }
}

class _BearPainter extends CustomPainter {
  final BearMood mood;
  final double heartScale;
  
  _BearPainter({required this.mood, this.heartScale = 1.0});
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width / 200; // Base scale factor
    
    // Bear colors
    final bearColor = const Color(0xFF9E9E9E); // Gray
    final darkColor = const Color(0xFF424242); // Dark gray for ears/tail
    final pinkColor = const Color(0xFFFFCDD2); // Pink blush
    final whiteColor = Colors.white;
    
    // Draw based on mood
    switch (mood) {
      case BearMood.heartEyes:
        _drawHeartEyesBear(canvas, center, scale, bearColor, darkColor, pinkColor);
        break;
      case BearMood.sleeping:
        _drawSleepingBear(canvas, center, scale, bearColor, darkColor, pinkColor);
        break;
      case BearMood.diving:
      case BearMood.潜水:
        _drawDivingBear(canvas, center, scale, bearColor, darkColor, pinkColor);
        break;
      case BearMood.heartHand:
        _drawHeartHandBear(canvas, center, scale, bearColor, darkColor, pinkColor);
        break;
      case BearMood.sunglasses:
        _drawSunglassesBear(canvas, center, scale, bearColor, darkColor, pinkColor);
        break;
      case BearMood.curious:
        _drawCuriousBear(canvas, center, scale, bearColor, darkColor, pinkColor);
        break;
      case BearMood.celebrating:
        _drawCelebratingBear(canvas, center, scale, bearColor, darkColor, pinkColor);
        break;
      default:
        _drawDefaultBear(canvas, center, scale, bearColor, darkColor, pinkColor);
    }
  }
  
  void _drawDefaultBear(Canvas canvas, Offset center, double scale,
      Color bearColor, Color darkColor, Color pinkColor) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Ears
    paint.color = bearColor;
    canvas.drawCircle(Offset(center.dx - 55 * scale, center.dy - 55 * scale), 30 * scale, paint);
    canvas.drawCircle(Offset(center.dx + 55 * scale, center.dy - 55 * scale), 30 * scale, paint);
    
    // Inner ears
    paint.color = pinkColor;
    canvas.drawCircle(Offset(center.dx - 55 * scale, center.dy - 55 * scale), 15 * scale, paint);
    canvas.drawCircle(Offset(center.dx + 55 * scale, center.dy - 55 * scale), 15 * scale, paint);
    
    // Head
    paint.color = bearColor;
    canvas.drawCircle(center, 70 * scale, paint);
    
    // Face mask (raccoon style)
    paint.color = darkColor;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy - 5 * scale), 
          width: 80 * scale, height: 40 * scale),
      paint,
    );
    
    // Eyes
    paint.color = whiteColor;
    canvas.drawCircle(Offset(center.dx - 25 * scale, center.dy - 15 * scale), 12 * scale, paint);
    canvas.drawCircle(Offset(center.dx + 25 * scale, center.dy - 15 * scale), 12 * scale, paint);
    
    // Pupils
    paint.color = darkColor;
    canvas.drawCircle(Offset(center.dx - 25 * scale, center.dy - 15 * scale), 6 * scale, paint);
    canvas.drawCircle(Offset(center.dx + 25 * scale, center.dy - 15 * scale), 6 * scale, paint);
    
    // Nose
    paint.color = darkColor;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 10 * scale), 
          width: 20 * scale, height: 12 * scale),
      paint,
    );
    
    // Mouth (smile)
    final mouthPaint = Paint()
      ..color = darkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * scale;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 25 * scale), 
          width: 30 * scale, height: 20 * scale),
      0.2, 2.7, false, mouthPaint,
    );
    
    // Blush
    paint.color = pinkColor;
    paint.style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx - 50 * scale, center.dy + 5 * scale), 
          width: 25 * scale, height: 15 * scale),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx + 50 * scale, center.dy + 5 * scale), 
          width: 25 * scale, height: 15 * scale),
      paint,
    );
    
    // Heart on chest
    _drawHeart(canvas, Offset(center.dx, center.dy + 70 * scale), 15 * scale, 
        const Color(0xFFE91E63));
  }
  
  void _drawHeartEyesBear(Canvas canvas, Offset center, double scale,
      Color bearColor, Color darkColor, Color pinkColor) {
    _drawDefaultBear(canvas, center, scale, bearColor, darkColor, pinkColor);
    
    // Replace eyes with heart eyes
    _drawHeart(canvas, Offset(center.dx - 25 * scale, center.dy - 15 * scale), 
        14 * scale * heartScale, const Color(0xFFE91E63));
    _drawHeart(canvas, Offset(center.dx + 25 * scale, center.dy - 15 * scale), 
        14 * scale * heartScale, const Color(0xFFE91E63));
  }
  
  void _drawSleepingBear(Canvas canvas, Offset center, double scale,
      Color bearColor, Color darkColor, Color pinkColor) {
    _drawDefaultBear(canvas, center, scale, bearColor, darkColor, pinkColor);
    
    // Sleep cap
    final capPaint = Paint()..color = const Color(0xFFE1BEE7);
    final capPath = Path()
      ..moveTo(center.dx - 60 * scale, center.dy - 50 * scale)
      ..lineTo(center.dx, center.dy - 120 * scale)
      ..lineTo(center.dx + 60 * scale, center.dy - 50 * scale)
      ..close();
    canvas.drawPath(capPath, capPaint);
    
    // Sleep cap ball
    canvas.drawCircle(Offset(center.dx, center.dy - 120 * scale), 12 * scale, capPaint);
    
    // Closed eyes (sleeping)
    final eyePaint = Paint()
      ..color = darkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * scale;
    
    // Left eye (closed)
    canvas.drawArc(
      Rect.fromCenter(center: Offset(center.dx - 25 * scale, center.dy - 15 * scale),
          width: 20 * scale, height: 5 * scale),
      0, 3.14, false, eyePaint,
    );
    
    // Right eye (closed)
    canvas.drawArc(
      Rect.fromCenter(center: Offset(center.dx + 25 * scale, center.dy - 15 * scale),
          width: 20 * scale, height: 5 * scale),
      0, 3.14, false, eyePaint,
    );
    
    // Zzz
    final zPaint = Paint()
      ..color = darkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(center.dx + 50 * scale, center.dy - 100 * scale, 
              20 * scale, 25 * scale), 
          Radius.circular(3 * scale)),
      zPaint,
    );
  }
  
  void _drawDivingBear(Canvas canvas, Offset center, double scale,
      Color bearColor, Color darkColor, Color pinkColor) {
    // Swimming goggles
    final gogglePaint = Paint()..color = const Color(0xFF2196F3);
    
    // Left goggle
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx - 25 * scale, center.dy - 15 * scale),
          width: 35 * scale, height: 25 * scale),
      gogglePaint,
    );
    
    // Right goggle
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx + 25 * scale, center.dy - 15 * scale),
          width: 35 * scale, height: 25 * scale),
      gogglePaint,
    );
    
    // Goggle straps
    final strapPaint = Paint()
      ..color = darkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * scale;
    canvas.drawLine(
      Offset(center.dx - 55 * scale, center.dy - 15 * scale),
      Offset(center.dx + 55 * scale, center.dy - 15 * scale),
      strapPaint,
    );
    
    // Bubble hearts
    _drawHeart(canvas, Offset(center.dx - 60 * scale, center.dy + 40 * scale), 
        10 * scale, const Color(0xFF2196F3).withOpacity(0.6));
    _drawHeart(canvas, Offset(center.dx + 50 * scale, center.dy + 30 * scale), 
        8 * scale, const Color(0xFF2196F3).withOpacity(0.6));
  }
  
  void _drawHeartHandBear(Canvas canvas, Offset center, double scale,
      Color bearColor, Color darkColor, Color pinkColor) {
    _drawDefaultBear(canvas, center, scale, bearColor, darkColor, pinkColor);
    
    // Draw heart hand gesture
    _drawHeart(canvas, Offset(center.dx, center.dy - 50 * scale), 
        30 * scale * heartScale, const Color(0xFFE91E63));
  }
  
  void _drawSunglassesBear(Canvas canvas, Offset center, double scale,
      Color bearColor, Color darkColor, Color pinkColor) {
    _drawDefaultBear(canvas, center, scale, bearColor, darkColor, pinkColor);
    
    // Star sunglasses
    final glassPaint = Paint()..color = const Color(0xFFFFEB3B);
    
    // Left glass
    _drawStar(canvas, Offset(center.dx - 25 * scale, center.dy - 15 * scale), 
        20 * scale, glassPaint);
    
    // Right glass
    _drawStar(canvas, Offset(center.dx + 25 * scale, center.dy - 15 * scale), 
        20 * scale, glassPaint);
    
    // Bridge
    final bridgePaint = Paint()
      ..color = darkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * scale;
    canvas.drawLine(
      Offset(center.dx - 8 * scale, center.dy - 15 * scale),
      Offset(center.dx + 8 * scale, center.dy - 15 * scale),
      bridgePaint,
    );
    
    // Celebration elements
    _drawStar(canvas, Offset(center.dx - 50 * scale, center.dy - 80 * scale), 
        10 * scale, const Color(0xFFFFEB3B));
    _drawStar(canvas, Offset(center.dx + 50 * scale, center.dy - 70 * scale), 
        12 * scale, const Color(0xFFE91E63));
  }
  
  void _drawCuriousBear(Canvas canvas, Offset center, double scale,
      Color bearColor, Color darkColor, Color pinkColor) {
    _drawDefaultBear(canvas, center, scale, bearColor, darkColor, pinkColor);
    
    // Question mark above head
    final qPaint = Paint()
      ..color = const Color(0xFF2196F3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 * scale;
    
    final qPath = Path()
      ..moveTo(center.dx + 40 * scale, center.dy - 100 * scale)
      ..quadraticBezierTo(center.dx + 60 * scale, center.dy - 90 * scale, 
          center.dx + 50 * scale, center.dy - 70 * scale)
      ..quadraticBezierTo(center.dx + 45 * scale, center.dy - 55 * scale, 
          center.dx + 55 * scale, center.dy - 45 * scale);
    canvas.drawPath(qPath, qPaint);
  }
  
  void _drawCelebratingBear(Canvas canvas, Offset center, double scale,
      Color bearColor, Color darkColor, Color pinkColor) {
    _drawDefaultBear(canvas, center, scale, bearColor, darkColor, pinkColor);
    
    // Raised arms celebration
    final armPaint = Paint()
      ..color = bearColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15 * scale
      ..strokeCap = StrokeCap.round;
    
    // Left arm up
    canvas.drawLine(
      Offset(center.dx - 70 * scale, center.dy),
      Offset(center.dx - 90 * scale, center.dy - 50 * scale),
      armPaint,
    );
    
    // Right arm up
    canvas.drawLine(
      Offset(center.dx + 70 * scale, center.dy),
      Offset(center.dx + 90 * scale, center.dy - 50 * scale),
      armPaint,
    );
    
    // Confetti/stars around
    _drawStar(canvas, Offset(center.dx - 60 * scale, center.dy - 60 * scale), 
        12 * scale, const Color(0xFFFFEB3B));
    _drawStar(canvas, Offset(center.dx + 60 * scale, center.dy - 70 * scale), 
        10 * scale, const Color(0xFFE91E63));
    _drawStar(canvas, Offset(center.dx, center.dy - 100 * scale), 
        15 * scale, const Color(0xFF4CAF50));
  }
  
  void _drawHeart(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final path = Path()
      ..moveTo(center.dx, center.dy + size * 0.3)
      ..cubicTo(
        center.dx - size, center.dy - size * 0.5,
        center.dx - size, center.dy - size,
        center.dx, center.dy - size * 0.5,
      )
      ..cubicTo(
        center.dx + size, center.dy - size,
        center.dx + size, center.dy - size * 0.5,
        center.dx, center.dy + size * 0.3,
      );
    
    canvas.drawPath(path, paint);
  }
  
  void _drawStar(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * math.pi / 5) - math.pi / 2;
      final point = Offset(
        center.dx + size * math.cos(angle),
        center.dy + size * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(_BearPainter oldDelegate) => 
      oldDelegate.mood != mood || oldDelegate.heartScale != heartScale;
}
