import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'user_metrics_model.dart';

/// ============================================
/// Aura-Pet App 入口
/// ============================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化SharedPreferences
  await SharedPreferences.getInstance();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserMetricsModel()),
      ],
      child: const AuraPetApp(),
    ),
  );
}

/// ============================================
/// Aura-Pet 应用主组件
/// ============================================
class AuraPetApp extends StatelessWidget {
  const AuraPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aura-Pet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter', // 默认正文字体
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4ECDC4), // 莫奈绿
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontFamily: 'Inter'),
          bodyMedium: TextStyle(fontFamily: 'Inter'),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFEDF6FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      home: const OnboardingNavigator(),
    );
  }
}

/// ============================================
/// 全局用户数据（静态快速访问）
/// ============================================
class UserMetrics {
  static String? gender;
  static String? selectedChannel;
  static String? primaryGoal;
  static final Set<String> additionalGoals = {};
  static double? height;
  static double? weight;
  static int? age;
  static double? goalWeight;
  static String? activityLevel;
}

/// ============================================
/// 46屏导航器 (MainContainer)
/// ============================================
class OnboardingNavigator extends StatefulWidget {
  const OnboardingNavigator({super.key});

  @override
  State<OnboardingNavigator> createState() => _OnboardingNavigatorState();
}

class _OnboardingNavigatorState extends State<OnboardingNavigator> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 46;

  @override
  void initState() {
    super.initState();
    // P0 Splash 特殊逻辑：2秒后自动翻页
    Timer(const Duration(seconds: 2), () {
      if (mounted && _currentPage == 0) {
        _nextPage();
      }
    });
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic, // 弹簧感平滑曲线
      );
    }
  }

  void _goToPage(int pageIndex) {
    if (pageIndex >= 0 && pageIndex < _totalPages) {
      _pageController.animateToPage(
        pageIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 禁止手势滑动 - 强力锁定
          PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _totalPages,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return SplashScreen(onComplete: _nextPage);
                case 1:
                  return WelcomeScreen(onComplete: _nextPage);
                case 2:
                  return CalorieFeatureScreen(onComplete: _nextPage);
                case 3:
                  return FastingFeatureScreen(onComplete: _nextPage);
                case 4:
                  return WeightTrendScreen(onComplete: _nextPage);
                case 5:
                  return HydrationScreen(onComplete: _nextPage);
                case 6:
                  return NutritionScreen(onComplete: _nextPage);
                case 7:
                  return ChannelSurveyScreen(onComplete: _nextPage);
                case 8:
                  return GoalSurveyScreen(onComplete: _nextPage);
                case 9:
                  return AdditionalGoalsScreen(onComplete: _nextPage);
                case 10:
                  return GenderScreen(onComplete: _nextPage);
                case 11:
                  return AgeScreen(onComplete: _nextPage);
                case 12:
                  return HeightScreen(onComplete: _nextPage);
                case 13:
                  return WeightScreen(onComplete: _nextPage);
                case 14:
                  return GoalWeightScreen(onComplete: _nextPage);
                case 15:
                  return ActivityScreen(onComplete: _nextPage);
                case 16:
                  return AnalyzingScreen(onComplete: _nextPage);
                case 17:
                  return PlanReadyScreen(onComplete: _nextPage);
                case 18:
                  return ReviewsScreen(onComplete: _nextPage);
                case 19:
                  return NotificationScreen(onComplete: _nextPage);
                case 20:
                  return CreatingPlanScreen(onComplete: _nextPage);
                case 21:
                  return WeightPredictionScreen(onComplete: _nextPage);
                case 22:
                  return HabitAnalysisScreen(onComplete: _nextPage);
                case 23:
                  return PremiumPaywallScreen(onComplete: _nextPage);
                case 24:
                  return PricingScreen(onComplete: _nextPage);
                case 25:
                  return PaymentCommitmentScreen(onComplete: _nextPage);
                case 26:
                  return WelcomeBackScreen(onComplete: _nextPage);
                case 27:
                  return HomeScreen(onComplete: _nextPage);
                case 28:
                  return NutrientsScreen(onComplete: _nextPage);
                case 29:
                  return MoodScreen(onComplete: _nextPage);
                case 30:
                  return FoodSearchScreen(onComplete: _nextPage);
                case 31:
                  return FoodListScreen(onComplete: _nextPage);
                case 32:
                  return CalorieCalculatorScreen(onComplete: _nextPage);
                case 33:
                  return FastingPlanScreen(onComplete: _nextPage);
                case 34:
                  return FastingTimerScreen(onComplete: _nextPage);
                case 35:
                  return WaterTrackerScreen(onComplete: _nextPage);
                case 36:
                  return WaterHistoryScreen(onComplete: _nextPage);
                case 37:
                  return AchievementsScreen(onComplete: _nextPage);
                case 38:
                  return ProfileScreen(onComplete: _nextPage);
                case 39:
                  return SettingsScreen(onComplete: _nextPage);
                case 40:
                  return GoalReachedScreen(onComplete: _nextPage);
                case 41:
                  return DressingRoomScreen(onComplete: _nextPage);
                case 42:
                  return ProgressReportScreen(onComplete: _nextPage);
                case 43:
                  return BadgeDetailScreen(onComplete: _nextPage);
                case 44:
                  return NotificationSettingsScreen(onComplete: _nextPage);
                case 45:
                  return AboutScreen(onComplete: _nextPage);
                default:
                  return _PlaceholderPage(pageNumber: index + 1);
              }
            },
          ),

          // 页码指示器
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentPage + 1} / $_totalPages',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ),

          // ============================================
          // 全局胶囊按钮（P0 Splash不显示，P45最后一页不显示）
          // ============================================
          if (_currentPage > 0 && _currentPage < _totalPages - 1)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 32,
              left: 40,
              right: 40,
              child: GestureDetector(
                onTap: _nextPage,
                child: Container(
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
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 占位页
class _PlaceholderPage extends StatelessWidget {
  final int pageNumber;

  const _PlaceholderPage({required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF6FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🐻', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            Text(
              'Page $pageNumber',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon...',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
