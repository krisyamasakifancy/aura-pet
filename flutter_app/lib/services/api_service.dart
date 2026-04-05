import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

class ApiService {
  static const String baseUrl = 'https://api.aura-pet.com/v1';
  static const Duration timeout = Duration(seconds: 30);

  // Singleton
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;

  void setToken(String token) {
    _token = token;
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // ===== Auth =====
  Future<ApiResponse> login(String email, String password) async {
    // Simulated API call
    await Future.delayed(const Duration(milliseconds: 800));
    return ApiResponse.success({
      'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      'user': {
        'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
        'email': email,
        'name': email.split('@').first,
        'level': 1,
        'coins': 100,
      }
    });
  }

  Future<ApiResponse> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return ApiResponse.success({
      'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      'user': {
        'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
        'email': email,
        'name': name,
        'level': 1,
        'coins': 200, // Welcome bonus
      }
    });
  }

  // ===== Meal =====
  Future<ApiResponse> analyzeFood(String imageBase64) async {
    await Future.delayed(const Duration(seconds: 2));
    // Simulated AI analysis
    final foods = [
      {'name': '鸡胸肉沙拉', 'emoji': '🍗', 'cal': 285, 'protein': 31.0, 'carbs': 12.0, 'fat': 8.0},
      {'name': '三文鱼便当', 'emoji': '🍣', 'cal': 420, 'protein': 35.0, 'carbs': 25.0, 'fat': 18.0},
      {'name': '蔬菜沙拉', 'emoji': '🥗', 'cal': 120, 'protein': 5.0, 'carbs': 20.0, 'fat': 3.0},
      {'name': '牛肉汉堡', 'emoji': '🍔', 'cal': 550, 'protein': 28.0, 'carbs': 45.0, 'fat': 28.0},
    ];
    final food = foods[DateTime.now().second % foods.length];
    return ApiResponse.success(food);
  }

  Future<ApiResponse> saveMeal(Map<String, dynamic> mealData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ApiResponse.success({
      'id': 'meal_${DateTime.now().millisecondsSinceEpoch}',
      ...mealData,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<ApiResponse> getMealHistory({int limit = 20, int offset = 0}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final meals = List.generate(
      limit,
      (i) => {
        'id': 'meal_${i}_${DateTime.now().millisecondsSinceEpoch}',
        'name': ['鸡胸肉沙拉', '三文鱼便当', '蔬菜沙拉'][i % 3],
        'emoji': ['🍗', '🍣', '🥗'][i % 3],
        'cal': [285, 420, 120][i % 3],
        'timestamp': DateTime.now().subtract(Duration(hours: i * 3)).toIso8601String(),
      },
    );
    return ApiResponse.success({
      'meals': meals,
      'total': 100,
      'hasMore': offset + limit < 100,
    });
  }

  // ===== Pet =====
  Future<ApiResponse> getPetState() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResponse.success({
      'level': 3,
      'xp': 65,
      'xpToNext': 100,
      'mood': 'happy',
      'accessories': ['scarf'],
      'hearts': 3,
      'coins': 280,
    });
  }

  Future<ApiResponse> buyAccessory(String accessoryId, int price) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ApiResponse.success({
      'success': true,
      'newAccessories': ['scarf', accessoryId],
      'remainingCoins': 280 - price,
    });
  }

  // ===== Nutrition =====
  Future<ApiResponse> getDailySummary() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return ApiResponse.success({
      'calories': 1245,
      'calorieGoal': 2000,
      'protein': 65,
      'proteinGoal': 60,
      'carbs': 180,
      'carbsGoal': 200,
      'fat': 45,
      'fatGoal': 65,
      'water': 5,
      'waterGoal': 8,
    });
  }

  Future<ApiResponse> addWaterLog(int glasses) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResponse.success({
      'success': true,
      'totalGlasses': 5 + glasses,
      'goalMet': 5 + glasses >= 8,
    });
  }

  // ===== Fasting =====
  Future<ApiResponse> startFasting(int hours) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return ApiResponse.success({
      'id': 'fasting_${DateTime.now().millisecondsSinceEpoch}',
      'startTime': DateTime.now().toIso8601String(),
      'targetHours': hours,
      'status': 'active',
    });
  }

  Future<ApiResponse> endFasting(String fastingId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return ApiResponse.success({
      'id': fastingId,
      'endTime': DateTime.now().toIso8601String(),
      'status': 'completed',
      'xpEarned': 50,
      'coinsEarned': 10,
    });
  }

  // ===== Achievements =====
  Future<ApiResponse> getAchievements() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ApiResponse.success({
      'achievements': [
        {'id': 'streak_7', 'name': '连续7天', 'progress': 5, 'target': 7, 'unlocked': false},
        {'id': 'water_8', 'name': '喝水达人', 'progress': 8, 'target': 8, 'unlocked': true},
        {'id': 'balance_3', 'name': '营养均衡', 'progress': 3, 'target': 3, 'unlocked': true},
      ]
    });
  }

  // ===== Subscription =====
  Future<ApiResponse> checkSubscription() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResponse.success({
      'isSubscribed': false,
      'plan': null,
      'expiresAt': null,
    });
  }

  Future<ApiResponse> subscribe(String planId) async {
    await Future.delayed(const Duration(seconds: 2));
    return ApiResponse.success({
      'success': true,
      'plan': planId,
      'expiresAt': DateTime.now().add(const Duration(days: 365)).toIso8601String(),
    });
  }

  // ===== Profile =====
  Future<ApiResponse> updateProfile(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ApiResponse.success({'success': true, ...data});
  }

  Future<ApiResponse> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResponse.success({
      'name': 'Colvin',
      'email': 'colvin@example.com',
      'height': 175,
      'weight': 70,
      'goal': 'lose',
      'createdAt': '2024-01-01T00:00:00Z',
    });
  }
}

class ApiResponse {
  final bool success;
  final dynamic data;
  final String? error;
  final int? statusCode;

  const ApiResponse._({
    required this.success,
    this.data,
    this.error,
    this.statusCode,
  });

  factory ApiResponse.success(dynamic data) {
    return ApiResponse._(success: true, data: data);
  }

  factory ApiResponse.error(String message, {int? statusCode}) {
    return ApiResponse._(
      success: false,
      error: message,
      statusCode: statusCode,
    );
  }

  T? getData<T>() {
    if (success && data is T) {
      return data as T;
    }
    return null;
  }

  Map<String, dynamic>? getDataAsMap() {
    if (success && data is Map<String, dynamic>) {
      return data as Map<String, dynamic>;
    }
    if (success && data is Map) {
      return Map<String, dynamic>.from(data as Map);
    }
    return null;
  }
}

// API Error types
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (code: $statusCode)';
}

class NetworkException extends ApiException {
  const NetworkException() : super('Network error. Please check your connection.');
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException() : super('Unauthorized. Please login again.', statusCode: 401);
}

class ServerException extends ApiException {
  const ServerException() : super('Server error. Please try again later.', statusCode: 500);
}
