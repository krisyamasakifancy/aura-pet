import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_state.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/monet_background.dart';
import 'p01_splash.dart';
import 'p02_welcome.dart';
import 'p03_feature_calories.dart';
import 'p04_feature_hydration.dart';
import 'p05_feature_fasting.dart';
import 'p06_feature_results.dart';
import 'p07_feature_nutrition.dart';
import 'p08_channel_survey.dart';
import 'p09_goal_selection.dart';
import 'p10_additional_goals.dart';
import 'p11_gender_selection.dart';
import 'p12_age_input.dart';
import 'p13_height_input.dart';
import 'p14_current_weight.dart';
import 'p15_goal_weight.dart';
import 'p16_activity_level.dart';
import 'p17_analyzing.dart';
import 'p18_personalized_plan.dart';
import 'p19_user_reviews.dart';
import 'p20_notifications.dart';
import 'p21_plan_loading.dart';
import 'p22_weight_prediction.dart';
import 'p23_habit_analysis.dart';
import 'p24_paywall.dart';
import 'p25_price_comparison.dart';
import 'p26_commitment.dart';
import 'p27_welcome_home.dart';
import 'p28_home_calories.dart';
import 'p29_home_macros.dart';
import 'p30_mood_check.dart';
import 'p31_food_search.dart';
import 'p32_food_list.dart';
import 'p33_calorie_calculator.dart';
import 'p34_fasting_plans.dart';
import 'p35_fasting_timer.dart';
import 'p36_water_detail.dart';
import 'p37_water_history.dart';
import 'p38_achievements.dart';
import 'p39_profile.dart';
import 'p40_settings.dart';
import 'p41_goal_celebration.dart';
import 'p42_pet_dressing.dart';
import 'p43_weekly_report.dart';
import 'p44_badge_detail.dart';
import 'p45_notification_settings.dart';
import 'p46_about.dart';

/// BitePal 46-Screen Stage System
/// PageView with button-only navigation (NeverScrollableScrollPhysics)
class BitePalOnboarding extends StatefulWidget {
  const BitePalOnboarding({super.key});

  @override
  State<BitePalOnboarding> createState() => _BitePalOnboardingState();
}

class _BitePalOnboardingState extends State<BitePalOnboarding> {
  late PageController _pageController;
  int _currentPage = 0;
  static const int _totalPages = 46;
  
  // Transition curve
  static const Curve _transitionCurve = Curves.easeInOutCubic;
  static const Duration _transitionDuration = Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    // Haptic feedback on page change
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    // Optional: track analytics
  }

  /// Navigate to next page (唯一导航方式)
  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: _transitionDuration,
        curve: _transitionCurve,
      );
    }
  }

  /// Navigate to previous page
  void _previousPage() {
    if (_currentPage > 0) {
      HapticFeedback.lightImpact();
      _pageController.previousPage(
        duration: _transitionDuration,
        curve: _transitionCurve,
      );
    }
  }

  /// Jump to specific page (for skip logic)
  void jumpToPage(int page) {
    if (page >= 0 && page < _totalPages) {
      _pageController.animateToPage(
        page,
        duration: _transitionDuration,
        curve: _transitionCurve,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingState()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            // Monet Gradient Background
            MonetBackground(currentPage: _currentPage),
            
            // Page View - 禁止手势滑动
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) {
                setState(() => _currentPage = page);
              },
              children: [
                // P1: Splash
                P01Splash(onComplete: _nextPage),
                // P2: Welcome
                P02Welcome(onNext: _nextPage),
                // P3: Feature - Calories
                P03FeatureCalories(onNext: _nextPage),
                // P4: Feature - Hydration
                P04FeatureHydration(onNext: _nextPage),
                // P5: Feature - Fasting
                P05FeatureFasting(onNext: _nextPage),
                // P6: Feature - Results
                P06FeatureResults(onNext: _nextPage),
                // P7: Feature - Nutrition
                P07FeatureNutrition(onNext: _nextPage),
                // P8: Channel Survey
                P08ChannelSurvey(onNext: _nextPage),
                // P9: Goal Selection
                P09GoalSelection(onNext: _nextPage),
                // P10: Additional Goals
                P10AdditionalGoals(onNext: _nextPage),
                // P11: Gender
                P11GenderSelection(onNext: _nextPage),
                // P12: Age
                P12AgeInput(onNext: _nextPage),
                // P13: Height
                P13HeightInput(onNext: _nextPage),
                // P14: Current Weight
                P14CurrentWeight(onNext: _nextPage),
                // P15: Goal Weight
                P15GoalWeight(onNext: _nextPage),
                // P16: Activity Level
                P16ActivityLevel(onNext: _nextPage),
                // P17: Analyzing
                P17Analyzing(onComplete: _nextPage),
                // P18: Personalized Plan
                P18PersonalizedPlan(onNext: _nextPage),
                // P19: User Reviews
                P19UserReviews(onNext: _nextPage),
                // P20: Notifications
                P20Notifications(onNext: _nextPage),
                // P21: Plan Loading
                P21PlanLoading(onComplete: _nextPage),
                // P22: Weight Prediction
                P22WeightPrediction(onNext: _nextPage),
                // P23: Habit Analysis
                P23HabitAnalysis(onNext: _nextPage),
                // P24: Paywall
                P24Paywall(onNext: _nextPage),
                // P25: Price Comparison
                P25PriceComparison(onNext: _nextPage),
                // P26: Commitment
                P26Commitment(onNext: _nextPage),
                // P27: Welcome Home
                P27WelcomeHome(onNext: _nextPage),
                // P28: Home - Calories
                P28HomeCalories(onNext: _nextPage),
                // P29: Home - Macros
                P29HomeMacros(onNext: _nextPage),
                // P30: Mood Check
                P30MoodCheck(onNext: _nextPage),
                // P31: Food Search
                P31FoodSearch(onNext: _nextPage),
                // P32: Food List
                P32FoodList(onNext: _nextPage),
                // P33: Calorie Calculator
                P33CalorieCalculator(onNext: _nextPage),
                // P34: Fasting Plans
                P34FastingPlans(onNext: _nextPage),
                // P35: Fasting Timer
                P35FastingTimer(onNext: _nextPage),
                // P36: Water Detail
                P36WaterDetail(onNext: _nextPage),
                // P37: Water History
                P37WaterHistory(onNext: _nextPage),
                // P38: Achievements
                P38Achievements(onNext: _nextPage),
                // P39: Profile
                P39Profile(onNext: _nextPage),
                // P40: Settings
                P40Settings(onNext: _nextPage),
                // P41: Goal Celebration
                P41GoalCelebration(onNext: _nextPage),
                // P42: Pet Dressing
                P42PetDressing(onNext: _nextPage),
                // P43: Weekly Report
                P43WeeklyReport(onNext: _nextPage),
                // P44: Badge Detail
                P44BadgeDetail(onNext: _nextPage),
                // P45: Notification Settings
                P45NotificationSettings(onNext: _nextPage),
                // P46: About
                P46About(onComplete: _nextPage),
              ],
            ),
            
            // Progress Indicator (Top)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 24,
              right: 24,
              child: _buildProgressBar(),
            ),
            
            // Page Counter (if needed)
            if (_currentPage > 0)
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                right: 24,
                child: Text(
                  '${_currentPage + 1}/$_totalPages',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = (_currentPage + 1) / _totalPages;
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2ECC71), // Green
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
