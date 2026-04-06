import 'package:flutter/material.dart';
import 'dart:math' as math;

/// P10: 喝水追踪 - 完整业务逻辑
class P10WaterScreen extends StatefulWidget {
  const P10WaterScreen({super.key});

  @override
  State<P10WaterScreen> createState() => _P10WaterScreenState();
}

class _P10WaterScreenState extends State<P10WaterScreen>
    with TickerProviderStateMixin {
  // 业务数据
  double _currentIntake = 1.8; // L
  final double _targetIntake = 2.5; // L
  final List<int> _hourlyIntake = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  
  late AnimationController _waveController;
  late AnimationController _fillController;
  late AnimationController _bubbleController;
  late Animation<double> _fillAnimation;
  
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    
    // 当前时间的小时摄入
    final currentHour = DateTime.now().hour;
    _hourlyIntake[currentHour] = 250; // 刚喝了一杯
    
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    
    _fillController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fillAnimation = Tween<double>(
      begin: 0,
      end: _currentIntake / _targetIntake,
    ).animate(CurvedAnimation(
      parent: _fillController,
      curve: Curves.easeOutCubic,
    ))..addListener(() => setState(() {}));
    
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
    
    _fillController.forward();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _fillController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  void _addWater(int ml) {
    HapticFeedback.mediumImpact();
    setState(() {
      final currentHour = DateTime.now().hour;
      _hourlyIntake[currentHour] += ml;
      _currentIntake = _hourlyIntake.reduce((a, b) => a + b) / 1000;
      _isAnimating = true;
    });
    
    _fillAnimation = Tween<double>(
      begin: _fillAnimation.value,
      end: (_currentIntake / _targetIntake).clamp(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _fillController,
      curve: Curves.elasticOut,
    ));
    
    _fillController.forward(from: 0).then((_) {
      setState(() => _isAnimating = false);
    });
  }

  double get _fillPercent => _currentIntake / _targetIntake;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SafeArea(
        child: Column(
          children: [
            // 顶部标题栏
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  const Text('💧', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Stay Hydrated',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.wb_sunny, size: 16, color: Color(0xFFFFB300)),
                        const SizedBox(width: 4),
                        Text(
                          '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // 主水杯Canvas
            Expanded(
              flex: 3,
              child: Center(
                child: GestureDetector(
                  onTap: () => _addWater(250),
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_waveController, _fillAnimation, _bubbleController]),
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(220, 320),
                        painter: WaterGlassPainter(
                          fillPercent: _fillPercent.clamp(0.0, 1.0),
                          wavePhase: _waveController.value * 2 * math.pi,
                          bubblePhase: _bubbleController.value,
                          isAnimating: _isAnimating,
                        ),
                        child: SizedBox(
                          width: 220,
                          height: 320,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 60),
                              Text(
                                '${_currentIntake.toStringAsFixed(1)}L',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '/ ${_targetIntake.toStringAsFixed(1)}L',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${(_fillPercent * 100).toInt()}%',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            
            // 快捷添加按钮
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickAddButton(100, '🍶'),
                  _buildQuickAddButton(200, '🥤'),
                  _buildQuickAddButton(300, '🫗'),
                  _buildQuickAddButton(500, '🍶'),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 剩余目标
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.water_drop, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Remaining Goal',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF78909C),
                          ),
                        ),
                        Text(
                          '${(_targetIntake - _currentIntake).clamp(0, double.infinity).toStringAsFixed(1)}L',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 18),
                        SizedBox(width: 4),
                        Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 小时摄入柱状图
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.bar_chart, size: 20, color: Color(0xFF1565C0)),
                      SizedBox(width: 8),
                      Text(
                        'Hourly Intake',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF37474F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(12, (i) {
                        final hour = (DateTime.now().hour - 6 + i) % 24;
                        final intake = _hourlyIntake[hour];
                        final maxIntake = 500;
                        final height = (intake / maxIntake * 60).clamp(4.0, 60.0);
                        final isCurrentHour = hour == DateTime.now().hour;
                        
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              width: 16,
                              height: height,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: isCurrentHour
                                      ? [const Color(0xFF1976D2), const Color(0xFF64B5F6)]
                                      : [const Color(0xFF90CAF9), const Color(0xFFBBDEFB)],
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${hour}h',
                              style: TextStyle(
                                fontSize: 10,
                                color: isCurrentHour ? const Color(0xFF1565C0) : const Color(0xFFB0BEC5),
                                fontWeight: isCurrentHour ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAddButton(int ml, String emoji) {
    return GestureDetector(
      onTap: () => _addWater(ml),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 2),
            Text(
              '${ml}ml',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1565C0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 水杯Canvas绘制器
class WaterGlassPainter extends CustomPainter {
  final double fillPercent;
  final double wavePhase;
  final double bubblePhase;
  final bool isAnimating;

  WaterGlassPainter({
    required this.fillPercent,
    required this.wavePhase,
    required this.bubblePhase,
    required this.isAnimating,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final glassTop = size.height * 0.1;
    final glassBottom = size.height * 0.85;
    final glassWidth = size.width * 0.7;
    
    // 绘制玻璃杯轮廓
    final glassPath = Path();
    glassPath.moveTo(centerX - glassWidth / 2, glassTop);
    glassPath.quadraticBezierTo(
      centerX - glassWidth / 2 - 10, glassBottom,
      centerX - glassWidth / 2 + 10, glassBottom,
    );
    glassPath.lineTo(centerX + glassWidth / 2 - 10, glassBottom);
    glassPath.quadraticBezierTo(
      centerX + glassWidth / 2 + 10, glassBottom,
      centerX + glassWidth / 2, glassTop,
    );
    glassPath.close();
    
    // 玻璃杯背景
    final glassBgPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawPath(glassPath, glassBgPaint);
    
    // 裁剪为杯子形状
    canvas.save();
    canvas.clipPath(glassPath);
    
    // 水位高度
    final waterHeight = (glassBottom - glassTop) * fillPercent;
    final waterTop = glassBottom - waterHeight;
    
    // 绘制波浪
    final wavePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF64B5F6).withOpacity(0.8),
          const Color(0xFF1976D2),
        ],
      ).createShader(Rect.fromLTWH(0, waterTop, size.width, waterHeight));
    
    final wavePath = Path();
    wavePath.moveTo(0, waterTop);
    
    for (double x = 0; x <= size.width; x += 2) {
      final wave1 = math.sin((x / size.width * 2 * math.pi) + wavePhase) * 6;
      final wave2 = math.sin((x / size.width * 4 * math.pi) + wavePhase * 1.5) * 3;
      final y = waterTop + wave1 + wave2;
      wavePath.lineTo(x, y);
    }
    
    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();
    
    canvas.drawPath(wavePath, wavePaint);
    
    // 气泡
    if (fillPercent > 0.1) {
      final bubblePaint = Paint()
        ..color = Colors.white.withOpacity(0.6)
        ..style = PaintingStyle.fill;
      
      for (int i = 0; i < 8; i++) {
        final bubbleX = centerX + math.sin(bubblePhase * 2 + i * 0.8) * 30;
        final baseY = waterTop + waterHeight * 0.3;
        final bubbleY = baseY + ((bubblePhase * 100 + i * 40) % (waterHeight * 0.6));
        final bubbleRadius = 3.0 + math.sin(bubblePhase + i) * 2;
        
        canvas.drawCircle(Offset(bubbleX, bubbleY), bubbleRadius, bubblePaint);
      }
    }
    
    canvas.restore();
    
    // 玻璃杯边框
    final glassBorderPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawPath(glassPath, glassBorderPaint);
    
    // 高光
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.5),
          Colors.white.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width * 0.3, size.height * 0.5));
    
    final highlightPath = Path();
    highlightPath.moveTo(centerX - glassWidth / 2 + 15, glassTop + 20);
    highlightPath.quadraticBezierTo(
      centerX - glassWidth / 2 + 10, glassBottom * 0.6,
      centerX - glassWidth / 2 + 20, glassBottom * 0.4,
    );
    highlightPath.lineTo(centerX - glassWidth / 2 + 25, glassBottom * 0.4);
    highlightPath.quadraticBezierTo(
      centerX - glassWidth / 2 + 15, glassBottom * 0.6,
      centerX - glassWidth / 2 + 20, glassTop + 20,
    );
    highlightPath.close();
    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(WaterGlassPainter oldDelegate) {
    return oldDelegate.fillPercent != fillPercent ||
        oldDelegate.wavePhase != wavePhase ||
        oldDelegate.bubblePhase != bubblePhase;
  }
}
