import 'package:flutter/material.dart';

class MealResultScreen extends StatelessWidget {
  const MealResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('饮食分析结果'),
      ),
      body: const Center(
        child: Text('Meal Result Screen'),
      ),
    );
  }
}
