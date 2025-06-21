// User Profile Model
class UserProfile {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String status;
  final int? organizationId;
  final String authProvider;
  final String? profilePictureUrl;
  final bool isEmailVerified;
  final DateTime? lastLogin;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.status,
    this.organizationId,
    required this.authProvider,
    this.profilePictureUrl,
    required this.isEmailVerified,
    this.lastLogin,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName'.trim();
  String get displayName => fullName.isNotEmpty ? fullName : email.split('@')[0];

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'],
    email: json['email'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    role: json['role'],
    status: json['status'],
    organizationId: json['organization_id'],
    authProvider: json['auth_provider'] ?? 'email',
    profilePictureUrl: json['profile_picture_url'],
    isEmailVerified: json['is_email_verified'] ?? false,
    lastLogin: json['last_login'] != null ? DateTime.parse(json['last_login']) : null,
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'first_name': firstName,
    'last_name': lastName,
    'role': role,
    'status': status,
    'organization_id': organizationId,
    'auth_provider': authProvider,
    'profile_picture_url': profilePictureUrl,
    'is_email_verified': isEmailVerified,
    'last_login': lastLogin?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
  };
}

// Registration Request Model
class RegisterRequest {
  final String email;
  final String password;
  final String username;
  final String fullName;
  final String? organizationName;
  final bool privacyPolicyAccepted;
  final bool termsOfServiceAccepted;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.username,
    required this.fullName,
    this.organizationName,
    this.privacyPolicyAccepted = true,
    this.termsOfServiceAccepted = true,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'username': username,
    'full_name': fullName,
    'organization_name': organizationName,
    'privacy_policy_accepted': privacyPolicyAccepted,
    'terms_of_service_accepted': termsOfServiceAccepted,
  };
}

// Registration Response Model
class RegisterResponse {
  final String message;
  final int userId;
  final bool emailSent;
  final String? action;
  final String? authProvider;

  RegisterResponse({
    required this.message,
    required this.userId,
    required this.emailSent,
    this.action,
    this.authProvider,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
    message: json['message'],
    userId: json['user_id'],
    emailSent: json['email_sent'] ?? false,
    action: json['action'],
    authProvider: json['auth_provider'],
  );
}

// Login Request Model
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}

// Login Response Model
class LoginResponse {
  final String message;
  final String sessionToken;
  final DateTime? expiresAt;
  final UserProfile user;

  LoginResponse({
    required this.message,
    required this.sessionToken,
    this.expiresAt,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    message: json['message'],
    sessionToken: json['session_token'],
    expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at']) : null,
    user: UserProfile.fromJson(json['user']),
  );
}

// Profile Update Request Model
class ProfileUpdateRequest {
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? preferredLanguage;
  final String? timezone;

  ProfileUpdateRequest({
    this.firstName,
    this.lastName,
    this.username,
    this.preferredLanguage,
    this.timezone,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (username != null) data['username'] = username;
    if (preferredLanguage != null) data['preferred_language'] = preferredLanguage;
    if (timezone != null) data['timezone'] = timezone;
    return data;
  }
}

// Password Change Request Model
class PasswordChangeRequest {
  final String currentPassword;
  final String newPassword;

  PasswordChangeRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    'current_password': currentPassword,
    'new_password': newPassword,
  };
}

// Forgot Password Request Model
class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

// Reset Password Request Model
class ResetPasswordRequest {
  final String token;
  final String newPassword;

  ResetPasswordRequest({
    required this.token,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    'token': token,
    'new_password': newPassword,
  };
}

// Email Verification Request Model
class VerifyEmailRequest {
  final String token;

  VerifyEmailRequest({required this.token});

  Map<String, dynamic> toJson() => {'token': token};
}

// Resend Verification Request Model
class ResendVerificationRequest {
  final String email;

  ResendVerificationRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

// Google OAuth Models
class GoogleOAuthUrlResponse {
  final String authUrl;
  final String state;

  GoogleOAuthUrlResponse({
    required this.authUrl,
    required this.state,
  });

  factory GoogleOAuthUrlResponse.fromJson(Map<String, dynamic> json) => 
    GoogleOAuthUrlResponse(
      authUrl: json['auth_url'],
      state: json['state'],
    );
}

class GoogleCallbackRequest {
  final String code;
  final String? state;
  final bool privacyPolicyAccepted;
  final bool termsOfServiceAccepted;

  GoogleCallbackRequest({
    required this.code,
    this.state,
    this.privacyPolicyAccepted = true,
    this.termsOfServiceAccepted = true,
  });

  Map<String, dynamic> toJson() => {
    'code': code,
    'state': state,
    'privacy_policy_accepted': privacyPolicyAccepted,
    'terms_of_service_accepted': termsOfServiceAccepted,
  };
}

// Session Info Model
class SessionInfo {
  final int id;
  final String sessionToken;
  final DateTime expiresAt;
  final bool isActive;
  final String? ipAddress;
  final String? userAgent;
  final DateTime createdAt;
  final bool isCurrent;

  SessionInfo({
    required this.id,
    required this.sessionToken,
    required this.expiresAt,
    required this.isActive,
    this.ipAddress,
    this.userAgent,
    required this.createdAt,
    required this.isCurrent,
  });

  factory SessionInfo.fromJson(Map<String, dynamic> json) => SessionInfo(
    id: json['id'],
    sessionToken: json['session_token'],
    expiresAt: DateTime.parse(json['expires_at']),
    isActive: json['is_active'],
    ipAddress: json['ip_address'],
    userAgent: json['user_agent'],
    createdAt: DateTime.parse(json['created_at']),
    isCurrent: json['is_current'],
  );
}

class ActiveSessionsResponse {
  final List<SessionInfo> sessions;

  ActiveSessionsResponse({required this.sessions});

  factory ActiveSessionsResponse.fromJson(Map<String, dynamic> json) => 
    ActiveSessionsResponse(
      sessions: (json['sessions'] as List)
          .map((session) => SessionInfo.fromJson(session))
          .toList(),
    );
}

// User Permissions Model
class UserPermissions {
  final String role;
  final List<String> permissions;
  final Map<String, bool> capabilities;

  UserPermissions({
    required this.role,
    required this.permissions,
    required this.capabilities,
  });

  factory UserPermissions.fromJson(Map<String, dynamic> json) => UserPermissions(
    role: json['role'],
    permissions: List<String>.from(json['permissions']),
    capabilities: Map<String, bool>.from(json['capabilities']),
  );
}

// Auth Exception Model
class AuthException implements Exception {
  final String message;
  final String code;
  final Map<String, dynamic>? errors;

  AuthException(this.message, {required this.code, this.errors});

  @override
  String toString() => 'AuthException: $message (Code: $code)';
}

// Error codes constants
class AuthErrorCodes {
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int validationError = 422;
  static const int tooManyRequests = 429;
  static const int serverError = 500;
}

class AuthExceptions {
  static const String invalidCredentials = "Invalid email or password";
  static const String emailNotVerified = "Email not verified";
  static const String accountSuspended = "Account suspended";
  static const String sessionExpired = "Session expired";
  static const String weakPassword = "Password too weak";
  static const String emailAlreadyExists = "Email already registered";
  static const String invalidToken = "Invalid or expired token";
  static const String rateLimitExceeded = "Too many requests";
} 