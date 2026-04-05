import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Canvas Bear - 6 Mood States for BitePal
/// P01: Rolling eyes (splash)
/// P02: HeartEyes (welcome)
/// P03: Excited/HandsTogether (calories)
/// P04: Sleeping (fasting)
/// P05: HeartEyes (results)
/// P06: Diving (water)
/// P07: HeartEyes (nutrition)
/// P17-P21: Various loading states
/// P35: Nightcap sleeping (fasting)
enum BearMood {
  rollingEyes,  // P01 Splash
  heartEyes,   // P02,P05,P07 Welcome/Results/Nutrition
  excited,     // P03 Calories feature
  sleeping,    // P04,P35 Fasting
  celebrating, // P18,P41 Goal celebration
  diving,      // P06 Water
  curious,     // P12,P13 Age/Height
  expecting,   // P15 Goal weight
  thinking,    // P21 Plan loading
  heartHand,  // P46 About/Goodbye
  sunglasses,  // P22 Weight prediction
  defaultMood, // Generic
}

/// Canvas-drawn Bear mascot with 6 mood states
class CanvasBear extends StatefulWidget {
  final BearMood mood;
  final double size;
  final bool animate;
  final Color? accentColor;
  
  const CanvasBear({
    super.key,
    this.mood = BearMood.defaultMood,
    this.size = 120,
    this.animate = true,
    this.accentColor,
  });

  @override
  State<CanvasBear> createState() => _CanvasBearState();
}

class _CanvasBearState extends State<CanvasBear> 
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _breathController;
  late AnimationController _heartController;
  late Animation<double> _bounce;
  late Animation<double> _breath;
  late Animation<double> _heart;

  @override
  void initState() {
    super.initState();
    
    // Bounce animation for idle movement
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _bounce = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    // Breathing animation
    _breathController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);
    
    _breath = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    // Heart floating animation
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _heart = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
    );
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
      animation: Listenable.merge([_bounce, _breath, _heart]),
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _BearPainter(
            mood: widget.mood,
            bounceOffset: widget.animate ? _bounce.value : 0,
            breathScale: widget.animate ? _breath.value : 1.0,
            heartScale: widget.animate ? _heart.value : 1.0,
            accentColor: widget.accentColor,
          ),
        );
      },
    );
  }
}

class _BearPainter extends CustomPainter {
  final BearMood mood;
  final double bounceOffset;
  final double breathScale;
  final double heartScale;
  final Color? accentColor;

  _BearPainter({
    required this.mood,
    required this.bounceOffset,
    required this.breathScale,
    required this.heartScale,
    this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final bearSize = size.width * 0.35;
    
    // Apply breathing scale
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(breathScale);
    canvas.translate(-center.dx, -center.dy);

    // Body
    final bodyPaint = Paint()
      ..color = const Color(0xFF8B7355) // Bear brown
      ..style = PaintingStyle.fill;
    
    // Draw body (oval)
    final bodyRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + bearSize * 0.3 + bounceOffset),
      width: bearSize * 1.8,
      height: bearSize * 1.4,
    );
    canvas.drawOval(bodyRect, bodyPaint);

