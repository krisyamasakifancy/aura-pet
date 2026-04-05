import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';

/// P20: Enable Notifications
/// "Stay on track!"
class P20Notifications extends StatefulWidget {
  final VoidCallback onNext;
  
  const P20Notifications({super.key, required this.onNext});
  
  @override
  State<P20Notifications> createState() => _P20NotificationsState();
}

class _P20NotificationsState extends State<P20Notifications> {
  bool _enabled = false;
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Stay on track!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enable notifications to never miss\na meal or water reminder',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const Spacer(),
            // Bear with alarm
            Stack(
              alignment: Alignment.topRight,
              children: [
                const CanvasBear(
                  mood: BearMood.defaultMood,
                  size: 180,
                ),
                // Small alarm icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.notifications_active,
                    color: Color(0xFFFF9800),
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Enable button
            GestureDetector(
              onTap: () {
                setState(() => _enabled = true);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _enabled ? const Color(0xFF4CAF50) : Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (_enabled ? const Color(0xFF4CAF50) : Colors.black)
                          .withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      _enabled ? Icons.check : Icons.notifications,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _enabled 
                          ? 'Notifications Enabled!' 
                          : 'Enable Notifications',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: widget.onNext,
              child: Text(
                'Maybe later',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
            const Spacer(),
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
