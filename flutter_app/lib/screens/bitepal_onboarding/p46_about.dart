import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';

/// P46: About & Support
/// "Made with Love for your health"
class P46About extends StatefulWidget {
  final VoidCallback onComplete;
  
  const P46About({super.key, required this.onComplete});
  
  @override
  State<P46About> createState() => _P46AboutState();
}

class _P46AboutState extends State<P46About>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  // Bear waving goodbye
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.pink.shade100.withOpacity(0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const CanvasBear(
                        mood: BearMood.heartHand,
                        size: 150,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Thank You!',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Made with ❤️ for your health',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Version info
                  Container(
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
                        _InfoRow(
                          icon: Icons.info_outline,
                          label: 'Version',
                          value: '2.4.1',
                        ),
                        const Divider(height: 24),
                        _InfoRow(
                          icon: Icons.privacy_tip_outlined,
                          label: 'Privacy Policy',
                          value: '',
                          onTap: () {},
                        ),
                        const Divider(height: 24),
                        _InfoRow(
                          icon: Icons.description_outlined,
                          label: 'Terms of Service',
                          value: '',
                          onTap: () {},
                        ),
                        const Divider(height: 24),
                        _InfoRow(
                          icon: Icons.help_outline,
                          label: 'Help & Support',
                          value: '',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  CapsuleButton(
                    text: 'Start using BitePal >',
                    onPressed: widget.onComplete,
                    backgroundColor: const Color(0xFF4CAF50),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '© 2026 BitePal. All rights reserved.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
              ),
            ),
          ),
          if (value.isNotEmpty)
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            )
          else if (onTap != null)
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
