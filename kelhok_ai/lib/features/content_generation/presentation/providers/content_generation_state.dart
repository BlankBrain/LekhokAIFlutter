import 'package:equatable/equatable.dart';
import '../../domain/entities/story_entity.dart';
import '../../domain/entities/caption_entity.dart';

/// Base state for content generation
abstract class ContentGenerationState extends Equatable {
  const ContentGenerationState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ContentGenerationInitial extends ContentGenerationState {
  const ContentGenerationInitial();
}

/// Loading state
class ContentGenerationLoading extends ContentGenerationState {
  const ContentGenerationLoading();
}

/// Success state for story generation
class StoryGenerationSuccess extends ContentGenerationState {
  final StoryEntity story;

  const StoryGenerationSuccess({required this.story});

  @override
  List<Object?> get props => [story];
}

/// Success state for caption generation
class CaptionGenerationSuccess extends ContentGenerationState {
  final CaptionEntity caption;

  const CaptionGenerationSuccess({required this.caption});

  @override
  List<Object?> get props => [caption];
}

/// Error state
class ContentGenerationError extends ContentGenerationState {
  final String message;

  const ContentGenerationError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Combined state that holds both story and caption
class ContentGenerationCombinedState extends Equatable {
  final ContentGenerationState storyState;
  final ContentGenerationState captionState;
  final bool isLoading;
  final String? errorMessage;

  const ContentGenerationCombinedState({
    required this.storyState,
    required this.captionState,
    required this.isLoading,
    this.errorMessage,
  });

  ContentGenerationCombinedState copyWith({
    ContentGenerationState? storyState,
    ContentGenerationState? captionState,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ContentGenerationCombinedState(
      storyState: storyState ?? this.storyState,
      captionState: captionState ?? this.captionState,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [storyState, captionState, isLoading, errorMessage];
} 