import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';

class P29HomeMacros extends StatelessWidget {
  final VoidCallback onNext;
  
  const P29HomeMacros({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Macronutrients', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 24)),
            const SizedBox(height: 24),
            // Carbs
            _MacroCard(name: 'Carbs', current: 75, goal: 100, color: Colors.orange, unit: 'g'),
            const SizedBox(height: 12),
            // Protein
            _MacroCard(name: 'Protein', current: 45, goal: 80, color: Colors.green, unit: 'g'),
            const SizedBox(height: 12),
            // Fats
            _MacroCard(name: 'Fats', current: 28, goal: 40, color: Colors.blue, unit: 'g'),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4))),
                const SizedBox(width: 8),
                Container(width: 24, height: 8, decoration: BoxDecoration(color: const Color(0xFF4CAF50), borderRadius: BorderRadius.circular(4))),
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

class _MacroCard extends StatelessWidget {
  final String name;
  final int current;
  final int goal;
  final Color color;
  final String unit;
  
  const _MacroCard({required this.name, required this.current, required this.goal, required this.color, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
              Text('$current / $goal $unit', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (current / goal).clamp(0.0, 1.0),
              child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
            ),
          ),
        ],
      ),
    );
  }
}
