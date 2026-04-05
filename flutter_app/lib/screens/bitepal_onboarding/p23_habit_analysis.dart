import 'package:flutter/material.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

class P23HabitAnalysis extends StatelessWidget {
  final VoidCallback onNext;
  
  const P23HabitAnalysis({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Based on your profile...', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 28)),
            const SizedBox(height: 24),
            Expanded(
              child: Column(
                children: [
                  _HabitBar(label: 'Sleep Quality', userScore: 65, avgScore: 72, color: Colors.purple),
                  const SizedBox(height: 16),
                  _HabitBar(label: 'Water Intake', userScore: 45, avgScore: 60, color: Colors.blue),
                  const SizedBox(height: 16),
                  _HabitBar(label: 'Meal Timing', userScore: 78, avgScore: 70, color: Colors.green),
                  const SizedBox(height: 16),
                  _HabitBar(label: 'Activity Level', userScore: 55, avgScore: 65, color: Colors.orange),
                ],
              ),
            ),
            Row(
              children: [
                const CanvasBear(mood: BearMood.thinking, size: 50, animate: false),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                    child: const Text("Room for improvement! Let's work together! 📈", style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.blue)),
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

class _HabitBar extends StatelessWidget {
  final String label;
  final int userScore;
  final int avgScore;
  final Color color;
  
  const _HabitBar({required this.label, required this.userScore, required this.avgScore, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14)),
              Text('$userScore%', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14, color: color)),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(height: 8, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4))),
              FractionallySizedBox(
                widthFactor: userScore / 100,
                child: Container(height: 8, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Avg: $avgScore%', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}
