import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_state.dart';
import '../../providers/fullstack_providers.dart';
import 'p01_splash.dart';
import 'p02_welcome.dart';
import 'p03_feature_calories.dart';
import 'p04_feature_fasting.dart';
import 'p05_feature_results.dart';
import 'p06_feature_water.dart';
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
import '../../widgets/monet_background.dart';

/// Main BitePal Onboarding Scaffold
/// 46 screens with PageView navigation + Persistence + ThemeController
class BitePalOnboarding extends StatefulWidget {
  final VoidCallback? onComplete;
  
  const BitePalOnboarding({super.key, this.onComplete});

  @override
  State<BitePalOnboarding> createState() => _BitePalOnboardingState();
}

class _BitePalOnboardingState extends State<BitePalOnboarding> {
  late PageController _pageController;
  int _currentPage = 0;
  final int _totalPages = 46;
  
  // Auto-advance timer for splash
  bool _autoAdvance = true;
  final _persistence = PersistenceService();
  String _currentQuote = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    // Load quote for current context
    _updateQuote();
    
    // Splash auto-advances
    if (_autoAdvance && _currentPage == 0) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && _currentPage == 0) {
          _goToPage(1);
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    if (page < _totalPages && page >= 0) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
      
      // Update theme and quote on page change
      _updateThemeForPage(page);
      _updateQuote();
    }
  }

  void _updateThemeForPage(int page) {
    final theme = Provider.of<ThemeController>(context, listen: false);
    
    // Fasting mode triggers (P34 start fasting, P35 timer)
    if (page >= 33 && page <= 35) {
      theme.startFasting();
    } else {
      theme.stopFasting();
    }
    
    // Water level sync (P28 home shows water progress)
    final state = Provider.of<OnboardingState>(context, listen: false);
    theme.updateWaterLevel(state.waterIntakeMl, state.waterGoalMl);
  }

  void _updateQuote() {
    setState(() {
      // Default motivational quote
      _currentQuote = '💪 坚持下去，你是最棒的！';
    });
  }

  void _onStateChanged() {
    // Handle state changes
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onQuoteTriggered(String context) {
    final quote = QuoteEngine.instance.getQuote(context: context);
    setState(() {
      _currentQuote = quote;
    });
  }

  void _nextPage() {
    // Save data when completing onboarding (P46)
    if (_currentPage == _totalPages - 1) {
      _saveUserData();
      widget.onComplete?.call();
      return;
    }
    
    if (_currentPage < _totalPages - 1) {
      _goToPage(_currentPage + 1);
    }
  }

  Future<void> _saveUserData() async {
    final state = Provider.of<OnboardingState>(context, listen: false);
    
    await _persistence.saveUserMetrics(
      age: state.age,
      heightCm: state.heightCm,
      currentWeightKg: state.currentWeightKg,
      goalWeightKg: state.goalWeightKg,
      gender: state.gender,
      activityLevel: state.activityLevel,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);
    
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => OnboardingState()..addListener(_onStateChanged),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.backgroundColor,
                theme.backgroundGradientEnd,
              ],
            ),
          ),
          child: Stack(
          children: [
            // Monet gradient background
            MonetBackground(
              pageIndex: _currentPage,
              child: const SizedBox.expand(),
            ),
            // Page content
            PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              physics: const NeverScrollableScrollPhysics(), // NO GESTURES
              children: [
                // P01: Splash
                P01Splash(onNext: () => _goToPage(1)),
                // P02: Welcome
                P02Welcome(onNext: _nextPage),
                // P03-P07: Features
                P03FeatureCalories(onNext: _nextPage),
                P04FeatureFasting(onNext: _nextPage),
                P05FeatureResults(onNext: _nextPage),
                P06FeatureWater(onNext: _nextPage),
                P07FeatureNutrition(onNext: _nextPage),
                // P08-P16: Survey
                P08ChannelSurvey(onNext: _nextPage),
                P09GoalSelection(onNext: _nextPage),
                P10AdditionalGoals(onNext: _nextPage),
                P11GenderSelection(onNext: _nextPage),
                P12AgeInput(onNext: _nextPage),
                P13HeightInput(onNext: _nextPage),
                P14CurrentWeight(onNext: _nextPage),
                P15GoalWeight(onNext: _nextPage),
                P16ActivityLevel(onNext: _nextPage),
                // P17-P27: Engagement
                P17Analyzing(onNext: _nextPage),
                P18PersonalizedPlan(onNext: _nextPage),
                P19UserReviews(onNext: _nextPage),
                P20Notifications(onNext: _nextPage),
                P21PlanLoading(onNext: _nextPage),
                P22WeightPrediction(onNext: _nextPage),
                P23HabitAnalysis(onNext: _nextPage),
                P24Paywall(onNext: _nextPage),
                P25PriceComparison(onNext: _nextPage),
                P26Commitment(onNext: _nextPage),
                P27WelcomeHome(onNext: _nextPage),
                // P28-P37: App Tools
                P28HomeCalories(onNext: _nextPage),
                P29HomeMacros(onNext: _nextPage),
                P30MoodCheck(onNext: _nextPage),
                P31FoodSearch(),
                P32FoodList(onNext: _nextPage),
                P33CalorieCalculator(onNext: _nextPage),
                P34FastingPlans(onNext: _nextPage),
                P35FastingTimer(onNext: _nextPage),
                P36WaterDetail(onNext: _nextPage),
                P37WaterHistory(onNext: _nextPage),
                // P38-P46: Achievements
                P38Achievements(onNext: _nextPage),
                P39Profile(onNext: _nextPage),
                P40Settings(onNext: _nextPage),
                P41GoalCelebration(onNext: _nextPage),
                P42PetDressing(onNext: _nextPage),
                P43WeeklyReport(onNext: _nextPage),
                P44BadgeDetail(onNext: _nextPage),
                P45NotificationSettings(onNext: _nextPage),
                P46About(onNext: widget.onComplete ?? _nextPage),
              ],
            ),
            // Page indicator (show after splash)
            if (_currentPage > 0)
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentPage + 1} / $_totalPages',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
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
