import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/monet_background.dart';

/// P02: Welcome Screen
/// Air blue background with heart-eyes bear and tagline
class P02Welcome extends StatelessWidget {
  final VoidCallback onNext;
  
  const P02Welcome({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            // Hero illustration placeholder (oatmeal bowl image concept)
            Container(
              width: 200,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Bowl illustration
                  Container(
                    width: 120,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.brown.shade200,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(60),
                      ),
                    ),
                  ),
                  // Food in bowl
                  Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  // Calorie bubble
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '310 kcal',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Main headline
            const Text(
              'Reach your\nweight goals',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 36,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Track calories, fasting & more\nwith your virtual pet companion',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const Spacer(),
            // Heart-eyes bear
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CanvasBear(
                  mood: BearMood.heartEyes,
                  size: 80,
                  animate: true,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // CTA Button
            CapsuleButton(
              text: 'Get started',
              onPressed: onNext,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
