import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global Theme Controller for Aura-Pet
/// Controls fasting mode, water tracking, and mood-based theming
class ThemeController extends ChangeNotifier {
  // ===== Fasting Mode =====
  bool _isFastingMode = false;
  bool get isFastingMode => _isFastingMode;
  
  // Fasting background transition
  Color get backgroundColor {
    if (_isFastingMode) {
      return const Color(0xFF1A0033); // Deep purple
    }
    return const Color(0xFFEDF6FA); // Air blue
  }
  
  Color get backgroundGradientEnd {
    if (_isFastingMode) {
      return const Color(0xFF2D1B4E); // Deep purple
    }
    return Colors.white;
  }
  
  // ===== Water Mode =====
  double _waterLevel = 0.0;
  double get waterLevel => _waterLevel;
  
  double get waterIconScale => 1.0 + (_waterLevel * 0.5); // Scale up to 1.5x
  
  // ===== Mood Mode =====
  String _currentMood = 'neutral';
  String get currentMood => _currentMood;
  
  // ===== Actions =====
  
  void startFasting() {
    _isFastingMode = true;
    notifyListeners();
  }
  
  void stopFasting() {
    _isFastingMode = false;
    notifyListeners();
  }
  
  void updateWaterLevel(double ml, double goal) {
    _waterLevel = (ml / goal).clamp(0.0, 1.0);
    notifyListeners();
  }
  
  void setMood(String mood) {
    _currentMood = mood;
    notifyListeners();
  }
  
  void reset() {
    _isFastingMode = false;
    _waterLevel = 0.0;
    _currentMood = 'neutral';
    notifyListeners();
  }
}

/// Persistence Service using SharedPreferences
/// Saves and loads user onboarding data
class PersistenceService {
  static const _keyAge = 'user_age';
  static const _keyHeight = 'user_height';
  static const _keyCurrentWeight = 'user_current_weight';
  static const _keyGoalWeight = 'user_goal_weight';
  static const _keyGender = 'user_gender';
  static const _keyActivityLevel = 'user_activity_level';
  static const _keyOnboardingComplete = 'onboarding_complete';
  static const _keyFastingState = 'fasting_state';
  static const _keyWaterIntake = 'water_intake';
  static const _keyUsedQuotes = 'used_quotes';
  
  SharedPreferences? _prefs;
  
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // ===== Save User Metrics =====
  
  Future<void> saveUserMetrics({
    required int age,
    required double heightCm,
    required double currentWeightKg,
    required double goalWeightKg,
    required String gender,
    required String activityLevel,
  }) async {
    await _prefs?.setInt(_keyAge, age);
    await _prefs?.setDouble(_keyHeight, heightCm);
    await _prefs?.setDouble(_keyCurrentWeight, currentWeightKg);
    await _prefs?.setDouble(_keyGoalWeight, goalWeightKg);
    await _prefs?.setString(_keyGender, gender);
    await _prefs?.setString(_keyActivityLevel, activityLevel);
    await _prefs?.setBool(_keyOnboardingComplete, true);
  }
  
  // ===== Load User Metrics =====
  
  Map<String, dynamic>? loadUserMetrics() {
    final complete = _prefs?.getBool(_keyOnboardingComplete) ?? false;
    if (!complete) return null;
    
    return {
      'age': _prefs?.getInt(_keyAge) ?? 25,
      'heightCm': _prefs?.getDouble(_keyHeight) ?? 170.0,
      'currentWeightKg': _prefs?.getDouble(_keyCurrentWeight) ?? 70.0,
      'goalWeightKg': _prefs?.getDouble(_keyGoalWeight) ?? 65.0,
      'gender': _prefs?.getString(_keyGender) ?? 'female',
      'activityLevel': _prefs?.getString(_keyActivityLevel) ?? 'moderate',
    };
  }
  
  bool get isOnboardingComplete => _prefs?.getBool(_keyOnboardingComplete) ?? false;
  
  // ===== Fasting State =====
  
  Future<void> saveFastingState({
    required String state,
    required int durationMinutes,
  }) async {
    await _prefs?.setString(_keyFastingState, state);
    await _prefs?.setInt('fasting_duration', durationMinutes);
  }
  
