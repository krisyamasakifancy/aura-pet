import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';

/// P07: Feature - Nutrition Breakdown
/// Heart-eyes bear + nutrition radar/progress bars
class P07FeatureNutrition extends StatelessWidget {
  final VoidCallback onNext;
  
  const P07FeatureNutrition({super.key, required this.onNext});

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
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.pie_chart, color: Colors.amber.shade700, size: 28),
            ),
            const SizedBox(height: 20),
            const Text(
              'What a well-balanced\nplate!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Good job!',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            // Nutrition breakdown card
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Pie chart representation
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 150,
                            child: CustomPaint(
                              painter: _NutritionPiePainter(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Legend
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _LegendItem(color: const Color(0xFFFF9800), label: 'Carbs', value: '75g'),
                            const SizedBox(height: 8),
                            _LegendItem(color: const Color(0xFF4CAF50), label: 'Protein', value: '45g'),
                            const SizedBox(height: 8),
                            _LegendItem(color: const Color(0xFF2196F3), label: 'Fats', value: '28g'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Progress bars
                    _MacroBar(
                      label: 'Carbs',
                      current: 75,
                      goal: 100,
                      color: Colors.orange,
                      unit: 'g',
                    ),
                    const SizedBox(height: 12),
                    _MacroBar(
                      label: 'Protein',
                      current: 45,
                      goal: 80,
                      color: Colors.green,
                      unit: 'g',
                    ),
                    const SizedBox(height: 12),
                    _MacroBar(
                      label: 'Fats',
                      current: 28,
                      goal: 40,
                      color: Colors.blue,
                      unit: 'g',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const CanvasBear(
                  mood: BearMood.heartEyes,
                  size: 60,
                  animate: true,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Perfect balance! Your bear is happy! 🍽️",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Colors.amber,
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

class _NutritionPiePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width.clamp(0, size.height) / 2;
    
    // Carbs: 45%, Protein: 27%, Fats: 28%
    final total = 45 + 27 + 28;
    
    // Carbs (orange)
    final carbsPaint = Paint()..color = const Color(0xFFFF9800)..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      (45 / total) * 2 * 3.14159,
      true,
      carbsPaint,
    );
    
    // Protein (green)
    final proteinPaint = Paint()..color = const Color(0xFF4CAF50)..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708 + (45 / total) * 2 * 3.14159,
      (27 / total) * 2 * 3.14159,
      true,
      proteinPaint,
    );
    
    // Fats (blue)
    final fatsPaint = Paint()..color = const Color(0xFF2196F3)..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708 + (45 + 27) / total * 2 * 3.14159,
      (28 / total) * 2 * 3.14159,
      true,
      fatsPaint,
    );
    
    // Inner circle (donut hole)
    canvas.drawCircle(center, radius * 0.5, Paint()..color = Colors.white);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  
  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

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
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _MacroBar extends StatelessWidget {
  final String label;
  final int current;
  final int goal;
  final Color color;
  final String unit;
  
  const _MacroBar({
    required this.label,
    required this.current,
    required this.goal,
    required this.color,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (current / goal).clamp(0.0, 1.0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Text(
              '$current / $goal $unit',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
