import 'dart:convert';
import 'dart:math';

/// AI Vision Intelligence - 多模态营养精算引擎
/// 不仅识别食物，还要估算克数、拆解营养素、反馈给宠物调整光晕
class VisionIntelligence {
  static VisionIntelligence? _instance;
  static VisionIntelligence get instance => 
      _instance ??= VisionIntelligence._();
  VisionIntelligence._();

  final Random _random = Random();

  // ================== 食物数据库 ==================
  
  /// 常见食物营养库 (每100g)
  static const Map<String, FoodNutrition> _foodDatabase = {
    'pizza': FoodNutrition(
      name: '披萨',
      caloriesPer100g: 266,
      proteinPer100g: 11,
      carbsPer100g: 33,
      fatPer100g: 10,
      density: 0.6, // 密度系数 (用于体积估算)
    ),
    'burger': FoodNutrition(
      name: '汉堡',
      caloriesPer100g: 295,
      proteinPer100g: 15,
      carbsPer100g: 24,
      fatPer100g: 14,
      density: 0.8,
    ),
    'salad': FoodNutrition(
      name: '沙拉',
      caloriesPer100g: 20,
      proteinPer100g: 1.5,
      carbsPer100g: 3,
      fatPer100g: 0.3,
      density: 0.3,
    ),
    'rice': FoodNutrition(
      name: '米饭',
      caloriesPer100g: 130,
      proteinPer100g: 2.7,
      carbsPer100g: 28,
      fatPer100g: 0.3,
      density: 0.9,
    ),
    'noodle': FoodNutrition(
      name: '面条',
      caloriesPer100g: 138,
      proteinPer100g: 4.5,
      carbsPer100g: 25,
      fatPer100g: 1.1,
      density: 0.7,
    ),
    'chicken': FoodNutrition(
      name: '鸡肉',
      caloriesPer100g: 165,
      proteinPer100g: 31,
      carbsPer100g: 0,
      fatPer100g: 3.6,
      density: 1.0,
    ),
    'fish': FoodNutrition(
      name: '鱼肉',
      caloriesPer100g: 90,
      proteinPer100g: 20,
      carbsPer100g: 0,
      fatPer100g: 1,
      density: 0.95,
    ),
    'egg': FoodNutrition(
      name: '鸡蛋',
      caloriesPer100g: 155,
      proteinPer100g: 13,
      carbsPer100g: 1.1,
      fatPer100g: 11,
      density: 1.0,
    ),
    'vegetable': FoodNutrition(
      name: '蔬菜',
      caloriesPer100g: 25,
      proteinPer100g: 1.5,
      carbsPer100g: 5,
      fatPer100g: 0.2,
      density: 0.25,
    ),
    'fruit': FoodNutrition(
      name: '水果',
      caloriesPer100g: 50,
      proteinPer100g: 0.5,
      carbsPer100g: 12,
      fatPer100g: 0.2,
      density: 0.6,
    ),
    'bread': FoodNutrition(
      name: '面包',
      caloriesPer100g: 265,
      proteinPer100g: 9,
      carbsPer100g: 49,
      fatPer100g: 3.2,
      density: 0.5,
    ),
    'rice_bowl': FoodNutrition(
      name: '米饭套餐',
      caloriesPer100g: 150,
      proteinPer100g: 5,
      carbsPer100g: 28,
      fatPer100g: 2,
      density: 0.85,
    ),
    'hotpot': FoodNutrition(
      name: '火锅',
      caloriesPer100g: 180,
      proteinPer100g: 12,
      carbsPer100g: 8,
      fatPer100g: 11,
      density: 0.9,
    ),
    'sushi': FoodNutrition(
      name: '寿司',
      caloriesPer100g: 140,
      proteinPer100g: 6,
      carbsPer100g: 24,
      fatPer100g: 2,
      density: 0.7,
    ),
    'dessert': FoodNutrition(
      name: '甜点',
      caloriesPer100g: 350,
      proteinPer100g: 4,
      carbsPer100g: 45,
      fatPer100g: 18,
      density: 0.5,
    ),
    'coffee': FoodNutrition(
      name: '咖啡',
      caloriesPer100g: 4,
      proteinPer100g: 0.3,
      carbsPer100g: 0,
      fatPer100g: 0.1,
      density: 1.0,
    ),
    'bubble_tea': FoodNutrition(
      name: '奶茶',
      caloriesPer100g: 75,
      proteinPer100g: 0.5,
      carbsPer100g: 15,
      fatPer100g: 2,
      density: 0.8,
    ),
    'default': FoodNutrition(
      name: '混合食物',
      caloriesPer100g: 200,
      proteinPer100g: 8,
      carbsPer100g: 25,
      fatPer100g: 8,
      density: 0.7,
    ),
  };

