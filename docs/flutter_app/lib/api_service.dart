import 'dart:convert';
import 'package:http/http.dart' as http;

// ============================================
// API CONFIGURATION
// ============================================

class ApiConfig {
  static const String baseUrl = 'http://localhost:8000';
  static const Duration timeout = Duration(seconds: 30);
}

// ============================================
// API RESPONSE MODELS
// ============================================

class UserInfo {
  final String id;
  final String email;
  final String displayName;
  final int bitecoins;
  final String subscriptionTier;
  final int currentStreak;
  final int totalMealsLogged;
  
  UserInfo({
    required this.id,
    required this.email,
    required this.displayName,
    required this.bitecoins,
    required this.subscriptionTier,
    required this.currentStreak,
    required this.totalMealsLogged,
  });
  
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      email: json['email'],
      displayName: json['display_name'],
      bitecoins: json['bitecoins'],
      subscriptionTier: json['subscription_tier'],
      currentStreak: json['current_streak'],
      totalMealsLogged: json['total_meals_logged'],
    );
  }
}

class PetState {
  final String id;
  final String name;
  final String species;
  final int hunger;
  final int joy;
  final int vigor;
  final int affinity;
  final int evolutionXp;
  final int evolutionLevel;
  final String currentMood;
  
  PetState({
    required this.id,
    required this.name,
    required this.species,
    required this.hunger,
    required this.joy,
    required this.vigor,
    required this.affinity,
    required this.evolutionXp,
    required this.evolutionLevel,
    required this.currentMood,
  });
  
  factory PetState.fromJson(Map<String, dynamic> json) {
    return PetState(
      id: json['id'],
      name: json['name'],
      species: json['species'],
      hunger: json['hunger'],
      joy: json['joy'],
      vigor: json['vigor'],
      affinity: json['affinity'],
      evolutionXp: json['evolution_xp'],
      evolutionLevel: json['evolution_level'],
      currentMood: json['current_mood'],
    );
  }
}

class MealLogResult {
  final String id;
  final String foodName;
  final int calories;
  final String category;
  final String anxietyReliefLabel;
  final String anxietyReliefEmoji;
  final int coinsEarned;
  final int xpEarned;
  final PetState petState;
  final String dialogue;
  final String animationTrigger;
  
  MealLogResult({
    required this.id,
    required this.foodName,
    required this.calories,
    required this.category,
    required this.anxietyReliefLabel,
    required this.anxietyReliefEmoji,
    required this.coinsEarned,
    required this.xpEarned,
    required this.petState,
    required this.dialogue,
    required this.animationTrigger,
  });
  
  factory MealLogResult.fromJson(Map<String, dynamic> json) {
    return MealLogResult(
      id: json['id'],
      foodName: json['food_name'],
      calories: json['calories'],
      category: json['category'],
      anxietyReliefLabel: json['anxiety_relief_label'],
      anxietyReliefEmoji: json['anxiety_relief_emoji'],
      coinsEarned: json['coins_earned'],
      xpEarned: json['xp_earned'],
      petState: PetState.fromJson(json['pet_state']),
      dialogue: json['dialogue'],
      animationTrigger: json['animation_trigger'],
    );
  }
}

class FoodAnalysisResult {
  final bool success;
  final String foodName;
  final int calories;
  final String category;
  final String anxietyReliefLabel;
  final String anxietyReliefEmoji;
  final double confidence;
  final List<String> colorsDetected;
  
  FoodAnalysisResult({
    required this.success,
    required this.foodName,
    required this.calories,
    required this.category,
    required this.anxietyReliefLabel,
    required this.anxietyReliefEmoji,
    required this.confidence,
    required this.colorsDetected,
  });
  
  factory FoodAnalysisResult.fromJson(Map<String, dynamic> json) {
    return FoodAnalysisResult(
      success: json['success'],
      foodName: json['food_name'],
      calories: json['calories'],
      category: json['category'],
      anxietyReliefLabel: json['anxiety_relief_label'],
      anxietyReliefEmoji: json['anxiety_relief_emoji'],
      confidence: json['confidence'].toDouble(),
      colorsDetected: List<String>.from(json['colors_detected']),
    );
  }
}

// ============================================
// API SERVICE
// ============================================

class AuraPetApiService {
  final http.Client _client;
  final String _baseUrl;
  
  AuraPetApiService({
    http.Client? client,
    String? baseUrl,
  }) : _client = client ?? http.Client(),
       _baseUrl = baseUrl ?? ApiConfig.baseUrl;
  
