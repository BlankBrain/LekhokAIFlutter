import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/story_entity.dart';
import '../../domain/entities/caption_entity.dart';

part 'generation_response_model.g.dart';

/// Data model for generation response from the API
@JsonSerializable()
class GenerationResponseModel extends Equatable {
  @JsonKey(name: 'story')
  final String story;
  
  @JsonKey(name: 'imagePrompt')
  final String imagePrompt; // This will be used as the caption
  
  @JsonKey(name: 'modelName')
  final String? modelName;
  
  @JsonKey(name: 'inputTokens')
  final int? inputTokens;
  
  @JsonKey(name: 'outputTokens')
  final int? outputTokens;

  const GenerationResponseModel({
    required this.story,
    required this.imagePrompt,
    this.modelName,
    this.inputTokens,
    this.outputTokens,
  });

  /// Creates a GenerationResponseModel from JSON
  factory GenerationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GenerationResponseModelFromJson(json);

  /// Converts the GenerationResponseModel to JSON
  Map<String, dynamic> toJson() => _$GenerationResponseModelToJson(this);

  /// Converts the model to a StoryEntity
  StoryEntity toStoryEntity() {
    return StoryEntity(
      content: story,
      modelName: modelName,
      inputTokens: inputTokens,
      outputTokens: outputTokens,
      generatedAt: DateTime.now(),
    );
  }

  /// Converts the model to a CaptionEntity using the imagePrompt field
  CaptionEntity toCaptionEntity() {
    return CaptionEntity(
      content: imagePrompt,
      modelName: modelName,
      inputTokens: inputTokens,
      outputTokens: outputTokens,
      generatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        story,
        imagePrompt,
        modelName,
        inputTokens,
        outputTokens,
      ];
} 