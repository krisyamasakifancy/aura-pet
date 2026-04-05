import 'package:flutter/material.dart';
import '../../widgets/monet_background.dart';
import '../../widgets/canvas_bear.dart';

class P27WelcomeHome extends StatelessWidget {
  final VoidCallback onNext;
  
  const P27WelcomeHome({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFCE4EC), Color(0xFFE3F2FD)])),
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            const ConfettiAnimation(active: true),
            const CanvasBear(mood: BearMood.celebrating, size: 200, animate: true),
            const SizedBox(height: 32),
            const Text('Welcome to\nyour new life!', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 36, height: 1.2)),
            const SizedBox(height: 16),
            Text("Let's start your journey together", style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: Colors.grey.shade600)),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
                child: const Text('Start Journey', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