  Map<String, dynamic>? loadFastingState() {
    final state = _prefs?.getString(_keyFastingState);
    if (state == null) return null;
    
    return {
      'state': state,
      'durationMinutes': _prefs?.getInt('fasting_duration') ?? 0,
    };
  }
  
  // ===== Water Intake =====
  
  Future<void> saveWaterIntake(double ml) async {
    await _prefs?.setDouble(_keyWaterIntake, ml);
  }
  
  double getWaterIntake() => _prefs?.getDouble(_keyWaterIntake) ?? 0.0;
  
  // ===== Used Quotes (for no-repeat) =====
  
  Future<void> markQuoteUsed(int quoteId) async {
    final used = _prefs?.getStringList(_keyUsedQuotes) ?? [];
    used.add(quoteId.toString());
    await _prefs?.setStringList(_keyUsedQuotes, used);
  }
  
  List<int> getUsedQuoteIds() {
    final used = _prefs?.getStringList(_keyUsedQuotes) ?? [];
    return used.map((e) => int.tryParse(e) ?? 0).toList();
  }
  
  Future<void> resetUsedQuotes() async {
    await _prefs?.setStringList(_keyUsedQuotes, []);
  }
  
  // ===== Clear All =====
  
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}

/// Quote Engine with 100 curated quotes
/// Categorized by emotion and context
class QuoteEngine {
  static final QuoteEngine _instance = QuoteEngine._();
  static QuoteEngine get instance => _instance;
  QuoteEngine._();
  
  final _random = DateTime.now().millisecondsSinceEpoch;
  final _usedIds = <int>[];
  
  // ===== Quote Database =====
  
