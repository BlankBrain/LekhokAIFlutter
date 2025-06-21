/// Request model for caption generation
class CaptionGenerationRequest {
  final String? imageUrl;
  final String? imageBase64;
  final String? context;
  final String tone;
  final String style;
  final int maxLength;
  final List<String> keywords;
  final String? storyId;

  const CaptionGenerationRequest({
    this.imageUrl,
    this.imageBase64,
    this.context,
    this.tone = 'casual',
    this.style = 'descriptive',
    this.maxLength = 100,
    this.keywords = const [],
    this.storyId,
  });

  Map<String, dynamic> toJson() {
    return {
      if (imageUrl != null) 'image_url': imageUrl,
      if (imageBase64 != null) 'image_base64': imageBase64,
      if (context != null) 'context': context,
      'tone': tone,
      'style': style,
      'max_length': maxLength,
      'keywords': keywords,
      if (storyId != null) 'story_id': storyId,
    };
  }

  CaptionGenerationRequest copyWith({
    String? imageUrl,
    String? imageBase64,
    String? context,
    String? tone,
    String? style,
    int? maxLength,
    List<String>? keywords,
    String? storyId,
  }) {
    return CaptionGenerationRequest(
      imageUrl: imageUrl ?? this.imageUrl,
      imageBase64: imageBase64 ?? this.imageBase64,
      context: context ?? this.context,
      tone: tone ?? this.tone,
      style: style ?? this.style,
      maxLength: maxLength ?? this.maxLength,
      keywords: keywords ?? this.keywords,
      storyId: storyId ?? this.storyId,
    );
  }
}

/// Response model for caption generation
class CaptionGenerationResponse {
  final bool success;
  final String? message;
  final GeneratedCaption? caption;
  final String? error;

  const CaptionGenerationResponse({
    required this.success,
    this.message,
    this.caption,
    this.error,
  });

  factory CaptionGenerationResponse.fromJson(Map<String, dynamic> json) {
    return CaptionGenerationResponse(
      success: json['success'] ?? false,
      message: json['message'],
      caption: json['caption'] != null
          ? GeneratedCaption.fromJson(json['caption'])
          : null,
      error: json['error'],
    );
  }
}

/// Model for a generated caption
class GeneratedCaption {
  final String id;
  final String text;
  final String tone;
  final String style;
  final List<String> keywords;
  final String? imageUrl;
  final String? storyId;
  final DateTime createdAt;
  final double? confidence;
  final List<String> alternativeTexts;

  const GeneratedCaption({
    required this.id,
    required this.text,
    required this.tone,
    required this.style,
    required this.keywords,
    this.imageUrl,
    this.storyId,
    required this.createdAt,
    this.confidence,
    this.alternativeTexts = const [],
  });

  factory GeneratedCaption.fromJson(Map<String, dynamic> json) {
    return GeneratedCaption(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      tone: json['tone'] ?? 'casual',
      style: json['style'] ?? 'descriptive',
      keywords: List<String>.from(json['keywords'] ?? []),
      imageUrl: json['image_url'],
      storyId: json['story_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      confidence: json['confidence']?.toDouble(),
      alternativeTexts: List<String>.from(json['alternative_texts'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'tone': tone,
      'style': style,
      'keywords': keywords,
      if (imageUrl != null) 'image_url': imageUrl,
      if (storyId != null) 'story_id': storyId,
      'created_at': createdAt.toIso8601String(),
      if (confidence != null) 'confidence': confidence,
      'alternative_texts': alternativeTexts,
    };
  }

  GeneratedCaption copyWith({
    String? id,
    String? text,
    String? tone,
    String? style,
    List<String>? keywords,
    String? imageUrl,
    String? storyId,
    DateTime? createdAt,
    double? confidence,
    List<String>? alternativeTexts,
  }) {
    return GeneratedCaption(
      id: id ?? this.id,
      text: text ?? this.text,
      tone: tone ?? this.tone,
      style: style ?? this.style,
      keywords: keywords ?? this.keywords,
      imageUrl: imageUrl ?? this.imageUrl,
      storyId: storyId ?? this.storyId,
      createdAt: createdAt ?? this.createdAt,
      confidence: confidence ?? this.confidence,
      alternativeTexts: alternativeTexts ?? this.alternativeTexts,
    );
  }
}

/// Caption tone options
enum CaptionTone {
  casual('casual', 'Casual', 'Friendly and conversational'),
  professional('professional', 'Professional', 'Formal and business-like'),
  playful('playful', 'Playful', 'Fun and lighthearted'),
  dramatic('dramatic', 'Dramatic', 'Intense and emotional'),
  inspirational('inspirational', 'Inspirational', 'Motivating and uplifting'),
  mysterious('mysterious', 'Mysterious', 'Intriguing and enigmatic');

  const CaptionTone(this.id, this.name, this.description);
  final String id;
  final String name;
  final String description;
}

/// Caption style options
enum CaptionStyle {
  descriptive('descriptive', 'Descriptive', 'Detailed description of the image'),
  narrative('narrative', 'Narrative', 'Story-telling approach'),
  poetic('poetic', 'Poetic', 'Artistic and lyrical'),
  humorous('humorous', 'Humorous', 'Funny and entertaining'),
  technical('technical', 'Technical', 'Precise and informative'),
  emotional('emotional', 'Emotional', 'Focused on feelings and mood');

  const CaptionStyle(this.id, this.name, this.description);
  final String id;
  final String name;
  final String description;
}

/// Caption generation progress state
class CaptionGenerationProgress {
  final String stage;
  final double progress;
  final String message;

  const CaptionGenerationProgress({
    required this.stage,
    required this.progress,
    required this.message,
  });
}

/// Caption generation error
class CaptionGenerationError {
  final String code;
  final String message;
  final String? details;

  const CaptionGenerationError({
    required this.code,
    required this.message,
    this.details,
  });
} 