import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../utils/theme.dart';

class PetCanvas extends StatelessWidget {
  const PetCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PetProvider>(
      builder: (context, petProvider, _) {
        final state = petProvider.state;
        
        // Calculate visual properties based on pet state
        final breathScale = 1.0 + (state.breathPhase.sin() * 0.02);
        final glowOpacity = state.glowIntensity * 0.3;
        
        // Adjust colors based on mood
        Color bearColor;
        switch (state.mood) {
          case PetMood.happy:
            bearColor = const Color(0xFFD4A574);
            break;
          case PetMood.sad:
            bearColor = const Color(0xFFB8956E);
            break;
          case PetMood.excited:
            bearColor = const Color(0xFFE4B584);
            break;
          case PetMood.sleepy:
            bearColor = const Color(0xFFC49574);
            break;
          case PetMood.diving:
            bearColor = const Color(0xFF4D96FF);
            break;
          case PetMood.eating:
            bearColor = const Color(0xFFD4A574);
            break;
          case PetMood.celebrating:
            bearColor = const Color(0xFFFFD93D);
            break;
          default:
            bearColor = const Color(0xFFD4A574);
        }

        return Transform.scale(
          scale: breathScale,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFFF8F0),
                  const Color(0xFFFFE8DC),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: bearColor.withValues(alpha: glowOpacity),
                  blurRadius: 60,
                  spreadRadius: 20,
                ),
                BoxShadow(
                  color: bearColor.withValues(alpha: 0.25),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Bear face
                CustomPaint(
                  size: const Size(200, 200),
                  painter: BearPainter(
                    bearColor: bearColor,
                    mood: state.mood,
                    breathPhase: state.breathPhase,
                  ),
                ),
                // Accessories
                ..._buildAccessories(state.accessories),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildAccessories(List<PetAccessory> accessories) {
    final widgets = <Widget>[];

    if (accessories.contains(PetAccessory.scarf)) {
      widgets.add(
        Positioned(
          bottom: 85,
          child: Container(
            width: 92,
            height: 28,
            decoration: BoxDecoration(
              color: AuraPetTheme.danger,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      );
      widgets.add(
        Positioned(
          bottom: 60,
          right: 65,
          child: Container(
            width: 13,
            height: 32,
            color: const Color(0xFFFF8585),
          ),
        ),
      );
    }

    if (accessories.contains(PetAccessory.hat)) {
      widgets.add(
        Positioned(
          top: 15,
          child: Container(
            width: 60,
            height: 40,
            decoration: BoxDecoration(
              color: AuraPetTheme.textDark,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
    }

    if (accessories.contains(PetAccessory.glasses)) {
      widgets.add(
        Positioned(
          top: 75,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 20,
                decoration: BoxDecoration(
                  color: AuraPetTheme.textDark,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 28,
                height: 20,
                decoration: BoxDecoration(
                  color: AuraPetTheme.textDark,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (accessories.contains(PetAccessory.crown)) {
      widgets.add(
        Positioned(
          top: 5,
          child: Container(
            width: 50,
            height: 30,
            child: const Text('👑', style: TextStyle(fontSize: 30)),
          ),
        ),
      );
    }

    return widgets;
  }
}

class BearPainter extends CustomPainter {
  final Color bearColor;
  final PetMood mood;
  final double breathPhase;

  BearPainter({
    required this.bearColor,
    required this.mood,
    required this.breathPhase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + 85), width: 110, height: 28),
      shadowPaint,
    );

    // Body
    final bodyPaint = Paint()..color = bearColor;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + 45), width: 100, height: 120),
      bodyPaint,
    );

    // Belly
    final bellyPaint = Paint()..color = const Color(0xFFF5E6D3);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + 55), width: 64, height: 76),
      bellyPaint,
    );

    // Head
    canvas.drawCircle(Offset(cx, cy - 18), 55, bodyPaint);

    // Ears
    canvas.drawCircle(Offset(cx - 45, cy - 55), 23, bodyPaint);
    canvas.drawCircle(Offset(cx + 45, cy - 55), 23, bodyPaint);

    // Inner ears
    final innerEarPaint = Paint()..color = const Color(0xFFC49A6C);
    canvas.drawCircle(Offset(cx - 45, cy - 55), 14, innerEarPaint);
    canvas.drawCircle(Offset(cx + 45, cy - 55), 14, innerEarPaint);

    // Muzzle
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: 64, height: 56),
      bellyPaint,
    );

    // Eyes
    final eyePaint = Paint()..color = const Color(0xFF4A4A4A);
    final eyeWhitePaint = Paint()..color = Colors.white;

    double leftEyeY = cy - 22;
    double rightEyeY = cy - 22;

    // Adjust eyes based on mood
    if (mood == PetMood.sleepy) {
      // Half-closed eyes
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx - 20, leftEyeY), width: 18, height: 4),
        eyePaint,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx + 20, rightEyeY), width: 18, height: 4),
        eyePaint,
      );
    } else if (mood == PetMood.sad) {
      leftEyeY += 5;
      rightEyeY += 5;
      canvas.drawCircle(Offset(cx - 20, leftEyeY), 9, eyePaint);
      canvas.drawCircle(Offset(cx + 20, rightEyeY), 9, eyePaint);
      // Tears
      final tearPaint = Paint()..color = const Color(0xFF4D96FF);
      canvas.drawCircle(Offset(cx - 20, leftEyeY + 15), 4, tearPaint);
    } else {
      canvas.drawCircle(Offset(cx - 20, leftEyeY), 9, eyePaint);
      canvas.drawCircle(Offset(cx + 20, rightEyeY), 9, eyePaint);
      // Eye highlights
      canvas.drawCircle(Offset(cx - 17, leftEyeY - 3), 4, eyeWhitePaint);
      canvas.drawCircle(Offset(cx + 23, rightEyeY - 3), 4, eyeWhitePaint);
    }

