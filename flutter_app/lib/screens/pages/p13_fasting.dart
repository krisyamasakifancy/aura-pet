import 'package:flutter/material.dart';
import 'dart:math' as math;

/// P13: 禁食计时 - 完整环形进度条倒计时逻辑
class P13FastingScreen extends StatefulWidget {
  const P13FastingScreen({super.key});

  @override
  State<P13FastingScreen> createState() => _P13FastingScreenState();
}

class _P13FastingScreenState extends State<P13FastingScreen>
    with TickerProviderStateMixin {
  // 16:8 禁食计划
  final int _fastingHours = 16;
  final int _eatingHours = 8;
  
  // 当前状态
  bool _isFasting = true; // 开始禁食
  DateTime? _startTime;
  DateTime? _endTime;
  
  late AnimationController _progressController;
  late AnimationController _breathController;
  late AnimationController _zzzController;
  late AnimationController _starController;
  
  double _progress = 0.0;
  Duration _remaining = const Duration(hours: 16);
  
  // 示例数据
  final List<Map<String, dynamic>> _fastingHistory = [
    {'date': 'Today', 'hours': 16, 'completed': true},
    {'date': 'Yesterday', 'hours': 18, 'completed': true},
    {'date': '2 days ago', 'hours': 14, 'completed': false},
    {'date': '3 days ago', 'hours': 16, 'completed': true},
    {'date': '4 days ago', 'hours': 20, 'completed': true},
  ];

  @override
  void initState() {
    super.initState();
    
    // 模拟进行中的禁食
    _startTime = DateTime.now().subtract(const Duration(hours: 8));
    _endTime = _startTime!.add(const Duration(hours: 16));
    
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
    
    _zzzController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
    
    _updateProgress();
    
    // 每秒更新进度
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        _updateProgress();
        return true;
      }
      return false;
    });
  }

  void _updateProgress() {
    if (_startTime == null || _endTime == null) return;
    
    final now = DateTime.now();
    final total = _endTime!.difference(_startTime!);
    final elapsed = now.difference(_startTime!);
    
    setState(() {
      _progress = (elapsed.inSeconds / total.inSeconds).clamp(0.0, 1.0);
      _remaining = _endTime!.difference(now);
      if (_remaining.isNegative) {
        _remaining = Duration.zero;
        _isFasting = false;
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _breathController.dispose();
    _zzzController.dispose();
    _starController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Stack(
        children: [
          // 星空背景
          AnimatedBuilder(
            animation: _starController,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: StarFieldPainter(
                  phase: _starController.value,
                ),
              );
            },
          ),
          
          SafeArea(
            child: Column(
              children: [
                // 顶部标题
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    children: [
                      AnimatedBuilder(
                        animation: _zzzController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              math.sin(_zzzController.value * 2 * math.pi) * 3,
                              -_zzzController.value * 8,
                            ),
                            child: const Text('💤', style: TextStyle(fontSize: 28)),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          '16:8 Fasting',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: _isFasting 
                              ? const Color(0xFF6C63FF).withValues(alpha: 0.3)
                              : const Color(0xFF4CAF50).withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _isFasting ? const Color(0xFF6C63FF) : const Color(0xFF4CAF50),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isFasting ? Icons.nightlight : Icons.restaurant,
                              size: 16,
                              color: _isFasting ? const Color(0xFF6C63FF) : const Color(0xFF4CAF50),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _isFasting ? 'Fasting' : 'Eating',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _isFasting ? const Color(0xFF6C63FF) : const Color(0xFF4CAF50),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // 环形进度条
                Expanded(
                  flex: 2,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _breathController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + _breathController.value * 0.02,
                          child: CustomPaint(
                            size: const Size(280, 280),
                            painter: FastingRingPainter(
                              progress: _progress,
                              isFasting: _isFasting,
                            ),
                            child: SizedBox(
                              width: 280,
                              height: 280,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _isFasting ? 'Time Remaining' : 'Completed!',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withValues(alpha: 0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _formatDuration(_remaining),
                                    style: const TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      fontFeatures: [FontFeature.tabularFigures()],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${(_progress * 100).toInt()}% Complete',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                // 计划概览
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildPhaseCard(
                          '🌙 Fasting',
                          '$_fastingHours hours',
                          const Color(0xFF6C63FF),
                          _isFasting,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 60,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      Expanded(
                        child: _buildPhaseCard(
                          '🍽️ Eating',
                          '$_eatingHours hours',
                          const Color(0xFFFFB74D),
                          !_isFasting,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // 历史记录
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.history, size: 18, color: Color(0xFF6C63FF)),
                          const SizedBox(width: 8),
                          const Text(
                            'Fasting History',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${_fastingHistory.where((h) => h['completed']).length}/${_fastingHistory.length}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6C63FF),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(_fastingHistory.length.clamp(0, 5), (i) {
                        final item = _fastingHistory[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: item['completed']
                                      ? const Color(0xFF6C63FF).withValues(alpha: 0.2)
                                      : const Color(0xFFFF5252).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  item['completed'] ? Icons.check : Icons.close,
                                  size: 16,
                                  color: item['completed'] ? const Color(0xFF6C63FF) : const Color(0xFFFF5252),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item['date'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                              ),
                              Text(
                                '${item['hours']}h',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseCard(String title, String value, Color color, bool isActive) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: isActive ? color : Colors.white.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: isActive ? color : Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

/// 禁食环形进度条绘制器
class FastingRingPainter extends CustomPainter {
  final double progress;
  final bool isFasting;

  FastingRingPainter({required this.progress, required this.isFasting});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 15;
    
    // 外圈渐变背景
    final bgPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [
          Colors.white.withValues(alpha: 0.1),
          Colors.white.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.1),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    canvas.drawCircle(center, radius, bgPaint);
    
    // 进度弧
    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + 2 * math.pi * progress,
        colors: isFasting
            ? [const Color(0xFF6C63FF), const Color(0xFF9B8FE8), const Color(0xFF6C63FF)]
            : [const Color(0xFF4CAF50), const Color(0xFF81C784), const Color(0xFF4CAF50)],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
    
    // 发光效果
    final glowPaint = Paint()
      ..color = (isFasting ? const Color(0xFF6C63FF) : const Color(0xFF4CAF50)).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      glowPaint,
    );
    
    // 进度点
    final dotAngle = -math.pi / 2 + 2 * math.pi * progress;
    final dotX = center.dx + radius * math.cos(dotAngle);
    final dotY = center.dy + radius * math.sin(dotAngle);
    
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(dotX, dotY), 8, dotPaint);
    
    final innerDotPaint = Paint()
      ..color = isFasting ? const Color(0xFF6C63FF) : const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(dotX, dotY), 5, innerDotPaint);
  }

  @override
  bool shouldRepaint(FastingRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isFasting != isFasting;
  }
}

/// 星空背景绘制器
class StarFieldPainter extends CustomPainter {
  final double phase;

  StarFieldPainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);
    
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final starSize = random.nextDouble() * 2 + 0.5;
      final twinkle = (math.sin(phase * 2 * math.pi + i) + 1) / 2;
      
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: 0.3 + twinkle * 0.5);
      
      canvas.drawCircle(Offset(x, y), starSize, paint);
    }
  }

  @override
  bool shouldRepaint(StarFieldPainter oldDelegate) {
    return oldDelegate.phase != phase;
  }
}
