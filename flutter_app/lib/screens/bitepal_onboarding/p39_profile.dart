import 'package:flutter/material.dart';
import '../../widgets/bitepal_widgets.dart';

class P39Profile extends StatelessWidget {
  final VoidCallback onNext;
  
  const P39Profile({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Profile', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 28)),
            const Spacer(),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 120, height: 120,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade200),
                  child: const Icon(Icons.person, size: 60, color: Colors.grey),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
                  child: const Icon(Icons.check, color: Colors.white, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Colvin', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 24)),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(value: '24.2', label: 'BMI', icon: Icons.monitor_weight, color: Colors.green),
                  _StatItem(value: '12', label: 'Day Streak', icon: Icons.local_fire_department, color: Colors.orange),
                  _StatItem(value: '45', label: 'Meals', icon: Icons.restaurant, color: Colors.blue),
                ],
              ),
            ),
            const Spacer(),
            CapsuleButton(text: 'Continue', onPressed: onNext),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  
  const _StatItem({required this.value, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20)),
        Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }
}
