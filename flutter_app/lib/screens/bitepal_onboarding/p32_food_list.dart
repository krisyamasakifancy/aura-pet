import 'package:flutter/material.dart';

class P32FoodList extends StatelessWidget {
  final VoidCallback onNext;
  const P32FoodList({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              '食物记录',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.restaurant),
                    title: Text('红烧肉'),
                    subtitle: Text('450 kcal'),
                  ),
                  ListTile(
                    leading: Icon(Icons.restaurant),
                    title: Text('麻辣烫'),
                    subtitle: Text('380 kcal'),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onNext,
              child: const Text('继续'),
            ),
          ],
        ),
      ),
    );
  }
}
