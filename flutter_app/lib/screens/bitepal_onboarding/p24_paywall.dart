import 'package:flutter/material.dart';
import '../../widgets/monet_background.dart';
import '../../widgets/canvas_bear.dart';

class P24Paywall extends StatelessWidget {
  final VoidCallback onNext;
  
  const P24Paywall({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFCE4EC),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text('Get your personalized plan', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 28)),
              const SizedBox(height: 8),
              Text('Limited time: 15:00 remaining', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.red.shade400)),
              const SizedBox(height: 32),
              // Gold card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA500)]),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 48),
                    const SizedBox(height: 12),
                    const Text('BitePal Plus', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
                    const SizedBox(height: 8),
                    const Text('Unlock all features', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.white70)),
                    const SizedBox(height: 16),
                    const Text('\$9.99/month', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Column(
                  children: [
                    _FeatureItem(text: 'AI Food Scanner'),
                    _FeatureItem(text: 'Advanced Analytics'),
                    _FeatureItem(text: 'Custom Meal Plans'),
                    _FeatureItem(text: 'Priority Support'),
                  ],
                ),
              ),
              const CanvasBear(mood: BearMood.expecting, size: 50, animate: false),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
                child: const Text('Get my plan for \$9.99', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;
  const _FeatureItem({required this.text});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(color: const Color(0xFF4CAF50), shape: BoxShape.circle),
            child: const Icon(Icons.check, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontFamily: 'Inter', fontSize: 14)),
        ],
      ),
    );
  }
}
