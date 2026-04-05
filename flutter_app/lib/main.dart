import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'providers/pet_provider.dart';
import 'providers/nutrition_provider.dart';
import 'providers/shop_provider.dart';
import 'providers/achievement_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/meal/meal_capture_screen.dart';
import 'screens/meal/meal_result_screen.dart';
import 'screens/meal/meal_history_screen.dart';
import 'screens/fasting/fasting_screen.dart';
import 'screens/water/water_screen.dart';
import 'screens/weight/weight_screen.dart';
import 'screens/bmi/bmi_screen.dart';
import 'screens/progress/progress_screen.dart';
import 'screens/achievements/achievements_screen.dart';
import 'screens/shop/shop_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/subscription/subscription_screen.dart';
import 'screens/pet/pet_detail_screen.dart';
import 'screens/meal/meal_detail_screen.dart';
import 'utils/theme.dart';
import 'utils/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const AuraPetApp());
}

class AuraPetApp extends StatelessWidget {
  const AuraPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => PetProvider()),
        ChangeNotifierProvider(create: (_) => NutritionProvider()),
        ChangeNotifierProvider(create: (_) => ShopProvider()),
        ChangeNotifierProvider(create: (_) => AchievementProvider()),
      ],
      child: MaterialApp(
        title: 'Aura-Pet',
        debugShowCheckedModeBanner: false,
        theme: AuraPetTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
