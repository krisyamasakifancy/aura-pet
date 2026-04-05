import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';

/// P06: Feature Introduction - Results
/// "See results...Watch your progress..."
class P06FeatureResults extends StatelessWidget {
  final VoidCallback onNext;
  
  const P06FeatureResults({super.key, required this.onNext});
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            // Bear with sunglasses and celebration
            Stack(
              alignment: Alignment.center,
              children: [
                // Rainbow background
                Positioned(
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.red.shade100.withOpacity(0),
                          Colors.pink.shade100.withOpacity(0),
                          Colors.orange.shade100.withOpacity(0.3),
                          Colors.yellow.shade100.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                ),
                // Stars
                ..._buildStars(),
                // Bear
                const CanvasBear(
                  mood: BearMood.sunglasses,
                  size: 180,
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'See results',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Watch your progress with\nbeautiful charts',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            // Monet-style Bezier curve chart
            Container(
              height: 120,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: CustomPaint(
                size: const Size(double.infinity, 88),
                painter: _MonetChartPainter(),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: CapsuleButton(
                text: 'Next >',
                onPressed: onNext,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: index == 4 ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == 4 ? Colors.black : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
  
  List<Widget> _buildStars() {
    return [
      Positioned(
        left: 20,
        top: 30,
        child: Icon(Icons.star, color: Colors.amber.shade300, size: 20),
      ),
      Positioned(
        right: 20,
        top: 50,
        child: Icon(Icons.star, color: Colors.pink.shade300, size: 16),
      ),
      Positioned(
        left: 50,
        top: 80,
        child: Icon(Icons.star, color: Colors.green.shade300, size: 14),
      ),
      Positioned(
        right: 40,
        top: 100,
        child: Icon(Icons.star, color: Colors.blue.shade300, size: 18),
      ),
    ];
  }
}

class _MonetChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    // Gradient colors (Monet inspired)
    final colors = [
      const Color(0xFFFF6B6B),
      const Color(0xFFFFE66D),
      const Color(0xFF4ECDC4),
      const Color(0xFF95E1D3),
      const Color(0xFFF38181),
    ];
    
    // Draw Bezier curve
    final path = Path();
    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.2, size.height * 0.6),
      Offset(size.width * 0.4, size.height * 0.5),
      Offset(size.width * 0.6, size.height * 0.35),
      Offset(size.width * 0.8, size.height * 0.25),
      Offset(size.width, size.height * 0.15),
    ];
    
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlX = (p0.dx + p1.dx) / 2;
      path.quadraticBezierTo(p0.dx, p0.dy, controlX, (p0.dy + p1.dy) / 2);
    }
    path.lineTo(points.last.dx, points.last.dy);
    
    // Create gradient
    paint.shader = LinearGradient(
      colors: [colors[0], colors[2], colors[4]],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawPath(path, paint);
    
    // Draw dots at data points
    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = colors[2];
    
    for (final point in points) {
      canvas.drawCircle(point, 5, dotPaint);
    }
    
    // Fill area under curve
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();
    
    paint.style = PaintingStyle.fill;
    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        colors[1].withOpacity(0.3),
        colors[3].withOpacity(0.1),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawPath(fillPath, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
