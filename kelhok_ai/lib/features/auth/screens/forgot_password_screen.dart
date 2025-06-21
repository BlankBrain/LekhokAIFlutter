import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/k_button.dart';
import '../../../shared/widgets/k_card.dart';
import '../../../shared/widgets/k_text_field.dart';
import '../providers/simple_auth_provider.dart';
import 'reset_password_screen.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(simpleAuthProvider.notifier).forgotPassword(
        _emailController.text.trim(),
      );
      
      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.passwordResetSent),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 4),
          ),
        );
        
        // Navigate to reset password screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResetPasswordScreen(),
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
              _buildForgotPasswordForm(authState),
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
          AppStrings.forgotPasswordTitle,
          style: AppTextStyles.headingLarge.copyWith(
            color: AppColors.primaryText,
          ),
        ),
        SizedBox(height: AppSizes.sm),
        Text(
          AppStrings.forgotPasswordDescription,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordForm(SimpleAuthState authState) {
    return KCard(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            KTextField(
              controller: _emailController,
              label: AppStrings.email,
              hintText: AppStrings.emailHint,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: _validateEmail,
              prefixIcon: Icon(Icons.email_outlined),
              onSubmitted: (_) => _handleForgotPassword(),
            ),
            SizedBox(height: AppSizes.xl),
            KButton(
              text: 'Send Reset Link',
              onPressed: authState.isLoading ? null : _handleForgotPassword,
              isLoading: authState.isLoading,
              type: KButtonType.primary,
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