import 'package:flutter/material.dart';

/// P46: About - App information and credits
class P46About extends StatelessWidget {
  final VoidCallback onNext;
  
  const P46About({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEDF6FA), Colors.white],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'About',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 24),
                  
                  // App logo and name
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100, height: 100,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4CAF50).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.pets,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Aura-Pet',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Mission statement
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF4CAF50).withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Color(0xFF4CAF50),
                          size: 32,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Your Health, Our Mission',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Aura-Pet combines cutting-edge AI with adorable pet companions to make your wellness journey delightful and effective.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Features list
                  const _FeatureRow(icon: Icons.ai, text: 'AI Vision Food Recognition'),
                  const _FeatureRow(icon: Icons.water_drop, text: 'Smart Water Tracking'),
                  const _FeatureRow(icon: Icons.timer, text: 'Fasting Timer with Insights'),
                  const _FeatureRow(icon: Icons.emoji_events, text: 'Achievement System'),
                  const _FeatureRow(icon: Icons.pets, text: 'Pet Companion & Dressing'),
                  const _FeatureRow(icon: Icons.share, text: 'Monet Garden Social Sharing'),
                  
                  const SizedBox(height: 24),
                  
                  // Credits
                  _InfoCard(
                    title: 'Made with ❤️',
                    subtitle: 'Designed for your wellness journey',
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Legal links
                  _LinkTile(
                    icon: Icons.privacy_tip,
                    title: 'Privacy Policy',
                    onTap: () {},
                  ),
                  _LinkTile(
                    icon: Icons.description,
                    title: 'Terms of Service',
                    onTap: () {},
                  ),
                  _LinkTile(
                    icon: Icons.code,
                    title: 'Open Source Licenses',
                    onTap: () {},
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Copyright
                  Center(
                    child: Text(
                      '© 2026 Aura-Pet. All rights reserved.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                ],
              ),
            ),
            
            // Complete onboarding button
            Padding(
              padding: const EdgeInsets.all(24),
              child: _CapsuleButton(
                text: 'Complete Setup',
                onPressed: onNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  
  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF4CAF50), size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  
  const _InfoCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.pets,
            color: Color(0xFF4CAF50),
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF2D3748),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  
  const _LinkTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade600, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Color(0xFF2D3748),
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

class _CapsuleButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  
  const _CapsuleButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CAF50).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
