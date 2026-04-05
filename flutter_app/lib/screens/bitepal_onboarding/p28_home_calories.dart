import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';

/// P28: Home - Calories Tab
/// Main home screen with calorie tracking
class P28HomeCalories extends StatelessWidget {
  final VoidCallback onNext;
  
  const P28HomeCalories({super.key, required this.onNext});
  
  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingState>();
    final remaining = onboarding.remainingCalories;
    final consumed = onboarding.totalCaloriesConsumed;
    final goal = onboarding.dailyCalorieGoal;
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.local_fire_department, 
                          size: 16, color: Colors.orange.shade400),
                      const SizedBox(width: 4),
                      Text(
                        '${onboarding.currentStreak ?? 5} day streak',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Calorie ring
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgress(
                    progress: consumed / goal,
                    size: 200,
                    strokeWidth: 16,
                    progressColor: remaining > 0 
                        ? const Color(0xFF4CAF50) 
                        : Colors.red,
                    backgroundColor: Colors.grey.shade200,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$remaining',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 48,
                          ),
                        ),
                        Text(
                          'remaining',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.blue,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Quick add buttons
            Row(
              children: [
                Expanded(
                  child: _QuickAddButton(
                    icon: Icons.breakfast_dining,
                    label: 'Breakfast',
                    color: Colors.orange,
                    onTap: onNext,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickAddButton(
                    icon: Icons.lunch_dining,
                    label: 'Lunch',
                    color: Colors.green,
                    onTap: onNext,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickAddButton(
                    icon: Icons.dinner_dining,
                    label: 'Dinner',
                    color: Colors.blue,
                    onTap: onNext,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Bear
            Row(
              children: [
                const CanvasBear(
                  mood: BearMood.heartEyes,
                  size: 60,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Text(
                      remaining > 0
                          ? "You're doing great! Keep it up! 💪"
                          : "You've reached your goal! 🎉",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  
  const _QuickAddButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on OnboardingState {
  int? get currentStreak => 5;
}
