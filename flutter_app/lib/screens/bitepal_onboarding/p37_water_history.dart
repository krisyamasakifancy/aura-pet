import 'package:flutter/material.dart';
import '../../widgets/bitepal_widgets.dart';

/// P37: Water History
/// Weekly bar chart
class P37WaterHistory extends StatelessWidget {
  final VoidCallback onNext;
  
  const P37WaterHistory({super.key, required this.onNext});
  
  @override
  Widget build(BuildContext context) {
    final _weekData = [
      {'day': 'Mon', 'amount': 2.0, 'goal': 2.5},
      {'day': 'Tue', 'amount': 2.2, 'goal': 2.5},
      {'day': 'Wed', 'amount': 1.8, 'goal': 2.5},
      {'day': 'Thu', 'amount': 2.5, 'goal': 2.5},
      {'day': 'Fri', 'amount': 2.3, 'goal': 2.5},
      {'day': 'Sat', 'amount': 2.0, 'goal': 2.5},
      {'day': 'Sun', 'amount': 1.5, 'goal': 2.5},
    ];
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Water History',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This week\'s progress',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            // Weekly average
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.water_drop,
                      color: Colors.blue,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Average',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const Text(
                        '2.0L / day',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        '80% of goal',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Bar chart
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: _weekData.map((data) {
                          final progress = (data['amount'] as double) / 
                              (data['goal'] as double);
                          final isToday = data['day'] == 'Sun';
                          
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${data['amount']}L',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 10,
                                      color: isToday 
                                          ? Colors.blue 
                                          : Colors.grey,
                                      fontWeight: isToday 
                                          ? FontWeight.bold 
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    height: 150 * progress.clamp(0.0, 1.0),
                                    decoration: BoxDecoration(
                                      color: progress >= 1.0 
                                          ? Colors.green 
                                          : Colors.blue.shade300,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    data['day'] as String,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11,
                                      color: isToday 
                                          ? Colors.blue 
                                          : Colors.grey,
                                      fontWeight: isToday 
                                          ? FontWeight.bold 
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            CapsuleButton(
              text: 'Next >',
              onPressed: onNext,
            ),
          ],
        ),
      ),
    );
  }
}
