import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/pet_state.dart';

/// ============================================
// AURA-PET: Quad-Agent API 服务
// WebSocket 实时通信
/// ============================================

class AuraPetApiService {
  static const String baseUrl = 'http://localhost:8000';
  static const String wsUrl = 'ws://localhost:8000/ws';
  
  WebSocket? _ws;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  bool _isConnected = false;

  Stream<Map<String, dynamic>> get messages => _messageController.stream;
  bool get isConnected => _isConnected;

  /// 连接 WebSocket
  Future<void> connect() async {
    try {
      _ws = await WebSocket.connect(wsUrl);
      _isConnected = true;
      
      _ws!.listen(
        (data) {
          final message = jsonDecode(data);
          _messageController.add(message);
        },
        onError: (error) {
          debugPrint('WebSocket Error: $error');
          _isConnected = false;
          _reconnect();
        },
        onDone: () {
          _isConnected = false;
          _reconnect();
        },
      );
      
      debugPrint('WebSocket Connected');
    } catch (e) {
      debugPrint('Connection Error: $e');
      _isConnected = false;
    }
  }

  void _reconnect() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!_isConnected) {
        connect();
      }
    });
  }

  /// 断开连接
  void disconnect() {
    _ws?.close();
    _isConnected = false;
  }

  /// ============================================
  /// Quad-Agent: 拍照分析食物
  /// ============================================
  Future<MealAnalysisResult> analyzeMeal(String imageBase64) async {
    try {
      final response = await post('/api/v1/meal/analyze', {
        'image': imageBase64,
      });
      return MealAnalysisResult.fromJson(response);
    } catch (e) {
      debugPrint('Meal Analysis Error: $e');
      // 离线模式：返回随机结果
      return _generateOfflineMealResult();
    }
  }

  /// ============================================
  /// 记录餐食
  /// ============================================
  Future<PetState> recordMeal(MealRecord meal) async {
    try {
      final response = await post('/api/v1/pet/feed', meal.toJson());
      return PetState.fromJson(response);
    } catch (e) {
      debugPrint('Record Meal Error: $e');
      throw e;
    }
  }

  /// ============================================
  /// 获取宠物状态
  /// ============================================
  Future<PetState> getPetState() async {
    try {
      final response = await get('/api/v1/pet/state');
      return PetState.fromJson(response);
    } catch (e) {
      debugPrint('Get Pet State Error: $e');
      // 返回默认状态
      return PetState();
    }
  }

  /// ============================================
  /// 添加金币
  /// ============================================
  Future<int> addCoins(int amount) async {
    try {
      final response = await post('/api/v1/pet/coins', {'amount': amount});
      return response['coins'];
    } catch (e) {
      debugPrint('Add Coins Error: $e');
      throw e;
    }
  }

  /// ============================================
  /// 喝水记录
  /// ============================================
  Future<PetState> addWater(int amount) async {
    try {
      final response = await post('/api/v1/pet/water', {'amount': amount});
      return PetState.fromJson(response);
    } catch (e) {
      debugPrint('Add Water Error: $e');
      throw e;
    }
  }

  /// ============================================
  /// 获取商店物品
  /// ============================================
  Future<List<ShopItem>> getShopItems() async {
    try {
      final response = await get('/api/v1/shop/items');
      return (response['items'] as List)
          .map((item) => ShopItem(
                id: item['id'],
                name: item['name'],
                emoji: item['emoji'],
                category: item['category'],
                price: item['price'],
                description: item['description'],
                isOwned: item['isOwned'] ?? false,
                isEquipped: item['isEquipped'] ?? false,
              ))
          .toList();
    } catch (e) {
      debugPrint('Get Shop Items Error: $e');
      return _getOfflineShopItems();
    }
  }

  /// ============================================
  /// 购买物品
  /// ============================================
  Future<bool> purchaseItem(String itemId) async {
    try {
      await post('/api/v1/shop/purchase', {'itemId': itemId});
      return true;
    } catch (e) {
      debugPrint('Purchase Item Error: $e');
      return false;
    }
  }

  /// ============================================
  /// 装备物品
  /// ============================================
  Future<bool> equipItem(String itemId) async {
    try {
      await post('/api/v1/shop/equip', {'itemId': itemId});
      return true;
    } catch (e) {
      debugPrint('Equip Item Error: $e');
      return false;
    }
  }

  // ========== HTTP 助手 ==========

  Future<Map<String, dynamic>> get(String path) async {
    final response = await httpGet('$baseUrl$path');
    return jsonDecode(response);
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final response = await httpPost('$baseUrl$path', body);
    return jsonDecode(response);
  }

  Future<String> httpGet(String url) async {
    // 简化实现，实际使用 http 包
    throw UnimplementedError('Use http package');
  }

  Future<String> httpPost(String url, Map<String, dynamic> body) async {
    // 简化实现，实际使用 http 包
    throw UnimplementedError('Use http package');
  }

  // ========== 离线模式 ==========

  MealAnalysisResult _generateOfflineMealResult() {
    final foods = [
      {'emoji': '🍰', 'name': '芝士蛋糕', 'cal': 420, 'label': '灵魂充电时间 ⚡'},
      {'emoji': '🍕', 'name': '披萨', 'cal': 680, 'label': '尊享犒劳时刻 👑'},
      {'emoji': '🥗', 'name': '蔬菜沙拉', 'cal': 180, 'label': '绿色能量满格 🌿'},
      {'emoji': '🍗', 'name': '炸鸡', 'cal': 620, 'label': '快乐炸裂 ✨'},
      {'emoji': '🧋', 'name': '奶茶', 'cal': 350, 'label': '快乐肥宅水 🥤'},
    ];
    
    final food = foods[DateTime.now().millisecond % foods.length];
    
    return MealAnalysisResult(
      foodName: food['name'],
      emoji: food['emoji'],
      calories: food['cal'],
      anxietyLabel: food['label'],
      phrases: [
        '哇！是你最爱的${food['name']}诶！！',
        '生活已经这么苦了当然要对自己好一点呀～',
        '吃吧吃吧，小浣熊批准了！👑✨',
      ],
      coinsEarned: 10 + (food['cal'] ~/ 50),
      xpEarned: food['cal'] ~/ 30,
      nutritionBalance: food['cal'] > 400 ? 0.3 : -0.2,
    );
  }

  List<ShopItem> _getOfflineShopItems() {
    return [
      ShopItem(id: 'glasses_1', name: '圆框眼镜', emoji: '👓', category: 'accessories', price: 100, description: '文艺小清新'),
      ShopItem(id: 'glasses_2', name: '墨镜', emoji: '🕶️', category: 'accessories', price: 200, description: '酷酷的'),
      ShopItem(id: 'bow_1', name: '粉色蝴蝶结', emoji: '🎀', category: 'accessories', price: 150, description: '可爱满分'),
      ShopItem(id: 'bg_1', name: '莫奈花园', emoji: '🌸', category: 'backgrounds', price: 300, description: '睡莲池畔'),
      ShopItem(id: 'bg_2', name: '星空', emoji: '✨', category: 'backgrounds', price: 250, description: '银河璀璨'),
    ];
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}

class MealAnalysisResult {
  final String foodName;
  final String emoji;
  final int calories;
  final String anxietyLabel;
  final List<String> phrases;
  final int coinsEarned;
  final int xpEarned;
  final double nutritionBalance;

  MealAnalysisResult({
    required this.foodName,
    required this.emoji,
    required this.calories,
    required this.anxietyLabel,
    required this.phrases,
    required this.coinsEarned,
    required this.xpEarned,
    required this.nutritionBalance,
  });

  factory MealAnalysisResult.fromJson(Map<String, dynamic> json) => MealAnalysisResult(
        foodName: json['foodName'],
        emoji: json['emoji'],
        calories: json['calories'],
        anxietyLabel: json['anxietyLabel'],
        phrases: List<String>.from(json['phrases']),
        coinsEarned: json['coinsEarned'],
        xpEarned: json['xpEarned'],
        nutritionBalance: (json['nutritionBalance'] ?? 0).toDouble(),
      );
}
