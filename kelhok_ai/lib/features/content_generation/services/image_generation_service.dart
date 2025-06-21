import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/app_constants.dart';
import '../models/image_generation_models.dart';

class ImageGenerationService {
  final ApiClient _apiClient;

  ImageGenerationService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Generate image from prompt
  Future<ImageGenerationResponse> generateImage(
    ImageGenerationRequest request,
  ) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.generateImage,
        data: request.toJson(),
      );

      return ImageGenerationResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ImageGenerationException(
        message: 'Failed to generate image: $e',
        code: 'UNKNOWN_ERROR',
      );
    }
  }

  /// Generate image from story content
  Future<ImageGenerationResponse> generateImageFromStory({
    required String story,
    required String style,
    String? characterId,
    Map<String, dynamic>? additionalParams,
  }) async {
    final request = ImageGenerationRequest(
      prompt: _createImagePromptFromStory(story),
      style: style,
      characterId: characterId,
      width: 512,
      height: 512,
      steps: 20,
      guidanceScale: 7.5,
      seed: null, // Random seed
      additionalParams: additionalParams,
    );

    return generateImage(request);
  }

  /// Get available image styles
  Future<List<ImageStyle>> getImageStyles() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.imageStyles);
      final List<dynamic> stylesData = response.data['styles'] ?? [];
      
      return stylesData
          .map((style) => ImageStyle.fromJson(style))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ImageGenerationException(
        message: 'Failed to fetch image styles: $e',
        code: 'FETCH_STYLES_ERROR',
      );
    }
  }

  /// Get generation history
  Future<List<GeneratedImage>> getGenerationHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.imageHistory,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final List<dynamic> imagesData = response.data['images'] ?? [];
      return imagesData
          .map((image) => GeneratedImage.fromJson(image))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ImageGenerationException(
        message: 'Failed to fetch generation history: $e',
        code: 'FETCH_HISTORY_ERROR',
      );
    }
  }

  /// Delete generated image
  Future<void> deleteImage(String imageId) async {
    try {
      await _apiClient.delete('${ApiEndpoints.imageHistory}/$imageId');
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ImageGenerationException(
        message: 'Failed to delete image: $e',
        code: 'DELETE_ERROR',
      );
    }
  }

  /// Check generation status for async operations
  Future<ImageGenerationStatus> checkGenerationStatus(String jobId) async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.generateImage}/status/$jobId');
      return ImageGenerationStatus.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ImageGenerationException(
        message: 'Failed to check generation status: $e',
        code: 'STATUS_CHECK_ERROR',
      );
    }
  }

  /// Create optimized image prompt from story content
  String _createImagePromptFromStory(String story) {
    // Extract key elements from story for image generation
    String prompt = story;
    
    // Limit prompt length for better results
    if (prompt.length > 200) {
      prompt = prompt.substring(0, 200);
    }
    
    // Add style keywords for better image generation
    prompt += ', detailed illustration, high quality, digital art';
    
    return prompt;
  }

  /// Handle Dio errors and convert to custom exceptions
  ImageGenerationException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ImageGenerationException(
          message: 'Connection timeout. Please check your internet connection.',
          code: 'TIMEOUT_ERROR',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Server error occurred';
        
        switch (statusCode) {
          case 400:
            return ImageGenerationException(
              message: 'Invalid request: $message',
              code: 'BAD_REQUEST',
            );
          case 401:
            return ImageGenerationException(
              message: 'Authentication required',
              code: 'UNAUTHORIZED',
            );
          case 403:
            return ImageGenerationException(
              message: 'Access denied',
              code: 'FORBIDDEN',
            );
          case 429:
            return ImageGenerationException(
              message: 'Rate limit exceeded. Please try again later.',
              code: 'RATE_LIMIT_EXCEEDED',
            );
          case 500:
            return ImageGenerationException(
              message: 'Server error. Please try again later.',
              code: 'SERVER_ERROR',
            );
          default:
            return ImageGenerationException(
              message: message,
              code: 'HTTP_ERROR_$statusCode',
            );
        }
      case DioExceptionType.cancel:
        return ImageGenerationException(
          message: 'Request was cancelled',
          code: 'CANCELLED',
        );
      case DioExceptionType.unknown:
      default:
        return ImageGenerationException(
          message: 'Network error occurred',
          code: 'NETWORK_ERROR',
        );
    }
  }
} 