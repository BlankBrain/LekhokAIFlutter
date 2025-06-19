import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'injection_container.dart' as di;

/// Main entry point of the KelhokAI application
Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await di.init();
  
  // Run the app with Riverpod
  runApp(
    const ProviderScope(
      child: KelhokAIApp(),
    ),
  );
}
