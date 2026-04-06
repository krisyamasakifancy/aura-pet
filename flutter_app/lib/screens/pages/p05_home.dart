import 'package:flutter/material.dart';
import '../../widgets/fancy_design.dart';
import '../../widgets/canvas_bear.dart';

/// P05: 首页仪表盘 - 微光影升级版
/// 遵循 awesome-design-md 极简风格
class P05HomeScreen extends StatefulWidget {
  const P05HomeScreen({super.key});

  @override
  State<P05HomeScreen> createState() => _P05HomeScreenState();
}

class _P05HomeScreenState extends State<P05HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // 模拟数据
  final int _consumedCalories = 1420;
  final int _targetCalories = 1800;
  final int _remainingCalories = 380;
  final double _progress = 1420 / 1800;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
    
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FancyDesign.surfaceLight,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // ========== Header ==========
                    _buildHeader(),
                    const SizedBox(height: 40),
                    
                    // ========== 核心环形图 ==========
                    _buildMainProgressRing(),
                    const SizedBox(height: 40),
                    
                    // ========== 快速数据卡片 ==========
                    _buildQuickStats(),
                    const SizedBox(height: 24),
                    
                    // ========== AI 状态面板 ==========
                    _buildAIInsightCard(),
                    const SizedBox(height: 24),
                    
                    // ========== 快捷操作 ==========
                    _buildQuickActions(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // 泰迪熊头像 + 问候
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: FancyDesign.shadowCard,
          ),
          child: const Center(
            child: SizedBox(
              width: 36,
              height: 36,
              child: CanvasBear(
                mood: BearMood.heartEyes,
                size: 36,
                animate: true,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: const TextStyle(
                  fontSize: 14,
                  color: FancyDesign.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                'Colvin',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: FancyDesign.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        // 通知按钮
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: FancyDesign.shadowSubtle,
          ),
          child: Stack(
            children: [
              const Center(
                child: Icon(
                  Icons.notifications_outlined,
                  color: FancyDesign.primaryBrown,
                  size: 22,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: FancyDesign.error,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: FancyDesign.error.withValues(alpha: 0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning ☀️';
    if (hour < 18) return 'Good Afternoon 🌤️';
    return 'Good Evening 🌙';
  }

  Widget _buildMainProgressRing() {
    return Column(
      children: [
        // 带呼吸光效的环形图
        GlowProgressRing(
          progress: _progress,
          centerValue: _remainingCalories.toString(),
          centerLabel: '剩余 kcal',
          size: 240,
          strokeWidth: 14,
          progressColor: FancyDesign.primaryBrown,
        ),
        const SizedBox(height: 24),
        
        // 热量概览
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: FancyDesign.shadowCard,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CalorieChip(
                label: '已摄入',
                value: _consumedCalories.toString(),
                color: FancyDesign.primaryBrown,
              ),
              Container(
                width: 1,
                height: 30,
                color: Colors.black.withValues(alpha: 0.1),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              _CalorieChip(
                label: '目标',
                value: _targetCalories.toString(),
                color: FancyDesign.textMuted,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.restaurant_outlined,
            label: '今日餐次',
            value: '3',
            subtitle: '早 + 午 + 晚',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.water_drop_outlined,
            label: '饮水量',
            value: '1.8L',
            subtitle: '目标 2.5L',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.directions_walk_outlined,
            label: '步数',
            value: '6.2k',
            subtitle: '目标 10k',
          ),
        ),
      ],
    );
  }

  Widget _buildAIInsightCard() {
    return StatusCallout(
      title: '🧠 AI 今日建议',
      description: '你的蛋白质摄入偏低，建议午餐增加一份鸡胸肉或豆制品。',
      type: StatusType.info,
      icon: Icons.lightbulb_outline,
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: FancyDesign.shadowCard,
      ),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: Icons.camera_alt_outlined,
              label: '拍照录入',
              isPrimary: true,
            ),
          ),
          Expanded(
            child: _ActionButton(
              icon: Icons.search_outlined,
              label: '搜索食物',
              isPrimary: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalorieChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _CalorieChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: FancyDesign.textMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtitle;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: FancyDesign.shadowCard,
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: FancyDesign.primaryBrown.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: FancyDesign.primaryBrown, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: FancyDesign.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: FancyDesign.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: FancyDesign.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: isPrimary ? FancyDesign.primaryGradient : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isPrimary ? Colors.white : FancyDesign.primaryBrown,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isPrimary ? Colors.white : FancyDesign.primaryBrown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
