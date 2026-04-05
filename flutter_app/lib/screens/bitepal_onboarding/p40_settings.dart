import 'package:flutter/material.dart';
import '../../widgets/bitepal_widgets.dart';

class P40Settings extends StatelessWidget {
  final VoidCallback onNext;
  
  const P40Settings({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Settings', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 28)),
            const SizedBox(height: 32),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
                child: Column(
                  children: [
                    _SettingsItem(icon: Icons.notifications, title: 'Notifications', subtitle: 'Meal & water reminders', trailing: Switch(value: true, onChanged: (_) {}, activeColor: const Color(0xFF4CAF50))),
                    const Divider(height: 32),
                    _SettingsItem(icon: Icons.straighten, title: 'Units', subtitle: 'kg / cm', trailing: const Icon(Icons.chevron_right)),
                    const Divider(height: 32),
                    _SettingsItem(icon: Icons.timer, title: 'Fasting Reminders', subtitle: 'Daily at 8:00 PM', trailing: Switch(value: true, onChanged: (_) {}, activeColor: const Color(0xFF4CAF50))),
                    const Divider(height: 32),
                    _SettingsItem(icon: Icons.water_drop, title: 'Water Reminders', subtitle: 'Every 2 hours', trailing: Switch(value: false, onChanged: (_) {}, activeColor: const Color(0xFF4CAF50))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            CapsuleButton(text: 'Continue', onPressed: onNext),
          ],
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  
  const _SettingsItem({required this.icon, required this.title, required this.subtitle, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: Colors.grey.shade700),
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
        trailing,
      ],
    );
  }
}
