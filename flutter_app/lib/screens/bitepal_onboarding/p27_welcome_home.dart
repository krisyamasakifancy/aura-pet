import 'package:flutter/material.dart';

class P27WelcomeHome extends StatelessWidget {
  final VoidCallback onNext;
  const P27WelcomeHome({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 80, color: Color(0xFF6B9EB8)),
            const SizedBox(height: 32),
            const Text(
              '欢迎回家！',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '您的个人健康管家已就绪',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B9EB8),
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              ),
              child: const Text('开始使用', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
