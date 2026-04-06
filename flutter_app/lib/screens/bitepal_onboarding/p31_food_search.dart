import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../widgets/furry_trio.dart';

/// P31: AI 智能识图页面 - Qwen-VL 中文食物识别版
/// 兔厨负责扫描交互 + 毛绒质感 + 中文食物专家
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
  
  String _foodName = '红烧肉';
  String _chineseName = '';
  int _calories = 450;
  String _portion = '一人份';
  String _caloriesRange = '400-500kcal';
  String _anxietyLabel = '灵魂充电时间';
  String _bearQuote = '🐰 看起来好好吃呢！';

  late AnimationController _scanController;
  late AnimationController _glowController;
  late Animation<double> _scanAnimation;
  late Animation<double> _glowAnimation;

  // 中文吐槽语料库
  static const List<Map<String, String>> _notFoodBearQuotes = [
    {'emoji': '😓', 'line': '兔兔研究了半天，这个真的不能吃诶...'},
    {'emoji': '🤔', 'line': '这看起来不像食物呢，我们要不拍点真正的晚餐？'},
    {'emoji': '😅', 'line': '兔厨提醒：这个好像不是红烧肉...'},
    {'emoji': '🫤', 'line': '呃...这个不在兔兔的菜单里呢，换个试试？'},
    {'emoji': '🤷', 'line': '兔兔摊手.jpg 让我们拍真正的美食吧！'},
    {'emoji': '🙈', 'line': '兔兔什么都没看到！让我们看看真正的食物吧！'},
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FurryTheme.surface,
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
            color: FurryTheme.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const Spacer(),
        // 兔厨小头像
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: FurryTheme.fluffyShadow,
            ),
            child: Center(
              child: ChefBunny(
                size: 32,
                animate: true,
                excited: true,
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
        borderRadius: BorderRadius.circular(24),
        boxShadow: FurryTheme.softShadow,
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: FurryTheme.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索食物...',
                hintStyle: TextStyle(color: FurryTheme.textMuted),
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
                gradient: FurryColors.warmGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: FurryColors.bearBrown.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChefBunny(size: 28, animate: true, excited: true),
                  const SizedBox(width: 8),
                  const Text(
                    '拍照扫描',
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
            onTap: _startScan,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: FurryTheme.softShadow,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner, color: FurryColors.carrotOrange, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    '扫码识别',
                    style: TextStyle(
                      color: FurryTheme.textPrimary,
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
          '最近记录',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: FurryTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView(
            children: [
              _FoodListItem(name: '红烧肉', calories: 450, time: '12:30'),
              _FoodListItem(name: '麻辣烫', calories: 380, time: '18:45'),
              _FoodListItem(name: '奶茶', calories: 250, time: '15:30'),
              _FoodListItem(name: '小笼包', calories: 280, time: '08:30'),
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
            gradient: FurryColors.warmGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: FurryColors.bearBrown.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ChefBunny(size: 40, animate: true, excited: true),
            ],
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
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 兔厨
            const SizedBox(
              width: 120,
              height: 120,
              child: ChefBunny(
                size: 120,
                animate: true,
                excited: true,
              ),
            ),
            const SizedBox(height: 16),
            // 对话气泡
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: FurryColors.carrotOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '🐰 让我看看主人今天吃了什么好东西？',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: FurryTheme.textPrimary,
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
                      backgroundColor: FurryColors.carrotOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
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
                      foregroundColor: FurryColors.carrotOrange,
                      side: BorderSide(color: FurryColors.carrotOrange),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
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
                style: TextStyle(color: FurryTheme.textMuted),
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
            // 兔厨 + 扫描框
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: FurryColors.carrotOrange.withValues(alpha: _glowAnimation.value * 0.6),
                        blurRadius: 50,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const SizedBox(
                    width: 140,
                    height: 140,
                    child: ChefBunny(
                      size: 140,
                      animate: true,
                      excited: true,
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
                      color: FurryColors.carrotOrange.withValues(alpha: 0.8),
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
                                FurryColors.carrotOrange,
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
              '🐰 兔厨正在分析中...',
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
                color: Colors.white.withValues(alpha: 0.7),
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
      Positioned(
        top: 0,
        left: 0,
        child: _CornerDecoration(isTop: true, isLeft: true),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: _CornerDecoration(isTop: true, isLeft: false),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        child: _CornerDecoration(isTop: false, isLeft: true),
      ),
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
          child: _buildFrostedGlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // AI 标签
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: FurryColors.warmGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, color: Colors.white, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'AI 识别',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: FurryColors.ellPink.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$_anxietyLabel $_anxietyLabel',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: FurryColors.bearBrown,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // 食物名称
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _chineseName.isNotEmpty ? _chineseName : _foodName,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: FurryTheme.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (_chineseName.isNotEmpty)
                      Text(
                        _foodName,
                        style: TextStyle(
                          fontSize: 14,
                          color: FurryTheme.textMuted,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // 热量
                Row(
                  children: [
                    Text(
                      '$_calories',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        color: FurryColors.bearBrown,
                        letterSpacing: -2,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'kcal',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: FurryTheme.textSecondary,
                          ),
                        ),
                        Text(
                          _caloriesRange,
                          style: TextStyle(
                            fontSize: 12,
                            color: FurryTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '($_portion)',
                  style: TextStyle(
                    fontSize: 14,
                    color: FurryTheme.textSecondary,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // 营养素
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NutrientChip(label: '蛋白质', value: '15.0g', color: FurryColors.carrotOrange),
                    _NutrientChip(label: '碳水', value: '20.0g', color: FurryColors.bearMuzzle),
                    _NutrientChip(label: '脂肪', value: '35.0g', color: FurryColors.ellPink),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // 兔厨建议
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: FurryColors.carrotOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const ChefBunny(size: 36, animate: true, excited: true),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _bearQuote,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // 添加按钮
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => setState(() => _showResult = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FurryColors.carrotOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 20),
                        SizedBox(width: 8),
                        Text(
                          '添加到记录',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========== 非食物提示 ==========
  Widget _buildNotFoodOverlay() {
    final quote = _notFoodBearQuotes[Random().nextInt(_notFoodBearQuotes.length)];
    
    return Container(
      color: Colors.black54,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _buildFrostedGlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 兔厨思考表情
                const SizedBox(
                  width: 100,
                  height: 100,
                  child: ChefBunny(
                    size: 100,
                    animate: true,
                    thinking: true,
                  ),
                ),
                const SizedBox(height: 16),
                
                // 拒绝标签
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.block, color: const Color(0xFFF59E0B), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '这不是食物',
                        style: TextStyle(
                          color: const Color(0xFFF59E0B),
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
                    color: FurryColors.carrotOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Text(
                        quote['emoji']!,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          quote['line']!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                // 重新拍摄按钮
                OutlinedButton.icon(
                  onPressed: () => setState(() => _showResult = false),
                  icon: const Icon(Icons.refresh),
                  label: const Text('重新拍摄'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: FurryColors.carrotOrange,
                    side: BorderSide(color: FurryColors.carrotOrange),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrostedGlassCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: child,
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
          top: isTop ? BorderSide(color: FurryColors.carrotOrange, width: 4) : BorderSide.none,
          bottom: !isTop ? BorderSide(color: FurryColors.carrotOrange, width: 4) : BorderSide.none,
          left: isLeft ? BorderSide(color: FurryColors.carrotOrange, width: 4) : BorderSide.none,
          right: !isLeft ? BorderSide(color: FurryColors.carrotOrange, width: 4) : BorderSide.none,
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: FurryTheme.softShadow,
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
                    color: FurryTheme.textPrimary,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: FurryTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: FurryColors.bearBrown.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '$calories kcal',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: FurryColors.bearBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NutrientChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _NutrientChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: FurryTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
