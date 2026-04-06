import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AuraPetTheme.primary, AuraPetTheme.primaryDark],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('×', style: TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('🐻✨', style: TextStyle(fontSize: 50)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '升级到小熊会员',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '解锁全部功能，加速达成目标！',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Card
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: AuraPetTheme.white,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AuraPetTheme.secondary, Color(0xFFFFE066)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '⭐ 年度会员',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF8B6914),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: '¥228',
                                    style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.w900,
                                      color: AuraPetTheme.textDark,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '/年',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AuraPetTheme.textLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              '每月仅 ¥19，折合每天 ¥0.6',
                              style: TextStyle(
                                color: AuraPetTheme.textLight,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Features
                            const _FeatureItem(text: '无限食物识别'),
                            const _FeatureItem(text: '深度营养分析'),
                            const _FeatureItem(text: '高级禁食方案'),
                            const _FeatureItem(text: '小熊进化路线'),
                            const _FeatureItem(text: '专属装饰商城'),

                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AuraPetTheme.textDark,
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                ),
                                child: const Text('立即开通 💎'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '轻松取消 · 安全支付 · 7天退款保证',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AuraPetTheme.accent,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('✓', style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AuraPetTheme.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
