import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/monet_background.dart';

/// P03: Feature Introduction - Calories
/// "Track calories...Just snap a photo..."
class P03FeatureCalories extends StatelessWidget {
  final VoidCallback onNext;
  
  const P03FeatureCalories({super.key, required this.onNext});
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            // Bear with happy surprised expression
            const CanvasBear(
              mood: BearMood.heartHand,
              size: 180,
            ),
            const SizedBox(height: 32),
            // Title
            const Text(
              'Track calories',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Just snap a photo of your meal\nand we\'ll do the rest',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            // Food tags floating around
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildFoodTag('Sweet potato', '120 kcal', Colors.orange.shade100),
                _buildFoodTag('Avocado', '100 kcal', Colors.green.shade100),
                _buildFoodTag('Salmon', '180 kcal', Colors.pink.shade100),
                _buildFoodTag('Egg', '70 kcal', Colors.yellow.shade100),
              ],
            ),
            const Spacer(),
            // CTA Button
            SizedBox(
              width: double.infinity,
              child: CapsuleButton(
                text: 'Next >',
                onPressed: onNext,
              ),
            ),
            const SizedBox(height: 16),
            // Pagination dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: index == 1 ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == 1 ? Colors.black : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFoodTag(String name, String calories, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            name,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          Text(
            calories,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
