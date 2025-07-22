import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState {
  final ThemeMode themeMode;

  ThemeState({this.themeMode = ThemeMode.system});

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }
}

class ThemeStateNotifier extends StateNotifier<ThemeState> {
  static const String _themeKey = 'themeMode';

  ThemeStateNotifier() : super(ThemeState()) {
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeMode = prefs.getString(_themeKey);
    state = state.copyWith(themeMode: _getThemeModeFromString(themeMode));
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, _getStringFromThemeMode(themeMode));
  }

  ThemeMode _getThemeModeFromString(String? themeMode) {
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _getStringFromThemeMode(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}

final themeStateProvider = StateNotifierProvider<ThemeStateNotifier, ThemeState>((ref) {
  return ThemeStateNotifier();
});
