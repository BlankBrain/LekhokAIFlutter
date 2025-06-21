import 'package:json_annotation/json_annotation.dart';

enum EnhancementType {
  upscale,
  styleTransfer,
  colorCorrection,
  noiseReduction,
  sharpening,
  backgroundRemoval,
  objectRemoval,
  faceEnhancement;

  String get displayName {
    switch (this) {
      case EnhancementType.upscale:
        return 'AI Upscale';
      case EnhancementType.styleTransfer:
        return 'Style Transfer';
      case EnhancementType.colorCorrection:
        return 'Color Correction';
      case EnhancementType.noiseReduction:
        return 'Noise Reduction';
      case EnhancementType.sharpening:
        return 'Sharpening';
      case EnhancementType.backgroundRemoval:
        return 'Background Removal';
      case EnhancementType.objectRemoval:
        return 'Object Removal';
      case EnhancementType.faceEnhancement:
        return 'Face Enhancement';
    }
  }

  String get description {
    switch (this) {
      case EnhancementType.upscale:
        return 'Increase image resolution using AI';
      case EnhancementType.styleTransfer:
        return 'Apply artistic styles to your image';
      case EnhancementType.colorCorrection:
        return 'Adjust colors and brightness automatically';
      case EnhancementType.noiseReduction:
        return 'Remove noise and grain from images';
      case EnhancementType.sharpening:
        return 'Enhance image details and clarity';
      case EnhancementType.backgroundRemoval:
        return 'Remove or replace image background';
      case EnhancementType.objectRemoval:
        return 'Remove unwanted objects from image';
      case EnhancementType.faceEnhancement:
        return 'Enhance facial features and skin';
    }
  }

  String get icon {
    switch (this) {
      case EnhancementType.upscale:
        return '📏';
      case EnhancementType.styleTransfer:
        return '🎨';
      case EnhancementType.colorCorrection:
        return '🌈';
      case EnhancementType.noiseReduction:
        return '✨';
      case EnhancementType.sharpening:
        return '🔍';
      case EnhancementType.backgroundRemoval:
        return '🖼️';
      case EnhancementType.objectRemoval:
        return '🗑️';
      case EnhancementType.faceEnhancement:
        return '👤';
    }
  }
}

enum UpscaleFactors {
  x2(2, '2x (Double)'),
  x4(4, '4x (Quadruple)'),
  x8(8, '8x (Eight times)');

  const UpscaleFactors(this.factor, this.displayName);
  final int factor;
  final String displayName;
}

enum StyleTransferStyles {
  vanGogh('Van Gogh', 'Starry Night style painting'),
  picasso('Picasso', 'Cubist artistic style'),
  monet('Monet', 'Impressionist painting style'),
  davinci('Da Vinci', 'Renaissance master style'),
  anime('Anime', 'Japanese animation style'),
  oilPainting('Oil Painting', 'Classic oil painting style'),
  watercolor('Watercolor', 'Watercolor painting style'),
  pencilSketch('Pencil Sketch', 'Hand-drawn pencil sketch'),
  pop('Pop Art', 'Pop art style like Warhol'),
  abstract('Abstract', 'Abstract modern art style');

  const StyleTransferStyles(this.name, this.description);
  final String name;
  final String description;
}

class EnhancementRequest {
  final String id;
  final EnhancementType type;
  final String inputImageUrl;
  final Map<String, dynamic> parameters;
  final DateTime createdAt;

