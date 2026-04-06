import 'package:flutter/material.dart';

class P39Profile extends StatelessWidget {
  final VoidCallback onNext;
  const P39Profile({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 80, color: Color(0xFF6B9EB8)),
            const SizedBox(height: 32),
            const Text(
              '个人中心',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '管理您的账户和偏好设置',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B9EB8),
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              ),
              child: const Text('完成设置'),
            ),
          ],
        ),
      ),
    );
  }
}
