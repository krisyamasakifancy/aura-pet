import 'package:flutter/material.dart';

/// OnboardingState - Global State Machine for BitePal 46-Screen Onboarding
/// All user data flows through this provider
class OnboardingState extends ChangeNotifier {
  // === P8: Channel Survey ===
  String? selectedChannel;
  final List<String> channels = [
    'TikTok', 'Instagram', 'YouTube', 'Google', 
    'Friends', 'App Store', 'Other'
  ];

  // === P9: Main Goal ===
  String selectedGoal = 'lose_weight'; // lose_weight, maintain, gain_weight

  // === P10: Additional Goals ===
  final Set<String> additionalGoals = {};
  final List<String> goalOptions = [
    'Build healthy relationship with food',
    'Boost daily energy',
    'Improve sleep quality',
    'Reduce sugar intake',
    'Eat more vegetables',
    'Stay hydrated',
    'Build muscle',
    'Reduce stress',
  ];

  // === P11: Gender ===
  String gender = 'female';

  // === P12: Age ===
  int age = 25;

  // === P13: Height ===
  double heightCm = 170.0;
  bool useMetricHeight = true;

  // === P14: Current Weight ===
  double currentWeightKg = 70.0;

  // === P15: Goal Weight ===
  double goalWeightKg = 65.0;

  // === P16: Activity Level ===
  String activityLevel = 'moderate';
  final Map<String, String> activityDescriptions = {
    'sedentary': 'Little or no exercise',
    'light': 'Light exercise 1-3 days/week',
    'moderate': 'Moderate exercise 3-5 days/week',
    'active': 'Hard exercise 6-7 days/week',
    'very_active': 'Very hard exercise & physical job',
  };

  // === P20: Notifications ===
  bool notificationsEnabled = false;

  // === P24-P26: Paywall ===
  String selectedPlan = 'yearly'; // weekly, yearly
  bool paywallAccepted = false;

  // === P28-P37: Daily Tracking ===
  int todayCalories = 0;
  int calorieGoal = 2000;
  double waterIntakeMl = 0;
  double waterGoalMl = 2500;
  String fastingState = 'idle'; // idle, running, completed
  int fastingDurationMinutes = 0;
  int fastingGoalMinutes = 960; // 16 hours default

  // === P30: Mood ===
  String? todayMood;

  // === P32: Food Log ===
  final List<Map<String, dynamic>> foodLog = [];

  // === P34: Fasting Plan ===
  String selectedFastingPlan = '16_8'; // 16_8, 14_10, 18_6, 20_4, custom

  // === P38: Achievements ===
  final List<String> unlockedAchievements = [];
  final List<Map<String, dynamic>> allAchievements = [
    {'id': 'early_bird', 'name': 'Early Bird', 'desc': 'Log breakfast', 'icon': Icons.workspace_premium, 'unlocked': false},
    {'id': 'streak_master', 'name': 'Streak Master', 'desc': '7 day streak', 'icon': Icons.local_fire_department, 'unlocked': false},
    {'id': 'hydration_hero', 'name': 'Hydration Hero', 'desc': 'Hit water goal', 'icon': Icons.water_drop, 'unlocked': false},
    {'id': 'food_logger', 'name': 'Food Logger', 'desc': 'Log 50 meals', 'icon': Icons.restaurant, 'unlocked': false},
    {'id': 'gym_rat', 'name': 'Gym Rat', 'desc': 'Work out 10x', 'icon': Icons.fitness_center, 'unlocked': false},
    {'id': 'sleep_champion', 'name': 'Sleep Champion', 'desc': '8hr sleep', 'icon': Icons.bedtime, 'unlocked': false},
  ];

  // === P42: Pet Skin ===
  String selectedPetSkin = 'default';
  final List<Map<String, dynamic>> petSkins = [
    {'id': 'default', 'name': 'Classic', 'color': Colors.grey},
    {'id': 'monet', 'name': 'Monet', 'color': Colors.pink},
    {'id': 'forest', 'name': 'Forest', 'color': Colors.green},
    {'id': 'ocean', 'name': 'Ocean', 'color': Colors.blue},
    {'id': 'sunset', 'name': 'Sunset', 'color': Colors.orange},
  ];

  // === Computed Values ===
  
  /// BMI Calculation
  double get bmi {
    final heightM = heightCm / 100;
    return currentWeightKg / (heightM * heightM);
  }

