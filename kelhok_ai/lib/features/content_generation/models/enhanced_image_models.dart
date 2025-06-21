import 'package:json_annotation/json_annotation.dart';

enum ImageStyle {
  photorealistic,
  digitalArt,
  oilPainting,
  watercolor,
  pencilSketch,
  anime,
  cartoon,
  fantasy,
  sciFi,
  cyberpunk,
  steampunk,
  minimalist,
  abstract,
  vintage,
  horror;

  String get displayName {
    switch (this) {
      case ImageStyle.photorealistic:
        return 'Photorealistic';
      case ImageStyle.digitalArt:
        return 'Digital Art';
      case ImageStyle.oilPainting:
        return 'Oil Painting';
      case ImageStyle.watercolor:
        return 'Watercolor';
      case ImageStyle.pencilSketch:
        return 'Pencil Sketch';
      case ImageStyle.anime:
        return 'Anime';
      case ImageStyle.cartoon:
        return 'Cartoon';
      case ImageStyle.fantasy:
        return 'Fantasy';
      case ImageStyle.sciFi:
        return 'Sci-Fi';
      case ImageStyle.cyberpunk:
        return 'Cyberpunk';
      case ImageStyle.steampunk:
        return 'Steampunk';
      case ImageStyle.minimalist:
        return 'Minimalist';
      case ImageStyle.abstract:
        return 'Abstract';
      case ImageStyle.vintage:
        return 'Vintage';
      case ImageStyle.horror:
        return 'Horror';
    }
  }

  String get description {
    switch (this) {
      case ImageStyle.photorealistic:
        return 'Highly detailed, realistic photography style';
      case ImageStyle.digitalArt:
        return 'Modern digital artwork with clean lines';
      case ImageStyle.oilPainting:
        return 'Classic oil painting with rich textures';
      case ImageStyle.watercolor:
        return 'Soft, flowing watercolor technique';
      case ImageStyle.pencilSketch:
        return 'Detailed pencil drawing style';
      case ImageStyle.anime:
        return 'Japanese animation art style';
      case ImageStyle.cartoon:
        return 'Playful cartoon illustration';
      case ImageStyle.fantasy:
        return 'Magical, otherworldly themes';
      case ImageStyle.sciFi:
        return 'Science fiction futuristic style';
      case ImageStyle.cyberpunk:
        return 'Futuristic high-tech dystopian style';
      case ImageStyle.steampunk:
        return 'Victorian-era industrial aesthetic';
      case ImageStyle.minimalist:
        return 'Clean, simple design approach';
      case ImageStyle.abstract:
        return 'Non-representational artistic expression';
      case ImageStyle.vintage:
        return 'Classic, aged aesthetic';
      case ImageStyle.horror:
        return 'Dark, scary atmospheric style';
    }
  }
}

enum ImageResolution {
  square512,
  square1024,
  portrait768x1024,
  landscape1024x768;

  String get displayName {
    switch (this) {
      case ImageResolution.square512:
        return '512×512 (Square)';
      case ImageResolution.square1024:
        return '1024×1024 (Square HD)';
      case ImageResolution.portrait768x1024:
        return '768×1024 (Portrait)';
      case ImageResolution.landscape1024x768:
        return '1024×768 (Landscape)';
    }
  }

  Map<String, int> get dimensions {
    switch (this) {
      case ImageResolution.square512:
        return {'width': 512, 'height': 512};
      case ImageResolution.square1024:
        return {'width': 1024, 'height': 1024};
      case ImageResolution.portrait768x1024:
        return {'width': 768, 'height': 1024};
      case ImageResolution.landscape1024x768:
        return {'width': 1024, 'height': 768};
    }
  }
}

class EnhancedImageRequest {
  final String prompt;
  final String? negativePrompt;
  final ImageStyle style;
  final ImageResolution resolution;
  final List<String> styleModifiers;
  final int? seed;
  final double guidanceScale;
  final int variationCount;

