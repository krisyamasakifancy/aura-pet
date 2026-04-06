import 'package:flutter/material.dart';

class P22WeightPrediction extends StatelessWidget {
  final VoidCallback onNext;
  const P22WeightPrediction({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.monitor_weight, size: 80, color: Color(0xFF6B9EB8)),
            const SizedBox(height: 32),
            const Text(
              '体重预测',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '输入您的目标体重\n我们将为您规划最佳路径',
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
              child: const Text('继续', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
