import 'package:flutter/material.dart';

class NutritionRecord {
  final String id;
  final String foodName;
  final String emoji;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final int auraScore;
  final DateTime timestamp;

  const NutritionRecord({
    required this.id,
    required this.foodName,
    required this.emoji,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.auraScore,
    required this.timestamp,
  });
}

class NutritionProvider extends ChangeNotifier {
  int _dailyCalorieGoal = 2000;
  int _proteinGoal = 60;
  int _carbsGoal = 200;
  int _fatGoal = 65;

  int _todayCalories = 0;
  double _todayProtein = 0;
  double _todayCarbs = 0;
  double _todayFat = 0;
  int _waterGlasses = 0;
  int _waterGoal = 8;

  final List<NutritionRecord> _mealHistory = [];

  // Getters
  int get dailyCalorieGoal => _dailyCalorieGoal;
  int get todayCalories => _todayCalories;
  double get todayProtein => _todayProtein;
  double get todayCarbs => _todayCarbs;
  double get todayFat => _todayFat;
  int get waterGlasses => _waterGlasses;
  int get waterGoal => _waterGoal;
  List<NutritionRecord> get mealHistory => List.unmodifiable(_mealHistory);

  double get calorieProgress => (_todayCalories / _dailyCalorieGoal).clamp(0.0, 1.5);
  double get proteinProgress => (_todayProtein / _proteinGoal).clamp(0.0, 1.5);
  double get carbsProgress => (_todayCarbs / _carbsGoal).clamp(0.0, 1.5);
  double get fatProgress => (_todayFat / _fatGoal).clamp(0.0, 1.5);
  double get waterProgress => (_waterGlasses / _waterGoal).clamp(0.0, 1.5);
  bool get waterGoalMet => _waterGlasses >= _waterGoal;

  int get remainingCalories => _dailyCalorieGoal - _todayCalories;
  int get weeklyCalories => _todayCalories * 7; // Simplified

  // Calculate Aura Score based on nutrition balance
  int calculateAuraScore({
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
  }) {
    double score = 50.0;

    // Protein ratio check (ideal: 30% of calories from protein)
    double proteinCal = protein * 4;
    double proteinRatio = proteinCal / calories;
    if (proteinRatio >= 0.25 && proteinRatio <= 0.35) {
      score += 20;
    } else if (proteinRatio >= 0.20 && proteinRatio <= 0.40) {
      score += 10;
    }

    // Fat ratio check (ideal: 25-30%)
    double fatCal = fat * 9;
    double fatRatio = fatCal / calories;
    if (fatRatio >= 0.20 && fatRatio <= 0.35) {
      score += 15;
    } else if (fatRatio >= 0.15 && fatRatio <= 0.40) {
      score += 8;
    }

    // Calorie balance
    if (calories <= _dailyCalorieGoal * 1.1) {
      score += 15;
    } else if (calories > _dailyCalorieGoal * 1.3) {
      score -= 20;
    }

    return score.clamp(0, 100).round();
  }

  // Add meal record
  void addMealRecord(NutritionRecord record) {
    _mealHistory.insert(0, record);
    _todayCalories += record.calories;
    _todayProtein += record.protein;
    _todayCarbs += record.carbs;
    _todayFat += record.fat;
    notifyListeners();
  }

  // Water tracking
  void addWater({int glasses = 1}) {
    _waterGlasses += glasses;
    notifyListeners();
  }

  void removeWater({int glasses = 1}) {
    _waterGlasses = (_waterGlasses - glasses).clamp(0, 999);
    notifyListeners();
  }

  void resetWater() {
    _waterGlasses = 0;
    notifyListeners();
  }

  // Reset daily values (call at midnight)
  void resetDaily() {
    _todayCalories = 0;
    _todayProtein = 0;
    _todayCarbs = 0;
    _todayFat = 0;
    _waterGlasses = 0;
    notifyListeners();
  }

  // Update goals
  void setCalorieGoal(int goal) {
    _dailyCalorieGoal = goal;
    notifyListeners();
  }

  void setProteinGoal(int goal) {
    _proteinGoal = goal;
    notifyListeners();
  }

  // Simulate food analysis (for demo)
  NutritionRecord simulateFoodAnalysis(String foodName) {
    final foods = {
      '鸡胸肉沙拉': {'emoji': '🍗', 'cal': 285, 'protein': 31.0, 'carbs': 12.0, 'fat': 8.0},
      '三文鱼便当': {'emoji': '🍣', 'cal': 420, 'protein': 35.0, 'carbs': 25.0, 'fat': 18.0},
      '蔬菜沙拉': {'emoji': '🥗', 'cal': 120, 'protein': 5.0, 'carbs': 20.0, 'fat': 3.0},
      '牛肉汉堡': {'emoji': '🍔', 'cal': 550, 'protein': 28.0, 'carbs': 45.0, 'fat': 28.0},
      '水果拼盘': {'emoji': '🍎', 'cal': 180, 'protein': 2.0, 'carbs': 45.0, 'fat': 1.0},
      '炒饭': {'emoji': '🍚', 'cal': 380, 'protein': 12.0, 'carbs': 60.0, 'fat': 12.0},
    };

    final food = foods[foodName] ?? foods.values.first;
    final aura = calculateAuraScore(
      calories: food['cal'] as int,
      protein: food['protein'] as double,
      carbs: food['carbs'] as double,
      fat: food['fat'] as double,
    );

    return NutritionRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      foodName: foodName,
      emoji: food['emoji'] as String,
      calories: food['cal'] as int,
      protein: food['protein'] as double,
      carbs: food['carbs'] as double,
      fat: food['fat'] as double,
      auraScore: aura,
      timestamp: DateTime.now(),
    );
  }
}
