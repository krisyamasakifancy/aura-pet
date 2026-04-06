import 'package:flutter/material.dart';
import '../../widgets/fancy_design.dart';
import '../../widgets/canvas_bear.dart';

/// P25: 个人数据面板 - 看板化重构
/// 遵循 awesome-design-md 专业财报风格
class P25ProfileScreen extends StatelessWidget {
  const P25ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FancyDesign.surfaceLight,
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
        // 泰迪熊头像
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: FancyDesign.shadowCard,
          ),
          child: const Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CanvasBear(
                mood: BearMood.heartEyes,
                size: 40,
                animate: true,
              ),
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
                  color: FancyDesign.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Professional Dashboard',
                style: TextStyle(
                  fontSize: 13,
                  color: FancyDesign.textSecondary.withValues(alpha: 0.8),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: FancyDesign.shadowSubtle,
          ),
          child: const Icon(
            Icons.settings_outlined,
            color: FancyDesign.primaryBrown,
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
                color: FancyDesign.primaryBrown,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '核心指标',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: FancyDesign.textPrimary,
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
          childAspectRatio: 1.1,
          children: [
            DataReportCard(
              title: 'BMI 指数',
              value: '22.4',
              subtitle: '理想范围',
              icon: Icons.monitor_weight_outlined,
              trend: '+0.3',
              trendPositive: true,
            ),
            DataReportCard(
              title: 'BMR 基础代谢',
              value: '1,580',
              subtitle: 'kcal/天',
              icon: Icons.bolt_outlined,
              trend: '+20',
              trendPositive: true,
            ),
            DataReportCard(
              title: 'TDEE 总消耗',
              value: '2,340',
              subtitle: 'kcal/天',
              icon: Icons.local_fire_department_outlined,
              trend: '+180',
              trendPositive: true,
            ),
            DataReportCard(
              title: '体脂率',
              value: '18.5',
              subtitle: '% 偏低',
              icon: Icons.percent_outlined,
              trend: '-1.2',
              trendPositive: true,
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
                color: FancyDesign.accentGold,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '营养素目标',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: FancyDesign.textPrimary,
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
              _buildMacroRow('蛋白质', 65, 80, 'g', Icons.egg_outlined),
              const SizedBox(height: 16),
              _buildMacroRow('碳水', 180, 250, 'g', Icons.grain_outlined),
              const SizedBox(height: 16),
              _buildMacroRow('脂肪', 45, 65, 'g', Icons.water_drop_outlined),
              const SizedBox(height: 16),
              _buildMacroRow('膳食纤维', 18, 30, 'g', Icons.grass_outlined),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMacroRow(String label, int current, int target, String unit, IconData icon) {
    final progress = current / target;
    final progressColor = progress > 1.0 ? FancyDesign.warning : FancyDesign.primaryBrown;
    
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: progressColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
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
                          color: FancyDesign.textPrimary,
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
                  // 进度条
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      backgroundColor: Colors.black.withValues(alpha: 0.05),
                      valueColor: AlwaysStoppedAnimation(progressColor),
                      minHeight: 6,
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
                color: FancyDesign.info,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'AI 健康助手',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: FancyDesign.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        StatusCallout(
          title: '今日营养摄入评估',
          description: '已达成 78% 的每日目标，继续保持！碳水略高，建议晚餐减少主食。',
          type: StatusType.success,
          icon: Icons.auto_awesome,
        ),
        const SizedBox(height: 12),
        
        StatusCallout(
          title: '运动建议',
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
                color: FancyDesign.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '快捷操作',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: FancyDesign.textPrimary,
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
                icon: Icons.camera_alt_outlined,
                label: '拍照录入',
                color: FancyDesign.primaryBrown,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.search_outlined,
                label: '搜索食物',
                color: FancyDesign.accentGold,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.bar_chart_outlined,
                label: '查看报告',
                color: FancyDesign.info,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: FancyDesign.shadowCard,
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.8)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: FancyDesign.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
