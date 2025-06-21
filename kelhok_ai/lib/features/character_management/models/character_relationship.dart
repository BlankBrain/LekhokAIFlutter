import 'package:json_annotation/json_annotation.dart';

part 'character_relationship.g.dart';

// Character relationship models for managing relationships between characters

enum RelationshipType {
  family,
  romantic,
  friendship,
  rivalry,
  mentor,
  ally,
  enemy,
  colleague,
  acquaintance,
  unknown;

  String get displayName {
    switch (this) {
      case RelationshipType.family:
        return 'Family';
      case RelationshipType.romantic:
        return 'Romantic';
      case RelationshipType.friendship:
        return 'Friendship';
      case RelationshipType.rivalry:
        return 'Rivalry';
      case RelationshipType.mentor:
        return 'Mentor/Student';
      case RelationshipType.ally:
        return 'Ally';
      case RelationshipType.enemy:
        return 'Enemy';
      case RelationshipType.colleague:
        return 'Colleague';
      case RelationshipType.acquaintance:
        return 'Acquaintance';
      case RelationshipType.unknown:
        return 'Unknown';
    }
  }

  String get description {
    switch (this) {
      case RelationshipType.family:
        return 'Related by blood or marriage';
      case RelationshipType.romantic:
        return 'Romantic partners or love interests';
      case RelationshipType.friendship:
        return 'Close friends who trust each other';
      case RelationshipType.rivalry:
        return 'Competitive relationship, not necessarily hostile';
      case RelationshipType.mentor:
        return 'One teaches or guides the other';
      case RelationshipType.ally:
        return 'Partners working toward common goals';
      case RelationshipType.enemy:
        return 'Hostile relationship with conflict';
      case RelationshipType.colleague:
        return 'Professional or work relationship';
      case RelationshipType.acquaintance:
        return 'Know each other but not close';
      case RelationshipType.unknown:
        return 'Relationship status unclear';
    }
  }
}

enum RelationshipStrength {
  weak,
  moderate,
  strong,
  intense;

  String get displayName {
    switch (this) {
      case RelationshipStrength.weak:
        return 'Weak';
      case RelationshipStrength.moderate:
        return 'Moderate';
      case RelationshipStrength.strong:
        return 'Strong';
      case RelationshipStrength.intense:
        return 'Intense';
    }
  }

  double get value {
    switch (this) {
      case RelationshipStrength.weak:
        return 0.25;
      case RelationshipStrength.moderate:
        return 0.5;
      case RelationshipStrength.strong:
        return 0.75;
      case RelationshipStrength.intense:
        return 1.0;
    }
  }
}

