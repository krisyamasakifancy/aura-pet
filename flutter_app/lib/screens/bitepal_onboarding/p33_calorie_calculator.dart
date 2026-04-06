import 'package:flutter/material.dart';

class P33CalorieCalculator extends StatelessWidget {
  final VoidCallback onNext;
  const P33CalorieCalculator({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calculate, size: 80, color: Color(0xFF6B9EB8)),
            const SizedBox(height: 32),
            const Text(
              '卡路里计算器',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '精准计算每日所需热量',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B9EB8),
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              ),
              child: const Text('继续'),
            ),
          ],
        ),
      ),
    );
  }
}
