import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/story_entity.dart';
import '../entities/caption_entity.dart';

/// Abstract repository interface for content generation
/// This defines the contract that the data layer must implement
abstract class ContentGenerationRepository {
  /// Generates a story based on the provided prompt
  /// Returns either a Failure or a StoryEntity
  Future<Either<Failure, StoryEntity>> generateStory({
    required String prompt,
    String? character,
  });

  /// Generates a caption based on the provided prompt
  /// Returns either a Failure or a CaptionEntity
  Future<Either<Failure, CaptionEntity>> generateCaption({
    required String prompt,
    String? character,
  });
} 