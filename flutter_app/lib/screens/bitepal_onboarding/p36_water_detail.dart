import 'package:flutter/material.dart';
import '../../widgets/bitepal_widgets.dart';

/// P36: Water Detail
/// "Total Water: 1.5L / 2.5L"
class P36WaterDetail extends StatefulWidget {
  final VoidCallback onNext;
  
  const P36WaterDetail({super.key, required this.onNext});
  
  @override
  State<P36WaterDetail> createState() => _P36WaterDetailState();
}

class _P36WaterDetailState extends State<P36WaterDetail> {
  double _water = 1500; // ml
  final double _goal = 2500; // ml
  
  void _addWater(int ml) {
    setState(() {
      _water = (_water + ml).clamp(0, _goal * 2);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final progress = (_water / _goal).clamp(0.0, 1.0);
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Stay Hydrated',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to add water',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const Spacer(),
            // Water visualization
            Center(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Glass outline
                  Container(
                    width: 150,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.shade200, width: 4),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                  ),
                  // Water fill
                  Positioned(
                    bottom: 4,
                    left: 4,
                    right: 4,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36),
                      ),
                      child: Container(
                        height: 242 * progress,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.blue.shade200,
                              Colors.blue.shade400,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Amount text
                  Positioned(
                    top: 80,
                    child: Text(
                      '${(_water / 1000).toStringAsFixed(1)}L',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '${_water.toInt()}ml / ${_goal.toInt()}ml',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Quick add buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _WaterButton(ml: 250, onTap: () => _addWater(250)),
                _WaterButton(ml: 500, onTap: () => _addWater(500)),
                _WaterButton(ml: 750, onTap: () => _addWater(750)),
                _WaterButton(ml: 1000, onTap: () => _addWater(1000)),
              ],
            ),
            const Spacer(),
            if (progress >= 1.0)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.celebration, color: Colors.blue),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Great job! You\'ve reached your daily water goal! 🎉',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            CapsuleButton(
              text: 'Next >',
              onPressed: widget.onNext,
            ),
          ],
        ),
      ),
    );
  }
}

class _WaterButton extends StatelessWidget {
  final int ml;
  final VoidCallback onTap;
  
  const _WaterButton({required this.ml, required this.onTap});
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Column(
          children: [
            Icon(Icons.water_drop, color: Colors.blue.shade400, size: 24),
            const SizedBox(height: 4),
            Text(
              '${ml}ml',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.blue.shade700,
              ),
            ),
            const Text(
              '+',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
