// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generation_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerationResponseModel _$GenerationResponseModelFromJson(
  Map<String, dynamic> json,
) => GenerationResponseModel(
  story: json['story'] as String,
  imagePrompt: json['imagePrompt'] as String,
  modelName: json['modelName'] as String?,
  inputTokens: (json['inputTokens'] as num?)?.toInt(),
  outputTokens: (json['outputTokens'] as num?)?.toInt(),
);

Map<String, dynamic> _$GenerationResponseModelToJson(
  GenerationResponseModel instance,
) => <String, dynamic>{
  'story': instance.story,
  'imagePrompt': instance.imagePrompt,
  'modelName': instance.modelName,
  'inputTokens': instance.inputTokens,
  'outputTokens': instance.outputTokens,
};
