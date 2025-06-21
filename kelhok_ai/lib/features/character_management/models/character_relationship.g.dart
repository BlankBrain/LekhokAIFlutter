// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_relationship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterRelationship _$CharacterRelationshipFromJson(
        Map<String, dynamic> json) =>
    CharacterRelationship(
      id: json['id'] as String,
      characterAId: json['characterAId'] as String,
      characterBId: json['characterBId'] as String,
      type: $enumDecode(_$RelationshipTypeEnumMap, json['type']),
      strength: $enumDecode(_$RelationshipStrengthEnumMap, json['strength']),
      description: json['description'] as String,
      sharedHistory: (json['sharedHistory'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      dynamicProperties:
          json['dynamicProperties'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CharacterRelationshipToJson(
        CharacterRelationship instance) =>
    <String, dynamic>{
      'id': instance.id,
      'characterAId': instance.characterAId,
      'characterBId': instance.characterBId,
      'type': _$RelationshipTypeEnumMap[instance.type]!,
      'strength': _$RelationshipStrengthEnumMap[instance.strength]!,
      'description': instance.description,
      'sharedHistory': instance.sharedHistory,
      'dynamicProperties': instance.dynamicProperties,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$RelationshipTypeEnumMap = {
  RelationshipType.family: 'family',
  RelationshipType.romantic: 'romantic',
  RelationshipType.friendship: 'friendship',
  RelationshipType.rivalry: 'rivalry',
  RelationshipType.mentor: 'mentor',
  RelationshipType.ally: 'ally',
  RelationshipType.enemy: 'enemy',
  RelationshipType.colleague: 'colleague',
  RelationshipType.acquaintance: 'acquaintance',
  RelationshipType.unknown: 'unknown',
};

const _$RelationshipStrengthEnumMap = {
  RelationshipStrength.weak: 'weak',
  RelationshipStrength.moderate: 'moderate',
  RelationshipStrength.strong: 'strong',
  RelationshipStrength.intense: 'intense',
};

RelationshipNetwork _$RelationshipNetworkFromJson(Map<String, dynamic> json) =>
    RelationshipNetwork(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      characterIds: (json['characterIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      relationships: (json['relationships'] as List<dynamic>)
          .map((e) => CharacterRelationship.fromJson(e as Map<String, dynamic>))
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$RelationshipNetworkToJson(
        RelationshipNetwork instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'characterIds': instance.characterIds,
      'relationships': instance.relationships,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
