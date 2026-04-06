import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class QwenVisionService {
  final String apiKey;
  
  QwenVisionService({required this.apiKey});
  
  Future<Map<String, dynamic>> recognizeFood(File imageFile) async {
    const url = 'https://dashscope.aliyuncs.com/api/v1/services/aigc/multimodal-generation/generation';
    
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    
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
    
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode(requestBody),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['output']['choices'][0]['message']['content'];
      return jsonDecode(content);
    } else {
      throw Exception('API调用失败: ${response.statusCode}');
    }
  }
}
