import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';

/// P09: Goal Selection
/// "What is your main goal?"
class P09GoalSelection extends StatefulWidget {
  final VoidCallback onNext;
  
  const P09GoalSelection({super.key, required this.onNext});
  
  @override
  State<P09GoalSelection> createState() => _P09GoalSelectionState();
}

class _P09GoalSelectionState extends State<P09GoalSelection> {
  String? _selectedGoal;
  
  final _goals = [
    {
      'name': 'Lose weight',
      'icon': Icons.trending_down,
      'color': Colors.red.shade400,
      'subtitle': 'Burn more calories than you eat',
    },
    {
      'name': 'Maintain weight',
      'icon': Icons.horizontal_rule,
      'color': Colors.blue.shade400,
      'subtitle': 'Keep your current weight',
    },
    {
      'name': 'Gain weight',
      'icon': Icons.trending_up,
      'color': Colors.green.shade400,
      'subtitle': 'Build muscle and strength',
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
              'What is your\nmain goal?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Column(
                children: _goals.map((goal) {
                  final isSelected = _selectedGoal == goal['name'];
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SelectableCard(
                      title: goal['name'] as String,
                      subtitle: goal['subtitle'] as String,
                      icon: goal['icon'] as IconData,
                      iconColor: goal['color'] as Color,
                      selected: isSelected,
                      onTap: () {
                        setState(() => _selectedGoal = goal['name'] as String);
                        final goalKey = goal['name'] == 'Lose weight' 
                            ? 'lose_weight' 
                            : goal['name'] == 'Gain weight' 
                                ? 'gain_weight' 
                                : 'maintain_weight';
                        context.read<OnboardingState>().setMainGoal(goalKey);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            CapsuleButton(
              text: 'Next >',
              onPressed: _selectedGoal != null ? widget.onNext : null,
            ),
          ],
        ),
      ),
    );
  }
}
