import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/meal/meal_capture_screen.dart';
import '../screens/fasting/fasting_screen.dart';
import '../screens/water/water_screen.dart';
import '../screens/weight/weight_screen.dart';
import '../screens/progress/progress_screen.dart';
import '../screens/shop/shop_screen.dart';
import '../screens/subscription/subscription_screen.dart';

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
      case '/fasting':
        return MaterialPageRoute(builder: (_) => const FastingScreen());
      case '/water':
        return MaterialPageRoute(builder: (_) => const WaterScreen());
      case '/weight':
        return MaterialPageRoute(builder: (_) => const WeightScreen());
      case '/progress':
        return MaterialPageRoute(builder: (_) => const ProgressScreen());
      case '/shop':
        return MaterialPageRoute(builder: (_) => const ShopScreen());
      case '/subscription':
        return MaterialPageRoute(builder: (_) => const SubscriptionScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
