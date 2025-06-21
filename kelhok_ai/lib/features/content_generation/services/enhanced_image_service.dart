import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../models/enhanced_image_models.dart';

class EnhancedImageService {
  final Dio _dio;

  EnhancedImageService({Dio? dio}) : _dio = dio ?? Dio();

  /// Generate images with enhanced styling options
  Future<EnhancedImageResponse> generateEnhancedImage(EnhancedImageRequest request) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.generateImage}/enhanced',
        data: request.toJson(),
      );

      return EnhancedImageResponse.fromJson(response.data);
    } catch (e) {
      // Return mock enhanced image generation for development
      return _generateMockEnhancedImage(request);
    }
  }

  /// Generate multiple style variations of the same prompt
  Future<List<EnhancedImageResponse>> generateStyleVariations({
    required String prompt,
    required List<ImageStyle> styles,
    ImageResolution resolution = ImageResolution.square1024,
  }) async {
    final futures = styles.map((style) {
      final request = EnhancedImageRequest(
        prompt: prompt,
        style: style,
        resolution: resolution,
        styleModifiers: _getStyleModifiers(style),
      );
      return generateEnhancedImage(request);
    }).toList();

    return Future.wait(futures);
  }

  /// Get style recommendations based on prompt analysis
  Future<List<ImageStyle>> getStyleRecommendations(String prompt) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.generateImage}/style-recommendations',
        data: {'prompt': prompt},
      );

      final styleNames = List<String>.from(response.data['recommended_styles']);
      return styleNames.map((name) => 
        ImageStyle.values.firstWhere((style) => style.name == name)
      ).toList();
    } catch (e) {
      // Return mock style recommendations based on prompt analysis
      return _analyzeMockStyleRecommendations(prompt);
    }
  }

  /// Apply style transfer to an existing image
  Future<EnhancedImageResponse> applyStyleTransfer({
    required String sourceImageUrl,
    required ImageStyle targetStyle,
    double strength = 0.75,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.generateImage}/style-transfer',
        data: {
          'source_image': sourceImageUrl,
          'target_style': targetStyle.name,
          'strength': strength,
        },
      );

      return EnhancedImageResponse.fromJson(response.data);
    } catch (e) {
      // Return mock style transfer result
      return _generateMockStyleTransfer(sourceImageUrl, targetStyle);
    }
  }

  /// Enhance image quality using AI upscaling
  Future<EnhancedImageResponse> enhanceImageQuality({
    required String imageUrl,
    int scaleFactor = 2,
    bool enhanceDetails = true,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.generateImage}/enhance',
        data: {
          'image_url': imageUrl,
          'scale_factor': scaleFactor,
          'enhance_details': enhanceDetails,
        },
      );

      return EnhancedImageResponse.fromJson(response.data);
    } catch (e) {
      // Return mock enhancement result
      return _generateMockEnhancement(imageUrl, scaleFactor);
    }
  }

  /// Generate image variations from a seed image
  Future<List<EnhancedImageResponse>> generateImageVariations({
    required String seedImageUrl,
    required String prompt,
    int variationCount = 4,
    double strength = 0.6,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.generateImage}/variations',
        data: {
          'seed_image': seedImageUrl,
          'prompt': prompt,
          'variation_count': variationCount,
          'strength': strength,
        },
      );

      final variations = List<Map<String, dynamic>>.from(response.data['variations']);
      return variations.map((variation) => EnhancedImageResponse.fromJson(variation)).toList();
    } catch (e) {
      // Return mock variations
      return _generateMockVariations(seedImageUrl, prompt, variationCount);
    }
  }

  /// Get available style categories
  List<String> getStyleCategories() {
    final categories = <String>{};
    for (final style in ImageStyle.values) {
      categories.add(_getStyleCategory(style));
    }
    return categories.toList()..sort();
  }

  /// Get styles by category
  List<ImageStyle> getStylesByCategory(String category) {
    return ImageStyle.values.where((style) => _getStyleCategory(style) == category).toList();
  }

  /// Get popular style combinations
  Map<String, List<ImageStyle>> getPopularStyleCombinations() {
    return {
      'Realistic Fantasy': [ImageStyle.photorealistic, ImageStyle.fantasy],
      'Anime Cyberpunk': [ImageStyle.anime, ImageStyle.cyberpunk],
      'Vintage Horror': [ImageStyle.vintage, ImageStyle.horror],
      'Digital Minimalism': [ImageStyle.digitalArt, ImageStyle.minimalist],
      'Abstract Art': [ImageStyle.abstract, ImageStyle.watercolor],
    };
  }

  // Helper methods for mock data generation

  EnhancedImageResponse _generateMockEnhancedImage(EnhancedImageRequest request) {
    final mockImageUrls = List.generate(request.variationCount, (index) => 
      'https://picsum.photos/seed/${request.prompt.hashCode + index}/${request.resolution.dimensions['width']}/${request.resolution.dimensions['height']}'
    );

    return EnhancedImageResponse(
      id: 'enhanced_${DateTime.now().millisecondsSinceEpoch}',
      imageUrls: mockImageUrls,
      request: request,
      createdAt: DateTime.now(),
      generationTimeMs: 3000 + (request.variationCount * 500),
    );
  }

  List<String> _getStyleModifiers(ImageStyle style) {
    switch (style) {
      case ImageStyle.photorealistic:
        return ['professional lighting', 'high resolution', 'sharp focus'];
      case ImageStyle.digitalArt:
        return ['clean lines', 'vibrant colors', 'digital painting'];
      case ImageStyle.oilPainting:
        return ['brush strokes', 'canvas texture', 'classical composition'];
      case ImageStyle.watercolor:
        return ['soft edges', 'flowing colors', 'paper texture'];
      case ImageStyle.pencilSketch:
        return ['graphite texture', 'detailed shading', 'artistic sketch'];
      case ImageStyle.anime:
        return ['detailed eyes', 'vibrant colors', 'cel shading'];
      case ImageStyle.cartoon:
        return ['bold outlines', 'bright colors', 'simplified forms'];
      case ImageStyle.fantasy:
        return ['magical', 'ethereal', 'mystical atmosphere'];
      case ImageStyle.sciFi:
        return ['futuristic', 'technological', 'space age'];
      case ImageStyle.cyberpunk:
        return ['neon lights', 'dark atmosphere', 'futuristic cityscape'];
      case ImageStyle.steampunk:
        return ['brass gears', 'Victorian era', 'steam powered'];
      case ImageStyle.minimalist:
        return ['clean lines', 'simple shapes', 'negative space'];
      case ImageStyle.abstract:
        return ['geometric shapes', 'bold colors', 'non-representational'];
      case ImageStyle.vintage:
        return ['aged texture', 'sepia tones', 'retro aesthetic'];
      case ImageStyle.horror:
        return ['dark atmosphere', 'eerie lighting', 'scary elements'];
    }
  }

  String _getStyleCategory(ImageStyle style) {
    switch (style) {
      case ImageStyle.photorealistic:
        return 'Realistic';
      case ImageStyle.digitalArt:
      case ImageStyle.minimalist:
      case ImageStyle.abstract:
        return 'Digital';
      case ImageStyle.oilPainting:
      case ImageStyle.watercolor:
      case ImageStyle.pencilSketch:
        return 'Traditional';
      case ImageStyle.anime:
      case ImageStyle.cartoon:
        return 'Illustrated';
      case ImageStyle.fantasy:
      case ImageStyle.horror:
        return 'Fantastical';
      case ImageStyle.sciFi:
      case ImageStyle.cyberpunk:
      case ImageStyle.steampunk:
        return 'Futuristic';
      case ImageStyle.vintage:
        return 'Historical';
    }
  }

  List<ImageStyle> _analyzeMockStyleRecommendations(String prompt) {
    final lowercasePrompt = prompt.toLowerCase();
    final recommendations = <ImageStyle>[];

    // Analyze prompt for style keywords
    if (lowercasePrompt.contains('photo') || lowercasePrompt.contains('realistic')) {
      recommendations.add(ImageStyle.photorealistic);
    }
    if (lowercasePrompt.contains('anime') || lowercasePrompt.contains('manga')) {
      recommendations.add(ImageStyle.anime);
    }
    if (lowercasePrompt.contains('fantasy') || lowercasePrompt.contains('magic')) {
      recommendations.add(ImageStyle.fantasy);
    }
    if (lowercasePrompt.contains('cyberpunk') || lowercasePrompt.contains('neon')) {
      recommendations.add(ImageStyle.cyberpunk);
    }
    if (lowercasePrompt.contains('painting') || lowercasePrompt.contains('art')) {
      recommendations.add(ImageStyle.oilPainting);
    }
    if (lowercasePrompt.contains('cartoon') || lowercasePrompt.contains('character')) {
      recommendations.add(ImageStyle.cartoon);
    }

    // Add default recommendations if none found
    if (recommendations.isEmpty) {
      recommendations.addAll([
        ImageStyle.digitalArt,
        ImageStyle.fantasy,
        ImageStyle.photorealistic,
      ]);
    }

    return recommendations.take(3).toList();
  }

  EnhancedImageResponse _generateMockStyleTransfer(String sourceImageUrl, ImageStyle targetStyle) {
    return EnhancedImageResponse(
      id: 'style_transfer_${DateTime.now().millisecondsSinceEpoch}',
      imageUrls: ['https://picsum.photos/seed/${targetStyle.hashCode}/1024/1024'],
      request: EnhancedImageRequest(
        prompt: 'Style transfer to ${targetStyle.displayName}',
        style: targetStyle,
        resolution: ImageResolution.square1024,
      ),
      createdAt: DateTime.now(),
      generationTimeMs: 5000,
    );
  }

  EnhancedImageResponse _generateMockEnhancement(String imageUrl, int scaleFactor) {
    return EnhancedImageResponse(
      id: 'enhancement_${DateTime.now().millisecondsSinceEpoch}',
      imageUrls: ['https://picsum.photos/seed/${imageUrl.hashCode}/${1024 * scaleFactor}/${1024 * scaleFactor}'],
      request: EnhancedImageRequest(
        prompt: 'Enhanced image ${scaleFactor}x',
        style: ImageStyle.digitalArt,
        resolution: ImageResolution.square1024,
      ),
      createdAt: DateTime.now(),
      generationTimeMs: 4000,
    );
  }

  List<EnhancedImageResponse> _generateMockVariations(String seedImageUrl, String prompt, int count) {
    return List.generate(count, (index) => EnhancedImageResponse(
      id: 'variation_${DateTime.now().millisecondsSinceEpoch}_$index',
      imageUrls: ['https://picsum.photos/seed/${prompt.hashCode + index}/1024/1024'],
      request: EnhancedImageRequest(
        prompt: '$prompt (variation ${index + 1})',
        style: ImageStyle.digitalArt,
        resolution: ImageResolution.square1024,
      ),
      createdAt: DateTime.now(),
      generationTimeMs: 3500,
    ));
  }
} 