  String get bmiCategory {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  /// BMR using Mifflin-St Jeor Equation
  double get bmr {
    if (gender == 'male') {
      return 10 * currentWeightKg + 6.25 * heightCm - 5 * age + 5;
    } else {
      return 10 * currentWeightKg + 6.25 * heightCm - 5 * age - 161;
    }
  }

  /// TDEE (Total Daily Energy Expenditure)
  double get tdee {
    double multiplier;
    switch (activityLevel) {
      case 'sedentary': multiplier = 1.2; break;
      case 'light': multiplier = 1.375; break;
      case 'moderate': multiplier = 1.55; break;
      case 'active': multiplier = 1.725; break;
      case 'very_active': multiplier = 1.9; break;
      default: multiplier = 1.55;
    }
    return bmr * multiplier;
  }

  /// Daily Calorie Goal based on main goal
  int get dailyCalorieGoal {
    switch (selectedGoal) {
      case 'lose_weight':
        return (tdee - 500).round(); // 500 kcal deficit
      case 'gain_weight':
        return (tdee + 300).round(); // 300 kcal surplus
      default:
        return tdee.round(); // maintenance
    }
  }

  /// Weight difference
  double get weightDifference => currentWeightKg - goalWeightKg;

  /// Weekly weight loss prediction (0.5kg per week average)
  int get weeksToGoal => (weightDifference / 0.5).abs().ceil();

  /// Weight prediction curve data points
  List<Map<String, double>> get weightPredictionCurve {
    final List<Map<String, double>> curve = [];
    final weeks = weeksToGoal + 4; // extra 4 weeks to show maintenance
    final weeklyLoss = weightDifference / weeksToGoal;
    
    for (int i = 0; i <= weeks; i++) {
      double weight;
      if (i <= weeksToGoal) {
        weight = currentWeightKg - (weeklyLoss * i);
      } else {
        weight = goalWeightKg; // maintenance phase
      }
      curve.add({
        'week': i.toDouble(),
        'weight': weight,
      });
    }
    return curve;
  }

  /// Calorie remaining
  int get caloriesRemaining => dailyCalorieGoal - todayCalories;

  /// Water progress percentage
  double get waterProgress => (waterIntakeMl / waterGoalMl).clamp(0.0, 1.0);

  /// Fasting progress percentage
  double get fastingProgress => 
    fastingState == 'idle' ? 0 : 
    (fastingDurationMinutes / fastingGoalMinutes).clamp(0.0, 1.0);

  // === Actions ===

  void setChannel(String channel) {
    selectedChannel = channel;
    notifyListeners();
  }

  void setGoal(String goal) {
    selectedGoal = goal;
    notifyListeners();
  }

  void toggleAdditionalGoal(String goal) {
    if (additionalGoals.contains(goal)) {
      additionalGoals.remove(goal);
    } else {
      additionalGoals.add(goal);
    }
    notifyListeners();
  }

  void setGender(String g) {
    gender = g;
    notifyListeners();
  }

  void setAge(int a) {
    age = a;
    notifyListeners();
  }

  void setHeight(double h) {
    heightCm = h;
    notifyListeners();
  }

  void setCurrentWeight(double w) {
    currentWeightKg = w;
    notifyListeners();
  }

  void setGoalWeight(double w) {
    goalWeightKg = w;
    notifyListeners();
  }

  void setActivityLevel(String level) {
    activityLevel = level;
    notifyListeners();
  }

  void setNotifications(bool enabled) {
    notificationsEnabled = enabled;
    notifyListeners();
  }

  void setPaywallPlan(String plan) {
    selectedPlan = plan;
    notifyListeners();
  }

  void acceptPaywall() {
    paywallAccepted = true;
    notifyListeners();
  }

  void addFood(Map<String, dynamic> food) {
    foodLog.add(food);
    todayCalories += (food['calories'] as int? ?? 0);
    notifyListeners();
  }

  void addWater(double ml) {
    waterIntakeMl += ml;
    notifyListeners();
  }

  void setMood(String mood) {
    todayMood = mood;
    notifyListeners();
  }

  void startFasting() {
    fastingState = 'running';
    fastingDurationMinutes = 0;
    notifyListeners();
  }

  void updateFastingProgress(int minutes) {
    fastingDurationMinutes = minutes;
    if (fastingDurationMinutes >= fastingGoalMinutes) {
      fastingState = 'completed';
    }
    notifyListeners();
  }

  void setFastingPlan(String plan) {
    selectedFastingPlan = plan;
    switch (plan) {
      case '16_8': fastingGoalMinutes = 960; break;
      case '14_10': fastingGoalMinutes = 840; break;
      case '18_6': fastingGoalMinutes = 1080; break;
      case '20_4': fastingGoalMinutes = 1200; break;
    }
    notifyListeners();
  }

  void setPetSkin(String skinId) {
    selectedPetSkin = skinId;
    notifyListeners();
  }

  void unlockAchievement(String id) {
    final index = allAchievements.indexWhere((a) => a['id'] == id);
    if (index != -1) {
      allAchievements[index]['unlocked'] = true;
      unlockedAchievements.add(id);
      notifyListeners();
    }
  }
}
