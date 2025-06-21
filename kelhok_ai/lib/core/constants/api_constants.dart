class ApiConstants {
  static const String baseUrl = 'https://api.karigorai.com'; // Production
  static const String developmentUrl = 'http://localhost:8000'; // Development
  
  // Authentication endpoints - matching the provided API documentation
  static const String authPrefix = '/auth';
  static const String register = '$authPrefix/register';
  static const String login = '$authPrefix/login';
  static const String logout = '$authPrefix/logout';
  static const String logoutAll = '$authPrefix/logout-all';
  static const String profile = '$authPrefix/profile';
  static const String updateProfile = '$authPrefix/profile';
  static const String changePassword = '$authPrefix/password/change';
  static const String forgotPassword = '$authPrefix/forgot-password';
  static const String resetPassword = '$authPrefix/reset-password';
  static const String verifyEmail = '$authPrefix/verify-email';
  static const String resendVerification = '$authPrefix/resend-verification';
  static const String validateResetToken = '$authPrefix/validate-reset-token';
  static const String googleAuth = '$authPrefix/google';
  static const String googleCallback = '$authPrefix/google/callback';
  static const String sessions = '$authPrefix/sessions';
  static const String permissions = '$authPrefix/permissions';
  static const String userInfo = '$authPrefix/me';

  // Story generation endpoints
  static const String generate = '/generate';
  static const String generateImage = '/generate-image';
  
  // Character management
  static const String characters = '/characters';
  static const String characterById = '/characters/{id}';
  static const String loadCharacter = '/load_character';
  static const String characterTemplates = '/characters/templates';
  static const String characterSuggestions = '/characters/suggestions';
  static const String characterSearch = '/characters/search';
  static const String charactersByTags = '/characters/by-tags';
  static const String characterFavorites = '/characters/favorites';
  
  // History management
  static const String history = '/history';
  static const String favourites = '/favourites';
  static const String historyById = '/history/{id}';
  static const String toggleFavorite = '/history/{id}/favourite';
  
  // System health
  static const String health = '/system/health';
  static const String status = '/system/status';
  
  // Analytics
  static const String analyticsDashboard = '/analytics/dashboard';
  static const String analyticsExport = '/analytics/export';
  
  // Settings
  static const String settings = '/settings';
  static const String settingsByCategory = '/settings/{category}';
  
  // API Key management
  static const String apiKey = '/api-key';
}

class StorageKeys {
  static const String sessionToken = 'session_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userProfile = 'user_profile';
  static const String appSettings = 'app_settings';
  static const String biometricEnabled = 'biometric_enabled';
}

class ApiConfig {
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'KarigorAI-iOS/1.0.0',
  };
  
  static Map<String, String> getAuthHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
    'X-Session-Token': token,
  };
} 