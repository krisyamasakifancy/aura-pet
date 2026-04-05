import 'package:flutter/material.dart';
import '../../widgets/bitepal_widgets.dart';

/// P24: Paywall
/// "Get your personalized plan"
class P24Paywall extends StatefulWidget {
  final VoidCallback onNext;
  
  const P24Paywall({super.key, required this.onNext});
  
  @override
  State<P24Paywall> createState() => _P24PaywallState();
}

class _P24PaywallState extends State<P24Paywall> {
  bool _isYearly = true;
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE0B2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer, size: 16, color: Colors.orange),
                  const SizedBox(width: 8),
                  const Text(
                    'Limited offer: 15 min left',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Get your personalized plan',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 32),
            // Toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ToggleButton(
                    label: 'Monthly',
                    selected: !_isYearly,
                    onTap: () => setState(() => _isYearly = false),
                  ),
                  _ToggleButton(
                    label: 'Yearly',
                    selected: _isYearly,
                    onTap: () => setState(() => _isYearly = true),
                    badge: '-40%',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Price card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFFD700).withOpacity(0.2),
                    const Color(0xFFFFA500).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFFFD700), width: 2),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.workspace_premium,
                    color: Color(0xFFFFD700),
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'BitePal Plus',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: _isYearly ? '\$4.99' : '\$9.99',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: _isYearly ? '/month' : '',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isYearly)
                    Text(
                      'Save \$95.88/year',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.green.shade600,
                      ),
                    ),
                  const SizedBox(height: 20),
                  const _FeatureItem(text: 'AI food recognition'),
                  const _FeatureItem(text: 'Personalized meal plans'),
                  const _FeatureItem(text: 'Advanced analytics'),
                  const _FeatureItem(text: 'Virtual pet accessories'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CapsuleButton(
              text: 'Get my plan for ${_isYearly ? '\$59.99' : '\$9.99'} >',
              onPressed: widget.onNext,
              backgroundColor: const Color(0xFF4CAF50),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: widget.onNext,
              child: const Text(
                'Maybe later',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? badge;
  
  const _ToggleButton({
    required this.label,
    required this.selected,
    required this.onTap,
    this.badge,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: selected ? Colors.black : Colors.grey.shade600,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
