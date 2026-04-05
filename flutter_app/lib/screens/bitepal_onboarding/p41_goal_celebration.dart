import 'package:flutter/material.dart';
import '../../widgets/monet_background.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';

class P41GoalCelebration extends StatelessWidget {
  final VoidCallback onNext;
  
  const P41GoalCelebration({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFCE4EC),
      child: SafeArea(
        child: Stack(
          children: [
            const ConfettiAnimation(active: true),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 250, height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(colors: [Colors.yellow.shade100.withOpacity(0.8), Colors.pink.shade100.withOpacity(0.5), Colors.transparent]),
                        ),
                      ),
                      const CanvasBear(mood: BearMood.celebrating, size: 200, animate: true),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text('Daily Goal\nReached! 🎉', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 32, height: 1.2)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)]),
                    child: Column(
                      children: [
                        _GoalCheck(label: 'Calories', value: '1,850 / 2,150 kcal', achieved: true),
                        const Divider(height: 24),
                        _GoalCheck(label: 'Water', value: '2.5L / 2.5L', achieved: true),
                        const Divider(height: 24),
                        _GoalCheck(label: 'Fasting', value: '16 hours', achieved: true),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Text('Amazing work today! 💪', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 18)),
                  const SizedBox(height: 24),
                  CapsuleButton(text: 'Continue', onPressed: onNext, backgroundColor: const Color(0xFF4CAF50)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalCheck extends StatelessWidget {
  final String label;
  final String value;
  final bool achieved;
  
  const _GoalCheck({required this.label, required this.value, required this.achieved});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: achieved ? const Color(0xFF4CAF50) : Colors.grey.shade300, shape: BoxShape.circle),
          child: Icon(achieved ? Icons.check : Icons.close, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14))),
        Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: achieved ? const Color(0xFF4CAF50) : Colors.grey)),
      ],
    );
  }
}
