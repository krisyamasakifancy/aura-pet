import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../widgets/canvas_bear.dart';

/// P31 Food Search - AI Camera Entry Point
/// 🦞 CEO 要求：右下角相机按钮 + 泰迪熊对话 + Gemini AI 识别
/// 🧠 升级：智能食物判定 + 非食物拒绝 + 体积估算
class P31FoodSearch extends StatefulWidget {
  final VoidCallback onNext;
  
  const P31FoodSearch({super.key, required this.onNext});

  @override
  State<P31FoodSearch> createState() => _P31FoodSearchState();
}

class _P31FoodSearchState extends State<P31FoodSearch> with TickerProviderStateMixin {
  // ========== 状态管理 ==========
  bool _showBearDialog = false;
  bool _isScanning = false;
  bool _showAIFeedback = false;
  bool _isNotFood = false;  // 🆕 非食物标记
  String? _selectedImagePath;
  String? _aiFoodName;
  int? _aiCalories;
  double? _aiProtein;
  double? _aiCarbs;
  double? _aiFat;
  String? _anxietyLabel;
  String? _anxietyEmoji;
  String? _bearComicLine;  // 🆕 泰迪熊吐槽台词
  String? _bearRejectEmoji;  // 🆕 拒绝表情
  
  final ImagePicker _picker = ImagePicker();
  late AnimationController _scanAnimController;
  late Animation<double> _scanAnimation;
  late AnimationController _shakeAnimController;

  // 项目主色调（棕色）
  static const Color _primaryBrown = Color(0xFF8B7355);
  static const Color _accentGold = Color(0xFFD4A574);

  // 🆕 泰迪熊吐槽语料库（非食物时使用）
  static const List<Map<String, String>> _notFoodBearQuotes = [
    {'emoji': '😓', 'line': '主人，这个真的咬不动诶... 🐻'},
    {'emoji': '🤔', 'line': '这看起来不像好吃的，我们要不去拍点真正的晚餐？✨'},
    {'emoji': '😅', 'line': '小浣熊研究了半天，发现这好像不能吃诶...'},
    {'emoji': '🫤', 'line': '呃...这个不在我的食物字典里呢，换个试试？'},
    {'emoji': '🤷', 'line': '摊手.jpg 这个真的帮不了你拍一张美食吧！'},
    {'emoji': '🙈', 'line': '我什么都没看到，让我看看真正的食物吧！'},
  ];

