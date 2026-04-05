import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';

/// P07: Feature Introduction - Nutrition
/// "What a well-balanced plate! Good job!"
class P07FeatureNutrition extends StatelessWidget {
  final VoidCallback onNext;
  
  const P07FeatureNutrition({super.key, required this.onNext});
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            // Heart-hand bear
            const CanvasBear(
              mood: BearMood.heartHand,
              size: 180,
            ),
            const SizedBox(height: 32),
            const Text(
              'What a well-balanced plate!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Good job!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.green.shade600,
              ),
            ),
            const SizedBox(height: 32),
            // Nutrition breakdown bars
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildMacroBar('Carbs', 75, 150, Colors.orange.shade400),
                  const SizedBox(height: 16),
                  _buildMacroBar('Protein', 45, 80, Colors.red.shade400),
                  const SizedBox(height: 16),
                  _buildMacroBar('Fats', 28, 50, Colors.yellow.shade700),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: CapsuleButton(
                text: 'Get started >',
                onPressed: onNext,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: index == 0 ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == 0 ? Colors.black : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMacroBar(String label, int value, int max, Color color) {
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
              '$value g',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value / max,
              child: Container(color: color),
            ),
          ),
        ),
      ],
    );
  }
}