  // ================== 多模态识别 ==================

  /// 识别食物并计算营养
  /// [imageBase64] - 图片base64编码
  /// [userContext] - 用户上下文 (可选)
  Future<VisionAnalysisResult> analyzeFood({
    required String imageBase64,
    Map<String, dynamic>? userContext,
  }) async {
    // 模拟多模态API调用
    await Future.delayed(const Duration(milliseconds: 800));

    // 模拟图片分析
    final detectedFoods = _simulateFoodDetection();
    final estimatedGrams = _estimatePortionSize(detectedFoods);
    
    // 计算营养素
    final nutritionResult = _calculateNutrition(
      foods: detectedFoods,
      grams: estimatedGrams,
    );

    // 计算 Aura Score
    final auraScore = _calculateAuraScore(nutritionResult);

    // 生成小熊反馈
    final petReaction = _generatePetReaction(auraScore, detectedFoods);

    return VisionAnalysisResult(
      foods: detectedFoods,
      estimatedGrams: estimatedGrams,
      nutrition: nutritionResult,
      auraScore: auraScore,
      petReaction: petReaction,
      timestamp: DateTime.now(),
    );
  }

  /// 模拟食物检测 (实际项目中替换为真实API)
  List<DetectedFood> _simulateFoodDetection() {
    // 随机选择1-3种食物
    final foodTypes = _foodDatabase.keys
        .where((k) => k != 'default')
        .toList()
      ..shuffle(_random);
    
    final count = 1 + _random.nextInt(3);
    final results = <DetectedFood>[];

    for (int i = 0; i < count && i < foodTypes.length; i++) {
      final foodType = foodTypes[i];
      final nutrition = _foodDatabase[foodType]!;
      final confidence = 0.7 + _random.nextDouble() * 0.3;

      results.add(DetectedFood(
        type: foodType,
        name: nutrition.name,
        confidence: confidence,
        boundingBox: _generateBoundingBox(),
      ));
    }

    return results;
  }

  /// 根据图片特征估算份量 (模拟)
  int _estimatePortionSize(List<DetectedFood> foods) {
    // 基础份量估算
    int basePortion = 150; // 默认150g

    // 根据食物类型调整
    for (final food in foods) {
      final nutrition = _foodDatabase[food.type] ?? _foodDatabase['default']!;
      
      // 高密度食物 → 估算更重
      if (nutrition.density > 0.8) {
        basePortion += 80;
      } else if (nutrition.density < 0.5) {
        basePortion -= 30;
      }
    }

    // 多种食物混合 → 总份量增加
    if (foods.length > 1) {
      basePortion = (basePortion * (1 + foods.length * 0.15)).toInt();
    }

    return basePortion.clamp(80, 600);
  }

  /// 计算营养素
  NutritionCalculation _calculateNutrition({
    required List<DetectedFood> foods,
    required int totalGrams,
  }) {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    // 按份量比例分配
    for (final food in foods) {
      final nutrition = _foodDatabase[food.type] ?? _foodDatabase['default']!;
      final ratio = totalGrams / 100;

      totalCalories += nutrition.caloriesPer100g * ratio;
      totalProtein += nutrition.proteinPer100g * ratio;
      totalCarbs += nutrition.carbsPer100g * ratio;
      totalFat += nutrition.fatPer100g * ratio;
    }

    return NutritionCalculation(
      calories: totalCalories,
      protein: totalProtein,
      carbs: totalCarbs,
      fat: totalFat,
      fiber: totalCarbs * 0.1, // 估算纤维
      sugar: totalCarbs * 0.15, // 估算糖分
      sodium: totalCalories * 0.5, // 估算钠
    );
  }

