import 'package:flutter/material.dart';

// KarigorAI Design System Constants
class AppColors {
  // Primary Brand Colors
  static const technoNavy = Color(0xFF22345C);
  static const karigorGold = Color(0xFFE6A426);
  
  // Glass Morphism Colors
  static const glassBackground = Color(0x99FFFFFF); // 60% white opacity
  static const glassBorder = Color(0x4DFFFFFF); // 30% white opacity
  static const glassShadow = Color(0x1F22345C); // 12% techno navy opacity
  
  // Text Colors
  static const primaryText = technoNavy;
  static const secondaryText = Color.fromRGBO(20, 31, 51, 0.8);
  static const tertiaryText = Color.fromRGBO(20, 31, 51, 0.7);
  static const quaternaryText = Color.fromRGBO(20, 31, 51, 0.6);
  
  // Background Colors
  static const primaryBackground = Color(0xFFF8FAFC);
  static const cardBackground = glassBackground;
  
  // Status Colors
  static const success = Color(0xFF10B981);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  static const info = Color(0xFF3B82F6);
}

class AppSizes {
  // Spacing
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  
  // Border Radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  
  // Component Heights
  static const double buttonHeightSm = 32.0;
  static const double buttonHeightMd = 40.0;
  static const double buttonHeightLg = 48.0;
  static const double textFieldHeight = 48.0;
  
  // Glass Effect
  static const double glassBlur = 12.0;
  static const double glassShadowBlur = 32.0;
  static const double glassShadowOffset = 8.0;
}

class AppTextStyles {
  // Heading Styles
  static const headingXL = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w900,
    color: AppColors.primaryText,
    height: 1.2,
  );
  
  static const headingLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: AppColors.primaryText,
    height: 1.2,
  );
  
  static const headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
    height: 1.3,
  );
  
  // Body Styles
  static const bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
    height: 1.4,
  );
  
  static const bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
    height: 1.4,
  );
  
  static const bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
    height: 1.4,
  );
}

class AppAnimations {
  // Durations
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 300);
  
  // Curves
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve elasticOut = Curves.elasticOut;
  static const Curve bounceOut = Curves.bounceOut;
}

class AppStrings {
  // App Info
  static const String appName = 'KarigorAI';
  static const String tagline = 'AI-Powered Storytelling';
  
  // Navigation
  static const String navHome = 'Home';
  static const String navGenerate = 'Generate';
  static const String navCharacters = 'Characters';
  static const String navHistory = 'History';
  static const String navProfile = 'Profile';
  
  // Actions
  static const String generateStory = 'Generate Story';
  static const String generateCaption = 'Generate Caption';
  static const String createCharacter = 'Create Character';
  static const String getStarted = 'Get Started';
  static const String signIn = 'Sign In';
  static const String signUp = 'Sign Up';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String share = 'Share';
  static const String favorite = 'Favorite';
  
  // Authentication
  static const String login = 'Login';
  static const String register = 'Register';
  static const String logout = 'Logout';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String username = 'Username';
  static const String fullName = 'Full Name';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String organizationName = 'Organization Name';
  static const String currentPassword = 'Current Password';
  static const String newPassword = 'New Password';
  static const String forgotPasswordTitle = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String changePassword = 'Change Password';
  static const String createAccount = 'Create Account';
  static const String haveAccount = 'Already have an account?';
  static const String noAccount = "Don't have an account?";
  static const String backToLogin = 'Back to Login';
  
  // Messages
  static const String loginSuccess = 'Login successful!';
  static const String registerSuccess = 'Registration successful! Please check your email to verify your account.';
  static const String passwordResetSent = 'Password reset link sent to your email.';
  static const String passwordResetSuccess = 'Password reset successful!';
  static const String profileUpdateSuccess = 'Profile updated successfully!';
  static const String passwordChangeSuccess = 'Password changed successfully!';
  
