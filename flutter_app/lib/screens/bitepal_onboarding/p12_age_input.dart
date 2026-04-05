import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

/// P12: Age Input
/// Horizontal ruler picker for age
class P12AgeInput extends StatelessWidget {
  final VoidCallback onNext;
  
  const P12AgeInput({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "How old are\nyou?",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 32,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Slide to select your age',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const Spacer(),
            // Curious bear
            Center(
              child: CanvasBear(
                mood: BearMood.curious,
                size: 120,
                animate: true,
              ),
            ),
            const Spacer(),
            // Age picker
            HorizontalRulerPicker(
              minValue: 13,
              maxValue: 100,
              initialValue: state.age.toDouble(),
              unit: 'years',
              onChanged: (value) => state.setAge(value.round()),
            ),
            const Spacer(),
            Row(
              children: [
                const SizedBox(width: 62),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Age ${state.age} - Good for calculating your BMR! 📊",
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Colors.purple,
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
