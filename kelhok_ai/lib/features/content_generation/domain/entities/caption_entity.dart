import 'package:equatable/equatable.dart';

/// Caption entity representing a generated caption
class CaptionEntity extends Equatable {
  final String content;
  final String? modelName;
  final int? inputTokens;
  final int? outputTokens;
  final DateTime generatedAt;

  const CaptionEntity({
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