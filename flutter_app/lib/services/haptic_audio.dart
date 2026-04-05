import 'package:flutter/services.dart';

/// 情感化触觉反馈系统
/// 让每一次交互都变成一次减压体验
class HapticEngine {
  static HapticEngine? _instance;
  static HapticEngine get instance => _instance ??= HapticEngine._();
  HapticEngine._();

  // ================== 震动模式 ==================

  /// 心跳感震动 - 用于激励语料
  /// 特点：双击震动，模拟心跳
  Future<void> heartbeat() async {
    await HapticFeedback.lightImpact(); // 第一次心跳
    await Future.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.lightImpact(); // 第二次心跳
  }

  /// 微风拂过震动 - 用于去焦虑语料
  /// 特点：轻柔持续的微震
  Future<void> gentleBreeze() async {
    await HapticFeedback.selectionClick();
  }

  /// 泡泡破裂震动 - 用于喝水提醒
  /// 特点：短促轻快
  Future<void> bubblePop() async {
    await HapticFeedback.mediumImpact();
  }

  /// 羽毛飘落震动 - 用于完成动作
  /// 特点：极其轻柔
  Future<void> featherFall() async {
    await HapticFeedback.selectionClick();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.selectionClick();
  }

  /// 成就解锁震动 - 用于达成里程碑
  /// 特点：有力且有节奏
  Future<void> achievementUnlock() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.lightImpact();
  }

  /// 连续打卡震动 - 用于激励连续行为
  /// 特点：三连击
  Future<void> streak() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 60));
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 60));
    await HapticFeedback.mediumImpact();
  }

  /// 摸头震动 - 用于深度交互
  /// 特点：四段式触控反馈
  Future<void> petHead() async {
    // 触碰
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    // 压缩
    await HapticFeedback.selectionClick();
    await Future.delayed(const Duration(milliseconds: 80));
    // 回弹
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 30));
    // 微颤
    await HapticFeedback.selectionClick();
  }

  /// 按压反馈
  Future<void> buttonPress() async {
    await HapticFeedback.lightImpact();
  }

  /// 切换/滑动反馈
  Future<void> slide() async {
    await HapticFeedback.selectionClick();
  }

  /// 错误反馈
  Future<void> error() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.heavyImpact();
  }

  /// 成功反馈
  Future<void> success() async {
    await HapticFeedback.mediumImpact();
  }

  // ================== 语料分类震动匹配 ==================

  /// 根据语料分类匹配震动
  Future<void> triggerForCategory(String category) async {
    switch (category) {
      case 'food_peace':
        await gentleBreeze();
        break;
      case 'water_fasting':
        await bubblePop();
        break;
      case 'emotional_connection':
        await heartbeat();
        break;
      case 'achievement_motivation':
        await achievementUnlock();
        break;
      default:
        await featherFall();
    }
  }

  /// 根据语料ID匹配震动
  Future<void> triggerForQuote(int quoteId) async {
    // 前25条美食语料 → 轻柔安抚
    if (quoteId <= 25) {
      await gentleBreeze();
    }
    // 26-50条喝水语料 → 清脆提醒
    else if (quoteId <= 50) {
      await bubblePop();
    }
    // 51-75条情感语料 → 温柔心跳
    else if (quoteId <= 75) {
      await heartbeat();
    }
    // 76-100条激励语料 → 成就震动
    else {
      await achievementUnlock();
    }
  }
}

/// 音效类型枚举
enum SoundType {
  // UI 交互音效
  buttonTap,
  switchToggle,
  success,
  error,
  
  // 功能音效
  waterDrink,
  mealLog,
  achievement,
  streak,
  
  // 语料气泡音效
  quoteAppear,
  quoteDismiss,
  
  // 宠物交互音效
  petHappy,
  petSleep,
  petEat,
}

/// 音效包管理器
/// 预置极简空灵音效
class AudioPackage {
  static AudioPackage? _instance;
  static AudioPackage get instance => _instance ??= AudioPackage._();
  AudioPackage._();

  bool _enabled = true;
  bool get enabled => _enabled;
  
  void setEnabled(bool value) {
    _enabled = value;
  }

  // ================== 音效播放 ==================

  /// 播放音效
  /// 由于Flutter原生不支持直接播放音效，使用系统音效作为占位
  /// 实际项目中应集成 audioplayers 或 soundpool 包
  Future<void> play(SoundType type) async {
    if (!_enabled) return;
    
    switch (type) {
      case SoundType.buttonTap:
        await HapticFeedback.lightImpact();
        break;
      case SoundType.switchToggle:
        await HapticFeedback.selectionClick();
        break;
      case SoundType.success:
        await HapticEngine.instance.success();
        break;
      case SoundType.error:
        await HapticEngine.instance.error();
        break;
      case SoundType.waterDrink:
        await HapticEngine.instance.bubblePop();
        break;
      case SoundType.mealLog:
        await HapticEngine.instance.success();
        break;
      case SoundType.achievement:
        await HapticEngine.instance.achievementUnlock();
        break;
      case SoundType.streak:
        await HapticEngine.instance.streak();
        break;
      case SoundType.quoteAppear:
        await HapticEngine.instance.featherFall();
        break;
      case SoundType.quoteDismiss:
        await HapticEngine.instance.gentleBreeze();
        break;
      case SoundType.petHappy:
        await HapticEngine.instance.heartbeat();
        break;
      case SoundType.petSleep:
        await HapticEngine.instance.featherFall();
        break;
      case SoundType.petEat:
        await HapticEngine.instance.bubblePop();
        break;
    }
  }

  /// 语料气泡出现音效
  Future<void> quoteAppear() => play(SoundType.quoteAppear);
  
  /// 语料气泡消失音效
  Future<void> quoteDismiss() => play(SoundType.quoteDismiss);
  
  /// 喝水音效
  Future<void> waterDrink() => play(SoundType.waterDrink);
  
  /// 记录饮食音效
  Future<void> mealLog() => play(SoundType.mealLog);
  
  /// 成就解锁音效
  Future<void> achievementUnlock() => play(SoundType.achievement);
}

/// 组合反馈系统
/// 同时触发触觉 + 音效
class CombinedFeedback {
  static CombinedFeedback? _instance;
  static CombinedFeedback get instance => 
      _instance ??= CombinedFeedback._();
  CombinedFeedback._();

  final HapticEngine _haptic = HapticEngine.instance;
  final AudioPackage _audio = AudioPackage.instance;

  /// 激励语料反馈
  Future<void> motivationalQuote() async {
    await Future.wait([
      _haptic.achievementUnlock(),
      _audio.quoteAppear(),
    ]);
  }

  /// 去焦虑语料反馈
  Future<void> calmingQuote() async {
    await Future.wait([
      _haptic.gentleBreeze(),
      _audio.quoteAppear(),
    ]);
  }

  /// 喝水反馈
  Future<void> waterDrink() async {
    await Future.wait([
      _haptic.bubblePop(),
      _audio.waterDrink(),
    ]);
  }

  /// 记录饮食反馈
  Future<void> logMeal() async {
    await Future.wait([
      _haptic.success(),
      _audio.mealLog(),
    ]);
  }

  /// 摸头交互反馈
  Future<void> petInteraction() async {
    await Future.wait([
      _haptic.petHead(),
      _audio.petHappy(),
    ]);
  }

  /// 达成成就反馈
  Future<void> achievement() async {
    await Future.wait([
      _haptic.achievementUnlock(),
      _audio.achievementUnlock(),
    ]);
  }
}
