import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';

/// P04: Feature - Fasting
/// Bear sleeping with nightcap + fasting ring
class P04FeatureFasting extends StatelessWidget {
  final VoidCallback onNext;
  
  const P04FeatureFasting({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.nightlight_round, color: Colors.green.shade700, size: 28),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enjoy fasting',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Build a healthy habit with flexible intermittent fasting plans',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const Spacer(),
            // Center: Sleeping bear with fasting ring
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Fasting progress ring
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: CustomPaint(
                      painter: _FastingRingPainter(),
                    ),
                  ),
                  // Time display
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '00:01:20',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        'Fasting',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  // Sleeping bear
                  const Positioned(
                    bottom: 10,
                    child: CanvasBear(
                      mood: BearMood.sleeping,
                      size: 80,
                      animate: true,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Grass decoration
            Container(
              height: 20,
              decoration: BoxDecoration(
                color: Colors.green.shade200,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
            ),
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _FastingOption(label: '16:8', selected: true),
                  _FastingOption(label: '14:10', selected: false),
                  _FastingOption(label: '18:6', selected: false),
                  _FastingOption(label: '20:4', selected: false),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const CanvasBear(
                  mood: BearMood.sleeping,
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
                    child: const Text(
                      "Sweet dreams! 😴 Your fast is progressing well!",
                      style: TextStyle(
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

class _FastingRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    
    // Background ring
    final bgPaint = Paint()
      ..color = Colors.green.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    
    canvas.drawCircle(center, radius, bgPaint);
    
    // Progress ring (5% progress)
    final progressPaint = Paint()
      ..color = Colors.green.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      0.05 * 2 * 3.14159,
      false,
      progressPaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FastingOption extends StatelessWidget {
  final String label;
  final bool selected;
  
  const _FastingOption({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? Colors.green.shade600 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : Colors.green.shade700,
        ),
      ),
    );
  }
}
