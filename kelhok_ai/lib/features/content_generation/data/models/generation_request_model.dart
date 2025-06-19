import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'generation_request_model.g.dart';

/// Data model for generation request to the API
@JsonSerializable()
class GenerationRequestModel extends Equatable {
  @JsonKey(name: 'storyIdea')
  final String storyIdea;
  
  @JsonKey(name: 'character')
  final String? character;

  const GenerationRequestModel({
    required this.storyIdea,
    this.character,
  });

  /// Creates a GenerationRequestModel from JSON
  factory GenerationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GenerationRequestModelFromJson(json);

  /// Converts the GenerationRequestModel to JSON
  Map<String, dynamic> toJson() => _$GenerationRequestModelToJson(this);

  @override
  List<Object?> get props => [storyIdea, character];
} 