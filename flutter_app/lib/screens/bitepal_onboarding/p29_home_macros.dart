import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';

/// P29: Home - Macros Tab
/// Macronutrient breakdown
class P29HomeMacros extends StatelessWidget {
  final VoidCallback onNext;
  
  const P29HomeMacros({super.key, required this.onNext});
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Macronutrients',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your daily breakdown',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            // Circular progress for each macro
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MacroCircle(
                  label: 'Carbs',
                  current: 95,
                  goal: 150,
                  color: Colors.orange,
                  icon: Icons.grain,
                ),
                _MacroCircle(
                  label: 'Protein',
                  current: 65,
                  goal: 80,
                  color: Colors.red,
                  icon: Icons.egg,
                ),
                _MacroCircle(
                  label: 'Fats',
                  current: 35,
                  goal: 50,
                  color: Colors.yellow.shade700,
                  icon: Icons.water_drop,
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Detail bars
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Today's Meals',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _MealItem(
                      name: 'Oatmeal with berries',
                      calories: 310,
                      time: '8:30 AM',
                      color: Colors.orange,
                    ),
                    const Divider(height: 24),
                    _MealItem(
                      name: 'Grilled chicken salad',
                      calories: 450,
                      time: '12:45 PM',
                      color: Colors.green,
                    ),
                    const Divider(height: 24),
                    _MealItem(
                      name: 'Salmon with vegetables',
                      calories: 520,
                      time: '7:00 PM',
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Bear feedback
            Row(
              children: [
                const CanvasBear(
                  mood: BearMood.curious,
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
                    'Your protein intake is on track!',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: Colors.blue.shade700,
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

class _MacroCircle extends StatelessWidget {
  final String label;
  final int current;
  final int goal;
  final Color color;
  final IconData icon;
  
  const _MacroCircle({
    required this.label,
    required this.current,
    required this.goal,
    required this.color,
    required this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    final progress = current / goal;
    
    return Column(
      children: [
        SizedBox(
          width: 90,
          height: 90,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgress(
                progress: progress,
                size: 90,
                strokeWidth: 8,
                progressColor: color,
                backgroundColor: color.withOpacity(0.2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: color, size: 20),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        Text(
          '$current / $goal g',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class _MealItem extends StatelessWidget {
  final String name;
  final int calories;
  final String time;
  final Color color;
  
  const _MealItem({
    required this.name,
    required this.calories,
    required this.time,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.restaurant, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
        Text(
          '$calories kcal',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: color,
          ),
        ),
      ],
    );
  }
}
