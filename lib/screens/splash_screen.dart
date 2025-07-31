import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tugende/config/routes_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tugende/dto/user_doc_dto.dart';
import 'package:tugende/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initAppState();
  }

  Future<GoogleSignInAccount?> _initializeGoogleSignIn() async {
    try {
      final googleSignIn = ref.read(googleSignInProvider);

      await googleSignIn.initialize(
        clientId: '517026597072-0opfisfsoi6s7gh3124de0matqpk1287.apps.googleusercontent.com', // **IMPORTANT: Replace with your actual client ID**
        // serverClientId: 'YOUR_SERVER_CLIENT_ID.apps.googleusercontent.com', // **IMPORTANT: Replace if you have a server client ID**
      );

      // Optionally, attempt lightweight authentication if you want to check for a previously signed-in user
      // without user interaction.
      final user = await googleSignIn.attemptLightweightAuthentication();
      return user;
    } catch (e) {
      if (kDebugMode) {
        print('Google Sign-In initialization failed: $e');
      }
      return null;
    }
  }

  void _initAppState() async {
    GoogleSignInAccount? googleUser = await _initializeGoogleSignIn();
    if (googleUser != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').where('googleId', isEqualTo: googleUser.id);
      final docSnapshot = await userDoc.get();
      if (mounted && docSnapshot.docs.isNotEmpty) {
        final user = UserDocDto.fromJson(docSnapshot.docs.first.data());
        ref.read(userStateProvider.notifier).signInUser(user);
        Navigator.pushNamedAndRemoveUntil(context, RouteNames.homeScreen, (route) => false);
      }
      return;
    }
    else if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        RouteNames.welcomeScreen,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: Text(
                  'TUGENDE',
                  style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              RotatedBox(
                quarterTurns: 3,
                child: Text(
                  'APP',
                  style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
