import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/monet_background.dart';

/// P02: Welcome Screen
/// Soft blue background, "Reach your weight goals", heart-eyes bear with flying hearts
class P02Welcome extends StatelessWidget {
  final VoidCallback onNext;
  
  const P02Welcome({super.key, required this.onNext});
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            // Title
            const Text(
              'Reach your\nweight goals',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'BitePal keeps you on track',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 40),
            // Bear with hearts
            Stack(
              alignment: Alignment.center,
              children: [
                // Flying hearts background
                const _FlyingHearts(),
                // Bear
                const CanvasBear(
                  mood: BearMood.heartEyes,
                  size: 200,
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Oatmeal bowl illustration placeholder
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5E6D3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.breakfast_dining, 
                        color: Color(0xFF8B4513), size: 32),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Oatmeal with berries',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '310 kcal',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            // CTA Button
            SizedBox(
              width: double.infinity,
              child: CapsuleButton(
                text: 'Get started >',
                onPressed: onNext,
              ),
            ),
            const SizedBox(height: 16),
            // Pagination dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: index == 0 ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == 0 ? Colors.black : Colors.grey.shade300,
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

class _FlyingHearts extends StatefulWidget {
  const _FlyingHearts();
  
  @override
  State<_FlyingHearts> createState() => _FlyingHeartsState();
}

class _FlyingHeartsState extends State<_FlyingHearts>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
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
        return Stack(
          children: [
            _buildHeart(0, 50, 150, _controller.value),
            _buildHeart(1, 150, 80, (_controller.value + 0.3) % 1),
            _buildHeart(2, 80, 200, (_controller.value + 0.6) % 1),
          ],
        );
      },
    );
  }
  
  Widget _buildHeart(int index, double x, double y, double progress) {
    final animatedY = y - progress * 50;
    final opacity = (1 - progress * 2).clamp(0.0, 1.0);
    final scale = 1.0 + progress * 0.5;
    
    return Positioned(
      left: x,
      top: animatedY,
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: Icon(
            Icons.favorite,
            color: Colors.pink.shade300.withOpacity(0.6),
            size: 24,
          ),
        ),
      ),
    );
  }
}
