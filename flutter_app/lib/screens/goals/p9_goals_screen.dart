import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 目标设置 P9 - 空气感滑动选择器 + 小熊手势提示
class GoalsP9Screen extends StatefulWidget {
  const GoalsP9Screen({super.key});

  @override
  State<GoalsP9Screen> createState() => _GoalsP9ScreenState();
}

class _GoalsP9ScreenState extends State<GoalsP9Screen>
    with TickerProviderStateMixin {
  // 身高
  double _height = 170;
  final double _minHeight = 120;
  final double _maxHeight = 200;
  
  // 体重
  double _weight = 65;
  final double _minWeight = 30;
  final double _maxWeight = 150;
  
  // 目标体重
  double _targetWeight = 60;
  
  // 当前编辑项
  String _activeField = 'height';
  
  late AnimationController _petGestureController;
  late AnimationController _sliderGlowController;
  late Animation<double> _gestureAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _petGestureController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    
    _gestureAnimation = Tween<double>(begin: -0.2, end: 0.2).animate(
      CurvedAnimation(parent: _petGestureController, curve: Curves.easeInOut),
    );
    
    _sliderGlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(_sliderGlowController);
  }

  @override
  void dispose() {
    _petGestureController.dispose();
    _sliderGlowController.dispose();
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
            colors: [Color(0xFFFAFAFA), Color(0xFFF5F5F5), Color(0xFFEEEEEE)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // 小熊提示区
                      _buildPetHintSection(),
                      
                      const SizedBox(height: 32),
                      
                      // 身高选择器
                      _buildHeightSlider(),
                      
                      const SizedBox(height: 32),
                      
                      // 体重选择器
                      _buildWeightSlider(),
                      
                      const SizedBox(height: 32),
                      
                      // 目标体重
                      _buildTargetWeightSlider(),
                    ],
                  ),
                ),
              ),
              _buildSaveButton(),
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
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Color(0xFF2D3436),
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Set Your Goals',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3436),
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildPetHintSection() {
    return AnimatedBuilder(
      animation: _gestureAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              // 小熊
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFB8C5D0), Color(0xFF8E9EAB)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFB5B5).withValues(alpha: 0.2),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // 脸部
                        Positioned(
                          top: 22,
                          left: 12,
                          child: Container(
                            width: 76,
                            height: 52,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(26),
                                topRight: Radius.circular(26),
                                bottomLeft: Radius.circular(32),
                                bottomRight: Radius.circular(32),
                              ),
                            ),
                          ),
                        ),
                        
                        // 眼睛
                        Positioned(
                          top: 38,
                          left: 30,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2D3436),
                              shape: BoxShape.circle,
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 1,
                                  left: 1,
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
                          top: 38,
                          right: 30,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2D3436),
                              shape: BoxShape.circle,
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 1,
                                  left: 1,
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
                        
                        // 手势提示 (根据当前滑动项变化)
                        _buildGestureHint(),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(width: 20),
              
              // 提示文字
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getHintTitle(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getHintSubtitle(),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF636E72),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGestureHint() {
    IconData icon;
    String emoji;
    
    switch (_activeField) {
      case 'height':
        icon = Icons.height_rounded;
        emoji = '📏';
        break;
      case 'weight':
        icon = Icons.monitor_weight_outlined;
        emoji = '⚖️';
        break;
      case 'target':
        icon = Icons.flag_rounded;
        emoji = '🎯';
        break;
      default:
        icon = Icons.touch_app_rounded;
        emoji = '👆';
    }
    
    return Positioned(
      bottom: 15,
      right: 5,
      child: Transform.rotate(
        angle: _gestureAnimation.value,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFB5B5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  String _getHintTitle() {
    switch (_activeField) {
      case 'height':
        return 'How tall are you?';
      case 'weight':
        return 'Current weight?';
      case 'target':
        return 'Your goal weight?';
      default:
        return 'Slide to adjust';
    }
  }

  String _getHintSubtitle() {
    switch (_activeField) {
      case 'height':
        return 'I\'ll help you calculate BMI';
      case 'weight':
        return 'Don\'t worry, we\'re friends!';
      case 'target':
        return 'Dream body is waiting for you';
      default:
        return 'Drag the slider gently';
    }
  }

  Widget _buildHeightSlider() {
    return _buildSliderSection(
      title: 'Height',
      value: _height,
      unit: 'cm',
      icon: '📏',
      isActive: _activeField == 'height',
      onActive: () => setState(() => _activeField = 'height'),
      onChanged: (v) => setState(() => _height = v),
      min: _minHeight,
      max: _maxHeight,
      color: const Color(0xFF7BC4FF),
    );
  }

  Widget _buildWeightSlider() {
    return _buildSliderSection(
      title: 'Current Weight',
      value: _weight,
      unit: 'kg',
      icon: '⚖️',
      isActive: _activeField == 'weight',
      onActive: () => setState(() => _activeField = 'weight'),
      onChanged: (v) => setState(() => _weight = v),
      min: _minWeight,
      max: _maxWeight,
      color: const Color(0xFFFFB5B5),
    );
  }

  Widget _buildTargetWeightSlider() {
    return _buildSliderSection(
      title: 'Target Weight',
      value: _targetWeight,
      unit: 'kg',
      icon: '🎯',
      isActive: _activeField == 'target',
      onActive: () => setState(() => _activeField = 'target'),
      onChanged: (v) => setState(() => _targetWeight = v),
      min: 30,
      max: _maxWeight,
      color: const Color(0xFF9B8FE8),
    );
  }

  Widget _buildSliderSection({
    required String title,
    required double value,
    required String unit,
    required String icon,
    required bool isActive,
    required VoidCallback onActive,
    required ValueChanged<double> onChanged,
    required double min,
    required double max,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onActive,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: isActive
                  ? Border.all(color: color.withValues(alpha: _glowAnimation.value), width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: isActive
                      ? color.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.05),
                  blurRadius: isActive ? 30 : 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(icon, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${value.toInt()} $unit',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // 空气感滑块
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // 轨道背景
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    
                    // 已填充轨道
                    FractionallySizedBox(
                      widthFactor: (value - min) / (max - min),
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    
                    // 滑块
                    Positioned(
                      left: (MediaQuery.of(context).size.width - 96) * ((value - min) / (max - min)),
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          final width = MediaQuery.of(context).size.width - 96;
                          final newValue = min + (details.localPosition.dx / width) * (max - min);
                          onChanged(newValue.clamp(min, max));
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: color, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.4),
                                blurRadius: isActive ? 15 : 8,
                                spreadRadius: isActive ? 2 : 0,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // 刻度
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${min.toInt()}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB2BEC3),
                      ),
                    ),
                    Text(
                      '${max.toInt()}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB2BEC3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            // 计算BMI
            final bmi = _weight / math.pow(_height / 100, 2);
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🎉', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 16),
                    const Text(
                      'Goals Saved!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your BMI: ${bmi.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF636E72),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2D3436),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: const Text(
            'Save Goals',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
