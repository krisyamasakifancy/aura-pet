import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/main_navigation.dart';
import '../screens/home/home_screen.dart';
import '../screens/meal/meal_capture_screen.dart';
import '../screens/meal/meal_history_screen.dart';
import '../screens/meal/meal_detail_screen.dart';
import '../screens/meal/meal_result_screen.dart';
import '../screens/fasting/fasting_screen.dart';
import '../screens/water/water_screen.dart';
import '../screens/weight/weight_screen.dart';
import '../screens/bmi/bmi_screen.dart';
import '../screens/progress/progress_screen.dart';
import '../screens/achievements/achievements_screen.dart';
import '../screens/shop/shop_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/subscription/subscription_screen.dart';
import '../screens/pet/pet_detail_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Splash & Onboarding
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      
      // Auth
      case '/auth/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      // Main Tab Navigation
      case '/main':
        return MaterialPageRoute(builder: (_) => const MainNavigation());
      
      // Home
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      
      // Meal
      case '/meal/capture':
        return MaterialPageRoute(builder: (_) => const MealCaptureScreen());
      case '/meal/history':
        return MaterialPageRoute(builder: (_) => const MealHistoryScreen());
      case '/meal/detail':
        final record = settings.arguments as dynamic;
        return MaterialPageRoute(builder: (_) => MealDetailScreen(record: record));
      case '/meal/result':
        return MaterialPageRoute(builder: (_) => const MealResultScreen());
      
      // Fasting
      case '/fasting':
        return MaterialPageRoute(builder: (_) => const FastingScreen());
      
      // Water
      case '/water':
        return MaterialPageRoute(builder: (_) => const WaterScreen());
      
      // Weight & BMI
      case '/weight':
        return MaterialPageRoute(builder: (_) => const WeightScreen());
      case '/bmi':
        return MaterialPageRoute(builder: (_) => const BmiScreen());
      
      // Progress
      case '/progress':
        return MaterialPageRoute(builder: (_) => const ProgressScreen());
      
      // Achievements
      case '/achievements':
        return MaterialPageRoute(builder: (_) => const AchievementsScreen());
      
      // Shop
      case '/shop':
        return MaterialPageRoute(builder: (_) => const ShopScreen());
      
      // Pet
      case '/pet/detail':
        return MaterialPageRoute(builder: (_) => const PetDetailScreen());
      
      // Profile
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      
      // Settings
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      
      // Subscription
      case '/subscription':
        return MaterialPageRoute(builder: (_) => const SubscriptionScreen());
      
      // 404
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE5E0),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Text('🐻', style: TextStyle(fontSize: 50)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '404',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFFF9B7B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '页面不存在',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF636E72),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    settings.name ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFB2BEC3),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(_, '/home'),
                    child: const Text('返回首页 🏠'),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}

/// Route names constant class for type-safe routing
class Routes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/auth/login';
  static const String main = '/main';
  static const String home = '/home';
  static const String mealCapture = '/meal/capture';
  static const String mealHistory = '/meal/history';
  static const String mealDetail = '/meal/detail';
  static const String mealResult = '/meal/result';
  static const String fasting = '/fasting';
  static const String water = '/water';
  static const String weight = '/weight';
  static const String bmi = '/bmi';
  static const String progress = '/progress';
  static const String achievements = '/achievements';
  static const String shop = '/shop';
  static const String petDetail = '/pet/detail';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String subscription = '/subscription';
}
