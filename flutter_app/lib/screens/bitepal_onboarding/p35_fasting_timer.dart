import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../providers/fullstack_providers.dart';
import '../../widgets/bitepal_widgets.dart';
import '../../widgets/canvas_bear.dart';

/// P35: Fasting Timer - Core implementation with:
/// 1. Ripple Canvas animation
/// 2. Timer countdown logic
/// 3. ThemeController fasting mode sync
/// 4. Quote engine integration
class P35FastingTimer extends StatefulWidget {
  final VoidCallback onNext;
  
  const P35FastingTimer({super.key, required this.onNext});

  @override
  State<P35FastingTimer> createState() => _P35FastingTimerState();
}

class _P35FastingTimerState extends State<P35FastingTimer>
    with TickerProviderStateMixin {
  
  // ===== Timer State =====
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isStarted = false;
  
  // ===== Ripple Animation Controllers =====
  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Ripple expansion animation
    _rippleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rippleController.dispose();
    super.dispose();
  }

  // ===== START FASTING - Core Logic =====
  void _startFasting() {
    setState(() => _isStarted = true);
    
    // 1. Start global Timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
      
      // 2. Sync to OnboardingState
      final state = Provider.of<OnboardingState>(context, listen: false);
      state.updateFastingProgress(_elapsedSeconds ~/ 60);
      
      // 3. Persist start time
      PersistenceService().saveFastingState(
        state: 'running',
        durationMinutes: _elapsedSeconds ~/ 60,
      );
      
      // 4. Trigger night fasting quote after 10PM
      if (DateTime.now().hour >= 22 && _elapsedSeconds % 300 == 0) {
        _showQuote(QuoteEngine.instance.getSleepQuote(isFasting: true));
      }
    });
    
    // 5. Start ripple animation
    _rippleController.repeat();
    
    // 6. 【CORE】Global background color change
    final theme = Provider.of<ThemeController>(context, listen: false);
    theme.startFasting(); // → backgroundColor: #1A0033 Deep Purple
    
    // 7. Trigger fasting quote
    _showQuote(QuoteEngine.instance.getFastingQuote());
  }
  
  void _showQuote(String quote) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(quote, style: const TextStyle(fontFamily: 'Inter', fontSize: 14)),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _stopFasting() {
    _timer?.cancel();
    _rippleController.stop();
    
    final theme = Provider.of<ThemeController>(context, listen: false);
    theme.stopFasting();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<OnboardingState>(context);
    final theme = Provider.of<ThemeController>(context);
    
    // Calculate progress
    final progress = state.fastingDurationMinutes / state.fastingGoalMinutes;
    final hours = _elapsedSeconds ~/ 3600;
    final minutes = (_elapsedSeconds % 3600) ~/ 60;
    final seconds = _elapsedSeconds % 60;
    
    return Container(
      // 【CORE】Background follows ThemeController
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: theme.isFastingMode
              ? [const Color(0xFF1A0033), const Color(0xFF2D1B4E)] // Deep purple
              : [MonetColors.airBlue, Colors.white], // Air blue
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Fasting Timer',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: theme.textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isStarted ? 'Keep going! Your body is healing...' : 'Ready to start your fast?',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: theme.subtitleColor,
                ),
              ),
              const Spacer(),
              
              // Timer Ring with Ripple Animation
              Stack(
                alignment: Alignment.center,
                children: [
                  // 【CORE】Ripple Canvas Animation
                  if (_isStarted)
                    AnimatedBuilder(
                      animation: _rippleAnimation,
                      builder: (context, child) {
                        return CustomPaint(
                          size: const Size(280, 280),
                          painter: _RipplePainter(
                            progress: _rippleAnimation.value,
                            color: theme.isFastingMode 
                                ? const Color(0xFF9C27B0) 
                                : const Color(0xFF4CAF50),
                          ),
                        );
                      },
                    ),
                  
                  // Progress Ring
                  SizedBox(
                    width: 250, height: 250,
                    child: CircularProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      strokeWidth: 16,
                      backgroundColor: theme.isFastingMode ? Colors.white24 : Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(
                        theme.isFastingMode ? const Color(0xFF9C27B0) : const Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                  
                  // Time Display
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                          color: theme.textColor,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(progress * 100).round()}%',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: theme.subtitleColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Goal: ${state.fastingGoalMinutes ~/ 60}h fast',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: theme.subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const Spacer(),
              
              // START FASTING / STOP Button
              if (!_isStarted)
                CapsuleButton(
                  text: 'START FASTING',
                  onPressed: _startFasting,
                  backgroundColor: theme.isFastingMode 
                      ? const Color(0xFF9C27B0) 
                      : const Color(0xFF4CAF50),
                )
              else
                Column(
                  children: [
                    Row(
                      children: [
                        CanvasBear(mood: BearMood.sleeping, size: 50, animate: true),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.isFastingMode 
                                  ? Colors.white.withOpacity(0.2) 
                                  : Colors.purple.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              theme.isFastingMode 
                                  ? QuoteEngine.instance.getFastingQuote(isNight: DateTime.now().hour >= 22)
                                  : "Sweet dreams! Your fast is going well!",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: theme.textColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _stopFasting,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: theme.isFastingMode ? Colors.white54 : Colors.grey),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              'End Fast',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: theme.textColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CapsuleButton(
                            text: 'Continue',
                            onPressed: () {
                              _stopFasting();
                              widget.onNext();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              
              if (!_isStarted) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: widget.onNext,
                  child: Text(
                    'Skip for now',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: theme.subtitleColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 【CORE】Ripple Canvas Animation Painter
class _RipplePainter extends CustomPainter {
  final double progress;
  final Color color;
  
  _RipplePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;
    
    // Multiple ripple layers
    for (int i = 0; i < 3; i++) {
      final rippleProgress = (progress + i * 0.25) % 1.0;
      final radius = maxRadius * rippleProgress;
      final opacity = (1.0 - rippleProgress) * 0.4;
      
      final paint = Paint()
        ..color = color.withOpacity(opacity.clamp(0.0, 0.4))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;
      
      canvas.drawCircle(center, radius, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
