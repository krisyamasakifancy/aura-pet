import 'package:flutter/material.dart';
import 'dart:async';

enum PetMood { happy, sad, hungry, sleepy, excited, diving, eating, celebrating }
enum PetAccessory { scarf, hat, bow, glasses, crown, backpack }

class PetState {
  final int level;
  final int xp;
  final int xpToNextLevel;
  final PetMood mood;
  final List<PetAccessory> accessories;
  final double breathPhase;
  final double glowIntensity;
  final int hearts;
  final int coins;

  const PetState({
    this.level = 1,
    this.xp = 0,
    this.xpToNextLevel = 100,
    this.mood = PetMood.happy,
    this.accessories = const [PetAccessory.scarf],
    this.breathPhase = 0.0,
    this.glowIntensity = 1.0,
    this.hearts = 3,
    this.coins = 100,
  });

  PetState copyWith({
    int? level,
    int? xp,
    int? xpToNextLevel,
    PetMood? mood,
    List<PetAccessory>? accessories,
    double? breathPhase,
    double? glowIntensity,
    int? hearts,
    int? coins,
  }) {
    return PetState(
      level: level ?? this.level,
      xp: xp ?? this.xp,
      xpToNextLevel: xpToNextLevel ?? this.xpToNextLevel,
      mood: mood ?? this.mood,
      accessories: accessories ?? this.accessories,
      breathPhase: breathPhase ?? this.breathPhase,
      glowIntensity: glowIntensity ?? this.glowIntensity,
      hearts: hearts ?? this.hearts,
      coins: coins ?? this.coins,
    );
  }

  double get xpProgress => xp / xpToNextLevel;
  String get moodEmoji => _moodToEmoji(mood);
  String get moodLabel => _moodToLabel(mood);

  static String _moodToEmoji(PetMood mood) {
    switch (mood) {
      case PetMood.happy: return '😊';
      case PetMood.sad: return '😢';
      case PetMood.hungry: return '🤤';
      case PetMood.sleepy: return '😴';
      case PetMood.excited: return '🤩';
      case PetMood.diving: return '🏊';
      case PetMood.eating: return '😋';
      case PetMood.celebrating: return '🎉';
    }
  }

  static String _moodToLabel(PetMood mood) {
    switch (mood) {
      case PetMood.happy: return '开心快乐';
      case PetMood.sad: return '有点难过';
      case PetMood.hungry: return '肚子饿了';
      case PetMood.sleepy: return '困了';
      case PetMood.excited: return '超级兴奋';
      case PetMood.diving: return '喝水ing';
      case PetMood.eating: return '吃东西中';
      case PetMood.celebrating: return '庆祝中';
    }
  }
}

class PetProvider extends ChangeNotifier {
  PetState _state = const PetState();
  Timer? _breathTimer;
  Timer? _moodTimer;
  bool _fastingActive = false;
  bool _waterGoalMet = false;

  PetState get state => _state;

  PetProvider() {
    _startBreathAnimation();
    _startMoodDecay();
  }

  void _startBreathAnimation() {
    _breathTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      _state = _state.copyWith(
        breathPhase: (_state.breathPhase + 0.05) % (3.14159 * 2),
      );
      notifyListeners();
    });
  }

  void _startMoodDecay() {
    _moodTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_state.mood == PetMood.excited || _state.mood == PetMood.celebrating) {
        _setMood(PetMood.happy);
      }
    });
  }

  void _setMood(PetMood mood) {
    _state = _state.copyWith(mood: mood);
    notifyListeners();
  }

  // ===== Fasting State Machine =====
  void startFasting() {
    _fastingActive = true;
    _setMood(PetMood.sleepy);
  }

  void stopFasting() {
    _fastingActive = false;
    addXp(50);
    _setMood(PetMood.celebrating);
    Future.delayed(const Duration(seconds: 3), () {
      if (_state.mood == PetMood.celebrating) {
        _setMood(PetMood.happy);
      }
    });
  }

  bool get isFasting => _fastingActive;

  // ===== Water State Machine =====
  void addWater(int glasses) {
    _waterGoalMet = glasses >= 8;
    if (_waterGoalMet) {
      _setMood(PetMood.diving);
      addCoins(10);
    }
  }

  void setMoodFromWater() {
    if (_waterGoalMet) {
      _setMood(PetMood.diving);
    }
  }

  // ===== Eating State Machine =====
  void startEating() {
    _setMood(PetMood.eating);
  }

  void finishEating({required int auraScore}) {
    _setMood(PetMood.happy);
    if (auraScore >= 80) {
      addXp(15);
      addCoins(5);
      _setMood(PetMood.excited);
    } else if (auraScore >= 50) {
      addXp(8);
      addCoins(3);
    } else {
      addXp(3);
      _setMood(PetMood.sad);
    }
  }

  // ===== XP & Leveling =====
  void addXp(int amount) {
    int newXp = _state.xp + amount;
    int newLevel = _state.level;
    int remainingXp = newXp;

    while (remainingXp >= _state.xpToNextLevel) {
      remainingXp -= _state.xpToNextLevel;
      newLevel++;
    }

    _state = _state.copyWith(
      xp: remainingXp,
      level: newLevel,
    );
    notifyListeners();
  }

  // ===== Coins =====
  void addCoins(int amount) {
    _state = _state.copyWith(coins: _state.coins + amount);
    notifyListeners();
  }

  bool spendCoins(int amount) {
    if (_state.coins < amount) return false;
    _state = _state.copyWith(coins: _state.coins - amount);
    notifyListeners();
    return true;
  }

  // ===== Accessories =====
  bool buyAccessory(PetAccessory accessory, int price) {
    if (_state.accessories.contains(accessory)) return false;
    if (!spendCoins(price)) return false;

    _state = _state.copyWith(
      accessories: [..._state.accessories, accessory],
    );
    notifyListeners();
    return true;
  }

  void equipAccessory(PetAccessory accessory) {
    if (!_state.accessories.contains(accessory)) return;
    // For MVP, all owned accessories are equipped
    notifyListeners();
  }

  // ===== Hearts =====
  void addHearts(int amount) {
    _state = _state.copyWith(hearts: _state.hearts + amount);
    notifyListeners();
  }

  bool useHeart() {
    if (_state.hearts <= 0) return false;
    _state = _state.copyWith(hearts: _state.hearts - 1);
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    _breathTimer?.cancel();
    _moodTimer?.cancel();
    super.dispose();
  }
}
