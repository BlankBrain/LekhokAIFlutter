import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';

/// Backend Character Model (matches the actual backend response)
class BackendCharacter {
  final String id;
  final String name;
  final String createdAt;
  final int? createdBy;
  final int usageCount;
  final String? lastUsed;

  BackendCharacter({
    required this.id,
    required this.name,
    required this.createdAt,
    this.createdBy,
    required this.usageCount,
    this.lastUsed,
  });

  factory BackendCharacter.fromJson(Map<String, dynamic> json) {
    return BackendCharacter(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: json['created_at'] as String,
      createdBy: json['created_by'] as int?,
      usageCount: json['usage_count'] as int,
      lastUsed: json['last_used'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
      'created_by': createdBy,
      'usage_count': usageCount,
      'last_used': lastUsed,
    };
  }
}

/// Backend Story Generation Request (matches the backend API)
class BackendStoryRequest {
  final String storyIdea;
  final String? character;

  BackendStoryRequest({
    required this.storyIdea,
    this.character,
  });

  Map<String, dynamic> toJson() {
    return {
      'storyIdea': storyIdea,
      if (character != null) 'character': character,
    };
  }
}

/// Backend Story Generation Response (matches the backend API)
class BackendStoryResponse {
  final String story;
  final String imagePrompt;
  final String? modelName;
  final int? inputTokens;
  final int? outputTokens;

  BackendStoryResponse({
    required this.story,
    required this.imagePrompt,
    this.modelName,
    this.inputTokens,
    this.outputTokens,
  });

  factory BackendStoryResponse.fromJson(Map<String, dynamic> json) {
    return BackendStoryResponse(
      story: json['story'] as String,
      imagePrompt: json['imagePrompt'] as String,
      modelName: json['modelName'] as String?,
      inputTokens: json['inputTokens'] as int?,
      outputTokens: json['outputTokens'] as int?,
    );
  }
}

/// Backend Story Service
/// This service integrates with the actual KarigorAI backend API
/// Endpoints: http://localhost:8000/api/v1/generate and http://localhost:8000/characters
class BackendStoryService {
  final ApiClient _apiClient;

  BackendStoryService() : _apiClient = ApiClient();

  /// Get all characters from the backend
  Future<List<BackendCharacter>> getCharacters() async {
    try {
      final response = await _apiClient.get('/characters');
      
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> charactersJson = response.data['characters'] as List<dynamic>;
        return charactersJson
            .map((json) => BackendCharacter.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load characters: Invalid response');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Authentication required. Please login again.');
      } else if (e.response?.statusCode == 403) {
        throw Exception('You don\'t have permission to access characters.');
      } else {
        throw Exception('Failed to load characters: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to load characters: $e');
    }
  }

  /// Generate story using the backend API
  Future<BackendStoryResponse> generateStory({
    required String storyIdea,
    String? characterId,
  }) async {
    try {
      final request = BackendStoryRequest(
        storyIdea: storyIdea,
        character: characterId,
      );

      final response = await _apiClient.post(
        '/api/v1/generate', // Correct backend endpoint
        data: request.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        return BackendStoryResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to generate story: Invalid response');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final detail = e.response?.data?['detail'] as String?;
        throw Exception('Invalid request: ${detail ?? 'Bad request'}');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Authentication required. Please login again.');
      } else if (e.response?.statusCode == 403) {
        throw Exception('You don\'t have permission to generate stories.');
      } else if (e.response?.statusCode == 503) {
        throw Exception('Story generation service is temporarily unavailable.');
      } else {
        throw Exception('Failed to generate story: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to generate story: $e');
    }
  }

  /// Load a specific character (tells backend to use this character for generation)
  Future<bool> loadCharacter(String characterId) async {
    try {
      final response = await _apiClient.post(
        '/load_character',
        data: {'character': characterId},
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data['success'] as bool? ?? false;
      } else {
        return false;
      }
    } catch (e) {
      // If character loading fails, continue anyway as it's not critical
      print('Warning: Failed to load character $characterId: $e');
      return false;
    }
  }

  /// Get character by ID
  Future<BackendCharacter?> getCharacter(String id) async {
    try {
      final characters = await getCharacters();
      return characters.where((char) => char.id == id).firstOrNull;
    } catch (e) {
      print('Warning: Failed to get character $id: $e');
      return null;
    }
  }

  /// Search characters by name
  Future<List<BackendCharacter>> searchCharacters(String query) async {
    try {
      final characters = await getCharacters();
      return characters
          .where((char) => char.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Failed to search characters: $e');
    }
  }
} 