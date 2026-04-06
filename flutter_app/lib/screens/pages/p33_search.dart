import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../widgets/fancy_design.dart';
import '../../widgets/canvas_bear.dart';

/// P31: AI 智能识图页面
/// 全屏扫描 + 泰迪熊单片眼镜 + 磨砂玻璃识别卡片
class P31FoodSearch extends StatefulWidget {
  const P31FoodSearch({super.key});

  @override
  State<P31FoodSearch> createState() => _P31FoodSearchState();
}

class _P31FoodSearchState extends State<P31FoodSearch>
    with TickerProviderStateMixin {
  bool _showScanAnimation = false;
  bool _showResult = false;
  bool _isNotFood = false;
  
  String _foodName = '芝士蛋糕';
  int _calories = 420;
  String _portion = '一人份';
  String _anxietyLabel = '灵魂充电时间';
  String _bearQuote = '🐻 看起来很美味呢！';

  late AnimationController _scanController;
  late AnimationController _glowController;
  late Animation<double> _scanAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _scanAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _startScan() {
    setState(() {
      _showScanAnimation = true;
      _showResult = false;
      _isNotFood = false;
    });
    _scanController.repeat();
    
    // 模拟 AI 识别 (2秒后显示结果)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _scanController.stop();
        setState(() {
          _showScanAnimation = false;
          _showResult = true;
        });
      }
    });
  }

  void _simulateNonFood() {
    setState(() {
      _showScanAnimation = true;
      _showResult = false;
      _isNotFood = false;
    });
    _scanController.repeat();
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _scanController.stop();
        setState(() {
          _showScanAnimation = false;
          _showResult = true;
          _isNotFood = true;
          _bearQuote = '🤔 主人，这个真的咬不动诶...';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FancyDesign.surfaceLight,
      body: Stack(
        children: [
          // 主内容
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Header
                  _buildHeader(),
                  const SizedBox(height: 24),
                  
                  // 搜索栏
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  
                  // 快速操作
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                  
                  // 最近记录
                  Expanded(
                    child: _buildRecentRecords(),
                  ),
                  
                  // 底部相机按钮
                  _buildCameraFAB(),
                ],
              ),
            ),
          ),
          
          // 全屏扫描动画
          if (_showScanAnimation) _buildScanOverlay(),
          
          // AI 识别结果
          if (_showResult && !_isNotFood) _buildResultOverlay(),
          if (_showResult && _isNotFood) _buildNotFoodOverlay(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Text(
          'Add Food',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: FancyDesign.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const Spacer(),
        // 泰迪熊小头像
        GestureDetector(
          onTap: () {}, // 熊熊互动
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: FancyDesign.shadowCard,
            ),
            child: const Center(
              child: SizedBox(
                width: 32,
                height: 32,
                child: CanvasBear(
                  mood: BearMood.excited,
                  size: 32,
                  animate: true,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: FancyDesign.shadowCard,
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: FancyDesign.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for food',
                hintStyle: TextStyle(color: FancyDesign.textMuted),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _startScan,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: FancyDesign.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: FancyDesign.primaryBrown.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Quick Scan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: _simulateNonFood,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: FancyDesign.shadowCard,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner, color: FancyDesign.accentGold, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Scan Barcode',
                    style: TextStyle(
                      color: FancyDesign.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentRecords() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: FancyDesign.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView(
            children: [
              _FoodListItem(name: 'Apple', calories: 95, time: '08:30'),
              _FoodListItem(name: 'Chicken Breast', calories: 165, time: '12:45'),
              _FoodListItem(name: 'Brown Rice', calories: 215, time: '12:45'),
              _FoodListItem(name: 'Greek Yogurt', calories: 100, time: '15:30'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCameraFAB() {
    return Align(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: () => _showBearDialog(context),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: FancyDesign.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: FancyDesign.primaryBrown.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.camera_alt_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  void _showBearDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 泰迪熊
            const SizedBox(
              width: 120,
              height: 120,
              child: CanvasBear(
                mood: BearMood.excited,
                size: 120,
                animate: true,
              ),
            ),
            const SizedBox(height: 16),
            // 对话气泡
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: FancyDesign.primaryBrown.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                '🐻 让我看看主人今天吃了什么好东西？',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: FancyDesign.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 操作按钮
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _startScan();
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('拍照'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FancyDesign.primaryBrown,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _startScan();
                    },
                    icon: const Icon(Icons.photo_library),
                    label: const Text('相册'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: FancyDesign.primaryBrown,
                      side: BorderSide(color: FancyDesign.primaryBrown),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                '稍后再说',
                style: TextStyle(color: FancyDesign.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== 全屏扫描动画 ==========
  Widget _buildScanOverlay() {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 泰迪熊 + 单片眼镜
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: FancyDesign.accentGold.withOpacity(_glowAnimation.value * 0.6),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const SizedBox(
                    width: 140,
                    height: 140,
                    child: CanvasBear(
                      mood: BearMood.curious, // 单片眼镜效果
                      size: 140,
                      animate: true,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            
            // 全息扫描框
            AnimatedBuilder(
              animation: _scanAnimation,
              builder: (context, child) {
                return Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: FancyDesign.accentGold.withOpacity(0.8),
                      width: 3,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // 四角装饰
                      ..._buildCornerDecorations(),
                      // 扫描线
                      Positioned(
                        top: _scanAnimation.value * 220,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                FancyDesign.accentGold,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: 40),
            
            // 提示文字
            const Text(
              '🧠 智能分析中...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '正在识别食物并估算分量',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCornerDecorations() {
    return [
      // 左上
      Positioned(
        top: 0,
        left: 0,
        child: _CornerDecoration(isTop: true, isLeft: true),
      ),
      // 右上
      Positioned(
        top: 0,
        right: 0,
        child: _CornerDecoration(isTop: true, isLeft: false),
      ),
      // 左下
      Positioned(
        bottom: 0,
        left: 0,
        child: _CornerDecoration(isTop: false, isLeft: true),
      ),
      // 右下
      Positioned(
        bottom: 0,
        right: 0,
        child: _CornerDecoration(isTop: false, isLeft: false),
      ),
    ];
  }

  // ========== AI 识别结果 ==========
  Widget _buildResultOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AIResultCard(
            foodName: _foodName,
            calories: _calories,
            portion: _portion,
            anxietyLabel: _anxietyLabel,
            emoji: '⚡',
            onAdd: () {
              setState(() => _showResult = false);
            },
          ),
        ),
      ),
    );
  }

  // ========== 非食物提示 ==========
  Widget _buildNotFoodOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: FancyDesign.shadowElevated,
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 泰迪熊流汗表情
                const SizedBox(
                  width: 100,
                  height: 100,
                  child: CanvasBear(
                    mood: BearMood.thinking,
                    size: 100,
                    animate: true,
                  ),
                ),
                const SizedBox(height: 16),
                // 拒绝标签
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: FancyDesign.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: FancyDesign.warning.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.block, color: FancyDesign.warning, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '这不是食物',
                        style: TextStyle(
                          color: FancyDesign.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // 吐槽台词
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: FancyDesign.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _bearQuote,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 重新拍摄按钮
                OutlinedButton.icon(
                  onPressed: () => setState(() => _showResult = false),
                  icon: const Icon(Icons.refresh),
                  label: const Text('重新拍摄'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: FancyDesign.primaryBrown,
                    side: BorderSide(color: FancyDesign.primaryBrown),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CornerDecoration extends StatelessWidget {
  final bool isTop;
  final bool isLeft;

  const _CornerDecoration({required this.isTop, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? BorderSide(color: FancyDesign.accentGold, width: 4) : BorderSide.none,
          bottom: !isTop ? BorderSide(color: FancyDesign.accentGold, width: 4) : BorderSide.none,
          left: isLeft ? BorderSide(color: FancyDesign.accentGold, width: 4) : BorderSide.none,
          right: !isLeft ? BorderSide(color: FancyDesign.accentGold, width: 4) : BorderSide.none,
        ),
      ),
    );
  }
}

class _FoodListItem extends StatelessWidget {
  final String name;
  final int calories;
  final String time;

  const _FoodListItem({
    required this.name,
    required this.calories,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: FancyDesign.shadowSubtle,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: FancyDesign.textPrimary,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: FancyDesign.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$calories kcal',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: FancyDesign.primaryBrown,
            ),
          ),
        ],
      ),
    );
  }
}
