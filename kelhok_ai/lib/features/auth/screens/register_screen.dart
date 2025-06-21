import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/k_button.dart';
import '../../../shared/widgets/k_card.dart';
import '../../../shared/widgets/k_text_field.dart';
import '../providers/simple_auth_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _organizationController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    _organizationController.dispose();
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

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value != _passwordController.text) {
      return AppStrings.passwordsDoNotMatch;
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.usernameRequired;
    }
    if (value.length < AppConstants.minUsernameLength) {
      return AppStrings.usernameTooShort;
    }
    if (value.length > AppConstants.maxUsernameLength) {
      return 'Username must be less than ${AppConstants.maxUsernameLength} characters';
    }
    return null;
  }

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fullNameRequired;
    }
    if (value.length > AppConstants.maxNameLength) {
      return 'Full name must be less than ${AppConstants.maxNameLength} characters';
    }
    return null;
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(simpleAuthProvider.notifier).register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        username: _usernameController.text.trim(),
        fullName: _fullNameController.text.trim(),
        organizationName: _organizationController.text.trim().isEmpty 
          ? null 
          : _organizationController.text.trim(),
      );
      
      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.registerSuccess),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 4),
          ),
        );
        
        // Navigate back to login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(simpleAuthProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: AppSizes.xl),
              _buildRegisterForm(authState),
              SizedBox(height: AppSizes.lg),
              _buildLoginLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.createAccount,
          style: AppTextStyles.headingLarge.copyWith(
            color: AppColors.primaryText,
          ),
        ),
        SizedBox(height: AppSizes.sm),
        Text(
          AppStrings.registerDescription,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm(SimpleAuthState authState) {
    return KCard(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            KTextField(
              controller: _fullNameController,
              label: AppStrings.fullName,
              hintText: AppStrings.fullNameHint,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              validator: _validateFullName,
              prefixIcon: Icon(Icons.person_outline),
            ),
            SizedBox(height: AppSizes.md),
            KTextField(
              controller: _usernameController,
              label: AppStrings.username,
              hintText: AppStrings.usernameHint,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              validator: _validateUsername,
              prefixIcon: Icon(Icons.alternate_email_outlined),
            ),
            SizedBox(height: AppSizes.md),
            KTextField(
              controller: _emailController,
              label: AppStrings.email,
              hintText: AppStrings.emailHint,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: _validateEmail,
              prefixIcon: Icon(Icons.email_outlined),
            ),
            SizedBox(height: AppSizes.md),
            KTextField(
              controller: _organizationController,
              label: AppStrings.organizationName,
              hintText: AppStrings.organizationNameHint,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              prefixIcon: Icon(Icons.business_outlined),
            ),
            SizedBox(height: AppSizes.md),
            KTextField(
              controller: _passwordController,
              label: AppStrings.password,
              hintText: AppStrings.passwordHint,
              obscureText: !_isPasswordVisible,
              textInputAction: TextInputAction.next,
              validator: _validatePassword,
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                icon: Icon(
                  _isPasswordVisible 
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                  color: AppColors.secondaryText,
                ),
              ),
            ),
            SizedBox(height: AppSizes.md),
            KTextField(
              controller: _confirmPasswordController,
              label: AppStrings.confirmPassword,
              hintText: AppStrings.confirmPasswordHint,
              obscureText: !_isConfirmPasswordVisible,
              textInputAction: TextInputAction.done,
              validator: _validateConfirmPassword,
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
                icon: Icon(
                  _isConfirmPasswordVisible 
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                  color: AppColors.secondaryText,
                ),
              ),
              onSubmitted: (_) => _handleRegister(),
            ),
            SizedBox(height: AppSizes.sm),
            Text(
              AppConstants.passwordRequirements,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.tertiaryText,
              ),
            ),
            SizedBox(height: AppSizes.xl),
            KButton(
              text: AppStrings.createAccount,
              onPressed: authState.isLoading ? null : _handleRegister,
              isLoading: authState.isLoading,
              type: KButtonType.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.haveAccount + ' ',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            child: Text(
              AppStrings.login,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.karigorGold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 