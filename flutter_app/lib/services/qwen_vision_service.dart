import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// CEO 指定营养师 Prompt（一字不差）
const String _NUTRITIONIST_PROMPT = '''你是一位拥有10年经验的中国注册营养师，精通川鲁粤淮扬等所有菜系。

分析这张图片，严格按以下 JSON 格式返回，不要输出任何其他内容：

{
"is_food": true/false,
"name": "菜品的准确名称",
"cuisine": "菜系",
"ingredients": ["主要食材1", "食材2"],
"portion_estimate": "分量估算",
"calories": 数字,
"protein": 数字,
"carbs": 数字,
"fat": 数字,
"advice": "一句具体的营养建议"
}''';

class QwenVisionService {
  /// 从编译时环境变量获取 API Key
  static String get _envApiKey {
    final key = const String.fromEnvironment('DASHSCOPE_API_KEY', defaultValue: '');
    if (key.isEmpty) {
      print('🚨 CRITICAL ERROR: API KEY NOT MAPPED');
      print('🚨 DASHSCOPE_API_KEY 未通过 --dart-define 注入');
      print('🚨 请检查 GitHub Secrets 和 workflow 配置');
    }
    return key;
  }
  
  final String apiKey;
  
  /// 存储最后一次 API 响应（供调试面板使用）
  static String? lastRawResponse;
  static Map<String, dynamic>? lastParsedResponse;
  
  QwenVisionService({required this.apiKey});
  
  /// 使用环境变量 API Key
  factory QwenVisionService.withEnvKey() {
    return QwenVisionService(apiKey: _envApiKey);
  }
  
  Future<Map<String, dynamic>> recognizeFood(File imageFile) async {
    final url = 'https://dashscope.aliyuncs.com/api/v1/services/aigc/multimodal-generation/generation';
    
    print('========================================');
    print('🔵 QwenVisionService.recognizeFood()');
    print('========================================');
    print('📡 API URL: $url');
    print('🔑 API Key: ${apiKey.isNotEmpty ? apiKey.substring(0, 10) + '...' : "EMPTY"}');
    print('📷 图片文件: ${imageFile.path}');
    print('📷 图片大小: ${imageFile.lengthSync()} bytes');
    
    if (apiKey.isEmpty) {
      print('🚨 CRITICAL ERROR: API KEY NOT MAPPED');
      throw Exception('CRITICAL ERROR: API KEY NOT MAPPED');
    }
    
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    print('📦 Base64 长度: ${base64Image.length} 字符');
    
    /// CEO 指定营养师 Prompt
    final requestBody = {
      "model": "qwen-vl-max",
      "input": {
        "messages": [
          {
            "role": "user",
            "content": [
              {"image": "data:image/jpeg;base64,$base64Image"},
              {"text": _NUTRITIONIST_PROMPT}
            ]
          }
        ]
      },
      "parameters": {"temperature": 0.1, "result_format": "message"}
    };
    
    // 打印原始请求体（调试用）
    final requestJson = jsonEncode(requestBody);
    print('📤 发送请求到 Qwen API...');
    print('📋 Request Body: $requestJson');
    
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: requestJson,
    );
    
    // 保存原始响应（供调试面板使用）
    lastRawResponse = response.body;
    
    print('========================================');
    print('📥 Qwen API 响应:');
    print('========================================');
    print('Status Code: ${response.statusCode}');
    print('📄 Raw Response: ${response.body}');
    print('========================================');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('✅ JSON 解析成功');
      print('📊 Full Response Data: $data');
      
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
        lastParsedResponse = result;
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
  
  /// 获取原始响应（供调试面板调用）
  static String getDebugRawResponse() {
    return lastRawResponse ?? '{"error": "No response yet"}';
  }
  
  /// 获取解析后响应（供调试面板调用）
  static Map<String, dynamic> getDebugParsedResponse() {
    return lastParsedResponse ?? {"error": "No parsed response"};
  }
}
