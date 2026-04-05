import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';

/// P35: Fasting Timer
/// Big countdown ring with "START FASTING"
class P35FastingTimer extends StatefulWidget {
  final VoidCallback onNext;
  
  const P35FastingTimer({super.key, required this.onNext});
  
  @override
  State<P35FastingTimer> createState() => _P35FastingTimerState();
}

class _P35FastingTimerState extends State<P35FastingTimer>
    with SingleTickerProviderStateMixin {
  bool _isStarted = false;
  late AnimationController _waveController;
  
  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }
  
  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Fasting Timer',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const Spacer(),
            // Timer ring
            Stack(
              alignment: Alignment.center,
              children: [
                // Wave animation
                if (_isStarted)
                  AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, child) {
                      return Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                        ),
                        child: CustomPaint(
                          painter: _WavePainter(_waveController.value),
                        ),
                      );
                    },
                  ),
                // Progress ring
                CircularProgress(
                  progress: _isStarted ? 0.1 : 0,
                  size: 250,
                  strokeWidth: 12,
                  progressColor: const Color(0xFF4CAF50),
                  backgroundColor: Colors.grey.shade200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isStarted ? '15:42:30' : '16:00:00',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                      ),
                      Text(
                        _isStarted ? 'remaining' : 'hours',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Bear
            CanvasBear(
              mood: _isStarted ? BearMood.sleeping : BearMood.defaultMood,
              size: 120,
            ),
            const Spacer(),
            if (!_isStarted)
              Column(
                children: [
                  Text(
                    'Ready to start your fast?',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CapsuleButton(
                    text: 'Start fasting >',
                    onPressed: () => setState(() => _isStarted = true),
                    backgroundColor: const Color(0xFF4CAF50),
                  ),
                ],
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Your fasting session has started! You\'ve got this! 💪',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final double progress;
  
  _WavePainter(this.progress);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4CAF50).withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    final path = Path();
    final waveHeight = 10.0;
    final startY = size.height * 0.3;
    
    path.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x++) {
      final y = startY + waveHeight * 
          (1 + (x / size.width * 4 * 3.14159 + progress * 2 * 3.14159).sin()) / 2;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(_WavePainter oldDelegate) => 
      oldDelegate.progress != progress;
}

extension on double {
  double sin() => math.sin(this);
}

import 'dart:math' as math;
