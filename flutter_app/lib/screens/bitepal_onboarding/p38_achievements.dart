import 'package:flutter/material.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

class P38Achievements extends StatelessWidget {
  final VoidCallback onNext;
  
  const P38Achievements({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final achievements = [
      {'icon': Icons.workspace_premium, 'name': 'Early Bird', 'desc': 'Log breakfast', 'color': Colors.amber, 'unlocked': true},
      {'icon': Icons.local_fire_department, 'name': 'Streak Master', 'desc': '7 day streak', 'color': Colors.orange, 'unlocked': true},
      {'icon': Icons.water_drop, 'name': 'Hydration Hero', 'desc': 'Hit water goal', 'color': Colors.blue, 'unlocked': true},
      {'icon': Icons.restaurant, 'name': 'Food Logger', 'desc': 'Log 50 meals', 'color': Colors.green, 'unlocked': true},
      {'icon': Icons.fitness_center, 'name': 'Gym Rat', 'desc': 'Work out 10x', 'color': Colors.red, 'unlocked': false},
      {'icon': Icons.bedtime, 'name': 'Sleep Champion', 'desc': '8hr sleep', 'color': Colors.purple, 'unlocked': false},
    ];
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Achievements', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 28)),
            const SizedBox(height: 8),
            Text('4 of 6 unlocked', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.grey.shade600)),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1, crossAxisSpacing: 12, mainAxisSpacing: 12),
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  final achievement = achievements[index];
                  final unlocked = achievement['unlocked'] as bool;
                  final color = achievement['color'] as Color;
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 56, height: 56,
                              decoration: BoxDecoration(
                                color: unlocked ? color.withOpacity(0.2) : Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(achievement['icon'] as IconData, color: unlocked ? color : Colors.grey.shade400, size: 28),
                            ),
                            if (!unlocked)
                              const Icon(Icons.lock, color: Colors.grey, size: 24),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(achievement['name'] as String, style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 13, color: unlocked ? Colors.black : Colors.grey), textAlign: TextAlign.center),
                        Text(achievement['desc'] as String, style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: Colors.grey.shade500), textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                const CanvasBear(mood: BearMood.celebrating, size: 50, animate: false),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(12)),
                    child: const Text("You're doing amazing! Keep going! 🏆", style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.amber)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CapsuleButton(text: 'Continue', onPressed: onNext),
          ],
        ),
      ),
    );
  }
}
