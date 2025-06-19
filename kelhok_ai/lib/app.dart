import 'package:flutter/material.dart';
import 'core/utils/constants.dart';
import 'features/content_generation/presentation/screens/content_generation_screen.dart';

/// Main application widget
class KelhokAIApp extends StatelessWidget {
  const KelhokAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const ContentGenerationScreen(),
    );
  }

  /// Builds the app theme
  ThemeData _buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        filled: true,
        contentPadding: const EdgeInsets.all(16.0),
      ),
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 12.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
        ),
      ),
      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 12.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
        ),
      ),
      // Card theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
      ),
    );
  }
} 