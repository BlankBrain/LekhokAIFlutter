import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../injection_container.dart' as di;
import 'content_generation_provider.dart';
import 'content_generation_state.dart';

/// Provider for ContentGenerationProvider
final contentGenerationProvider = StateNotifierProvider<ContentGenerationProvider, ContentGenerationCombinedState>(
  (ref) => di.sl<ContentGenerationProvider>(),
);

/// Provider to access the story state specifically
final storyStateProvider = Provider<ContentGenerationState>(
  (ref) => ref.watch(contentGenerationProvider).storyState,
);

/// Provider to access the caption state specifically
final captionStateProvider = Provider<ContentGenerationState>(
  (ref) => ref.watch(contentGenerationProvider).captionState,
);

/// Provider to check if any generation is in progress
final isLoadingProvider = Provider<bool>(
  (ref) => ref.watch(contentGenerationProvider).isLoading,
);

/// Provider to get the current error message (if any)
final errorMessageProvider = Provider<String?>(
  (ref) => ref.watch(contentGenerationProvider).errorMessage,
); 