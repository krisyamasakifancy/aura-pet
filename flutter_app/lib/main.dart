import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'providers/pet_provider.dart';
import 'providers/nutrition_provider.dart';
import 'providers/shop_provider.dart';
import 'providers/achievement_provider.dart';
import 'screens/bitepal_onboarding/main_onboarding.dart';
import 'services/monet_clock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MonetClock.instance.start();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const AuraPetApp());
}

class AuraPetApp extends StatelessWidget {
  const AuraPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aura-Pet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BitePalOnboarding(),
    );
  }
}
