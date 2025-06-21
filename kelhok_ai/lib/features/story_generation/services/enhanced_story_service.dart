import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../character_management/models/character_models.dart';
import '../models/story_generation_models.dart';

class EnhancedStoryService {
  final Dio _dio;

  EnhancedStoryService({Dio? dio}) : _dio = dio ?? Dio();

  /// Generate a story with character integration
  Future<StoryGenerationResponse> generateStoryWithCharacters({
    required String prompt,
    List<Character>? characters,
    String? genre,
    String? tone,
    String? style,
    int? wordCount,
  }) async {
    try {
      final enhancedPrompt = _buildEnhancedPrompt(
        prompt: prompt,
        characters: characters,
        genre: genre,
        tone: tone,
        style: style,
        wordCount: wordCount,
      );

      final response = await _dio.post(
        ApiConstants.generateStory,
        data: {
          'prompt': enhancedPrompt,
          'characters': characters?.map((c) => c.toJson()).toList(),
          'genre': genre,
          'tone': tone,
          'style': style,
          'word_count': wordCount,
          'include_character_development': characters?.isNotEmpty ?? false,
          'maintain_character_consistency': true,
        },
      );

      return StoryGenerationResponse.fromJson(response.data);
    } catch (e) {
      // Fallback to mock generation with character integration
      return _generateMockStoryWithCharacters(
        prompt: prompt,
        characters: characters,
        genre: genre,
        tone: tone,
        wordCount: wordCount,
      );
    }
  }

  /// Build an enhanced prompt that includes character information
  String _buildEnhancedPrompt({
    required String prompt,
    List<Character>? characters,
    String? genre,
    String? tone,
    String? style,
    int? wordCount,
  }) {
    final buffer = StringBuffer();
    
    // Add genre and tone context
    if (genre != null || tone != null) {
      buffer.writeln('Story Context:');
      if (genre != null) buffer.writeln('- Genre: $genre');
      if (tone != null) buffer.writeln('- Tone: $tone');
      if (style != null) buffer.writeln('- Style: $style');
      if (wordCount != null) buffer.writeln('- Target length: approximately $wordCount words');
      buffer.writeln();
    }

    // Add character information
    if (characters != null && characters.isNotEmpty) {
      buffer.writeln('Characters to include in the story:');
      for (int i = 0; i < characters.length; i++) {
        final character = characters[i];
        buffer.writeln('${i + 1}. ${character.name}:');
        buffer.writeln('   - Description: ${character.description}');
        
        if (character.personality.archetype != null) {
          buffer.writeln('   - Archetype: ${character.personality.archetype!.displayName}');
        }
        
        if (character.appearance.age != null) {
          buffer.writeln('   - Age: ${character.appearance.age}');
        }
        
        if (character.background.occupation.isNotEmpty) {
          buffer.writeln('   - Occupation: ${character.background.occupation}');
        }
        
        if (character.personality.traits.isNotEmpty) {
          buffer.writeln('   - Key traits: ${character.personality.traits.take(3).join(', ')}');
        }
        
        if (character.personality.motivations.isNotEmpty) {
          buffer.writeln('   - Motivations: ${character.personality.motivations.take(2).join(', ')}');
        }
        
        buffer.writeln();
      }
      
      buffer.writeln('Please ensure each character maintains their unique personality, traits, and motivations throughout the story.');
      buffer.writeln();
    }

    // Add the main prompt
    buffer.writeln('Story Prompt:');
    buffer.writeln(prompt);
    
    return buffer.toString();
  }

