import 'package:flutter/material.dart';
import '../../widgets/bitepal_widgets.dart';

class P37WaterHistory extends StatelessWidget {
  final VoidCallback onNext;
  
  const P37WaterHistory({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final values = [1.5, 2.0, 1.8, 2.5, 2.2, 2.8, 1.0];
    final goal = 2.5;
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Water History', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 28)),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)]),
                child: Column(
                  children: [
                    const Text('This Week', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(7, (index) {
                          final value = values[index];
                          final height = (value / goal * 150).clamp(20.0, 150.0);
                          final met = value >= goal;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('${value}L', style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: Colors.grey.shade600)),
                              const SizedBox(height: 4),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 30,
                                height: height,
                                decoration: BoxDecoration(
                                  color: met ? const Color(0xFF4CAF50) : Colors.blue.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(days[index], style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: index == 6 ? const Color(0xFF4CAF50) : Colors.grey)),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(width: 12, height: 12, decoration: BoxDecoration(color: const Color(0xFF4CAF50), borderRadius: BorderRadius.circular(4))),
                const SizedBox(width: 8),
                Text('Goal met', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(width: 24),
                Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.blue.shade200, borderRadius: BorderRadius.circular(4))),
                const SizedBox(width: 8),
                Text('Below goal', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
            const SizedBox(height: 16),
            CapsuleButton(text: 'Continue', onPressed: onNext),
          ],
        ),
      ),
    );
  }
}
