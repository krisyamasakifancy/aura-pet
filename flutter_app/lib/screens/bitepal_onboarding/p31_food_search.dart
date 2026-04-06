import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../widgets/canvas_bear.dart';

/// P31 Food Search - AI Camera Entry Point
/// 🦞 CEO 要求：右下角相机按钮 + 泰迪熊对话 + Gemini AI 识别
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
  String? _selectedImagePath;
  String? _aiFoodName;
  int? _aiCalories;
  double? _aiProtein;
  double? _aiCarbs;
  double? _aiFat;
  String? _anxietyLabel;
  String? _anxietyEmoji;
  
  final ImagePicker _picker = ImagePicker();
  late AnimationController _scanAnimController;
  late Animation<double> _scanAnimation;

  // 项目主色调（棕色）
  static const Color _primaryBrown = Color(0xFF8B7355);
  static const Color _accentGold = Color(0xFFD4A574);

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
  }

  @override
  void dispose() {
    _scanAnimController.dispose();
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

  // ========== Gemini API 调用 ==========
  Future<void> _callGeminiAPI(XFile image) async {
    try {
      // 读取图片并转为 base64
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      // 从环境变量获取 API Key（通过 Flutter Define）
      // 在实际部署时通过 --dart-define=GEMINI_API_KEY=xxx 注入
      const apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
      
      if (apiKey.isEmpty) {
        // 没有 API Key 时使用模拟数据
        await _simulateAIFeedback();
        return;
      }

      // 调用 Gemini Vision API
      final response = await http.post(
        Uri.parse('https://generativelanguage.googleapis.com/v1/models/gemini-pro-vision:generateContent?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{
            'parts': [
              {
                'text': '''分析这张食物图片，返回JSON格式：
                {
                  "food_name": "食物名称",
                  "calories": 估算热量(整数),
                  "protein": 蛋白质(g, 浮点数),
                  "carbs": 碳水化合物(g, 浮点数),
                  "fat": 脂肪(g, 浮点数),
                  "anxiety_label": "去焦虑标签",
                  "anxiety_emoji": "表情符号"
                }
                只返回JSON，不要其他内容。'''
              },
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
          _updateAIResult(
            foodName: result['food_name'] ?? '未知食物',
            calories: (result['calories'] ?? 0).toInt(),
            protein: (result['protein'] ?? 0).toDouble(),
            carbs: (result['carbs'] ?? 0).toDouble(),
            fat: (result['fat'] ?? 0).toDouble(),
            anxietyLabel: result['anxiety_label'] ?? '能量补给',
            anxietyEmoji: result['anxiety_emoji'] ?? '⚡',
          );
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

  // ========== 模拟 AI 反馈（无 API Key 或失败时）==========
  Future<void> _simulateAIFeedback() async {
    // 模拟 AI 识别延迟
    await Future.delayed(const Duration(seconds: 2));
    
    // 随机生成模拟数据
    final foods = [
      {'name': '芝士蛋糕', 'cal': 420, 'protein': 8.5, 'carbs': 45.0, 'fat': 22.0},
      {'name': '水果沙拉', 'cal': 150, 'protein': 2.0, 'carbs': 35.0, 'fat': 1.0},
      {'name': '三明治', 'cal': 320, 'protein': 15.0, 'carbs': 40.0, 'fat': 12.0},
      {'name': '奶茶', 'cal': 280, 'protein': 3.0, 'carbs': 55.0, 'fat': 6.0},
    ];
    
    final food = foods[DateTime.now().second % foods.length];
    
    _updateAIResult(
      foodName: food['name'] as String,
      calories: food['cal'] as int,
      protein: food['protein'] as double,
      carbs: food['carbs'] as double,
      fat: food['fat'] as double,
      anxietyLabel: '灵魂充电时间',
      anxietyEmoji: '⚡',
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
  }) {
    setState(() {
      _isScanning = false;
      _showAIFeedback = true;
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
                    const Expanded(
                      child: Text(
                        'Add Food',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    // 泰迪熊小头像（可点击）
                    GestureDetector(
                      onTap: _showBearDialogPopup,
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: CanvasBear(
                          mood: BearMood.excited,
                          size: 40,
                          animate: true,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // ========== AI 推荐卡片（识别结果显示）==========
                if (_showAIFeedback) _buildAIFeedbackCard(),
                
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

        // ========== 浮动相机按钮（右下角，Z-Index 最高）==========
        // ⚠️ 使用 Stack + Positioned 确保不被遮挡
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
      backgroundColor: _primaryBrown,  // 主棕色
      child: const Icon(
        Icons.camera_alt_rounded,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  // ========== AI 推荐卡片 ==========
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
                      '$_aiCalories kcal',
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
              '🐻 正在分析中...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '让泰迪熊看看你吃了什么好东西',
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
            onTap: () {}, // 防止点击对话框关闭
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
                    child: Text(
                      '🐻 让我看看主人今天吃了什么好东西？',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: _primaryBrown.withOpacity(0.9),
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
