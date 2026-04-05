import 'package:flutter/material.dart';
import '../../widgets/bitepal_widgets.dart';

class P45NotificationSettings extends StatelessWidget {
  final VoidCallback onNext;
  
  const P45NotificationSettings({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notifications', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 28)),
            Text("Customize your reminders", style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.grey.shade600)),
            const SizedBox(height: 32),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
                child: Column(
                  children: [
                    _ToggleItem(icon: Icons.restaurant, title: 'Meal reminders', subtitle: 'Before each meal', value: true, color: Colors.orange),
                    const Divider(height: 32),
                    _ToggleItem(icon: Icons.water_drop, title: 'Water reminders', subtitle: 'Every 2 hours', value: true, color: Colors.blue),
                    const Divider(height: 32),
                    _ToggleItem(icon: Icons.monitor_weight, title: 'Weight tracking', subtitle: 'Daily at 9:00 AM', value: false, color: Colors.green),
                    const Divider(height: 32),
                    _ToggleItem(icon: Icons.timer, title: 'Fasting reminders', subtitle: 'End of fasting window', value: true, color: Colors.purple),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Tip: Customize reminders to stay motivated without being overwhelmed!', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.blue.shade700))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CapsuleButton(text: 'Save & Continue', onPressed: onNext),
          ],
        ),
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Color color;
  
  const _ToggleItem({required this.icon, required this.title, required this.subtitle, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 15)),
              Text(subtitle, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
        ),
        Switch(value: value, onChanged: (_) {}, activeColor: color),
      ],
    );
  }
}
