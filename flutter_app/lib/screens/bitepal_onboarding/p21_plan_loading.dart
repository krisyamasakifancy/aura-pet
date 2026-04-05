import 'package:flutter/material.dart';
import '../../widgets/canvas_bear.dart';

class P21PlanLoading extends StatefulWidget {
  final VoidCallback onNext;
  
  const P21PlanLoading({super.key, required this.onNext});

  @override
  State<P21PlanLoading> createState() => _P21PlanLoadingState();
}

class _P21PlanLoadingState extends State<P21PlanLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _progress = 0;
  
  final _steps = [
    'Analyzing BMI...',
    'Calculating BMR...',
    'Optimizing calories...',
    'Setting goals...',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 4), vsync: this)..forward();
    
    _controller.addListener(() {
      final newProgress = (_controller.value * _steps.length).ceil();
      if (newProgress != _progress && newProgress <= _steps.length) {
        setState(() => _progress = newProgress);
      }
    });
    
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) widget.onNext();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Spacer(),
          const CanvasBear(mood: BearMood.thinking, size: 100, animate: true),
          const SizedBox(height: 32),
          const Text('Your plan is being created...', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 24)),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              children: List.generate(_steps.length, (index) {
                final completed = index < _progress;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        completed ? Icons.check_circle : Icons.circle_outlined,
                        color: completed ? const Color(0xFF4CAF50) : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _steps[index],
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: completed ? Colors.black : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