  /// 计算 Aura Score
  int _calculateAuraScore(NutritionCalculation nutrition) {
    double score = 70; // 基础分

    // 蛋白质评分 (优质蛋白加分)
    if (nutrition.protein >= 20) {
      score += 15;
    } else if (nutrition.protein >= 10) {
      score += 8;
    } else if (nutrition.protein < 5) {
      score -= 10;
    }

    // 碳水评分 (适量碳水加分，过高减分)
    final carbRatio = nutrition.carbs / nutrition.calories * 4;
    if (carbRatio >= 0.4 && carbRatio <= 0.55) {
      score += 10;
    } else if (carbRatio > 0.65) {
      score -= 15;
    }

    // 脂肪评分 (适量健康脂肪加分)
    final fatRatio = nutrition.fat / nutrition.calories * 9;
    if (fatRatio >= 0.25 && fatRatio <= 0.35) {
      score += 8;
    } else if (fatRatio > 0.45) {
      score -= 12;
    }

    // 卡路里评分
    if (nutrition.calories <= 500) {
      score += 5;
    } else if (nutrition.calories > 800) {
      score -= 10;
    }

    return score.clamp(0, 100).toInt();
  }

  /// 生成小熊反应
  PetVisionReaction _generatePetReaction(int auraScore, List<DetectedFood> foods) {
    String reaction;
    String mood;
    Color glowColor;
    double glowIntensity;

    if (auraScore >= 85) {
      reaction = '太棒了！这顿饭营养满分！';
      mood = 'celebrating';
      glowColor = const Color(0xFFFFD700);
      glowIntensity = 0.9;
    } else if (auraScore >= 70) {
      reaction = '还不错哦，继续保持~';
      mood = 'happy';
      glowColor = const Color(0xFFFFE4B5);
      glowIntensity = 0.7;
    } else if (auraScore >= 50) {
      reaction = '可以再优化一下营养搭配~';
      mood = 'neutral';
      glowColor = const Color(0xFFFFAB76);
      glowIntensity = 0.5;
    } else {
      reaction = '小熊建议下次吃点更健康的~';
      mood = 'sleepy';
      glowColor = const Color(0xFFB5D0FF);
      glowIntensity = 0.4;
    }

    return PetVisionReaction(
      reaction: reaction,
      mood: mood,
      glowColor: glowColor,
      glowIntensity: glowIntensity,
    );
  }

  /// 生成边界框
  Map<String, double> _generateBoundingBox() {
    return {
      'x': _random.nextDouble() * 0.4,
      'y': _random.nextDouble() * 0.4,
      'width': 0.2 + _random.nextDouble() * 0.3,
      'height': 0.2 + _random.nextDouble() * 0.3,
    };
  }
}

/// 食物营养数据
class FoodNutrition {
  final String name;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final double density;

  const FoodNutrition({
    required this.name,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    required this.density,
  });
}

/// 检测到的食物
class DetectedFood {
  final String type;
  final String name;
  final double confidence;
  final Map<String, double> boundingBox;

  const DetectedFood({
    required this.type,
    required this.name,
    required this.confidence,
    required this.boundingBox,
  });
}

/// 营养计算结果
class NutritionCalculation {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double sugar;
  final double sodium;

  const NutritionCalculation({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sugar,
    required this.sodium,
  });

  Map<String, dynamic> toJson() => {
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
    'fiber': fiber,
    'sugar': sugar,
    'sodium': sodium,
  };
}

/// 视觉分析结果
class VisionAnalysisResult {
  final List<DetectedFood> foods;
  final int estimatedGrams;
  final NutritionCalculation nutrition;
  final int auraScore;
  final PetVisionReaction petReaction;
  final DateTime timestamp;

  const VisionAnalysisResult({
    required this.foods,
    required this.estimatedGrams,
    required this.nutrition,
    required this.auraScore,
    required this.petReaction,
    required this.timestamp,
  });

  /// 转为API响应格式
  Map<String, dynamic> toApiResponse() => {
    'foods': foods.map((f) => {
      'type': f.type,
      'name': f.name,
      'confidence': f.confidence,
      'boundingBox': f.boundingBox,
    }).toList(),
    'estimatedGrams': estimatedGrams,
    'nutrition': nutrition.toJson(),
    'auraScore': auraScore,
    'petReaction': {
      'reaction': petReaction.reaction,
      'mood': petReaction.mood,
      'glowColor': petReaction.glowColor.value,
      'glowIntensity': petReaction.glowIntensity,
    },
    'timestamp': timestamp.toIso8601String(),
  };
}

/// 小熊视觉反应
class PetVisionReaction {
  final String reaction;
  final String mood;
  final Color glowColor;
  final double glowIntensity;

  const PetVisionReaction({
    required this.reaction,
    required this.mood,
    required this.glowColor,
    required this.glowIntensity,
  });
}

// Color类 (Flutter简化)
class Color {
  final int value;
  const Color(this.value);
}
