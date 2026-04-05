import 'package:flutter/material.dart';
import '../../widgets/bitepal_widgets.dart';

/// P23: Habit Analysis
/// "Based on your profile..."
class P23HabitAnalysis extends StatelessWidget {
  final VoidCallback onNext;
  
  const P23HabitAnalysis({super.key, required this.onNext});
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Based on your profile...',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your potential vs others your age',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Column(
                children: [
                  _ComparisonBar(
                    label: 'Water Intake',
                    userValue: 65,
                    avgValue: 45,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 20),
                  _ComparisonBar(
                    label: 'Physical Activity',
                    userValue: 55,
                    avgValue: 60,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 20),
                  _ComparisonBar(
                    label: 'Sleep Quality',
                    userValue: 75,
                    avgValue: 65,
                    color: Colors.purple,
                  ),
                  const SizedBox(height: 20),
                  _ComparisonBar(
                    label: 'Diet Balance',
                    userValue: 50,
                    avgValue: 55,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 20),
                  _ComparisonBar(
                    label: 'Stress Level',
                    userValue: 70,
                    avgValue: 60,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb, color: Colors.amber),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You have great potential! Focus on improving water intake.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
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

class _ComparisonBar extends StatelessWidget {
  final String label;
  final int userValue;
  final int avgValue;
  final Color color;
  
  const _ComparisonBar({
    required this.label,
    required this.userValue,
    required this.avgValue,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Text(
              '$userValue%',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            // Average bar (background)
            Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            // Average marker
            Positioned(
              left: avgValue / 100 * (MediaQuery.of(context).size.width - 96),
              child: Container(
                width: 3,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.grey.shade500,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
            ),
            // User bar
            FractionallySizedBox(
              widthFactor: userValue / 100,
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Average: $avgValue%',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
