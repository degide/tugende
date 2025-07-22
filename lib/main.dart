import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tugende/config/routes_config.dart';
import 'package:tugende/config/theme_config.dart';
import 'package:tugende/providers/theme_provider.dart';
import 'package:tugende/screens/splash_screen.dart';
import 'package:tugende/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: TugendeApp()));
}

class TugendeApp extends ConsumerWidget {
  const TugendeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeStateProvider);

    return MaterialApp(
      title: 'Tugende',
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      themeMode: themeState.themeMode,
      routes: {
        RouteNames.splashScreen: (context) => const SplashScreen(),
        RouteNames.welcomeScreen: (context) => const WelcomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
