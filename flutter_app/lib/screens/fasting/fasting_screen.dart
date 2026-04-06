import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/pet_provider.dart';
import '../../utils/theme.dart';

class FastingScreen extends StatefulWidget {
  const FastingScreen({super.key});

  @override
  State<FastingScreen> createState() => _FastingScreenState();
}

class _FastingScreenState extends State<FastingScreen>
    with SingleTickerProviderStateMixin {
  int _selectedHours = 16;
  bool _isActive = false;
  int _remainingSeconds = 16 * 3600;
  late AnimationController _animController;

  final List<Map<String, dynamic>> _plans = [
    {'hours': 16, 'icon': '🕐', 'title': '16:8 轻断食', 'desc': '16小时禁食，8小时进食窗口'},
    {'hours': 18, 'icon': '🌙', 'title': '18:6 进阶断食', 'desc': '18小时禁食，更强效'},
    {'hours': 20, 'icon': '🔥', 'title': '20:4 燃脂挑战', 'desc': '20小时禁食，极致效果'},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _updateTimer();
  }

  void _updateTimer() {
    setState(() {
      _remainingSeconds = _selectedHours * 3600;
    });
  }

  String _formatTime() {
    final hours = _remainingSeconds ~/ 3600;
    final minutes = (_remainingSeconds % 3600) ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get _progress {
    final total = _selectedHours * 3600.0;
    return 1.0 - (_remainingSeconds / total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AuraPetTheme.bgGreen,
              AuraPetTheme.bgCream,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        '轻断食',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Timer circle
                      _TimerCircle(
                        progress: _progress,
                        time: _formatTime(),
                        isActive: _isActive,
                        animController: _animController,
                      ),
                      const SizedBox(height: 24),

                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AuraPetTheme.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: AuraPetTheme.accent.withOpacity(0.3),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _isActive
                                    ? AuraPetTheme.accent
                                    : AuraPetTheme.textLight,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isActive ? '禁食进行中' : '准备开始',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AuraPetTheme.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Fasting plans
                      ...List.generate(_plans.length, (index) {
                        final plan = _plans[index];
                        final isSelected = _selectedHours == plan['hours'];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () {
                              if (!_isActive) {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _selectedHours = plan['hours'];
                                  _updateTimer();
                                });
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AuraPetTheme.bgGreen
                                    : AuraPetTheme.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AuraPetTheme.accent
                                      : Colors.transparent,
                                  width: 3,
                                ),
                                boxShadow: AuraPetTheme.shadowSm,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AuraPetTheme.bgGreen,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Center(
                                      child: Text(
                                        plan['icon'],
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          plan['title'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: AuraPetTheme.textDark,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          plan['desc'],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AuraPetTheme.textLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle,
                                      color: AuraPetTheme.accent,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // Start/Stop button
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: _isActive
                          ? null
                          : const LinearGradient(
                              colors: [AuraPetTheme.accent, Color(0xFF5BBF68)],
                            ),
                      color: _isActive ? AuraPetTheme.white : null,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AuraPetTheme.accent.withOpacity(0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _toggleFasting,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: Text(
                        _isActive ? '✓ 结束禁食' : '🌙 开始禁食',
                        style: TextStyle(
                          color: _isActive
                              ? AuraPetTheme.accent
                              : AuraPetTheme.white,
                          fontWeight: FontWeight.w700,
                        ),
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

  void _toggleFasting() {
    HapticFeedback.mediumImpact();
    final pet = context.read<PetProvider>();

    if (_isActive) {
      pet.stopFasting();
      setState(() => _isActive = false);
      _updateTimer();
    } else {
      pet.startFasting();
      setState(() => _isActive = true);
      _startCountdown();
    }
  }

  void _startCountdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || !_isActive) return false;
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
        return true;
      } else {
        // Fasting complete
        pet.stopFasting();
        setState(() => _isActive = false);
        _updateTimer();
        return false;
      }
    });
  }
}

class _TimerCircle extends StatelessWidget {
  final double progress;
  final String time;
  final bool isActive;
  final AnimationController animController;

  const _TimerCircle({
    required this.progress,
    required this.time,
    required this.isActive,
    required this.animController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AuraPetTheme.white,
              boxShadow: AuraPetTheme.shadowMd,
            ),
          ),
          // Progress arc
          AnimatedBuilder(
            animation: animController,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(260, 260),
                painter: _TimerPainter(
                  progress: progress,
                  isActive: isActive,
                  animValue: animController.value,
                ),
              );
            },
          ),
          // Time display
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: AuraPetTheme.textDark,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '剩余时间',
                style: TextStyle(
                  fontSize: 14,
                  color: AuraPetTheme.textLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimerPainter extends CustomPainter {
  final double progress;
  final bool isActive;
  final double animValue;

  _TimerPainter({
    required this.progress,
    required this.isActive,
    required this.animValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.width / 2 - 7;

    // Background track
    final trackPaint = Paint()
      ..color = const Color(0xFFE8E8E8)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(cx, cy), radius, trackPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = AuraPetTheme.accent
        ..strokeWidth = 14
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final sweepAngle = progress * 2 * 3.14159;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: radius),
        -3.14159 / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }

    // Animated glow when active
    if (isActive) {
      final glowPaint = Paint()
        ..color = AuraPetTheme.accent.withOpacity(0.2 + animValue * 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(Offset(cx, cy), radius, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TimerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isActive != isActive ||
        oldDelegate.animValue != animValue;
  }
}
