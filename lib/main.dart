import 'package:flutter/material.dart';

void main() {
  runApp(const TugendeApp());
}

class TugendeApp extends StatelessWidget {
  const TugendeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugende',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Welcome to Tugende!'),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
