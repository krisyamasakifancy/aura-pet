import 'package:flutter/material.dart';
import '../../widgets/bitepal_widgets.dart';

/// P25: Price Comparison
/// "Choose your path"
class P25PriceComparison extends StatefulWidget {
  final VoidCallback onNext;
  
  const P25PriceComparison({super.key, required this.onNext});
  
  @override
  State<P25PriceComparison> createState() => _P25PriceComparisonState();
}

class _P25PriceComparisonState extends State<P25PriceComparison> {
  int _selectedPlan = 1; // 0 = weekly, 1 = yearly
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Choose your path',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Column(
                children: [
                  // Weekly plan
                  _PlanCard(
                    title: 'Weekly',
                    price: '\$2.99',
                    period: 'per week',
                    features: const [
                      'AI food recognition',
                      'Basic meal plans',
                      'Water tracking',
                    ],
                    isSelected: _selectedPlan == 0,
                    onTap: () => setState(() => _selectedPlan = 0),
                  ),
                  const SizedBox(height: 16),
                  // Yearly plan (recommended)
                  _PlanCard(
                    title: 'Yearly',
                    price: '\$4.99',
                    period: 'per month',
                    features: const [
                      'Everything in Weekly',
                      'Advanced analytics',
                      'Virtual pet skins',
                      'Priority support',
                    ],
                    isSelected: _selectedPlan == 1,
                    isRecommended: true,
                    savings: 'Save \$95.88',
                    onTap: () => setState(() => _selectedPlan = 1),
                  ),
                ],
              ),
            ),
            CapsuleButton(
              text: 'Continue with ${_selectedPlan == 0 ? 'Weekly' : 'Yearly'} >',
              onPressed: widget.onNext,
              backgroundColor: const Color(0xFF4CAF50),
            ),
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
  final bool isSelected;
  final bool isRecommended;
  final String? savings;
  final VoidCallback onTap;
  
  const _PlanCard({
    required this.title,
    required this.price,
    required this.period,
    required this.features,
    required this.isSelected,
    this.isRecommended = false,
    this.savings,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CAF50).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : null,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                if (isRecommended)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Best value',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    period,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                if (savings != null) ...[
                  const Spacer(),
                  Text(
                    savings!,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.green.shade600,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            ...features.map((f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.check,
                    size: 16,
                    color: isSelected ? const Color(0xFF4CAF50) : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    f,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
