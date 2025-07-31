import 'package:flutter/material.dart';
import 'package:tugende/config/routes_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initAppState();
  }

  void _initAppState() async {
    await Future.delayed(Duration(seconds: 2));
    if (mounted) {
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
