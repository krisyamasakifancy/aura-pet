import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';

/// P33: Calorie Calculator
/// "Sweet potato - 120 kcal"
class P33CalorieCalculator extends StatefulWidget {
  final VoidCallback onNext;
  
  const P33CalorieCalculator({super.key, required this.onNext});
  
  @override
  State<P33CalorieCalculator> createState() => _P33CalorieCalculatorState();
}

class _P33CalorieCalculatorState extends State<P33CalorieCalculator> {
  double _weight = 120;
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.arrow_back),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Food info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.egg, color: Colors.orange, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sweet potato',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'per 100g = 86 kcal',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Calorie display
            Text(
              '${_weight.toInt()}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 72,
                color: Color(0xFF4CAF50),
              ),
            ),
            const Text(
              'kcal',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            // Weight slider
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: const Color(0xFF4CAF50),
                inactiveTrackColor: Colors.grey.shade200,
                thumbColor: const Color(0xFF4CAF50),
                overlayColor: const Color(0xFF4CAF50).withOpacity(0.2),
                trackHeight: 8,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
              ),
              child: Slider(
                value: _weight,
                min: 50,
                max: 500,
                onChanged: (value) => setState(() => _weight = value),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '50g',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                Text(
                  '${_weight.toInt()}g',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '500g',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Bear reaction
            Row(
              children: [
                const CanvasBear(
                  mood: BearMood.heartEyes,
                  size: 60,
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_weight.toInt()}g is ${(_weight * 0.86).toInt()} calories! 🍠',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CapsuleButton(
              text: 'Add to diary >',
              onPressed: widget.onNext,
              backgroundColor: const Color(0xFF4CAF50),
            ),
          ],
        ),
      ),
    );
  }
}
