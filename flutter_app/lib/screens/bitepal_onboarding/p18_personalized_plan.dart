import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';

/// P18: Personalized Plan Ready
/// "Your personalized plan is ready!"
class P18PersonalizedPlan extends StatelessWidget {
  final VoidCallback onNext;
  
  const P18PersonalizedPlan({super.key, required this.onNext});
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Your personalized\nplan is ready!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            const Spacer(),
            // Celebrating bear
            const CanvasBear(
              mood: BearMood.celebrating,
              size: 180,
            ),
            const SizedBox(height: 40),
            // Plan summary card
            Container(
              padding: const EdgeInsets.all(24),
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
                  _PlanItem(
                    icon: Icons.calendar_today,
                    label: 'Estimated goal date',
                    value: 'March 15, 2026',
                    color: Colors.purple,
                  ),
                  const Divider(height: 24),
                  _PlanItem(
                    icon: Icons.local_fire_department,
                    label: 'Daily calorie goal',
                    value: '2,150 kcal',
                    color: Colors.orange,
                  ),
                  const Divider(height: 24),
                  _PlanItem(
                    icon: Icons.water_drop,
                    label: 'Daily water goal',
                    value: '2.5 L',
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
            const Spacer(),
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

class _PlanItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  
  const _PlanItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
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
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
