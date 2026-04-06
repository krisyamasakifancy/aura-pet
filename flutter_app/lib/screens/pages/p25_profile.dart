import 'package:flutter/material.dart';
import '../../widgets/furry_trio.dart';
import '../../widgets/fancy_design.dart';

/// P25: 个人数据面板 - 毛绒三友版
/// 看板化重构 + 角色水印
class P25ProfileScreen extends StatelessWidget {
  const P25ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FurryTheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========== Header ==========
              _buildHeader(),
              const SizedBox(height: 32),
              
              // ========== 主数据看板 (Grid) ==========
              _buildDataDashboard(),
              const SizedBox(height: 24),
              
              // ========== 健康指标卡片 ==========
              _buildHealthMetrics(),
              const SizedBox(height: 24),
              
              // ========== AI 状态面板 ==========
              _buildAIStatusPanel(),
              const SizedBox(height: 24),
              
              // ========== 快捷操作 ==========
              _buildQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // 毛绒三友头像
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: FurryTheme.cardBg,
            shape: BoxShape.circle,
            boxShadow: FurryTheme.fluffyShadow,
          ),
          child: Center(
            child: FurryTrioDisplay(
              activeCharacter: FurryTrio.dataBear,
              onBearTap: () {},
              onBunnyTap: () {},
              onEllTap: () {},
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '个人数据面板',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: FurryTheme.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Professional Dashboard',
                style: TextStyle(
                  fontSize: 13,
                  color: FurryTheme.textSecondary.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // 设置按钮
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: FurryTheme.cardBg,
            borderRadius: BorderRadius.circular(FurryTheme.radiusMd),
            boxShadow: FurryTheme.softShadow,
          ),
          child: Icon(
            Icons.settings_outlined,
            color: FurryColors.bearBrown,
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildDataDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题行
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: FurryColors.bearBrown,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '核心指标',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: FurryTheme.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const Spacer(),
            Text(
              '实时更新',
              style: TextStyle(
                fontSize: 12,
                color: FancyDesign.success.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: FancyDesign.success,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: FancyDesign.success.withValues(alpha: 0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Grid 2x2 布局
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.0,
          children: [
            _CharacterWatermarkCard(
              character: FurryTrio.dataBear,
              child: DataReportCard(
                title: 'BMI 指数',
                value: '22.4',
                subtitle: '理想范围',
                icon: Icons.monitor_weight_outlined,
                trend: '+0.3',
                trendPositive: true,
              ),
            ),
            _CharacterWatermarkCard(
              character: FurryTrio.dataBear,
              child: DataReportCard(
                title: 'BMR 基础代谢',
                value: '1,580',
                subtitle: 'kcal/天',
                icon: Icons.bolt_outlined,
                trend: '+20',
                trendPositive: true,
              ),
            ),
            _CharacterWatermarkCard(
              character: FurryTrio.cheerEll,
              child: DataReportCard(
                title: 'TDEE 总消耗',
                value: '2,340',
                subtitle: 'kcal/天',
                icon: Icons.local_fire_department_outlined,
                trend: '+180',
                trendPositive: true,
              ),
            ),
            _CharacterWatermarkCard(
              character: FurryTrio.chefBunny,
              child: DataReportCard(
                title: '体脂率',
                value: '18.5',
                subtitle: '% 偏低',
                icon: Icons.percent_outlined,
                trend: '-1.2',
                trendPositive: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: FurryColors.bearMuzzle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '营养素目标',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: FurryTheme.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // 营养素进度卡片
        FrostedGlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildMacroRow('蛋白质', 65, 80, 'g', Icons.egg_outlined, FurryColors.carrotOrange),
              const SizedBox(height: 16),
              _buildMacroRow('碳水', 180, 250, 'g', Icons.grain_outlined, FurryColors.bearMuzzle),
              const SizedBox(height: 16),
              _buildMacroRow('脂肪', 45, 65, 'g', Icons.water_drop_outlined, FurryColors.bowPink),
              const SizedBox(height: 16),
              _buildMacroRow('膳食纤维', 18, 30, 'g', Icons.grass_outlined, const Color(0xFF10B981)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMacroRow(String label, int current, int target, String unit, IconData icon, Color color) {
    final progress = current / target;
    final progressColor = progress > 1.0 ? FancyDesign.warning : color;
    
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: progressColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: progressColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: FurryTheme.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '$current / $target $unit',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: progressColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 毛绒风格进度条
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [progressColor, progressColor.withValues(alpha: 0.7)],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: progressColor.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAIStatusPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'AI 健康助手',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: FurryTheme.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        StatusCallout(
          title: '🐻 今日营养摄入评估',
          description: '已达成 78% 的每日目标，继续保持！碳水略高，建议晚餐减少主食。',
          type: StatusType.success,
          icon: Icons.auto_awesome,
        ),
        const SizedBox(height: 12),
        
        StatusCallout(
          title: '🐘 运动建议',
          description: '今日步数 6,234，建议再走 3,766 步达到目标',
          type: StatusType.warning,
          icon: Icons.directions_walk,
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: FurryTheme.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '快捷操作',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: FurryTheme.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                emoji: '🐰',
                icon: Icons.camera_alt_outlined,
                label: '拍照录入',
                color: FurryColors.carrotOrange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                emoji: '🔍',
                icon: Icons.search_outlined,
                label: '搜索食物',
                color: FurryColors.bearMuzzle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                emoji: '📊',
                icon: Icons.bar_chart_outlined,
                label: '查看报告',
                color: const Color(0xFF3B82F6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 带角色水印的卡片
class _CharacterWatermarkCard extends StatelessWidget {
  final FurryTrio character;
  final Widget child;

  const _CharacterWatermarkCard({
    required this.character,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        // 角色水印
        Positioned(
          right: 8,
          bottom: 8,
          child: Opacity(
            opacity: 0.15,
            child: Transform.scale(
              scale: 0.8,
              child: _buildCharacter(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCharacter() {
    switch (character) {
      case FurryTrio.dataBear:
        return const DataBear(size: 60, animate: false);
      case FurryTrio.chefBunny:
        return const ChefBunny(size: 60, animate: false);
      case FurryTrio.cheerEll:
        return const CheerEll(size: 60, animate: false);
    }
  }
}

class _QuickActionButton extends StatelessWidget {
  final String emoji;
  final IconData icon;
  final String label;
  final Color color;

  const _QuickActionButton({
    required this.emoji,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: FurryTheme.cardBg,
        borderRadius: BorderRadius.circular(FurryTheme.radiusMd),
        boxShadow: FurryTheme.fluffyShadow,
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: FurryTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
