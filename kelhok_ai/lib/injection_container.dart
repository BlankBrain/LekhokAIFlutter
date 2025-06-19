import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';

// Features - Content Generation
import 'features/content_generation/data/datasources/content_generation_remote_datasource.dart';
import 'features/content_generation/data/repositories/content_generation_repository_impl.dart';
import 'features/content_generation/domain/repositories/content_generation_repository.dart';
import 'features/content_generation/domain/usecases/generate_story_usecase.dart';
import 'features/content_generation/domain/usecases/generate_caption_usecase.dart';
import 'features/content_generation/presentation/providers/content_generation_provider.dart';

final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> init() async {
  // Initialize logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // Use debugPrint for development, which is safer than print
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      debugPrint('Error: ${record.error}');
    }
    if (record.stackTrace != null) {
      debugPrint('Stack trace: ${record.stackTrace}');
    }
  });

  //! Features - Content Generation
  // Providers (Riverpod StateNotifiers)
  sl.registerFactory(() => ContentGenerationProvider(
        generateStoryUseCase: sl(),
        generateCaptionUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GenerateStoryUseCase(sl()));
  sl.registerLazySingleton(() => GenerateCaptionUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ContentGenerationRepository>(
    () => ContentGenerationRepositoryImpl(
      remoteDataSource: sl(),
      logger: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ContentGenerationRemoteDataSource>(
    () => ContentGenerationRemoteDataSourceImpl(
      httpClient: sl(),
      logger: sl(),
    ),
  );

  //! Core
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Logger('KelhokAI'));
}

/// Dispose all dependencies
void dispose() {
  sl.reset();
} 