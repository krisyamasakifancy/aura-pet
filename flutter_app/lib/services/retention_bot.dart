import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quote_engine.dart';

/// 自动化留存系统 - 宠物思念通知机制
/// 当用户超过24小时未登录，发送情感化推送
class RetentionBot {
  static RetentionBot? _instance;
  static RetentionBot get instance => _instance ??= RetentionBot._();
  RetentionBot._();

  final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();
  
  Timer? _checkTimer;
  DateTime? _lastActiveTime;
  bool _isInitialized = false;

  // 触发阈值 (小时)
  static const int REMIND_AFTER_HOURS = 24;
  static const int URGENT_REMIND_HOURS = 48;
  static const int CRITICAL_REMIND_HOURS = 72;

  // ================== 初始化 ==================

  /// 初始化留存机器人
  Future<void> init() async {
    if (_isInitialized) return;

    // 初始化通知插件
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // 加载上次活跃时间
    await _loadLastActiveTime();

    // 启动定时检查
    _startPeriodicCheck();

    _isInitialized = true;
  }

  /// 加载上次活跃时间
  Future<void> _loadLastActiveTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('last_active_timestamp');
    if (timestamp != null) {
      _lastActiveTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else {
      _lastActiveTime = DateTime.now();
    }
  }

  /// 保存活跃时间
  Future<void> saveActiveTime() async {
    _lastActiveTime = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_active_timestamp', _lastActiveTime!.millisecondsSinceEpoch);
  }

  /// 启动定时检查
  void _startPeriodicCheck() {
    // 每小时检查一次
    _checkTimer?.cancel();
    _checkTimer = Timer.periodic(const Duration(hours: 1), (_) {
      _checkAndNotify();
    });
    
    // 立即检查一次
    _checkAndNotify();
  }

  /// 检查并通知
  Future<void> _checkAndNotify() async {
    if (_lastActiveTime == null) return;

    final hoursSinceActive = DateTime.now().difference(_lastActiveTime!).inHours;

    // 根据离线时长选择不同级别的提醒
    String category;
    int notificationId;

    if (hoursSinceActive >= CRITICAL_REMIND_HOURS) {
      category = 'critical';
      notificationId = 3;
    } else if (hoursSinceActive >= URGENT_REMIND_HOURS) {
      category = 'urgent';
      notificationId = 2;
    } else if (hoursSinceActive >= REMIND_AFTER_HOURS) {
      category = 'gentle';
      notificationId = 1;
    } else {
      return; // 不需要提醒
    }

    // 检查是否已经发送过这个级别的提醒
    final prefs = await SharedPreferences.getInstance();
    final lastNotifiedKey = 'last_notified_$category';
    final lastNotified = prefs.getInt(lastNotifiedKey);
    
    if (lastNotified != null) {
      final hoursSinceNotified = DateTime.now().millisecondsSinceEpoch - lastNotified;
      if (hoursSinceNotified < 24 * 60 * 60 * 1000) {
        return; // 24小时内已经提醒过
      }
    }

    // 发送提醒
    await _sendRetentionNotification(category, notificationId);

    // 记录提醒时间
    await prefs.setInt(lastNotifiedKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// 发送留存通知
  Future<void> _sendRetentionNotification(String category, int id) async {
    final content = _generateNotificationContent(category);

    const androidDetails = AndroidNotificationDetails(
      'retention_channel',
      '宠物思念提醒',
      channelDescription: '小熊想念你的提醒',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      styleInformation: BigTextStyleInformation(''),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id,
      content.title,
      content.body,
      details,
    );
  }

  /// 生成通知内容
  _NotificationContent _generateNotificationContent(String category) {
    // 根据类别从语料库选择不同风格的文案
    switch (category) {
      case 'gentle':
        // 温柔提醒
        return _NotificationContent(
          title: '🐻 小熊想你了...',
          body: QuoteEngine.instance.getQuote(trigger: 'long_idle'),
        );
      
      case 'urgent':
        // 稍微焦急
        final urgentQuotes = [
          '主人，你已经离开${_getHoursSinceActive()}小时了...',
          '花园里的睡莲开了，你再不回来我就要睡着了...',
          '小熊今天吃了好多好吃的，等你来一起分享~',
          '今天的Aura能量有点低，需要你来帮我充充电~',
        ];
        return _NotificationContent(
          title: '🌙 ${_getRandomPetName()}等你回来',
          body: urgentQuotes[DateTime.now().minute % urgentQuotes.length],
        );
      
      case 'critical':
        // 深情呼唤
        final criticalQuotes = [
          '主人...小熊有点难过，好久没见到你了...',
          '即使你不在，小熊也会一直等你哦...',
          '今天的晚霞很美，可惜没人陪小熊一起看...',
          '想你了，想你了，想你了...（小熊发动思念攻击）',
        ];
        return _NotificationContent(
          title: '💔 ${_getRandomPetName()}的思念',
          body: criticalQuotes[DateTime.now().hour % criticalQuotes.length],
        );
      
      default:
        return _NotificationContent(
          title: '🐻 小熊想念你',
          body: '快回来陪小熊一起健康生活吧~',
        );
    }
  }

  String _getHoursSinceActive() {
    if (_lastActiveTime == null) return '很久';
    final hours = DateTime.now().difference(_lastActiveTime!).inHours;
    return '$hours';
  }

  String _getRandomPetName() {
    final names = ['小熊', '宝贝', '主人', '你'];
    return names[DateTime.now().second % names.length];
  }

  /// 通知被点击回调
  void _onNotificationTapped(NotificationResponse response) {
    // 打开App
    // 实际项目中导航到首页
  }

  /// 停止检查
  void stop() {
    _checkTimer?.cancel();
    _checkTimer = null;
  }

  /// 请求通知权限
  Future<bool> requestPermission() async {
    final result = await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    return result ?? false;
  }

  // ================== 手动触发 ==================

  /// 手动触发一次提醒（用于测试）
  Future<void> triggerManualReminder() async {
    await _sendRetentionNotification('gentle', 100);
  }

  /// 获取用户离线时长
  String getOfflineDuration() {
    if (_lastActiveTime == null) return '未知';
    
    final duration = DateTime.now().difference(_lastActiveTime!);
    
    if (duration.inDays > 0) {
      return '${duration.inDays}天${duration.inHours % 24}小时';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}小时';
    } else {
      return '${duration.inMinutes}分钟';
    }
  }

  /// 是否需要提醒
  bool needsReminder() {
    if (_lastActiveTime == null) return false;
    return DateTime.now().difference(_lastActiveTime!).inHours >= REMIND_AFTER_HOURS;
  }
}

/// 通知内容
class _NotificationContent {
  final String title;
  final String body;

  const _NotificationContent({
    required this.title,
    required this.body,
  });
}

/// 情感化通知卡片 Widget
class EmotionalNotificationCard extends StatelessWidget {
  final String title;
  final String body;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const EmotionalNotificationCard({
    super.key,
    required this.title,
    required this.body,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFF8E1),
              const Color(0xFFFFE0B2),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFAB76).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 宠物头像
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFE4B5).withValues(alpha: 0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Center(
                child: Text('🐻', style: TextStyle(fontSize: 40)),
              ),
            ),
            const SizedBox(height: 16),

            // 标题
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A4063),
              ),
            ),
            const SizedBox(height: 12),

            // 内容
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Color(0xFF636E72),
              ),
            ),
            const SizedBox(height: 20),

            // 按钮
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onDismiss,
                    child: const Text('稍后'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFAB76),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '去看看 🐻',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
