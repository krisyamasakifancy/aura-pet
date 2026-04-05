import 'package:flutter/material.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

class P26Commitment extends StatelessWidget {
  final VoidCallback onNext;
  
  const P26Commitment({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            const CanvasBear(mood: BearMood.heartHand, size: 150, animate: true),
            const SizedBox(height: 32),
            const Text("We are committed\nto your success", textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 28, height: 1.2)),
            const SizedBox(height: 16),
            Text('30-day money-back guarantee', style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: Colors.grey.shade600)),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TrustBadge(icon: Icons.verified_user, label: 'Secure'),
                const SizedBox(width: 24),
                _TrustBadge(icon: Icons.lock, label: 'Private'),
                const SizedBox(width: 24),
                _TrustBadge(icon: Icons.refresh, label: 'Refund'),
              ],
            ),
            const Spacer(),
            CapsuleButton(text: "I'm committed!", onPressed: onNext, backgroundColor: const Color(0xFF4CAF50)),
            const SizedBox(height: 12),
            SkipButton(onPressed: onNext, text: 'Skip for now'),
          ],
        ),
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  
  const _TrustBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }
}
