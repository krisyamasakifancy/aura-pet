import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';
import '../../widgets/bitepal_widgets.dart';

/// P04: Feature Introduction - Hydration
/// "Stay hydrated...Easily track your water..."
class P04FeatureHydration extends StatelessWidget {
  final VoidCallback onNext;
  
  const P04FeatureHydration({super.key, required this.onNext});
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            // Diving bear with bubbles
            Stack(
              alignment: Alignment.center,
              children: [
                // Water wave animation placeholder
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 300,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue.shade100.withOpacity(0),
                          Colors.blue.shade200.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                ),
                // Bear
                const CanvasBear(
                  mood: BearMood.潜水,
                  size: 180,
                ),
                // Bubbles
                const _WaterBubbles(),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Stay hydrated',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Easily track your water intake\nand build healthy habits',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            // Water glasses
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildWaterGlass(0.3, '+'),
                const SizedBox(width: 16),
                _buildWaterGlass(0.6, '+'),
                const SizedBox(width: 16),
                _buildWaterGlass(1.0, '✓'),
              ],
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
                width: index == 2 ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == 2 ? Colors.black : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildWaterGlass(double fill, String action) {
    return Container(
      width: 70,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200, width: 2),
      ),
      child: Stack(
        children: [
          // Water fill
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              child: Container(
                height: 100 * fill,
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                ),
              ),
            ),
          ),
          // Action button
          Positioned(
            bottom: 4,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  action,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaterBubbles extends StatefulWidget {
  const _WaterBubbles();
  
  @override
  State<_WaterBubbles> createState() => _WaterBubblesState();
}

class _WaterBubblesState extends State<_WaterBubbles>
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
        return SizedBox(
          width: 250,
          height: 250,
          child: Stack(
            children: [
              _buildBubble(30, 200, 10, _controller.value),
              _buildBubble(80, 180, 8, (_controller.value + 0.3) % 1),
              _buildBubble(150, 210, 12, (_controller.value + 0.6) % 1),
              _buildBubble(200, 190, 6, (_controller.value + 0.9) % 1),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildBubble(double x, double y, double size, double progress) {
    final animatedY = y - progress * 60;
    final opacity = (1 - progress).clamp(0.0, 0.6);
    
    return Positioned(
      left: x,
      top: animatedY,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue.shade300.withOpacity(opacity),
        ),
      ),
    );
  }
}
