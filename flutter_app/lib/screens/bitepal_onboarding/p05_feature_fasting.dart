import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';

/// P05: Feature Introduction - Fasting
/// "Enjoy fasting...Build a healthy habit..."
class P05FeatureFasting extends StatelessWidget {
  final VoidCallback onNext;
  
  const P05FeatureFasting({super.key, required this.onNext});
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            // Sleeping bear with green grass
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Green grass
                Container(
                  height: 40,
                  width: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF81C784),
                        const Color(0xFF4CAF50),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(150),
                      bottomRight: Radius.circular(150),
                    ),
                  ),
                ),
                // Sleeping bear
                const CanvasBear(
                  mood: BearMood.sleeping,
                  size: 180,
                ),
                // Zzz animation
                const _ZzzAnimation(),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Enjoy fasting',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Build a healthy habit with\nintermittent fasting',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            // Fasting timer ring
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const CircularProgress(
                    progress: 0.1,
                    size: 120,
                    strokeWidth: 10,
                    progressColor: Color(0xFF4CAF50),
                    child: Text(
                      '00:01:20',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Fasting state',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '16h Recommended',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: CapsuleButton(
                text: 'Next >',
                onPressed: onNext,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: index == 3 ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == 3 ? Colors.black : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZzzAnimation extends StatefulWidget {
  const _ZzzAnimation();
  
  @override
  State<_ZzzAnimation> createState() => _ZzzAnimationState();
}

class _ZzzAnimationState extends State<_ZzzAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Positioned(
          right: 30,
          top: 20 + 10 * _controller.value,
          child: Opacity(
            opacity: (1 - _controller.value).clamp(0.0, 1.0),
            child: Text(
              'Zzz',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 20 + 10 * _controller.value,
                color: Colors.blue.shade300,
              ),
            ),
          ),
        );
      },
    );
  }
}
