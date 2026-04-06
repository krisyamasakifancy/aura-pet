import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 首页 P1 - 比心小熊 + 温柔粉金色 Aura 光晕
class HomeP1Screen extends StatefulWidget {
  const HomeP1Screen({super.key});

  @override
  State<HomeP1Screen> createState() => _HomeP1ScreenState();
}

class _HomeP1ScreenState extends State<HomeP1Screen>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late AnimationController _glowController;
  late Animation<double> _heartAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    // 比心动画
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _heartAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
    );
    
    // 光晕呼吸
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(begin: 0.4, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF0F5), Color(0xFFFFE4E1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 头部问候
              _buildHeader(),
              
              // 主内容
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // 比心小熊区域
                      _buildHeartingPet(),
                      
                      const SizedBox(height: 24),
                      
                      // Aura Score 卡片
                      _buildAuraScoreCard(),
                      
                      const SizedBox(height: 20),
                      
                      // 今日进度
                      _buildTodayProgress(),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFB5B5), Color(0xFFFFD4D4)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFB5B5).withOpacity(0.3),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Center(
              child: Text('✨', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good Morning!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF636E72),
                  ),
                ),
                const Text(
                  'You look radiant today ✨',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3436),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF2D3436),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeartingPet() {
    return AnimatedBuilder(
      animation: Listenable.merge([_heartController, _glowController]),
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Color.lerp(
                  const Color(0xFFFFB5B5)!.withOpacity(_glowAnimation.value),
                  const Color(0xFFFFD700)!.withOpacity(_glowAnimation.value),
                  0.5,
                )!,
                Colors.transparent,
              ],
              radius: 1.5,
            ),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Aura 光晕
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFB5B5).withOpacity(_glowAnimation.value * 0.6),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                      BoxShadow(
                        color: const Color(0xFFFFD700).withOpacity(_glowAnimation.value * 0.3),
                        blurRadius: 60,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
              
              // 小熊身体
              Transform.scale(
                scale: 1 + (_glowAnimation.value - 0.4) * 0.05,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFB8C5D0), Color(0xFF8E9EAB)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // 脸部
                      Positioned(
                        top: 35,
                        left: 20,
                        child: Container(
                          width: 120,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      
                      // 左眼
                      Positioned(
                        top: 60,
                        left: 45,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2D3436),
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 2,
                                left: 2,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // 右眼
                      Positioned(
                        top: 60,
                        right: 45,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2D3436),
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 2,
                                left: 2,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // 腮红
                      Positioned(
                        bottom: 55,
                        left: 28,
                        child: Container(
                          width: 18,
                          height: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB5B5).withOpacity(0.6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 55,
                        right: 28,
                        child: Container(
                          width: 18,
                          height: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB5B5).withOpacity(0.6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      
                      // 嘴巴
                      Positioned(
                        bottom: 40,
                        left: 70,
                        child: Container(
                          width: 20,
                          height: 10,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xFF2D3436), width: 2),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      
                      // 比心手势
                      Positioned(
                        bottom: 30,
                        right: 15,
                        child: Transform.scale(
                          scale: _heartAnimation.value,
                          child: Transform.rotate(
                            angle: -0.3,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFB5B5),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFFB5B5).withOpacity(0.5),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Text('💕', style: TextStyle(fontSize: 28)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // 飘浮爱心
              ...List.generate(5, (index) {
                final delay = index * 0.3;
                final offset = (_heartController.value + delay) % 1.0;
                return Positioned(
                  bottom: 20 + offset * 50,
                  left: 20 + index * 30,
                  child: Opacity(
                    opacity: (1 - offset).clamp(0.0, 0.8),
                    child: Transform.translate(
                      offset: Offset(0, -offset * 30),
                      child: const Text('💗', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAuraScoreCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFFFF8F0)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '✨',
                style: TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 12),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 92),
                duration: const Duration(milliseconds: 2000),
                builder: (context, value, child) {
                  return Text(
                    '${value.toInt()}',
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w800,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFF8BA0)],
                        ).createShader(const Rect.fromLTWH(0, 0, 100, 60)),
                    ),
                  );
                },
              ),
              const Text(
                ' Aura',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF8BA0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '🌟 光之追随者',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFB8860B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today\'s Journey',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildProgressCard('🔥', '1,240', 'kcal', Color(0xFFFF8BA0))),
            const SizedBox(width: 12),
            Expanded(child: _buildProgressCard('💧', '5/8', 'glasses', Color(0xFF7BC4FF))),
            const SizedBox(width: 12),
            Expanded(child: _buildProgressCard('⏰', '16:8', 'fasting', Color(0xFF9B8FE8))),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCard(String emoji, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFFB2BEC3),
            ),
          ),
        ],
      ),
    );
  }
}
