import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class QwenVisionService {
  // ⚠️ 测试用：直接写入 API Key
  // TODO: 正式环境请通过环境变量或 GitHub Secrets 注入
  static const String _testApiKey = 'YOUR_DASHSCOPE_API_KEY_HERE';
  
  final String apiKey;
  
  QwenVisionService({required this.apiKey});
  
  /// 便捷构造函数：直接使用测试 Key
  factory QwenVisionService.withTestKey() {
    return QwenVisionService(apiKey: _testApiKey);
  }
  
  Future<Map<String, dynamic>> recognizeFood(File imageFile) async {
    final url = 'https://dashscope.aliyuncs.com/api/v1/services/aigc/multimodal-generation/generation';
    
    print('========================================');
    print('🔵 QwenVisionService.recognizeFood()');
    print('========================================');
    print('📡 API URL: $url');
    print('🔑 API Key: ${apiKey.substring(0, 10)}...');
    print('📷 图片文件: ${imageFile.path}');
    print('📷 图片大小: ${imageFile.lengthSync()} bytes');
    
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    print('📦 Base64 长度: ${base64Image.length} 字符');
    
    final requestBody = {
      "model": "qwen-vl-max",
      "input": {
        "messages": [
          {
            "role": "user",
            "content": [
              {"image": "data:image/jpeg;base64,$base64Image"},
              {"text": "你是一位中国营养学专家。分析这张食物图片，只返回JSON，不要其他内容：{\"is_food\": true/false, \"name\": \"菜名\", \"cuisine\": \"菜系\", \"calories\": 数字, \"protein\": 数字, \"carbs\": 数字, \"fat\": 数字, \"advice\": \"建议文案\"}如果不是食物，is_food为false，其他字段为空。"}
            ]
          }
        ]
      },
      "parameters": {"temperature": 0.1, "result_format": "message"}
    };
    
    print('📤 发送请求到 Qwen API...');
    
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode(requestBody),
    );
    
    print('========================================');
    print('📥 Qwen API 响应:');
    print('========================================');
    print('Status Code: ${response.statusCode}');
    print('📄 Response Body: ${response.body}');
    print('========================================');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('✅ JSON 解析成功');
      
      String? content;
      try {
        content = data['output']['choices'][0]['message']['content'];
        print('💬 AI 返回的 content: $content');
      } catch (e) {
        print('❌ 提取 content 失败: $e');
        print('📄 完整响应: $data');
      }
      
      if (content != null) {
        print('🔄 解析 content JSON...');
        final result = jsonDecode(content);
        print('✅ 最终解析结果: $result');
        print('========================================');
        return result;
      } else {
        throw Exception('无法从响应中提取 content');
      }
    } else {
      print('❌ API 调用失败: ${response.statusCode}');
      throw Exception('API调用失败: ${response.statusCode}');
    }
  }
}
