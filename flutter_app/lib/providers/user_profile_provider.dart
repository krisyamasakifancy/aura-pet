import 'package:flutter/material.dart';

/// User profile data model
class UserProfile {
  String? gender;
  int age;
  double height; // cm
  double currentWeight; // kg
  double goalWeight; // kg
  String activityLevel;
  String? mainGoal;
  List<String> additionalGoals;
  String? channel;
  
  UserProfile({
    this.gender,
    this.age = 25,
    this.height = 170.0,
    this.currentWeight = 70.0,
    this.goalWeight = 65.0,
    this.activityLevel = 'moderately_active',
    this.mainGoal,
    this.additionalGoals = const [],
    this.channel,
  });
  
  double get bmi {
    final heightInMeters = height / 100;
    return currentWeight / (heightInMeters * heightInMeters);
  }
  
  double get weightToLose => currentWeight - goalWeight;
  
  int get dailyCalorieGoal {
    double bmr;
    if (gender == 'male') {
      bmr = 10 * currentWeight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * currentWeight + 6.25 * height - 5 * age - 161;
    }
    
    double multiplier;
    switch (activityLevel) {
      case 'sedentary': multiplier = 1.2; break;
      case 'lightly_active': multiplier = 1.375; break;
      case 'moderately_active': multiplier = 1.55; break;
      case 'very_active': multiplier = 1.725; break;
      case 'extra_active': multiplier = 1.9; break;
      default: multiplier = 1.55;
    }
    
    double goalAdjustment = 0;
    if (mainGoal == 'lose_weight') goalAdjustment = -500;
    else if (mainGoal == 'gain_weight') goalAdjustment = 300;
    
    return (bmr * multiplier + goalAdjustment).round();
  }
  
  Map<String, dynamic> toJson() => {
    'gender': gender,
    'age': age,
    'height': height,
    'currentWeight': currentWeight,
    'goalWeight': goalWeight,
    'activityLevel': activityLevel,
    'mainGoal': mainGoal,
    'additionalGoals': additionalGoals,
    'channel': channel,
  };
  
  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    gender: json['gender'],
    age: json['age'] ?? 25,
    height: (json['height'] ?? 170.0).toDouble(),
    currentWeight: (json['currentWeight'] ?? 70.0).toDouble(),
    goalWeight: (json['goalWeight'] ?? 65.0).toDouble(),
    activityLevel: json['activityLevel'] ?? 'moderately_active',
    mainGoal: json['mainGoal'],
    additionalGoals: List<String>.from(json['additionalGoals'] ?? []),
    channel: json['channel'],
  );
}

/// User profile state provider
class UserProfileProvider extends ChangeNotifier {
  UserProfile _profile = UserProfile();
  
  UserProfile get profile => _profile;
  
  void updateProfile(UserProfile profile) {
    _profile = profile;
    notifyListeners();
  }
  
  void setGender(String? gender) {
    _profile.gender = gender;
    notifyListeners();
  }
  
  void setAge(int age) {
    _profile.age = age;
    notifyListeners();
  }
  
  void setHeight(double height) {
    _profile.height = height;
    notifyListeners();
  }
  
  void setCurrentWeight(double weight) {
    _profile.currentWeight = weight;
    notifyListeners();
  }
  
  void setGoalWeight(double weight) {
    _profile.goalWeight = weight;
    notifyListeners();
  }
  
  void setActivityLevel(String level) {
    _profile.activityLevel = level;
    notifyListeners();
  }
  
  void setMainGoal(String? goal) {
    _profile.mainGoal = goal;
    notifyListeners();
  }
  
  void addAdditionalGoal(String goal) {
    if (!_profile.additionalGoals.contains(goal)) {
      _profile.additionalGoals = [..._profile.additionalGoals, goal];
      notifyListeners();
    }
  }
  
  void removeAdditionalGoal(String goal) {
    _profile.additionalGoals = _profile.additionalGoals.where((g) => g != goal).toList();
    notifyListeners();
  }
  
  void setChannel(String? channel) {
    _profile.channel = channel;
    notifyListeners();
  }
}
