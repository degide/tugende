import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tugende/config/routes_config.dart';
import 'package:tugende/config/theme_config.dart';
import 'package:tugende/providers/theme_provider.dart';
import 'package:tugende/screens/splash_screen.dart';
import 'package:tugende/screens/welcome_screen.dart';
import 'package:tugende/screens/verification_screen.dart';
import 'package:tugende/screens/phone_input_screen.dart';
import 'package:tugende/screens/otp_verification_screen.dart';
import 'package:tugende/screens/personal_details_screen.dart';
import 'package:tugende/screens/email_verification_screen.dart';
import 'package:tugende/screens/role_selection_screen.dart';
import 'package:tugende/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
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
        RouteNames.verificationScreen: (context) => const VerificationScreen(),
        RouteNames.phoneInputScreen: (context) => const PhoneInputScreen(),
        RouteNames.otpVerificationScreen: (context) => const OtpVerificationScreen(),
        RouteNames.personalDetailsScreen: (context) => const PersonalDetailsScreen(),
        RouteNames.emailVerificationScreen: (context) => const EmailVerificationScreen(),
        RouteNames.roleSelectionScreen: (context) => const RoleSelectionScreen(),
        RouteNames.loginScreen: (context) => const LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
