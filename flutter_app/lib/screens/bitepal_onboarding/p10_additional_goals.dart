import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';

/// P10: Additional Goals
/// "Any additional goals?"
class P10AdditionalGoals extends StatefulWidget {
  final VoidCallback onNext;
  
  const P10AdditionalGoals({super.key, required this.onNext});
  
  @override
  State<P10AdditionalGoals> createState() => _P10AdditionalGoalsState();
}

class _P10AdditionalGoalsState extends State<P10AdditionalGoals> {
  final List<String> _selectedGoals = [];
  
  final _goals = [
    {'name': 'Build healthy relationship with food', 'icon': Icons.favorite},
    {'name': 'Boost daily energy', 'icon': Icons.bolt},
    {'name': 'Improve sleep quality', 'icon': Icons.bedtime},
    {'name': 'Reduce stress', 'icon': Icons.spa},
    {'name': 'Build muscle', 'icon': Icons.fitness_center},
    {'name': 'Eat more vegetables', 'icon': Icons.eco},
    {'name': 'Drink more water', 'icon': Icons.water_drop},
    {'name': 'Try intermittent fasting', 'icon': Icons.schedule},
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
              'Any additional\ngoals?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select all that apply',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: _goals.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final goal = _goals[index]['name'] as String;
                  final icon = _goals[index]['icon'] as IconData;
                  final isSelected = _selectedGoals.contains(goal);
                  
                  return MultiSelectCard(
                    title: goal,
                    icon: icon,
                    selected: isSelected,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedGoals.remove(goal);
                          context.read<OnboardingState>().removeAdditionalGoal(goal);
                        } else {
                          _selectedGoals.add(goal);
                          context.read<OnboardingState>().addAdditionalGoal(goal);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            CapsuleButton(
              text: 'Next >',
              onPressed: widget.onNext,
            ),
          ],
        ),
      ),
    );
  }
}
