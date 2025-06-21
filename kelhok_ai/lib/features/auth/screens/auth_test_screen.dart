import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/k_button.dart';
import '../../../shared/widgets/k_card.dart';
import '../providers/simple_auth_provider.dart';

class AuthTestScreen extends ConsumerWidget {
  const AuthTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(simpleAuthProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Authentication Test',
          style: AppTextStyles.headingMedium,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Test Credentials',
                style: AppTextStyles.headingLarge,
              ),
              SizedBox(height: AppSizes.sm),
              Text(
                'Use these test credentials to login and test different user roles:',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              SizedBox(height: AppSizes.xl),
              _buildTestUser(
                context,
                ref,
                title: '1. General User',
                email: 'test@karigorai.com',
                password: 'TestPassword123!',
                role: 'general_user',
                userId: '8',
                token: 'z3H5_XpzxxTP9Sn8ffGlaSsPhmPi-z3uncoUCDxaXuA',
                authState: authState,
              ),
              SizedBox(height: AppSizes.md),
              _buildTestUser(
                context,
                ref,
                title: '2. Super Admin',
                email: 'admin@karigorai.com',
                password: 'AdminPassword123!',
                role: 'super_admin',
                userId: '9',
                token: '9TlR9cGRYEstArsJ4mGIxNU-albVgsJQKfL75QoU3hU',
                authState: authState,
              ),
              SizedBox(height: AppSizes.md),
              _buildTestUser(
                context,
                ref,
                title: '3. Organization User',
                email: 'demo@karigorai.com',
                password: 'DemoPassword123!',
                role: 'organization_user',
                userId: '10',
                token: '2CAB2orSbxHTJ8GPcMNPl4TRjiIIPgLTLFllLPUbrYg',
                authState: authState,
              ),
              SizedBox(height: AppSizes.xl),
              if (authState.isAuthenticated) ...[
                KCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current User',
                        style: AppTextStyles.headingMedium,
                      ),
                      SizedBox(height: AppSizes.md),
                      _buildInfoRow('Name:', authState.user?.fullName ?? 'N/A'),
                      _buildInfoRow('Email:', authState.user?.email ?? 'N/A'),
                      _buildInfoRow('Role:', authState.user?.role ?? 'N/A'),
                      _buildInfoRow('User ID:', authState.user?.id?.toString() ?? 'N/A'),
                      _buildInfoRow('Verified:', authState.user?.isEmailVerified?.toString() ?? 'N/A'),
                      _buildInfoRow('Provider:', authState.user?.simpleAuthProvider ?? 'N/A'),
                      if (authState.user?.organizationId != null)
                        _buildInfoRow('Organization:', authState.user!.organizationId.toString()),
                      SizedBox(height: AppSizes.md),
                      KButton(
                        text: 'Logout',
                        onPressed: () async {
                          await ref.read(simpleAuthProvider.notifier).logout();
                        },
                        type: KButtonType.outline,
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: AppSizes.xl),
              KCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'API Testing Info',
                      style: AppTextStyles.headingMedium,
                    ),
                    SizedBox(height: AppSizes.md),
                    Text(
                      'Base URL: http://localhost:8000',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontFamily: 'monospace',
                        color: AppColors.secondaryText,
                      ),
                    ),
                    SizedBox(height: AppSizes.sm),
                    Text(
                      'Use the session tokens above for direct API testing if needed.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestUser(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String email,
    required String password,
    required String role,
    required String userId,
    required String token,
    required SimpleAuthState authState,
  }) {
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSizes.sm),
          _buildInfoRow('Email:', email),
          _buildInfoRow('Password:', password),
          _buildInfoRow('Role:', role),
          _buildInfoRow('User ID:', userId),
          SizedBox(height: AppSizes.sm),
          Text(
            'Session Token:',
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSizes.xs),
          Container(
            padding: EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              color: AppColors.glassBackground.withOpacity(0.5),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Text(
              token,
              style: AppTextStyles.bodySmall.copyWith(
                fontFamily: 'monospace',
                color: AppColors.secondaryText,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: AppSizes.md),
          KButton(
            text: authState.isLoading ? 'Logging in...' : 'Login as ${role.replaceAll('_', ' ').toUpperCase()}',
            onPressed: authState.isLoading 
              ? null 
              : () => _loginAsTestUser(ref, email, password),
            isLoading: authState.isLoading,
            type: KButtonType.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryText,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                fontFamily: label.contains('Token') || label.contains('ID') ? 'monospace' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loginAsTestUser(WidgetRef ref, String email, String password) async {
    try {
      await ref.read(simpleAuthProvider.notifier).login(email, password);
    } catch (e) {
      // Error handling is done in the provider
      print('Login error: $e');
    }
  }
} 