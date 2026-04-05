import 'package:flutter/material.dart';
import '../../services/hive_persistence.dart';

/// P45: Notification Settings - Minimal list with Switch → SharedPreferences
/// Every toggle is persisted to Hive/SettingsService
class P45NotificationSettings extends StatefulWidget {
  final VoidCallback onNext;
  
  const P45NotificationSettings({super.key, required this.onNext});

  @override
  State<P45NotificationSettings> createState() => _P45NotificationSettingsState();
}

class _P45NotificationSettingsState extends State<P45NotificationSettings> {
  // Settings state (loaded from Hive)
  bool _mealReminders = true;
  bool _waterReminders = true;
  bool _fastingReminders = true;
  bool _dailyDigest = false;
  bool _achievementAlerts = true;
  bool _streakReminders = true;
  bool _motivationalQuotes = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  void _loadSettings() {
    // Load from Hive/SettingsService
    final settings = HivePersistence.loadNotificationSettings();
    if (settings != null) {
      setState(() {
        _mealReminders = settings['mealReminders'] ?? true;
        _waterReminders = settings['waterReminders'] ?? true;
        _fastingReminders = settings['fastingReminders'] ?? true;
        _dailyDigest = settings['dailyDigest'] ?? false;
        _achievementAlerts = settings['achievementAlerts'] ?? true;
        _streakReminders = settings['streakReminders'] ?? true;
        _motivationalQuotes = settings['motivationalQuotes'] ?? true;
        _soundEnabled = settings['soundEnabled'] ?? true;
        _vibrationEnabled = settings['vibrationEnabled'] ?? true;
      });
    }
  }
  
  // 【CORE】Save setting to Hive immediately
  Future<void> _saveSetting(String key, bool value) async {
    await HivePersistence.saveNotificationSetting(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEDF6FA), Colors.white],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: widget.onNext,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Expanded(
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Reminders Section
                  _SectionHeader(title: 'Reminders'),
                  _SettingsTile(
                    icon: Icons.restaurant,
                    title: 'Meal Reminders',
                    subtitle: 'Get reminded to log your meals',
                    value: _mealReminders,
                    onChanged: (v) {
                      setState(() => _mealReminders = v);
                      _saveSetting('mealReminders', v);
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.water_drop,
                    title: 'Water Reminders',
                    subtitle: 'Stay hydrated throughout the day',
                    value: _waterReminders,
                    onChanged: (v) {
                      setState(() => _waterReminders = v);
                      _saveSetting('waterReminders', v);
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.timer,
                    title: 'Fasting Reminders',
                    subtitle: 'Notifications for fasting windows',
                    value: _fastingReminders,
                    onChanged: (v) {
                      setState(() => _fastingReminders = v);
                      _saveSetting('fastingReminders', v);
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.local_fire_department,
                    title: 'Streak Reminders',
                    subtitle: 'Don\'t break your streak!',
                    value: _streakReminders,
                    onChanged: (v) {
                      setState(() => _streakReminders = v);
                      _saveSetting('streakReminders', v);
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Updates Section
                  _SectionHeader(title: 'Updates'),
                  _SettingsTile(
                    icon: Icons.summarize,
                    title: 'Daily Digest',
                    subtitle: 'Morning summary of your progress',
                    value: _dailyDigest,
                    onChanged: (v) {
                      setState(() => _dailyDigest = v);
                      _saveSetting('dailyDigest', v);
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.emoji_events,
                    title: 'Achievement Alerts',
                    subtitle: 'Celebrate your milestones',
                    value: _achievementAlerts,
                    onChanged: (v) {
                      setState(() => _achievementAlerts = v);
                      _saveSetting('achievementAlerts', v);
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.format_quote,
                    title: 'Motivational Quotes',
                    subtitle: 'Daily inspiration from your pet',
                    value: _motivationalQuotes,
                    onChanged: (v) {
                      setState(() => _motivationalQuotes = v);
                      _saveSetting('motivationalQuotes', v);
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Sound & Haptics Section
                  _SectionHeader(title: 'Sound & Haptics'),
                  _SettingsTile(
                    icon: Icons.volume_up,
                    title: 'Sound',
                    subtitle: 'Play notification sounds',
                    value: _soundEnabled,
                    onChanged: (v) {
                      setState(() => _soundEnabled = v);
                      _saveSetting('soundEnabled', v);
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.vibration,
                    title: 'Vibration',
                    subtitle: 'Haptic feedback for notifications',
                    value: _vibrationEnabled,
                    onChanged: (v) {
                      setState(() => _vibrationEnabled = v);
                      _saveSetting('vibrationEnabled', v);
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Quiet Hours
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF9B59B6).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.nightlight_round,
                            color: Color(0xFF9B59B6),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quiet Hours',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '22:00 - 08:00',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
            
            // Continue button
            Padding(
              padding: const EdgeInsets.all(24),
              child: _CapsuleButton(
                text: 'Continue',
                onPressed: widget.onNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade500,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF4CAF50), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          // 【CORE】Switch → SharedPreferences/Hive
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF4CAF50),
          ),
        ],
      ),
    );
  }
}

class _CapsuleButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  
  const _CapsuleButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CAF50).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
