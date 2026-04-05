import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';

/// P26: Commitment Page
/// "We are committed to your success"
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
            const SizedBox(height: 40),
            // Bear making promise gesture
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.pink.shade100.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                const CanvasBear(
                  mood: BearMood.heartHand,
                  size: 160,
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'We are committed\nto your success',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your journey to better health\nstarts right now',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            // Trust badges
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _TrustBadge(
                        icon: Icons.shield,
                        label: '100% Secure',
                        color: Colors.blue,
                      ),
                      _TrustBadge(
                        icon: Icons.refresh,
                        label: '30-day Refund',
                        color: Colors.green,
                      ),
                      _TrustBadge(
                        icon: Icons.lock,
                        label: 'Private Data',
                        color: Colors.purple,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            CapsuleButton(
              text: 'Start my journey >',
              onPressed: onNext,
              backgroundColor: const Color(0xFF4CAF50),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onNext,
              child: Text(
                'Skip for now',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  
  const _TrustBadge({
    required this.icon,
    required this.label,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