    // Nose
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy - 5), width: 18, height: 12),
      eyePaint,
    );

    // Mouth
    final mouthPaint = Paint()
      ..color = const Color(0xFF4A4A4A)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (mood == PetMood.happy || mood == PetMood.excited) {
      // Big smile
      final path = Path()
        ..moveTo(cx - 18, cy + 7)
        ..quadraticBezierTo(cx, cy + 16, cx + 18, cy + 7);
      canvas.drawPath(path, mouthPaint);
    } else if (mood == PetMood.sad) {
      // Frown
      final path = Path()
        ..moveTo(cx - 15, cy + 15)
        ..quadraticBezierTo(cx, cy + 5, cx + 15, cy + 15);
      canvas.drawPath(path, mouthPaint);
    } else if (mood == PetMood.eating) {
      // Open mouth
      final openMouthPaint = Paint()..color = const Color(0xFF4A4A4A);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy + 12), width: 20, height: 12),
        openMouthPaint,
      );
    } else {
      // Normal smile
      final path = Path()
        ..moveTo(cx - 9, cy + 7)
        ..quadraticBezierTo(cx, cy + 16, cx + 9, cy + 7);
      canvas.drawPath(path, mouthPaint);
    }

    // Blush
    final blushPaint = Paint()..color = const Color(0xFFFFB5B5).withValues(alpha: 0.5);
    canvas.drawCircle(Offset(cx - 42, cy - 5), 11, blushPaint);
    canvas.drawCircle(Offset(cx + 42, cy - 5), 11, blushPaint);
  }

  @override
  bool shouldRepaint(covariant BearPainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.breathPhase != breathPhase ||
        oldDelegate.bearColor != bearColor;
  }
}

extension on double {
  double sin() => _sin(this);
}

double _sin(double x) {
  // Taylor series approximation
  double result = x;
  double term = x;
  for (int i = 1; i < 10; i++) {
    term *= -x * x / ((2 * i) * (2 * i + 1));
    result += term;
  }
  return result;
}
