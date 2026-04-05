import 'package:flutter/material.dart';
import '../../widgets/bitepal_widgets.dart';

/// P34: Fasting Plans
/// "Choose your fasting plan"
class P34FastingPlans extends StatefulWidget {
  final VoidCallback onNext;
  
  const P34FastingPlans({super.key, required this.onNext});
  
  @override
  State<P34FastingPlans> createState() => _P34FastingPlansState();
}

class _P34FastingPlansState extends State<P34FastingPlans> {
  String? _selectedPlan;
  
  final _plans = [
    {'name': '16:8', 'hours': 16, 'fasting': '14 hours', 'eating': '8 hours'},
    {'name': '18:6', 'hours': 18, 'fasting': '16 hours', 'eating': '6 hours'},
    {'name': '20:4', 'hours': 20, 'fasting': '20 hours', 'eating': '4 hours'},
    {'name': 'OMAD', 'hours': 23, 'fasting': '23 hours', 'eating': '1 hour'},
  ];
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Choose your\nfasting plan',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start with 16:8 if you\'re new to fasting',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: _plans.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final plan = _plans[index];
                  final isSelected = _selectedPlan == plan['name'];
                  
                  return GestureDetector(
                    onTap: () => setState(() => _selectedPlan = plan['name'] as String),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? const Color(0xFF4CAF50).withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected 
                              ? const Color(0xFF4CAF50)
                              : Colors.grey.shade200,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? const Color(0xFF4CAF50)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${plan['hours']}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: isSelected ? Colors.white : Colors.grey,
                                  ),
                                ),
                                Text(
                                  'hours',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isSelected 
                                        ? Colors.white70 
                                        : Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plan['name'] as String,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: isSelected 
                                        ? const Color(0xFF4CAF50)
                                        : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Fasting: ${plan['fasting']} • Eating: ${plan['eating']}',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF4CAF50),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            CapsuleButton(
              text: 'Start fasting >',
              onPressed: _selectedPlan != null ? widget.onNext : null,
              backgroundColor: const Color(0xFF4CAF50),
            ),
          ],
        ),
      ),
    );
  }
}
