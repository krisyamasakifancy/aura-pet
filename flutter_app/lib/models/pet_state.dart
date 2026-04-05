/// ============================================
// AURA-PET: 数据模型
/// ============================================

class PetState {
  final String name;
  final int level;
  final int xp;
  final int xpToNext;
  final int coins;
  final int joy; // 0-100
  final int fullness; // 0-100
  final int waterIntake;
  final int waterGoal;
  final int streak;
  final int mealsToday;
  final String mood;
  final double nutritionBalance; // -1 到 1，影响颜色
  final DateTime lastFed;
  final String? equippedItem;
  final String evolutionStage; // 幼年期/成长期/完全体

  PetState({
    this.name = '毛毛',
    this.level = 1,
    this.xp = 0,
    this.xpToNext = 100,
    this.coins = 100,
    this.joy = 80,
    this.fullness = 70,
    this.waterIntake = 0,
    this.waterGoal = 2000,
    this.streak = 0,
    this.mealsToday = 0,
    this.mood = 'happy',
    this.nutritionBalance = 0,
    DateTime? lastFed,
    this.equippedItem,
    this.evolutionStage = '幼年期',
  }) : lastFed = lastFed ?? DateTime.now();

  PetState copyWith({
    String? name,
    int? level,
    int? xp,
    int? xpToNext,
    int? coins,
    int? joy,
    int? fullness,
    int? waterIntake,
    int? waterGoal,
    int? streak,
    int? mealsToday,
    String? mood,
    double? nutritionBalance,
    DateTime? lastFed,
    String? equippedItem,
    String? evolutionStage,
  }) {
    return PetState(
      name: name ?? this.name,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      xpToNext: xpToNext ?? this.xpToNext,
      coins: coins ?? this.coins,
      joy: joy ?? this.joy,
      fullness: fullness ?? this.fullness,
      waterIntake: waterIntake ?? this.waterIntake,
      waterGoal: waterGoal ?? this.waterGoal,
      streak: streak ?? this.streak,
      mealsToday: mealsToday ?? this.mealsToday,
      mood: mood ?? this.mood,
      nutritionBalance: nutritionBalance ?? this.nutritionBalance,
      lastFed: lastFed ?? this.lastFed,
      equippedItem: equippedItem ?? this.equippedItem,
      evolutionStage: evolutionStage ?? this.evolutionStage,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'level': level,
        'xp': xp,
        'xpToNext': xpToNext,
        'coins': coins,
        'joy': joy,
        'fullness': fullness,
        'waterIntake': waterIntake,
        'waterGoal': waterGoal,
        'streak': streak,
        'mealsToday': mealsToday,
        'mood': mood,
        'nutritionBalance': nutritionBalance,
        'lastFed': lastFed.toIso8601String(),
        'equippedItem': equippedItem,
        'evolutionStage': evolutionStage,
      };

  factory PetState.fromJson(Map<String, dynamic> json) => PetState(
        name: json['name'] ?? '毛毛',
        level: json['level'] ?? 1,
        xp: json['xp'] ?? 0,
        xpToNext: json['xpToNext'] ?? 100,
        coins: json['coins'] ?? 100,
        joy: json['joy'] ?? 80,
        fullness: json['fullness'] ?? 70,
        waterIntake: json['waterIntake'] ?? 0,
        waterGoal: json['waterGoal'] ?? 2000,
        streak: json['streak'] ?? 0,
        mealsToday: json['mealsToday'] ?? 0,
        mood: json['mood'] ?? 'happy',
        nutritionBalance: (json['nutritionBalance'] ?? 0).toDouble(),
        lastFed: json['lastFed'] != null
            ? DateTime.parse(json['lastFed'])
            : DateTime.now(),
        equippedItem: json['equippedItem'],
        evolutionStage: json['evolutionStage'] ?? '幼年期',
      );
}

class MealRecord {
  final String foodName;
  final String emoji;
  final int calories;
  final String anxietyLabel;
  final List<String> phrases;
  final DateTime timestamp;
  final int coinsEarned;
  final int xpEarned;

  MealRecord({
    required this.foodName,
    required this.emoji,
    required this.calories,
    required this.anxietyLabel,
    required this.phrases,
    required this.timestamp,
    required this.coinsEarned,
    required this.xpEarned,
  });

  Map<String, dynamic> toJson() => {
        'foodName': foodName,
        'emoji': emoji,
        'calories': calories,
        'anxietyLabel': anxietyLabel,
        'phrases': phrases,
        'timestamp': timestamp.toIso8601String(),
        'coinsEarned': coinsEarned,
        'xpEarned': xpEarned,
      };

  factory MealRecord.fromJson(Map<String, dynamic> json) => MealRecord(
        foodName: json['foodName'],
        emoji: json['emoji'],
        calories: json['calories'],
        anxietyLabel: json['anxietyLabel'],
        phrases: List<String>.from(json['phrases']),
        timestamp: DateTime.parse(json['timestamp']),
        coinsEarned: json['coinsEarned'],
        xpEarned: json['xpEarned'],
      );
}

class ShopItem {
  final String id;
  final String name;
  final String emoji;
  final String category; // accessories, backgrounds, effects
  final int price;
  final String description;
  final bool isOwned;
  final bool isEquipped;

  ShopItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.category,
    required this.price,
    required this.description,
    this.isOwned = false,
    this.isEquipped = false,
  });

  ShopItem copyWith({
    bool? isOwned,
    bool? isEquipped,
  }) {
    return ShopItem(
      id: id,
      name: name,
      emoji: emoji,
      category: category,
      price: price,
      description: description,
      isOwned: isOwned ?? this.isOwned,
      isEquipped: isEquipped ?? this.isEquipped,
    );
  }
}
