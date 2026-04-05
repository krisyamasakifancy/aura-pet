import 'package:flutter/material.dart';
import '../utils/aura_theme.dart';
import '../widgets/q_raccoon_canvas.dart';

/// 极简空气感首页 - 对标竞品截图
class AuraHomeScreen extends StatefulWidget {
  const AuraHomeScreen({super.key});

  @override
  State<AuraHomeScreen> createState() => _AuraHomeScreenState();
}

class _AuraHomeScreenState extends State<AuraHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AuraPetTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Column(
                  children: [
                    // 顶部状态
                    _buildHeader(),
                    
                    // 主内容
                    Expanded(
                      child: IndexedStack(
                        index: _currentTab,
                        children: const [
                          _HomeContent(),
                          _MealContent(),
                          _FastingContent(),
                          _ProfileContent(),
                        ],
                      ),
                    ),
                    
                    // 底部导航
                    _buildBottomNav(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // 小熊头像
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AuraPetTheme.raccoonGray,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AuraPetTheme.auraGlow.withValues(alpha: 0.3),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Stack(
              children: [
                // 脸部
                Positioned(
                  top: 12,
                  left: 8,
                  child: Container(
                    width: 32,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                // 眼睛
                Positioned(
                  top: 18,
                  left: 14,
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AuraPetTheme.noseBlack,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AuraPetTheme.noseBlack,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          
          // 问候语
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello! 👋',
                  style: TextStyle(
                    fontSize: 14,
                    color: AuraPetTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Reach your goals',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AuraPetTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          
          // 通知图标
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: AuraPetTheme.softShadow,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AuraPetTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: AuraPetTheme.softShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_rounded, 'Home'),
            _buildNavItem(1, Icons.restaurant_rounded, 'Meal'),
            _buildNavItem(2, Icons.timer_rounded, 'Fasting'),
            _buildNavItem(3, Icons.person_rounded, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentTab == index;
    
    return GestureDetector(
      onTap: () => setState(() => _currentTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AuraPetTheme.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? AuraPetTheme.primary : AuraPetTheme.textLight,
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AuraPetTheme.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 首页内容
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          
          // 今日摄入卡片
          _buildCaloriesCard(),
          
          const SizedBox(height: 24),
          
          // 快捷操作
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AuraPetTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildQuickActions(),
          
          const SizedBox(height: 24),
          
          // 今日进度
          const Text(
            'Today Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AuraPetTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildProgressCard(),
          
          const SizedBox(height: 24),
          
          // 小熊互动区
          _buildPetSection(),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildCaloriesCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AuraPetTheme.softShadow,
      ),
      child: Row(
        children: [
          // 热量圆环
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AuraPetTheme.primary,
                  AuraPetTheme.primaryLight,
                ],
              ),
            ),
            child: Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '1,240',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AuraPetTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'kcal',
                      style: TextStyle(
                        fontSize: 12,
                        color: AuraPetTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today\'s Intake',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AuraPetTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'of 2,000 kcal goal',
                  style: TextStyle(
                    fontSize: 14,
                    color: AuraPetTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                // 营养条
                _buildMacroBar('Protein', 0.65, AuraPetTheme.success),
                const SizedBox(height: 8),
                _buildMacroBar('Carbs', 0.45, AuraPetTheme.warning),
                const SizedBox(height: 8),
                _buildMacroBar('Fat', 0.30, AuraPetTheme.accent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroBar(String label, double progress, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AuraPetTheme.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            icon: Icons.camera_alt_rounded,
            label: 'Snap & Log',
            color: AuraPetTheme.primary,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            icon: Icons.water_drop_rounded,
            label: 'Log Water',
            color: const Color(0xFF7BC4FF),
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            icon: Icons.favorite_rounded,
            label: 'Start Fast',
            color: AuraPetTheme.accent,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AuraPetTheme.softShadow,
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AuraPetTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AuraPetTheme.softShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildProgressItem(
                  icon: Icons.water_drop_rounded,
                  value: '5/8',
                  label: 'Glasses',
                  color: const Color(0xFF7BC4FF),
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: AuraPetTheme.surfaceOverlay,
              ),
              Expanded(
                child: _buildProgressItem(
                  icon: Icons.directions_walk_rounded,
                  value: '8,234',
                  label: 'Steps',
                  color: AuraPetTheme.success,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: AuraPetTheme.surfaceOverlay,
              ),
              Expanded(
                child: _buildProgressItem(
                  icon: Icons.local_fire_department_rounded,
                  value: '450',
                  label: 'Burned',
                  color: AuraPetTheme.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AuraPetTheme.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AuraPetTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPetSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AuraPetTheme.auraGlow.withValues(alpha: 0.2),
            AuraPetTheme.accent.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          // 小熊
          const QRaccoonCanvas(
            size: 100,
            showHeart: true,
            auraScore: 85,
          ),
          const SizedBox(width: 20),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bear needs you!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AuraPetTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap to feed & interact',
                  style: TextStyle(
                    fontSize: 13,
                    color: AuraPetTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AuraPetTheme.heartPink,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '💕 Pet Bear',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 饮食内容
class _MealContent extends StatelessWidget {
  const _MealContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const QRaccoonCanvas(
            size: 150,
            showHeart: true,
            showHeartBubbles: true,
            auraScore: 90,
          ),
          const SizedBox(height: 24),
          const Text(
            'Log your meals',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AuraPetTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the camera to start',
            style: TextStyle(
              fontSize: 14,
              color: AuraPetTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// 禁食内容
class _FastingContent extends StatelessWidget {
  const _FastingContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 16:8 标识
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AuraPetTheme.primary,
                  AuraPetTheme.primaryLight,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AuraPetTheme.primary.withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '16:8',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: AuraPetTheme.primary,
                      ),
                    ),
                    Text(
                      'Fasting',
                      style: TextStyle(
                        fontSize: 14,
                        color: AuraPetTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Fasting Mode',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AuraPetTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap to start your fast',
            style: TextStyle(
              fontSize: 14,
              color: AuraPetTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// 个人中心
class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // 头像
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AuraPetTheme.raccoonGray,
              shape: BoxShape.circle,
              boxShadow: AuraPetTheme.softShadow,
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AuraPetTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
