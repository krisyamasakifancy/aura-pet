import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/p01_splash.dart';
import 'pages/p02_onboard1.dart';
import 'pages/p03_onboard2.dart';
import 'pages/p04_onboard3.dart';
import 'pages/p05_home.dart';
import 'pages/p06_capture.dart';
import 'pages/p07_meal_result.dart';
import 'pages/p08_meal_history.dart';
import 'pages/p09_meal_detail.dart';
import 'pages/p10_water.dart';
import 'pages/p11_weight.dart';
import 'pages/p12_bmi.dart';
import 'pages/p13_fasting.dart';
import 'pages/p14_fasting_set.dart';
import 'pages/p15_progress.dart';
import 'pages/p16_weekly.dart';
import 'pages/p17_monthly.dart';
import 'pages/p18_achievements.dart';
import 'pages/p19_achievement_detail.dart';
import 'pages/p20_shop.dart';
import 'pages/p21_product.dart';
import 'pages/p22_purchase.dart';
import 'pages/p23_pet_detail.dart';
import 'pages/p24_pet_dress.dart';
import 'pages/p25_profile.dart';
import 'pages/p26_settings.dart';
import 'pages/p27_notification.dart';
import 'pages/p28_goals.dart';
import 'pages/p29_subscription.dart';
import 'pages/p30_login.dart';
import 'pages/p31_register.dart';
import 'pages/p32_forgot.dart';
import 'pages/p33_search.dart';
import 'pages/p34_calendar.dart';
import 'pages/p35_sync.dart';
import 'pages/p36_help.dart';
import 'pages/p37_about.dart';
import 'pages/p38_privacy.dart';
import 'pages/p39_terms.dart';
import 'pages/p40_honor.dart';
import 'pages/p41_daily_task.dart';
import 'pages/p42_activity.dart';
import 'pages/p43_celebration.dart';
import 'pages/p44_complete.dart';

/// 44页横向精准切页系统
class AuraPageNavigator extends StatefulWidget {
  const AuraPageNavigator({super.key});

  @override
  State<AuraPageNavigator> createState() => _AuraPageNavigatorState();
}

