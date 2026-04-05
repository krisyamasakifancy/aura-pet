import 'package:flutter/material.dart';

/// Onboarding global state machine
class OnboardingState extends ChangeNotifier {
  int _currentStep = 0;
  
  // Survey answers
  String? _channel;
  String? _mainGoal;
  List<String> _additionalGoals = [];
  String? _gender;
  int _age = 25;
  double _height = 170.0; // cm
  double _currentWeight = 70.0; // kg
  double _goalWeight = 65.0; // kg
  String _activityLevel = 'moderately_active';
  bool _notificationEnabled = false;
  
  // Fasting state
  bool _fastingActive = false;
  Duration _fastingDuration = const Duration(hours: 16);
  DateTime? _fastingStartTime;
  
  // Water tracking
  double _waterIntake = 0.0; // ml
  double _waterGoal = 2000.0; // ml
  
  // Meals
  List<Map<String, dynamic>> _meals = [];
  
  // Mood
  String? _currentMood;
  
  // Getters
  int get currentStep => _currentStep;
  String? get channel => _channel;
  String? get mainGoal => _mainGoal;
  List<String> get additionalGoals => _additionalGoals;
  String? get gender => _gender;
  int get age => _age;
  double get height => _height;
  double get currentWeight => _currentWeight;
  double get goalWeight => _goalWeight;
  String get activityLevel => _activityLevel;
  bool get notificationEnabled => _notificationEnabled;
  bool get fastingActive => _fastingActive;
  Duration get fastingDuration => _fastingDuration;
  DateTime? get fastingStartTime => _fastingStartTime;
  double get waterIntake => _waterIntake;
  double get waterGoal => _waterGoal;
  List<Map<String, dynamic>> get meals => _meals;
  String? get currentMood => _currentMood;
  
  // BMI calculation
  double get bmi {
    final heightInMeters = _height / 100;
    return _currentWeight / (heightInMeters * heightInMeters);
  }
  
  // Weight difference
  double get weightDifference => _currentWeight - _goalWeight;
  
  // Calories (simplified calculation)
  int get dailyCalorieGoal {
    // Mifflin-St Jeor Equation
    double bmr;
    if (_gender == 'male') {
      bmr = 10 * _currentWeight + 6.25 * _height - 5 * _age + 5;
    } else {
      bmr = 10 * _currentWeight + 6.25 * _height - 5 * _age - 161;
    }
    
    // Activity multiplier
    double multiplier;
    switch (_activityLevel) {
      case 'sedentary': multiplier = 1.2; break;
      case 'lightly_active': multiplier = 1.375; break;
      case 'moderately_active': multiplier = 1.55; break;
      case 'very_active': multiplier = 1.725; break;
      case 'extra_active': multiplier = 1.9; break;
      default: multiplier = 1.55;
    }
    
    // Goal adjustment
    double goalAdjustment;
    if (_mainGoal == 'lose_weight') {
      goalAdjustment = -500; // 减重
    } else if (_mainGoal == 'gain_weight') {
      goalAdjustment = 300; // 增重
    } else {
      goalAdjustment = 0; // 维持
    }
    
    return (bmr * multiplier + goalAdjustment).round();
  }
  
  // Total calories consumed
  int get totalCaloriesConsumed {
    return _meals.fold(0, (sum, meal) => sum + (meal['calories'] as int? ?? 0));
  }
  
  // Remaining calories
  int get remainingCalories => dailyCalorieGoal - totalCaloriesConsumed;
  
  // Setters
  void setChannel(String value) {
    _channel = value;
    notifyListeners();
  }
  
  void setMainGoal(String value) {
    _mainGoal = value;
    notifyListeners();
  }
  
  void addAdditionalGoal(String goal) {
    if (!_additionalGoals.contains(goal)) {
      _additionalGoals.add(goal);
      notifyListeners();
    }
  }
  
  void removeAdditionalGoal(String goal) {
    _additionalGoals.remove(goal);
    notifyListeners();
  }
  
  void setGender(String value) {
    _gender = value;
    notifyListeners();
  }
  
  void setAge(int value) {
    _age = value;
    notifyListeners();
  }
  
  void setHeight(double value) {
    _height = value;
    notifyListeners();
  }
  
  void setCurrentWeight(double value) {
    _currentWeight = value;
    notifyListeners();
  }
  
  void setGoalWeight(double value) {
    _goalWeight = value;
    notifyListeners();
  }
  
  void setActivityLevel(String value) {
    _activityLevel = value;
    notifyListeners();
  }
  
  void setNotificationEnabled(bool value) {
    _notificationEnabled = value;
    notifyListeners();
  }
  
  void startFasting(Duration duration) {
    _fastingActive = true;
    _fastingDuration = duration;
    _fastingStartTime = DateTime.now();
    notifyListeners();
  }
  
  void stopFasting() {
    _fastingActive = false;
    _fastingStartTime = null;
    notifyListeners();
  }
  
  void addWater(double ml) {
    _waterIntake += ml;
    if (_waterIntake > _waterGoal) _waterIntake = _waterGoal;
    notifyListeners();
  }
  
  void setWaterGoal(double ml) {
    _waterGoal = ml;
    notifyListeners();
  }
  
  void addMeal(Map<String, dynamic> meal) {
    _meals.add(meal);
    notifyListeners();
  }
  
  void removeMeal(int index) {
    if (index >= 0 && index < _meals.length) {
      _meals.removeAt(index);
      notifyListeners();
    }
  }
  
  void setMood(String mood) {
    _currentMood = mood;
    notifyListeners();
  }
  
  void nextStep() {
    _currentStep++;
    notifyListeners();
  }
}