@JsonSerializable()
class CharacterRelationship {
  final String id;
  final String characterAId;
  final String characterBId;
  final RelationshipType type;
  final RelationshipStrength strength;
  final String description;
  final List<String> sharedHistory;
  final Map<String, dynamic> dynamicProperties;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CharacterRelationship({
    required this.id,
    required this.characterAId,
    required this.characterBId,
    required this.type,
    required this.strength,
    required this.description,
    this.sharedHistory = const [],
    this.dynamicProperties = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  factory CharacterRelationship.fromJson(Map<String, dynamic> json) =>
      _$CharacterRelationshipFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterRelationshipToJson(this);

  CharacterRelationship copyWith({
    String? id,
    String? characterAId,
    String? characterBId,
    RelationshipType? type,
    RelationshipStrength? strength,
    String? description,
    List<String>? sharedHistory,
    Map<String, dynamic>? dynamicProperties,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CharacterRelationship(
      id: id ?? this.id,
      characterAId: characterAId ?? this.characterAId,
      characterBId: characterBId ?? this.characterBId,
      type: type ?? this.type,
      strength: strength ?? this.strength,
      description: description ?? this.description,
      sharedHistory: sharedHistory ?? this.sharedHistory,
      dynamicProperties: dynamicProperties ?? this.dynamicProperties,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if this relationship involves the given character
  bool involvesCharacter(String characterId) {
    return characterAId == characterId || characterBId == characterId;
  }

  /// Get the other character ID in this relationship
  String getOtherCharacterId(String characterId) {
    if (characterAId == characterId) return characterBId;
    if (characterBId == characterId) return characterAId;
    throw ArgumentError('Character ID not found in this relationship');
  }

  /// Check if this is a mutual relationship type
  bool get isMutual {
    switch (type) {
      case RelationshipType.family:
      case RelationshipType.romantic:
      case RelationshipType.friendship:
      case RelationshipType.rivalry:
      case RelationshipType.ally:
      case RelationshipType.enemy:
      case RelationshipType.colleague:
      case RelationshipType.acquaintance:
        return true;
      case RelationshipType.mentor:
      case RelationshipType.unknown:
        return false;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterRelationship &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CharacterRelationship{id: $id, type: $type, strength: $strength}';
  }
}

@JsonSerializable()
class RelationshipNetwork {
  final String id;
  final String name;
  final String description;
  final List<String> characterIds;
  final List<CharacterRelationship> relationships;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RelationshipNetwork({
    required this.id,
    required this.name,
    required this.description,
    required this.characterIds,
    required this.relationships,
    this.metadata = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  factory RelationshipNetwork.fromJson(Map<String, dynamic> json) =>
      _$RelationshipNetworkFromJson(json);

  Map<String, dynamic> toJson() => _$RelationshipNetworkToJson(this);

  RelationshipNetwork copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? characterIds,
    List<CharacterRelationship>? relationships,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RelationshipNetwork(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      characterIds: characterIds ?? this.characterIds,
      relationships: relationships ?? this.relationships,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get all relationships for a specific character
  List<CharacterRelationship> getCharacterRelationships(String characterId) {
    return relationships.where((rel) => rel.involvesCharacter(characterId)).toList();
  }

  /// Get all characters connected to a specific character
  List<String> getConnectedCharacters(String characterId) {
    return relationships
        .where((rel) => rel.involvesCharacter(characterId))
        .map((rel) => rel.getOtherCharacterId(characterId))
        .toList();
  }

  /// Check if two characters have a direct relationship
  CharacterRelationship? getRelationshipBetween(String characterA, String characterB) {
    return relationships.firstWhere(
      (rel) => 
        (rel.characterAId == characterA && rel.characterBId == characterB) ||
        (rel.characterAId == characterB && rel.characterBId == characterA),
      orElse: () => throw StateError('No relationship found'),
    );
  }

  /// Add a new relationship to the network
  RelationshipNetwork addRelationship(CharacterRelationship relationship) {
    final updatedRelationships = List<CharacterRelationship>.from(relationships);
    updatedRelationships.add(relationship);
    
    final updatedCharacterIds = Set<String>.from(characterIds);
    updatedCharacterIds.add(relationship.characterAId);
    updatedCharacterIds.add(relationship.characterBId);
    
    return copyWith(
      relationships: updatedRelationships,
      characterIds: updatedCharacterIds.toList(),
      updatedAt: DateTime.now(),
    );
  }

  /// Remove a relationship from the network
  RelationshipNetwork removeRelationship(String relationshipId) {
    final updatedRelationships = relationships
        .where((rel) => rel.id != relationshipId)
        .toList();
    
    return copyWith(
      relationships: updatedRelationships,
      updatedAt: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelationshipNetwork &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'RelationshipNetwork{id: $id, name: $name, characters: ${characterIds.length}, relationships: ${relationships.length}}';
  }
}

/// Predefined relationship templates
class RelationshipTemplates {
  static const List<Map<String, dynamic>> templates = [
    {
      'name': 'Hero & Mentor',
      'type': RelationshipType.mentor,
      'strength': RelationshipStrength.strong,
      'description': 'A wise mentor guides the hero on their journey',
      'sharedHistory': [
        'First meeting when hero was inexperienced',
        'Training sessions and lessons learned',
        'Moments of doubt and encouragement',
      ],
    },
    {
      'name': 'Star-Crossed Lovers',
      'type': RelationshipType.romantic,
      'strength': RelationshipStrength.intense,
      'description': 'Two lovers kept apart by circumstances beyond their control',
      'sharedHistory': [
        'First meeting and instant attraction',
        'Secret meetings and stolen moments',
        'Discovery of obstacles to their love',
      ],
    },
    {
      'name': 'Childhood Friends',
      'type': RelationshipType.friendship,
      'strength': RelationshipStrength.strong,
      'description': 'Friends since childhood who know each other deeply',
      'sharedHistory': [
        'Playing together as children',
        'Shared adventures and mischief',
        'Supporting each other through difficult times',
      ],
    },
    {
      'name': 'Bitter Rivals',
      'type': RelationshipType.rivalry,
      'strength': RelationshipStrength.intense,
      'description': 'Two characters locked in competition and conflict',
      'sharedHistory': [
        'Initial competition or disagreement',
        'Escalating conflicts and confrontations',
        'Moments where rivalry becomes personal',
      ],
    },
    {
      'name': 'Siblings',
      'type': RelationshipType.family,
      'strength': RelationshipStrength.strong,
      'description': 'Brothers or sisters with a complex family bond',
      'sharedHistory': [
        'Growing up together in the same household',
        'Sibling rivalry and competition',
        'Protecting each other when needed',
      ],
    },
    {
      'name': 'Unlikely Allies',
      'type': RelationshipType.ally,
      'strength': RelationshipStrength.moderate,
      'description': 'Two very different characters forced to work together',
      'sharedHistory': [
        'Initial mistrust and conflict',
        'Forced cooperation due to circumstances',
        'Gradual respect and understanding',
      ],
    },
  ];

  static CharacterRelationship createFromTemplate(
    Map<String, dynamic> template,
    String characterAId,
    String characterBId,
  ) {
    return CharacterRelationship(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      characterAId: characterAId,
      characterBId: characterBId,
      type: template['type'] as RelationshipType,
      strength: template['strength'] as RelationshipStrength,
      description: template['description'] as String,
      sharedHistory: List<String>.from(template['sharedHistory'] as List),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}