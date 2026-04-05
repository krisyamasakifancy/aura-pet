import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/aura_theme.dart';
import '../widgets/q_raccoon_canvas.dart';

/// 极简空气感禁食计时器 - 对标竞品截图
class AuraFastingScreen extends StatefulWidget {
  const AuraFastingScreen({super.key});

  @override
  State<AuraFastingScreen> createState() => _AuraFastingScreenState();
}

class _AuraFastingScreenState extends State<AuraFastingScreen>
    with TickerProviderStateMixin {
  bool _isFasting = false;
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // 16:8 方案
  final int _fastingHours = 16;
  final int _eatingHours = 8;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startFasting() {
    setState(() {
      _isFasting = true;
      _elapsed = Duration.zero;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsed += const Duration(seconds: 1);
      });

      // 达到目标后自动停止
      if (_elapsed.inHours >= _fastingHours) {
        _stopFasting();
      }
    });
  }

  void _stopFasting() {
    _timer?.cancel();
    setState(() {
      _isFasting = false;
    });
  }

  Duration get _targetDuration => Duration(hours: _fastingHours);
  double get _progress => _elapsed.inSeconds / _targetDuration.inSeconds;
  Duration get _remaining => _targetDuration - _elapsed;

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AuraPetTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 顶部
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: AuraPetTheme.softShadow,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: AuraPetTheme.textPrimary,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Intermittent Fasting',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AuraPetTheme.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),

              // 主内容
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 小熊
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _isFasting ? _pulseAnimation.value : 1.0,
                          child: QRaccoonCanvas(
                            size: 150,
                            showHeart: _isFasting,
                            showHeartBubbles: _isFasting,
                            auraScore: _isFasting ? 90 : 60,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    // 16:8 圆环
                    _buildProgressRing(),

                    const SizedBox(height: 24),

                    // 时间显示
                    Text(
                      _formatDuration(_isFasting ? _elapsed : _targetDuration),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: AuraPetTheme.textPrimary,
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _isFasting ? 'Fasting in progress' : '16:8 Fasting Mode',
                      style: TextStyle(
                        fontSize: 16,
                        color: AuraPetTheme.textSecondary,
                      ),
                    ),

                    if (_isFasting && _remaining.inSeconds > 0) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: AuraPetTheme.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              size: 18,
                              color: AuraPetTheme.success,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_remaining.inHours}h ${_remaining.inMinutes.remainder(60)}m remaining',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AuraPetTheme.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 40),

                    // 阶段指示
                    _buildPhaseIndicator(),
                  ],
                ),
              ),

              // 底部按钮
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isFasting ? _stopFasting : _startFasting,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFasting 
                          ? AuraPetTheme.danger 
                          : AuraPetTheme.textPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      _isFasting ? 'End Fast' : 'Start Fasting',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressRing() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 背景圆环
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: AuraPetTheme.softShadow,
            ),
          ),
          
          // 进度圆环
          SizedBox(
            width: 180,
            height: 180,
            child: CircularProgressIndicator(
              value: _isFasting ? _progress.clamp(0.0, 1.0) : 0,
              strokeWidth: 12,
              backgroundColor: AuraPetTheme.surfaceOverlay,
              valueColor: AlwaysStoppedAnimation<Color>(
                _isFasting ? AuraPetTheme.primary : AuraPetTheme.textLight,
              ),
              strokeCap: StrokeCap.round,
            ),
          ),
          
          // 中心内容
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isFasting ? '${(_progress * 100).toInt()}%' : '16:8',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: _isFasting ? AuraPetTheme.primary : AuraPetTheme.textLight,
                ),
              ),
              Text(
                _isFasting ? 'Complete' : 'Fasting',
                style: TextStyle(
                  fontSize: 14,
                  color: AuraPetTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AuraPetTheme.softShadow,
      ),
      child: Row(
        children: [
          // 禁食阶段
          Expanded(
            child: _buildPhaseItem(
              icon: Icons.dark_mode_rounded,
              label: 'Fasting',
              hours: '$_fastingHours hrs',
              isActive: _isFasting,
              color: AuraPetTheme.primary,
            ),
          ),
          
          // 箭头
          Icon(
            Icons.arrow_forward_rounded,
            color: AuraPetTheme.textLight,
          ),
          
          // 进食阶段
          Expanded(
            child: _buildPhaseItem(
              icon: Icons.restaurant_rounded,
              label: 'Eating',
              hours: '$_eatingHours hrs',
              isActive: !_isFasting,
              color: AuraPetTheme.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseItem({
    required IconData icon,
    required String label,
    required String hours,
    required bool isActive,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isActive ? color : color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 22,
            color: isActive ? Colors.white : color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? color : AuraPetTheme.textSecondary,
          ),
        ),
        Text(
          hours,
          style: TextStyle(
            fontSize: 11,
            color: AuraPetTheme.textLight,
          ),
        ),
      ],
    );
  }
}
