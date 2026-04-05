import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 体重进度 P7 - 莫奈风格磨砂玻璃折线图
class ProgressP7Screen extends StatefulWidget {
  const ProgressP7Screen({super.key});

  @override
  State<ProgressP7Screen> createState() => _ProgressP7ScreenState();
}

class _ProgressP7ScreenState extends State<ProgressP7Screen>
    with TickerProviderStateMixin {
  int _selectedPeriod = 0; // 0=Week, 1=Month, 2=Year
  late AnimationController _chartController;
  late AnimationController _flowController;
  late Animation<double> _chartAnimation;
  late Animation<double> _flowAnimation;

  // 模拟数据
  final Map<int, List<double>> _data = {
    0: [68, 67.5, 67.2, 66.8, 66.5, 66.2, 66.0], // Week
    1: [70, 69, 68.5, 68, 67.5, 67, 66.5, 66.2, 66, 65.8, 65.5, 65.2, 65, 64.8, 64.5, 64.2, 64, 63.8, 63.5, 63.2, 63, 62.8, 62.5, 62.2, 62, 61.8, 61.5, 61.2, 61, 60.8], // Month
    2: [80, 78, 76, 74, 72, 70, 68, 66, 64, 63, 62, 61], // Year
  };

  @override
  void initState() {
    super.initState();
    
    _chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _chartAnimation = CurvedAnimation(
      parent: _chartController,
      curve: Curves.easeOutCubic,
    );
    
    _flowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    
    _flowAnimation = Tween<double>(begin: 0, end: 1).animate(_flowController);
    
    _chartController.forward();
  }

  @override
  void dispose() {
    _chartController.dispose();
    _flowController.dispose();
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
              Color(0xFFFFF8F0),
              Color(0xFFFFE4D6),
              Color(0xFFF5E6D3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildSummaryCard(),
                      const SizedBox(height: 24),
                      _buildPeriodSelector(),
                      const SizedBox(height: 24),
                      _buildChartCard(),
                      const SizedBox(height: 24),
                      _buildStatsCards(),
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
              'Weight Progress',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3436),
              ),
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.share_outlined,
              color: Color(0xFF2D3436),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFFFF8F5),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8BA0).withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // 目标进度
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Journey to Goal',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF636E72),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 80, end: 60),
                      duration: const Duration(milliseconds: 1500),
                      builder: (context, value, child) {
                        return Text(
                          value.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [Color(0xFFFF8BA0), Color(0xFFFFB4C4)],
                              ).createShader(const Rect.fromLTWH(0, 0, 100, 50)),
                          ),
                        );
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8, left: 4),
                      child: Text(
                        'kg',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF636E72),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_down, size: 14, color: Color(0xFF4CAF50)),
                      SizedBox(width: 4),
                      Text(
                        '-20kg achieved!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 圆环进度
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 0.75),
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return CircularProgressIndicator(
                      value: value,
                      strokeWidth: 10,
                      backgroundColor: const Color(0xFFFFE4D6),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF8BA0),
                      ),
                      strokeCap: StrokeCap.round,
                    );
                  },
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 75),
                      duration: const Duration(milliseconds: 2000),
                      builder: (context, value, child) {
                        return Text(
                          '${value.toInt()}%',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFFF8BA0),
                          ),
                        );
                      },
                    ),
                    const Text(
                      'done',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF636E72),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ['Week', 'Month', 'Year'];
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: List.generate(periods.length, (index) {
          final isSelected = _selectedPeriod == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedPeriod = index);
                _chartController.reset();
                _chartController.forward();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFF8BA0) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  periods[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF636E72),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildChartCard() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.9),
            Colors.white.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                '📊 ',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'Weight Trend',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: AnimatedBuilder(
              animation: Listenable.merge([_chartAnimation, _flowAnimation]),
              builder: (context, child) {
                return CustomPaint(
                  painter: _MonetChartPainter(
                    data: _data[_selectedPeriod]!,
                    progress: _chartAnimation.value,
                    flowPhase: _flowAnimation.value,
                  ),
                  size: Size.infinite,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: '📈',
            title: 'Average',
            value: '66.5',
            unit: 'kg',
            color: const Color(0xFF7BC4FF),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: '🔥',
            title: 'Lost',
            value: '20',
            unit: 'kg',
            color: const Color(0xFFFF8BA0),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: '⏱️',
            title: 'Days',
            value: '180',
            unit: 'days',
            color: const Color(0xFF9B8FE8),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String title,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: double.parse(value)),
            duration: const Duration(milliseconds: 1500),
            builder: (context, v, child) {
              return Text(
                v.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              );
            },
          ),
          Text(
            unit,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFFB2BEC3),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF636E72),
            ),
          ),
        ],
      ),
    );
  }
}