    // Head
    final headRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - bearSize * 0.1 + bounceOffset),
      width: bearSize * 1.6,
      height: bearSize * 1.5,
    );
    canvas.drawOval(headRect, bodyPaint);

    // Ears
    final earPaint = Paint()..color = const Color(0xFF8B7355)..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx - bearSize * 0.6, center.dy - bearSize * 0.65 + bounceOffset),
      bearSize * 0.25, earPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + bearSize * 0.6, center.dy - bearSize * 0.65 + bounceOffset),
      bearSize * 0.25, earPaint,
    );

    // Inner ears (lighter)
    final innerEarPaint = Paint()..color = const Color(0xFFD4A574)..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx - bearSize * 0.6, center.dy - bearSize * 0.65 + bounceOffset),
      bearSize * 0.12, innerEarPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + bearSize * 0.6, center.dy - bearSize * 0.65 + bounceOffset),
      bearSize * 0.12, innerEarPaint,
    );

    // Muzzle
    final muzzlePaint = Paint()..color = const Color(0xFFD4A574)..style = PaintingStyle.fill;
    final muzzleRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + bearSize * 0.15 + bounceOffset),
      width: bearSize * 0.6,
      height: bearSize * 0.5,
    );
    canvas.drawOval(muzzleRect, muzzlePaint);

    // Draw mood-specific features
    _drawMoodFeatures(canvas, size, center, bearSize);

    canvas.restore();

    // Draw mood-specific decorations (hearts, bubbles, etc.)
    _drawMoodDecorations(canvas, size, center, bearSize);
  }

  void _drawMoodFeatures(Canvas canvas, Size size, Offset center, double bearSize) {
    switch (mood) {
      case BearMood.rollingEyes:
        _drawRollingEyes(canvas, center, bearSize);
        break;
      case BearMood.heartEyes:
        _drawHeartEyes(canvas, center, bearSize);
        break;
      case BearMood.excited:
        _drawExcitedFace(canvas, center, bearSize);
        break;
      case BearMood.sleeping:
        _drawSleepingFace(canvas, center, bearSize);
        break;
      case BearMood.celebrating:
        _drawCelebratingFace(canvas, center, bearSize);
        break;
      case BearMood.diving:
        _drawDivingFace(canvas, center, bearSize);
        break;
      case BearMood.curious:
        _drawCuriousFace(canvas, center, bearSize);
        break;
      case BearMood.expecting:
        _drawExpectingFace(canvas, center, bearSize);
        break;
      case BearMood.thinking:
        _drawThinkingFace(canvas, center, bearSize);
        break;
      case BearMood.heartHand:
        _drawHeartHandFace(canvas, center, bearSize);
        break;
      case BearMood.sunglasses:
        _drawSunglassesFace(canvas, center, bearSize);
        break;
      default:
        _drawDefaultFace(canvas, center, bearSize);
    }
  }

  void _drawRollingEyes(Canvas canvas, Offset center, double bearSize) {
    // Rolling eyes (white part)
    final eyeWhitePaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - bearSize * 0.3, center.dy - bearSize * 0.15 + bounceOffset),
        width: bearSize * 0.35,
        height: bearSize * 0.35,
      ),
      eyeWhitePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + bearSize * 0.3, center.dy - bearSize * 0.15 + bounceOffset),
        width: bearSize * 0.35,
        height: bearSize * 0.35,
      ),
      eyeWhitePaint,
    );

    // Pupils looking up (rolling effect)
    final pupilPaint = Paint()..color = Colors.black..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx - bearSize * 0.3, center.dy - bearSize * 0.25 + bounceOffset),
      bearSize * 0.1, pupilPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + bearSize * 0.3, center.dy - bearSize * 0.25 + bounceOffset),
      bearSize * 0.1, pupilPaint,
    );

    // Big smile
    final smilePaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    final smilePath = Path();
    smilePath.moveTo(center.dx - bearSize * 0.3, center.dy + bearSize * 0.2 + bounceOffset);
    smilePath.quadraticBezierTo(
      center.dx, center.dy + bearSize * 0.4 + bounceOffset,
      center.dx + bearSize * 0.3, center.dy + bearSize * 0.2 + bounceOffset,
    );
    canvas.drawPath(smilePath, smilePaint);

    // Tongue sticking out
    final tonguePaint = Paint()..color = Colors.pink..style = PaintingStyle.fill;
    final tongueRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + bearSize * 0.35 + bounceOffset),
      width: bearSize * 0.2,
      height: bearSize * 0.15,
    );
    canvas.drawOval(tongueRect, tonguePaint);
  }

  void _drawHeartEyes(Canvas canvas, Offset center, double bearSize) {
    // Heart-shaped eyes
    final heartPaint = Paint()..color = Colors.pink.shade400..style = PaintingStyle.fill;
    
    // Left heart eye
    _drawHeart(canvas, 
      Offset(center.dx - bearSize * 0.28, center.dy - bearSize * 0.15 + bounceOffset),
      bearSize * 0.18, heartPaint);
    
    // Right heart eye
    _drawHeart(canvas,
      Offset(center.dx + bearSize * 0.28, center.dy - bearSize * 0.15 + bounceOffset),
      bearSize * 0.18, heartPaint);

    // Blush
    final blushPaint = Paint()..color = Colors.pink.shade100..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - bearSize * 0.5, center.dy + bounceOffset),
        width: bearSize * 0.25,
        height: bearSize * 0.15,
      ),
      blushPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + bearSize * 0.5, center.dy + bounceOffset),
        width: bearSize * 0.25,
        height: bearSize * 0.15,
      ),
      blushPaint,
    );

    // Happy smile
    _drawHappyMouth(canvas, center, bearSize);
  }

  void _drawExcitedFace(Canvas canvas, Offset center, double bearSize) {
    // Wide excited eyes
    final eyeWhitePaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - bearSize * 0.3, center.dy - bearSize * 0.15 + bounceOffset),
        width: bearSize * 0.4,
        height: bearSize * 0.45,
      ),
      eyeWhitePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + bearSize * 0.3, center.dy - bearSize * 0.15 + bounceOffset),
        width: bearSize * 0.4,
        height: bearSize * 0.45,
      ),
      eyeWhitePaint,
    );

    // Pupils looking at food
    final pupilPaint = Paint()..color = Colors.black..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx - bearSize * 0.25, center.dy - bearSize * 0.1 + bounceOffset),
      bearSize * 0.12, pupilPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + bearSize * 0.35, center.dy - bearSize * 0.1 + bounceOffset),
      bearSize * 0.12, pupilPaint,
    );

    // Hands together (praying gesture)
    _drawHandsTogether(canvas, center, bearSize);

    // Open happy mouth
    final mouthPaint = Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.fill;
    final mouthRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + bearSize * 0.25 + bounceOffset),
      width: bearSize * 0.35,
      height: bearSize * 0.25,
    );
    canvas.drawOval(mouthRect, mouthPaint);
  }

  void _drawSleepingFace(Canvas canvas, Offset center, double bearSize) {
    // Closed eyes (sleeping)
    final eyePaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    // Left closed eye
    canvas.drawLine(
      Offset(center.dx - bearSize * 0.4, center.dy - bearSize * 0.1 + bounceOffset),
      Offset(center.dx - bearSize * 0.15, center.dy - bearSize * 0.1 + bounceOffset),
      eyePaint,
    );
    // Right closed eye
    canvas.drawLine(
      Offset(center.dx + bearSize * 0.15, center.dy - bearSize * 0.1 + bounceOffset),
      Offset(center.dx + bearSize * 0.4, center.dy - bearSize * 0.1 + bounceOffset),
      eyePaint,
    );

    // Peaceful smile
    _drawHappyMouth(canvas, center, bearSize);

    // ZZZ floating
    _drawZZZ(canvas, center, bearSize);

    // Nightcap
    _drawNightcap(canvas, center, bearSize);
  }

  void _drawCelebratingFace(Canvas canvas, Offset center, double bearSize) {
    // Star eyes
    _drawStarEyes(canvas, center, bearSize);

    // Big open smile
    final mouthPaint = Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.fill;
    final mouthPath = Path();
    mouthPath.moveTo(center.dx - bearSize * 0.3, center.dy + bearSize * 0.15 + bounceOffset);
    mouthPath.quadraticBezierTo(
      center.dx, center.dy + bearSize * 0.4 + bounceOffset,
      center.dx + bearSize * 0.3, center.dy + bearSize * 0.15 + bounceOffset,
    );
    mouthPath.close();
    canvas.drawPath(mouthPath, mouthPaint);

    // Raised arms (celebrating)
    _drawRaisedArms(canvas, center, bearSize);
  }

  void _drawDivingFace(Canvas canvas, Offset center, double bearSize) {
    // Goggles
    _drawDivingGoggles(canvas, center, bearSize);

    // Tube in mouth
    _drawBreathingTube(canvas, center, bearSize);

    // Flippers at bottom
    _drawFlippers(canvas, center, bearSize);
  }

  void _drawCuriousFace(Canvas canvas, Offset center, double bearSize) {
    // Curious eyes (one bigger)
    final eyeWhitePaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - bearSize * 0.3, center.dy - bearSize * 0.15 + bounceOffset),
        width: bearSize * 0.38,
        height: bearSize * 0.42,
      ),
      eyeWhitePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + bearSize * 0.3, center.dy - bearSize * 0.15 + bounceOffset),
        width: bearSize * 0.35,
        height: bearSize * 0.38,
      ),
      eyeWhitePaint,
    );

    // Curious pupils
    final pupilPaint = Paint()..color = Colors.black..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx - bearSize * 0.25, center.dy - bearSize * 0.12 + bounceOffset),
      bearSize * 0.12, pupilPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + bearSize * 0.3, center.dy - bearSize * 0.15 + bounceOffset),
      bearSize * 0.1, pupilPaint,
    );

    // Small 'o' mouth
    final mouthPaint = Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx, center.dy + bearSize * 0.25 + bounceOffset),
      bearSize * 0.08, mouthPaint,
    );
  }

  void _drawExpectingFace(Canvas canvas, Offset center, double bearSize) {
    // Hopeful eyes
    _drawHeartEyes(canvas, center, bearSize);

    // Small smile
    final smilePaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    final smilePath = Path();
    smilePath.moveTo(center.dx - bearSize * 0.2, center.dy + bearSize * 0.2 + bounceOffset);
    smilePath.quadraticBezierTo(
      center.dx, center.dy + bearSize * 0.3 + bounceOffset,
      center.dx + bearSize * 0.2, center.dy + bearSize * 0.2 + bounceOffset,
    );
    canvas.drawPath(smilePath, smilePaint);
  }

  void _drawThinkingFace(Canvas canvas, Offset center, double bearSize) {
    // One eye closed, one open
    final eyePaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    // Left eye closed
    canvas.drawLine(
      Offset(center.dx - bearSize * 0.4, center.dy - bearSize * 0.1 + bounceOffset),
      Offset(center.dx - bearSize * 0.15, center.dy - bearSize * 0.1 + bounceOffset),
      eyePaint,
    );
    
    // Right eye open
    final eyeWhitePaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + bearSize * 0.3, center.dy - bearSize * 0.15 + bounceOffset),
        width: bearSize * 0.35,
        height: bearSize * 0.38,
      ),
      eyeWhitePaint,
    );
    final pupilPaint = Paint()..color = Colors.black..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx + bearSize * 0.3, center.dy - bearSize * 0.12 + bounceOffset),
      bearSize * 0.1, pupilPaint,
    );

    // Thinking mouth
    final mouthPaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx - bearSize * 0.15, center.dy + bearSize * 0.25 + bounceOffset),
      Offset(center.dx + bearSize * 0.15, center.dy + bearSize * 0.25 + bounceOffset),
      mouthPaint,
    );

    // Thought bubbles
    _drawThoughtBubbles(canvas, center, bearSize);
  }

  void _drawHeartHandFace(Canvas canvas, Offset center, double bearSize) {
    // Heart eyes
    _drawHeartEyes(canvas, center, bearSize);

    // Waving hand
    _drawWavingHand(canvas, center, bearSize);

    // Gentle smile
    _drawHappyMouth(canvas, center, bearSize);
  }

  void _drawSunglassesFace(Canvas canvas, Offset center, double bearSize) {
    // Cool sunglasses
    _drawSunglasses(canvas, center, bearSize);

    // Cool smile
    final smilePaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    final smilePath = Path();
    smilePath.moveTo(center.dx - bearSize * 0.25, center.dy + bearSize * 0.2 + bounceOffset);
    smilePath.quadraticBezierTo(
      center.dx, center.dy + bearSize * 0.35 + bounceOffset,
      center.dx + bearSize * 0.25, center.dy + bearSize * 0.2 + bounceOffset,
    );
    canvas.drawPath(smilePath, smilePaint);
  }

  void _drawDefaultFace(Canvas canvas, Offset center, double bearSize) {
    // Normal eyes
    final eyeWhitePaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - bearSize * 0.3, center.dy - bearSize * 0.15 + bounceOffset),
        width: bearSize * 0.35,
        height: bearSize * 0.38,
      ),
      eyeWhitePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + bearSize * 0.3, center.dy - bearSize * 0.15 + bounceOffset),
        width: bearSize * 0.35,
        height: bearSize * 0.38,
      ),
      eyeWhitePaint,
    );

    final pupilPaint = Paint()..color = Colors.black..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx - bearSize * 0.3, center.dy - bearSize * 0.12 + bounceOffset),
      bearSize * 0.1, pupilPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + bearSize * 0.3, center.dy - bearSize * 0.12 + bounceOffset),
      bearSize * 0.1, pupilPaint,
    );

    _drawHappyMouth(canvas, center, bearSize);
  }

  // === Helper Drawing Methods ===

  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
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

  void _drawHappyMouth(Canvas canvas, Offset center, double bearSize) {
    final smilePaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    final smilePath = Path();
    smilePath.moveTo(center.dx - bearSize * 0.2, center.dy + bearSize * 0.2 + bounceOffset);
    smilePath.quadraticBezierTo(
      center.dx, center.dy + bearSize * 0.35 + bounceOffset,
      center.dx + bearSize * 0.2, center.dy + bearSize * 0.2 + bounceOffset,
    );
    canvas.drawPath(smilePath, smilePaint);
  }

  void _drawStarEyes(Canvas canvas, Offset center, double bearSize) {
    final starPaint = Paint()..color = Colors.amber..style = PaintingStyle.fill;
    
    _drawStar(canvas, 
      Offset(center.dx - bearSize * 0.28, center.dy - bearSize * 0.15 + bounceOffset),
      bearSize * 0.15, starPaint);
    _drawStar(canvas,
      Offset(center.dx + bearSize * 0.28, center.dy - bearSize * 0.15 + bounceOffset),
      bearSize * 0.15, starPaint);
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
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

  void _drawZZZ(Canvas canvas, Offset center, double bearSize) {
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Zzz',
        style: TextStyle(
          color: Color(0xFF5D4037),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, 
      Offset(center.dx + bearSize * 0.6, center.dy - bearSize * 0.8 + bounceOffset));
  }

  void _drawNightcap(Canvas canvas, Offset center, double bearSize) {
    final capPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final capPath = Path();
    capPath.moveTo(center.dx - bearSize * 0.5, center.dy - bearSize * 0.5 + bounceOffset);
    capPath.lineTo(center.dx, center.dy - bearSize * 1.2 + bounceOffset);
    capPath.lineTo(center.dx + bearSize * 0.5, center.dy - bearSize * 0.5 + bounceOffset);
    capPath.close();
    canvas.drawPath(capPath, capPaint);

    // Cap pom-pom
    canvas.drawCircle(
      Offset(center.dx, center.dy - bearSize * 1.25 + bounceOffset),
      bearSize * 0.1, capPaint,
    );
  }

  void _drawHandsTogether(Canvas canvas, Offset center, double bearSize) {
    final handPaint = Paint()..color = const Color(0xFFD4A574)..style = PaintingStyle.fill;
    
    // Two paws together
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - bearSize * 0.1, center.dy + bearSize * 0.35 + bounceOffset),
        width: bearSize * 0.25,
        height: bearSize * 0.2,
      ),
      handPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + bearSize * 0.1, center.dy + bearSize * 0.35 + bounceOffset),
        width: bearSize * 0.25,
        height: bearSize * 0.2,
      ),
      handPaint,
    );
  }

  void _drawRaisedArms(Canvas canvas, Offset center, double bearSize) {
    final armPaint = Paint()
      ..color = const Color(0xFF8B7355)
      ..style = PaintingStyle.stroke
      ..strokeWidth = bearSize * 0.15
      ..strokeCap = StrokeCap.round;

    // Left arm raised
    canvas.drawLine(
      Offset(center.dx - bearSize * 0.7, center.dy + bounceOffset),
      Offset(center.dx - bearSize * 1.0, center.dy - bearSize * 0.5 + bounceOffset),
      armPaint,
    );
    // Right arm raised
    canvas.drawLine(
      Offset(center.dx + bearSize * 0.7, center.dy + bounceOffset),
      Offset(center.dx + bearSize * 1.0, center.dy - bearSize * 0.5 + bounceOffset),
      armPaint,
    );
  }

  void _drawDivingGoggles(Canvas canvas, Offset center, double bearSize) {
    final gogglePaint = Paint()..color = Colors.blue.shade800..style = PaintingStyle.fill;
    final strapPaint = Paint()..color = Colors.black..style = PaintingStyle.stroke..strokeWidth = 2;

    // Left goggle
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - bearSize * 0.28, center.dy - bearSize * 0.1 + bounceOffset),
        width: bearSize * 0.35,
        height: bearSize * 0.25,
      ),
      gogglePaint,
    );
    // Right goggle
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + bearSize * 0.28, center.dy - bearSize * 0.1 + bounceOffset),
        width: bearSize * 0.35,
        height: bearSize * 0.25,
      ),
      gogglePaint,
    );
    // Strap
    canvas.drawLine(
      Offset(center.dx - bearSize * 0.45, center.dy - bearSize * 0.1 + bounceOffset),
      Offset(center.dx + bearSize * 0.45, center.dy - bearSize * 0.1 + bounceOffset),
      strapPaint,
    );
  }

  void _drawBreathingTube(Canvas canvas, Offset center, double bearSize) {
    final tubePaint = Paint()..color = Colors.grey..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + bearSize * 0.25 + bounceOffset),
        width: bearSize * 0.15,
        height: bearSize * 0.3,
      ),
      tubePaint,
    );
  }

  void _drawFlippers(Canvas canvas, Offset center, double bearSize) {
    final flipperPaint = Paint()..color = Colors.green..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - bearSize * 0.3, center.dy + bearSize * 0.9 + bounceOffset),
        width: bearSize * 0.4,
        height: bearSize * 0.2,
      ),
      flipperPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + bearSize * 0.3, center.dy + bearSize * 0.9 + bounceOffset),
        width: bearSize * 0.4,
        height: bearSize * 0.2,
      ),
      flipperPaint,
    );
  }

  void _drawSunglasses(Canvas canvas, Offset center, double bearSize) {
    final glassPaint = Paint()..color = Colors.black..style = PaintingStyle.fill;
    final lensPaint = Paint()..color = Colors.grey.shade800..style = PaintingStyle.fill;

    // Frames
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx - bearSize * 0.28, center.dy - bearSize * 0.1 + bounceOffset),
          width: bearSize * 0.4,
          height: bearSize * 0.3,
        ),
        const Radius.circular(4),
      ),
      glassPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx + bearSize * 0.28, center.dy - bearSize * 0.1 + bounceOffset),
          width: bearSize * 0.4,
          height: bearSize * 0.3,
        ),
        const Radius.circular(4),
      ),
      glassPaint,
    );

    // Lenses
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx - bearSize * 0.28, center.dy - bearSize * 0.1 + bounceOffset),
          width: bearSize * 0.35,
          height: bearSize * 0.25,
        ),
        const Radius.circular(3),
      ),
      lensPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx + bearSize * 0.28, center.dy - bearSize * 0.1 + bounceOffset),
          width: bearSize * 0.35,
          height: bearSize * 0.25,
        ),
        const Radius.circular(3),
      ),
      lensPaint,
    );

    // Bridge
    canvas.drawLine(
      Offset(center.dx - bearSize * 0.08, center.dy - bearSize * 0.1 + bounceOffset),
      Offset(center.dx + bearSize * 0.08, center.dy - bearSize * 0.1 + bounceOffset),
      glassPaint..strokeWidth = 4,
    );
  }

  void _drawWavingHand(Canvas canvas, Offset center, double bearSize) {
    final handPaint = Paint()..color = const Color(0xFFD4A574)..style = PaintingStyle.fill;
    
    // Waving arm
    final armPaint = Paint()
      ..color = const Color(0xFF8B7355)
      ..style = PaintingStyle.stroke
      ..strokeWidth = bearSize * 0.12
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(center.dx + bearSize * 0.8, center.dy + bounceOffset),
      Offset(center.dx + bearSize * 1.2, center.dy - bearSize * 0.3 + bounceOffset),
      armPaint,
    );

    // Hand
    canvas.drawCircle(
      Offset(center.dx + bearSize * 1.2, center.dy - bearSize * 0.4 + bounceOffset),
      bearSize * 0.15, handPaint,
    );

    // Fingers
    for (int i = 0; i < 3; i++) {
      canvas.drawLine(
        Offset(center.dx + bearSize * 1.15, center.dy - bearSize * 0.5 + bounceOffset + i * bearSize * 0.05),
        Offset(center.dx + bearSize * 1.3, center.dy - bearSize * 0.6 + bounceOffset + i * bearSize * 0.05),
        handPaint..strokeWidth = 4,
      );
    }
  }

  void _drawThoughtBubbles(Canvas canvas, Offset center, double bearSize) {
    final bubblePaint = Paint()..color = Colors.grey.shade300..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(center.dx + bearSize * 0.5, center.dy - bearSize * 0.5 + bounceOffset),
      bearSize * 0.08, bubblePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + bearSize * 0.65, center.dy - bearSize * 0.7 + bounceOffset),
      bearSize * 0.12, bubblePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + bearSize * 0.85, center.dy - bearSize * 0.9 + bounceOffset),
      bearSize * 0.18, bubblePaint,
    );
  }

  void _drawMoodDecorations(Canvas canvas, Size size, Offset center, double bearSize) {
    // Draw floating hearts for heartEyes mood
    if (mood == BearMood.heartEyes || mood == BearMood.heartHand) {
      final heartPaint = Paint()..color = Colors.pink.withOpacity(0.6)..style = PaintingStyle.fill;
      _drawHeart(canvas, 
        Offset(center.dx - bearSize * 0.8, center.dy - bearSize * 0.5 + math.sin(DateTime.now().millisecond / 500.0) * 10),
        bearSize * 0.1 * heartScale, heartPaint);
      _drawHeart(canvas,
        Offset(center.dx + bearSize * 0.9, center.dy - bearSize * 0.3 + math.cos(DateTime.now().millisecond / 600.0) * 10),
        bearSize * 0.08 * heartScale, heartPaint);
    }

    // Draw bubbles for diving mood
    if (mood == BearMood.diving) {
      final bubblePaint = Paint()
        ..color = Colors.lightBlue.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      
      for (int i = 0; i < 5; i++) {
        final x = center.dx + bearSize * 0.3 + i * bearSize * 0.1;
        final y = center.dy - bearSize * 0.5 - (DateTime.now().millisecond / 50.0 + i * 20) % 60;
        canvas.drawCircle(Offset(x, y), bearSize * 0.05 * (i % 3 + 1), bubblePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BearPainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.bounceOffset != bounceOffset ||
        oldDelegate.breathScale != breathScale;
  }
}