  /// Generate a mock story with character integration for testing
  StoryGenerationResponse _generateMockStoryWithCharacters({
    required String prompt,
    List<Character>? characters,
    String? genre,
    String? tone,
    int? wordCount,
  }) {
    final buffer = StringBuffer();
    
    // Generate story opening
    if (characters != null && characters.isNotEmpty) {
      final mainCharacter = characters.first;
      buffer.write('${mainCharacter.name} ');
      
      // Add character-specific opening based on archetype
      switch (mainCharacter.personality.archetype) {
        case PersonalityArchetype.hero:
          buffer.write('stood at the crossroads of destiny, knowing that the choice ahead would define not just their fate, but the fate of all they held dear. ');
          break;
        case PersonalityArchetype.mentor:
          buffer.write('gazed thoughtfully at the young apprentice before them, wisdom gleaming in their eyes as they prepared to share a lesson that would change everything. ');
          break;
        case PersonalityArchetype.villain:
          buffer.write('smiled coldly as their carefully laid plans began to unfold, each piece falling into place with devastating precision. ');
          break;
        case PersonalityArchetype.explorer:
          buffer.write('felt the familiar thrill of adventure coursing through their veins as they set foot on uncharted territory. ');
          break;
        default:
          buffer.write('found themselves in an extraordinary situation that would test everything they believed about themselves and the world around them. ');
      }
    } else {
      buffer.write('In a world where anything was possible, ');
    }

    // Incorporate the original prompt
    buffer.write(prompt);
    
    // Add character interactions if multiple characters
    if (characters != null && characters.length > 1) {
      buffer.write('\n\n');
      for (int i = 1; i < characters.length; i++) {
        final character = characters[i];
        buffer.write('${character.name}, ');
        
        if (character.background.occupation.isNotEmpty) {
          buffer.write('a ${character.background.occupation}, ');
        }
        
        if (character.personality.traits.isNotEmpty) {
          final trait = character.personality.traits.first;
          buffer.write('known for being $trait, ');
        }
        
        buffer.write('joined the unfolding adventure, bringing their own unique perspective and skills to the challenge ahead. ');
      }
    }

    // Add story development
    buffer.write('\n\nAs the story unfolded, each character faced their own internal struggles while working together toward a common goal. ');
    
    if (characters != null && characters.isNotEmpty) {
      for (final character in characters) {
        if (character.personality.fears.isNotEmpty) {
          buffer.write('${character.name} had to confront their fear of ${character.personality.fears.first}, ');
        }
        if (character.personality.motivations.isNotEmpty) {
          buffer.write('driven by their desire to ${character.personality.motivations.first}. ');
        }
      }
    }

    // Add resolution
    buffer.write('\n\nIn the end, through courage, determination, and the bonds forged between unlikely allies, they discovered that the greatest adventures are not just about reaching a destination, but about the growth and transformation that happens along the way. ');
    
    if (characters != null && characters.isNotEmpty) {
      buffer.write('Each character emerged changed, having learned valuable lessons about themselves and the power of working together despite their differences.');
    }

    final story = buffer.toString();
    
    return StoryGenerationResponse(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      story: story,
      prompt: prompt,
      characters: characters?.map((c) => c.name).toList() ?? [],
      genre: genre,
      tone: tone,
      wordCount: story.split(' ').length,
      createdAt: DateTime.now(),
      metadata: {
        'enhanced_with_characters': characters?.isNotEmpty ?? false,
        'character_count': characters?.length ?? 0,
        'generation_type': 'character_integrated',
      },
    );
  }

  /// Get character suggestions based on story prompt
  Future<List<Character>> suggestCharactersForStory(String prompt) async {
    try {
      final response = await _dio.post(
        ApiConstants.suggestCharacters,
        data: {'prompt': prompt},
      );
      
      return (response.data['characters'] as List)
          .map((json) => Character.fromJson(json))
          .toList();
    } catch (e) {
      // Return mock character suggestions
      return _getMockCharacterSuggestions(prompt);
    }
  }

