import 'package:flutter/material.dart';
import '../utils/aura_theme.dart';
import '../widgets/q_raccoon_canvas.dart';

/// 极简空气感启动页
/// 对标竞品的清新可爱风格
class AuraSplashScreen extends StatefulWidget {
  const AuraSplashScreen({super.key});

  @override
  State<AuraSplashScreen> createState() => _AuraSplashScreenState();
}

class _AuraSplashScreenState extends State<AuraSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _heartAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );

    _heartAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();

    // 3秒后跳转
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: [
                  // 装饰光斑
                  _buildAmbientSpots(),
                  
                  // 主内容
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 小熊
                        Opacity(
                          opacity: _fadeAnimation.value,
                          child: Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: const QRaccoonCanvas(
                              size: 180,
                              showHeart: true,
                              auraScore: 100,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // App 名称
                        Opacity(
                          opacity: _fadeAnimation.value,
                          child: Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: Column(
                              children: [
                                const Text(
                                  'Aura-Pet',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                    color: AuraPetTheme.textPrimary,
                                    letterSpacing: -1,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Reach your health goals',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AuraPetTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 60),
                        
                        // 心形装饰
                        Opacity(
                          opacity: _heartAnimation.value,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildHeart(0, 20),
                              _buildHeart(1, 0),
                              _buildHeart(2, 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAmbientSpots() {
    return Stack(
      children: [
        // 左上光斑
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AuraPetTheme.primaryLight.withOpacity(0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // 右下光斑
        Positioned(
          bottom: -150,
          right: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AuraPetTheme.accentLight.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeart(int index, double delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.5, end: 1.0),
      duration: Duration(milliseconds: 1000 + delay),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              Icons.favorite,
              size: 20 + index * 4,
              color: index == 1
                  ? AuraPetTheme.heartPink
                  : AuraPetTheme.heartLight,
            ),
          ),
        );
      },
    );
  }
}