  @override
  void initState() {
    super.initState();
    _scanAnimController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scanAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scanAnimController, curve: Curves.easeInOut),
    );
    
    // 🆕 抖动动画（非食物时使用）
    _shakeAnimController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _scanAnimController.dispose();
    _shakeAnimController.dispose();
    super.dispose();
  }

  // ========== 泰迪熊对话框 ==========
  void _showBearDialogPopup() {
    setState(() => _showBearDialog = true);
  }

  void _dismissBearDialog() {
    setState(() => _showBearDialog = false);
  }

  // ========== 相机/相册选择 ==========
  Future<void> _pickImage(ImageSource source) async {
    try {
      _dismissBearDialog();
      
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return;

      setState(() {
        _selectedImagePath = image.path;
        _isScanning = true;
        _showAIFeedback = false;
        _isNotFood = false;
        _bearComicLine = null;
        _bearRejectEmoji = null;
      });

      // 开始扫描动画
      _scanAnimController.repeat();

      // 调用 Gemini API
      await _callGeminiAPI(image);

    } catch (e) {
      _showErrorSnackBar('无法访问相机/相册: $e');
      setState(() => _isScanning = false);
    }
  }

  // ========== 🧠 升级版 Gemini API 调用 ==========
  Future<void> _callGeminiAPI(XFile image) async {
    try {
      // 读取图片并转为 base64
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      // 从环境变量获取 API Key
      const apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
      
      if (apiKey.isEmpty) {
        // 没有 API Key 时使用模拟数据
        await _simulateAIFeedback();
        return;
      }

      // 🆕 升级版 Prompt：食物判定 + 体积估算
      const enhancedPrompt = '''
【智能食物分析系统 v2.0】

你是一个严格的食物鉴定专家。请严格按以下步骤分析：

## 第一步：食物判定（必须先执行）
仔细分析图片内容，判断是否为"可食用食物"：
- ✅ 可接受：水果、蔬菜、肉类、菜肴、饮品、零食、甜点、面包、米饭、面食等任何可以食用的东西
- ❌ 不可接受：电子产品（电脑、手机、键盘）、家具（桌子、椅子）、人、动物（除非是食物本身如烤鸭）、植物（非食用）、建筑、风景、服装、书籍、化妆品等

## 第二步：响应格式

### 如果是食物：
```json
{
  "is_food": true,
  "food_name": "食物名称",
  "portion_size": "一人份/二人份/多人份/小份/大份",
  "calories": 估算热量(整数),
  "calories_range": "100-200kcal",
  "protein": 蛋白质(g, 浮点数),
  "carbs": 碳水化合物(g, 浮点数),
  "fat": 脂肪(g, 浮点数),
  "anxiety_label": "去焦虑标签",
  "anxiety_emoji": "表情符号",
  "confidence": 0.0-1.0,
  "reasoning": "简要判断依据"
}
```

### 如果不是食物：
```json
{
  "is_food": false,
  "detected_object": "识别到的物体名称",
  "reject_reason": "为什么这不是食物",
  "suggestion": "建议用户拍什么"
}
```

## 重要规则：
1. 必须先判断 is_food，这是最重要的字段
2. 如果不是食物，is_food 必须为 false，禁止返回任何食物数据
3. 如果是食物，必须估算份量（一 人份/二人份/多人份）
4. 热量必须基于份量调整（多人份热量约是单人份的2-3倍）
5. 只返回JSON，不要其他内容
''';

      // 调用 Gemini Vision API
      final response = await http.post(
        Uri.parse('https://generativelanguage.googleapis.com/v1/models/gemini-pro-vision:generateContent?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{
            'parts': [
              {'text': enhancedPrompt},
              {
                'inlineData': {
                  'mimeType': 'image/jpeg',
                  'data': base64Image
                }
              }
            ]
          }]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
        
        // 解析 JSON 响应
        final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(text);
        if (jsonMatch != null) {
          final result = jsonDecode(jsonMatch.group(0)!);
          
          // 🆕 检查是否为食物
          final isFood = result['is_food'] == true;
          
          if (!isFood) {
            // ❌ 非食物：显示吐槽界面
            _handleNotFood(result);
          } else {
            // ✅ 是食物：正常显示识别结果
            _handleFoodResult(result);
          }
        } else {
          await _simulateAIFeedback();
        }
      } else {
        await _simulateAIFeedback();
      }

    } catch (e) {
      // API 调用失败时使用模拟数据
      await _simulateAIFeedback();
    }
  }

  // 🆕 处理非食物结果
  void _handleNotFood(Map<String, dynamic> result) {
    final random = Random();
    final quote = _notFoodBearQuotes[random.nextInt(_notFoodBearQuotes.length)];
    
    setState(() {
      _isScanning = false;
      _showAIFeedback = true;
      _isNotFood = true;
      _bearComicLine = result['suggestion'] ?? quote['line'];
      _bearRejectEmoji = quote['emoji'];
      _aiFoodName = result['detected_object'] ?? '未知物体';
    });
    
    // 播放抖动动画
    _shakeAnimController.forward().then((_) {
      _shakeAnimController.reverse();
    });
  }

  // 🆕 处理食物结果
  void _handleFoodResult(Map<String, dynamic> result) {
    // 计算热量范围
    final calories = result['calories'] ?? 0;
    final portionSize = result['portion_size'] ?? '一人份';
    
    String caloriesRange;
    if (portionSize.contains('多') || portionSize.contains('3') || portionSize.contains('大')) {
      caloriesRange = '${(calories * 0.8).round()}-${(calories * 1.5).round()}kcal';
    } else if (portionSize.contains('二') || portionSize.contains('中')) {
      caloriesRange = '${(calories * 0.6).round()}-${(calories * 1.2).round()}kcal';
    } else {
      caloriesRange = '${(calories * 0.7).round()}-${(calories * 1.3).round()}kcal';
    }
    
    _updateAIResult(
      foodName: result['food_name'] ?? '未知食物',
      calories: calories,
      protein: (result['protein'] ?? 0).toDouble(),
      carbs: (result['carbs'] ?? 0).toDouble(),
      fat: (result['fat'] ?? 0).toDouble(),
      anxietyLabel: result['anxiety_label'] ?? '能量补给',
      anxietyEmoji: result['anxiety_emoji'] ?? '⚡',
      portionSize: portionSize,
      caloriesRange: caloriesRange,
    );
  }

  // ========== 模拟 AI 反馈（无 API Key 或失败时）==========
  Future<void> _simulateAIFeedback() async {
    // 模拟 AI 识别延迟
    await Future.delayed(const Duration(seconds: 2));
    
    // 随机决定是否模拟非食物（10%概率）
    final random = Random();
    if (random.nextInt(10) == 0) {
      // 模拟非食物
      final quote = _notFoodBearQuotes[random.nextInt(_notFoodBearQuotes.length)];
      setState(() {
        _isScanning = false;
        _showAIFeedback = true;
        _isNotFood = true;
        _bearComicLine = quote['line'];
        _bearRejectEmoji = quote['emoji'];
        _aiFoodName = '非食物物体';
      });
      _shakeAnimController.forward().then((_) => _shakeAnimController.reverse());
      return;
    }
    
    // 正常食物数据
    final foods = [
      {'name': '芝士蛋糕', 'cal': 420, 'protein': 8.5, 'carbs': 45.0, 'fat': 22.0, 'portion': '一人份', 'range': '350-500kcal'},
      {'name': '水果沙拉', 'cal': 150, 'protein': 2.0, 'carbs': 35.0, 'fat': 1.0, 'portion': '一人份', 'range': '120-200kcal'},
      {'name': '三明治套餐', 'cal': 450, 'protein': 20.0, 'carbs': 50.0, 'fat': 18.0, 'portion': '二人份', 'range': '400-600kcal'},
      {'name': '珍珠奶茶', 'cal': 280, 'protein': 3.0, 'carbs': 55.0, 'fat': 6.0, 'portion': '一人份', 'range': '250-350kcal'},
    ];
    
    final food = foods[random.nextInt(foods.length)];
    
    _updateAIResult(
      foodName: food['name'] as String,
      calories: food['cal'] as int,
      protein: food['protein'] as double,
      carbs: food['carbs'] as double,
      fat: food['fat'] as double,
      anxietyLabel: '灵魂充电时间',
      anxietyEmoji: '⚡',
      portionSize: food['portion'] as String,
      caloriesRange: food['range'] as String,
    );
  }

  void _updateAIResult({
    required String foodName,
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
    required String anxietyLabel,
    required String anxietyEmoji,
    String? portionSize,
    String? caloriesRange,
  }) {
    setState(() {
      _isScanning = false;
      _showAIFeedback = true;
      _isNotFood = false;
      _aiFoodName = foodName;
      _aiCalories = calories;
      _aiProtein = protein;
      _aiCarbs = carbs;
      _aiFat = fat;
      _anxietyLabel = anxietyLabel;
      _anxietyEmoji = anxietyEmoji;
    });
    _scanAnimController.stop();
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ========== 构建 UI ==========
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ========== 主内容 ==========
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题栏
                Row(
                  children: [
                    IconButton(onPressed: widget.onNext, icon: const Icon(Icons.arrow_back)),
                    Expanded(
                      child: Text(
                        _isNotFood ? '🤷 这不是食物' : 'Add Food',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    // 泰迪熊小头像（可点击）
                    GestureDetector(
                      onTap: _showBearDialogPopup,
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CanvasBear(
                          mood: _isNotFood ? BearMood.thinking : BearMood.excited,
                          size: 40,
                          animate: true,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // ========== 🆕 非食物反馈卡片 ==========
                if (_showAIFeedback && _isNotFood) _buildNotFoodCard(),
                
                // ========== AI 推荐卡片（正常食物）==========
                if (_showAIFeedback && !_isNotFood) _buildAIFeedbackCard(),
                
                // 搜索栏
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey.shade500),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search for food',
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontFamily: 'Inter'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // 快速扫描卡片
                Row(
                  children: [
                    Expanded(
                      child: _ScanCard(
                        icon: Icons.camera_alt,
                        label: 'Quick Scan',
                        color: _primaryBrown,
                        onTap: () => _pickImage(ImageSource.camera),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ScanCard(
                        icon: Icons.photo_library,
                        label: 'From Gallery',
                        color: _accentGold,
                        onTap: () => _pickImage(ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                const Text(
                  'Recent',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                Expanded(
                  child: ListView(
                    children: [
                      _FoodListItem(name: 'Apple', calories: 95, onTap: widget.onNext),
                      _FoodListItem(name: 'Chicken Breast', calories: 165, onTap: widget.onNext),
                      _FoodListItem(name: 'Brown Rice', calories: 215, onTap: widget.onNext),
                      _FoodListItem(name: 'Greek Yogurt', calories: 100, onTap: widget.onNext),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ========== 扫描动画叠加层 ==========
        if (_isScanning) _buildScanningOverlay(),

        // ========== 泰迪熊对话框 ==========
        if (_showBearDialog) _buildBearDialog(),

        // ========== 浮动相机按钮（右下角）==========
        Positioned(
          right: 24,
          bottom: 24,
          child: _buildCameraFAB(),
        ),
      ],
    );
  }

  // ========== 浮动相机按钮 ==========
  Widget _buildCameraFAB() {
    return FloatingActionButton(
      onPressed: _showBearDialogPopup,
      backgroundColor: _primaryBrown,
      child: const Icon(
        Icons.camera_alt_rounded,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  // ========== 🆕 非食物反馈卡片 ==========
  Widget _buildNotFoodCard() {
    return AnimatedBuilder(
      animation: _shakeAnimController,
      builder: (context, child) {
        final shake = sin(_shakeAnimController.value * pi * 4) * 10;
        return Transform.translate(
          offset: Offset(shake, 0),
          child: child,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.orange.shade300,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            // 🆕 流汗/摊手泰迪熊
            const SizedBox(
              width: 100,
              height: 100,
              child: CanvasBear(
                mood: BearMood.thinking,  // 流汗表情
                size: 100,
                animate: true,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // 拒绝标签
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.block, color: Colors.orange.shade700, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '这不是食物',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // 检测到的物体
            Text(
              '检测到: $_aiFoodName',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // 🆕 吐槽台词
            if (_bearComicLine != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(
                      _bearRejectEmoji ?? '🤔',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _bearComicLine!,
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
            
            // 重新拍摄按钮
            OutlinedButton.icon(
              onPressed: _showBearDialogPopup,
              icon: const Icon(Icons.refresh),
              label: const Text('重新拍摄'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _primaryBrown,
                side: BorderSide(color: _primaryBrown),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== AI 推荐卡片（正常食物）==========
  Widget _buildAIFeedbackCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _primaryBrown.withOpacity(0.1),
            _accentGold.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _primaryBrown.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI 识别标签
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _primaryBrown,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'AI 推荐',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // 去焦虑标签
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _accentGold.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_anxietyEmoji $_anxietyLabel',
                  style: TextStyle(
                    color: _primaryBrown.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 食物名称
          Row(
            children: [
              if (_selectedImagePath != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(_selectedImagePath!),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _aiFoodName ?? '',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_aiCalories ?? 0} kcal',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: _primaryBrown,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 营养数据
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NutrientChip(label: '蛋白质', value: '${_aiProtein?.toStringAsFixed(1)}g'),
              _NutrientChip(label: '碳水', value: '${_aiCarbs?.toStringAsFixed(1)}g'),
              _NutrientChip(label: '脂肪', value: '${_aiFat?.toStringAsFixed(1)}g'),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 添加按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryBrown,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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
    );
  }

  // ========== 扫描动画叠加层 ==========
  Widget _buildScanningOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 泰迪熊
            const SizedBox(
              width: 120,
              height: 120,
              child: CanvasBear(
                mood: BearMood.thinking,
                size: 120,
                animate: true,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 扫描框
            AnimatedBuilder(
              animation: _scanAnimation,
              builder: (context, child) {
                return Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _accentGold,
                      width: 3,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // 扫描线
                      Positioned(
                        top: _scanAnimation.value * 180,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                _accentGold,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // 四角装饰
                      ...List.generate(4, (i) {
                        final isTop = i < 2;
                        final isLeft = i % 2 == 0;
                        return Positioned(
                          top: isTop ? 0 : null,
                          bottom: isTop ? null : 0,
                          left: isLeft ? 0 : null,
                          right: isLeft ? null : 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              border: Border(
                                top: isTop ? BorderSide(color: _accentGold, width: 4) : BorderSide.none,
                                bottom: !isTop ? BorderSide(color: _accentGold, width: 4) : BorderSide.none,
                                left: isLeft ? BorderSide(color: _accentGold, width: 4) : BorderSide.none,
                                right: !isLeft ? BorderSide(color: _accentGold, width: 4) : BorderSide.none,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // 提示文字
            const Text(
              '🧠 智能分析中...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '正在识别是否为食物并估算分量',
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

  // ========== 泰迪熊对话框 ==========
  Widget _buildBearDialog() {
    return GestureDetector(
      onTap: _dismissBearDialog,
      child: Container(
        color: Colors.black38,
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(32),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: _primaryBrown.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 泰迪熊
                  const SizedBox(
                    width: 150,
                    height: 150,
                    child: CanvasBear(
                      mood: BearMood.excited,
                      size: 150,
                      animate: true,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 对话气泡
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _primaryBrown.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      '🐻 让我看看主人今天吃了什么好东西？',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 操作按钮
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('拍照'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryBrown,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('相册'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _primaryBrown,
                            side: BorderSide(color: _primaryBrown),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 关闭按钮
                  TextButton(
                    onPressed: _dismissBearDialog,
                    child: Text(
                      '稍后再说',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ========== 小部件 ==========

class _ScanCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  
  const _ScanCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodListItem extends StatelessWidget {
  final String name;
  final int calories;
  final VoidCallback onTap;
  
  const _FoodListItem({
    required this.name,
    required this.calories,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        name,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Text(
        '$calories kcal',
        style: TextStyle(
          fontFamily: 'Inter',
          color: Colors.grey.shade600,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _NutrientChip extends StatelessWidget {
  final String label;
  final String value;
  
  const _NutrientChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
