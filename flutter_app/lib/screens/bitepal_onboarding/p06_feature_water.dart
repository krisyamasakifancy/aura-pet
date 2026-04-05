import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';

/// P06: Feature - Stay Hydrated
/// Diving bear with water level animation
class P06FeatureWater extends StatelessWidget {
  final VoidCallback onNext;
  
  const P06FeatureWater({super.key, required this.onNext});

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
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.water_drop, color: Colors.blue.shade700, size: 28),
            ),
            const SizedBox(height: 20),
            const Text(
              'Stay hydrated',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Easily track your water intake throughout the day',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const Spacer(),
            // Water glass with level
            Center(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Glass
                  Container(
                    width: 140,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                        bottom: Radius.circular(40),
                      ),
                      border: Border.all(color: Colors.blue.shade200, width: 3),
                    ),
                  ),
                  // Water level (70% filled)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(17),
                      bottom: Radius.circular(37),
                    ),
                    child: Container(
                      width: 134,
                      height: 137, // 70% of 200
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.blue.shade300.withOpacity(0.8),
                            Colors.blue.shade600,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Waves animation
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: CustomPaint(
                              size: const Size(134, 20),
                              painter: _WavePainter(),
                            ),
                          ),
                          // Bubbles
                          ...List.generate(5, (i) => Positioned(
                            bottom: 20 + i * 25.0,
                            left: 30.0 + i * 15,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  // Measurement lines
                  ...List.generate(4, (i) => Positioned(
                    bottom: 40 + i * 40,
                    left: 10,
                    child: Text(
                      '${250 * (4 - i)}ml',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        color: Colors.blue.shade300,
                      ),
                    ),
                  )),
                  // Diving bear inside glass
                  const Positioned(
                    bottom: 60,
                    child: CanvasBear(
                      mood: BearMood.diving,
                      size: 70,
                      animate: true,
                    ),
                  ),
                  // Percentage badge
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        '70%',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Quick add buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _WaterButton(label: '+250ml', onTap: () {}),
                _WaterButton(label: '+500ml', onTap: () {}),
                _WaterButton(label: '+1L', onTap: () {}),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const CanvasBear(
                  mood: BearMood.diving,
                  size: 50,
                  animate: false,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Splish splash! Keep drinking! 💧",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Colors.blue,
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

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(
      size.width * 0.25, 0,
      size.width * 0.5, size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height,
      size.width, size.height * 0.5,
    );
    path.lineTo(size.width, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WaterButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  
  const _WaterButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Colors.blue.shade700, size: 18),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.blue.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
