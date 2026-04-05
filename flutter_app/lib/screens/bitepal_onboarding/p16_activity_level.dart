import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';

/// P16: Activity Level
/// "What's your activity level?"
class P16ActivityLevel extends StatefulWidget {
  final VoidCallback onNext;
  
  const P16ActivityLevel({super.key, required this.onNext});
  
  @override
  State<P16ActivityLevel> createState() => _P16ActivityLevelState();
}

class _P16ActivityLevelState extends State<P16ActivityLevel> {
  String? _selectedLevel;
  
  final _levels = [
    {
      'name': 'Sedentary',
      'desc': 'Little or no exercise',
      'icon': Icons.weekend,
      'color': Colors.grey,
    },
    {
      'name': 'Lightly Active',
      'desc': '1-3 days/week',
      'icon': Icons.directions_walk,
      'color': Colors.green,
    },
    {
      'name': 'Moderately Active',
      'desc': '3-5 days/week',
      'icon': Icons.directions_run,
      'color': Colors.blue,
    },
    {
      'name': 'Very Active',
      'desc': '6-7 days/week',
      'icon': Icons.fitness_center,
      'color': Colors.orange,
    },
    {
      'name': 'Extra Active',
      'desc': 'Physical job + training',
      'icon': Icons.sports_martial_arts,
      'color': Colors.red,
    },
  ];
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              "What's your\nactivity level?",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: _levels.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final level = _levels[index];
                  final isSelected = _selectedLevel == level['name'];
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedLevel = level['name']);
                      final key = (level['name'] as String).toLowerCase().replaceAll(' ', '_');
                      context.read<OnboardingState>().setActivityLevel(key);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? (level['color'] as Color).withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected 
                              ? level['color'] as Color 
                              : Colors.grey.shade200,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: (level['color'] as Color).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              level['icon'] as IconData,
                              color: level['color'] as Color,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  level['name'] as String,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: isSelected 
                                        ? Colors.black 
                                        : Colors.grey.shade700,
                                  ),
                                ),
                                Text(
                                  level['desc'] as String,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: level['color'] as Color,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            CapsuleButton(
              text: 'Next >',
              onPressed: _selectedLevel != null ? widget.onNext : null,
            ),
          ],
        ),
      ),
    );
  }
}
