/// API Constants
class ApiConstants {
  // Base URL - will be provided by backend team
  // For now using a placeholder URL for development
  static const String baseUrl = 'https://your-api-domain.com/api/v1';
  
  // Endpoints
  static const String generateEndpoint = '/generate';
  
  // Headers
  static const String contentType = 'application/json';
  
  // Default character for MVP
  static const String defaultCharacter = 'default_character_for_mvp';
}

/// App Constants
class AppConstants {
  static const String appName = 'KelhokAI';
  static const String appVersion = '1.0.0';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  
  // Timeouts
  static const int connectionTimeout = 30; // seconds
  static const int receiveTimeout = 30; // seconds
}

/// Text Constants
class TextConstants {
  // App Bar
  static const String appBarTitle = 'AI Content Generator';
  
  // Story Generation
  static const String storyPromptLabel = 'Enter your Story Idea:';
  static const String storyPromptHint = 'e.g., A knight searching for a legendary sword...';
  static const String generateStoryButton = 'Generate Story';
  static const String generatedStoryLabel = 'Generated Story:';
  static const String copyStoryButton = 'Copy Story';
  
  // Caption Generation
  static const String captionPromptLabel = 'Enter context for your Caption:';
  static const String captionPromptHint = 'e.g., A serene beach at sunrise...';
  static const String generateCaptionButton = 'Generate Caption';
  static const String generatedCaptionLabel = 'Generated Caption:';
  static const String copyCaptionButton = 'Copy Caption';
  
  // General
  static const String placeholderText = 'Your AI-generated content will appear here.';
  static const String loadingText = 'Generating...';
  static const String copiedToClipboard = 'Copied to clipboard!';
  
  // Error Messages
  static const String networkError = 'Please check your internet connection and try again.';
  static const String serverError = 'Something went wrong. Please try again later.';
  static const String generalError = 'An unexpected error occurred. Please try again.';
  static const String emptyInputError = 'Please enter some text to generate content.';
  static const String generationFailedError = 'Failed to generate content. Please try again.';
} 