  const EnhancedImageRequest({
    required this.prompt,
    this.negativePrompt,
    required this.style,
    required this.resolution,
    this.styleModifiers = const [],
    this.seed,
    this.guidanceScale = 7.5,
    this.variationCount = 1,
  });

  Map<String, dynamic> toJson() => {
    'prompt': enhancedPrompt,
    'negative_prompt': negativePrompt,
    'style': style.name,
    'width': resolution.dimensions['width'],
    'height': resolution.dimensions['height'],
    'seed': seed,
    'guidance_scale': guidanceScale,
    'num_images': variationCount,
  };

  /// Get the complete prompt with style modifiers
  String get enhancedPrompt {
    final buffer = StringBuffer();
    buffer.write(prompt);
    
    // Add style-specific keywords
    buffer.write(', ${style.displayName.toLowerCase()} style');
    
    // Add style modifiers
    if (styleModifiers.isNotEmpty) {
      buffer.write(', ${styleModifiers.join(', ')}');
    }
    
    return buffer.toString();
  }
}

class EnhancedImageResponse {
  final String id;
  final List<String> imageUrls;
  final EnhancedImageRequest request;
  final DateTime createdAt;
  final int generationTimeMs;
  final String? error;

  const EnhancedImageResponse({
    required this.id,
    required this.imageUrls,
    required this.request,
    required this.createdAt,
    required this.generationTimeMs,
    this.error,
  });

  factory EnhancedImageResponse.fromJson(Map<String, dynamic> json) {
    return EnhancedImageResponse(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      imageUrls: List<String>.from(json['images'] ?? []),
      request: EnhancedImageRequest(
        prompt: json['prompt'] ?? '',
        style: ImageStyle.digitalArt,
        resolution: ImageResolution.square1024,
      ),
      createdAt: DateTime.now(),
      generationTimeMs: json['generation_time_ms'] ?? 3000,
      error: json['error'],
    );
  }

  bool get isSuccess => error == null && imageUrls.isNotEmpty;
}

/// Style presets for quick selection
class ImageStylePresets {
  static const List<Map<String, dynamic>> presets = [
    {
      'name': 'Professional Photo',
      'style': ImageStyle.photorealistic,
      'modifiers': ['professional lighting', 'high resolution', 'sharp focus'],
      'negativePrompt': 'blurry, low quality, amateur',
    },
    {
      'name': 'Fantasy Art',
      'style': ImageStyle.fantasy,
      'modifiers': ['magical', 'ethereal', 'mystical atmosphere'],
      'negativePrompt': 'modern, realistic, mundane',
    },
    {
      'name': 'Anime Character',
      'style': ImageStyle.anime,
      'modifiers': ['detailed eyes', 'vibrant colors', 'cel shading'],
      'negativePrompt': 'realistic, western cartoon, 3d render',
    },
    {
      'name': 'Oil Painting',
      'style': ImageStyle.oilPainting,
      'modifiers': ['brush strokes', 'canvas texture', 'classical composition'],
      'negativePrompt': 'digital, smooth, modern',
    },
    {
      'name': 'Cyberpunk Scene',
      'style': ImageStyle.cyberpunk,
      'modifiers': ['neon lights', 'futuristic', 'dark atmosphere', 'rain'],
      'negativePrompt': 'bright, natural, historical',
    },
    {
      'name': 'Minimalist Design',
      'style': ImageStyle.minimalist,
      'modifiers': ['clean lines', 'simple shapes', 'negative space'],
      'negativePrompt': 'cluttered, complex, detailed',
    },
  ];

  static Map<String, dynamic>? getPreset(String name) {
    try {
      return presets.firstWhere((preset) => preset['name'] == name);
    } catch (e) {
      return null;
    }
  }

  static List<String> get presetNames => presets.map((p) => p['name'] as String).toList();
}