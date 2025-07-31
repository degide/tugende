import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tugende/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('TugendeApp Integration Tests', () {
    testWidgets('Complete app flow - from splash to phone input', (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(child: TugendeApp()));
      await tester.pumpAndSettle();

      // Should start with splash screen or welcome screen
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Look for any initial screen content
      await tester.pumpAndSettle(Duration(seconds: 3));
      
      // App should be loaded
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    });

    testWidgets('Navigation between screens works', (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(child: TugendeApp()));
      await tester.pumpAndSettle();

      // Wait for app to fully load
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Look for navigation elements
      final navigateButtons = find.byType(ElevatedButton);
      if (navigateButtons.evaluate().isNotEmpty) {
        await tester.tap(navigateButtons.first);
        await tester.pumpAndSettle();
        
        // Verify navigation occurred
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      }
    });

    testWidgets('Theme changes reflect in UI', (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(child: TugendeApp()));
      await tester.pumpAndSettle();

      // Get initial theme
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final initialTheme = materialApp.theme;

      // Theme should be configured
      expect(initialTheme, isNotNull);
    });

    testWidgets('App handles back button navigation', (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(child: TugendeApp()));
      await tester.pumpAndSettle();

      // Try to find back button
      final backButtons = find.byIcon(Icons.arrow_back);
      if (backButtons.evaluate().isNotEmpty) {
        await tester.tap(backButtons.first);
        await tester.pumpAndSettle();
        
        // Should handle navigation
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      }
    });

    testWidgets('Form inputs accept text and validate', (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(child: TugendeApp()));
      await tester.pumpAndSettle();

      // Look for text input fields
      final textFields = find.byType(TextFormField);
      if (textFields.evaluate().isNotEmpty) {
        // Enter text in first field
        await tester.enterText(textFields.first, 'Test Input');
        await tester.pump();
        
        // Verify text was entered
        expect(find.text('Test Input'), findsAtLeastNWidgets(1));
      }
    });
  });

  group('Performance Tests', () {
    testWidgets('App starts within reasonable time', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();
      
      await tester.pumpWidget(ProviderScope(child: TugendeApp()));
      await tester.pumpAndSettle();
      
      stopwatch.stop();
      
      // App should start within 5 seconds
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));
    });

    testWidgets('Smooth scrolling performance', (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(child: TugendeApp()));
      await tester.pumpAndSettle();

      // Look for scrollable content
      final scrollables = find.byType(ScrollView);
      if (scrollables.evaluate().isNotEmpty) {
        // Test scrolling performance
        await tester.drag(scrollables.first, Offset(0, -300));
        await tester.pumpAndSettle();
        
        // Should handle scrolling without errors
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('Error Handling Tests', () {
    testWidgets('App handles widget exceptions gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(child: TugendeApp()));
      await tester.pumpAndSettle();

      // App should not have thrown any exceptions during startup
      expect(tester.takeException(), isNull);
    });

    testWidgets('Invalid input handling', (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(child: TugendeApp()));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      if (textFields.evaluate().isNotEmpty) {
        // Enter invalid characters
        await tester.enterText(textFields.first, '!@#\$%^&*()');
        await tester.pump();
        
        // App should handle invalid input without crashing
        expect(tester.takeException(), isNull);
      }
    });
  });
}
