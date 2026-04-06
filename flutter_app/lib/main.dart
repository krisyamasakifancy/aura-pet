import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'providers/pet_provider.dart';
import 'providers/nutrition_provider.dart';
import 'providers/shop_provider.dart';
import 'providers/achievement_provider.dart';
import 'screens/bitepal_onboarding/main_onboarding.dart';
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
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider.value(value: MonetClock.instance),
      ],
      child: MaterialApp(
        title: 'Aura-Pet',
        debugShowCheckedModeBanner: false,
        theme: AuraPetTheme.lightTheme,
        themeMode: ThemeMode.light,
        home: const BitePalOnboarding(),
      ),
    );
  }
}
