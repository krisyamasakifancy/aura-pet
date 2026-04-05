import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

/// P15: Goal Weight
/// Same as P14 but with goal weight difference shown
class P15GoalWeight extends StatelessWidget {
  final VoidCallback onNext;
  
  const P15GoalWeight({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    final diff = state.currentWeightKg - state.goalWeightKg;
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "What's your\ngoal weight?",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            if (diff > 0)
              Text(
                'You want to lose ${diff.toStringAsFixed(1)} kg',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.green.shade600,
                ),
              )
            else if (diff < 0)
              Text(
                'You want to gain ${(-diff).toStringAsFixed(1)} kg',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.orange.shade600,
                ),
              )
            else
              Text(
                'You want to maintain your weight',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.blue.shade600,
                ),
              ),
            const Spacer(),
            // Goal weight dial
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200, width: 20),
                    ),
                  ),
                  SizedBox(
                    width: 280,
                    height: 280,
                    child: CustomPaint(
                      painter: _WeightRingPainter(
                        progress: (state.goalWeightKg - 30) / 120,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.goalWeightKg.round().toString(),
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
                value: state.goalWeightKg,
                min: 30,
                max: 150,
                onChanged: (value) => state.setGoalWeight(value),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('30 kg', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey)),
                  Text('150 kg', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                const CanvasBear(
                  mood: BearMood.expecting,
                  size: 50,
                  animate: false,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      diff > 0
                          ? "Goal: ${state.goalWeightKg.round()} kg - You'll get there! 🎯"
                          : diff < 0
                              ? "Goal: ${state.goalWeightKg.round()} kg - Let's build muscle! 💪"
                              : "Goal: ${state.goalWeightKg.round()} kg - Balance is key! ⚖️",
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Colors.green,
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
