import 'package:flutter/material.dart';

class ThemeConfig {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF143A37),
    scaffoldBackgroundColor: Color(0xFF143A37),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF143A37),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    iconTheme: IconThemeData(color: Colors.white),
    colorScheme: ColorScheme.light(
      primary: Color(0xFF143A37),
      secondary: Colors.yellow,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF143A37),
    scaffoldBackgroundColor: Color(0xFF1E1E1E),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.grey),
    ),
    iconTheme: IconThemeData(color: Colors.white),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF143A37),
      secondary: Colors.yellow,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
    ),
  );
}