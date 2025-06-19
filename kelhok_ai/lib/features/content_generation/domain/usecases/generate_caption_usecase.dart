import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/caption_entity.dart';
import '../repositories/content_generation_repository.dart';

/// Use case for generating a caption
class GenerateCaptionUseCase implements UseCase<CaptionEntity, GenerateCaptionParams> {
  final ContentGenerationRepository repository;

  GenerateCaptionUseCase(this.repository);

  @override
  Future<Either<Failure, CaptionEntity>> call(GenerateCaptionParams params) async {
    return await repository.generateCaption(
      prompt: params.prompt,
      character: params.character,
    );
  }
}

/// Parameters for the GenerateCaptionUseCase
class GenerateCaptionParams extends Equatable {
  final String prompt;
  final String? character;

  const GenerateCaptionParams({
    required this.prompt,
    this.character,
  });

  @override
  List<Object?> get props => [prompt, character];
} 