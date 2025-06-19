import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/story_entity.dart';
import '../repositories/content_generation_repository.dart';

/// Use case for generating a story
class GenerateStoryUseCase implements UseCase<StoryEntity, GenerateStoryParams> {
  final ContentGenerationRepository repository;

  GenerateStoryUseCase(this.repository);

  @override
  Future<Either<Failure, StoryEntity>> call(GenerateStoryParams params) async {
    return await repository.generateStory(
      prompt: params.prompt,
      character: params.character,
    );
  }
}

/// Parameters for the GenerateStoryUseCase
class GenerateStoryParams extends Equatable {
  final String prompt;
  final String? character;

  const GenerateStoryParams({
    required this.prompt,
    this.character,
  });

  @override
  List<Object?> get props => [prompt, character];
} 