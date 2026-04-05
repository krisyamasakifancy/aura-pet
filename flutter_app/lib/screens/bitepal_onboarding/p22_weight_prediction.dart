import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

class P22WeightPrediction extends StatelessWidget {
  final VoidCallback onNext;
  
  const P22WeightPrediction({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    final curve = state.weightPredictionCurve;
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Believe in yourself!', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 28)),
            const SizedBox(height: 8),
            Text('You can reach your goal in ${state.weeksToGoal} weeks', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.grey.shade600)),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Weight Prediction', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 16),
                    Expanded(
                      child: CustomPaint(
                        size: const Size(double.infinity, double.infinity),
                        painter: _PredictionPainter(curve: curve, goalWeight: state.goalWeightKg),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const CanvasBear(mood: BearMood.sunglasses, size: 50, animate: false),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(12)),
                    child: Text("From ${state.currentWeightKg.round()}kg to ${state.goalWeightKg.round()}kg! 💪", style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.purple)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CapsuleButton(text: 'Continue', onPressed: onNext),
          ],
        ),
      ),
    );
  }
}

class _PredictionPainter extends CustomPainter {
  final List<Map<String, double>> curve;
  final double goalWeight;
  
  _PredictionPainter({required this.curve, required this.goalWeight});

  @override
  void paint(Canvas canvas, Size size) {
    if (curve.isEmpty) return;
    
    final maxWeight = curve.first['weight']!;
    final minWeight = goalWeight;
    final range = maxWeight - minWeight;
    
    final path = Path();
    final points = <Offset>[];
    
    for (int i = 0; i < curve.length; i++) {
      final x = i / (curve.length - 1) * size.width;
      final y = size.height - ((curve[i]['weight']! - minWeight) / range * size.height);
      points.add(Offset(x, y));
    }
    
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    
    // Gradient
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..shader = const LinearGradient(colors: [Color(0xFF9C27B0), Color(0xFF4CAF50)]).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawPath(path, paint);
    
    // Goal line
    final goalY = size.height - ((goalWeight - minWeight) / range * size.height);
    canvas.drawLine(Offset(0, goalY), Offset(size.width, goalY), Paint()..color = Colors.green.withOpacity(0.5)..strokeWidth = 2);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
