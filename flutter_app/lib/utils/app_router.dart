import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/meal/meal_capture_screen.dart';
import '../screens/meal/meal_history_screen.dart';
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
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case '/auth/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/meal/capture':
        return MaterialPageRoute(builder: (_) => const MealCaptureScreen());
      case '/meal/history':
        return MaterialPageRoute(builder: (_) => const MealHistoryScreen());
      case '/meal/result':
        return MaterialPageRoute(builder: (_) => const MealResultScreen());
      case '/fasting':
        return MaterialPageRoute(builder: (_) => const FastingScreen());
      case '/water':
        return MaterialPageRoute(builder: (_) => const WaterScreen());
      case '/weight':
        return MaterialPageRoute(builder: (_) => const WeightScreen());
      case '/bmi':
        return MaterialPageRoute(builder: (_) => const BmiScreen());
      case '/progress':
        return MaterialPageRoute(builder: (_) => const ProgressScreen());
      case '/achievements':
        return MaterialPageRoute(builder: (_) => const AchievementsScreen());
      case '/shop':
        return MaterialPageRoute(builder: (_) => const ShopScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case '/subscription':
        return MaterialPageRoute(builder: (_) => const SubscriptionScreen());
      case '/pet/detail':
        return MaterialPageRoute(builder: (_) => const PetDetailScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('404', style: TextStyle(fontSize: 64, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 16),
                  Text('页面不存在: ${settings.name}'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(_, '/home'),
                    child: const Text('返回首页'),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}