  static const _quotes = [
    // ===== 夸奖类 (Praise - 25条) =====
    {'id': 1, 'text': "Yummy! Let's log your meal! 🍽️", 'category': 'praise', 'context': 'food'},
    {'id': 2, 'text': "Amazing taste! Your bear is drooling! 😋", 'category': 'praise', 'context': 'food'},
    {'id': 3, 'text': "Great choice! Balanced and beautiful! ✨", 'category': 'praise', 'context': 'food'},
    {'id': 4, 'text': "Perfect balance! Your bear is doing a happy dance! 💃", 'category': 'praise', 'context': 'nutrition'},
    {'id': 5, 'text': "You're crushing it! Protein goals met! 💪", 'category': 'praise', 'context': 'nutrition'},
    {'id': 6, 'text': "Hydration hero! Keep it flowing! 💧", 'category': 'praise', 'context': 'water'},
    {'id': 7, 'text': "Splash splash! Looking refreshed! 🌊", 'category': 'praise', 'context': 'water'},
    {'id': 8, 'text': "Water warrior! Your cells are thanking you! 🙌", 'category': 'praise', 'context': 'water'},
    {'id': 9, 'text': "Goal crusher! You're unstoppable! 🏆", 'category': 'praise', 'context': 'general'},
    {'id': 10, 'text': "Daily goal reached! Champions only! 🏅", 'category': 'praise', 'context': 'general'},
    {'id': 11, 'text': "You're on fire! Keep the momentum! 🔥", 'category': 'praise', 'context': 'general'},
    {'id': 12, 'text': "Fantastic progress! Bear is so proud! 🐻", 'category': 'praise', 'context': 'general'},
    {'id': 13, 'text': "Streak continues! You're a machine! ⚙️", 'category': 'praise', 'context': 'streak'},
    {'id': 14, 'text': "7 days strong! Legend status! 👑", 'category': 'praise', 'context': 'streak'},
    {'id': 15, 'text': "Consistency king! Bow to the master! 🤴", 'category': 'praise', 'context': 'streak'},
    {'id': 16, 'text': "Marathon mode! One step at a time! 🏃", 'category': 'praise', 'context': 'fasting'},
    {'id': 17, 'text': "Fasting warrior! Mind over hunger! 🧠", 'category': 'praise', 'context': 'fasting'},
    {'id': 18, 'text': "Hours flying by! You're doing amazing! ⏰", 'category': 'praise', 'context': 'fasting'},
    {'id': 19, 'text': "Calorie deficit achieved! Science works! 🔬", 'category': 'praise', 'context': 'calories'},
    {'id': 20, 'text': "Under budget! Smart eating! 🧠", 'category': 'praise', 'context': 'calories'},
    {'id': 21, 'text': "Macros nailed! Nutrition master! 🎯", 'category': 'praise', 'context': 'nutrition'},
    {'id': 22, 'text': "Protein packed! Muscles growing! 💪", 'category': 'praise', 'context': 'nutrition'},
    {'id': 23, 'text': "Fats in check! Balance achieved! ⚖️", 'category': 'praise', 'context': 'nutrition'},
    {'id': 24, 'text': "Carbs controlled! Steady energy! ⚡", 'category': 'praise', 'context': 'nutrition'},
    {'id': 25, 'text': "New personal best! Bear is cheering! 📣", 'category': 'praise', 'context': 'general'},
    
    // ===== 伴眠类 (Sleep Aid - 25条) =====
    {'id': 26, 'text': "Sweet dreams! Your bear is tucked in too! 😴", 'category': 'sleep', 'context': 'night'},
    {'id': 27, 'text': "Time to rest. Tomorrow is a new day! 🌙", 'category': 'sleep', 'context': 'night'},
    {'id': 28, 'text': "Cozy time! Let the stars watch over you! ⭐", 'category': 'sleep', 'context': 'night'},
    {'id': 29, 'text': "Sleep tight! Bear's dreaming of you! 🌟", 'category': 'sleep', 'context': 'night'},
    {'id': 30, 'text': "Night night! Rest those tired muscles! 💤", 'category': 'sleep', 'context': 'night'},
    {'id': 31, 'text': "Fasting progress saved! Your body is healing! 🌱", 'category': 'sleep', 'context': 'fasting_night'},
    {'id': 32, 'text': "While you sleep, magic happens! ✨", 'category': 'sleep', 'context': 'fasting_night'},
    {'id': 33, 'text': "Autophagy activated! Cellular cleanup! 🧹", 'category': 'sleep', 'context': 'fasting_night'},
    {'id': 34, 'text': "Sweet fasting dreams! Your bear is meditating! 🧘", 'category': 'sleep', 'context': 'fasting_night'},
    {'id': 35, 'text': "Rest well, warrior! Recovery mode on! 💆", 'category': 'sleep', 'context': 'fasting_night'},
    {'id': 36, 'text': "Deep breaths... You're doing great! 🌊", 'category': 'sleep', 'context': 'stress'},
    {'id': 37, 'text': "One day at a time. Breathe in, breathe out! 🌬️", 'category': 'sleep', 'context': 'stress'},
    {'id': 38, 'text': "Progress over perfection! You've got this! 💝", 'category': 'sleep', 'context': 'stress'},
    {'id': 39, 'text': "Be gentle with yourself tonight! 🌸", 'category': 'sleep', 'context': 'stress'},
    {'id': 40, 'text': "The bear believes in you! Always! 🐻", 'category': 'sleep', 'context': 'stress'},
    {'id': 41, 'text': "Zzz... Fat burning while you rest! 🔥", 'category': 'sleep', 'context': 'fasting_night'},
    {'id': 42, 'text': "Sleep is the best recovery! 📈", 'category': 'sleep', 'context': 'general'},
    {'id': 43, 'text': "8 hours ahead! Wake up refreshed! ☀️", 'category': 'sleep', 'context': 'general'},
    {'id': 44, 'text': "Dream big! Tomorrow's goals await! 🎯", 'category': 'sleep', 'context': 'general'},
    {'id': 45, 'text': "Sleep tight, champion! 🌙✨", 'category': 'sleep', 'context': 'general'},
    {'id': 46, 'text': "Your bear is on standby mode! 🛋️", 'category': 'sleep', 'context': 'general'},
    {'id': 47, 'text': "Rest now, conquer later! 💪", 'category': 'sleep', 'context': 'general'},
    {'id': 48, 'text': "Moonlight mode: activated! 🌕", 'category': 'sleep', 'context': 'general'},
    {'id': 49, 'text': "Sleep + fasting = supercharge! ⚡", 'category': 'sleep', 'context': 'fasting_night'},
    {'id': 50, 'text': "Bear is running on low power mode! 😴", 'category': 'sleep', 'context': 'general'},
    
    // ===== 毒舌类 (Tough Love - 20条) =====
    {'id': 51, 'text': "No excuses! Track it or it didn't happen! 📝", 'category': 'tough', 'context': 'general'},
    {'id': 52, 'text': "The scale doesn't lie, but neither does effort! ⚖️", 'category': 'tough', 'context': 'general'},
    {'id': 53, 'text': "Choose discipline over comfort! 💪", 'category': 'tough', 'context': 'general'},
    {'id': 54, 'text': "Excuses don't burn calories! 🔥", 'category': 'tough', 'context': 'general'},
    {'id': 55, 'text': "Your future self will thank you! Or curse you! ⏰", 'category': 'tough', 'context': 'general'},
    {'id': 56, 'text': "No water logged? Bear is disappointed! 😔", 'category': 'tough', 'context': 'water'},
    {'id': 57, 'text': "Hydration check failed! Drink up! 💧", 'category': 'tough', 'context': 'water'},
    {'id': 58, 'text': "Water reminder: your 5th today! 📢", 'category': 'tough', 'context': 'water'},
    {'id': 59, 'text': "Where did the food log go? 📝", 'category': 'tough', 'context': 'food'},
    {'id': 60, 'text': "Logging is caring! Track that snack! 🍪", 'category': 'tough', 'context': 'food'},
    {'id': 61, 'text': "Skipped breakfast? Bear's hungry stare! 👀", 'category': 'tough', 'context': 'food'},
    {'id': 62, 'text': "Fasting window closing! Get focused! 🎯", 'category': 'tough', 'context': 'fasting'},
    {'id': 63, 'text': "No cheats during fasting! Stay strong! 🦾", 'category': 'tough', 'context': 'fasting'},
    {'id': 64, 'text': "Halfway there! Don't quit now! 🏃", 'category': 'tough', 'context': 'fasting'},
    {'id': 65, 'text': "Cico math: 5 minutes of planning = results! 📊", 'category': 'tough', 'context': 'calories'},
    {'id': 66, 'text': "Calories over? No snacks zone! 🚫", 'category': 'tough', 'context': 'calories'},
    {'id': 67, 'text': "Tracking > Guessing > Wishful thinking! 📈", 'category': 'tough', 'context': 'general'},
    {'id': 68, 'text': "Weekend warrior mode: activated! Let's go! ⚔️", 'category': 'tough', 'context': 'general'},
    {'id': 69, 'text': "Every meal logged is a win! 🏆", 'category': 'tough', 'context': 'general'},
    {'id': 70, 'text': "No perfect days, only better days! Keep going! 📈", 'category': 'tough', 'context': 'general'},
    
    // ===== 专业类 (Professional - 15条) =====
    {'id': 71, 'text': "BMR calculated: Your body burns X calories at rest! 🔬", 'category': 'professional', 'context': 'bmr'},
    {'id': 72, 'text': "TDEE updated: Activity level factored in! 📊", 'category': 'professional', 'context': 'tdee'},
    {'id': 73, 'text': "Calorie deficit: Science-backed weight loss! ⚗️", 'category': 'professional', 'context': 'calories'},
    {'id': 74, 'text': "Macronutrient ratio optimized for your goal! ⚖️", 'category': 'professional', 'context': 'nutrition'},
    {'id': 75, 'text': "Water intake: 2.5L recommended for optimal hydration! 💧", 'category': 'professional', 'context': 'water'},
    {'id': 76, 'text': "Intermittent fasting: 16:8 is your current protocol! ⏰", 'category': 'professional', 'context': 'fasting'},
    {'id': 77, 'text': "Autophagy begins after 14 hours of fasting! 🧬", 'category': 'professional', 'context': 'fasting'},
    {'id': 78, 'text': "BMI calculated: ${"{bmi}"} - Normal range confirmed! 📏", 'category': 'professional', 'context': 'metrics'},
    {'id': 79, 'text': "Weekly weight trend: Down 0.5kg avg! 📉", 'category': 'professional', 'context': 'progress'},
    {'id': 80, 'text': "Goal weight projected: ${"{weeks}"} weeks to go! 🎯", 'category': 'professional', 'context': 'progress'},
    {'id': 81, 'text': "Protein intake: ${"{protein}g"} for muscle preservation! 💪", 'category': 'professional', 'context': 'nutrition'},
    {'id': 82, 'text': "Fiber goal: 25g/day for gut health! 🌾", 'category': 'professional', 'context': 'nutrition'},
    {'id': 83, 'text': "Sleep optimization: 7-9 hours recommended! 😴", 'category': 'professional', 'context': 'general'},
    {'id': 84, 'text': "Step count: 10,000 steps/day for fat burning! 🚶", 'category': 'professional', 'context': 'general'},
    {'id': 85, 'text': "NEAT boost: Non-exercise activity adds up! 🏃", 'category': 'professional', 'context': 'general'},
    
    // ===== 甜系类 (Sweet - 15条) =====
    {'id': 86, 'text': "You light up the app! ✨ Bear loves you! 💕", 'category': 'sweet', 'context': 'general'},
    {'id': 87, 'text': "Looking fabulous today! Keep glowing! ✨", 'category': 'sweet', 'context': 'general'},
    {'id': 88, 'text': "Bear gives you a big hug! 🐻💕", 'category': 'sweet', 'context': 'general'},
    {'id': 89, 'text': "You're the sweetest thing in bear's life! 🍯", 'category': 'sweet', 'context': 'general'},
    {'id': 90, 'text': "Goals? Met! Beauty? Unlocked! ✨", 'category': 'sweet', 'context': 'general'},
    {'id': 91, 'text': "Bear doing happy paws! You're amazing! 🐾", 'category': 'sweet', 'context': 'general'},
    {'id': 92, 'text': "Sending you wellness vibes! 🌸💆", 'category': 'sweet', 'context': 'stress'},
    {'id': 93, 'text': "Self-care reminder: You deserve a break! ☕", 'category': 'sweet', 'context': 'stress'},
    {'id': 94, 'text': "Be kind to yourself today! You're doing great! 💝", 'category': 'sweet', 'context': 'stress'},
    {'id': 95, 'text': "Breathe. You're doing enough. 💆", 'category': 'sweet', 'context': 'stress'},
    {'id': 96, 'text': "Bear hearts your progress! ❤️🐻", 'category': 'sweet', 'context': 'general'},
    {'id': 97, 'text': "You're a star, shining bright! ⭐", 'category': 'sweet', 'context': 'general'},
    {'id': 98, 'text': "Dream it, track it, achieve it! 🌈", 'category': 'sweet', 'context': 'general'},
    {'id': 99, 'text': "Bear's tail is wagging for you! 🐕", 'category': 'sweet', 'context': 'general'},
    {'id': 100, 'text': "Together we thrive! Thank you for being here! 💖", 'category': 'sweet', 'context': 'general'},
  ];
  
