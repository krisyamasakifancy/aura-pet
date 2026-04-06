import 'package:flutter/material.dart';
import '../../widgets/furry_trio.dart';
import '../../widgets/fancy_design.dart';

/// P05: 首页仪表盘 - 毛绒三友版
/// 去 Apple 化 + 暖色系 + 毛绒质感
class P05HomeScreen extends StatefulWidget {
  const P05HomeScreen({super.key});

  @override
  State<P05HomeScreen> createState() => _P05HomeScreenState();
}

class _P05HomeScreenState extends State<P05HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  FurryTrio _activeCharacter = FurryTrio.dataBear;

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

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning ☀️';
    if (hour < 18) return 'Good Afternoon 🌤️';
    return 'Good Evening 🌙';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FurryTheme.surface,
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
                    const SizedBox(height: 32),
                    
                    // ========== 毛绒三友组合 ==========
                    _buildFurryTrio(),
                    const SizedBox(height: 24),
                    
                    // ========== 对话气泡 ==========
                    _buildCharacterDialog(),
                    const SizedBox(height: 32),
                    
                    // ========== 核心环形图 ==========
                    _buildMainProgressRing(),
                    const SizedBox(height: 32),
                    
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
        // 熊仔小头像
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: FurryTheme.cardBg,
            shape: BoxShape.circle,
            boxShadow: FurryTheme.fluffyShadow,
          ),
          child: Center(
            child: DataBear(
              size: 36,
              animate: true,
              celebrating: true,
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
                  color: FurryTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                'Colvin',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: FurryTheme.textPrimary,
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
            color: FurryTheme.cardBg,
            borderRadius: BorderRadius.circular(FurryTheme.radiusMd),
            boxShadow: FurryTheme.softShadow,
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  Icons.notifications_outlined,
                  color: FurryColors.bearBrown,
                  size: 22,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEF4444).withOpacity(0.5),
                        blurRadius: 6,
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

  Widget _buildFurryTrio() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            FurryColors.bearBrown.withOpacity(0.1),
            FurryColors.bunnyPink.withOpacity(0.1),
            FurryColors.ellPink.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(FurryTheme.radiusLg),
        boxShadow: FurryTheme.fluffyShadow,
      ),
      child: Column(
        children: [
          // 毛绒三友组合
          FurryTrioDisplay(
            activeCharacter: _activeCharacter,
            sleeping: false,
            onBearTap: () => setState(() => _activeCharacter = FurryTrio.dataBear),
            onBunnyTap: () => setState(() => _activeCharacter = FurryTrio.chefBunny),
            onEllTap: () => setState(() => _activeCharacter = FurryTrio.cheerEll),
          ),
          
          const SizedBox(height: 16),
          
          // 角色标签
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CharacterLabel(
                name: '熊仔',
                emoji: '🐻',
                color: FurryColors.bearBrown,
                isActive: _activeCharacter == FurryTrio.dataBear,
                onTap: () => setState(() => _activeCharacter = FurryTrio.dataBear),
              ),
              const SizedBox(width: 16),
              _CharacterLabel(
                name: '兔厨',
                emoji: '🐰',
                color: FurryColors.carrotOrange,
                isActive: _activeCharacter == FurryTrio.chefBunny,
                onTap: () => setState(() => _activeCharacter = FurryTrio.chefBunny),
              ),
              const SizedBox(width: 16),
              _CharacterLabel(
                name: '象宝',
                emoji: '🐘',
                color: FurryColors.bowPink,
                isActive: _activeCharacter == FurryTrio.cheerEll,
                onTap: () => setState(() => _activeCharacter = FurryTrio.cheerEll),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterDialog() {
    String message;
    switch (_activeCharacter) {
      case FurryTrio.dataBear:
        message = '📊 今天的数据很棒哦！继续保持~';
        break;
      case FurryTrio.chefBunny:
        message = '🥕 午餐要吃什么好吃的呢？让我看看！';
        break;
      case FurryTrio.cheerEll:
        message = '💪 今天的运动目标完成了吗？一起加油！';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FurryTheme.cardBg,
        borderRadius: BorderRadius.circular(FurryTheme.radiusMd),
        boxShadow: FurryTheme.softShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _getCharacterColor().withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                _getCharacterEmoji(),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: FurryTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCharacterColor() {
    switch (_activeCharacter) {
      case FurryTrio.dataBear:
        return FurryColors.bearBrown;
      case FurryTrio.chefBunny:
        return FurryColors.carrotOrange;
      case FurryTrio.cheerEll:
        return FurryColors.bowPink;
    }
  }

  String _getCharacterEmoji() {
    switch (_activeCharacter) {
      case FurryTrio.dataBear:
        return '🐻';
      case FurryTrio.chefBunny:
        return '🐰';
      case FurryTrio.cheerEll:
        return '🐘';
    }
  }

  Widget _buildMainProgressRing() {
    return Column(
      children: [
        // 带呼吸光效的环形图
        GlowProgressRing(
          progress: _progress,
          centerValue: _remainingCalories.toString(),
          centerLabel: '剩余 kcal',
          size: 220,
          strokeWidth: 16,
          progressColor: FurryColors.bearBrown,
        ),
        const SizedBox(height: 24),
        
        // 热量概览 - 毛绒胶囊卡片
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: FurryTheme.cardBg,
            borderRadius: BorderRadius.circular(30),
            boxShadow: FurryTheme.fluffyShadow,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CalorieChip(
                label: '已摄入',
                value: _consumedCalories.toString(),
                color: FurryColors.bearBrown,
              ),
              Container(
                width: 1,
                height: 30,
                color: Colors.black.withOpacity(0.08),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              _CalorieChip(
                label: '目标',
                value: _targetCalories.toString(),
                color: FurryTheme.textMuted,
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
            color: FurryColors.carrotOrange,
            emoji: '🐰',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.water_drop_outlined,
            label: '饮水量',
            value: '1.8L',
            subtitle: '目标 2.5L',
            color: const Color(0xFF60A5FA),
            emoji: '💧',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.directions_walk_outlined,
            label: '步数',
            value: '6.2k',
            subtitle: '目标 10k',
            color: FurryColors.bowPink,
            emoji: '🐘',
          ),
        ),
      ],
    );
  }

  Widget _buildAIInsightCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FurryColors.bearBrown.withOpacity(0.08),
        borderRadius: BorderRadius.circular(FurryTheme.radiusMd),
        border: Border.all(
          color: FurryColors.bearBrown.withOpacity(0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: FurryColors.bearGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('🧠', style: TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI 今日建议',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: FurryTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '你的蛋白质摄入偏低，建议午餐增加一份鸡胸肉或豆制品。',
                  style: TextStyle(
                    fontSize: 12,
                    color: FurryTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: FurryTheme.cardBg,
        borderRadius: BorderRadius.circular(FurryTheme.radiusMd),
        boxShadow: FurryTheme.fluffyShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: Icons.camera_alt_outlined,
              label: '拍照录入',
              emoji: '🐰',
              isPrimary: true,
              onTap: () => setState(() => _activeCharacter = FurryTrio.chefBunny),
            ),
          ),
          Expanded(
            child: _ActionButton(
              icon: Icons.search_outlined,
              label: '搜索食物',
              emoji: '🔍',
              isPrimary: false,
              onTap: () => setState(() => _activeCharacter = FurryTrio.chefBunny),
            ),
          ),
        ],
      ),
    );
  }
}

class _CharacterLabel extends StatelessWidget {
  final String name;
  final String emoji;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const _CharacterLabel({
    required this.name,
    required this.emoji,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 4),
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? color : FurryTheme.textMuted,
              ),
            ),
          ],
        ),
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
            color: FurryTheme.textMuted,
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
  final Color color;
  final String emoji;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FurryTheme.cardBg,
        borderRadius: BorderRadius.circular(FurryTheme.radiusMd),
        boxShadow: FurryTheme.fluffyShadow,
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: FurryTheme.textSecondary,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: FurryTheme.textMuted,
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
  final String emoji;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.emoji,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: isPrimary ? FurryColors.warmGradient : null,
          color: isPrimary ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(FurryTheme.radiusMd),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isPrimary ? Colors.white : FurryColors.bearBrown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
