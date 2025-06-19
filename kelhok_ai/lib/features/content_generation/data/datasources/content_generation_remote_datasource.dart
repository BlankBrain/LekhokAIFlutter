import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import '../../../../core/utils/constants.dart';
import '../models/generation_request_model.dart';
import '../models/generation_response_model.dart';
import '../models/error_response_model.dart';

/// Abstract interface for the remote data source
abstract class ContentGenerationRemoteDataSource {
  Future<GenerationResponseModel> generateContent({
    required String prompt,
    String? character,
  });
}

/// Concrete implementation of the remote data source
class ContentGenerationRemoteDataSourceImpl
    implements ContentGenerationRemoteDataSource {
  final http.Client httpClient;
  final Logger logger;

  ContentGenerationRemoteDataSourceImpl({
    required this.httpClient,
    required this.logger,
  });

  @override
  Future<GenerationResponseModel> generateContent({
    required String prompt,
    String? character,
  }) async {
    final request = GenerationRequestModel(
      storyIdea: prompt,
      character: character ?? ApiConstants.defaultCharacter,
    );

    try {
      logger.info('Making API request to generate content');
      
      final response = await httpClient.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.generateEndpoint}'),
        headers: {
          'Content-Type': ApiConstants.contentType,
        },
        body: json.encode(request.toJson()),
      ).timeout(
        const Duration(seconds: 30),
      );

      logger.info('API response received with status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        logger.info('Successfully parsed response JSON');
        return GenerationResponseModel.fromJson(jsonResponse);
      } else {
        // Try to parse error response
        try {
          final errorResponse = json.decode(response.body) as Map<String, dynamic>;
          final errorModel = ErrorResponseModel.fromJson(errorResponse);
          logger.warning('API returned error: ${errorModel.detail}');
          throw ServerException(message: errorModel.detail);
        } catch (e) {
          logger.warning('Failed to parse error response: $e');
          throw ServerException(
            message: 'Server returned status code ${response.statusCode}',
          );
        }
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.severe('Network error occurred: $e');
      if (e.toString().contains('timeout') || e.toString().contains('TimeoutException')) {
        throw NetworkException(message: 'Connection timeout. Please try again.');
      }
      throw NetworkException(message: 'Network error occurred. Please check your connection.');
    }
  }
}

/// Custom exceptions for the data source
class ServerException implements Exception {
  final String message;
  ServerException({required this.message});
}

class NetworkException implements Exception {
  final String message;
  NetworkException({required this.message});
}

class ParsingException implements Exception {
  final String message;
  ParsingException({required this.message});
} 