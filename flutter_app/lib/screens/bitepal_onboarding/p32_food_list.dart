import 'package:flutter/material.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

class P32FoodList extends StatelessWidget {
  final VoidCallback onNext;
  
  const P32FoodList({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final foods = [
      {'name': 'Sweet Potato', 'calories': 120, 'selected': false},
      {'name': 'Avocado', 'calories': 100, 'selected': true},
      {'name': 'Grilled Chicken', 'calories': 165, 'selected': false},
      {'name': 'Brown Rice', 'calories': 85, 'selected': false},
    ];
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(onPressed: onNext, icon: const Icon(Icons.arrow_back)),
                const Text('Select Food', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: foods.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final food = foods[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(food['name'] as String, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
                    subtitle: Text('${food['calories']} kcal', style: TextStyle(fontFamily: 'Inter', color: Colors.grey.shade600)),
                    trailing: Icon(
                      food['selected'] == true ? Icons.check_circle : Icons.add_circle_outline,
                      color: food['selected'] == true ? const Color(0xFF4CAF50) : Colors.grey,
                    ),
                    onTap: onNext,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const CanvasBear(mood: BearMood.heartEyes, size: 50, animate: false),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                    child: const Text("Yummy choices! 🍽️", style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.green)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CapsuleButton(text: 'Add to Diary', onPressed: onNext),
          ],
        ),
      ),
    );
  }
}
