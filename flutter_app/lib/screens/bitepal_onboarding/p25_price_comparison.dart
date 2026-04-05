import 'package:flutter/material.dart';
import '../../widgets/bitepal_widgets.dart';

class P25PriceComparison extends StatelessWidget {
  final VoidCallback onNext;
  
  const P25PriceComparison({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose your path', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 28)),
            const SizedBox(height: 32),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _PlanCard(
                      title: 'Weekly',
                      price: '\$2.99',
                      period: '/week',
                      features: ['Basic tracking', '7-day history'],
                      isPopular: false,
                      onTap: onNext,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _PlanCard(
                      title: 'Yearly',
                      price: '\$19.00',
                      period: '/month',
                      features: ['Everything', 'Priority support', 'Save 60%'],
                      isPopular: true,
                      onTap: onNext,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CapsuleButton(text: 'Continue', onPressed: onNext),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final List<String> features;
  final bool isPopular;
  final VoidCallback onTap;
  
  const _PlanCard({required this.title, required this.price, required this.period, required this.features, required this.isPopular, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isPopular ? const Color(0xFF4CAF50) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isPopular ? const Color(0xFF4CAF50) : Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPopular)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(12)),
                child: const Text('Most Popular', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 10, color: Colors.black)),
              ),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 18, color: isPopular ? Colors.white : Colors.black)),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(price, style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 28, color: isPopular ? Colors.white : Colors.black)),
                Text(period, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isPopular ? Colors.white70 : Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            ...features.map((f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.check, size: 16, color: isPopular ? Colors.white : const Color(0xFF4CAF50)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(f, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isPopular ? Colors.white : Colors.grey.shade700))),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
