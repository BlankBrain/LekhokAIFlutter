import 'package:equatable/equatable.dart';

/// Story entity representing a generated story
class StoryEntity extends Equatable {
  final String content;
  final String? modelName;
  final int? inputTokens;
  final int? outputTokens;
  final DateTime generatedAt;

  const StoryEntity({
    required this.content,
    this.modelName,
    this.inputTokens,
    this.outputTokens,
    required this.generatedAt,
  });

  @override
  List<Object?> get props => [
        content,
        modelName,
        inputTokens,
        outputTokens,
        generatedAt,
      ];
} 