import 'package:flutter/material.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

class P43WeeklyReport extends StatelessWidget {
  final VoidCallback onNext;
  
  const P43WeeklyReport({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Progress\nReport', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 28, height: 1.2)),
            Text("This week's summary", style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.grey.shade600)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _StatCard(icon: Icons.local_fire_department, value: '12', label: 'Day Streak', color: Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(icon: Icons.trending_down, value: '-2.5', label: 'kg lost', color: Colors.green)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _StatCard(icon: Icons.restaurant, value: '85%', label: 'Calories', color: Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(icon: Icons.timer, value: '18h', label: 'Avg Fast', color: Colors.purple)),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Weight Trend', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    Expanded(
                      child: CustomPaint(
                        size: const Size(double.infinity, double.infinity),
                        painter: _TrendPainter(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                const CanvasBear(mood: BearMood.heartEyes, size: 50, animate: false),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                    child: const Text("Great progress this week! 📈", style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.green)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CapsuleButton(text: 'Continue', onPressed: onNext),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  
  const _StatCard({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 24, color: color)),
          Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    paint.shader = const LinearGradient(colors: [Colors.green, Colors.blue]).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.lineTo(size.width * 0.16, size.height * 0.75);
    path.lineTo(size.width * 0.33, size.height * 0.7);
    path.lineTo(size.width * 0.5, size.height * 0.65);
    path.lineTo(size.width * 0.66, size.height * 0.6);
    path.lineTo(size.width * 0.83, size.height * 0.55);
    path.lineTo(size.width, size.height * 0.5);
    
    canvas.drawPath(path, paint);
    
    final dotPaint = Paint()..style = PaintingStyle.fill..color = Colors.green;
    for (final p in [Offset(0, size.height * 0.8), Offset(size.width * 0.5, size.height * 0.65), Offset(size.width, size.height * 0.5)]) {
      canvas.drawCircle(p, 5, dotPaint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
