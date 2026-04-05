import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

/// P14: Current Weight
/// Circular dial/wheel picker for weight
class P14CurrentWeight extends StatelessWidget {
  final VoidCallback onNext;
  
  const P14CurrentWeight({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "What's your\ncurrent weight?",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Rotate to select',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const Spacer(),
            // Weight dial
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background ring
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200, width: 20),
                    ),
                  ),
                  // Progress ring
                  SizedBox(
                    width: 280,
                    height: 280,
                    child: CustomPaint(
                      painter: _WeightRingPainter(
                        progress: (state.currentWeightKg - 40) / 100,
                      ),
                    ),
                  ),
                  // Weight display
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.currentWeightKg.round().toString(),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 72,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                      const Text(
                        'kg',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Weight slider
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 8,
                activeTrackColor: const Color(0xFF4CAF50),
                inactiveTrackColor: Colors.grey.shade200,
                thumbColor: const Color(0xFF4CAF50),
                overlayColor: const Color(0xFF4CAF50).withOpacity(0.2),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 16),
              ),
              child: Slider(
                value: state.currentWeightKg,
                min: 40,
                max: 150,
                onChanged: (value) => state.setCurrentWeight(value),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('40 kg', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey)),
                  Text('150 kg', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                const CanvasBear(
                  mood: BearMood.curious,
                  size: 50,
                  animate: false,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Current: ${state.currentWeightKg.round()} kg - Let's track your journey! ⚖️",
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CapsuleButton(text: 'Next', onPressed: onNext),
          ],
        ),
      ),
    );
  }
}

class _WeightRingPainter extends CustomPainter {
  final double progress;
  
  _WeightRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 20) / 2;
    
    final paint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      progress * 2 * 3.14159,
      false,
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant _WeightRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
