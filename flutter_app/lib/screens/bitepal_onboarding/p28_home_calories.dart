import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';

class P28HomeCalories extends StatelessWidget {
  final VoidCallback onNext;
  
  const P28HomeCalories({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Today', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 24)),
                TextButton(onPressed: onNext, child: const Text('Next >', style: TextStyle(fontFamily: 'Inter', color: Color(0xFF4CAF50)))),
              ],
            ),
            const SizedBox(height: 24),
            // Calorie ring
            Center(
              child: CalorieRing(
                current: state.todayCalories,
                goal: state.dailyCalorieGoal,
                size: 200,
                color: const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(height: 32),
            // Meal buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MealButton(label: 'Breakfast', icon: Icons.wb_sunny, onTap: onNext),
                _MealButton(label: 'Lunch', icon: Icons.wb_cloudy, onTap: onNext),
                _MealButton(label: 'Dinner', icon: Icons.nights_stay, onTap: onNext),
              ],
            ),
            const Spacer(),
            // Navigation dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 24, height: 8, decoration: BoxDecoration(color: const Color(0xFF4CAF50), borderRadius: BorderRadius.circular(4))),
                const SizedBox(width: 8),
                Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4))),
                const SizedBox(width: 8),
                Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MealButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  
  const _MealButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(20)),
            child: Icon(icon, color: Colors.orange, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: 12)),
        ],
      ),
    );
  }
}
