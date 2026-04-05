import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

class P20Notifications extends StatelessWidget {
  final VoidCallback onNext;
  
  const P20Notifications({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            const Text(
              'Stay on track!',
              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 32),
            ),
            const SizedBox(height: 16),
            Text(
              'Enable notifications to get reminders',
              style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 40),
            // Notification illustration
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    shape: BoxShape.circle,
                  ),
                ),
                const Icon(Icons.notifications_active, size: 80, color: Colors.orange),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                const CanvasBear(mood: BearMood.curious, size: 50, animate: false),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(12)),
                    child: const Text("Don't miss your reminders! 🔔", style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.orange)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CapsuleButton(
              text: 'Enable Notifications',
              onPressed: () {
                state.setNotifications(true);
                onNext();
              },
              backgroundColor: const Color(0xFF4CAF50),
            ),
            const SizedBox(height: 12),
            SkipButton(onPressed: onNext, text: 'Maybe later'),
          ],
        ),
      ),
    );
  }
}
