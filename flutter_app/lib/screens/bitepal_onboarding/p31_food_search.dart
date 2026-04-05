import 'package:flutter/material.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

class P31FoodSearch extends StatelessWidget {
  final VoidCallback onNext;
  
  const P31FoodSearch({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(onPressed: onNext, icon: const Icon(Icons.arrow_back)),
                const Text('Add Food', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
            const SizedBox(height: 16),
            // Search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(decoration: const InputDecoration(hintText: 'Search for food', border: InputBorder.none, hintStyle: TextStyle(fontFamily: 'Inter')))),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Quick scan cards
            Row(
              children: [
                Expanded(
                  child: _ScanCard(icon: Icons.camera_alt, label: 'Quick Scan', color: const Color(0xFF4CAF50), onTap: onNext),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ScanCard(icon: Icons.qr_code_scanner, label: 'Scan Barcode', color: Colors.orange, onTap: onNext),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Recent', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  _FoodListItem(name: 'Apple', calories: 95, onTap: onNext),
                  _FoodListItem(name: 'Chicken Breast', calories: 165, onTap: onNext),
                  _FoodListItem(name: 'Brown Rice', calories: 215, onTap: onNext),
                  _FoodListItem(name: 'Greek Yogurt', calories: 100, onTap: onNext),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  
  const _ScanCard({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}

class _FoodListItem extends StatelessWidget {
  final String name;
  final int calories;
  final VoidCallback onTap;
  
  const _FoodListItem({required this.name, required this.calories, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(name, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
      trailing: Text('$calories kcal', style: TextStyle(fontFamily: 'Inter', color: Colors.grey.shade600)),
      onTap: onTap,
    );
  }
}