  /// Generate mock character suggestions based on prompt analysis
  List<Character> _getMockCharacterSuggestions(String prompt) {
    final suggestions = <Character>[];
    final lowercasePrompt = prompt.toLowerCase();
    
    // Analyze prompt for character archetypes
    if (lowercasePrompt.contains('adventure') || lowercasePrompt.contains('quest') || lowercasePrompt.contains('journey')) {
      suggestions.add(_createSuggestedCharacter(
        name: 'Alex the Explorer',
        archetype: PersonalityArchetype.explorer,
        description: 'A brave adventurer with an insatiable curiosity for the unknown',
      ));
    }
    
    if (lowercasePrompt.contains('magic') || lowercasePrompt.contains('wizard') || lowercasePrompt.contains('spell')) {
      suggestions.add(_createSuggestedCharacter(
        name: 'Sage Meridian',
        archetype: PersonalityArchetype.magician,
        description: 'A wise practitioner of ancient magical arts',
      ));
    }
    
    if (lowercasePrompt.contains('love') || lowercasePrompt.contains('romance') || lowercasePrompt.contains('heart')) {
      suggestions.add(_createSuggestedCharacter(
        name: 'Elena Brighthart',
        archetype: PersonalityArchetype.lover,
        description: 'A passionate soul who believes in the power of love to overcome any obstacle',
      ));
    }
    
    if (lowercasePrompt.contains('evil') || lowercasePrompt.contains('dark') || lowercasePrompt.contains('villain')) {
      suggestions.add(_createSuggestedCharacter(
        name: 'Lord Shadowmere',
        archetype: PersonalityArchetype.shadow,
        description: 'A mysterious antagonist with hidden depths and complex motivations',
      ));
    }
    
    // Always include a hero option
    if (suggestions.isEmpty || !suggestions.any((c) => c.personality.archetype == PersonalityArchetype.hero)) {
      suggestions.add(_createSuggestedCharacter(
        name: 'Jordan Lightbringer',
        archetype: PersonalityArchetype.hero,
        description: 'A reluctant hero who rises to meet the challenges fate has placed before them',
      ));
    }
    
    return suggestions.take(3).toList();
  }

