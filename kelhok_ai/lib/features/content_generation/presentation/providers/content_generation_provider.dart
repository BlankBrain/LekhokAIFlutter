import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/usecases/generate_story_usecase.dart';
import '../../domain/usecases/generate_caption_usecase.dart';
import 'content_generation_state.dart';

/// Riverpod StateNotifier for managing content generation state
class ContentGenerationProvider extends StateNotifier<ContentGenerationCombinedState> {
  final GenerateStoryUseCase generateStoryUseCase;
  final GenerateCaptionUseCase generateCaptionUseCase;
  final Logger logger = Logger('ContentGenerationProvider');

  ContentGenerationProvider({
    required this.generateStoryUseCase,
    required this.generateCaptionUseCase,
  }) : super(const ContentGenerationCombinedState(
          storyState: ContentGenerationInitial(),
          captionState: ContentGenerationInitial(),
          isLoading: false,
        ));

  /// Generates a story based on the provided prompt
  Future<void> generateStory(String prompt) async {
    if (prompt.trim().isEmpty) {
      logger.warning('Story generation attempted with empty prompt');
      state = state.copyWith(
        storyState: const ContentGenerationError(
          message: TextConstants.emptyInputError,
        ),
        isLoading: false,
      );
      return;
    }

    logger.info('Starting story generation with prompt: $prompt');

    // Set loading state
    state = state.copyWith(
      storyState: const ContentGenerationLoading(),
      isLoading: true,
      errorMessage: null,
    );

    try {
      final result = await generateStoryUseCase(
        GenerateStoryParams(
          prompt: prompt,
          character: ApiConstants.defaultCharacter,
        ),
      );

      result.fold(
        (failure) {
          logger.warning('Story generation failed: ${failure.message}');
          state = state.copyWith(
            storyState: ContentGenerationError(message: failure.message),
            isLoading: false,
            errorMessage: failure.message,
          );
        },
        (story) {
          logger.info('Story generation successful');
          state = state.copyWith(
            storyState: StoryGenerationSuccess(story: story),
            isLoading: false,
            errorMessage: null,
          );
        },
      );
    } catch (e) {
      logger.severe('Unexpected error during story generation: $e');
      state = state.copyWith(
        storyState: const ContentGenerationError(
          message: TextConstants.generalError,
        ),
        isLoading: false,
        errorMessage: TextConstants.generalError,
      );
    }
  }

  /// Generates a caption based on the provided prompt
  Future<void> generateCaption(String prompt) async {
    if (prompt.trim().isEmpty) {
      logger.warning('Caption generation attempted with empty prompt');
      state = state.copyWith(
        captionState: const ContentGenerationError(
          message: TextConstants.emptyInputError,
        ),
        isLoading: false,
      );
      return;
    }

    logger.info('Starting caption generation with prompt: $prompt');

    // Set loading state
    state = state.copyWith(
      captionState: const ContentGenerationLoading(),
      isLoading: true,
      errorMessage: null,
    );

    try {
      final result = await generateCaptionUseCase(
        GenerateCaptionParams(
          prompt: prompt,
          character: ApiConstants.defaultCharacter,
        ),
      );

      result.fold(
        (failure) {
          logger.warning('Caption generation failed: ${failure.message}');
          state = state.copyWith(
            captionState: ContentGenerationError(message: failure.message),
            isLoading: false,
            errorMessage: failure.message,
          );
        },
        (caption) {
          logger.info('Caption generation successful');
          state = state.copyWith(
            captionState: CaptionGenerationSuccess(caption: caption),
            isLoading: false,
            errorMessage: null,
          );
        },
      );
    } catch (e) {
      logger.severe('Unexpected error during caption generation: $e');
      state = state.copyWith(
        captionState: const ContentGenerationError(
          message: TextConstants.generalError,
        ),
        isLoading: false,
        errorMessage: TextConstants.generalError,
      );
    }
  }

  /// Clears the current state and resets to initial
  void clearState() {
    logger.info('Clearing content generation state');
    state = const ContentGenerationCombinedState(
      storyState: ContentGenerationInitial(),
      captionState: ContentGenerationInitial(),
      isLoading: false,
    );
  }

  /// Clears only the story state
  void clearStoryState() {
    logger.info('Clearing story state');
    state = state.copyWith(
      storyState: const ContentGenerationInitial(),
      errorMessage: null,
    );
  }

  /// Clears only the caption state
  void clearCaptionState() {
    logger.info('Clearing caption state');
    state = state.copyWith(
      captionState: const ContentGenerationInitial(),
      errorMessage: null,
    );
  }
} 