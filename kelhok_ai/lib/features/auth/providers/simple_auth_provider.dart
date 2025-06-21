import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Simple auth state
class SimpleAuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? user;

  SimpleAuthState({
    required this.isAuthenticated,
    required this.isLoading,
    this.error,
    this.user,
  });

  SimpleAuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    Map<String, dynamic>? user,
  }) {
    return SimpleAuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
    );
  }
}

// Simple auth notifier
class SimpleAuthNotifier extends StateNotifier<SimpleAuthState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  SimpleAuthNotifier() : super(SimpleAuthState(
    isAuthenticated: false,
    isLoading: true,
  )) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final token = await _storage.read(key: 'session_token');
      if (token != null && token.isNotEmpty) {
        final userJson = await _storage.read(key: 'user_profile');
        Map<String, dynamic>? user;
        if (userJson != null) {
          user = {
            'email': 'test@karigorai.com',
            'name': 'Test User',
            'id': 1,
          };
        }
        
        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
          user: user,
        );
      } else {
        state = state.copyWith(
          isAuthenticated: false,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      if (email.contains('test') || email == 'admin@karigorai.com') {
        await _storage.write(key: 'session_token', value: 'mock_token_${DateTime.now().millisecondsSinceEpoch}');
        await _storage.write(key: 'user_profile', value: 'mock_user');
        
        final user = {
          'email': email,
          'name': email.split('@')[0].replaceAll('.', ' ').toUpperCase(),
          'id': 1,
        };
        
        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
          user: user,
        );
      } else {
        throw Exception('Invalid credentials. Use test@karigorai.com or admin@karigorai.com with any password.');
      }
    } catch (e) {
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String username,
    required String fullName,
    String? organizationName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      state = state.copyWith(
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      state = state.copyWith(
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Mock reset password - in real app this would call API
      await Future.delayed(const Duration(seconds: 1));
      
      state = state.copyWith(
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _storage.delete(key: 'session_token');
      await _storage.delete(key: 'user_profile');
    } finally {
      state = SimpleAuthState(
        isAuthenticated: false,
        isLoading: false,
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider
final simpleAuthProvider = StateNotifierProvider<SimpleAuthNotifier, SimpleAuthState>((ref) {
  return SimpleAuthNotifier();
});
