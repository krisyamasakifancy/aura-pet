import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

/// P18: Personalized Plan Ready
class P18PersonalizedPlan extends StatelessWidget {
  final VoidCallback onNext;
  
  const P18PersonalizedPlan({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            const Text(
              "Your personalized\nplan is ready!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 32),
            // Plan summary card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _PlanRow(label: 'Daily calories', value: '${state.dailyCalorieGoal} kcal'),
                  const Divider(height: 24),
                  _PlanRow(label: 'Expected goal date', value: '${state.weeksToGoal} weeks'),
                  const Divider(height: 24),
                  _PlanRow(label: 'Water goal', value: '${(state.waterGoalMl / 1000).toStringAsFixed(1)} L'),
                  const Divider(height: 24),
                  _PlanRow(label: 'Fasting plan', value: '16:8'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const CanvasBear(
              mood: BearMood.celebrating,
              size: 100,
              animate: true,
            ),
            const Spacer(),
            CapsuleButton(
              text: 'Continue',
              onPressed: onNext,
              backgroundColor: const Color(0xFF4CAF50),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  final String label;
  final String value;
  
  const _PlanRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.grey.shade600)),
        Text(value, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
      ],
    );
  }
}
