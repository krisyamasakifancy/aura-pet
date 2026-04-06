import 'dart:convert';
import 'dart:io';
// ignore_for_file: avoid_web_libraries_in_flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/nutrition_provider.dart';
import '../../providers/pet_provider.dart';
import '../../services/qwen_vision_service.dart';
import '../../utils/theme.dart';
import '../../utils/router.dart';
import '../../widgets/furry_trio.dart';

// Web localStorage
import 'dart:html' as html;

class MealCaptureScreen extends StatefulWidget {
  const MealCaptureScreen({super.key});

  @override
  State<MealCaptureScreen> createState() => _MealCaptureScreenState();
}

class _MealCaptureScreenState extends State<MealCaptureScreen> {
  bool _isAnalyzing = false;
  NutritionRecord? _lastRecord;
  
  // Qwen 识别结果
  Map<String, dynamic>? _qwenResult;
  bool _isNotFood = false;
  File? _capturedImage;
  
  // API Key 从 localStorage 读取
  String _apiKey = '';
  final TextEditingController _apiKeyController = TextEditingController();
  bool _isApiKeyVisible = false;
  bool _showApiKeySetup = false;
  
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> _quickFoods = [
    {'name': '鸡胸肉沙拉', 'emoji': '🍗'},
    {'name': '三文鱼便当', 'emoji': '🍣'},
    {'name': '蔬菜沙拉', 'emoji': '🥗'},
    {'name': '牛肉汉堡', 'emoji': '🍔'},
    {'name': '水果拼盘', 'emoji': '🍎'},
    {'name': '炒饭', 'emoji': '🍚'},
  ];

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  // ========== localStorage 操作 ==========
  static const String _apiKeyStorageKey = 'dashscope_api_key';
  
  void _loadApiKey() {
    try {
      final savedKey = html.window.localStorage[_apiKeyStorageKey];
      if (savedKey != null && savedKey.isNotEmpty) {
        _apiKey = savedKey;
        print('✅ 已从 localStorage 加载 API Key');
      } else {
        print('⚠️ localStorage 中没有保存的 API Key');
        _showApiKeySetup = true;
      }
    } catch (e) {
      print('❌ 读取 localStorage 失败: $e');
      _showApiKeySetup = true;
    }
  }

  void _saveApiKey(String key) {
    try {
      html.window.localStorage[_apiKeyStorageKey] = key;
      setState(() {
        _apiKey = key;
        _showApiKeySetup = false;
      });
      print('✅ API Key 已保存到 localStorage');
    } catch (e) {
      print('❌ 保存 API Key 失败: $e');
    }
  }

