import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../widgets/bitepal_widgets.dart';

class P34FastingPlans extends StatelessWidget {
  final VoidCallback onNext;
  
  const P34FastingPlans({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    
    final plans = [
      {'id': '14_10', 'name': '14:10', 'desc': '14h fast, 10h eat', 'hours': 14},
      {'id': '16_8', 'name': '16:8', 'desc': '16h fast, 8h eat', 'hours': 16},
      {'id': '18_6', 'name': '18:6', 'desc': '18h fast, 6h eat', 'hours': 18},
      {'id': '20_4', 'name': '20:4', 'desc': '20h fast, 4h eat', 'hours': 20},
    ];
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Fasting Plans', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 28)),
            const SizedBox(height: 8),
            Text('Choose your fasting schedule', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.grey.shade600)),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: plans.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  final isSelected = state.selectedFastingPlan == plan['id'];
                  return GestureDetector(
                    onTap: () => state.setFastingPlan(plan['id'] as String),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF4CAF50).withOpacity(0.1) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade200, width: isSelected ? 2 : 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56, height: 56,
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF4CAF50).withOpacity(0.2) : Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(plan['name'] as String, style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14, color: isSelected ? const Color(0xFF4CAF50) : Colors.grey)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(plan['name'] as String, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
                                Text(plan['desc'] as String, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey.shade600)),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Container(
                              width: 24, height: 24,
                              decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
                              child: const Icon(Icons.check, color: Colors.white, size: 16),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            CapsuleButton(text: 'Start Fasting', onPressed: onNext),
          ],
        ),
      ),
    );
  }
}
