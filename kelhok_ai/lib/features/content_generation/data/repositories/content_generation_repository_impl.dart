import 'package:dartz/dartz.dart';
import 'package:logging/logging.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/story_entity.dart';
import '../../domain/entities/caption_entity.dart';
import '../../domain/repositories/content_generation_repository.dart';
import '../datasources/content_generation_remote_datasource.dart';

/// Concrete implementation of ContentGenerationRepository
class ContentGenerationRepositoryImpl implements ContentGenerationRepository {
  final ContentGenerationRemoteDataSource remoteDataSource;
  final Logger logger;

  ContentGenerationRepositoryImpl({
    required this.remoteDataSource,
    required this.logger,
  });

  @override
  Future<Either<Failure, StoryEntity>> generateStory({
    required String prompt,
    String? character,
  }) async {
    try {
      logger.info('Repository: Generating story with prompt: $prompt');
      
      final result = await remoteDataSource.generateContent(
        prompt: prompt,
        character: character,
      );
      
      final storyEntity = result.toStoryEntity();
      logger.info('Repository: Successfully generated story');
      
      return Right(storyEntity);
    } on ServerException catch (e) {
      logger.warning('Repository: Server error occurred: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      logger.warning('Repository: Network error occurred: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      logger.severe('Repository: Unexpected error occurred: $e');
      return Left(GeneralFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, CaptionEntity>> generateCaption({
    required String prompt,
    String? character,
  }) async {
    try {
      logger.info('Repository: Generating caption with prompt: $prompt');
      
      final result = await remoteDataSource.generateContent(
        prompt: prompt,
        character: character,
      );
      
      final captionEntity = result.toCaptionEntity();
      logger.info('Repository: Successfully generated caption');
      
      return Right(captionEntity);
    } on ServerException catch (e) {
      logger.warning('Repository: Server error occurred: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      logger.warning('Repository: Network error occurred: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      logger.severe('Repository: Unexpected error occurred: $e');
      return Left(GeneralFailure(message: 'An unexpected error occurred'));
    }
  }
} 