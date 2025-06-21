import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class IOSConfig {
  static const FlutterSecureStorage secureStorage = FlutterSecureStorage();

  static bool get isIOS => Platform.isIOS;

  // iOS-specific authentication features
  static const Map<String, String> iOSHeaders = {
    'X-Platform': 'iOS',
    'X-Device-Type': 'mobile',
    'User-Agent': 'KarigorAI-iOS/1.0.0',
  };

  // iOS Keychain configuration
  static const String keychainServiceName = 'com.karigorai.kelhok.auth';
  static const String keychainAccessGroup = 'com.karigorai.kelhok';

  // Network configuration for iOS
  static const Map<String, dynamic> networkConfig = {
    'allowCellularAccess': true,
    'allowExpensiveNetworkAccess': true,
    'allowConstrainedNetworkAccess': true,
    'timeout': 30.0,
  };

  // iOS-specific storage keys
  static const String iosTokenKey = 'ios_session_token';
  static const String iosBiometricKey = 'ios_biometric_enabled';
  static const String iosUserIdKey = 'ios_user_id';
  static const String iosProfileKey = 'ios_user_profile';

  // Methods for iOS-specific functionality
  static Future<bool> canUseBiometrics() async {
    if (!isIOS) return false;
    
    try {
      // This would typically check for biometric availability
      // For now, we'll assume it's available on iOS devices
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> clearIOSData() async {
    if (!isIOS) return;
    
    try {
      await secureStorage.deleteAll();
    } catch (e) {
      print('Error clearing iOS data: $e');
    }
  }

  static Future<void> storeSecurely(String key, String value) async {
    await secureStorage.write(key: key, value: value);
  }

  static Future<String?> readSecurely(String key) async {
    return await secureStorage.read(key: key);
  }

  // iOS-specific UI configurations
  static const double iosCornerRadius = 12.0;
  static const double iosBlurRadius = 20.0;
  
  // iOS notification permissions (for future use)
  static Future<bool> requestNotificationPermissions() async {
    if (!isIOS) return false;
    // Implementation would go here for iOS notification permissions
    return true;
  }
} 