class _AuraPageNavigatorState extends State<AuraPageNavigator>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  
  // 44页数据
  static const int _totalPages = 44;
  
  final List<Map<String, dynamic>> _pageData = [
    {'emoji': '💫', 'title': '开始体验', 'bg': const Color(0xFFFFD700), 'color': const Color(0xFFFFB74D)},
    {'emoji': '🌟', 'title': 'Track Journey', 'bg': const Color(0xFFFF8BA0), 'color': const Color(0xFFFFB4C4)},
    {'emoji': '💕', 'title': 'Pet Misses You', 'bg': const Color(0xFFFF8BA0), 'color': const Color(0xFFFFB4C4)},
    {'emoji': '✨', 'title': 'Start Today', 'bg': const Color(0xFFFF8BA0), 'color': const Color(0xFFFFB4C4)},
    {'emoji': '🏠', 'title': 'Good Morning', 'bg': const Color(0xFFFFF0F5), 'color': const Color(0xFFFF8BA0)},
    {'emoji': '📸', 'title': 'Snap & Log', 'bg': const Color(0xFFFF8BA0), 'color': const Color(0xFFFFB4C4)},
    {'emoji': '🍽️', 'title': 'Delicious!', 'bg': const Color(0xFFFF8BA0), 'color': const Color(0xFFFFB4C4)},
    {'emoji': '📋', 'title': 'Meal History', 'bg': const Color(0xFFFFF0F5), 'color': const Color(0xFFFF8BA0)},
    {'emoji': '🍎', 'title': 'Nutrition Info', 'bg': const Color(0xFFFFF5F5), 'color': const Color(0xFFFFB74D)},
    {'emoji': '💧', 'title': 'Stay Hydrated', 'bg': const Color(0xFFE3F2FD), 'color': const Color(0xFF1976D2)},
    {'emoji': '⚖️', 'title': 'Weight Log', 'bg': const Color(0xFFFFF8F0), 'color': const Color(0xFFFF8BA0)},
    {'emoji': '📊', 'title': 'BMI Calculator', 'bg': const Color(0xFFFFF8F0), 'color': const Color(0xFFFFB74D)},
    {'emoji': '🌙', 'title': '16:8 Fasting', 'bg': const Color(0xFF1A1A2E), 'color': const Color(0xFF6C63FF)},
    {'emoji': '⏰', 'title': 'Fasting Schedule', 'bg': const Color(0xFFE8F5E9), 'color': const Color(0xFF4CAF50)},
    {'emoji': '📈', 'title': 'Progress', 'bg': const Color(0xFFFFF8F0), 'color': const Color(0xFFFF8BA0)},
    {'emoji': '📅', 'title': 'Weekly Report', 'bg': const Color(0xFFFFF8F0), 'color': const Color(0xFFFFB74D)},
    {'emoji': '📆', 'title': 'Monthly Report', 'bg': const Color(0xFFFFF8F0), 'color': const Color(0xFFFF8BA0)},
    {'emoji': '🏆', 'title': 'Achievements', 'bg': const Color(0xFFFFF8E1), 'color': const Color(0xFFFFD700)},
    {'emoji': '🎖️', 'title': 'Badge Unlocked', 'bg': const Color(0xFFFFF8E1), 'color': const Color(0xFFFFD700)},
    {'emoji': '🛍️', 'title': 'Pet Shop', 'bg': const Color(0xFFFFF8E1), 'color': const Color(0xFFFFD700)},
    {'emoji': '🎁', 'title': 'Product Detail', 'bg': const Color(0xFFFFF8E1), 'color': const Color(0xFFFFD700)},
    {'emoji': '💳', 'title': 'Confirm Purchase', 'bg': const Color(0xFFFFE4B5), 'color': const Color(0xFF9B59B6)},
    {'emoji': '🐻', 'title': 'My Pet', 'bg': const Color(0xFFFFF0F5), 'color': const Color(0xFFFF8BA0)},
    {'emoji': '👗', 'title': 'Dress Up', 'bg': const Color(0xFFFFF8E1), 'color': const Color(0xFFFFD700)},
    {'emoji': '👤', 'title': 'Profile', 'bg': const Color(0xFFF5F5F5), 'color': const Color(0xFF6B9EB8)},
    {'emoji': '⚙️', 'title': 'Settings', 'bg': const Color(0xFFFAFAFA), 'color': const Color(0xFF636E72)},
    {'emoji': '🔔', 'title': 'Notifications', 'bg': const Color(0xFFF5F5F5), 'color': const Color(0xFF6B9EB8)},
    {'emoji': '🎯', 'title': 'Set Goals', 'bg': const Color(0xFFF0F4FF), 'color': const Color(0xFF9B8FE8)},
    {'emoji': '👑', 'title': 'Go Premium', 'bg': const Color(0xFF1A1A2E), 'color': const Color(0xFF9B59B6)},
    {'emoji': '🔐', 'title': 'Welcome Back', 'bg': const Color(0xFFFFFFFF), 'color': const Color(0xFF6B9EB8)},
    {'emoji': '📝', 'title': 'Create Account', 'bg': const Color(0xFFFFFFFF), 'color': const Color(0xFF6B9EB8)},
    {'emoji': '🔑', 'title': 'Reset Password', 'bg': const Color(0xFFFFFFFF), 'color': const Color(0xFF6B9EB8)},
    {'emoji': '🔍', 'title': 'Search', 'bg': const Color(0xFFFFFFFF), 'color': const Color(0xFF6B9EB8)},
    {'emoji': '📅', 'title': 'Calendar', 'bg': const Color(0xFFE3F2FD), 'color': const Color(0xFF1976D2)},
    {'emoji': '🔄', 'title': 'Sync Data', 'bg': const Color(0xFFFFFFFF), 'color': const Color(0xFF6B9EB8)},
    {'emoji': '❓', 'title': 'Help & Support', 'bg': const Color(0xFFFFFFFF), 'color': const Color(0xFF6B9EB8)},
    {'emoji': 'ℹ️', 'title': 'About Us', 'bg': const Color(0xFFFFFFFF), 'color': const Color(0xFF6B9EB8)},
    {'emoji': '🔒', 'title': 'Privacy Policy', 'bg': const Color(0xFFFAFAFA), 'color': const Color(0xFF636E72)},
    {'emoji': '📜', 'title': 'Terms of Service', 'bg': const Color(0xFFFAFAFA), 'color': const Color(0xFF636E72)},
    {'emoji': '🏅', 'title': 'Hall of Fame', 'bg': const Color(0xFFFFF8E1), 'color': const Color(0xFFFFD700)},
    {'emoji': '✅', 'title': 'Daily Tasks', 'bg': const Color(0xFFE8F5E9), 'color': const Color(0xFF4CAF50)},
    {'emoji': '🎉', 'title': 'Activities', 'bg': const Color(0xFFFFF8E1), 'color': const Color(0xFFFFD700)},
    {'emoji': '🎊', 'title': 'Congratulations!', 'bg': const Color(0xFFFFE4B5), 'color': const Color(0xFFFFD700)},
    {'emoji': '🎉', 'title': 'All Done!', 'bg': const Color(0xFFFFD700), 'color': const Color(0xFFFFB74D)},
  ];

  late AnimationController _bgColorController;
  late AnimationController _buttonController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _pageController = PageController(
      viewportFraction: 1.0,
      initialPage: 0,
    );
    
    _bgColorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bgColorController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
      setState(() => _currentPage++);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      HapticFeedback.lightImpact();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
      setState(() => _currentPage--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _pageData[_currentPage];
    
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              data['bg'],
              Color.lerp(data['bg'], const Color(0xFFC1DDF1), 0.5)!,
            ],
          ),
        ),
        child: Stack(
          children: [
            // PageView
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                P01SplashScreen(),
                P02Onboard1Screen(),
                P03Onboard2Screen(),
                P04Onboard3Screen(),
                P05HomeScreen(),
                P06CaptureScreen(),
                P07MealResultScreen(),
                P08MealHistoryScreen(),
                P09MealDetailScreen(),
                P10WaterScreen(),
                P11WeightScreen(),
                P12BmiScreen(),
                P13FastingScreen(),
                P14FastingSetScreen(),
                P15ProgressScreen(),
                P16WeeklyScreen(),
                P17MonthlyScreen(),
                P18AchievementsScreen(),
                P19AchievementDetailScreen(),
                P20ShopScreen(),
                P21ProductScreen(),
                P22PurchaseScreen(),
                P23PetDetailScreen(),
                P24PetDressScreen(),
                P25ProfileScreen(),
                P26SettingsScreen(),
                P27NotificationScreen(),
                P28GoalsScreen(),
                P29SubscriptionScreen(),
                P30LoginScreen(),
                P31RegisterScreen(),
                P32ForgotScreen(),
                P33SearchScreen(),
                P34CalendarScreen(),
                P35SyncScreen(),
                P36HelpScreen(),
                P37AboutScreen(),
                P38PrivacyScreen(),
                P39TermsScreen(),
                P40HonorScreen(),
                P41DailyTaskScreen(),
                P42ActivityScreen(),
                P43CelebrationScreen(),
                P44CompleteScreen(),
              ],
            ),
            
            // 页面指示器
            _buildPageIndicator(),
            
            // 底部导航
            _buildSmartNavigator(data),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_totalPages, (index) {
          final isActive = index == _currentPage;
          final isNearby = (index - _currentPage).abs() <= 2;
          
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: isActive ? 20 : (isNearby ? 8 : 6),
            height: 8,
            decoration: BoxDecoration(
              color: isActive 
                  ? _pageData[_currentPage]['color']
                  : Colors.white.withValues(alpha: isNearby ? 0.5 : 0.3),
              borderRadius: BorderRadius.circular(4),
              boxShadow: isActive
                  ? [BoxShadow(
                      color: _pageData[_currentPage]['color'].withValues(alpha: 0.5),
                      blurRadius: 8,
                    )]
                  : null,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSmartNavigator(Map<String, dynamic> data) {
    return Positioned(
      left: 24,
      right: 24,
      bottom: MediaQuery.of(context).padding.bottom + 30,
      child: Row(
        children: [
          // 返回
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _currentPage > 0 ? 1.0 : 0.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentPage > 0 ? 56 : 0,
              child: _currentPage > 0
                  ? GestureDetector(
                      onTapDown: (_) => _buttonController.forward(),
                      onTapUp: (_) {
                        _buttonController.reverse();
                        _previousPage();
                      },
                      onTapCancel: () => _buttonController.reverse(),
                      child: ScaleTransition(
                        scale: _buttonScaleAnimation,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Color(0xFF636E72),
                            size: 20,
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          
          if (_currentPage > 0) const SizedBox(width: 12),
          
          // 主按钮
          Expanded(
            child: GestureDetector(
              onTapDown: (_) => _buttonController.forward(),
              onTapUp: (_) {
                _buttonController.reverse();
                _nextPage();
              },
              onTapCancel: () => _buttonController.reverse(),
              child: ScaleTransition(
                scale: _buttonScaleAnimation,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        data['color'],
                        Color.lerp(data['color'], Colors.white, 0.3)!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: data['color'].withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data['emoji'],
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _currentPage < _totalPages - 1 ? '下一步' : '完成',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      if (_currentPage < _totalPages - 1) ...[
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white70,
                          size: 18,
                        ),
                      ],
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
