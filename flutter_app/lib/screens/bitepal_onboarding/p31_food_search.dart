import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../services/qwen_vision_service.dart';
import '../../widgets/furry_trio.dart';

/// P31: AI 智能识图页面 - 毛绒三友联动版
/// 
/// UI 映射逻辑：
/// - name → Chef Bunny 对话框
/// - calories/protein/carbs/fat → Data Bear 数据板
/// - advice → Cheer Ell 反馈层
/// - is_food = false → 毛绒三友集体困惑动画
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
  
  // ========== 毛绒三友联动数据 ==========
  // Chef Bunny - 负责显示菜品名称
  String _bunnyFoodName = '';
  String _bunnyQuote = '🐰 让我看看这是什么呢~';
  
  // Data Bear - 负责显示营养数据
  int _calories = 0;
  double _protein = 0.0;
  double _carbs = 0.0;
  double _fat = 0.0;
  String _portion = '';
  
  // Cheer Ell - 负责显示营养建议
  String _advice = '';
  bool _showEllCelebrate = false;
  
  // 原始 JSON 用于调试
  String _rawJson = '';
  
  // 动画控制器
  late AnimationController _confusedController;
  late Animation<double> _confusedAnimation;

  @override
  void initState() {
    super.initState();
    
    // 困惑动画
    _confusedController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _confusedAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _confusedController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _confusedController.dispose();
    super.dispose();
  }

  File? _selectedImage;

  void _startScan() async {
    // 选择图片
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    
    _selectedImage = File(image.path);
    
    setState(() {
      _showScanAnimation = true;
      _showResult = false;
      _isNotFood = false;
      _rawJson = '';
    });
    
    // 调用真实的 Qwen Vision API
    try {
      // 从 localStorage 或环境变量获取 API Key
      const apiKey = String.fromEnvironment('DASHSCOPE_API_KEY', defaultValue: '');
      
      if (apiKey.isEmpty) {
        // 从 localStorage 获取
        final savedKey = await _getApiKeyFromStorage();
        if (savedKey == null || savedKey.isEmpty) {
          _showError('API Key 未配置！请先设置 DashScope API Key');
          return;
        }
        await _callQwenApi(savedKey);
      } else {
        await _callQwenApi(apiKey);
      }
    } catch (e) {
      _showError('API 调用失败: $e');
    }
  }
  
  Future<String?> _getApiKeyFromStorage() async {
    try {
      const channel = MethodChannel('aura_pet/storage');
      final result = await channel.invokeMethod<String>('getApiKey');
      return result;
    } catch (e) {
      // 如果没有原生 channel，返回空
      return '';
    }
  }
  
  Future<void> _callQwenApi(String apiKey) async {
    if (_selectedImage == null) return;
    
    final service = QwenVisionService(apiKey: apiKey);
    
    try {
      final result = await service.recognizeFood(_selectedImage!);
      
      // 更新调试面板
      _rawJson = QwenVisionService.lastRawResponse ?? jsonEncode(result);
      
      if (mounted) {
        _updateTrioWithResponse(jsonEncode(result));
        setState(() {
          _showScanAnimation = false;
          _showResult = true;
        });
      }
    } catch (e) {
      if (mounted) {
        _showError('识别失败: $e');
        setState(() {
          _showScanAnimation = false;
        });
      }
    }
  }
  
  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _showScanAnimation = false;
      });
    }
  }

  void _updateTrioWithResponse(String jsonStr) {
    try {
      // 提取 JSON
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(jsonStr);
      if (jsonMatch == null) return;
      
      final data = json.decode(jsonMatch.group(0)!);
      
      // 判定食物
      final isFood = data['is_food'] ?? true;
      
      if (!isFood) {
        // ========== 非食物：毛绒三友集体困惑 ==========
        setState(() {
          _isNotFood = true;
          _bunnyQuote = '😕 哎呀，这好像不是吃的哦？';
          _bunnyFoodName = '无法识别';
          _advice = '请拍摄真正的食物';
          _calories = 0;
          _protein = 0;
          _carbs = 0;
          _fat = 0;
        });
        _confusedController.repeat(reverse: true);
        return;
      }
      
      // ========== 食物：正常联动 ==========
      _confusedController.stop();
      _confusedController.reset();
      
      setState(() {
        // Chef Bunny - 菜品名称 + 语录
        _bunnyFoodName = data['name'] ?? '未知菜品';
        _bunnyQuote = _generateBunnyQuote(data['name'], data['cuisine']);
        
        // Data Bear - 营养数据
        _calories = data['calories'] ?? 0;
        _protein = (data['protein'] ?? 0).toDouble();
        _carbs = (data['carbs'] ?? 0).toDouble();
        _fat = (data['fat'] ?? 0).toDouble();
        _portion = data['portion_estimate'] ?? '';
        
        // Cheer Ell - 营养建议 + 庆祝
        _advice = data['advice'] ?? '营养均衡，健康饮食';
        _showEllCelebrate = true;
      });
    } catch (e) {
      debugPrint('JSON 解析错误: $e');
    }
  }

  String _generateBunnyQuote(String? name, String? cuisine) {
    if (name == null) return '🐰 让我看看这是什么~';
    
    final quotes = [
      '🐰 $_bunnyFoodName！看起来好好吃呢！',
      '🐰 哇！$_bunnyFoodName，兔兔的最爱！',
      '🐰 $_bunnyFoodName 来了，今天要好好享用~',
      '🐰 这个 $_bunnyFoodName 看起来超棒的！',
    ];
    
    return quotes[Random().nextInt(quotes.length)];
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
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                  Expanded(child: _buildRecentRecords()),
                  _buildCameraFAB(),
                ],
              ),
            ),
          ),
          
          // 全屏扫描动画
          if (_showScanAnimation) _buildScanOverlay(),
          
          // ========== 识别结果 ==========
          if (_showResult && !_isNotFood) _buildResultOverlay(),
          if (_showResult && _isNotFood) _buildConfusedOverlay(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Text(
          'AI 营养师',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: FurryTheme.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const Spacer(),
        // 毛绒三友小头像
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
              child: FurryTrioDisplay(
                activeCharacter: FurryTrio.chefBunny,
                onBearTap: () {},
                onBunnyTap: () {},
                onEllTap: () {},
              ),
            ),
          ),
        ),
      ],
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
                gradient: FurryTheme.warmGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: FurryColors.bearBrown.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ChefBunny(size: 28, animate: true, excited: true),
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
            children: const [
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
            gradient: FurryTheme.warmGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: FurryColors.bearBrown.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: ChefBunny(size: 40, animate: true, excited: true),
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
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 毛绒三友
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                ChefBunny(size: 80, animate: true, excited: true),
                DataBear(size: 80, animate: true, celebrate: true),
                CheerEll(size: 80, animate: true, celebrate: true),
              ],
            ),
            const SizedBox(height: 16),
            // 对话气泡
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: FurryColors.carrotOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '🐰 毛绒三友等你来拍照！',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),
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
              child: Text('稍后再说', style: TextStyle(color: FurryTheme.textMuted)),
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
            // 毛绒三友扫描中
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                ChefBunny(size: 80, animate: true, excited: true),
                SizedBox(width: 16),
                DataBear(size: 80, animate: true, celebrate: true),
                SizedBox(width: 16),
                CheerEll(size: 80, animate: true, celebrate: true),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              '🐰 毛绒三友正在分析中...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '识别食物并计算营养成分',
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

  // ========== 识别结果：三友联动 ==========
  Widget _buildResultOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ========== 毛绒三友组合 ==========
              _buildTrioHeader(),
              const SizedBox(height: 24),
              
              // ========== 主结果卡片 ==========
              _buildFrostedGlassCard(
                child: Column(
                  children: [
                    // ========== Chef Bunny - 菜品名称 ==========
                    _buildBunnySection(),
                    
                    const Divider(height: 24),
                    
                    // ========== Data Bear - 营养数据 ==========
                    _buildBearSection(),
                    
                    const Divider(height: 24),
                    
                    // ========== Cheer Ell - 营养建议 ==========
                    _buildEllSection(),
                  ],
                ),
              ),
              
              // ========== 可折叠调试面板 ==========
              _buildDebugPanel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrioHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Chef Bunny
          Column(
            children: [
              const ChefBunny(size: 60, animate: true, excited: true),
              const SizedBox(height: 8),
              Text(
                '🐰 兔厨',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          // Data Bear
          Column(
            children: [
              const DataBear(size: 60, animate: true, celebrate: true),
              const SizedBox(height: 8),
              Text(
                '🐻 熊仔',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          // Cheer Ell
          Column(
            children: [
              CheerEll(
                size: 60,
                animate: true,
                celebrate: _showEllCelebrate,
              ),
              const SizedBox(height: 8),
              Text(
                '🐘 象宝',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ========== Chef Bunny - 菜品名称 + 语录 ==========
  Widget _buildBunnySection() {
    return Column(
      children: [
        // 兔厨头像
        const ChefBunny(size: 80, animate: true, excited: true),
        const SizedBox(height: 12),
        // 菜品名称
        Text(
          _bunnyFoodName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: FurryTheme.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        // 对话气泡
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: FurryColors.carrotOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            _bunnyQuote,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: FurryTheme.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  // ========== Data Bear - 营养数据 ==========
  Widget _buildBearSection() {
    return Column(
      children: [
        // 熊仔头像 + 热量
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const DataBear(size: 60, animate: true, celebrate: true),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        ' kcal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: FurryTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  _portion,
                  style: TextStyle(
                    fontSize: 13,
                    color: FurryTheme.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 营养素卡片
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNutrientCard('蛋白质', '${_protein.toStringAsFixed(1)}g', FurryColors.carrotOrange),
            _buildNutrientCard('碳水', '${_carbs.toStringAsFixed(1)}g', FurryColors.bearMuzzle),
            _buildNutrientCard('脂肪', '${_fat.toStringAsFixed(1)}g', FurryColors.ellPink),
          ],
        ),
      ],
    );
  }

  Widget _buildNutrientCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
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

  // ========== Cheer Ell - 营养建议 ==========
  Widget _buildEllSection() {
    return Column(
      children: [
        // 象宝头像
        CheerEll(
          size: 60,
          animate: true,
          celebrate: _showEllCelebrate,
        ),
        const SizedBox(height: 12),
        // 建议卡片
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF10B981).withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.tips_and_updates,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🐘 象宝建议',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _advice,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: FurryTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ========== 可折叠调试面板 ==========
  Widget _buildDebugPanel() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // 深灰色背景
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF10B981).withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          collapsedIconColor: const Color(0xFF10B981),
          iconColor: const Color(0xFF10B981),
          title: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '🐛 Debug 面板 - 原始 JSON',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          children: [
            // API 配置信息
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📡 API 配置',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Endpoint: dashscope.aliyuncs.com/api/v1/services/aigc/multimodal-generation/generation',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Text(
                    'Model: qwen-vl-max',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Text(
                    'DASHSCOPE_API_KEY: ${_isKeyConfigured ? "✓ 已配置" : "✗ 未配置"}',
                    style: TextStyle(
                      color: _isKeyConfigured ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // 原始 JSON
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '📄 原始 JSON 响应 (Raw Response)',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 200,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _rawJson.isEmpty 
                      ? '// 等待识别结果...'
                      : _formatJson(_rawJson),
                  style: const TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 11,
                    fontFamily: 'monospace',
                    height: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 解析状态
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _rawJson.isNotEmpty ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _rawJson.isNotEmpty 
                      ? '✓ JSON 解析成功'
                      : '⏳ 等待 API 响应',
                  style: TextStyle(
                    color: _rawJson.isNotEmpty ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool get _isKeyConfigured {
    const apiKey = String.fromEnvironment('DASHSCOPE_API_KEY', defaultValue: '');
    return apiKey.isNotEmpty;
  }

  String _formatJson(String jsonStr) {
    try {
      final decoded = json.decode(jsonStr);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (e) {
      return jsonStr;
    }
  }

  // ========== 非食物：毛绒三友集体困惑 ==========
  Widget _buildConfusedOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 毛绒三友集体困惑动画
              AnimatedBuilder(
                animation: _confusedAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_confusedAnimation.value * 0.1),
                    child: Transform.rotate(
                      angle: sin(_confusedAnimation.value * 3.14159) * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          ChefBunny(size: 80, animate: true, thinking: true),
                          SizedBox(width: 16),
                          DataBear(size: 80, animate: true, thinking: true),
                          SizedBox(width: 16),
                          CheerEll(size: 80, animate: true, thinking: true),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              
              // 困惑提示
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      '😕',
                      style: TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '哎呀，这好像不是吃的哦？',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: FurryTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '毛绒三友都困惑了呢~\n请拍摄真正的食物吧！',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: FurryTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: FurryColors.carrotOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const ChefBunny(size: 36, animate: true, thinking: true),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _bunnyQuote,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // 调试面板
              _buildDebugPanel(),
              
              const SizedBox(height: 16),
              
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
    );
  }

  Widget _buildFrostedGlassCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
              color: FurryColors.bearBrown.withOpacity(0.1),
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
