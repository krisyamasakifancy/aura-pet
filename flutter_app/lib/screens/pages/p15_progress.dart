import 'package:flutter/material.dart';
import 'dart:math' as math;

/// P15: 体重进度 - 莫奈渐变色Bezier曲线图
class P15ProgressScreen extends StatefulWidget {
  const P15ProgressScreen({super.key});

  @override
  State<P15ProgressScreen> createState() => _P15ProgressScreenState();
}

class _P15ProgressScreenState extends State<P15ProgressScreen>
    with SingleTickerProviderStateMixin {
  // 体重数据 (过去30天)
  final List<Map<String, dynamic>> _weightData = [
    {'day': 1, 'weight': 68.5, 'target': 65.0},
    {'day': 3, 'weight': 68.2, 'target': 65.0},
    {'day': 5, 'weight': 67.8, 'target': 65.0},
    {'day': 7, 'weight': 67.5, 'target': 65.0},
    {'day': 9, 'weight': 67.2, 'target': 65.0},
    {'day': 11, 'weight': 66.9, 'target': 65.0},
    {'day': 13, 'weight': 66.5, 'target': 65.0},
    {'day': 15, 'weight': 66.3, 'target': 65.0},
    {'day': 17, 'weight': 66.0, 'target': 65.0},
    {'day': 19, 'weight': 65.8, 'target': 65.0},
    {'day': 21, 'weight': 65.5, 'target': 65.0},
    {'day': 23, 'weight': 65.3, 'target': 65.0},
    {'day': 25, 'weight': 65.1, 'target': 65.0},
    {'day': 27, 'weight': 65.0, 'target': 65.0},
    {'day': 29, 'weight': 64.8, 'target': 65.0},
  ];

  final double _currentWeight = 64.8;
  final double _startWeight = 68.5;
  final double _targetWeight = 65.0;
  final double _bmi = 22.5;

  late AnimationController _chartAnimController;
  late Animation<double> _chartAnimation;
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _chartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _chartAnimation = CurvedAnimation(
      parent: _chartAnimController,
      curve: Curves.easeOutCubic,
    );
    _chartAnimController.forward();
  }

  @override
  void dispose() {
    _chartAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lostWeight = _startWeight - _currentWeight;
    final progressPercent = ((_startWeight - _targetWeight) > 0)
        ? (lostWeight / (_startWeight - _targetWeight) * 100).clamp(0, 100)
        : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: SafeArea(
        child: Column(
          children: [
            // 顶部标题
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  const Text('📈', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Progress',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF8BA0), Color(0xFFFFB4C4)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF8BA0).withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.trending_down, size: 16, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          '-3.7kg',
                          style: TextStyle(
                            fontSize: 14,
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

            // 核心指标卡片
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      'Current',
                      '${_currentWeight.toStringAsFixed(1)} kg',
                      Icons.monitor_weight,
                      const Color(0xFFFF8BA0),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      'Target',
                      '${_targetWeight.toStringAsFixed(1)} kg',
                      Icons.flag,
                      const Color(0xFF6C63FF),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      'Lost',
                      '${lostWeight.toStringAsFixed(1)} kg',
                      Icons.remove_circle,
                      const Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 莫奈渐变图表
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 图表头部
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Row(
                        children: [
                          const Text(
                            'Weight Trend',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                          const Spacer(),
                          _buildLegendItem('Actual', const Color(0xFFFF8BA0)),
                          const SizedBox(width: 12),
                          _buildLegendItem('Target', const Color(0xFF6C63FF)),
                        ],
                      ),
                    ),
                    
                    // Bezier曲线图
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _chartAnimation,
                        builder: (context, child) {
                          return GestureDetector(
                            onTapDown: (details) {
                              _handleChartTap(details.localPosition);
                            },
                            child: CustomPaint(
                              size: Size.infinite,
                              painter: MonetWeightChartPainter(
                                data: _weightData,
                                animationValue: _chartAnimation.value,
                                selectedIndex: _selectedIndex,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // 底部统计
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8F0).withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem('Avg', '${(_weightData.map((e) => e['weight'] as double).reduce((a, b) => a + b) / _weightData.length).toStringAsFixed(1)}', 'kg'),
                          Container(width: 1, height: 30, color: Colors.grey.withOpacity(0.2)),
                          _buildStatItem('Progress', '${progressPercent.toStringAsFixed(0)}', '%'),
                          Container(width: 1, height: 30, color: Colors.grey.withOpacity(0.2)),
                          _buildStatItem('Days', '${_weightData.length}', 'days'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 周对比卡片
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.compare_arrows, size: 20, color: Color(0xFF6C63FF)),
                      SizedBox(width: 8),
                      Text(
                        'Week Comparison',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D3436),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildWeekBar('This Week', -0.8, const Color(0xFF4CAF50)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildWeekBar('Last Week', -1.2, const Color(0xFFFF8BA0)),
                      ),
                    ],
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

  void _handleChartTap(Offset position) {
    // 简单的点击处理
    setState(() {
      _selectedIndex = _selectedIndex == 0 ? -1 : 0;
    });
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
        const SizedBox(height: 2),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3436),
                ),
              ),
              TextSpan(
                text: unit,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeekBar(String label, double change, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              change < 0 ? Icons.arrow_downward : Icons.arrow_upward,
              size: 14,
              color: color,
            ),
            const SizedBox(width: 2),
            Text(
              '${change.abs().toStringAsFixed(1)}kg',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 莫奈渐变色体重图表绘制器
class MonetWeightChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double animationValue;
  final int selectedIndex;

  MonetWeightChartPainter({
    required this.data,
    required this.animationValue,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final leftPadding = 45.0;
    final bottomPadding = 30.0;
    final topPadding = 20.0;
    final rightPadding = 20.0;

    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - bottomPadding - topPadding;

    // 找出权重范围
    final weights = data.map((e) => e['weight'] as double).toList();
    final minWeight = (weights.reduce(math.min) - 1).floorToDouble();
    final maxWeight = (weights.reduce(math.max) + 1).ceilToDouble();

    // 绘制网格线
    _drawGrid(canvas, size, leftPadding, topPadding, chartWidth, chartHeight, minWeight, maxWeight);

    // 绘制目标线
    _drawTargetLine(canvas, size, leftPadding, topPadding, chartWidth, chartHeight, data.first['target'] as double, minWeight, maxWeight);

    // 绘制实际体重曲线
    _drawWeightCurve(canvas, size, leftPadding, topPadding, chartWidth, chartHeight, minWeight, maxWeight);

    // 绘制数据点
    _drawDataPoints(canvas, size, leftPadding, topPadding, chartWidth, chartHeight, minWeight, maxWeight);
  }

  void _drawGrid(Canvas canvas, Size size, double left, double top, double width, double height, double minW, double maxW) {
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..strokeWidth = 1;

    // 水平网格线
    const horizontalLines = 5;
    for (int i = 0; i <= horizontalLines; i++) {
      final y = top + (height / horizontalLines) * i;
      canvas.drawLine(Offset(left, y), Offset(left + width, y), gridPaint);
      
      // Y轴标签
      final weight = maxW - ((maxW - minW) / horizontalLines) * i;
      final textPainter = TextPainter(
        text: TextSpan(
          text: weight.toStringAsFixed(0),
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[400],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(left - textPainter.width - 8, y - textPainter.height / 2));
    }

    // X轴标签 (天数)
    final step = (data.length / 5).ceil();
    for (int i = 0; i < data.length; i += step) {
      final x = left + (width / (data.length - 1)) * i;
      final textPainter = TextPainter(
        text: TextSpan(
          text: 'D${data[i]['day']}',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[400],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, top + height + 8));
    }
  }

  void _drawTargetLine(Canvas canvas, Size size, double left, double top, double width, double height, double target, double minW, double maxW) {
    final targetY = top + height * (1 - (target - minW) / (maxW - minW));

    final dashPaint = Paint()
      ..color = const Color(0xFF6C63FF).withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // 虚线
    const dashWidth = 8.0;
    const dashSpace = 4.0;
    var startX = left;
    while (startX < left + width) {
      canvas.drawLine(
        Offset(startX, targetY),
        Offset(math.min(startX + dashWidth, left + width), targetY),
        dashPaint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  void _drawWeightCurve(Canvas canvas, Size size, double left, double top, double width, double height, double minW, double maxW) {
    if (data.length < 2) return;

    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = left + (width / (data.length - 1)) * i;
      final y = top + height * (1 - (data[i]['weight'] as double - minW) / (maxW - minW));
      points.add(Offset(x, y));
    }

    // 莫奈渐变填充
    final fillPath = Path();
    fillPath.moveTo(points.first.dx, top + height);
    
    // 使用Bezier曲线平滑
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[i];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = i < points.length - 2 ? points[i + 2] : points[i + 1];

      final cp1x = p1.dx + (p2.dx - p0.dx) / 6;
      final cp1y = p1.dy + (p2.dy - p0.dy) / 6;
      final cp2x = p2.dx - (p3.dx - p1.dx) / 6;
      final cp2y = p2.dy - (p3.dy - p1.dy) / 6;

      fillPath.cubicTo(cp1x, cp1y, cp2x, cp2y, p2.dx, p2.dy);
    }

    fillPath.lineTo(points.last.dx, top + height);
    fillPath.close();

    // 莫奈风格渐变
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFF8BA0).withOpacity(0.4),
          const Color(0xFFFFB4C4).withOpacity(0.1),
          const Color(0xFFFFF8F0).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(left, top, width, height));

    canvas.drawPath(fillPath, fillPaint);

    // 曲线描边
    final strokePath = Path();
    strokePath.moveTo(points.first.dx, points.first.dy);
    
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[i];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = i < points.length - 2 ? points[i + 2] : points[i + 1];

      final cp1x = p1.dx + (p2.dx - p0.dx) / 6;
      final cp1y = p1.dy + (p2.dy - p0.dy) / 6;
      final cp2x = p2.dx - (p3.dx - p1.dx) / 6;
      final cp2y = p2.dy - (p3.dy - p1.dy) / 6;

      strokePath.cubicTo(cp1x, cp1y, cp2x, cp2y, p2.dx, p2.dy);
    }

    // 发光效果
    final glowPaint = Paint()
      ..color = const Color(0xFFFF8BA0).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    
    canvas.drawPath(strokePath, glowPaint);

    // 主曲线
    final strokePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFFFF8BA0),
          Color(0xFFFFB74D),
          Color(0xFFFF8BA0),
        ],
      ).createShader(Rect.fromLTWH(left, top, width, height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(strokePath, strokePaint);
  }

  void _drawDataPoints(Canvas canvas, Size size, double left, double top, double width, double height, double minW, double maxW) {
    for (int i = 0; i < data.length; i++) {
      final x = left + (width / (data.length - 1)) * i;
      final y = top + height * (1 - (data[i]['weight'] as double - minW) / (maxW - minW));
      
      final isSelected = i == selectedIndex;
      final animProgress = (i / data.length).clamp(0.0, animationValue);
      
      if (animProgress <= 0) continue;
      
      final currentX = left + (x - left) * animationValue.clamp(0.0, 1.0);
      
      // 外圈光晕
      final glowPaint = Paint()
        ..color = const Color(0xFFFF8BA0).withOpacity(0.3)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(currentX, y), isSelected ? 12 : 8, glowPaint);
      
      // 白底
      final bgPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(currentX, y), isSelected ? 8 : 5, bgPaint);
      
      // 圆点
      final dotPaint = Paint()
        ..color = const Color(0xFFFF8BA0)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(currentX, y), isSelected ? 6 : 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(MonetWeightChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}
