import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('设置'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notifications section
            _SectionTitle(title: '通知'),
            _SettingsToggle(
              icon: '🍽️',
              title: '用餐提醒',
              subtitle: '记得记录每餐饮食',
              value: true,
              onChanged: (v) {},
            ),
            _SettingsToggle(
              icon: '💧',
              title: '喝水提醒',
              subtitle: '每小时提醒一次',
              value: true,
              onChanged: (v) {},
            ),
            _SettingsToggle(
              icon: '⏰',
              title: '禁食提醒',
              subtitle: '开始/结束禁食通知',
              value: false,
              onChanged: (v) {},
            ),
            _SettingsToggle(
              icon: '🏆',
              title: '成就解锁',
              subtitle: '获得新成就时通知',
              value: true,
              onChanged: (v) {},
            ),
            const SizedBox(height: 24),

            // Display section
            _SectionTitle(title: '显示'),
            _SettingsToggle(
              icon: '🌙',
              title: '深色模式',
              subtitle: '保护眼睛',
              value: false,
              onChanged: (v) {},
            ),
            _SettingsToggle(
              icon: '📱',
              title: '震动反馈',
              subtitle: '交互时震动',
              value: true,
              onChanged: (v) {},
            ),
            const SizedBox(height: 24),

            // Data section
            _SectionTitle(title: '数据'),
            _SettingsItem(
              icon: '📤',
              title: '导出数据',
              subtitle: '导出健康数据报告',
              onTap: () {},
            ),
            _SettingsItem(
              icon: '🔄',
              title: '同步数据',
              subtitle: '与服务器同步',
              onTap: () {},
            ),
            _SettingsItem(
              icon: '🗑️',
              title: '清除缓存',
              subtitle: '释放存储空间',
              onTap: () {},
            ),
            const SizedBox(height: 24),

            // About section
            _SectionTitle(title: '关于'),
            _SettingsItem(
              icon: '📖',
              title: '使用条款',
              subtitle: '',
              onTap: () {},
            ),
            _SettingsItem(
              icon: '🔒',
              title: '隐私政策',
              subtitle: '',
              onTap: () {},
            ),
            _SettingsItem(
              icon: '⭐',
              title: '给我们评分',
              subtitle: '',
              onTap: () {},
            ),
            _SettingsItem(
              icon: '📱',
              title: '检查更新',
              subtitle: '当前版本 1.0.0',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AuraPetTheme.textLight,
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AuraPetTheme.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: AuraPetTheme.shadowSm,
          ),
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AuraPetTheme.textLight,
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AuraPetTheme.textMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AuraPetTheme.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AuraPetTheme.shadowSm,
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AuraPetTheme.textLight,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AuraPetTheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
