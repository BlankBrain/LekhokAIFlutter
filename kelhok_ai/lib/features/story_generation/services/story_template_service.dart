import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/story_template_models.dart';
import '../../../core/constants/api_constants.dart';

class StoryTemplateService {
  final Dio _dio;
  
  StoryTemplateService({Dio? dio}) : _dio = dio ?? Dio();

  /// Fetch all available story templates
  Future<List<StoryTemplate>> getTemplates({
    String? category,
    String? difficulty,
    List<String>? genres,
    String? searchQuery,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null) queryParams['category'] = category;
      if (difficulty != null) queryParams['difficulty'] = difficulty;
      if (genres != null && genres.isNotEmpty) queryParams['genres'] = genres.join(',');
      if (searchQuery != null && searchQuery.isNotEmpty) queryParams['search'] = searchQuery;

      final response = await _dio.get(
        '${ApiConstants.baseUrl}/templates',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> templatesJson = response.data['templates'];
        return templatesJson.map((json) => StoryTemplate.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch templates: ${response.statusMessage}');
      }
    } catch (e) {
      // Return mock data for development
      return _getMockTemplates(
        category: category,
        difficulty: difficulty,
        genres: genres,
        searchQuery: searchQuery,
      );
    }
  }

  /// Get a specific template by ID
  Future<StoryTemplate?> getTemplateById(String templateId) async {
    try {
      final response = await _dio.get('${ApiConstants.baseUrl}/templates/$templateId');
      
      if (response.statusCode == 200) {
        return StoryTemplate.fromJson(response.data);
      } else {
        throw Exception('Template not found');
      }
    } catch (e) {
      // Return mock data for development
      final mockTemplates = _getMockTemplates();
      return mockTemplates.firstWhere(
        (template) => template.id == templateId,
        orElse: () => throw Exception('Template not found'),
      );
    }
  }

  /// Get templates by category
  Future<List<StoryTemplate>> getTemplatesByCategory(String category) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/templates/category/$category',
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> templatesJson = response.data['templates'];
        return templatesJson.map((json) => StoryTemplate.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch templates by category');
      }
    } catch (e) {
      // Return filtered mock data
      return _getMockTemplates(category: category);
    }
  }

  /// Search templates
  Future<List<StoryTemplate>> searchTemplates(String query) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/templates/search',
        queryParameters: {'q': query},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> templatesJson = response.data['templates'];
        return templatesJson.map((json) => StoryTemplate.fromJson(json)).toList();
      } else {
        throw Exception('Search failed');
      }
    } catch (e) {
      // Return filtered mock data
      return _getMockTemplates(searchQuery: query);
    }
  }

  /// Get user's favorite templates
  Future<List<StoryTemplate>> getFavoriteTemplates() async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/templates/favorites',
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> templatesJson = response.data['templates'];
        return templatesJson.map((json) => StoryTemplate.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch favorite templates');
      }
    } catch (e) {
      // Return empty list for development
      return [];
    }
  }

  /// Toggle template favorite status
  Future<bool> toggleFavorite(String templateId) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/templates/$templateId/favorite',
      );
      
      return response.statusCode == 200;
    } catch (e) {
      // Return true for development (mock success)
      return true;
    }
  }

  /// Generate story from template
  Future<String> generateStoryFromTemplate({
    required String templateId,
    required TemplateCustomization customization,
    Map<String, String>? additionalContext,
  }) async {
    try {
      final requestBody = {
        'template_id': templateId,
        'customization': customization.toJson(),
        if (additionalContext != null) 'context': additionalContext,
      };

      final response = await _dio.post(
        '${ApiConstants.generate}',
        data: requestBody,
      );

      if (response.statusCode == 200) {
        return response.data['story'] ?? '';
      } else {
        throw Exception('Story generation failed');
      }
    } catch (e) {
      // Return mock story for development
      return _generateMockStory(templateId, customization);
    }
  }

  /// Save custom template
  Future<StoryTemplate> saveCustomTemplate(StoryTemplate template) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/templates',
        data: template.toJson(),
      );

      if (response.statusCode == 201) {
        return StoryTemplate.fromJson(response.data);
      } else {
        throw Exception('Failed to save template');
      }
    } catch (e) {
      // Return the template with a generated ID for development
      return template.copyWith(
        id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      );
    }
  }

  /// Delete custom template
  Future<bool> deleteCustomTemplate(String templateId) async {
    try {
      final response = await _dio.delete(
        '${ApiConstants.baseUrl}/templates/$templateId',
      );
      
      return response.statusCode == 200;
    } catch (e) {
      // Return true for development (mock success)
      return true;
    }
  }

  // Mock data methods for development
  List<StoryTemplate> _getMockTemplates({
    String? category,
    String? difficulty,
    List<String>? genres,
    String? searchQuery,
  }) {
    var templates = PredefinedTemplates.allTemplates;

    // Apply filters
    if (category != null) {
      templates = templates.where((t) => 
        t.category.toLowerCase() == category.toLowerCase()).toList();
    }

    if (difficulty != null) {
      templates = templates.where((t) => 
        t.difficulty.toLowerCase() == difficulty.toLowerCase()).toList();
    }

    if (genres != null && genres.isNotEmpty) {
      templates = templates.where((t) => 
        t.genres.any((g) => genres.contains(g))).toList();
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      templates = templates.where((t) => 
        t.name.toLowerCase().contains(query) ||
        t.description.toLowerCase().contains(query) ||
        t.tags.any((tag) => tag.toLowerCase().contains(query))).toList();
    }

    return templates;
  }

  String _generateMockStory(String templateId, TemplateCustomization customization) {
    final template = PredefinedTemplates.allTemplates
        .firstWhere((t) => t.id == templateId, orElse: () => PredefinedTemplates.allTemplates.first);
    
    return '''
    ${template.previewContent}
    
    This is a ${customization.selectedTone} story with a ${customization.selectedMood} mood, 
    incorporating elements from the ${customization.selectedGenres.join(', ')} genres.
    
    The story continues with rich details and compelling narrative, 
    bringing the template to life with approximately ${customization.targetLength} words 
    of engaging content that captures the essence of your customization choices.
    
    [This is a mock story for development purposes]
    ''';
  }
} 