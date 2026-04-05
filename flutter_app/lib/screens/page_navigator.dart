import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 横向精准切页系统 - 一页一页"切"出来的仪式感
/// 核心：PageView + 智能导航器 + 空气感转场
class AuraPageNavigator extends StatefulWidget {
  const AuraPageNavigator({super.key});

  @override
  State<AuraPageNavigator> createState() => _AuraPageNavigatorState();
}

class _AuraPageNavigatorState extends State<AuraPageNavigator>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  
  // 总页数
  static const int _totalPages = 8;
  
  // 背景颜色 lerp 过渡
  late AnimationController _bgColorController;
  late Animation<Color?> _bgColorAnimation;
  Color _currentBgColor = const Color(0xFFFFF0F5);
  Color _targetBgColor = const Color(0xFFFFF0F5);
  
  // 底部按钮动画
  late AnimationController _buttonController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _pageController = PageController(
      viewportFraction: 1.0,
      initialPage: 0,
    );
    
    // 背景颜色动画
    _bgColorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _bgColorAnimation = ColorTween(
      begin: _currentBgColor,
      end: _targetBgColor,
    ).animate(CurvedAnimation(
      parent: _bgColorController,
      curve: Curves.easeInOutCubic,
    ));
    
    // 按钮缩放动画
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bgColorController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      HapticFeedback.lightImpact();
      
      // 更新目标背景色
      _currentBgColor = _targetBgColor;
      _targetBgColor = _getPageBgColor(_currentPage + 1);
      
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
      
      setState(() => _currentPage++);
      _bgColorController.forward(from: 0);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      HapticFeedback.lightImpact();
      
      _currentBgColor = _targetBgColor;
      _targetBgColor = _getPageBgColor(_currentPage - 1);
      
      _pageController.previousPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
      
      setState(() => _currentPage--);
      _bgColorController.forward(from: 0);
    }
  }

  Color _getPageBgColor(int page) {
    final colors = [
      const Color(0xFFFFF0F5), // P1: 粉白
      const Color(0xFFE3F2FD), // P5: 淡蓝
      const Color(0xFF1A1A2E), // P6: 深蓝
      const Color(0xFFFFF8F0), // P7: 米黄
      const Color(0xFFFFF5F5), // P8: 浅粉
      const Color(0xFFF5F5F5), // P9: 浅灰
      const Color(0xFFFFF8E1), // P30: 金黄
      const Color(0xFF1A1A2E), // Paywall: 深蓝
    ];
    return colors[page % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgColorAnimation,
        builder: (context, child) {
          return Container(
            duration: const Duration(milliseconds: 600),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _bgColorAnimation.value ?? _currentBgColor,
                  Color.lerp(_bgColorAnimation.value ?? _currentBgColor, 
                      const Color(0xFFC1DDF1), 0.5)!,
                ],
              ),
            ),
            child: Stack(
              children: [
                // 主内容 - PageView
                _buildPageView(),
                
                // 页面指示器
                _buildPageIndicator(),
                
                // 底部智能导航器
                _buildSmartNavigator(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(), // 禁止手动滑动
      onPageChanged: (page) {
        setState(() => _currentPage = page);
      },
      children: [
        // P1: 首页 - 比心小熊
        _P1HomePage(onPetStateChange: _onPetStateChange),
        
        // P5: 喝水 - 潜水模式
        _P5WaterPage(onPetStateChange: _onPetStateChange),
        
        // P6: 禁食 - 睡眠模式
        _P6FastingPage(onPetStateChange: _onPetStateChange),
        
        // P7: 进度 - 折线图
        _P7ProgressPage(onPetStateChange: _onPetStateChange),
        
        // P8: 营养 - 雷达图
        _P8NutritionPage(onPetStateChange: _onPetStateChange),
        
        // P9: 目标 - 滑块
        _P9GoalsPage(onPetStateChange: _onPetStateChange),
        
        // P30: 商店 - 换装
        _P30ShopPage(onPetStateChange: _onPetStateChange),
        
        // Paywall: 订阅
        _PaywallPage(onPetStateChange: _onPetStateChange),
      ],
    );
  }

  String _petState = 'hearting';

  void _onPetStateChange(String state) {
    setState(() => _petState = state);
  }

  Widget _buildPageIndicator() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_totalPages, (index) {
          final isActive = index == _currentPage;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive 
                  ? Colors.white 
                  : Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(4),
              boxShadow: isActive
                  ? [BoxShadow(
                      color: Colors.white.withValues(alpha: 0.5),
                      blurRadius: 8,
                    )]
                  : null,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSmartNavigator() {
    return Positioned(
      left: 24,
      right: 24,
      bottom: MediaQuery.of(context).padding.bottom + 30,
      child: Row(
        children: [
          // 返回按钮 (非首页显示)
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _currentPage > 0 ? 1.0 : 0.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentPage > 0 ? 56 : 0,
              child: _currentPage > 0
                  ? GestureDetector(
                      onTapDown: (_) => _buttonController.forward(),
                      onTapUp: (_) {
                        _buttonController.reverse();
                        _previousPage();
                      },
                      onTapCancel: () => _buttonController.reverse(),
                      child: ScaleTransition(
                        scale: _buttonScaleAnimation,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Color(0xFF636E72),
                            size: 20,
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          
          if (_currentPage > 0) const SizedBox(width: 12),
          
          // 主按钮
          Expanded(
            child: GestureDetector(
              onTapDown: (_) => _buttonController.forward(),
              onTapUp: (_) {
                _buttonController.reverse();
                _nextPage();
              },
              onTapCancel: () => _buttonController.reverse(),
              child: ScaleTransition(
                scale: _buttonScaleAnimation,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _getButtonGradient(),
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: _getButtonColor().withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getButtonEmoji(),
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getButtonText(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      if (_currentPage < _totalPages - 1) ...[
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white70,
                          size: 18,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText() {
    switch (_currentPage) {
      case 0:
        return '开始体验';
      case 1:
        return '记录喝水';
      case 2:
        return '开启禁食';
      case 3:
        return '查看进度';
      case 4:
        return '分析营养';
      case 5:
        return '设置目标';
      case 6:
        return '逛逛商店';
      case 7:
        return '解锁 premium';
      default:
        return '下一步';
    }
  }

  String _getButtonEmoji() {
    switch (_currentPage) {
      case 0:
        return '💕';
      case 1:
        return '💧';
      case 2:
        return '🌙';
      case 3:
        return '📈';
      case 4:
        return '🍎';
      case 5:
        return '🎯';
      case 6:
        return '🛍️';
      case 7:
        return '👑';
      default:
        return '✨';
    }
  }

  Color _getButtonColor() {
    switch (_currentPage) {
      case 0:
        return const Color(0xFFFF8BA0);
      case 1:
        return const Color(0xFF1976D2);
      case 2:
        return const Color(0xFF6C63FF);
      case 3:
        return const Color(0xFFFF8BA0);
      case 4:
        return const Color(0xFFFFB74D);
      case 5:
        return const Color(0xFF9B8FE8);
      case 6:
        return const Color(0xFFFFD700);
      case 7:
        return const Color(0xFF9B59B6);
      default:
        return const Color(0xFF6B9EB8);
    }
  }

  List<Color> _getButtonGradient() {
    switch (_currentPage) {
      case 0:
        return [const Color(0xFFFF8BA0), const Color(0xFFFFB4C4)];
      case 1:
        return [const Color(0xFF1976D2), const Color(0xFF64B5F6)];
      case 2:
        return [const Color(0xFF6C63FF), const Color(0xFF9B8FE8)];
      case 3:
        return [const Color(0xFFFF8BA0), const Color(0xFFFFB74D)];
      case 4:
        return [const Color(0xFFFFB74D), const Color(0xFFFFD700)];
      case 5:
        return [const Color(0xFF9B8FE8), const Color(0xFFBA68C8)];
      case 6:
        return [const Color(0xFFFFD700), const Color(0xFFFFE57F)];
      case 7:
        return [const Color(0xFF9B59B6), const Color(0xFFBA68C8)];
      default:
        return [const Color(0xFF6B9EB8), const Color(0xFF8FBDD3)];
    }
  }
}

/// 通用小熊组件 - 带状态切换动画
class _AnimatedPet extends StatefulWidget {
  final String state; // hearting, diving, sleeping, celebrating
  final double size;
  final VoidCallback? onStateComplete;
  
  const _AnimatedPet({
    required this.state,
    this.size = 120,
    this.onStateComplete,
  });

  @override
  State<_AnimatedPet> createState() => _AnimatedPetState();
}

class _AnimatedPetState extends State<_AnimatedPet>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _stateController;
  late Animation<double> _breathAnimation;
  late Animation<double> _stateAnimation;
  
  String _previousState = '';
  String _currentState = '';

  @override
  void initState() {
    super.initState();
    _currentState = widget.state;
    
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    
    _breathAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
    
    _stateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _stateAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _stateController, curve: Curves.easeOutCubic),
    );
    
    _stateController.forward();
  }

  @override
  void didUpdateWidget(_AnimatedPet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _previousState = _currentState;
      _currentState = widget.state;
      
      // 缩放退出动画
      _stateController.reverse().then((_) {
        // 状态切换后重新进入
        _stateController.forward();
        widget.onStateComplete?.call();
      });
    }
  }

  @override
  void dispose() {
    _breathController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_breathAnimation, _stateAnimation]),
      builder: (context, child) {
        // 状态切换时的缩放
        final scale = _stateAnimation.value < 0.5
            ? 1.0 - _stateAnimation.value * 0.2 // 退出: 1.0 -> 0.9
            : 0.9 + (_stateAnimation.value - 0.5) * 0.2; // 进入: 0.9 -> 1.0
        
        return Transform.scale(
          scale: scale * _breathAnimation.value,
          child: _buildPetByState(),
        );
      },
    );
  }

  Widget _buildPetByState() {
    switch (_currentState) {
      case 'diving':
        return _buildDivingPet();
      case 'sleeping':
        return _buildSleepingPet();
      case 'celebrating':
        return _buildCelebratingPet();
      case 'hearting':
      default:
        return _buildHeartingPet();
    }
  }

  Widget _buildHeartingPet() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 光晕
        Container(
          width: widget.size * 1.2,
          height: widget.size * 1.2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFB5B5).withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
        ),
        // 身体
        Container(
          width: widget.size,
          height: widget.size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFB8C5D0), Color(0xFF8E9EAB)],
            ),
          ),
          child: Stack(
            children: [
              // 脸部
              Positioned(
                top: widget.size * 0.2,
                left: widget.size * 0.12,
                child: Container(
                  width: widget.size * 0.76,
                  height: widget.size * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(widget.size * 0.25),
                      topRight: Radius.circular(widget.size * 0.25),
                      bottomLeft: Radius.circular(widget.size * 0.32),
                      bottomRight: Radius.circular(widget.size * 0.32),
                    ),
                  ),
                ),
              ),
              // 眼睛
              Positioned(
                top: widget.size * 0.32,
                left: widget.size * 0.28,
                child: _buildEye(widget.size * 0.08),
              ),
              Positioned(
                top: widget.size * 0.32,
                right: widget.size * 0.28,
                child: _buildEye(widget.size * 0.08),
              ),
              // 比心
              Positioned(
                bottom: widget.size * 0.12,
                right: widget.size * 0.05,
                child: Container(
                  padding: EdgeInsets.all(widget.size * 0.05),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB5B5),
                    borderRadius: BorderRadius.circular(widget.size * 0.08),
                  ),
                  child: const Text('💕', style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivingPet() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 水波光晕
        Container(
          width: widget.size * 1.2,
          height: widget.size * 1.2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF64B5F6).withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
        ),
        // 身体
        Container(
          width: widget.size,
          height: widget.size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFB8C5D0), Color(0xFF8E9EAB)],
            ),
          ),
          child: Stack(
            children: [
              // 脸部
              Positioned(
                top: widget.size * 0.2,
                left: widget.size * 0.12,
                child: Container(
                  width: widget.size * 0.76,
                  height: widget.size * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(widget.size * 0.25),
                      topRight: Radius.circular(widget.size * 0.25),
                      bottomLeft: Radius.circular(widget.size * 0.32),
                      bottomRight: Radius.circular(widget.size * 0.32),
                    ),
                  ),
                ),
              ),
              // 潜水镜
              Positioned(
                top: widget.size * 0.25,
                left: widget.size * 0.15,
                child: Container(
                  width: widget.size * 0.25,
                  height: widget.size * 0.15,
                  decoration: BoxDecoration(
                    color: const Color(0xFF64B5F6).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(widget.size * 0.05),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
              Positioned(
                top: widget.size * 0.25,
                right: widget.size * 0.15,
                child: Container(
                  width: widget.size * 0.25,
                  height: widget.size * 0.15,
                  decoration: BoxDecoration(
                    color: const Color(0xFF64B5F6).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(widget.size * 0.05),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
              // 泡泡
              Positioned(
                bottom: widget.size * 0.1,
                right: widget.size * 0.05,
                child: const Text('🫧', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSleepingPet() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 月光光晕
        Container(
          width: widget.size * 1.2,
          height: widget.size * 1.2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
        ),
        // 睡帽
        Positioned(
          top: -widget.size * 0.15,
          child: Container(
            padding: EdgeInsets.all(widget.size * 0.05),
            decoration: const BoxDecoration(
              color: Color(0xFF6C63FF),
              shape: BoxShape.circle,
            ),
            child: const Text('⭐', style: TextStyle(fontSize: 16)),
          ),
        ),
        // 身体
        Container(
          width: widget.size,
          height: widget.size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFB8C5D0), Color(0xFF8E9EAB)],
            ),
          ),
          child: Stack(
            children: [
              // 脸部
              Positioned(
                top: widget.size * 0.2,
                left: widget.size * 0.12,
                child: Container(
                  width: widget.size * 0.76,
                  height: widget.size * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(widget.size * 0.25),
                      topRight: Radius.circular(widget.size * 0.25),
                      bottomLeft: Radius.circular(widget.size * 0.32),
                      bottomRight: Radius.circular(widget.size * 0.32),
                    ),
                  ),
                ),
              ),
              // 闭眼
              Positioned(
                top: widget.size * 0.35,
                left: widget.size * 0.3,
                child: Container(
                  width: widget.size * 0.12,
                  height: widget.size * 0.03,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D3436),
                    borderRadius: BorderRadius.circular(widget.size * 0.02),
                  ),
                ),
              ),
              Positioned(
                top: widget.size * 0.35,
                right: widget.size * 0.3,
                child: Container(
                  width: widget.size * 0.12,
                  height: widget.size * 0.03,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D3436),
                    borderRadius: BorderRadius.circular(widget.size * 0.02),
                  ),
                ),
              ),
              // ZZZ
              Positioned(
                top: widget.size * 0.05,
                right: widget.size * 0.15,
                child: const Text('💤', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCelebratingPet() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 金光
        Container(
          width: widget.size * 1.3,
          height: widget.size * 1.3,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD700).withValues(alpha: 0.5),
                blurRadius: 40,
                spreadRadius: 15,
              ),
            ],
          ),
        ),
        // 身体
        Container(
          width: widget.size,
          height: widget.size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFD700), Color(0xFFFFB74D)],
            ),
          ),
          child: Stack(
            children: [
              // 脸部
              Positioned(
                top: widget.size * 0.2,
                left: widget.size * 0.12,
                child: Container(
                  width: widget.size * 0.76,
                  height: widget.size * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(widget.size * 0.25),
                      topRight: Radius.circular(widget.size * 0.25),
                      bottomLeft: Radius.circular(widget.size * 0.32),
                      bottomRight: Radius.circular(widget.size * 0.32),
                    ),
                  ),
                ),
              ),
              // 星星眼
              Positioned(
                top: widget.size * 0.3,
                left: widget.size * 0.28,
                child: const Text('⭐', style: TextStyle(fontSize: 14)),
              ),
              Positioned(
                top: widget.size * 0.3,
                right: widget.size * 0.28,
                child: const Text('⭐', style: TextStyle(fontSize: 14)),
              ),
              // 皇冠
              Positioned(
                top: -widget.size * 0.1,
                left: widget.size * 0.3,
                child: const Text('👑', style: TextStyle(fontSize: 24)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEye(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF2D3436),
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: [
          Positioned(
            top: size * 0.2,
            left: size * 0.2,
            child: Container(
              width: size * 0.4,
              height: size * 0.4,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============ 各个页面组件 ============

class _P1HomePage extends StatelessWidget {
  final Function(String) onPetStateChange;
  const _P1HomePage({required this.onPetStateChange});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '💕',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 24),
            const _AnimatedPet(state: 'hearting', size: 120),
            const SizedBox(height: 24),
            const Text(
              'Welcome Home!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your pet is waiting for you',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF636E72),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _P5WaterPage extends StatelessWidget {
  final Function(String) onPetStateChange;
  const _P5WaterPage({required this.onPetStateChange});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '💧',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 24),
            const _AnimatedPet(state: 'diving', size: 120),
            const SizedBox(height: 24),
            const Text(
              'Stay Hydrated!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Diving mode activated',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF1976D2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _P6FastingPage extends StatelessWidget {
  final Function(String) onPetStateChange;
  const _P6FastingPage({required this.onPetStateChange});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🌙',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 24),
            const _AnimatedPet(state: 'sleeping', size: 120),
            const SizedBox(height: 24),
            const Text(
              'Deep Sleep Mode',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '16:8 Fasting',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _P7ProgressPage extends StatelessWidget {
  final Function(String) onPetStateChange;
  const _P7ProgressPage({required this.onPetStateChange});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '📈',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 24),
            Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFFFF8BA0).withValues(alpha: 0.3), Colors.white],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: CustomPaint(
                painter: _MiniChartPainter(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Weight Progress',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '-20kg achieved!',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF4CAF50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF8BA0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.5,
      size.width * 0.5, size.height * 0.6,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.7,
      size.width, size.height * 0.3,
    );
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _P8NutritionPage extends StatelessWidget {
  final Function(String) onPetStateChange;
  const _P8NutritionPage({required this.onPetStateChange});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🍎',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _AnimatedPet(state: 'hearting', size: 80),
                const SizedBox(width: 16),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFFFB74D), width: 3),
                  ),
                  child: const Center(
                    child: Text('📊', style: TextStyle(fontSize: 32)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Nutrition Balance',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Well Balanced!',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFFFB74D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _P9GoalsPage extends StatelessWidget {
  final Function(String) onPetStateChange;
  const _P9GoalsPage({required this.onPetStateChange});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🎯',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 24),
            const _AnimatedPet(state: 'hearting', size: 100),
            const SizedBox(height: 24),
            Container(
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF9B8FE8).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                widthFactor: 0.65,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF9B8FE8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Set Your Goals',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Slide to adjust',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF636E72),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _P30ShopPage extends StatelessWidget {
  final Function(String) onPetStateChange;
  const _P30ShopPage({required this.onPetStateChange});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🛍️',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 24),
            Stack(
              alignment: Alignment.center,
              children: [
                const _AnimatedPet(state: 'celebrating', size: 100),
                const Positioned(
                  top: -20,
                  child: Text('👑', style: TextStyle(fontSize: 32)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Pet Shop',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Unlock new skins!',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFFFD700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaywallPage extends StatelessWidget {
  final Function(String) onPetStateChange;
  const _PaywallPage({required this.onPetStateChange});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '👑',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 24),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF9B59B6).withValues(alpha: 0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                const _AnimatedPet(state: 'celebrating', size: 120),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Unlock Premium',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Unlock new world',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
