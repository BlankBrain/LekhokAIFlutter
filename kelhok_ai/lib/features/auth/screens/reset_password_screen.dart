import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/k_button.dart';
import '../../../shared/widgets/k_card.dart';
import '../../../shared/widgets/k_text_field.dart';
import '../providers/simple_auth_provider.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateToken(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.resetTokenRequired;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.newPasswordRequired;
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

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(simpleAuthProvider.notifier).resetPassword(
        token: _tokenController.text.trim(),
        newPassword: _passwordController.text,
      );
      
      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.passwordResetSuccess),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 4),
          ),
        );
        
        // Navigate to login
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
              SizedBox(height: AppSizes.xl),
              _buildHeader(),
              SizedBox(height: AppSizes.xxl),
              _buildResetPasswordForm(authState),
              SizedBox(height: AppSizes.xl),
              _buildBackToLoginLink(),
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
          AppStrings.resetPassword,
          style: AppTextStyles.headingLarge.copyWith(
            color: AppColors.primaryText,
          ),
        ),
        SizedBox(height: AppSizes.sm),
        Text(
          AppStrings.resetPasswordDescription,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildResetPasswordForm(SimpleAuthState authState) {
    return KCard(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
                         KTextField(
               controller: _tokenController,
               label: 'Reset Token',
               hintText: AppStrings.resetTokenHint,
               keyboardType: TextInputType.text,
               textInputAction: TextInputAction.next,
               validator: _validateToken,
               prefixIcon: Icon(Icons.vpn_key_outlined),
             ),
             SizedBox(height: AppSizes.md),
             KTextField(
               controller: _passwordController,
               label: AppStrings.newPassword,
               hintText: AppStrings.newPasswordHint,
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
              onSubmitted: (_) => _handleResetPassword(),
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
              text: AppStrings.resetPassword,
              onPressed: authState.isLoading ? null : _handleResetPassword,
              isLoading: authState.isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackToLoginLink() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        },
        child: Text(
          AppStrings.backToLogin,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.karigorGold,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
} 