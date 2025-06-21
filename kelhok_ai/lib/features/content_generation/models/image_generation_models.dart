// Image generation models for KarigorAI mobile app

class ImageGenerationRequest {
  final String prompt;
  final String style;
  final String? characterId;
  final int width;
  final int height;
  final int steps;
  final double guidanceScale;
  final int? seed;
  final Map<String, dynamic>? additionalParams;

  const ImageGenerationRequest({
    required this.prompt,
    this.style = 'realistic',
    this.characterId,
    this.width = 512,
    this.height = 512,
    this.steps = 20,
    this.guidanceScale = 7.5,
    this.seed,
    this.additionalParams,
  });

  Map<String, dynamic> toJson() {
    return {
      'prompt': prompt,
      'style': style,
      if (characterId != null) 'character_id': characterId,
      'width': width,
      'height': height,
      'steps': steps,
      'guidance_scale': guidanceScale,
      if (seed != null) 'seed': seed,
      if (additionalParams != null) ...additionalParams!,
    };
  }

  factory ImageGenerationRequest.fromJson(Map<String, dynamic> json) {
    return ImageGenerationRequest(
      prompt: json['prompt'] as String,
      style: json['style'] as String? ?? 'realistic',
      characterId: json['character_id'] as String?,
      width: json['width'] as int? ?? 512,
      height: json['height'] as int? ?? 512,
      steps: json['steps'] as int? ?? 20,
      guidanceScale: (json['guidance_scale'] as num?)?.toDouble() ?? 7.5,
      seed: json['seed'] as int?,
      additionalParams: json['additional_params'] as Map<String, dynamic>?,
    );
  }
}

class ImageGenerationResponse {
  final String id;
  final String imageUrl;
  final String? thumbnailUrl;
  final String prompt;
  final String style;
  final String? characterId;
  final DateTime createdAt;
  final GenerationStatus status;
  final Map<String, dynamic>? metadata;

  const ImageGenerationResponse({
    required this.id,
    required this.imageUrl,
    this.thumbnailUrl,
    required this.prompt,
    required this.style,
    this.characterId,
    required this.createdAt,
    this.status = GenerationStatus.completed,
    this.metadata,
  });

  factory ImageGenerationResponse.fromJson(Map<String, dynamic> json) {
    return ImageGenerationResponse(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      prompt: json['prompt'] as String,
      style: json['style'] as String,
      characterId: json['character_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: GenerationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => GenerationStatus.completed,
      ),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      'prompt': prompt,
      'style': style,
      if (characterId != null) 'character_id': characterId,
      'created_at': createdAt.toIso8601String(),
      'status': status.name,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

class ImageStyle {
  final String id;
  final String name;
  final String description;
  final String? previewUrl;
  final bool isPremium;
  final List<String>? tags;

  const ImageStyle({
    required this.id,
    required this.name,
    required this.description,
    this.previewUrl,
    this.isPremium = false,
    this.tags,
  });

  factory ImageStyle.fromJson(Map<String, dynamic> json) {
    return ImageStyle(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      previewUrl: json['preview_url'] as String?,
      isPremium: json['is_premium'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      if (previewUrl != null) 'preview_url': previewUrl,
      'is_premium': isPremium,
      if (tags != null) 'tags': tags,
    };
  }
}

class GeneratedImage {
  final String id;
  final String imageUrl;
  final String? thumbnailUrl;
  final String prompt;
  final String style;
  final String? characterId;
  final String? storyId;
  final DateTime createdAt;
  final bool isFavorite;
  final Map<String, dynamic>? metadata;

  const GeneratedImage({
    required this.id,
    required this.imageUrl,
    this.thumbnailUrl,
    required this.prompt,
    required this.style,
    this.characterId,
    this.storyId,
    required this.createdAt,
    this.isFavorite = false,
    this.metadata,
  });

  factory GeneratedImage.fromJson(Map<String, dynamic> json) {
    return GeneratedImage(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      prompt: json['prompt'] as String,
      style: json['style'] as String,
      characterId: json['character_id'] as String?,
      storyId: json['story_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      isFavorite: json['is_favorite'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      'prompt': prompt,
      'style': style,
      if (characterId != null) 'character_id': characterId,
      if (storyId != null) 'story_id': storyId,
      'created_at': createdAt.toIso8601String(),
      'is_favorite': isFavorite,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

class ImageGenerationStatus {
  final String jobId;
  final GenerationStatus status;
  final double? progress;
  final String? message;
  final String? imageUrl;
  final String? errorMessage;
  final DateTime? completedAt;

  const ImageGenerationStatus({
    required this.jobId,
    required this.status,
    this.progress,
    this.message,
    this.imageUrl,
    this.errorMessage,
    this.completedAt,
  });

  factory ImageGenerationStatus.fromJson(Map<String, dynamic> json) {
    return ImageGenerationStatus(
      jobId: json['job_id'] as String,
      status: GenerationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => GenerationStatus.pending,
      ),
      progress: (json['progress'] as num?)?.toDouble(),
      message: json['message'] as String?,
      imageUrl: json['image_url'] as String?,
      errorMessage: json['error_message'] as String?,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job_id': jobId,
      'status': status.name,
      if (progress != null) 'progress': progress,
      if (message != null) 'message': message,
      if (imageUrl != null) 'image_url': imageUrl,
      if (errorMessage != null) 'error_message': errorMessage,
      if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
    };
  }
}

enum GenerationStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
}

class ImageGenerationException implements Exception {
  final String message;
  final String code;
  final dynamic details;

  const ImageGenerationException({
    required this.message,
    required this.code,
    this.details,
  });

  @override
  String toString() => 'ImageGenerationException: $message (Code: $code)';
} 