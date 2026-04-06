import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/qwen_vision_service.dart';

/// P31: AI 智能识图页面 - MVP 精简版
class P31FoodSearch extends StatefulWidget {
  const P31FoodSearch({super.key});

  @override
  State<P31FoodSearch> createState() => _P31FoodSearchState();
}

class _P31FoodSearchState extends State<P31FoodSearch> {
  bool _showScanAnimation = false;
  bool _showResult = false;
  String _foodName = '';
  int _calories = 0;
  double _protein = 0;
  double _carbs = 0;
  double _fat = 0;
  String _advice = '';
  String _rawJson = '';
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Stack(
          children: [
            // 主内容
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildCameraButton(),
                  const SizedBox(height: 24),
                  Expanded(child: _buildRecentRecords()),
                ],
              ),
            ),
            // 扫描动画
            if (_showScanAnimation) _buildScanOverlay(),
            // 识别结果
            if (_showResult) _buildResultOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      children: [
        Icon(Icons.restaurant_menu, color: Color(0xFF6B9EB8), size: 32),
        SizedBox(width: 12),
        Text(
          'AI 营养师',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
      ],
    );
  }

  Widget _buildCameraButton() {
    return GestureDetector(
      onTap: _startScan,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6B9EB8), Color(0xFF9ECFW0)],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6B9EB8).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Column(
          children: [
            Icon(Icons.camera_alt, color: Colors.white, size: 64),
            SizedBox(height: 16),
            Text(
              '拍照扫描',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '拍摄食物，自动识别营养成分',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
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
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView(
            children: const [
              ListTile(
                leading: Icon(Icons.restaurant, color: Color(0xFFFFB74D)),
                title: Text('红烧肉'),
                subtitle: Text('12:30'),
                trailing: Text('450 kcal'),
              ),
              ListTile(
                leading: Icon(Icons.restaurant, color: Color(0xFFFFB74D)),
                title: Text('麻辣烫'),
                subtitle: Text('18:45'),
                trailing: Text('380 kcal'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScanOverlay() {
    return Container(
      color: Colors.black87,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF6B9EB8)),
            SizedBox(height: 24),
            Text(
              '正在识别中...',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 结果卡片
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 30,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // 食物名称
                    Text(
                      _foodName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 热量
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$_calories',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFB74D),
                          ),
                        ),
                        const Text(' kcal'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // 营养素
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMacro('蛋白质', '${_protein.toStringAsFixed(1)}g', Colors.red),
                        _buildMacro('碳水', '${_carbs.toStringAsFixed(1)}g', Colors.orange),
                        _buildMacro('脂肪', '${_fat.toStringAsFixed(1)}g', Colors.pink),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // 建议
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _advice,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              // ========== 调试面板（CEO 要求）==========
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.bug_report, color: Colors.green, size: 16),
                        SizedBox(width: 8),
                        Text(
                          '🐛 Debug - Raw JSON Response',
                          style: TextStyle(color: Colors.green, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 200,
                      child: SingleChildScrollView(
                        child: Text(
                          _rawJson.isEmpty ? '// 等待识别...' : _formatJson(_rawJson),
                          style: const TextStyle(
                            color: Colors.green,
                            fontFamily: 'monospace',
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // 关闭按钮
              ElevatedButton(
                onPressed: () => setState(() => _showResult = false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B9EB8),
                ),
                child: const Text('关闭'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacro(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }

  String _formatJson(String jsonStr) {
    try {
      final decoded = json.decode(jsonStr);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (e) {
      return jsonStr;
    }
  }

  void _startScan() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    
    _selectedImage = File(image.path);
    
    setState(() {
      _showScanAnimation = true;
      _showResult = false;
    });
    
    // 调用 Qwen API
    try {
      // 演示模式：模拟返回
      await Future.delayed(const Duration(seconds: 2));
      
      // 模拟识别结果
      setState(() {
        _foodName = '鱼香肉丝';
        _calories = 320;
        _protein = 15.5;
        _carbs = 28.0;
        _fat = 12.5;
        _advice = '这道菜蛋白质丰富，建议搭配蔬菜一起食用';
        _rawJson = '''{
  "is_food": true,
  "name": "鱼香肉丝",
  "cuisine": "川菜",
  "ingredients": ["猪里脊", "木耳", "胡萝卜", "青椒", "豆瓣酱"],
  "portion_estimate": "中份（约200克）",
  "calories": 320,
  "protein": 15.5,
  "carbs": 28.0,
  "fat": 12.5,
  "advice": "这道菜蛋白质丰富，建议搭配蔬菜一起食用"
}''';
        _showScanAnimation = false;
        _showResult = true;
      });
    } catch (e) {
      setState(() {
        _showScanAnimation = false;
      });
    }
  }
}
