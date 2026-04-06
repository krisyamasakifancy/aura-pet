import 'package:flutter/material.dart';
import 'p22_weight_prediction.dart';
import 'p27_welcome_home.dart';
import 'p31_food_search.dart';
import 'p32_food_list.dart';
import 'p33_calorie_calculator.dart';
import 'p35_fasting_timer.dart';
import 'p39_profile.dart';

/// Main BitePal Onboarding Scaffold - MVP 精简版
class BitePalOnboarding extends StatefulWidget {
  final VoidCallback? onComplete;
  
  const BitePalOnboarding({super.key, this.onComplete});

  @override
  State<BitePalOnboarding> createState() => _BitePalOnboardingState();
}

class _BitePalOnboardingState extends State<BitePalOnboarding> {
  late PageController _pageController;
  int _currentPage = 0;
  final int _totalPages = 7;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _goToPage(_currentPage + 1);
    } else {
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEDF6FA), Color(0xFFFAF5F0)],
          ),
        ),
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (page) => setState(() => _currentPage = page),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                P22WeightPrediction(onNext: _nextPage),
                P27WelcomeHome(onNext: _nextPage),
                const P31FoodSearch(),
                P32FoodList(onNext: _nextPage),
                P33CalorieCalculator(onNext: _nextPage),
                P35FastingTimer(onNext: _nextPage),
                P39Profile(onNext: _nextPage),
              ],
            ),
            if (_currentPage > 0)
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: _buildPageIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _totalPages,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == _currentPage ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == _currentPage
                ? const Color(0xFF6B9EB8)
                : const Color(0xFF6B9EB8).withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