  const EnhancementRequest({
    required this.id,
    required this.type,
    required this.inputImageUrl,
    required this.parameters,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'input_image_url': inputImageUrl,
    'parameters': parameters,
    'created_at': createdAt.toIso8601String(),
  };

  factory EnhancementRequest.fromJson(Map<String, dynamic> json) {
    return EnhancementRequest(
      id: json['id'],
      type: EnhancementType.values.firstWhere((e) => e.name == json['type']),
      inputImageUrl: json['input_image_url'],
      parameters: Map<String, dynamic>.from(json['parameters']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  EnhancementRequest copyWith({
    String? id,
    EnhancementType? type,
    String? inputImageUrl,
    Map<String, dynamic>? parameters,
    DateTime? createdAt,
  }) {
    return EnhancementRequest(
      id: id ?? this.id,
      type: type ?? this.type,
      inputImageUrl: inputImageUrl ?? this.inputImageUrl,
      parameters: parameters ?? this.parameters,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class EnhancementResult {
  final String id;
  final String requestId;
  final String outputImageUrl;
  final EnhancementType type;
  final Map<String, dynamic> metadata;
  final DateTime completedAt;
  final bool isSuccess;
  final String? errorMessage;

  const EnhancementResult({
    required this.id,
    required this.requestId,
    required this.outputImageUrl,
    required this.type,
    required this.metadata,
    required this.completedAt,
    required this.isSuccess,
    this.errorMessage,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'request_id': requestId,
    'output_image_url': outputImageUrl,
    'type': type.name,
    'metadata': metadata,
    'completed_at': completedAt.toIso8601String(),
    'is_success': isSuccess,
    'error_message': errorMessage,
  };

  factory EnhancementResult.fromJson(Map<String, dynamic> json) {
    return EnhancementResult(
      id: json['id'],
      requestId: json['request_id'],
      outputImageUrl: json['output_image_url'],
      type: EnhancementType.values.firstWhere((e) => e.name == json['type']),
      metadata: Map<String, dynamic>.from(json['metadata']),
      completedAt: DateTime.parse(json['completed_at']),
      isSuccess: json['is_success'],
      errorMessage: json['error_message'],
    );
  }
}

class BatchEnhancementJob {
  final String id;
  final String name;
  final List<EnhancementRequest> requests;
  final EnhancementType type;
  final Map<String, dynamic> batchParameters;
  final DateTime createdAt;
  final DateTime? completedAt;
  final BatchJobStatus status;
  final int totalImages;
  final int processedImages;
  final int successfulImages;
  final int failedImages;

  const BatchEnhancementJob({
    required this.id,
    required this.name,
    required this.requests,
    required this.type,
    required this.batchParameters,
    required this.createdAt,
    this.completedAt,
    required this.status,
    required this.totalImages,
    required this.processedImages,
    required this.successfulImages,
    required this.failedImages,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'requests': requests.map((r) => r.toJson()).toList(),
    'type': type.name,
    'batch_parameters': batchParameters,
    'created_at': createdAt.toIso8601String(),
    'completed_at': completedAt?.toIso8601String(),
    'status': status.name,
    'total_images': totalImages,
    'processed_images': processedImages,
    'successful_images': successfulImages,
    'failed_images': failedImages,
  };

  factory BatchEnhancementJob.fromJson(Map<String, dynamic> json) {
    return BatchEnhancementJob(
      id: json['id'],
      name: json['name'],
      requests: (json['requests'] as List)
          .map((r) => EnhancementRequest.fromJson(r))
          .toList(),
      type: EnhancementType.values.firstWhere((e) => e.name == json['type']),
      batchParameters: Map<String, dynamic>.from(json['batch_parameters']),
      createdAt: DateTime.parse(json['created_at']),
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at'])
          : null,
      status: BatchJobStatus.values.firstWhere((s) => s.name == json['status']),
      totalImages: json['total_images'],
      processedImages: json['processed_images'],
      successfulImages: json['successful_images'],
      failedImages: json['failed_images'],
    );
  }

  BatchEnhancementJob copyWith({
    String? id,
    String? name,
    List<EnhancementRequest>? requests,
    EnhancementType? type,
    Map<String, dynamic>? batchParameters,
    DateTime? createdAt,
    DateTime? completedAt,
    BatchJobStatus? status,
    int? totalImages,
    int? processedImages,
    int? successfulImages,
    int? failedImages,
  }) {
    return BatchEnhancementJob(
      id: id ?? this.id,
      name: name ?? this.name,
      requests: requests ?? this.requests,
      type: type ?? this.type,
      batchParameters: batchParameters ?? this.batchParameters,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
      totalImages: totalImages ?? this.totalImages,
      processedImages: processedImages ?? this.processedImages,
      successfulImages: successfulImages ?? this.successfulImages,
      failedImages: failedImages ?? this.failedImages,
    );
  }

  double get progressPercentage {
    if (totalImages == 0) return 0.0;
    return (processedImages / totalImages) * 100;
  }

  bool get isCompleted => status == BatchJobStatus.completed;
  bool get isFailed => status == BatchJobStatus.failed;
  bool get isProcessing => status == BatchJobStatus.processing;
  bool get isPending => status == BatchJobStatus.pending;
}

enum BatchJobStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled;

  String get displayName {
    switch (this) {
      case BatchJobStatus.pending:
        return 'Pending';
      case BatchJobStatus.processing:
        return 'Processing';
      case BatchJobStatus.completed:
        return 'Completed';
      case BatchJobStatus.failed:
        return 'Failed';
      case BatchJobStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class ImageVariation {
  final String id;
  final String sourceImageUrl;
  final String variationImageUrl;
  final Map<String, dynamic> parameters;
  final double similarity;
  final DateTime createdAt;

  const ImageVariation({
    required this.id,
    required this.sourceImageUrl,
    required this.variationImageUrl,
    required this.parameters,
    required this.similarity,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'source_image_url': sourceImageUrl,
    'variation_image_url': variationImageUrl,
    'parameters': parameters,
    'similarity': similarity,
    'created_at': createdAt.toIso8601String(),
  };

  factory ImageVariation.fromJson(Map<String, dynamic> json) {
    return ImageVariation(
      id: json['id'],
      sourceImageUrl: json['source_image_url'],
      variationImageUrl: json['variation_image_url'],
      parameters: Map<String, dynamic>.from(json['parameters']),
      similarity: (json['similarity'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class EnhancementPreset {
  final String id;
  final String name;
  final String description;
  final EnhancementType type;
  final Map<String, dynamic> parameters;
  final bool isCustom;
  final String? thumbnailUrl;

  const EnhancementPreset({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.parameters,
    required this.isCustom,
    this.thumbnailUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'type': type.name,
    'parameters': parameters,
    'is_custom': isCustom,
    'thumbnail_url': thumbnailUrl,
  };

  factory EnhancementPreset.fromJson(Map<String, dynamic> json) {
    return EnhancementPreset(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: EnhancementType.values.firstWhere((e) => e.name == json['type']),
      parameters: Map<String, dynamic>.from(json['parameters']),
      isCustom: json['is_custom'],
      thumbnailUrl: json['thumbnail_url'],
    );
  }
}

/// Predefined enhancement presets
class EnhancementPresets {
  static const List<Map<String, dynamic>> upscalePresets = [
    {
      'id': 'upscale_2x_fast',
      'name': '2x Fast',
      'description': 'Quick 2x upscaling for preview',
      'type': EnhancementType.upscale,
      'parameters': {'factor': 2, 'quality': 'fast'},
    },
    {
      'id': 'upscale_4x_quality',
      'name': '4x High Quality',
      'description': 'Best quality 4x upscaling',
      'type': EnhancementType.upscale,
      'parameters': {'factor': 4, 'quality': 'high'},
    },
    {
      'id': 'upscale_8x_max',
      'name': '8x Maximum',
      'description': 'Maximum 8x upscaling',
      'type': EnhancementType.upscale,
      'parameters': {'factor': 8, 'quality': 'high'},
    },
  ];

  static const List<Map<String, dynamic>> styleTransferPresets = [
    {
      'id': 'style_van_gogh',
      'name': 'Van Gogh Style',
      'description': 'Transform into Van Gogh\'s painting style',
      'type': EnhancementType.styleTransfer,
      'parameters': {'style': 'van_gogh', 'strength': 0.8},
    },
    {
      'id': 'style_anime',
      'name': 'Anime Style',
      'description': 'Convert to anime art style',
      'type': EnhancementType.styleTransfer,
      'parameters': {'style': 'anime', 'strength': 0.9},
    },
    {
      'id': 'style_oil_painting',
      'name': 'Oil Painting',
      'description': 'Classic oil painting effect',
      'type': EnhancementType.styleTransfer,
      'parameters': {'style': 'oil_painting', 'strength': 0.7},
    },
  ];

  static const List<Map<String, dynamic>> colorCorrectionPresets = [
    {
      'id': 'color_auto',
      'name': 'Auto Enhance',
      'description': 'Automatic color and brightness adjustment',
      'type': EnhancementType.colorCorrection,
      'parameters': {'auto': true, 'brightness': 0, 'contrast': 0},
    },
    {
      'id': 'color_vivid',
      'name': 'Vivid Colors',
      'description': 'Boost saturation and vibrancy',
      'type': EnhancementType.colorCorrection,
      'parameters': {'saturation': 1.3, 'vibrancy': 1.2},
    },
    {
      'id': 'color_vintage',
      'name': 'Vintage Look',
      'description': 'Retro color grading',
      'type': EnhancementType.colorCorrection,
      'parameters': {'vintage': true, 'warmth': 1.2},
    },
  ];

  static List<EnhancementPreset> getAllPresets() {
    final allPresets = <EnhancementPreset>[];
    
    for (final preset in [...upscalePresets, ...styleTransferPresets, ...colorCorrectionPresets]) {
      allPresets.add(EnhancementPreset.fromJson(preset));
    }
    
    return allPresets;
  }

  static List<EnhancementPreset> getPresetsByType(EnhancementType type) {
    return getAllPresets().where((preset) => preset.type == type).toList();
  }
} 