import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../models/character_models.dart';

class CharacterService {
  final Dio _dio;

  CharacterService(this._dio);

  // Get all characters for the user
  Future<List<Character>> getCharacters() async {
    try {
      final response = await _dio.get(ApiConstants.characters);
      final List<dynamic> charactersJson = response.data['characters'];
      return charactersJson.map((json) => Character.fromJson(json)).toList();
    } catch (e) {
      // Return mock data for development
      return _getMockCharacters();
    }
  }

  // Get character by ID
  Future<Character?> getCharacter(String id) async {
    try {
      final response = await _dio.get('${ApiConstants.characters}/$id');
      return Character.fromJson(response.data);
    } catch (e) {
      // Return mock data for development
      final mockCharacters = _getMockCharacters();
      return mockCharacters.firstWhere(
        (character) => character.id == id,
        orElse: () => mockCharacters.first,
      );
    }
  }

  // Create new character
  Future<Character> createCharacter(Character character) async {
    try {
      final response = await _dio.post(
        ApiConstants.characters,
        data: character.toJson(),
      );
      return Character.fromJson(response.data);
    } catch (e) {
      // Return the character with a generated ID for development
      return character.copyWith(
        id: 'char_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  // Update existing character
  Future<Character> updateCharacter(Character character) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.characters}/${character.id}',
        data: character.toJson(),
      );
      return Character.fromJson(response.data);
    } catch (e) {
      // Return the updated character for development
      return character.copyWith(updatedAt: DateTime.now());
    }
  }

  // Delete character
  Future<bool> deleteCharacter(String id) async {
    try {
      await _dio.delete('${ApiConstants.characters}/$id');
      return true;
    } catch (e) {
      // Return success for development
      return true;
    }
  }

  // Toggle favorite status
  Future<Character> toggleFavorite(String id, bool isFavorite) async {
    try {
      final response = await _dio.patch(
        '${ApiConstants.characters}/$id/favorite',
        data: {'is_favorite': isFavorite},
      );
      return Character.fromJson(response.data);
    } catch (e) {
      // Return mock updated character for development
      final character = await getCharacter(id);
      return character!.copyWith(
        isFavorite: isFavorite,
        updatedAt: DateTime.now(),
      );
    }
  }

  // Search characters
  Future<List<Character>> searchCharacters(String query) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.characters}/search',
        queryParameters: {'q': query},
      );
      final List<dynamic> charactersJson = response.data['characters'];
      return charactersJson.map((json) => Character.fromJson(json)).toList();
    } catch (e) {
      // Filter mock data for development
      final mockCharacters = _getMockCharacters();
      return mockCharacters.where((character) {
        return character.name.toLowerCase().contains(query.toLowerCase()) ||
            character.description.toLowerCase().contains(query.toLowerCase()) ||
            character.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    }
  }

  // Get characters by tags
  Future<List<Character>> getCharactersByTags(List<String> tags) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.characters}/by-tags',
        queryParameters: {'tags': tags.join(',')},
      );
      final List<dynamic> charactersJson = response.data['characters'];
      return charactersJson.map((json) => Character.fromJson(json)).toList();
    } catch (e) {
      // Filter mock data for development
      final mockCharacters = _getMockCharacters();
      return mockCharacters.where((character) {
        return character.tags.any((tag) => tags.contains(tag));
      }).toList();
    }
  }

  // Get favorite characters
  Future<List<Character>> getFavoriteCharacters() async {
    try {
      final response = await _dio.get('${ApiConstants.characters}/favorites');
      final List<dynamic> charactersJson = response.data['characters'];
      return charactersJson.map((json) => Character.fromJson(json)).toList();
    } catch (e) {
      // Filter mock data for development
      final mockCharacters = _getMockCharacters();
      return mockCharacters.where((character) => character.isFavorite).toList();
    }
  }

  // Generate character suggestions based on story context
  Future<List<Character>> generateCharacterSuggestions({
    required String storyContext,
    String? genre,
    int limit = 5,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.characters}/suggestions',
        data: {
          'story_context': storyContext,
          'genre': genre,
          'limit': limit,
        },
      );
      final List<dynamic> charactersJson = response.data['suggestions'];
      return charactersJson.map((json) => Character.fromJson(json)).toList();
    } catch (e) {
      // Return template characters as suggestions for development
      return CharacterTemplates.defaultTemplates.take(limit).toList();
    }
  }

  // Get character templates
  Future<List<Character>> getCharacterTemplates() async {
    try {
      final response = await _dio.get('${ApiConstants.characters}/templates');
      final List<dynamic> templatesJson = response.data['templates'];
      return templatesJson.map((json) => Character.fromJson(json)).toList();
    } catch (e) {
      // Return default templates for development
      return CharacterTemplates.defaultTemplates;
    }
  }

  // Mock data for development
  List<Character> _getMockCharacters() {
    return [
      Character(
        id: 'char_1',
        name: 'Elena Brightblade',
        description: 'A skilled elven warrior with a mysterious past',
        appearance: const CharacterAppearance(
          gender: 'Female',
          age: 150,
          height: '5\'8"',
          build: 'Athletic',
          hairColor: 'Silver',
          hairStyle: 'Long braided',
          eyeColor: 'Emerald green',
          skinTone: 'Fair',
          distinctiveFeatures: ['Pointed ears', 'Ancient scar on left cheek'],
          clothing: 'Leather armor with silver trim',
        ),
        personality: const CharacterPersonality(
          archetype: PersonalityArchetype.hero,
          traits: ['Brave', 'Honorable', 'Determined'],
          strengths: ['Master swordswoman', 'Tactical mind', 'Loyal'],
          weaknesses: ['Stubborn', 'Haunted by past', 'Distrusts magic'],
          fears: ['Losing loved ones', 'Repeating past mistakes'],
          motivations: ['Protect the innocent', 'Redeem past failures'],
          speechPattern: 'Formal but warm',
          mannerisms: 'Touches sword hilt when nervous',
        ),
        background: const CharacterBackground(
          occupation: 'Knight-errant',
          origin: 'Silverwood Forest',
          education: 'Royal military academy',
          family: 'Lost family in orc raids',
          relationships: ['Marcus (mentor)', 'Thalia (best friend)'],
          pastExperiences: ['Failed to save village', 'Trained by legendary knight'],
          currentGoal: 'Find and stop the Shadow Cult',
          backstory: 'Once a promising knight who failed to protect her village',
        ),
        tags: ['elf', 'warrior', 'knight', 'protagonist'],
        avatarUrl: null,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        isFavorite: true,
      ),
      Character(
        id: 'char_2',
        name: 'Professor Aldric Thornweave',
        description: 'An eccentric wizard with vast knowledge of ancient magic',
        appearance: const CharacterAppearance(
          gender: 'Male',
          age: 68,
          height: '5\'10"',
          build: 'Thin',
          hairColor: 'Gray with white streaks',
          hairStyle: 'Long beard, wild hair',
          eyeColor: 'Bright blue',
          skinTone: 'Pale',
          distinctiveFeatures: ['Bushy eyebrows', 'Ink-stained fingers'],
          clothing: 'Robes covered in mystical symbols',
        ),
        personality: const CharacterPersonality(
          archetype: PersonalityArchetype.mentor,
          traits: ['Wise', 'Eccentric', 'Curious'],
          strengths: ['Vast knowledge', 'Powerful magic', 'Teaching ability'],
          weaknesses: ['Absent-minded', 'Socially awkward', 'Overconfident'],
          fears: ['Knowledge being lost', 'Students failing'],
          motivations: ['Preserve ancient knowledge', 'Train next generation'],
          speechPattern: 'Uses big words, quotes ancient texts',
          mannerisms: 'Strokes beard when thinking',
        ),
        background: const CharacterBackground(
          occupation: 'Wizard and scholar',
          origin: 'Tower of Mysteries',
          education: 'Arcane University, self-taught',
          family: 'Never married, devoted to studies',
          relationships: ['Elena (student)', 'Council of Mages (colleagues)'],
          pastExperiences: ['Discovered lost spells', 'Fought in Mage Wars'],
          currentGoal: 'Decode the Prophecy of Shadows',
          backstory: 'Youngest wizard to join the High Council',
        ),
        tags: ['human', 'wizard', 'mentor', 'scholar'],
        avatarUrl: null,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        isFavorite: false,
      ),
      Character(
        id: 'char_3',
        name: 'Zara Nightwhisper',
        description: 'A cunning rogue with connections in the criminal underworld',
        appearance: const CharacterAppearance(
          gender: 'Female',
          age: 28,
          height: '5\'6"',
          build: 'Lithe',
          hairColor: 'Black',
          hairStyle: 'Short and practical',
          eyeColor: 'Dark brown',
          skinTone: 'Olive',
          distinctiveFeatures: ['Small scar above right eyebrow', 'Calloused hands'],
          clothing: 'Dark leather outfit with hidden pockets',
        ),
        personality: const CharacterPersonality(
          archetype: PersonalityArchetype.trickster,
          traits: ['Cunning', 'Independent', 'Sarcastic'],
          strengths: ['Stealth', 'Lock picking', 'Street smart'],
          weaknesses: ['Trust issues', 'Greedy', 'Reckless'],
          fears: ['Being trapped', 'Poverty', 'Betrayal'],
          motivations: ['Freedom', 'Wealth', 'Revenge on former gang'],
          speechPattern: 'Quick wit, uses street slang',
          mannerisms: 'Fidgets with lockpicks',
        ),
        background: const CharacterBackground(
          occupation: 'Thief and information broker',
          origin: 'Slums of Goldport',
          education: 'School of hard knocks',
          family: 'Orphaned at young age',
          relationships: ['Thieves Guild (former)', 'Various contacts'],
          pastExperiences: ['Survived on streets', 'Betrayed by gang leader'],
          currentGoal: 'Build her own criminal empire',
          backstory: 'Rose from street orphan to master thief',
        ),
        tags: ['human', 'rogue', 'thief', 'anti-hero'],
        avatarUrl: null,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        isFavorite: true,
      ),
      Character(
        id: 'char_4',
        name: 'Lord Malachar the Cruel',
        description: 'A fallen paladin turned dark lord seeking ultimate power',
        appearance: const CharacterAppearance(
          gender: 'Male',
          age: 45,
          height: '6\'2"',
          build: 'Muscular',
          hairColor: 'Black with silver streaks',
          hairStyle: 'Slicked back',
          eyeColor: 'Red (corrupted)',
          skinTone: 'Pale',
          distinctiveFeatures: ['Burn scars on left side of face', 'Always wears black armor'],
          clothing: 'Ornate black plate armor',
        ),
        personality: const CharacterPersonality(
          archetype: PersonalityArchetype.shadow,
          traits: ['Ruthless', 'Charismatic', 'Ambitious'],
          strengths: ['Master tactician', 'Dark magic', 'Leadership'],
          weaknesses: ['Pride', 'Obsession with power', 'Former honor haunts him'],
          fears: ['Being forgotten', 'Losing control', 'His past self'],
          motivations: ['Ultimate power', 'Prove his worth', 'Destroy those who wronged him'],
          speechPattern: 'Commanding, uses royal we',
          mannerisms: 'Clenches fist when angry',
        ),
        background: const CharacterBackground(
          occupation: 'Dark Lord and conqueror',
          origin: 'Kingdom of Valeria (former paladin)',
          education: 'Paladin training, self-taught dark arts',
          family: 'Disowned by noble family',
          relationships: ['Former order (enemies)', 'Dark cultists (followers)'],
          pastExperiences: ['Fall from grace', 'Pact with dark entity'],
          currentGoal: 'Conquer the known world',
          backstory: 'Once the realm\'s greatest paladin, corrupted by betrayal',
        ),
        tags: ['human', 'villain', 'dark-lord', 'fallen-paladin'],
        avatarUrl: null,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
        isFavorite: false,
      ),
      Character(
        id: 'char_5',
        name: 'Pip Brightbottom',
        description: 'An optimistic halfling bard who sees adventure everywhere',
        appearance: const CharacterAppearance(
          gender: 'Male',
          age: 25,
          height: '3\'4"',
          build: 'Small and round',
          hairColor: 'Curly brown',
          hairStyle: 'Messy curls',
          eyeColor: 'Hazel',
          skinTone: 'Tan',
          distinctiveFeatures: ['Dimpled cheeks', 'Always smiling'],
          clothing: 'Colorful traveling clothes with many pockets',
        ),
        personality: const CharacterPersonality(
          archetype: PersonalityArchetype.jester,
          traits: ['Optimistic', 'Friendly', 'Curious'],
          strengths: ['Musical talent', 'Storytelling', 'Morale booster'],
          weaknesses: ['Naive', 'Overly trusting', 'Gets into trouble'],
          fears: ['Being alone', 'Sad endings', 'Disappointing friends'],
          motivations: ['Make friends', 'Collect stories', 'Spread joy'],
          speechPattern: 'Enthusiastic, uses lots of exclamations',
          mannerisms: 'Hums while walking',
        ),
        background: const CharacterBackground(
          occupation: 'Traveling bard and storyteller',
          origin: 'Greenhill Village',
          education: 'Bard college dropout',
          family: 'Large loving family',
          relationships: ['Village friends', 'Fellow travelers'],
          pastExperiences: ['First adventure', 'Learned to play lute'],
          currentGoal: 'Become the greatest storyteller',
          backstory: 'Left comfortable home to seek adventure and stories',
        ),
        tags: ['halfling', 'bard', 'sidekick', 'comic-relief'],
        avatarUrl: null,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
        isFavorite: true,
      ),
    ];
  }
} 