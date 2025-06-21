import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/api/api_client.dart';
import '../models/auth_models.dart';
import 'dart:convert';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // API endpoints
  static const String _register = '/auth/register';
  static const String _login = '/auth/login';
  static const String _logout = '/auth/logout';
  static const String _logoutAll = '/auth/logout-all';
  static const String _profile = '/auth/profile';
  static const String _updateProfile = '/auth/profile';
  static const String _changePassword = '/auth/password/change';
  static const String _forgotPassword = '/auth/forgot-password';
  static const String _resetPassword = '/auth/reset-password';
  static const String _verifyEmail = '/auth/verify-email';
  static const String _resendVerification = '/auth/resend-verification';
  static const String _validateResetToken = '/auth/validate-reset-token';
  static const String _googleAuth = '/auth/google';
  static const String _googleCallback = '/auth/google/callback';
  static const String _sessions = '/auth/sessions';
  static const String _permissions = '/auth/permissions';

  // Storage keys
  static const String _sessionTokenKey = 'session_token';
  static const String _userProfileKey = 'user_profile';
  static const String _userIdKey = 'user_id';
  static const String _refreshTokenKey = 'refresh_token';

  // Register new user
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await _apiClient.post(
        _register,
        data: request.toJson(),
      );
      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Login user
  Future<LoginResponse> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _apiClient.post(
        _login,
        data: request.toJson(),
      );
      
      final loginResponse = LoginResponse.fromJson(response.data);
      
      // Store session token securely
      await _secureStorage.write(
        key: _sessionTokenKey,
        value: loginResponse.sessionToken,
      );
      
      // Store user profile
      await _secureStorage.write(
        key: _userProfileKey,
        value: jsonEncode(loginResponse.user.toJson()),
      );
      
      // Store user ID
      await _secureStorage.write(
        key: _userIdKey,
        value: loginResponse.user.id.toString(),
      );
      
      return loginResponse;
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Get current user profile
  Future<UserProfile> getCurrentUser() async {
    try {
      final response = await _apiClient.get(_profile);
      final userProfile = UserProfile.fromJson(response.data['user'] ?? response.data);
      
      // Update stored profile
      await _secureStorage.write(
        key: _userProfileKey,
        value: jsonEncode(userProfile.toJson()),
      );
      
      return userProfile;
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Update user profile
  Future<UserProfile> updateProfile(ProfileUpdateRequest request) async {
    try {
      final response = await _apiClient.put(
        _updateProfile,
        data: request.toJson(),
      );
      
      final userProfile = UserProfile.fromJson(response.data['user'] ?? response.data);
      
      // Update stored profile
      await _secureStorage.write(
        key: _userProfileKey,
        value: jsonEncode(userProfile.toJson()),
      );
      
      return userProfile;
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final request = PasswordChangeRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      
      await _apiClient.post(
        _changePassword,
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Forgot password
  Future<void> forgotPassword(String email) async {
    try {
      await _apiClient.post(
        _forgotPassword,
        data: ForgotPasswordRequest(email: email).toJson(),
      );
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Reset password
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _apiClient.post(
        _resetPassword,
        data: ResetPasswordRequest(
          token: token,
          newPassword: newPassword,
        ).toJson(),
      );
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Validate reset token
  Future<bool> validateResetToken(String token) async {
    try {
      final response = await _apiClient.get(
        '$_validateResetToken?token=$token',
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 404) {
        return false;
      }
      throw _handleAuthError(e);
    }
  }

  // Verify email
  Future<void> verifyEmail(String token) async {
    try {
      await _apiClient.post(
        _verifyEmail,
        data: VerifyEmailRequest(token: token).toJson(),
      );
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Resend email verification
  Future<void> resendEmailVerification(String email) async {
    try {
      await _apiClient.post(
        _resendVerification,
        data: ResendVerificationRequest(email: email).toJson(),
      );
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Get Google OAuth URL
  Future<GoogleOAuthUrlResponse> getGoogleOAuthUrl() async {
    try {
      final response = await _apiClient.get(_googleAuth);
      return GoogleOAuthUrlResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Google OAuth callback
  Future<LoginResponse> googleOAuthCallback(GoogleCallbackRequest request) async {
    try {
      final response = await _apiClient.post(
        _googleCallback,
        data: request.toJson(),
      );
      
      final loginResponse = LoginResponse.fromJson(response.data);
      
      // Store session token securely
      await _secureStorage.write(
        key: _sessionTokenKey,
        value: loginResponse.sessionToken,
      );
      
      // Store user profile
      await _secureStorage.write(
        key: _userProfileKey,
        value: jsonEncode(loginResponse.user.toJson()),
      );
      
      // Store user ID
      await _secureStorage.write(
        key: _userIdKey,
        value: loginResponse.user.id.toString(),
      );
      
      return loginResponse;
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Get active sessions
  Future<ActiveSessionsResponse> getActiveSessions() async {
    try {
      final response = await _apiClient.get(_sessions);
      return ActiveSessionsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Get user permissions
  Future<UserPermissions> getUserPermissions() async {
    try {
      final response = await _apiClient.get(_permissions);
      return UserPermissions.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Logout from current device
  Future<void> logout() async {
    try {
      await _apiClient.post(_logout);
    } catch (e) {
      // Continue with logout even if API call fails
      print('Logout API call failed: $e');
    } finally {
      // Always clear stored tokens
      await _clearStoredData();
    }
  }

  // Logout from all devices
  Future<void> logoutAllDevices() async {
    try {
      await _apiClient.post(_logoutAll);
    } catch (e) {
      // Continue with logout even if API call fails
      print('Logout all devices API call failed: $e');
    } finally {
      // Always clear stored tokens
      await _clearStoredData();
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read(key: _sessionTokenKey);
    if (token == null || token.isEmpty) return false;
    
    // For development, return true if token exists
    // In production, you might want to validate with server
    return true;
  }

  // Get stored session token
  Future<String?> getSessionToken() async {
    return await _secureStorage.read(key: _sessionTokenKey);
  }

  // Get stored user profile
  Future<UserProfile?> getStoredUserProfile() async {
    try {
      final userProfileJson = await _secureStorage.read(key: _userProfileKey);
      if (userProfileJson == null) return null;
      
      final userProfileMap = jsonDecode(userProfileJson);
      return UserProfile.fromJson(userProfileMap);
    } catch (e) {
      return null;
    }
  }

  // Get stored user ID
  Future<String?> getUserId() async {
    return await _secureStorage.read(key: _userIdKey);
  }

  // Clear all stored authentication data
  Future<void> _clearStoredData() async {
    await _secureStorage.delete(key: _sessionTokenKey);
    await _secureStorage.delete(key: _userIdKey);
    await _secureStorage.delete(key: _userProfileKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  // Error handling
  AuthException _handleAuthError(dynamic error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode ?? 0;
      final data = error.response?.data;
      
      switch (statusCode) {
        case 401:
          return AuthException(
            data?['message'] ?? 'Invalid credentials',
            code: 'INVALID_CREDENTIALS',
          );
        case 403:
          return AuthException(
            'Access forbidden',
            code: 'ACCESS_FORBIDDEN',
          );
        case 404:
          return AuthException(
            'Resource not found',
            code: 'NOT_FOUND',
          );
        case 422:
          return AuthException(
            data?['message'] ?? 'Validation error',
            code: 'VALIDATION_ERROR',
            errors: data?['errors'],
          );
        case 429:
          return AuthException(
            'Too many requests',
            code: 'RATE_LIMIT_EXCEEDED',
          );
        case 500:
          return AuthException(
            'Server error. Please try again later.',
            code: 'SERVER_ERROR',
          );
        default:
          return AuthException(
            data?['message'] ?? error.message ?? 'Unknown error occurred',
            code: 'API_ERROR',
          );
      }
    } else {
      return AuthException(
        'Network error. Please check your connection.',
        code: 'NETWORK_ERROR',
      );
    }
  }
} 