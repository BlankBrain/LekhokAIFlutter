import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/api/api_client.dart';
import '../models/caption_generation_models.dart';

class CaptionGenerationService {
  final ApiClient _apiClient;

  CaptionGenerationService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Generate caption from image URL
  Future<CaptionGenerationResponse> generateCaptionFromUrl({
    required String imageUrl,
    String? context,
    String tone = 'casual',
    String style = 'descriptive',
    int maxLength = 100,
    List<String> keywords = const [],
    String? storyId,
    Function(CaptionGenerationProgress)? onProgress,
  }) async {
    try {
      final request = CaptionGenerationRequest(
        imageUrl: imageUrl,
        context: context,
        tone: tone,
        style: style,
        maxLength: maxLength,
        keywords: keywords,
        storyId: storyId,
      );

      return await _generateCaption(request, onProgress);
    } catch (e) {
      return CaptionGenerationResponse(
        success: false,
        error: 'Failed to generate caption: $e',
      );
    }
  }

  /// Generate caption from image file
  Future<CaptionGenerationResponse> generateCaptionFromFile({
    required File imageFile,
    String? context,
    String tone = 'casual',
    String style = 'descriptive',
    int maxLength = 100,
    List<String> keywords = const [],
    String? storyId,
    Function(CaptionGenerationProgress)? onProgress,
  }) async {
    try {
      // Convert image to base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final request = CaptionGenerationRequest(
        imageBase64: base64Image,
        context: context,
        tone: tone,
        style: style,
        maxLength: maxLength,
        keywords: keywords,
        storyId: storyId,
      );

      return await _generateCaption(request, onProgress);
    } catch (e) {
      return CaptionGenerationResponse(
        success: false,
        error: 'Failed to process image file: $e',
      );
    }
  }

  /// Generate caption from image bytes
  Future<CaptionGenerationResponse> generateCaptionFromBytes({
    required Uint8List imageBytes,
    String? context,
    String tone = 'casual',
    String style = 'descriptive',
    int maxLength = 100,
    List<String> keywords = const [],
    String? storyId,
    Function(CaptionGenerationProgress)? onProgress,
  }) async {
    try {
      final base64Image = base64Encode(imageBytes);

      final request = CaptionGenerationRequest(
        imageBase64: base64Image,
        context: context,
        tone: tone,
        style: style,
        maxLength: maxLength,
        keywords: keywords,
        storyId: storyId,
      );

      return await _generateCaption(request, onProgress);
    } catch (e) {
      return CaptionGenerationResponse(
        success: false,
        error: 'Failed to process image bytes: $e',
      );
    }
  }

  /// Internal method to handle caption generation
  Future<CaptionGenerationResponse> _generateCaption(
    CaptionGenerationRequest request,
    Function(CaptionGenerationProgress)? onProgress,
  ) async {
    try {
      // Report initial progress
      onProgress?.call(const CaptionGenerationProgress(
        stage: 'initializing',
        progress: 0.0,
        message: 'Preparing image for analysis...',
      ));

      // Simulate image processing stages
      await Future.delayed(const Duration(milliseconds: 500));
      onProgress?.call(const CaptionGenerationProgress(
        stage: 'processing',
        progress: 0.3,
        message: 'Analyzing image content...',
      ));

      await Future.delayed(const Duration(milliseconds: 800));
      onProgress?.call(const CaptionGenerationProgress(
        stage: 'generating',
        progress: 0.7,
        message: 'Generating caption...',
      ));

      // Make API call
      final response = await _apiClient.post(
        ApiEndpoints.generateCaption,
        data: request.toJson(),
      );

      await Future.delayed(const Duration(milliseconds: 300));
      onProgress?.call(const CaptionGenerationProgress(
        stage: 'finalizing',
        progress: 1.0,
        message: 'Caption generated successfully!',
      ));

      // For now, simulate a successful response
      // In real implementation, this would parse the actual API response
      debugPrint('API Response: ${response.statusCode}');
      final mockCaption = GeneratedCaption(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: _generateMockCaption(request.tone, request.style),
        tone: request.tone,
        style: request.style,
        keywords: request.keywords,
        imageUrl: request.imageUrl,
        storyId: request.storyId,
        createdAt: DateTime.now(),
        confidence: 0.85 + (DateTime.now().millisecond % 15) / 100,
        alternativeTexts: _generateAlternativeCaptions(request.tone, request.style),
      );

      return CaptionGenerationResponse(
        success: true,
        message: 'Caption generated successfully',
        caption: mockCaption,
      );
    } on DioException catch (e) {
      return CaptionGenerationResponse(
        success: false,
        error: _handleDioError(e),
      );
    } catch (e) {
      return CaptionGenerationResponse(
        success: false,
        error: 'Unexpected error: $e',
      );
    }
  }

  /// Get caption history for a user
  Future<List<GeneratedCaption>> getCaptionHistory({
    int page = 1,
    int limit = 20,
    String? storyId,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        if (storyId != null) 'story_id': storyId,
      };

      final response = await _apiClient.get(
        ApiEndpoints.captionHistory,
        queryParameters: queryParams,
      );

      // For now, return mock data
      // In real implementation, parse response.data
      debugPrint('History API Response: ${response.statusCode}');
      return _generateMockHistory(limit);
    } catch (e) {
      debugPrint('Error fetching caption history: $e');
      return [];
    }
  }

  /// Delete a caption
  Future<bool> deleteCaption(String captionId) async {
    try {
      await _apiClient.delete('${ApiEndpoints.captionHistory}/$captionId');
      return true;
    } catch (e) {
      debugPrint('Error deleting caption: $e');
      return false;
    }
  }

  /// Save caption to favorites
  Future<bool> saveCaptionToFavorites(String captionId) async {
    try {
      await _apiClient.post('${ApiEndpoints.captionHistory}/$captionId/favorite');
      return true;
    } catch (e) {
      debugPrint('Error saving caption to favorites: $e');
      return false;
    }
  }

  /// Generate mock caption based on tone and style
  String _generateMockCaption(String tone, String style) {
    final captions = {
      'casual_descriptive': [
        'A beautiful moment captured in perfect lighting, showcasing the natural beauty of the scene.',
        'This image perfectly captures the essence of the moment with stunning detail and composition.',
        'What a gorgeous shot! The colors and lighting really make this image stand out.',
      ],
      'professional_descriptive': [
        'Professional photography demonstrating exceptional composition and technical excellence.',
        'This image exhibits superior photographic technique with optimal exposure and framing.',
        'A professionally executed photograph showcasing advanced compositional elements.',
      ],
      'playful_narrative': [
        'Once upon a time, in a world full of wonder, this magical moment was captured forever!',
        'Here begins an adventure filled with joy, laughter, and unforgettable memories!',
        'This is where the story gets interesting - can you guess what happens next?',
      ],
      'dramatic_poetic': [
        'In shadows and light, a story unfolds, whispered by the winds of time.',
        'Where silence speaks louder than words, and beauty transcends the ordinary.',
        'A moment suspended between heartbeats, eternal and ephemeral.',
      ],
      'inspirational_emotional': [
        'Every ending is a new beginning, every sunset promises a new dawn.',
        'In this moment, we find the strength to believe in infinite possibilities.',
        'Sometimes the most beautiful journeys begin with a single step forward.',
      ],
    };

    final key = '${tone}_$style';
    final captionList = captions[key] ?? captions['casual_descriptive']!;
    return captionList[DateTime.now().millisecond % captionList.length];
  }

  /// Generate alternative captions
  List<String> _generateAlternativeCaptions(String tone, String style) {
    return [
      _generateMockCaption(tone, style),
      _generateMockCaption(tone, style),
      _generateMockCaption(tone, style),
    ];
  }

  /// Generate mock caption history
  List<GeneratedCaption> _generateMockHistory(int count) {
    return List.generate(count, (index) {
      final tones = ['casual', 'professional', 'playful', 'dramatic'];
      final styles = ['descriptive', 'narrative', 'poetic', 'emotional'];
      final tone = tones[index % tones.length];
      final style = styles[index % styles.length];
      
      return GeneratedCaption(
        id: 'mock_${DateTime.now().millisecondsSinceEpoch + index}',
        text: _generateMockCaption(tone, style),
        tone: tone,
        style: style,
        keywords: ['mock', 'caption', tone, style],
        createdAt: DateTime.now().subtract(Duration(days: index)),
        confidence: 0.8 + (index % 20) / 100,
        alternativeTexts: _generateAlternativeCaptions(tone, style),
      );
    });
  }

  /// Handle Dio errors
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server response timeout. Please try again.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return 'Authentication failed. Please login again.';
        } else if (statusCode == 429) {
          return 'Too many requests. Please wait before trying again.';
        } else if (statusCode == 500) {
          return 'Server error. Please try again later.';
        }
        return 'Server error (${statusCode ?? 'unknown'}). Please try again.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'Connection error. Please check your internet connection.';
      default:
        return 'Network error. Please try again.';
    }
  }
} 