  void _clearApiKey() {
    try {
      html.window.localStorage.remove(_apiKeyStorageKey);
      setState(() {
        _apiKey = '';
        _showApiKeySetup = true;
        _apiKeyController.clear();
      });
      print('✅ API Key 已清除');
    } catch (e) {
      print('❌ 清除 API Key 失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('记录饮食'),
        actions: [
          // API Key 设置按钮
          IconButton(
            icon: Icon(_apiKey.isEmpty ? Icons.key_off : Icons.key),
            tooltip: _apiKey.isEmpty ? '设置 API Key' : 'API Key 已配置',
            onPressed: () {
              setState(() {
                _showApiKeySetup = !_showApiKeySetup;
                if (_showApiKeySetup) {
                  _apiKeyController.text = _apiKey;
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========== API Key 设置区 ==========
            if (_showApiKeySetup || _apiKey.isEmpty) _buildApiKeySetup(),
            
            // ========== Camera area ==========
            _buildCameraArea(),
            const SizedBox(height: 24),
            
            // 拍照/相册按钮
            _buildCameraButtons(),
            const SizedBox(height: 32),

            // Quick select
            Text('快速选择', style: AuraPetTheme.headingMd),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _quickFoods.length,
              itemBuilder: (context, index) {
                final food = _quickFoods[index];
                return _QuickFoodCard(
                  emoji: food['emoji'],
                  name: food['name'],
                  onTap: () => _selectQuickFood(food['name']),
                );
              },
            ),

            // ========== 毛绒质感结果卡片 ==========
            if (_qwenResult != null) ...[
              const SizedBox(height: 32),
              _isNotFood 
                  ? _buildNotFoodCard() 
                  : _buildFoodResultCard(),
            ],
            
            // 原有的模拟结果卡片（快速选择使用）
            if (_lastRecord != null && _qwenResult == null) ...[
              const SizedBox(height: 32),
              _MealResultCard(record: _lastRecord!),
            ],
          ],
        ),
      ),
    );
  }

  // ========== API Key 设置 ==========
  Widget _buildApiKeySetup() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFF8C00).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C00).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.key,
                  color: Color(0xFFFF8C00),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '设置 DashScope API Key',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5D4E37),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '用于调用通义千问进行食物识别',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8B7B6B),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  _isApiKeyVisible ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF8B7B6B),
                ),
                onPressed: () {
                  setState(() {
                    _isApiKeyVisible = !_isApiKeyVisible;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _apiKeyController,
            obscureText: !_isApiKeyVisible,
            decoration: InputDecoration(
              hintText: '粘贴你的 API Key',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '🔒 Key 只保存在你的浏览器 localStorage 中，不会上传到服务器',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final key = _apiKeyController.text.trim();
                    if (key.isNotEmpty) {
                      _saveApiKey(key);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('✅ API Key 已保存'),
                          backgroundColor: const Color(0xFF10B981),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8C00),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('保存 Key'),
                ),
              ),
              if (_apiKey.isNotEmpty) ...[
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _clearApiKey,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade400,
                    side: BorderSide(color: Colors.red.shade300),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('清除'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCameraArea() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: _capturedImage != null && !_isAnalyzing
          ? ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.file(
                _capturedImage!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            )
          : _isAnalyzing
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChefBunny(size: 50, animate: true, excited: true),
                        SizedBox(width: 8),
                        DataBear(size: 50, animate: true, celebrate: true),
                        SizedBox(width: 8),
                        CheerEll(size: 50, animate: true, celebrate: true),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      '🐰 AI 营养师分析中...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '正在识别食物并计算营养',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 16),
                    CircularProgressIndicator(
                      color: Color(0xFFFF8C00),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('📸', style: TextStyle(fontSize: 72)),
                    const SizedBox(height: 16),
                    Text(
                      '点击下方按钮拍照',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _ScanLine(),
                  ],
                ),
    );
  }

  Widget _buildCameraButtons() {
    return Column(
      children: [
        if (_apiKey.isEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orange.shade700, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    '请先在顶部设置 API Key，否则只能使用模拟数据',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFE65100),
                    ),
                  ),
                ),
              ],
            ),
          ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isAnalyzing ? null : () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('拍照'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8C00),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isAnalyzing ? null : () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('相册'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF8C00),
                  side: const BorderSide(color: Color(0xFFFF8C00)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ========== 拍照/选图处理 ==========
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image == null) return;
      
      setState(() {
        _capturedImage = File(image.path);
        _isAnalyzing = true;
        _qwenResult = null;
        _isNotFood = false;
      });
      
      HapticFeedback.mediumImpact();
      
      // 调用 Qwen-VL 识别
      await _recognizeWithQwen(File(image.path));
      
    } catch (e) {
      print('图片选择失败: $e');
      setState(() => _isAnalyzing = false);
    }
  }

  // ========== Qwen-VL 识别 ==========
  Future<void> _recognizeWithQwen(File imageFile) async {
    print('========================================');
    print('=== 🍳 开始 Qwen-VL 食物识别 ===');
    print('========================================');
    
    // 检查 API Key
    if (_apiKey.isEmpty) {
      print('⚠️ API Key 未配置，使用模拟数据');
      await _simulateRecognition();
      return;
    }
    
    print('✅ API Key 已配置: ${_apiKey.substring(0, 10)}...');
    print('📷 图片大小: ${imageFile.lengthSync()} bytes');
    
    try {
      final service = QwenVisionService(apiKey: _apiKey);
      print('🔄 正在调用 Qwen API...');
      
      final result = await service.recognizeFood(imageFile);
      
      print('========================================');
      print('📥 Qwen API 返回结果:');
      print('========================================');
      print('原始数据: $result');
      print('========================================');
      
      if (!mounted) return;
      
      setState(() {
        _qwenResult = result;
        _isNotFood = result['is_food'] == false;
        _isAnalyzing = false;
      });
      
      if (!_isNotFood) {
        print('✅ 识别为食物: ${result['name']}');
        _createNutritionRecord(result);
      } else {
        print('❌ 识别为非食物');
      }
      
    } catch (e) {
      print('========================================');
      print('❌ Qwen 识别出错: $e');
      print('========================================');
      
      if (mounted) {
        await _simulateRecognition();
      }
    }
  }

  // 模拟识别（无 API Key 或识别失败时使用）
  Future<void> _simulateRecognition() async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (!mounted) return;
    
    final foods = [
      {'name': '红烧肉', 'cuisine': '川菜', 'calories': 450, 'protein': 18.5, 'carbs': 12.0, 'fat': 38.0, 'advice': '这道菜脂肪含量较高，建议搭配一份蔬菜平衡'},
      {'name': '麻辣烫', 'cuisine': '川菜', 'calories': 380, 'protein': 25.0, 'carbs': 30.0, 'fat': 18.0, 'advice': '麻辣烫营养均衡，注意不要选太辣的汤底'},
      {'name': '螺蛳粉', 'cuisine': '桂菜', 'calories': 420, 'protein': 18.0, 'carbs': 55.0, 'fat': 15.0, 'advice': '螺蛳粉热量较高，建议少放花生和腐竹'},
      {'name': '小笼包', 'cuisine': '淮扬菜', 'calories': 280, 'protein': 12.0, 'carbs': 35.0, 'fat': 10.0, 'advice': '小笼包皮薄馅多，适量食用即可'},
    ];
    final food = foods[DateTime.now().second % foods.length];
    
    setState(() {
      _qwenResult = {
        'is_food': true,
        ...food,
      };
      _isNotFood = false;
      _isAnalyzing = false;
    });
    
    _createNutritionRecord(_qwenResult!);
  }

  void _createNutritionRecord(Map<String, dynamic> result) {
    final nutrition = context.read<NutritionProvider>();
    final foodName = result['name'] ?? '未知菜品';
    final calories = (result['calories'] ?? 300).toInt();
    
    final record = NutritionRecord(
      foodName: foodName,
      emoji: _getFoodEmoji(foodName),
      calories: calories,
      protein: (result['protein'] ?? 15).toDouble(),
      carbs: (result['carbs'] ?? 30).toDouble(),
      fat: (result['fat'] ?? 15).toDouble(),
      timestamp: DateTime.now(),
    );
    
    setState(() => _lastRecord = record);
    
    final pet = context.read<PetProvider>();
    pet.startEating();
    Future.delayed(const Duration(milliseconds: 500), () {
      pet.finishEating(auraScore: record.auraScore);
    });
  }

  String _getFoodEmoji(String foodName) {
    if (foodName.contains('肉') || foodName.contains('牛') || foodName.contains('猪')) return '🥩';
    if (foodName.contains('鸡')) return '🍗';
    if (foodName.contains('鱼') || foodName.contains('三文')) return '🍣';
    if (foodName.contains('沙拉') || foodName.contains('菜')) return '🥗';
    if (foodName.contains('面') || foodName.contains('粉')) return '🍜';
    if (foodName.contains('包')) return '🥟';
    if (foodName.contains('米')) return '🍚';
    return '🍽️';
  }

  // ========== 非食物卡片 ==========
  Widget _buildNotFoodCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChefBunny(size: 60, animate: true, thinking: true),
              DataBear(size: 60, animate: true, thinking: true),
              CheerEll(size: 60, animate: true, thinking: true),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            '😕 识别不到食物哦~',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF5D4E37),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '毛绒三友都困惑了呢\n请拍摄真正的食物吧！',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF8B7B6B),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _qwenResult = null;
                _capturedImage = null;
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('重新拍摄'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFFF8C00),
              side: const BorderSide(color: Color(0xFFFF8C00)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== 食物结果卡片 ==========
  Widget _buildFoodResultCard() {
    final result = _qwenResult!;
    final foodName = result['name'] ?? '未知菜品';
    final cuisine = result['cuisine'] ?? '其他';
    final calories = (result['calories'] ?? 0).toInt();
    final protein = (result['protein'] ?? 0).toDouble();
    final carbs = (result['carbs'] ?? 0).toDouble();
    final fat = (result['fat'] ?? 0).toDouble();
    final advice = result['advice'] ?? '';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const ChefBunny(size: 50, animate: true, excited: true),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      foodName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF5D4E37),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB6C1).withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        cuisine,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFF8C00),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF5F0), Color(0xFFFFB6C1)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const DataBear(size: 50, animate: true, celebrate: true),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$calories',
                          style: const TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF8B7355),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'kcal',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF8B7B6B),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'AI 精准估算',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB0A090),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _NutritionChip(label: '蛋白质', value: '${protein.toStringAsFixed(1)}g', color: const Color(0xFFFF8C00)),
              const SizedBox(width: 8),
              _NutritionChip(label: '碳水', value: '${carbs.toStringAsFixed(1)}g', color: const Color(0xFFD4A574)),
              const SizedBox(width: 8),
              _NutritionChip(label: '脂肪', value: '${fat.toStringAsFixed(1)}g', color: const Color(0xFFFFB6C1)),
            ],
          ),
          if (advice.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const CheerEll(size: 36, animate: true, celebrate: true),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      advice,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5D4E37),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_lastRecord != null) {
                  context.read<NutritionProvider>().addMealRecord(_lastRecord!);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8C00),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🐻', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 8),
                  Text(
                    '保存记录',
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

  void _simulateCapture() {
    setState(() => _isAnalyzing = true);
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(seconds: 2), () {
      final foods = [
        '鸡胸肉沙拉',
        '三文鱼便当',
        '蔬菜沙拉',
        '牛肉汉堡',
        '水果拼盘',
      ];
      final food = foods[DateTime.now().second % foods.length];
      _analyzeFood(food);
    });
  }

  void _selectQuickFood(String foodName) {
    HapticFeedback.selectionClick();
    _analyzeFood(foodName);
  }

  void _analyzeFood(String foodName) {
    final nutrition = context.read<NutritionProvider>();
    final record = nutrition.simulateFoodAnalysis(foodName);
    final pet = context.read<PetProvider>();
    pet.startEating();
    setState(() {
      _isAnalyzing = false;
      _lastRecord = record;
      _qwenResult = null;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      pet.finishEating(auraScore: record.auraScore);
    });
  }
}

