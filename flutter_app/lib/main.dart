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
import 'screens/onboarding/aura_onboarding_screen.dart';
import 'screens/aura_home_screen.dart';
import 'screens/aura_demo_showcase.dart';
import 'screens/page_navigator.dart';
import 'screens/bitepal_onboarding/main_onboarding.dart';
import 'screens/fasting/aura_fasting_screen.dart';
import 'screens/auth/login_screen.dart';
import 'services/quote_engine.dart';
import 'services/monet_clock.dart';
import 'services/haptic_audio.dart';
import 'utils/aura_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize engines
  await QuoteEngine.instance.init();
  MonetClock.instance.start();
  
  // Lock orientation to portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  // Enable 120Hz rendering
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  
  // Set preferred frame rate
  final window = WidgetsBinding.instance.window;
  window.setPreferredFrameRate(120);
  
  // Set status bar style (will be updated by MonetClock)
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  
  runApp(const AuraPetApp());
}

class AuraPetApp extends StatefulWidget {
  const AuraPetApp({super.key});

  @override
  State<AuraPetApp> createState() => _AuraPetAppState();
}

class _AuraPetAppState extends State<AuraPetApp> with WidgetsBindingObserver {
  MonetColors _currentColors = MonetColors.getCurrentColors();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Listen to MonetClock changes
    MonetClock.instance.addListener(_onMonetClockChange);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    MonetClock.instance.removeListener(_onMonetClockChange);
    super.dispose();
  }

  void _onMonetClockChange() {
    setState(() {
      _currentColors = MonetColors.getCurrentColors();
    });
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
        
        // MonetClock for time-aware theming
        ChangeNotifierProvider.value(value: MonetClock.instance),
      ],
      child: MaterialApp(
        title: 'Aura-Pet',
        debugShowCheckedModeBanner: false,
        
        // Time-aware Monet theme
        theme: AuraPetTheme.lightTheme,
        darkTheme: MonetThemeBuilder.build(MonetColors.night),
        themeMode: ThemeMode.system,
        
        // Initial route based on onboarding status
        initialRoute: '/',
        
        // Silk-smooth page transitions
        pageRouteBuilder: (settings, builder) {
          return _SilkPageRoute(
            settings: settings,
            pageBuilder: builder,
          );
        },
        
        // Route generator
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return _SilkPageRoute(
                settings: settings,
                pageBuilder: (_) => const SplashScreen(),
              );
            case '/onboarding':
              return _SilkPageRoute(
                settings: settings,
                pageBuilder: (_) => const AuraOnboardingScreen(),
              );
            case '/auth/login':
              return _SilkPageRoute(
                settings: settings,
                pageBuilder: (_) => const LoginScreen(),
              );
            case '/main':
            case '/home':
              return _SilkPageRoute(
                settings: settings,
                pageBuilder: (_) => const AuraHomeScreen(),
              );
            case '/fasting':
              return _SilkPageRoute(
                settings: settings,
                pageBuilder: (_) => const AuraFastingScreen(),
              );
            case '/demo':
              return _SilkPageRoute(
                settings: settings,
                pageBuilder: (_) => const AuraDemoShowcase(),
              );
            case '/navigator':
              return _SilkPageRoute(
                settings: settings,
                pageBuilder: (_) => const AuraPageNavigator(),
              );
            case '/bitepal':
              return _SilkPageRoute(
                settings: settings,
                pageBuilder: (_) => const BitePalOnboarding(),
              );
            default:
              return _SilkPageRoute(
                settings: settings,
                pageBuilder: (_) => const MainNavigation(),
              );
          }
        },
        
        // Global error handling
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              // Enable high refresh rate hints
              preferStationaryColors: true,
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

/// 丝绸般顺滑的页面过渡
class _SilkPageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder pageBuilder;

  _SilkPageRoute({
    required RouteSettings settings,
    required this.pageBuilder,
  }) : super(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => 
        pageBuilder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // 丝绸顺滑曲线
      const silkCurve = _SilkSlideTransitionCurve();
      
      // 主页面淡入 + 轻微上移
      final fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.7, curve: silkCurve),
        ),
      );

      final slideUp = Tween<Offset>(
        begin: const Offset(0, 0.05),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.7, curve: silkCurve),
        ),
      );

      // 次页面淡出
      final fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.3, 1.0, curve: silkCurve),
        ),
      );

      return SlideTransition(
        position: slideUp,
        child: FadeTransition(
          opacity: fadeIn,
          child: FadeTransition(
            opacity: fadeOut,
            child: child,
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 300),
  );
}

/// 丝绸滑动过渡曲线
class _SilkSlideTransitionCurve extends Curve {
  const _SilkSlideTransitionCurve();
  
  @override
  double transformInternal(double t) {
    // 快速启动 → 优雅减速
    // 类似丝绸滑过手指的感觉
    return t * t * (3 - 2 * t);
  }
}