/// 莫奈风格折线图 Painter
class _MonetChartPainter extends CustomPainter {
  final List<double> data;
  final double progress;
  final double flowPhase;
  
  _MonetChartPainter({
    required this.data,
    required this.progress,
    required this.flowPhase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    
    final minVal = data.reduce(math.min);
    final maxVal = data.reduce(math.max);
    final range = maxVal - minVal;
    
    // 计算点
    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - ((data[i] - minVal) / range) * size.height * 0.8 - size.height * 0.1;
      points.add(Offset(x, y));
    }
    
    // 渐变填充
    final fillPath = Path();
    fillPath.moveTo(0, size.height);
    
    for (int i = 0; i < points.length; i++) {
      final animatedX = points[i].dx * progress;
      if (i == 0) {
        fillPath.lineTo(animatedX, points[i].dy);
      } else {
        // 曲线连接
        final prev = points[i - 1];
        final curr = points[i];
        final cpX = (prev.dx + curr.dx) / 2;
        
        fillPath.quadraticBezierTo(
          prev.dx + (curr.dx - prev.dx) * 0.5,
          prev.dy,
          cpX * progress,
          (prev.dy + curr.dy) / 2,
        );
        if (i == points.length - 1) {
          fillPath.lineTo(animatedX, curr.dy);
        }
      }
    }
    
    fillPath.lineTo(size.width * progress, size.height);
    fillPath.close();
    
    // 渐变画笔
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFF8BA0).withValues(alpha: 0.4),
          const Color(0xFFFF8BA0).withValues(alpha: 0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawPath(fillPath, fillPaint);
    
    // 折线
    final linePath = Path();
    for (int i = 0; i < points.length; i++) {
      final x = points[i].dx * progress;
      final y = points[i].dy;
      
      if (i == 0) {
        linePath.moveTo(x, y);
      } else {
        final prev = points[i - 1];
        final prevX = prev.dx * progress;
        final prevY = prev.dy;
        final cpX = (prevX + x) / 2;
        
        linePath.quadraticBezierTo(cpX, prevY, (prevX + x) / 2, (prevY + y) / 2);
        if (i == points.length - 1) {
          linePath.lineTo(x, y);
        }
      }
    }
    
    final linePaint = Paint()
      ..color = const Color(0xFFFF8BA0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    canvas.drawPath(linePath, linePaint);
    
    // 数据点
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final dotBorderPaint = Paint()
      ..color = const Color(0xFFFF8BA0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    for (int i = 0; i < points.length; i++) {
      if (i / points.length > progress) break;
      
      final x = points[i].dx * progress;
      final y = points[i].dy;
      
      // 光晕
      final glowPaint = Paint()
        ..color = const Color(0xFFFF8BA0).withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(Offset(x, y), 12, glowPaint);
      
      // 圆点
      canvas.drawCircle(Offset(x, y), 6, dotPaint);
      canvas.drawCircle(Offset(x, y), 6, dotBorderPaint);
    }
    
    // 流动光效
    if (progress >= 1.0) {
      final glowX = (flowPhase * size.width * 2) % (size.width * 1.5) - size.width * 0.25;
      
      final flowGlow = Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFB4C4).withValues(alpha: 0.4),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: Offset(glowX, size.height / 2), radius: 60));
      
      canvas.drawCircle(Offset(glowX, size.height / 2), 60, flowGlow);
    }
  }

  @override
  bool shouldRepaint(covariant _MonetChartPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.flowPhase != flowPhase;
  }
}
