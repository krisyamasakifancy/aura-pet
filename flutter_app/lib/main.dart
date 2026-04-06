import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'providers/pet_provider.dart';
import 'providers/nutrition_provider.dart';
import 'providers/shop_provider.dart';
import 'providers/achievement_provider.dart';
import 'screens/main_navigation.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/aura_home_screen.dart';
import 'screens/aura_demo_showcase.dart';
import 'screens/page_navigator.dart';
import 'screens/bitepal_onboarding/main_onboarding.dart';
import 'screens/fasting/aura_fasting_screen.dart';
import 'screens/auth/login_screen.dart';
import 'providers/fullstack_providers.dart';
import 'services/monet_clock.dart';
import 'services/haptic_audio.dart';
import 'utils/aura_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize MonetClock
  MonetClock.instance.start();
  
  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  // Enable edge-to-edge mode
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  
  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  
  runApp(const AuraPetApp());
}

class AuraPetApp extends StatefulWidget {
  const AuraPetApp({super.key});

  @override
  State<AuraPetApp> createState() => _AuraPetAppState();
}

class _AuraPetAppState extends State<AuraPetApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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
        
        // Global Theme Controller - fasting mode, water tracking
        ChangeNotifierProvider(create: (_) => ThemeController()),
        
        // MonetClock for time-aware theming
        ChangeNotifierProvider.value(value: MonetClock.instance),
      ],
      child: MaterialApp(
        title: 'Aura-Pet',
        debugShowCheckedModeBanner: false,
        
        // Time-aware Monet theme
        theme: AuraPetTheme.lightTheme,
        darkTheme: AuraPetTheme.darkTheme,
        themeMode: ThemeMode.system,
        
        // Initial route
        initialRoute: '/',
        
        // Route generator
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (_) => const AuraDemoShowcase(),
              );
            case '/onboarding':
              return MaterialPageRoute(
                builder: (_) => const AuraOnboardingScreen(),
              );
            case '/auth/login':
              return MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              );
            case '/main':
            case '/home':
              return MaterialPageRoute(
                builder: (_) => const AuraHomeScreen(),
              );
            case '/fasting':
              return MaterialPageRoute(
                builder: (_) => const AuraFastingScreen(),
              );
            case '/demo':
              return MaterialPageRoute(
                builder: (_) => const AuraDemoShowcase(),
              );
            case '/navigator':
              return MaterialPageRoute(
                builder: (_) => const AuraPageNavigator(),
              );
            case '/bitepal':
              return MaterialPageRoute(
                builder: (_) => const BitePalOnboarding(),
              );
            default:
              return MaterialPageRoute(
                builder: (_) => const MainNavigation(),
              );
          }
        },
      ),
    );
  }
}
