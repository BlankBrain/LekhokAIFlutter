import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/character_models.dart';
import '../services/character_service.dart';

// Dio provider
final dioProvider = Provider<Dio>((ref) => Dio());

// Character service provider
final characterServiceProvider = Provider<CharacterService>((ref) {
  final dio = ref.read(dioProvider);
  return CharacterService(dio);
});

// Characters list provider
final charactersProvider = FutureProvider<List<Character>>((ref) async {
  final service = ref.read(characterServiceProvider);
  return service.getCharacters();
});

// Character templates provider
final characterTemplatesProvider = FutureProvider<List<Character>>((ref) async {
  final service = ref.read(characterServiceProvider);
  return service.getCharacterTemplates();
});

// Favorite characters provider
final favoriteCharactersProvider = FutureProvider<List<Character>>((ref) async {
  final service = ref.read(characterServiceProvider);
  return service.getFavoriteCharacters();
});

// Character search provider
final characterSearchProvider = FutureProvider.family<List<Character>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final service = ref.read(characterServiceProvider);
  return service.searchCharacters(query);
});

// Characters by tags provider
final charactersByTagsProvider = FutureProvider.family<List<Character>, List<String>>((ref, tags) async {
  if (tags.isEmpty) return [];
  final service = ref.read(characterServiceProvider);
  return service.getCharactersByTags(tags);
});

// Character creation state
class CharacterCreationState {
  final Character character;
  final int currentStep;
  final bool isLoading;
  final String? error;

  const CharacterCreationState({
    required this.character,
    this.currentStep = 0,
    this.isLoading = false,
    this.error,
  });

  CharacterCreationState copyWith({
    Character? character,
    int? currentStep,
    bool? isLoading,
    String? error,
  }) {
    return CharacterCreationState(
      character: character ?? this.character,
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Character creation provider
final characterCreationProvider = StateNotifierProvider<CharacterCreationNotifier, CharacterCreationState>((ref) {
  return CharacterCreationNotifier(ref.read(characterServiceProvider));
});

class CharacterCreationNotifier extends StateNotifier<CharacterCreationState> {
  final CharacterService _service;

  CharacterCreationNotifier(this._service) : super(CharacterCreationState(
    character: _createEmptyCharacter(),
  ));

  static Character _createEmptyCharacter() {
    final now = DateTime.now();
    return Character(
      id: '',
      name: '',
      description: '',
      appearance: const CharacterAppearance(),
      personality: const CharacterPersonality(),
      background: const CharacterBackground(),
      createdAt: now,
      updatedAt: now,
    );
  }

  void updateCharacter(Character character) {
    state = state.copyWith(character: character);
  }

  void updateBasicInfo({String? name, String? description}) {
    final updatedCharacter = state.character.copyWith(
      name: name ?? state.character.name,
      description: description ?? state.character.description,
    );
    state = state.copyWith(character: updatedCharacter);
  }

  void updateAppearance(CharacterAppearance appearance) {
    final updatedCharacter = state.character.copyWith(appearance: appearance);
    state = state.copyWith(character: updatedCharacter);
  }

  void updatePersonality(CharacterPersonality personality) {
    final updatedCharacter = state.character.copyWith(personality: personality);
    state = state.copyWith(character: updatedCharacter);
  }

  void updateBackground(CharacterBackground background) {
    final updatedCharacter = state.character.copyWith(background: background);
    state = state.copyWith(character: updatedCharacter);
  }

  void nextStep() {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void setStep(int step) {
    if (step >= 0 && step <= 3) {
      state = state.copyWith(currentStep: step);
    }
  }

  Future<void> saveCharacter() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final savedCharacter = await _service.createCharacter(state.character);
      state = state.copyWith(
        character: savedCharacter,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void reset() {
    state = CharacterCreationState(character: _createEmptyCharacter());
  }

  void loadTemplate(Character template) {
    final newCharacter = template.copyWith(
      id: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    state = state.copyWith(character: newCharacter);
  }
}

// Character management state for list operations
class CharacterManagementState {
  final List<Character> characters;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final List<String> selectedTags;

  const CharacterManagementState({
    this.characters = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.selectedTags = const [],
  });

  CharacterManagementState copyWith({
    List<Character>? characters,
    bool? isLoading,
    String? error,
    String? searchQuery,
    List<String>? selectedTags,
  }) {
    return CharacterManagementState(
      characters: characters ?? this.characters,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTags: selectedTags ?? this.selectedTags,
    );
  }
}

// Character management provider
final characterManagementProvider = StateNotifierProvider<CharacterManagementNotifier, CharacterManagementState>((ref) {
  return CharacterManagementNotifier(ref.read(characterServiceProvider));
});

class CharacterManagementNotifier extends StateNotifier<CharacterManagementState> {
  final CharacterService _service;

  CharacterManagementNotifier(this._service) : super(const CharacterManagementState()) {
    loadCharacters();
  }

  Future<void> loadCharacters() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final characters = await _service.getCharacters();
      state = state.copyWith(
        characters: characters,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteCharacter(String id) async {
    try {
      await _service.deleteCharacter(id);
      final updatedCharacters = state.characters.where((c) => c.id != id).toList();
      state = state.copyWith(characters: updatedCharacters);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> toggleFavorite(String id) async {
    try {
      final character = state.characters.firstWhere((c) => c.id == id);
      final updatedCharacter = await _service.toggleFavorite(id, !character.isFavorite);
      
      final updatedCharacters = state.characters.map((c) {
        return c.id == id ? updatedCharacter : c;
      }).toList();
      
      state = state.copyWith(characters: updatedCharacters);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSelectedTags(List<String> tags) {
    state = state.copyWith(selectedTags: tags);
  }

  List<Character> get filteredCharacters {
    var filtered = state.characters;
    
    // Apply search filter
    if (state.searchQuery.isNotEmpty) {
      filtered = filtered.where((character) {
        return character.name.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
            character.description.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
            character.tags.any((tag) => tag.toLowerCase().contains(state.searchQuery.toLowerCase()));
      }).toList();
    }
    
    // Apply tag filter
    if (state.selectedTags.isNotEmpty) {
      filtered = filtered.where((character) {
        return character.tags.any((tag) => state.selectedTags.contains(tag));
      }).toList();
    }
    
    return filtered;
  }
}

// All characters provider (alias for compatibility)
final allCharactersProvider = charactersProvider; 