  // Validation Messages
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Please enter a valid email address';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort = 'Password must be at least 8 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String usernameRequired = 'Username is required';
  static const String usernameTooShort = 'Username must be at least 3 characters';
  static const String fullNameRequired = 'Full name is required';
  static const String firstNameRequired = 'First name is required';
  static const String lastNameRequired = 'Last name is required';
  static const String currentPasswordRequired = 'Current password is required';
  static const String newPasswordRequired = 'New password is required';
  static const String resetTokenRequired = 'Reset token is required';
  
  // Hints
  static const String emailHint = 'Enter your email address';
  static const String passwordHint = 'Enter your password';
  static const String confirmPasswordHint = 'Confirm your password';
  static const String usernameHint = 'Enter your username';
  static const String fullNameHint = 'Enter your full name';
  static const String firstNameHint = 'Enter your first name';
  static const String lastNameHint = 'Enter your last name';
  static const String organizationNameHint = 'Enter organization name (optional)';
  static const String currentPasswordHint = 'Enter your current password';
  static const String newPasswordHint = 'Enter your new password';
  static const String resetTokenHint = 'Enter reset token from email';
  
  // Descriptions
  static const String forgotPasswordDescription = 'Enter your email address and we\'ll send you a link to reset your password.';
  static const String resetPasswordDescription = 'Enter the reset token from your email and choose a new password.';
  static const String registerDescription = 'Create your account to start your AI storytelling journey.';
  
  // Placeholders
  static const String enterStoryPrompt = 'What story would you like to create today?';
  static const String searchCharacters = 'Search characters...';
  static const String searchStories = 'Search stories...';
  
  // Onboarding
  static const String welcomeTitle = 'Welcome to KarigorAI';
  static const String welcomeSubtitle = 'AI-Powered Storytelling at Your Fingertips';
  static const List<String> onboardingFeatures = [
    'Generate unique stories with AI',
    'Create custom characters',
    'Save and organize your stories',
    'Share with the community',
  ];
}

class AppConstants {
  // Validation Rules
  static const int minPasswordLength = 8;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  static const int maxNameLength = 50;
  
  // Email Regex
  static final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  
  // Password Requirements
  static const String passwordRequirements = 'Password must contain at least 8 characters';
  
  // Default Values
  static const String defaultAvatar = 'https://via.placeholder.com/150';
}

class ApiEndpoints {
  // Base paths
  static const String auth = '/auth';
  static const String api = '/api';
  
  // Authentication endpoints
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String logout = '$auth/logout';
  static const String profile = '$auth/profile';
  static const String refreshToken = '$auth/refresh';
  static const String forgotPassword = '$auth/forgot-password';
  static const String resetPassword = '$auth/reset-password';
  static const String changePassword = '$auth/change-password';
  static const String verifyEmail = '$auth/verify-email';
  
  // Story generation endpoints
  static const String generateStory = '$api/generate';
  static const String storyHistory = '$api/stories';
  static const String storyTemplates = '$api/templates';
  static const String storyGenres = '$api/genres';
  static const String templateCategories = '$api/template-categories';
  static const String generateFromTemplate = '$api/generate-from-template';
  static const String saveCustomTemplate = '$api/templates/custom';
  static const String favoriteTemplates = '$api/templates/favorites';
  static const String searchTemplates = '$api/templates/search';
  
  // Image generation endpoints
  static const String generateImage = '$api/generate-image';
  static const String imageHistory = '$api/images';
  static const String imageStyles = '$api/image-styles';
  
  // Caption generation endpoints
  static const String generateCaption = '$api/generate-caption';
  static const String captionHistory = '$api/captions';
  
  // Character endpoints
  static const String characters = '$api/characters';
  static const String createCharacter = '$api/characters';
  
  // User management
  static const String users = '$api/users';
  static const String userProfile = '$api/user/profile';
  static const String userStats = '$api/user/stats';
  
  // Analytics
  static const String analytics = '$api/analytics';
  static const String usage = '$api/usage';
} 