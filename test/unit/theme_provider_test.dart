import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tugende/providers/theme_provider.dart';

void main() {
  group('ThemeProvider Unit Tests', () {
    late ProviderContainer container;

    setUp(() {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial theme state should be system', () {
      final themeState = container.read(themeStateProvider);
      expect(themeState.themeMode, ThemeMode.system);
    });

    test('Theme state should update when setThemeMode is called', () async {
      final notifier = container.read(themeStateProvider.notifier);
      
      // Change to light theme
      await notifier.setThemeMode(ThemeMode.light);
      
      final themeState = container.read(themeStateProvider);
      expect(themeState.themeMode, ThemeMode.light);
    });

    test('Theme state should update to dark mode', () async {
      final notifier = container.read(themeStateProvider.notifier);
      
      // Change to dark theme
      await notifier.setThemeMode(ThemeMode.dark);
      
      final themeState = container.read(themeStateProvider);
      expect(themeState.themeMode, ThemeMode.dark);
    });

    test('Theme state should persist between sessions', () async {
      // Set mock SharedPreferences with saved theme
      SharedPreferences.setMockInitialValues({'themeMode': 'dark'});
      
      final newContainer = ProviderContainer();
      
      // Trigger the provider to initialize and wait for async _loadSavedTheme to complete
      newContainer.read(themeStateProvider.notifier);
      await Future.delayed(Duration(milliseconds: 200));
      
      final themeState = newContainer.read(themeStateProvider);
      expect(themeState.themeMode, ThemeMode.dark);
      
      newContainer.dispose();
    });

    test('copyWith should create new state with updated theme', () {
      final originalState = ThemeState(themeMode: ThemeMode.light);
      final newState = originalState.copyWith(themeMode: ThemeMode.dark);
      
      expect(originalState.themeMode, ThemeMode.light);
      expect(newState.themeMode, ThemeMode.dark);
    });

    test('copyWith should keep original theme when no parameter provided', () {
      final originalState = ThemeState(themeMode: ThemeMode.light);
      final newState = originalState.copyWith();
      
      expect(originalState.themeMode, ThemeMode.light);
      expect(newState.themeMode, ThemeMode.light);
    });
  });
}
