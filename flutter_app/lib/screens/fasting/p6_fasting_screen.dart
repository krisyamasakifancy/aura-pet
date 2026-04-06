import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 禁食计时 P6 - 睡帽小熊 + 深眠呼吸 + 幽静深蓝
class FastingP6Screen extends StatefulWidget {
  const FastingP6Screen({super.key});

  @override
  State<FastingP6Screen> createState() => _FastingP6ScreenState();
}

class _FastingP6ScreenState extends State<FastingP6Screen>
    with TickerProviderStateMixin {
  bool _isFasting = false;
  Duration _elapsed = Duration.zero;
  late AnimationController _sleepController;
  late AnimationController _breathController;
  late AnimationController _starController;
  late Animation<double> _breathAnimation;
  late Animation<double> _starAnimation;

  @override
  void initState() {
    super.initState();
    
    // 睡眠动画
    _sleepController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    // 呼吸动画
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);
    
    _breathAnimation = Tween<double>(begin: 0.98, end: 1.04).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
    
    // 星星闪烁
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    _starAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _starController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _sleepController.dispose();
    _breathController.dispose();
    _starController.dispose();
    super.dispose();
  }

  void _toggleFasting() {
    setState(() {
      _isFasting = !_isFasting;
      if (_isFasting) {
        _elapsed = Duration.zero;
        _startTimer();
      }
    });
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || !_isFasting) return false;
      setState(() => _elapsed += const Duration(seconds: 1));
      return _isFasting;
    });
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _isFasting
                ? [const Color(0xFF1A1A2E), const Color(0xFF16213E), const Color(0xFF0F3460)]
                : [const Color(0xFFF8F9FA), const Color(0xFFE9ECEF), const Color(0xFFDEE2E6)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // 星空背景 (仅禁食时)
              if (_isFasting) _buildStarField(),
              
              // 主内容
              Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSleepingPet(),
                          const SizedBox(height: 40),
                          _buildTimerRing(),
                          const SizedBox(height: 32),
                          _buildPhaseIndicator(),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStarField() {
    return AnimatedBuilder(
      animation: _starAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: _StarFieldPainter(_starAnimation.value),
          size: Size.infinite,
        );
      },
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
                color: _isFasting 
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: _isFasting ? Colors.white : const Color(0xFF2D3436),
              ),
            ),
          ),
          Expanded(
            child: Text(
              _isFasting ? 'Deep Sleep Mode' : 'Intermittent Fasting',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _isFasting ? Colors.white : const Color(0xFF2D3436),
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildSleepingPet() {
    return AnimatedBuilder(
      animation: Listenable.merge([_breathController, _sleepController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _breathAnimation.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 月牙光晕
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withOpacity(0.3),
                      blurRadius: 50,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
              
              // 小熊身体
              Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFB8C5D0), Color(0xFF8E9EAB)],
                  ),
                ),
                child: Stack(
                  children: [
                    // 脸部
                    Positioned(
                      top: 30,
                      left: 18,
                      child: Container(
                        width: 114,
                        height: 75,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(38),
                            topRight: Radius.circular(38),
                            bottomLeft: Radius.circular(48),
                            bottomRight: Radius.circular(48),
                          ),
                        ),
                      ),
                    ),
                    
                    // 睡帽
                    Positioned(
                      top: -20,
                      left: 45,
                      child: Column(
                        children: [
                          // 帽子
                          Container(
                            width: 60,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Color(0xFF6C63FF),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                          ),
                          // 帽尖
                          Transform.rotate(
                            angle: _sleepController.value * 0.2 - 0.1,
                            child: Container(
                              width: 8,
                              height: 25,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6C63FF),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          // 星星
                          Positioned(
                            top: 5,
                            right: -5,
                            child: Text(
                              '⭐',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(_starAnimation.value),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // ZZZ 动画
                    Positioned(
                      top: 5,
                      right: 25,
                      child: AnimatedBuilder(
                        animation: _sleepController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, -_sleepController.value * 10),
                            child: Opacity(
                              opacity: 1 - _sleepController.value,
                              child: const Text(
                                '💤',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // 闭眼 (睡眠状态)
                    if (_isFasting) ...[
                      Positioned(
                        top: 55,
                        left: 40,
                        child: Container(
                          width: 20,
                          height: 3,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D3436),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 55,
                        right: 40,
                        child: Container(
                          width: 20,
                          height: 3,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D3436),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ] else ...[
                      // 睁眼
                      Positioned(
                        top: 50,
                        left: 40,
                        child: Container(
                          width: 14,
                          height: 14,
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
                                  width: 5,
                                  height: 5,
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
                        top: 50,
                        right: 40,
                        child: Container(
                          width: 14,
                          height: 14,
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
                                  width: 5,
                                  height: 5,
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
                    ],
                    
                    // 腮红
                    Positioned(
                      bottom: 50,
                      left: 25,
                      child: Container(
                        width: 18,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB5B5).withOpacity(_isFasting ? 0.8 : 0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      right: 25,
                      child: Container(
                        width: 18,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB5B5).withOpacity(_isFasting ? 0.8 : 0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    
                    // 嘴巴 (微笑)
                    Positioned(
                      bottom: 35,
                      left: 65,
                      child: Container(
                        width: 20,
                        height: 12,
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
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimerRing() {
    final progress = _elapsed.inSeconds / (16 * 3600);
    
    return Column(
      children: [
        SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 外圈
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isFasting 
                      ? Colors.white.withOpacity(0.05)
                      : Colors.white,
                  border: Border.all(
                    color: _isFasting 
                        ? const Color(0xFF6C63FF).withOpacity(0.3)
                        : const Color(0xFFDEE2E6),
                    width: 2,
                  ),
                ),
              ),
              
              // 进度
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: _isFasting ? progress.clamp(0.0, 1.0) : 0,
                  strokeWidth: 12,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF6C63FF),
                  ),
                  strokeCap: StrokeCap.round,
                ),
              ),
              
              // 时间
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatDuration(_elapsed),
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: _isFasting ? Colors.white : const Color(0xFF2D3436),
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isFasting ? 'Sleeping...' : 'Ready to rest',
                    style: TextStyle(
                      fontSize: 14,
                      color: _isFasting 
                          ? Colors.white.withOpacity(0.7)
                          : const Color(0xFF636E72),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhaseIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isFasting 
            ? Colors.white.withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildPhaseItem(Icons.nightlight_round, 'Deep Sleep', const Color(0xFF6C63FF), true),
          Expanded(child: Container(height: 2, color: const Color(0xFF6C63FF).withOpacity(0.3))),
          _buildPhaseItem(Icons.wb_sunny_outlined, 'Awake', const Color(0xFFFFD700), false),
        ],
      ),
    );
  }

  Widget _buildPhaseItem(IconData icon, String label, Color color, bool isActive) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isActive ? color : color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: isActive ? Colors.white : color, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? color : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _toggleFasting,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isFasting ? const Color(0xFF6C63FF) : const Color(0xFF2D3436),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isFasting ? Icons.stop_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                _isFasting ? 'Wake Up' : 'Start Sleeping',
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
}

/// 星空背景 Painter
class _StarFieldPainter extends CustomPainter {
  final double twinkle;
  
  _StarFieldPainter(this.twinkle);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final random = math.Random(42);
    
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final starSize = random.nextDouble() * 2 + 1;
      final opacity = (random.nextDouble() * 0.5 + 0.5) * twinkle;
      
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), starSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarFieldPainter oldDelegate) {
    return oldDelegate.twinkle != twinkle;
  }
}
