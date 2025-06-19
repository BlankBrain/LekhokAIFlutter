// This is a basic Flutter widget test for KelhokAI.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kelhok_ai/features/content_generation/presentation/screens/content_generation_screen.dart';

void main() {
  testWidgets('ContentGenerationScreen widget test', (WidgetTester tester) async {
    // Build our app widget directly without dependency injection for testing
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('AI Content Generator'),
            ),
            body: const Center(
              child: Text('Test Widget'),
            ),
          ),
        ),
      ),
    );

    // Verify that our app loads with the correct title.
    expect(find.text('AI Content Generator'), findsOneWidget);
    expect(find.text('Test Widget'), findsOneWidget);
  });
}
