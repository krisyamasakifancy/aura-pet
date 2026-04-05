import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'providers/pet_provider.dart';
import 'providers/nutrition_provider.dart';
import 'providers/shop_provider.dart';
import 'providers/achievement_provider.dart';
import 'screens/main_navigation.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'services/quote_engine.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Quote Engine
  await QuoteEngine.instance.init();
  
  // Lock orientation to portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
  
  runApp(const AuraPetApp());
}

class AuraPetApp extends StatelessWidget {
  const AuraPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // App state - user session, loading states
        ChangeNotifierProvider(create: (_) => AppState()),
        
        // Pet state - mood, XP, level, accessories
        ChangeNotifierProvider(create: (_) => PetProvider()),
        
        // Nutrition tracking - calories, macros, water
        ChangeNotifierProvider(create: (_) => NutritionProvider()),
        
        // Shop system - items, purchases
        ChangeNotifierProvider(create: (_) => ShopProvider()),
        
        // Achievements - progress, unlocks
        ChangeNotifierProvider(create: (_) => AchievementProvider()),
      ],
      child: MaterialApp(
        title: 'Aura-Pet',
        debugShowCheckedModeBanner: false,
        theme: AuraPetTheme.lightTheme,
        
        // Initial route based on onboarding status
        initialRoute: '/',
        
        // Route generator
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (_) => const SplashScreen(),
                settings: settings,
              );
            case '/onboarding':
              return MaterialPageRoute(
                builder: (_) => const OnboardingScreen(),
                settings: settings,
              );
            case '/auth/login':
              return MaterialPageRoute(
                builder: (_) => const LoginScreen(),
                settings: settings,
              );
            case '/main':
            case '/home':
              return MaterialPageRoute(
                builder: (_) => const MainNavigation(),
                settings: settings,
              );
            default:
              return MaterialPageRoute(
                builder: (_) => const MainNavigation(),
                settings: settings,
              );
          }
        },
      ),
    );
  }
}
