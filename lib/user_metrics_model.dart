import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 用户指标数据模型
/// 管理身体指标数据和实时追踪数据
/// 使用SharedPreferences持久化存储
class UserMetricsModel extends ChangeNotifier {
  // 身体指标数据
  String gender = "Female";
  int age = 25;
  double height = 165.0;
  double weight = 60.0;
  double goalWeight = 50.0;
  String activityLevel = "Sedentary";
  
  // 实时追踪数据
  bool fastingMode = false;
  int dailyCalorieIntake = 0;
  int totalWaterIntake = 0;

  UserMetricsModel() {
    loadData();
  }

  // 持久化：保存数据
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gender', gender);
    await prefs.setInt('age', age);
    await prefs.setDouble('height', height);
    await prefs.setDouble('weight', weight);
    await prefs.setDouble('goalWeight', goalWeight);
    await prefs.setString('activityLevel', activityLevel);
    await prefs.setBool('fastingMode', fastingMode);
    await prefs.setInt('dailyCalorieIntake', dailyCalorieIntake);
    await prefs.setInt('totalWaterIntake', totalWaterIntake);
    notifyListeners();
  }

  // 持久化：读取数据
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    gender = prefs.getString('gender') ?? "Female";
    age = prefs.getInt('age') ?? 25;
    height = prefs.getDouble('height') ?? 165.0;
    weight = prefs.getDouble('weight') ?? 60.0;
    goalWeight = prefs.getDouble('goalWeight') ?? 50.0;
    activityLevel = prefs.getString('activityLevel') ?? "Sedentary";
    fastingMode = prefs.getBool('fastingMode') ?? false;
    dailyCalorieIntake = prefs.getInt('dailyCalorieIntake') ?? 0;
    totalWaterIntake = prefs.getInt('totalWaterIntake') ?? 0;
    notifyListeners();
  }

  // 更新方法（供各页面调用）
  void updateWeight(double newWeight) {
    weight = newWeight;
    saveData();
  }
  
  void updateGender(String newGender) {
    gender = newGender;
    saveData();
  }

  void updateAge(int newAge) {
    age = newAge;
    saveData();
  }

  void updateHeight(double newHeight) {
    height = newHeight;
    saveData();
  }

  void updateGoalWeight(double newGoalWeight) {
    goalWeight = newGoalWeight;
    saveData();
  }

  void updateActivityLevel(String newLevel) {
    activityLevel = newLevel;
    saveData();
  }
  
  void addWater(int amount) {
    totalWaterIntake += amount;
    saveData();
  }

  void setDailyCalorieIntake(int amount) {
    dailyCalorieIntake = amount;
    saveData();
  }

  void addCalorieIntake(int amount) {
    dailyCalorieIntake += amount;
    saveData();
  }

  void toggleFasting(bool status) {
    fastingMode = status;
    saveData();
  }

  void resetDailyData() {
    dailyCalorieIntake = 0;
    totalWaterIntake = 0;
    saveData();
  }

  // 计算BMI
  double get bmi {
    final heightM = height / 100;
    return weight / (heightM * heightM);
  }

  String get bmiCategory {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 24.9) return 'Normal';
    if (bmi < 29.9) return 'Overweight';
    return 'Obese';
  }

  // 计算BMR (基础代谢率)
  double get bmr {
    if (gender == 'Male') {
      return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }
  }

  // 计算TDEE (每日总能量消耗)
  double get tdee {
    double activityMultiplier;
    switch (activityLevel) {
      case 'Sedentary':
        activityMultiplier = 1.2;
        break;
      case 'Lightly Active':
        activityMultiplier = 1.375;
        break;
      case 'Moderately Active':
        activityMultiplier = 1.55;
        break;
      case 'Very Active':
        activityMultiplier = 1.725;
        break;
      case 'Extremely Active':
        activityMultiplier = 1.9;
        break;
      default:
        activityMultiplier = 1.2;
    }
    return bmr * activityMultiplier;
  }

  // 计算每日目标卡路里
  int get dailyCalorieGoal {
    // 减重：TDEE - 500
    // 维持：TDEE
    // 增重：TDEE + 300
    if (goalWeight < weight) {
      return (tdee - 500).round();
    } else if (goalWeight > weight) {
      return (tdee + 300).round();
    }
    return tdee.round();
  }
}
