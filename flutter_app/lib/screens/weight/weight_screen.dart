import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class WeightScreen extends StatelessWidget {
  const WeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('体重追踪'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // BMI Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AuraPetTheme.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AuraPetTheme.shadowMd,
              ),
              child: Column(
                children: [
                  const Text(
                    '你的 BMI',
                    style: TextStyle(
                      fontSize: 14,
                      color: AuraPetTheme.textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '24.5',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: AuraPetTheme.primary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AuraPetTheme.bgGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '正常体重',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AuraPetTheme.accent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // BMI Scale
                  Stack(
                    children: [
                      Container(
                        height: 12,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF3498DB),
                              Color(0xFF2ECC71),
                              Color(0xFFF1C40F),
                              Color(0xFFE74C3C),
                            ],
                            stops: [0.0, 0.3, 0.6, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.55,
                        child: Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.only(top: -6),
                          decoration: BoxDecoration(
                            color: AuraPetTheme.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AuraPetTheme.primary,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('偏瘦', style: TextStyle(fontSize: 11, color: AuraPetTheme.textLight)),
                      Text('正常', style: TextStyle(fontSize: 11, color: AuraPetTheme.textLight)),
                      Text('超重', style: TextStyle(fontSize: 11, color: AuraPetTheme.textLight)),
                      Text('肥胖', style: TextStyle(fontSize: 11, color: AuraPetTheme.textLight)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Weight Chart
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AuraPetTheme.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AuraPetTheme.shadowMd,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '📈 体重趋势',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        '近7天',
                        style: TextStyle(
                          fontSize: 13,
                          color: AuraPetTheme.textLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _ChartBar(height: 0.6),
                        _ChartBar(height: 0.55),
                        _ChartBar(height: 0.58),
                        _ChartBar(height: 0.52),
                        _ChartBar(height: 0.48),
                        _ChartBar(height: 0.45),
                        _ChartBar(height: 0.42),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Log button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AuraPetTheme.primary, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  '📝 记录今日体重',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AuraPetTheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  final double height;

  const _ChartBar({required this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: 100 * height,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AuraPetTheme.primary, AuraPetTheme.bgPink],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '一',
          style: TextStyle(fontSize: 11, color: AuraPetTheme.textLight),
        ),
      ],
    );
  }
}
