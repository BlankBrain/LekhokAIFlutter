// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generation_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerationRequestModel _$GenerationRequestModelFromJson(
  Map<String, dynamic> json,
) => GenerationRequestModel(
  storyIdea: json['storyIdea'] as String,
  character: json['character'] as String?,
);

Map<String, dynamic> _$GenerationRequestModelToJson(
  GenerationRequestModel instance,
) => <String, dynamic>{
  'storyIdea': instance.storyIdea,
  'character': instance.character,
};
