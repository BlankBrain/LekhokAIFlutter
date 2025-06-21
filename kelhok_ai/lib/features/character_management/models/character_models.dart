class Character {
  final String id;
  final String name;
  final String description;
  final CharacterAppearance appearance;
  final CharacterPersonality personality;
  final CharacterBackground background;
  final List<String> tags;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;

  const Character({
    required this.id,
    required this.name,
    required this.description,
    required this.appearance,
    required this.personality,
    required this.background,
    this.tags = const [],
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      appearance: CharacterAppearance.fromJson(json['appearance']),
      personality: CharacterPersonality.fromJson(json['personality']),
      background: CharacterBackground.fromJson(json['background']),
      tags: List<String>.from(json['tags'] ?? []),
      avatarUrl: json['avatar_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'appearance': appearance.toJson(),
      'personality': personality.toJson(),
      'background': background.toJson(),
      'tags': tags,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_favorite': isFavorite,
    };
  }

  Character copyWith({
    String? id,
    String? name,
    String? description,
    CharacterAppearance? appearance,
    CharacterPersonality? personality,
    CharacterBackground? background,
    List<String>? tags,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      appearance: appearance ?? this.appearance,
      personality: personality ?? this.personality,
      background: background ?? this.background,
      tags: tags ?? this.tags,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class CharacterAppearance {
  final String? gender;
  final int? age;
  final String? height;
  final String? build;
  final String? hairColor;
  final String? hairStyle;
  final String? eyeColor;
  final String? skinTone;
  final List<String> distinctiveFeatures;
  final String? clothing;

  const CharacterAppearance({
    this.gender,
    this.age,
    this.height,
    this.build,
    this.hairColor,
    this.hairStyle,
    this.eyeColor,
    this.skinTone,
    this.distinctiveFeatures = const [],
    this.clothing,
  });

  factory CharacterAppearance.fromJson(Map<String, dynamic> json) {
    return CharacterAppearance(
      gender: json['gender'],
      age: json['age'],
      height: json['height'],
      build: json['build'],
      hairColor: json['hair_color'],
      hairStyle: json['hair_style'],
      eyeColor: json['eye_color'],
      skinTone: json['skin_tone'],
      distinctiveFeatures: List<String>.from(json['distinctive_features'] ?? []),
      clothing: json['clothing'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'age': age,
      'height': height,
      'build': build,
      'hair_color': hairColor,
      'hair_style': hairStyle,
      'eye_color': eyeColor,
      'skin_tone': skinTone,
      'distinctive_features': distinctiveFeatures,
      'clothing': clothing,
    };
  }

  CharacterAppearance copyWith({
    String? gender,
    int? age,
    String? height,
    String? build,
    String? hairColor,
    String? hairStyle,
    String? eyeColor,
    String? skinTone,
    List<String>? distinctiveFeatures,
    String? clothing,
  }) {
    return CharacterAppearance(
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      build: build ?? this.build,
      hairColor: hairColor ?? this.hairColor,
      hairStyle: hairStyle ?? this.hairStyle,
      eyeColor: eyeColor ?? this.eyeColor,
      skinTone: skinTone ?? this.skinTone,
      distinctiveFeatures: distinctiveFeatures ?? this.distinctiveFeatures,
      clothing: clothing ?? this.clothing,
    );
  }
}

class CharacterPersonality {
  final List<String> traits;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> fears;
  final List<String> motivations;
  final String? speechPattern;
  final String? mannerisms;
  final PersonalityArchetype? archetype;

  const CharacterPersonality({
    this.traits = const [],
    this.strengths = const [],
    this.weaknesses = const [],
    this.fears = const [],
    this.motivations = const [],
    this.speechPattern,
    this.mannerisms,
    this.archetype,
  });

  factory CharacterPersonality.fromJson(Map<String, dynamic> json) {
    return CharacterPersonality(
      traits: List<String>.from(json['traits'] ?? []),
      strengths: List<String>.from(json['strengths'] ?? []),
      weaknesses: List<String>.from(json['weaknesses'] ?? []),
      fears: List<String>.from(json['fears'] ?? []),
      motivations: List<String>.from(json['motivations'] ?? []),
      speechPattern: json['speech_pattern'],
      mannerisms: json['mannerisms'],
      archetype: json['archetype'] != null 
          ? PersonalityArchetype.values.firstWhere(
              (e) => e.name == json['archetype'],
              orElse: () => PersonalityArchetype.hero,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'traits': traits,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'fears': fears,
      'motivations': motivations,
      'speech_pattern': speechPattern,
      'mannerisms': mannerisms,
      'archetype': archetype?.name,
    };
  }

  CharacterPersonality copyWith({
    List<String>? traits,
    List<String>? strengths,
    List<String>? weaknesses,
    List<String>? fears,
    List<String>? motivations,
    String? speechPattern,
    String? mannerisms,
    PersonalityArchetype? archetype,
  }) {
    return CharacterPersonality(
      traits: traits ?? this.traits,
      strengths: strengths ?? this.strengths,
      weaknesses: weaknesses ?? this.weaknesses,
      fears: fears ?? this.fears,
      motivations: motivations ?? this.motivations,
      speechPattern: speechPattern ?? this.speechPattern,
      mannerisms: mannerisms ?? this.mannerisms,
      archetype: archetype ?? this.archetype,
    );
  }
}

class CharacterBackground {
  final String? occupation;
  final String? origin;
  final String? education;
  final String? family;
  final List<String> relationships;
  final List<String> pastExperiences;
  final String? currentGoal;
  final String? backstory;

  const CharacterBackground({
    this.occupation,
    this.origin,
    this.education,
    this.family,
    this.relationships = const [],
    this.pastExperiences = const [],
    this.currentGoal,
    this.backstory,
  });

  factory CharacterBackground.fromJson(Map<String, dynamic> json) {
    return CharacterBackground(
      occupation: json['occupation'],
      origin: json['origin'],
      education: json['education'],
      family: json['family'],
      relationships: List<String>.from(json['relationships'] ?? []),
      pastExperiences: List<String>.from(json['past_experiences'] ?? []),
      currentGoal: json['current_goal'],
      backstory: json['backstory'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'occupation': occupation,
      'origin': origin,
      'education': education,
      'family': family,
      'relationships': relationships,
      'past_experiences': pastExperiences,
      'current_goal': currentGoal,
      'backstory': backstory,
    };
  }

  CharacterBackground copyWith({
    String? occupation,
    String? origin,
    String? education,
    String? family,
    List<String>? relationships,
    List<String>? pastExperiences,
    String? currentGoal,
    String? backstory,
  }) {
    return CharacterBackground(
      occupation: occupation ?? this.occupation,
      origin: origin ?? this.origin,
      education: education ?? this.education,
      family: family ?? this.family,
      relationships: relationships ?? this.relationships,
      pastExperiences: pastExperiences ?? this.pastExperiences,
      currentGoal: currentGoal ?? this.currentGoal,
      backstory: backstory ?? this.backstory,
    );
  }
}

enum PersonalityArchetype {
  hero,
  mentor,
  ally,
  guardian,
  trickster,
  shapeshifter,
  shadow,
  innocent,
  explorer,
  sage,
  creator,
  ruler,
  caregiver,
  everyman,
  lover,
  jester,
  rebel,
  magician;

  String get displayName {
    switch (this) {
      case PersonalityArchetype.hero:
        return 'Hero';
      case PersonalityArchetype.mentor:
        return 'Mentor';
      case PersonalityArchetype.ally:
        return 'Ally';
      case PersonalityArchetype.guardian:
        return 'Guardian';
      case PersonalityArchetype.trickster:
        return 'Trickster';
      case PersonalityArchetype.shapeshifter:
        return 'Shapeshifter';
      case PersonalityArchetype.shadow:
        return 'Shadow';
      case PersonalityArchetype.innocent:
        return 'Innocent';
      case PersonalityArchetype.explorer:
        return 'Explorer';
      case PersonalityArchetype.sage:
        return 'Sage';
      case PersonalityArchetype.creator:
        return 'Creator';
      case PersonalityArchetype.ruler:
        return 'Ruler';
      case PersonalityArchetype.caregiver:
        return 'Caregiver';
      case PersonalityArchetype.everyman:
        return 'Everyman';
      case PersonalityArchetype.lover:
        return 'Lover';
      case PersonalityArchetype.jester:
        return 'Jester';
      case PersonalityArchetype.rebel:
        return 'Rebel';
      case PersonalityArchetype.magician:
        return 'Magician';
    }
  }

  String get description {
    switch (this) {
      case PersonalityArchetype.hero:
        return 'Brave, determined, willing to sacrifice for others';
      case PersonalityArchetype.mentor:
        return 'Wise, experienced, guides others';
      case PersonalityArchetype.ally:
        return 'Loyal, supportive, stands by the hero';
      case PersonalityArchetype.guardian:
        return 'Protective, tests the hero, challenges growth';
      case PersonalityArchetype.trickster:
        return 'Clever, unpredictable, brings comic relief';
      case PersonalityArchetype.shapeshifter:
        return 'Mysterious, changeable, keeps others guessing';
      case PersonalityArchetype.shadow:
        return 'Dark, represents fears and hidden desires';
      case PersonalityArchetype.innocent:
        return 'Pure, optimistic, sees the good in everything';
      case PersonalityArchetype.explorer:
        return 'Adventurous, independent, seeks new experiences';
      case PersonalityArchetype.sage:
        return 'Knowledgeable, thoughtful, seeks truth';
      case PersonalityArchetype.creator:
        return 'Imaginative, artistic, brings new things to life';
      case PersonalityArchetype.ruler:
        return 'Authoritative, responsible, creates order';
      case PersonalityArchetype.caregiver:
        return 'Nurturing, selfless, protects others';
      case PersonalityArchetype.everyman:
        return 'Relatable, down-to-earth, represents common people';
      case PersonalityArchetype.lover:
        return 'Passionate, devoted, seeks connection';
      case PersonalityArchetype.jester:
        return 'Humorous, light-hearted, brings joy';
      case PersonalityArchetype.rebel:
        return 'Revolutionary, independent, challenges authority';
      case PersonalityArchetype.magician:
        return 'Transformative, visionary, makes impossible possible';
    }
  }
}

// Predefined character templates for quick creation
class CharacterTemplates {
  static List<Character> get defaultTemplates => [
    _createHeroTemplate(),
    _createMentorTemplate(),
    _createVillainTemplate(),
    _createSidekickTemplate(),
    _createLoveInterestTemplate(),
    _createAntiHeroTemplate(),
  ];

  static Character _createHeroTemplate() {
    return Character(
      id: 'template_hero',
      name: 'The Hero',
      description: 'A brave protagonist ready to face any challenge',
      appearance: const CharacterAppearance(
        age: 25,
        build: 'Athletic',
        distinctiveFeatures: ['Determined eyes', 'Strong posture'],
      ),
      personality: const CharacterPersonality(
        archetype: PersonalityArchetype.hero,
        traits: ['Brave', 'Determined', 'Compassionate'],
        strengths: ['Leadership', 'Courage', 'Moral compass'],
        weaknesses: ['Sometimes reckless', 'Self-doubt'],
        motivations: ['Protect others', 'Do what\'s right'],
      ),
      background: const CharacterBackground(
        currentGoal: 'Save the world/community',
        backstory: 'Called to adventure by circumstances beyond their control',
      ),
      tags: ['protagonist', 'hero', 'leader'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static Character _createMentorTemplate() {
    return Character(
      id: 'template_mentor',
      name: 'The Wise Mentor',
      description: 'An experienced guide who helps others grow',
      appearance: const CharacterAppearance(
        age: 55,
        build: 'Average',
        distinctiveFeatures: ['Kind eyes', 'Weathered hands'],
      ),
      personality: const CharacterPersonality(
        archetype: PersonalityArchetype.mentor,
        traits: ['Wise', 'Patient', 'Understanding'],
        strengths: ['Experience', 'Wisdom', 'Teaching ability'],
        weaknesses: ['Past regrets', 'Sometimes cryptic'],
        motivations: ['Guide the next generation', 'Share knowledge'],
      ),
      background: const CharacterBackground(
        occupation: 'Teacher/Former adventurer',
        currentGoal: 'Train the hero',
        backstory: 'Has walked the hero\'s path before',
      ),
      tags: ['mentor', 'wise', 'guide'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static Character _createVillainTemplate() {
    return Character(
      id: 'template_villain',
      name: 'The Antagonist',
      description: 'A formidable opponent with their own agenda',
      appearance: const CharacterAppearance(
        age: 40,
        build: 'Imposing',
        distinctiveFeatures: ['Piercing gaze', 'Commanding presence'],
      ),
      personality: const CharacterPersonality(
        archetype: PersonalityArchetype.shadow,
        traits: ['Cunning', 'Ambitious', 'Ruthless'],
        strengths: ['Intelligence', 'Resources', 'Determination'],
        weaknesses: ['Pride', 'Obsession', 'Isolation'],
        motivations: ['Power', 'Revenge', 'Control'],
      ),
      background: const CharacterBackground(
        currentGoal: 'Achieve their grand plan',
        backstory: 'Shaped by past trauma or injustice',
      ),
      tags: ['antagonist', 'villain', 'powerful'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static Character _createSidekickTemplate() {
    return Character(
      id: 'template_sidekick',
      name: 'The Loyal Companion',
      description: 'A faithful friend who stands by the hero',
      appearance: const CharacterAppearance(
        age: 22,
        build: 'Lean',
        distinctiveFeatures: ['Bright smile', 'Quick movements'],
      ),
      personality: const CharacterPersonality(
        archetype: PersonalityArchetype.ally,
        traits: ['Loyal', 'Optimistic', 'Supportive'],
        strengths: ['Friendship', 'Agility', 'Quick thinking'],
        weaknesses: ['Inexperience', 'Impulsiveness'],
        motivations: ['Help friends', 'Prove themselves'],
      ),
      background: const CharacterBackground(
        currentGoal: 'Support the hero\'s quest',
        backstory: 'Met the hero by chance and chose to follow',
      ),
      tags: ['sidekick', 'ally', 'friend'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static Character _createLoveInterestTemplate() {
    return Character(
      id: 'template_love_interest',
      name: 'The Love Interest',
      description: 'Someone who captures the heart',
      appearance: const CharacterAppearance(
        age: 24,
        build: 'Graceful',
        distinctiveFeatures: ['Captivating smile', 'Elegant bearing'],
      ),
      personality: const CharacterPersonality(
        archetype: PersonalityArchetype.lover,
        traits: ['Charming', 'Independent', 'Caring'],
        strengths: ['Emotional intelligence', 'Diplomacy', 'Compassion'],
        weaknesses: ['Torn loyalties', 'Vulnerable heart'],
        motivations: ['Love', 'Peace', 'Understanding'],
      ),
      background: const CharacterBackground(
        currentGoal: 'Find true love and happiness',
        backstory: 'Has their own dreams and aspirations',
      ),
      tags: ['romance', 'love', 'partner'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static Character _createAntiHeroTemplate() {
    return Character(
      id: 'template_antihero',
      name: 'The Anti-Hero',
      description: 'A flawed protagonist with questionable methods',
      appearance: const CharacterAppearance(
        age: 35,
        build: 'Rugged',
        distinctiveFeatures: ['Scars', 'Weathered face', 'Intense eyes'],
      ),
      personality: const CharacterPersonality(
        archetype: PersonalityArchetype.rebel,
        traits: ['Cynical', 'Independent', 'Morally ambiguous'],
        strengths: ['Survival skills', 'Resourcefulness', 'Determination'],
        weaknesses: ['Trust issues', 'Violent tendencies', 'Isolation'],
        motivations: ['Personal gain', 'Revenge', 'Survival'],
      ),
      background: const CharacterBackground(
        occupation: 'Mercenary/Outlaw',
        currentGoal: 'Complete their mission at any cost',
        backstory: 'Betrayed by those they trusted',
      ),
      tags: ['antihero', 'complex', 'morally-gray'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
} 