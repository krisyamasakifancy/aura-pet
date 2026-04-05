import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('个人资料'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AuraPetTheme.bgPink,
                shape: BoxShape.circle,
                boxShadow: AuraPetTheme.shadowMd,
              ),
              child: const Center(
                child: Text('🐻', style: TextStyle(fontSize: 50)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Colvin',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Text(
              'colvin@example.com',
              style: TextStyle(
                color: AuraPetTheme.textLight,
              ),
            ),
            const SizedBox(height: 32),

            // Stats row
            Row(
              children: [
                Expanded(child: _ProfileStat(label: '连续天数', value: '7天')),
                Expanded(child: _ProfileStat(label: '完成目标', value: '23次')),
                Expanded(child: _ProfileStat(label: '获得成就', value: '5个')),
              ],
            ),
            const SizedBox(height: 32),

            // Settings list
            _SettingsItem(
              icon: '👤',
              title: '编辑资料',
              subtitle: '修改姓名、头像等信息',
              onTap: () {},
            ),
            _SettingsItem(
              icon: '🎯',
              title: '健康目标',
              subtitle: '设置每日卡路里、营养素目标',
              onTap: () {},
            ),
            _SettingsItem(
              icon: '🔔',
              title: '提醒设置',
              subtitle: '用餐、喝水提醒',
              onTap: () {},
            ),
            _SettingsItem(
              icon: '📊',
              title: '数据统计',
              subtitle: '查看详细健康报告',
              onTap: () {},
            ),
            _SettingsItem(
              icon: '💳',
              title: '订阅管理',
              subtitle: '会员订阅',
              onTap: () {},
            ),
            _SettingsItem(
              icon: '❓',
              title: '帮助与反馈',
              subtitle: '联系我们',
              onTap: () {},
            ),
            _SettingsItem(
              icon: '📖',
              title: '使用指南',
              subtitle: '了解所有功能',
              onTap: () {},
            ),

            const SizedBox(height: 24),

            // Logout button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AuraPetTheme.danger, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  '退出登录',
                  style: TextStyle(
                    color: AuraPetTheme.danger,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AuraPetTheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AuraPetTheme.textLight,
          ),
        ),
      ],
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
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AuraPetTheme.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AuraPetTheme.shadowSm,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AuraPetTheme.bgCream,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AuraPetTheme.textDark,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AuraPetTheme.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AuraPetTheme.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
