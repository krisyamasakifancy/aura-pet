import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 会员订阅 P - 解锁小熊新世界 + 皇冠/披风皮肤预览
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen>
    with TickerProviderStateMixin {
  int _selectedPlan = 1; // 0=Monthly, 1=Yearly, 2=Lifetime
  
  final List<Map<String, dynamic>> _plans = [
    {
      'id': 'monthly',
      'name': 'Monthly',
      'price': 3.99,
      'period': '/month',
      'emoji': '🌙',
      'features': ['All features', 'Ad-free', 'Priority support'],
      'skin': '🧸',
      'color': Color(0xFF7BC4FF),
    },
    {
      'id': 'yearly',
      'name': 'Yearly',
      'price': 35.99,
      'period': '/year',
      'emoji': '⭐',
      'features': ['Everything in Monthly', 'Save 25%', 'Exclusive skins', 'Advanced analytics'],
      'skin': '👑',
      'color': Color(0xFFFFD700),
      'badge': 'BEST VALUE',
    },
    {
      'id': 'lifetime',
      'name': 'Lifetime',
      'price': 99.99,
      'period': 'one-time',
      'emoji': '💎',
      'features': ['Everything in Yearly', 'Forever yours', 'VIP badge', 'Early access'],
      'skin': '🦸',
      'color': Color(0xFF9B59B6),
    },
  ];
  
  late AnimationController _petController;
  late AnimationController _glowController;
  late AnimationController _confettiController;
  late Animation<double> _petAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _petController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    _petAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _petController, curve: Curves.easeInOut),
    );
    
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(begin: 0.4, end: 0.9).animate(_glowController);
    
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _petController.dispose();
    _glowController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildUnlockedWorld(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildPlanSelector(),
                      const SizedBox(height: 24),
                      _buildFeaturesList(),
                    ],
                  ),
                ),
              ),
              _buildSubscribeButton(),
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
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white70,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Unlock Premium',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildUnlockedWorld() {
    return AnimatedBuilder(
      animation: Listenable.merge([_petAnimation, _glowAnimation, _confettiController]),
      builder: (context, child) {
        final plan = _plans[_selectedPlan];
        
        return SizedBox(
          height: 250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 背景光环
              ...List.generate(3, (index) {
                final radius = 100 + index * 30;
                return Container(
                  width: radius * 2,
                  height: radius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: (plan['color'] as Color).withValues(alpha: _glowAnimation.value * (1 - index * 0.3)),
                      width: 2,
                    ),
                  ),
                );
              }),
              
              // 中心光效
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (plan['color'] as Color).withValues(alpha: 0.4 * _glowAnimation.value),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              
              // 小熊 + 皮肤预览
              Transform.scale(
                scale: _petAnimation.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 小熊主体
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFB8C5D0), Color(0xFF8E9EAB)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (plan['color'] as Color).withValues(alpha: 0.5),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // 脸部
                          Positioned(
                            top: 25,
                            left: 15,
                            child: Container(
                              width: 90,
                              height: 60,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(35),
                                  bottomRight: Radius.circular(35),
                                ),
                              ),
                            ),
                          ),
                          
                          // 眼睛
                          Positioned(
                            top: 42,
                            left: 38,
                            child: Container(
                              width: 12,
                              height: 12,
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
                                      width: 4,
                                      height: 4,
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
                          Positioned(
                            top: 42,
                            right: 38,
                            child: Container(
                              width: 12,
                              height: 12,
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
                                      width: 4,
                                      height: 4,
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
                            bottom: 38,
                            left: 24,
                            child: Container(
                              width: 14,
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFB5B5).withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 38,
                            right: 24,
                            child: Container(
                              width: 14,
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFB5B5).withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          
                          // 微笑
                          Positioned(
                            bottom: 26,
                            left: 52,
                            child: Container(
                              width: 16,
                              height: 10,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Color(0xFF2D3436), width: 2),
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // 皮肤装备 (皇冠/披风)
                    _buildSkinPreview(plan),
                  ],
                ),
              ),
              
              // 庆祝粒子
              ...List.generate(12, (index) {
                final angle = (index / 12) * 2 * math.pi + _confettiController.value * 2 * math.pi;
                final radius = 130 + math.sin(_confettiController.value * math.pi * 4 + index) * 20;
                return Positioned(
                  left: 180 + math.cos(angle) * radius - 10,
                  top: 125 + math.sin(angle) * radius - 10,
                  child: Opacity(
                    opacity: (1 - _confettiController.value).clamp(0.0, 1.0),
                    child: Transform.rotate(
                      angle: _confettiController.value * math.pi * 2,
                      child: Text(
                        ['✨', '💫', '⭐', '🌟', '💗', '🎉', '🎊', '💕', '🌈', '🦋', '🌸', '💎'][index],
                        style: const TextStyle(fontSize: 16),
                      ),
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

  Widget _buildSkinPreview(Map plan) {
    return Stack(
      children: [
        // 皇冠 (年度/终身)
        if (_selectedPlan >= 1)
          Positioned(
            top: -25,
            left: 35,
            child: Transform.scale(
              scale: _petAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withValues(alpha: 0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Text('👑', style: TextStyle(fontSize: 24)),
              ),
            ),
          ),
        
        // 披风 (终身)
        if (_selectedPlan >= 2)
          Positioned(
            bottom: -10,
            left: 25,
            child: Transform.scale(
              scale: _petAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF9B59B6),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9B59B6).withValues(alpha: 0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Text('✨', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlanSelector() {
    return Row(
      children: List.generate(_plans.length, (index) {
        final plan = _plans[index];
        final isSelected = _selectedPlan == index;
        
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedPlan = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(left: index > 0 ? 8 : 0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? (plan['color'] as Color).withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? plan['color'] as Color
                      : Colors.white.withValues(alpha: 0.1),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  if (plan['badge'] != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: plan['color'] as Color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        plan['badge'] as String,
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  Text(
                    plan['emoji'] as String,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plan['name'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${plan['price']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: plan['color'] as Color,
                    ),
                  ),
                  Text(
                    plan['period'] as String,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFeaturesList() {
    final plan = _plans[_selectedPlan];
    final features = plan['features'] as List<String>;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('✨', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text(
                'Premium Features',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...features.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: (plan['color'] as Color).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 14,
                    color: plan['color'] as Color,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  feature,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSubscribeButton() {
    final plan = _plans[_selectedPlan];
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () => _showSubscribeConfirmation(plan),
          style: ElevatedButton.styleFrom(
            backgroundColor: plan['color'] as Color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            boxShadow: [
              BoxShadow(
                color: (plan['color'] as Color).withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                plan['emoji'] as String,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'Subscribe for \$${plan['price']}${plan['period'] == 'one-time' ? '' : plan['period']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSubscribeConfirmation(Map plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              '${plan['emoji']} ${plan['name']} Premium',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Welcome to the premium family!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (plan['color'] as Color).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    plan['skin'] as String,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'New skin unlocked!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Start Premium',
              style: TextStyle(
                color: plan['color'] as Color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
