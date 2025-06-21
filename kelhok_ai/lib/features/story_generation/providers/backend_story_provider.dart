import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/backend_story_service.dart';

// Provider for the backend story service
final backendStoryServiceProvider = Provider<BackendStoryService>((ref) {
  return BackendStoryService();
});

// State classes for story generation
class BackendCharactersState {
  final List<BackendCharacter> characters;
  final bool isLoading;
  final String? error;

  const BackendCharactersState({
    this.characters = const [],
    this.isLoading = false,
    this.error,
  });

  BackendCharactersState copyWith({
    List<BackendCharacter>? characters,
    bool? isLoading,
    String? error,
  }) {
    return BackendCharactersState(
      characters: characters ?? this.characters,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class BackendStoryState {
  final BackendStoryResponse? story;
  final bool isGenerating;
  final String? error;

  const BackendStoryState({
    this.story,
    this.isGenerating = false,
    this.error,
  });

  BackendStoryState copyWith({
    BackendStoryResponse? story,
    bool? isGenerating,
    String? error,
  }) {
    return BackendStoryState(
      story: story ?? this.story,
      isGenerating: isGenerating ?? this.isGenerating,
      error: error ?? this.error,
    );
  }
}

// Notifier for characters
class BackendCharactersNotifier extends StateNotifier<BackendCharactersState> {
  final BackendStoryService _storyService;
  final Ref _ref;

  BackendCharactersNotifier(this._storyService, this._ref) : super(const BackendCharactersState()) {
    loadCharacters();
  }

  Future<void> loadCharacters() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final characters = await _storyService.getCharacters();
      state = state.copyWith(characters: characters, isLoading: false);
      
      // Auto-select himu as default character
      _setDefaultCharacter(characters);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> refreshCharacters() async {
    await loadCharacters();
  }

  Future<void> searchCharacters(String query) async {
    if (query.isEmpty) {
      await loadCharacters();
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final characters = await _storyService.searchCharacters(query);
      state = state.copyWith(characters: characters, isLoading: false);
      
      // Auto-select himu as default character
      _setDefaultCharacter(characters);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void _setDefaultCharacter(List<BackendCharacter> characters) {
    // Only set default if no character is currently selected
    final currentSelection = _ref.read(selectedCharacterProvider);
    if (currentSelection == null) {
      // Find himu character and set as default
      final himuCandidates = characters.where(
        (character) => character.name.toLowerCase() == 'himu',
      ).toList();
      
      BackendCharacter? defaultCharacter;
      if (himuCandidates.isNotEmpty) {
        defaultCharacter = himuCandidates.first;
      } else if (characters.isNotEmpty) {
        defaultCharacter = characters.first;
      }
      
      if (defaultCharacter != null) {
        _ref.read(selectedCharacterProvider.notifier).state = defaultCharacter;
      }
    }
  }
}

// Notifier for story generation
class BackendStoryNotifier extends StateNotifier<BackendStoryState> {
  final BackendStoryService _storyService;

  BackendStoryNotifier(this._storyService) : super(const BackendStoryState());

  Future<void> generateStory({
    required String storyIdea,
    String? characterId,
  }) async {
    state = state.copyWith(isGenerating: true, error: null);
    
    try {
      // Load character if specified
      if (characterId != null) {
        await _storyService.loadCharacter(characterId);
      }

      // Generate story
      final storyResponse = await _storyService.generateStory(
        storyIdea: storyIdea,
        characterId: characterId,
      );

      state = state.copyWith(
        story: storyResponse,
        isGenerating: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isGenerating: false,
      );
    }
  }

  void clearStory() {
    state = state.copyWith(story: null, error: null);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider for characters state
final backendCharactersProvider = StateNotifierProvider<BackendCharactersNotifier, BackendCharactersState>((ref) {
  final storyService = ref.watch(backendStoryServiceProvider);
  return BackendCharactersNotifier(storyService, ref);
});

// Provider for story generation state
final backendStoryProvider = StateNotifierProvider<BackendStoryNotifier, BackendStoryState>((ref) {
  final storyService = ref.watch(backendStoryServiceProvider);
  return BackendStoryNotifier(storyService);
});

// Provider for selected character
final selectedCharacterProvider = StateProvider<BackendCharacter?>((ref) => null); 