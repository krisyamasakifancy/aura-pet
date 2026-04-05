import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../providers/pet_provider.dart';
import '../../utils/theme.dart';
import '../../utils/router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  String? _selectedGoal;
  String? _selectedFeature;

  final List<OnboardingStep> _steps = [
    OnboardingStep(
      title: '你好！我是小熊 🐻',
      subtitle: '你的健康伙伴今天也很期待见到你！',
      emoji: '🐻',
    ),
    OnboardingStep(
      title: '你的健康目标是什么？',
      subtitle: '选择你最想要的改变',
      emoji: '🎯',
    ),
    OnboardingStep(
      title: '你最想要什么功能？',
      subtitle: '选择你最关心的健康功能',
      emoji: '💪',
    ),
    OnboardingStep(
      title: '准备好了吗？',
      subtitle: '小熊已经迫不及待要帮助你了！',
      emoji: '🎉',
    ),
  ];

  final List<Map<String, String>> _goalOptions = [
    {'icon': '🎯', 'title': '减重', 'desc': '健康地减少体脂', 'val': 'lose'},
    {'icon': '⚖️', 'title': '维持体重', 'desc': '保持当前体重稳定', 'val': 'maintain'},
    {'icon': '💪', 'title': '增肌', 'desc': '增加肌肉量', 'val': 'gain'},
  ];

  final List<Map<String, String>> _featureOptions = [
    {'icon': '📸', 'title': '拍照记录', 'desc': 'AI识别食物', 'val': 'photo'},
    {'icon': '⏰', 'title': '轻断食', 'desc': '16:8间歇性禁食', 'val': 'fasting'},
    {'icon': '💧', 'title': '多喝水', 'desc': '追踪每日饮水', 'val': 'water'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            Padding(
              padding: const EdgeInsets.all(24),
              child: LinearProgressIndicator(
                value: ((_currentStep + 1) / _steps.length),
                backgroundColor: AuraPetTheme.primary.withValues(alpha: 0.2),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AuraPetTheme.primary),
                borderRadius: BorderRadius.circular(3),
                minHeight: 5,
              ),
            ),

            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentStep = index);
                },
                children: [
                  _buildWelcomeStep(),
                  _buildGoalStep(),
                  _buildFeatureStep(),
                  _buildReadyStep(),
                ],
              ),
            ),

            // Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: Text(_currentStep == _steps.length - 1 ? '开始使用 🐻' : '继续'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeStep() {
    return _buildStepContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAnimatedBear(),
          const SizedBox(height: 24),
          Text(
            '你好！我是小熊',
            style: AuraPetTheme.headingXl,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            '你的健康伙伴今天也很期待见到你！',
            style: AuraPetTheme.bodyMd,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalStep() {
    return _buildStepContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎯', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 24),
          Text(
            '你的健康目标是什么？',
            style: AuraPetTheme.headingLg,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '选择你最想要的改变',
            style: AuraPetTheme.bodyMd,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ..._goalOptions.map((opt) => _buildOptionCard(
                icon: opt['icon']!,
                title: opt['title']!,
                desc: opt['desc']!,
                isSelected: _selectedGoal == opt['val'],
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedGoal = opt['val']);
                },
              )),
        ],
      ),
    );
  }

  Widget _buildFeatureStep() {
    return _buildStepContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('💪', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 24),
          Text(
            '你最想要什么功能？',
            style: AuraPetTheme.headingLg,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '选择你最关心的健康功能',
            style: AuraPetTheme.bodyMd,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ..._featureOptions.map((opt) => _buildOptionCard(
                icon: opt['icon']!,
                title: opt['title']!,
                desc: opt['desc']!,
                isSelected: _selectedFeature == opt['val'],
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedFeature = opt['val']);
                },
              )),
        ],
      ),
    );
  }

  Widget _buildReadyStep() {
    return _buildStepContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎉', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 24),
          Text(
            '准备好了吗？',
            style: AuraPetTheme.headingXl,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            '小熊已经迫不及待要帮助你了！',
            style: AuraPetTheme.bodyMd,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          _buildAnimatedBear(size: 120),
        ],
      ),
    );
  }

  Widget _buildStepContent({required Widget child}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: child,
    );
  }

  Widget _buildAnimatedBear({double size = 200}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.95, end: 1.05),
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AuraPetTheme.white,
              shape: BoxShape.circle,
              boxShadow: AuraPetTheme.shadowMd,
            ),
            child: const Center(
              child: Text('🐻', style: TextStyle(fontSize: 100)),
            ),
          ),
        );
      },
      onEnd: () => setState(() {}),
    );
  }

  Widget _buildOptionCard({
    required String icon,
    required String title,
    required String desc,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isSelected ? AuraPetTheme.bgPink : AuraPetTheme.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AuraPetTheme.primary : Colors.transparent,
              width: 3,
            ),
            boxShadow: AuraPetTheme.shadowSm,
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFE5D0), Color(0xFFFFD8C0)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 26)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AuraPetTheme.bodyLg),
                    const SizedBox(height: 2),
                    Text(desc, style: AuraPetTheme.bodySm),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: AuraPetTheme.primary),
            ],
          ),
        ),
      ),
    );
  }

  void _onNext() {
    HapticFeedback.mediumImpact();

    if (_currentStep < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Complete onboarding
      context.read<AppState>().completeOnboarding();
      context.read<PetProvider>().addCoins(100); // Welcome bonus
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingStep {
  final String title;
  final String subtitle;
  final String emoji;

  const OnboardingStep({
    required this.title,
    required this.subtitle,
    required this.emoji,
  });
}