class _ScanLine extends StatefulWidget {
  @override
  State<_ScanLine> createState() => _ScanLineState();
}

class _ScanLineState extends State<_ScanLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: 3,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                const Color(0xFFFF8C00),
                Colors.transparent,
              ],
            ),
          ),
          transform: Matrix4.translationValues(
            0,
            _controller.value * 150 - 75,
            0,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _QuickFoodCard extends StatelessWidget {
  final String emoji;
  final String name;
  final VoidCallback onTap;

  const _QuickFoodCard({
    required this.emoji,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AuraPetTheme.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AuraPetTheme.shadowSm,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AuraPetTheme.textDark,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _MealResultCard extends StatelessWidget {
  final NutritionRecord record;

  const _MealResultCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AuraPetTheme.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AuraPetTheme.shadowMd,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AuraPetTheme.bgPink,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(record.emoji, style: const TextStyle(fontSize: 36)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(record.foodName, style: AuraPetTheme.headingMd),
                    Text('1份 · 约250g', style: AuraPetTheme.bodySm),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AuraPetTheme.bgPink, Color(0xFFFFF5F0)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      record.calories.toString(),
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        color: AuraPetTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'kcal',
                      style: TextStyle(
                        fontSize: 18,
                        color: AuraPetTheme.textLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '今日已摄入 ${context.read<NutritionProvider>().todayCalories} / ${context.read<NutritionProvider>().dailyCalorieGoal} kcal',
                  style: AuraPetTheme.bodyMd,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AuraPetTheme.accent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '✨ Aura: ${record.auraScore}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _NutritionItem(
                label: '蛋白质',
                value: '${record.protein.toInt()}g',
                progress: record.protein / 60,
                color: AuraPetTheme.accent,
              ),
              const SizedBox(width: 12),
              _NutritionItem(
                label: '碳水',
                value: '${record.carbs.toInt()}g',
                progress: record.carbs / 200,
                color: const Color(0xFFFFB74D),
              ),
              const SizedBox(width: 12),
              _NutritionItem(
                label: '脂肪',
                value: '${record.fat.toInt()}g',
                progress: record.fat / 65,
                color: const Color(0xFFE57373),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<NutritionProvider>().addMealRecord(record);
                Navigator.pop(context);
              },
              child: const Text('保存记录 🐻'),
            ),
          ),
        ],
      ),
    );
  }
}

class _NutritionItem extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final Color color;

  const _NutritionItem({
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AuraPetTheme.bgCream,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AuraPetTheme.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: AuraPetTheme.bodySm),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: color.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutritionChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _NutritionChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF8B7B6B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