  Character _createSuggestedCharacter({
    required String name,
    required PersonalityArchetype archetype,
    required String description,
  }) {
    return Character(
      id: DateTime.now().millisecondsSinceEpoch.toString() + name.hashCode.toString(),
      name: name,
      description: description,
      tags: [archetype.displayName.toLowerCase()],
      appearance: CharacterAppearance(
        gender: 'Unknown',
        age: 25,
        height: 'Average',
        build: 'Average',
        hairColor: 'Dark',
        hairStyle: 'Medium',
        eyeColor: 'Brown',
        skinTone: 'Medium',
        distinctiveFeatures: [],
        clothing: 'Appropriate for their role',
      ),
      personality: CharacterPersonality(
        archetype: archetype,
        traits: _getArchetypeTraits(archetype),
        strengths: _getArchetypeStrengths(archetype),
        weaknesses: _getArchetypeWeaknesses(archetype),
        fears: _getArchetypeFears(archetype),
        motivations: _getArchetypeMotivations(archetype),
        speechPatterns: 'Clear and purposeful',
        mannerisms: 'Confident body language',
      ),
      background: CharacterBackground(
        occupation: _getArchetypeOccupation(archetype),
        origin: 'Unknown lands',
        education: 'Self-taught through experience',
        family: 'Details to be revealed',
        relationships: [],
        pastExperiences: ['Formative challenges that shaped their character'],
        currentGoals: ['Fulfill their role in the story'],
        backstory: 'A character with a rich history waiting to be explored',
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  List<String> _getArchetypeTraits(PersonalityArchetype archetype) {
    switch (archetype) {
      case PersonalityArchetype.hero:
        return ['Brave', 'Determined', 'Compassionate'];
      case PersonalityArchetype.mentor:
        return ['Wise', 'Patient', 'Knowledgeable'];
      case PersonalityArchetype.explorer:
        return ['Curious', 'Adventurous', 'Independent'];
      case PersonalityArchetype.magician:
        return ['Mysterious', 'Powerful', 'Knowledgeable'];
      case PersonalityArchetype.lover:
        return ['Passionate', 'Caring', 'Emotional'];
      case PersonalityArchetype.shadow:
        return ['Complex', 'Mysterious', 'Driven'];
      default:
        return ['Unique', 'Interesting', 'Complex'];
    }
  }

  List<String> _getArchetypeStrengths(PersonalityArchetype archetype) {
    switch (archetype) {
      case PersonalityArchetype.hero:
        return ['Courage', 'Determination', 'Leadership'];
      case PersonalityArchetype.mentor:
        return ['Wisdom', 'Experience', 'Guidance'];
      case PersonalityArchetype.explorer:
        return ['Adaptability', 'Resourcefulness', 'Curiosity'];
      case PersonalityArchetype.magician:
        return ['Knowledge', 'Power', 'Intuition'];
      case PersonalityArchetype.lover:
        return ['Empathy', 'Devotion', 'Inspiration'];
      case PersonalityArchetype.shadow:
        return ['Intelligence', 'Cunning', 'Persistence'];
      default:
        return ['Versatility', 'Adaptability'];
    }
  }

  List<String> _getArchetypeWeaknesses(PersonalityArchetype archetype) {
    switch (archetype) {
      case PersonalityArchetype.hero:
        return ['Self-doubt', 'Recklessness'];
      case PersonalityArchetype.mentor:
        return ['Overprotectiveness', 'Past regrets'];
      case PersonalityArchetype.explorer:
        return ['Restlessness', 'Impatience'];
      case PersonalityArchetype.magician:
        return ['Arrogance', 'Isolation'];
      case PersonalityArchetype.lover:
        return ['Jealousy', 'Emotional vulnerability'];
      case PersonalityArchetype.shadow:
        return ['Obsession', 'Isolation'];
      default:
        return ['Unknown challenges'];
    }
  }

  List<String> _getArchetypeFears(PersonalityArchetype archetype) {
    switch (archetype) {
      case PersonalityArchetype.hero:
        return ['Failure', 'Letting others down'];
      case PersonalityArchetype.mentor:
        return ['Student\'s failure', 'Being forgotten'];
      case PersonalityArchetype.explorer:
        return ['Being trapped', 'Boredom'];
      case PersonalityArchetype.magician:
        return ['Powerlessness', 'Being ordinary'];
      case PersonalityArchetype.lover:
        return ['Rejection', 'Being alone'];
      case PersonalityArchetype.shadow:
        return ['Being defeated', 'Irrelevance'];
      default:
        return ['The unknown'];
    }
  }

  List<String> _getArchetypeMotivations(PersonalityArchetype archetype) {
    switch (archetype) {
      case PersonalityArchetype.hero:
        return ['Protect others', 'Prove themselves'];
      case PersonalityArchetype.mentor:
        return ['Guide others', 'Pass on knowledge'];
      case PersonalityArchetype.explorer:
        return ['Discover new things', 'Push boundaries'];
      case PersonalityArchetype.magician:
        return ['Master their craft', 'Transform the world'];
      case PersonalityArchetype.lover:
        return ['Find true love', 'Create harmony'];
      case PersonalityArchetype.shadow:
        return ['Achieve their goals', 'Gain recognition'];
      default:
        return ['Fulfill their purpose'];
    }
  }

  String _getArchetypeOccupation(PersonalityArchetype archetype) {
    switch (archetype) {
      case PersonalityArchetype.hero:
        return 'Guardian';
      case PersonalityArchetype.mentor:
        return 'Teacher';
      case PersonalityArchetype.explorer:
        return 'Adventurer';
      case PersonalityArchetype.magician:
        return 'Mage';
      case PersonalityArchetype.lover:
        return 'Artist';
      case PersonalityArchetype.shadow:
        return 'Mysterious Figure';
      default:
        return 'Wanderer';
    }
  }
}