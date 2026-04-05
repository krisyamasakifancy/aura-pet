import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';

/// P22: Weight Prediction Chart
/// "Believe in yourself!"
class P22WeightPrediction extends StatelessWidget {
  final VoidCallback onNext;
  
  const P22WeightPrediction({super.key, required this.onNext});
  
  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingState>();
    final currentWeight = onboarding.currentWeight;
    final goalWeight = onboarding.goalWeight;
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Believe in yourself!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your projected progress',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            // Weight prediction chart
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Chart
                    Expanded(
                      child: CustomPaint(
                        size: const Size(double.infinity, double.infinity),
                        painter: _WeightChartPainter(
                          currentWeight: currentWeight,
                          goalWeight: goalWeight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _LegendItem(color: Colors.grey, label: 'Current: ${currentWeight.toStringAsFixed(1)} kg'),
                        const SizedBox(width: 24),
                        _LegendItem(color: const Color(0xFF4CAF50), label: 'Goal: ${goalWeight.toStringAsFixed(1)} kg'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Bear at end of chart
            const CanvasBear(
              mood: BearMood.heartEyes,
              size: 80,
            ),
            const SizedBox(height: 16),
            CapsuleButton(
              text: 'Next >',
              onPressed: onNext,
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  
  const _LegendItem({required this.color, required this.label});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class _WeightChartPainter extends CustomPainter {
  final double currentWeight;
  final double goalWeight;
  
  _WeightChartPainter({required this.currentWeight, required this.goalWeight});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    // Grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }
    
    // Draw curve
    final path = Path();
    final points = <Offset>[];
    
    for (int i = 0; i <= 12; i++) {
      final x = size.width * i / 12;
      // Exponential decay curve
      final progress = i / 12;
      final weight = currentWeight - (currentWeight - goalWeight) * 
          (1 - math.exp(-3 * progress));
      // Normalize to chart height (assuming 40-100kg range)
      final y = size.height * (1 - (weight - 40) / 60);
      points.add(Offset(x, y.clamp(0, size.height)));
    }
    
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    
    paint.shader = const LinearGradient(
      colors: [Colors.grey, Color(0xFF4CAF50)],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawPath(path, paint);
    
    // Current weight dot
    final dotPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;
    canvas.drawCircle(points[0], 8, dotPaint);
    
    // Goal weight dot
    dotPaint.color = const Color(0xFF4CAF50);
    canvas.drawCircle(points.last, 8, dotPaint);
  }
  
  @override
  bool shouldRepaint(_WeightChartPainter oldDelegate) =>
      oldDelegate.currentWeight != currentWeight ||
      oldDelegate.goalWeight != goalWeight;
}
