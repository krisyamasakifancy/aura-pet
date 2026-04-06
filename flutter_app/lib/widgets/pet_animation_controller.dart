import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../animations/raccoon_painter.dart';
import '../services/api_service.dart';
import '../models/pet_state.dart';

/// ============================================
// AURA-PET: 宠物状态动画控制器
// 处理所有物理动画和状态转换
/// ============================================

class PetAnimationController extends StatefulWidget {
  final PetState petState;
  final VoidCallback? onTap;
  final Function(String phrase)? onSpeechBubble;

  const PetAnimationController({
    super.key,
    required this.petState,
    this.onTap,
    this.onSpeechBubble,
  });

  @override
  State<PetAnimationController> createState() => _PetAnimationControllerState();
}

class _PetAnimationControllerState extends State<PetAnimationController>
    with TickerProviderStateMixin {
  // 主动画控制器
  late AnimationController _breathController;
  late AnimationController _blinkController;
  late AnimationController _tailController;
  late AnimationController _earController;
  late AnimationController _springController;
  late AnimationController _emotionController;

  // 动画值
  double _breathPhase = 0;
  double _blinkProgress = 1.0;
  double _tailWag = 0;
  double _earTwitch = 0;
  double _floatY = 0;
  double _springScale = 1.0;
  String _currentEmotion = 'happy';

  // 当前说的台词
  String? _currentSpeech;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _startAnimations();
  }

  void _initControllers() {
    // 呼吸动画 - 水分影响频率
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..addListener(() {
        setState(() {
          _breathPhase = _breathController.value * 2 * math.pi;
        });
      });

    // 眨眼动画
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..addListener(() {
        setState(() {
          _blinkProgress = 1.0 - _blinkController.value;
        });
      });

    // 尾巴摇摆
    _tailController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {
          _tailWag = math.sin(_tailController.value * math.pi * 4) * 0.15;
        });
      });

    // 耳朵抖动
    _earController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..addListener(() {
        setState(() {
          _earTwitch = math.sin(_earController.value * math.pi * 3) * 0.05;
        });
      });

    // 弹簧物理动画
    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // 情绪动画
    _emotionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _startAnimations() {
    _breathController.repeat();
    _scheduleBlink();
  }

  void _scheduleBlink() {
    Future.delayed(Duration(milliseconds: 2000 + Random().nextInt(3000)), () {
      if (mounted) {
        _blinkController.forward().then((_) {
          _blinkController.reverse().then((_) {
            _scheduleBlink();
          });
        });
      }
    });

    // 耳朵随机抖动
    Future.delayed(Duration(milliseconds: 1000 + Random().nextInt(5000)), () {
      if (mounted) {
        _earController.forward().then((_) => _earController.reverse());
        _scheduleBlink();
      }
    });
  }

  void _triggerSpringAnimation(String type) {
    _springController.reset();
    
    switch (type) {
      case 'bounce':
        _springController.duration = const Duration(milliseconds: 600);
        _springController.forward();
        _triggerTailWag();
        break;
      case 'spin':
        _triggerTailWag();
        _triggerTailWag();
        break;
      case 'jump':
        _triggerTailWag();
        break;
      case 'hug':
        _springController.forward();
        break;
    }
  }

  void _triggerTailWag() {
    _tailController.reset();
    _tailController.forward();
  }

  void _setEmotion(String emotion) {
    setState(() {
      _currentEmotion = emotion;
    });
  }

  void _showSpeechBubble(String phrase) {
    setState(() {
      _currentSpeech = phrase;
    });
    widget.onSpeechBubble?.call(phrase);
    
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _currentSpeech = null;
        });
      }
    });
  }

  void _onPetTap() {
    // 触发触摸反馈
    _triggerSpringAnimation('hug');
    
    // 显示随机台词
    final phrases = _getPhrasesForEmotion(_currentEmotion);
    _showSpeechBubble(phrases[Random().nextInt(phrases.length)]);
    
    widget.onTap?.call();
  }

  List<String> _getPhrasesForEmotion(String emotion) {
    switch (emotion) {
      case 'happy':
        return ['好开心呀～', '嘿嘿～', '我们是好朋友！', '喜欢你！', '今天也要加油哦～'];
      case 'excited':
        return ['哇！！', '太棒了！！', '好幸福呀！！', '转圈圈～', '你是最棒的！'];
      case 'loved':
        return ['好喜欢你！', '我们永远在一起！', '最爱你了！', '抱抱～', '不会离开你的～'];
      case 'sleepy':
        return ['困困的...', '想睡觉了...', 'zzZ...', '陪我一起睡吧...'];
      case 'hungry':
        return ['肚子饿了...', '想吃东西...', '可以喂我嘛？', '咕噜咕噜...'];
      default:
        return ['你好呀！'];
    }
  }

  @override
  void dispose() {
    _breathController.dispose();
    _blinkController.dispose();
    _tailController.dispose();
    _earController.dispose();
    _springController.dispose();
    _emotionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPetTap,
      child: AnimatedBuilder(
        animation: _springController,
        builder: (context, child) {
          double scale = 1.0;
          
          if (_springController.isAnimating) {
            // 弹簧物理曲线
            final t = _springController.value;
            scale = 1.0 + math.sin(t * math.pi) * 0.35 * (1 - t);
          }
          
          return Transform.scale(
            scale: scale,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 发光效果
                _buildGlow(),
                
                // 小浣熊
                SizedBox(
                  width: 280,
                  height: 280,
                  child: CustomPaint(
                    painter: RaccoonPainter(
                      breathPhase: _breathPhase,
                      blinkProgress: _blinkProgress,
                      tailWag: _tailWag,
                      earTwitch: _earTwitch,
                      floatY: _floatY,
                      joyLevel: widget.petState.joy / 100,
                      waterIntake: widget.petState.waterIntake.toDouble(),
                      nutritionBalance: widget.petState.nutritionBalance,
                    ),
                  ),
                ),
                
                // 语音气泡
                if (_currentSpeech != null)
                  Positioned(
                    top: -20,
                    left: 0,
                    right: 0,
                    child: _buildSpeechBubble(_currentSpeech!),
                  ),
                
                // 心情指示器
                Positioned(
                  bottom: -10,
                  left: 0,
                  right: 0,
                  child: _buildMoodBadge(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlow() {
    return Positioned.fill(
      child: Center(
        child: Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                _getEmotionColor(_currentEmotion).withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion) {
      case 'happy':
        return const Color(0xFFFF6B9D);
      case 'excited':
        return const Color(0xFFFBBF24);
      case 'loved':
        return const Color(0xFFFF6B9D);
      case 'sleepy':
        return const Color(0xFFC9B8E0);
      case 'hungry':
        return const Color(0xFFFF9F43);
      default:
        return const Color(0xFFFF6B9D);
    }
  }

  Widget _buildSpeechBubble(String text) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 200),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, -10 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF0D1117),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildMoodBadge() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getMoodColor(_currentEmotion),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _getMoodText(_currentEmotion),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'happy':
        return const Color(0xFF4ADE80);
      case 'excited':
        return const Color(0xFFFBBF24);
      case 'loved':
        return const Color(0xFFFF6B9D);
      case 'sleepy':
        return const Color(0xFFC9B8E0);
      case 'hungry':
        return const Color(0xFFFF9F43);
      default:
        return const Color(0xFF4ADE80);
    }
  }

  String _getMoodText(String mood) {
    switch (mood) {
      case 'happy':
        return '超开心';
      case 'excited':
        return '兴奋';
      case 'loved':
        return '被爱着';
      case 'sleepy':
        return '困困';
      case 'hungry':
        return '饿了';
      default:
        return '开心';
    }
  }
}