  // ===== Get Quote by Context =====
  
  String getQuote({
    required String context,
    List<String>? allowedCategories,
  }) {
    // Filter by context and category
    var candidates = _quotes.where((q) => q['context'] == context).toList();
    
    if (allowedCategories != null && allowedCategories.isNotEmpty) {
      candidates = candidates.where((q) => 
        allowedCategories.contains(q['category'])).toList();
    }
    
    // Remove already used
    candidates = candidates.where((q) => 
      !_usedIds.contains(q['id'])).toList();
    
    // Fallback if all used
    if (candidates.isEmpty) {
      candidates = _quotes.where((q) => q['context'] == context).toList();
      candidates.shuffle();
    }
    
    if (candidates.isEmpty) return "You're doing great! 🌟";
    
    // Pick random
    final quote = candidates[DateTime.now().millisecond % candidates.length];
    _usedIds.add(quote['id'] as int);
    
    return quote['text'] as String;
  }
  
  // ===== Context-specific getters =====
  
  String getWaterQuote() => getQuote(context: 'water', allowedCategories: ['praise', 'sweet']);
  String getFoodQuote() => getQuote(context: 'food', allowedCategories: ['praise', 'tough']);
  String getFastingQuote({bool isNight = false}) => getQuote(
    context: isNight ? 'fasting_night' : 'fasting',
    allowedCategories: isNight ? ['sleep', 'professional'] : ['praise', 'professional'],
  );
  String getSleepQuote({bool isFasting = false}) => getQuote(
    context: isFasting ? 'fasting_night' : 'night',
    allowedCategories: ['sleep', 'sweet'],
  );
  String getMotivationQuote() => getQuote(context: 'general', allowedCategories: ['tough', 'praise']);
  String getSweetQuote() => getQuote(context: 'general', allowedCategories: ['sweet']);
  String getProfessionalQuote() => getQuote(context: 'general', allowedCategories: ['professional']);
  
  // ===== Reset =====
  
  void resetUsedQuotes() {
    _usedIds.clear();
  }
}