  // Helper method for API calls
  Future<Map<String, dynamic>> _get(String endpoint) async {
    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl$endpoint'))
          .timeout(ApiConfig.timeout);
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ApiException('GET $endpoint failed: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }
  
  Future<Map<String, dynamic>> _post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl$endpoint'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.timeout);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw ApiException('POST $endpoint failed: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }
  
  // ----------------------------------------
  // USER ENDPOINTS
  // ----------------------------------------
  
  /// Get current user info
  Future<UserInfo> getCurrentUser() async {
    final data = await _get('/api/v1/user/me');
    return UserInfo.fromJson(data);
  }
  
  /// Add coins (for testing)
  Future<int> addCoins(int amount) async {
    final data = await _post('/api/v1/user/coins/add', {'amount': amount});
    return data['new_balance'];
  }
  
  // ----------------------------------------
  // PET ENDPOINTS
  // ----------------------------------------
  
  /// Get pet state
  Future<PetState> getPetState() async {
    final data = await _get('/api/v1/pet');
    return PetState.fromJson(data);
  }
  
  /// Update pet state
  Future<PetState> updatePetState({
    String? mood,
    int? hunger,
    int? joy,
  }) async {
    final body = <String, dynamic>{};
    if (mood != null) body['mood'] = mood;
    if (hunger != null) body['hunger'] = hunger;
    if (joy != null) body['joy'] = joy;
    
    final data = await _post('/api/v1/pet/state', body);
    return PetState.fromJson(data['pet']);
  }
  
  // ----------------------------------------
  // MEAL ENDPOINTS
  // ----------------------------------------
  
  /// Log a meal
  Future<MealLogResult> logMeal({
    required String foodName,
    required int calories,
    required String category,
    required String anxietyReliefLabel,
    required String anxietyReliefEmoji,
  }) async {
    final data = await _post('/api/v1/meals', {
      'food_name': foodName,
      'calories': calories,
      'category': category,
      'anxiety_relief_label': anxietyReliefLabel,
      'anxiety_relief_emoji': anxietyReliefEmoji,
    });
    return MealLogResult.fromJson(data);
  }
  
  /// Analyze food from image (mock - requires actual image upload)
  Future<FoodAnalysisResult> analyzeFoodImage(List<int> imageBytes) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/api/v1/meals/analyze'),
      );
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: 'food.jpg',
      ));
      
      final streamedResponse = await _client.send(request).timeout(ApiConfig.timeout);
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        return FoodAnalysisResult.fromJson(jsonDecode(response.body));
      } else {
        throw ApiException('Image analysis failed: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }
  
  // ----------------------------------------
  // INTERACTION ENDPOINTS
  // ----------------------------------------
  
  /// Touch interaction
  Future<Map<String, dynamic>> touchInteraction(String touchType) async {
    final data = await _post('/api/v1/interactions/touch', {
      'touch_type': touchType,
    });
    return {
      'animation_trigger': data['animation_trigger'],
      'dialogue': data['dialogue'],
      'coins_earned': data['coins_earned'],
    };
  }
  
  // ----------------------------------------
  // WATER TRACKING ENDPOINTS
  // ----------------------------------------
  
  /// Log water intake
  Future<Map<String, dynamic>> logWater(int amountMl) async {
    final data = await _post('/api/v1/water', {
      'amount_ml': amountMl,
    });
    return {
      'success': data['success'],
      'amount_ml': data['amount_ml'],
      'today_total': data['today_total'],
      'goal_achieved': data['goal_achieved'],
    };
  }
  
  // ----------------------------------------
  // SHOP ENDPOINTS
  // ----------------------------------------
  
  /// Get shop items
  Future<List<ShopItem>> getShopItems() async {
    final data = await _get('/api/v1/shop/items');
    return (data as List).map((item) => ShopItem.fromJson(item)).toList();
  }
  
  /// Purchase item
  Future<PurchaseResult> purchaseItem(String itemId) async {
    final data = await _post('/api/v1/shop/purchase', {
      'item_id': itemId,
    });
    return PurchaseResult.fromJson(data);
  }
  
  // ----------------------------------------
  // ANALYTICS ENDPOINTS
  // ----------------------------------------
  
  /// Get daily stats
  Future<DailyStats> getDailyStats() async {
    final data = await _get('/api/v1/analytics/daily');
    return DailyStats.fromJson(data);
  }
}

// ============================================
// ADDITIONAL MODELS
// ============================================

class ShopItem {
  final String id;
  final String itemKey;
  final String name;
  final String description;
  final String itemType;
  final int priceBitecoins;
  final String? previewImageUrl;
  
  ShopItem({
    required this.id,
    required this.itemKey,
    required this.name,
    required this.description,
    required this.itemType,
    required this.priceBitecoins,
    this.previewImageUrl,
  });
  
  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
      id: json['id'],
      itemKey: json['item_key'],
      name: json['name'],
      description: json['description'],
      itemType: json['item_type'],
      priceBitecoins: json['price_bitecoins'],
      previewImageUrl: json['preview_image_url'],
    );
  }
}

class PurchaseResult {
  final bool success;
  final int newBalance;
  final String itemId;
  final String message;
  
  PurchaseResult({
    required this.success,
    required this.newBalance,
    required this.itemId,
    required this.message,
  });
  
  factory PurchaseResult.fromJson(Map<String, dynamic> json) {
    return PurchaseResult(
      success: json['success'],
      newBalance: json['new_balance'],
      itemId: json['item_id'],
      message: json['message'],
    );
  }
}

class DailyStats {
  final String date;
  final int mealsCount;
  final int totalCalories;
  final int coinsEarnedToday;
  final Map<String, dynamic> petState;
  final int streak;
  
  DailyStats({
    required this.date,
    required this.mealsCount,
    required this.totalCalories,
    required this.coinsEarnedToday,
    required this.petState,
    required this.streak,
  });
  
  factory DailyStats.fromJson(Map<String, dynamic> json) {
    return DailyStats(
      date: json['date'],
      mealsCount: json['meals_count'],
      totalCalories: json['total_calories'],
      coinsEarnedToday: json['coins_earned_today'],
      petState: json['pet_state'],
      streak: json['streak'],
    );
  }
}

// ============================================
// EXCEPTION
// ============================================

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  
  @override
  String toString() => 'ApiException: $message';
}
