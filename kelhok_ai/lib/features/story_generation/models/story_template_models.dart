import 'package:flutter/foundation.dart';

/// Represents a story template with predefined structure and prompts
class StoryTemplate {
  final String id;
  final String name;
  final String description;
  final String category;
  final List<String> genres;
  final String thumbnailUrl;
  final String previewContent;
  final List<TemplatePrompt> prompts;
  final Map<String, dynamic> settings;
  final int estimatedLength;
  final String difficulty;
  final List<String> tags;
  final bool isPremium;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StoryTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.genres,
    required this.thumbnailUrl,
    required this.previewContent,
    required this.prompts,
    required this.settings,
    required this.estimatedLength,
    required this.difficulty,
    required this.tags,
    this.isPremium = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StoryTemplate.fromJson(Map<String, dynamic> json) {
    return StoryTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      genres: List<String>.from(json['genres'] ?? []),
      thumbnailUrl: json['thumbnail_url'] as String? ?? '',
      previewContent: json['preview_content'] as String? ?? '',
      prompts: (json['prompts'] as List<dynamic>?)
          ?.map((p) => TemplatePrompt.fromJson(p))
          .toList() ?? [],
      settings: Map<String, dynamic>.from(json['settings'] ?? {}),
      estimatedLength: json['estimated_length'] as int? ?? 500,
      difficulty: json['difficulty'] as String? ?? 'medium',
      tags: List<String>.from(json['tags'] ?? []),
      isPremium: json['is_premium'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'genres': genres,
      'thumbnail_url': thumbnailUrl,
      'preview_content': previewContent,
      'prompts': prompts.map((p) => p.toJson()).toList(),
      'settings': settings,
      'estimated_length': estimatedLength,
      'difficulty': difficulty,
      'tags': tags,
      'is_premium': isPremium,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  StoryTemplate copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    List<String>? genres,
    String? thumbnailUrl,
    String? previewContent,
    List<TemplatePrompt>? prompts,
    Map<String, dynamic>? settings,
    int? estimatedLength,
    String? difficulty,
    List<String>? tags,
    bool? isPremium,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StoryTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      genres: genres ?? this.genres,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      previewContent: previewContent ?? this.previewContent,
      prompts: prompts ?? this.prompts,
      settings: settings ?? this.settings,
      estimatedLength: estimatedLength ?? this.estimatedLength,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Represents a prompt within a story template
class TemplatePrompt {
  final String id;
  final String title;
  final String content;
  final String type; // 'main', 'character', 'setting', 'conflict', 'resolution'
  final int order;
  final bool isRequired;
  final Map<String, dynamic> parameters;

  const TemplatePrompt({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.order,
    this.isRequired = true,
    this.parameters = const {},
  });

  factory TemplatePrompt.fromJson(Map<String, dynamic> json) {
    return TemplatePrompt(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      order: json['order'] as int,
      isRequired: json['is_required'] as bool? ?? true,
      parameters: Map<String, dynamic>.from(json['parameters'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'type': type,
      'order': order,
      'is_required': isRequired,
      'parameters': parameters,
    };
  }
}

/// Represents a story genre with detailed information
class StoryGenre {
  final String id;
  final String name;
  final String description;
  final String parentGenre;
  final List<String> subGenres;
  final String iconName;
  final String colorHex;
  final List<String> commonThemes;
  final List<String> typicalElements;
  final String moodDescription;
  final List<String> recommendedTones;

  const StoryGenre({
    required this.id,
    required this.name,
    required this.description,
    this.parentGenre = '',
    this.subGenres = const [],
    required this.iconName,
    required this.colorHex,
    this.commonThemes = const [],
    this.typicalElements = const [],
    required this.moodDescription,
    this.recommendedTones = const [],
  });

  factory StoryGenre.fromJson(Map<String, dynamic> json) {
    return StoryGenre(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      parentGenre: json['parent_genre'] as String? ?? '',
      subGenres: List<String>.from(json['sub_genres'] ?? []),
      iconName: json['icon_name'] as String,
      colorHex: json['color_hex'] as String,
      commonThemes: List<String>.from(json['common_themes'] ?? []),
      typicalElements: List<String>.from(json['typical_elements'] ?? []),
      moodDescription: json['mood_description'] as String,
      recommendedTones: List<String>.from(json['recommended_tones'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'parent_genre': parentGenre,
      'sub_genres': subGenres,
      'icon_name': iconName,
      'color_hex': colorHex,
      'common_themes': commonThemes,
      'typical_elements': typicalElements,
      'mood_description': moodDescription,
      'recommended_tones': recommendedTones,
    };
  }
}

/// Represents a template category for organization
class TemplateCategory {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final String colorHex;
  final int templateCount;
  final bool isPopular;

  const TemplateCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.colorHex,
    this.templateCount = 0,
    this.isPopular = false,
  });

  factory TemplateCategory.fromJson(Map<String, dynamic> json) {
    return TemplateCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconName: json['icon_name'] as String,
      colorHex: json['color_hex'] as String,
      templateCount: json['template_count'] as int? ?? 0,
      isPopular: json['is_popular'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon_name': iconName,
      'color_hex': colorHex,
      'template_count': templateCount,
      'is_popular': isPopular,
    };
  }
}

/// Represents customization options for a template
class TemplateCustomization {
  final String templateId;
  final Map<String, String> customPrompts;
  final List<String> selectedGenres;
  final String selectedTone;
  final String selectedMood;
  final int targetLength;
  final Map<String, dynamic> characterSettings;
  final Map<String, dynamic> plotSettings;

  const TemplateCustomization({
    required this.templateId,
    this.customPrompts = const {},
    this.selectedGenres = const [],
    this.selectedTone = 'neutral',
    this.selectedMood = 'balanced',
    this.targetLength = 500,
    this.characterSettings = const {},
    this.plotSettings = const {},
  });

  factory TemplateCustomization.fromJson(Map<String, dynamic> json) {
    return TemplateCustomization(
      templateId: json['template_id'] as String,
      customPrompts: Map<String, String>.from(json['custom_prompts'] ?? {}),
      selectedGenres: List<String>.from(json['selected_genres'] ?? []),
      selectedTone: json['selected_tone'] as String? ?? 'neutral',
      selectedMood: json['selected_mood'] as String? ?? 'balanced',
      targetLength: json['target_length'] as int? ?? 500,
      characterSettings: Map<String, dynamic>.from(json['character_settings'] ?? {}),
      plotSettings: Map<String, dynamic>.from(json['plot_settings'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'template_id': templateId,
      'custom_prompts': customPrompts,
      'selected_genres': selectedGenres,
      'selected_tone': selectedTone,
      'selected_mood': selectedMood,
      'target_length': targetLength,
      'character_settings': characterSettings,
      'plot_settings': plotSettings,
    };
  }
}

/// Predefined story templates for immediate use
class PredefinedTemplates {
  static List<StoryTemplate> get defaultTemplates => [
    // Adventure Template
    StoryTemplate(
      id: 'adventure_001',
      name: 'Epic Adventure',
      description: 'A thrilling journey filled with danger, discovery, and heroism',
      category: 'adventure',
      genres: ['adventure', 'action', 'fantasy'],
      thumbnailUrl: 'assets/templates/adventure.png',
      previewContent: 'The ancient map crackled in Sarah\'s hands as she studied the mysterious symbols...',
      prompts: [
        TemplatePrompt(
          id: 'adv_main',
          title: 'Main Adventure',
          content: 'Write an epic adventure story about {character} who discovers {discovery} and must {quest} to {goal}',
          type: 'main',
          order: 1,
        ),
      ],
      settings: {'tone': 'exciting', 'pace': 'fast'},
      estimatedLength: 800,
      difficulty: 'medium',
      tags: ['hero', 'quest', 'journey', 'danger'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    // Romance Template
    StoryTemplate(
      id: 'romance_001',
      name: 'Sweet Romance',
      description: 'A heartwarming love story with emotional depth and connection',
      category: 'romance',
      genres: ['romance', 'drama', 'contemporary'],
      thumbnailUrl: 'assets/templates/romance.png',
      previewContent: 'Emma never believed in love at first sight until she met him at the coffee shop...',
      prompts: [
        TemplatePrompt(
          id: 'rom_main',
          title: 'Romance Story',
          content: 'Write a romantic story about {character1} and {character2} who meet {meeting_place} and overcome {obstacle} to find love',
          type: 'main',
          order: 1,
        ),
      ],
      settings: {'tone': 'warm', 'pace': 'gentle'},
      estimatedLength: 600,
      difficulty: 'easy',
      tags: ['love', 'relationship', 'emotion', 'connection'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    // Mystery Template
    StoryTemplate(
      id: 'mystery_001',
      name: 'Detective Mystery',
      description: 'A puzzling mystery that keeps readers guessing until the end',
      category: 'mystery',
      genres: ['mystery', 'thriller', 'crime'],
      thumbnailUrl: 'assets/templates/mystery.png',
      previewContent: 'Detective Morgan stared at the crime scene, knowing something wasn\'t right...',
      prompts: [
        TemplatePrompt(
          id: 'mys_main',
          title: 'Mystery Plot',
          content: 'Write a mystery story where {detective} investigates {crime} and discovers {clue} that leads to {revelation}',
          type: 'main',
          order: 1,
        ),
      ],
      settings: {'tone': 'suspenseful', 'pace': 'building'},
      estimatedLength: 1000,
      difficulty: 'hard',
      tags: ['detective', 'clues', 'investigation', 'puzzle'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    // Sci-Fi Template
    StoryTemplate(
      id: 'scifi_001',
      name: 'Space Odyssey',
      description: 'A futuristic tale of technology, space exploration, and possibilities',
      category: 'sci-fi',
      genres: ['sci-fi', 'space', 'technology'],
      thumbnailUrl: 'assets/templates/scifi.png',
      previewContent: 'The starship Horizon drifted silently through the void, its crew unaware of the discovery awaiting them...',
      prompts: [
        TemplatePrompt(
          id: 'sf_main',
          title: 'Sci-Fi Adventure',
          content: 'Write a science fiction story set in {setting} where {character} discovers {technology} and must {mission} to {outcome}',
          type: 'main',
          order: 1,
        ),
      ],
      settings: {'tone': 'wonder', 'pace': 'varied'},
      estimatedLength: 900,
      difficulty: 'medium',
      tags: ['future', 'technology', 'space', 'exploration'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    // Fantasy Template
    StoryTemplate(
      id: 'fantasy_001',
      name: 'Magical Realm',
      description: 'A magical world filled with wonder, mythical creatures, and ancient powers',
      category: 'fantasy',
      genres: ['fantasy', 'magic', 'mythology'],
      thumbnailUrl: 'assets/templates/fantasy.png',
      previewContent: 'The crystal pulsed with ancient magic as Lyra touched its surface, awakening powers long forgotten...',
      prompts: [
        TemplatePrompt(
          id: 'fan_main',
          title: 'Fantasy Quest',
          content: 'Write a fantasy story about {character} who possesses {magic} and must {quest} to defeat {antagonist} and restore {peace}',
          type: 'main',
          order: 1,
        ),
      ],
      settings: {'tone': 'magical', 'pace': 'epic'},
      estimatedLength: 1200,
      difficulty: 'hard',
      tags: ['magic', 'quest', 'mythical', 'power'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  static List<StoryGenre> get defaultGenres => [
    StoryGenre(
      id: 'adventure',
      name: 'Adventure',
      description: 'Stories filled with exciting journeys and thrilling experiences',
      iconName: 'adventure',
      colorHex: '#FF6B35',
      commonThemes: ['journey', 'discovery', 'courage', 'exploration'],
      typicalElements: ['quest', 'travel', 'danger', 'heroism'],
      moodDescription: 'Exciting and energetic',
      recommendedTones: ['exciting', 'bold', 'inspiring'],
    ),
    StoryGenre(
      id: 'romance',
      name: 'Romance',
      description: 'Stories centered around love, relationships, and emotional connections',
      iconName: 'heart',
      colorHex: '#E91E63',
      commonThemes: ['love', 'relationships', 'emotion', 'connection'],
      typicalElements: ['meeting', 'attraction', 'conflict', 'resolution'],
      moodDescription: 'Warm and emotional',
      recommendedTones: ['warm', 'tender', 'passionate'],
    ),
    StoryGenre(
      id: 'mystery',
      name: 'Mystery',
      description: 'Puzzling stories that challenge readers to solve along with the characters',
      iconName: 'search',
      colorHex: '#3F51B5',
      commonThemes: ['investigation', 'secrets', 'truth', 'justice'],
      typicalElements: ['crime', 'clues', 'suspects', 'revelation'],
      moodDescription: 'Suspenseful and intriguing',
      recommendedTones: ['suspenseful', 'dark', 'mysterious'],
    ),
    StoryGenre(
      id: 'fantasy',
      name: 'Fantasy',
      description: 'Magical worlds with supernatural elements and mythical creatures',
      iconName: 'auto_awesome',
      colorHex: '#9C27B0',
      commonThemes: ['magic', 'power', 'good vs evil', 'destiny'],
      typicalElements: ['magic', 'creatures', 'quests', 'prophecies'],
      moodDescription: 'Magical and wondrous',
      recommendedTones: ['magical', 'epic', 'mystical'],
    ),
    StoryGenre(
      id: 'sci-fi',
      name: 'Science Fiction',
      description: 'Futuristic stories exploring technology and scientific possibilities',
      iconName: 'rocket_launch',
      colorHex: '#00BCD4',
      commonThemes: ['technology', 'future', 'exploration', 'progress'],
      typicalElements: ['technology', 'space', 'aliens', 'time'],
      moodDescription: 'Futuristic and imaginative',
      recommendedTones: ['wonder', 'clinical', 'optimistic'],
    ),
  ];

  static List<TemplateCategory> get defaultCategories => [
    TemplateCategory(
      id: 'popular',
      name: 'Popular Templates',
      description: 'Most loved templates by our community',
      iconName: 'trending_up',
      colorHex: '#FF5722',
      isPopular: true,
    ),
    TemplateCategory(
      id: 'beginner',
      name: 'Beginner Friendly',
      description: 'Perfect templates for new writers',
      iconName: 'school',
      colorHex: '#4CAF50',
    ),
    TemplateCategory(
      id: 'advanced',
      name: 'Advanced Writers',
      description: 'Complex templates for experienced writers',
      iconName: 'psychology',
      colorHex: '#9C27B0',
    ),
    TemplateCategory(
      id: 'quick',
      name: 'Quick Stories',
      description: 'Templates for short, engaging stories',
      iconName: 'flash_on',
      colorHex: '#FFC107',
    ),
  ];
} 