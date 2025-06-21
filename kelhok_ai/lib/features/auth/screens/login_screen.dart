import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../../core/constants/app_constants.dart';
import '../providers/simple_auth_provider.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'package:flutter/foundation.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // Animation controllers
  late AnimationController _backgroundController;
  late AnimationController _heroController;
  late AnimationController _formController;

  // Animations
  late Animation<double> _backgroundAnimation;
  late Animation<double> _heroSlideAnimation;
  late Animation<double> _heroFadeAnimation;
  late Animation<double> _formSlideAnimation;
  late Animation<double> _formFadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Gentle background gradient animation
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );

    // Hero section animation
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _heroSlideAnimation = Tween<double>(begin: -30.0, end: 0.0).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic),
    );
    _heroFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOut),
    );

    // Form animation
    _formController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _formSlideAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic),
    );
    _formFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOut),
    );
  }

  void _startAnimations() {
    _backgroundController.repeat();
    
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _heroController.forward();
    });
    
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _formController.forward();
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _heroController.dispose();
    _formController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailRequired;
    }
    if (!AppConstants.emailRegex.hasMatch(value)) {
      return AppStrings.emailInvalid;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value.length < AppConstants.minPasswordLength) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(simpleAuthProvider.notifier).login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.loginSuccess),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
          ),
        );
      }
    }
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.xs, vertical: AppSizes.xs),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.35),
                  Colors.white.withOpacity(0.25),
                  Colors.white.withOpacity(0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusXl),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            padding: EdgeInsets.all(AppSizes.lg),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(simpleAuthProvider);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: Stack(
        children: [
          // Subtle animated background
          _buildAnimatedBackground(),
          
          // Main content with proper scrolling
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                bottom: keyboardHeight + AppSizes.md,
              ),
              child: Column(
                children: [
                  // Hero section with fixed height
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: _buildHeroSection(),
                  ),
                  
                  // Login form section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.md),
                    child: Column(
                      children: [
                        // Main login card
                        _buildGlassCard(child: _buildLoginForm(authState)),
                        
                        SizedBox(height: AppSizes.sm),
                        
                        // Additional actions (without test credentials)
                        _buildAdditionalActions(),
                        
                        SizedBox(height: AppSizes.md),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: GradientRotation(_backgroundAnimation.value * 0.5 * math.pi),
              colors: [
                const Color(0xFFFF9A8B).withOpacity(0.6), // Softer coral
                const Color(0xFFFEAD5E).withOpacity(0.7), // Softer orange
                const Color(0xFFE6A426).withOpacity(0.8), // Karigor gold
                const Color(0xFF22345C).withOpacity(0.9), // Techno navy
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroSection() {
    return AnimatedBuilder(
      animation: Listenable.merge([_heroSlideAnimation, _heroFadeAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _heroSlideAnimation.value),
          child: Opacity(
            opacity: _heroFadeAnimation.value,
            child: Padding(
              padding: EdgeInsets.all(AppSizes.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo/icon with glassmorphic effect
                  _buildGlassCard(
                    child: Container(
                      width: 80,
                      height: 80,
                      child: Icon(
                        Icons.auto_stories_rounded,
                        size: 40,
                        color: AppColors.technoNavy,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: AppSizes.lg),
                  
                  // Welcome text with different font and better contrast
                  Text(
                    'Welcome to KarigorAI',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: 'SF Pro Display', // iOS system font
                      letterSpacing: -0.5,
                      height: 1.1,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.4),
                          offset: const Offset(0, 3),
                          blurRadius: 6,
                        ),
                        Shadow(
                          color: AppColors.karigorGold.withOpacity(0.3),
                          offset: const Offset(0, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: AppSizes.sm),
                  
                  // Subtitle with different font and enhanced readability
                  Text(
                    'Where stories come to life through AI magic ✨',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.95),
                      fontFamily: 'SF Pro Text', // iOS system font
                      letterSpacing: 0.2,
                      height: 1.3,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginForm(SimpleAuthState authState) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Form header with better contrast
          Text(
            'Sign in to continue',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.technoNavy,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: AppSizes.xs),
          
          Text(
            'Your creative journey awaits',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.technoNavy.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          
          if (kDebugMode) ...[
            SizedBox(height: AppSizes.xs),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.sm,
                vertical: AppSizes.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.karigorGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                border: Border.all(
                  color: AppColors.karigorGold.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                'Dev Mode: Use test@karigorai.com with any password',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.karigorGold,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          
          SizedBox(height: AppSizes.md),
          
          // Email field with better contrast
          _buildGlassTextField(
            controller: _emailController,
            label: AppStrings.email,
            hintText: 'Enter your email address',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: _validateEmail,
            prefixIcon: Icons.email_rounded,
          ),
          
          SizedBox(height: AppSizes.sm),
          
          // Password field
          _buildGlassTextField(
            controller: _passwordController,
            label: AppStrings.password,
            hintText: 'Enter your password',
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.done,
            validator: _validatePassword,
            prefixIcon: Icons.lock_rounded,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              icon: Icon(
                _isPasswordVisible 
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
                color: AppColors.technoNavy.withOpacity(0.7),
              ),
            ),
            onSubmitted: (_) => _handleLogin(),
          ),
          
          SizedBox(height: AppSizes.lg),
          
          // Login button with enhanced design
          GestureDetector(
            onTap: authState.isLoading ? null : _handleLogin,
            child: Container(
              height: AppSizes.buttonHeightLg,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: authState.isLoading 
                    ? [Colors.grey.withOpacity(0.6), Colors.grey.withOpacity(0.4)]
                    : [
                        AppColors.karigorGold,
                        AppColors.karigorGold.withOpacity(0.9),
                        AppColors.karigorGold.withOpacity(0.8),
                      ],
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.karigorGold.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: authState.isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      AppStrings.login,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.25),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
    bool obscureText = false,
    Widget? suffixIcon,
    void Function(String)? onSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              validator: validator,
              obscureText: obscureText,
              onFieldSubmitted: onSubmitted,
              style: TextStyle(
                color: AppColors.technoNavy,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: label,
                hintText: hintText,
                labelStyle: TextStyle(
                  color: AppColors.technoNavy.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
                hintStyle: TextStyle(
                  color: AppColors.technoNavy.withOpacity(0.6),
                ),
                prefixIcon: Icon(
                  prefixIcon,
                  color: AppColors.technoNavy.withOpacity(0.7),
                ),
                suffixIcon: suffixIcon,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.md,
                ),
                errorStyle: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalActions() {
    return Column(
      children: [
        // Forgot password link
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ForgotPasswordScreen(),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.xs,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              AppStrings.forgotPasswordTitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
        
        SizedBox(height: AppSizes.sm),
        
        // Sign up link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },
              child: Text(
                AppStrings.signUp,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.4),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
} 