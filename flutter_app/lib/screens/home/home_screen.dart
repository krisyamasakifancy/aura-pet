import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../providers/pet_provider.dart';
import '../../providers/nutrition_provider.dart';
import '../../utils/theme.dart';
import '../../utils/router.dart';
import '../../widgets/pet_canvas.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/action_grid.dart';
import '../../widgets/progress_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildPetSection(context),
              _buildStatsRow(context),
              _buildQuickActions(context),
              _buildTodayProgress(context),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = '早上好呀！☀️';
    } else if (hour < 18) {
      greeting = '下午好！🌤️';
    } else {
      greeting = '晚上好！🌙';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(greeting, style: AuraPetTheme.bodyMd),
          const SizedBox(height: 4),
          Text('今天感觉怎么样？', style: AuraPetTheme.headingLg),
        ],
      ),
    );
  }

  Widget _buildPetSection(BuildContext context) {
    return Consumer<PetProvider>(
      builder: (context, petProvider, _) {
        final state = petProvider.state;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              // Pet Canvas with level badge
              Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(
                    width: 260,
                    height: 260,
                    child: PetCanvas(),
                  ),
                  // Level badge
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AuraPetTheme.secondary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AuraPetTheme.secondary.withOpacity(0.4),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: Text(
                        'Lv.${state.level}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF8B6914),
                        ),
                      ),
                    ),
                  ),
                  // Status badge
                  Positioned(
                    bottom: 15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AuraPetTheme.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: AuraPetTheme.shadowSm,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AuraPetTheme.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            state.moodLabel,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AuraPetTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // XP bar
              const SizedBox(height: 12),
              SizedBox(
                width: 200,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: state.xpProgress,
                        backgroundColor:
                            AuraPetTheme.secondary.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AuraPetTheme.secondary,
                        ),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${state.xp}/${state.xpToNextLevel} XP',
                      style: AuraPetTheme.bodySm,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Consumer2<NutritionProvider, PetProvider>(
      builder: (context, nutrition, pet, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: '🔥',
                  iconBg: const Color(0xFFFFE5D0),
                  value: nutrition.todayCalories.toString(),
                  label: '卡路里',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.mealCapture),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  icon: '💧',
                  iconBg: const Color(0xFFD4ECFF),
                  value: '${nutrition.waterGlasses}/${nutrition.waterGoal}',
                  label: '喝水量',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.water),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  icon: '💪',
                  iconBg: const Color(0xFFE8F5E8),
                  value: '${nutrition.todayProtein.toInt()}g',
                  label: '蛋白质',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.progress),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('快捷操作', style: AuraPetTheme.headingMd),
          const SizedBox(height: 16),
          ActionGrid(
            actions: [
              ActionItem(
                icon: '📸',
                label: '拍照',
                bgColor: const Color(0xFFFFE5D0),
                onTap: () => Navigator.pushNamed(context, AppRoutes.mealCapture),
              ),
              ActionItem(
                icon: '⏰',
                label: '禁食',
                bgColor: const Color(0xFFE8F5E8),
                onTap: () => Navigator.pushNamed(context, AppRoutes.fasting),
              ),
              ActionItem(
                icon: '🚰',
                label: '喝水',
                bgColor: const Color(0xFFD4ECFF),
                onTap: () => Navigator.pushNamed(context, AppRoutes.water),
              ),
              ActionItem(
                icon: '⚖️',
                label: '体重',
                bgColor: const Color(0xFFF4E8FF),
                onTap: () => Navigator.pushNamed(context, AppRoutes.weight),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodayProgress(BuildContext context) {
    return Consumer2<NutritionProvider, PetProvider>(
      builder: (context, nutrition, pet, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('今日进度', style: AuraPetTheme.headingMd),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.progress),
                    child: const Text(
                      '查看全部',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AuraPetTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ProgressCard(
                      icon: '🎯',
                      iconBg: AuraPetTheme.bgPink,
                      value: '${(nutrition.calorieProgress * 100).toInt()}%',
                      label: '目标完成',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.progress),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ProgressCard(
                      icon: '🪙',
                      iconBg: const Color(0xFFFFD93D),
                      value: pet.state.coins.toString(),
                      label: '金币',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.shop),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
