import 'package:flutter/material.dart';
import '../utils/aura_theme.dart';
import '../widgets/q_raccoon_canvas.dart';

/// 极简空气感引导页 - 对标竞品截图
class AuraOnboardingScreen extends StatefulWidget {
  const AuraOnboardingScreen({super.key});

  @override
  State<AuraOnboardingScreen> createState() => _AuraOnboardingScreenState();
}

class _AuraOnboardingScreenState extends State<AuraOnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      title: 'Reach',
      titleAccent: 'your',
      subtitle: 'weight goals',
      description: 'Track meals, water, and fasting with your cute pet companion.',
      emoji: '💪',
    ),
    _OnboardingPage(
      title: 'Snap &',
      titleAccent: 'Log',
      subtitle: 'instantly',
      description: 'AI-powered food recognition. Just snap a photo.',
      emoji: '📸',
    ),
    _OnboardingPage(
      title: 'Stay',
      titleAccent: 'motivated',
      subtitle: 'every day',
      description: 'Your pet evolves as you reach your health goals.',
      emoji: '🐻',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AuraPetTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 跳过按钮
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/auth/login'),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AuraPetTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),

              // 页面内容
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),

              // 指示器
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AuraPetTheme.primary
                            : AuraPetTheme.textLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),

              // 底部按钮
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                        );
                      } else {
                        Navigator.pushReplacementNamed(context, '/auth/login');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AuraPetTheme.textPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      _currentPage < _pages.length - 1 ? 'Next' : 'Get started',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 小熊展示
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AuraPetTheme.auraGlow.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
            child: const Center(
              child: QRaccoonCanvas(
                size: 180,
                showHeart: true,
                auraScore: 100,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // 标题
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${page.title} ',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: AuraPetTheme.textPrimary,
                    height: 1.2,
                  ),
                ),
                TextSpan(
                  text: page.titleAccent,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: AuraPetTheme.primary,
                    height: 1.2,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          Text(
            page.subtitle,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: AuraPetTheme.textPrimary,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 20),

          // 描述
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AuraPetTheme.textSecondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 32),

          // Emoji 装饰
          Text(
            page.emoji,
            style: const TextStyle(fontSize: 40),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final String title;
  final String titleAccent;
  final String subtitle;
  final String description;
  final String emoji;

  _OnboardingPage({
    required this.title,
    required this.titleAccent,
    required this.subtitle,
    required this.description,
    required this.emoji,
  });
}
