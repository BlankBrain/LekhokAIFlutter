import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/k_card.dart';
import '../../../shared/widgets/k_button.dart';
import "../../../features/auth/providers/simple_auth_provider.dart";

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(simpleAuthProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, ref),
          _buildProfileHeader(user),
          _buildStatsSection(),
          _buildSettingsSection(context, ref),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      backgroundColor: AppColors.technoNavy,
      elevation: 0,
      expandedHeight: 120,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Profile',
          style: AppTextStyles.headingMedium.copyWith(
            color: Colors.white,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.technoNavy,
                AppColors.karigorGold,
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _showLogoutDialog(context, ref);
          },
          icon: const Icon(
            Icons.logout_outlined,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.technoNavy,
        child: Container(
          padding: EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSizes.radiusLg),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: AppSizes.md),
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.karigorGold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: AppColors.karigorGold,
                        width: 3,
                      ),
                    ),
                    child: user?.profilePictureUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              user!.profilePictureUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 50,
                                  color: AppColors.karigorGold,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors.karigorGold,
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.karigorGold,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: AppColors.primaryBackground,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.md),
              Text(
                user?.fullName ?? 'User',
                style: AppTextStyles.headingMedium,
              ),
              SizedBox(height: AppSizes.xs),
              Text(
                user?.email ?? 'user@example.com',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              SizedBox(height: AppSizes.sm),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.karigorGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusXs),
                ),
                child: Text(
                  _getRoleDisplayName(user?.role),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.karigorGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (user?.isEmailVerified == true) ...[
                SizedBox(height: AppSizes.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified,
                      size: 16,
                      color: AppColors.success,
                    ),
                    SizedBox(width: AppSizes.xs),
                    Text(
                      'Email Verified',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getRoleDisplayName(String? role) {
    switch (role) {
      case 'super_admin':
        return 'Super Admin';
      case 'organization_user':
        return 'Organization User';
      case 'general_user':
      default:
        return 'General User';
    }
  }

  Widget _buildStatsSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Statistics',
              style: AppTextStyles.headingMedium,
            ),
            SizedBox(height: AppSizes.md),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.auto_stories,
                    title: 'Stories',
                    value: '0',
                    subtitle: 'Created',
                  ),
                ),
                SizedBox(width: AppSizes.md),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.people,
                    title: 'Characters',
                    value: '0',
                    subtitle: 'Active',
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.favorite,
                    title: 'Favorites',
                    value: '0',
                    subtitle: 'Saved',
                  ),
                ),
                SizedBox(width: AppSizes.md),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.share,
                    title: 'Shared',
                    value: '0',
                    subtitle: 'Stories',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return KCard(
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: AppColors.karigorGold,
          ),
          SizedBox(height: AppSizes.sm),
          Text(
            value,
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.karigorGold,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: AppTextStyles.headingMedium,
            ),
            SizedBox(height: AppSizes.md),
            KCard(
              child: Column(
                children: [
                  _buildSettingsItem(
                    icon: Icons.edit_outlined,
                    title: 'Edit Profile',
                    subtitle: 'Update your personal information',
                    onTap: () {
                      // Navigate to edit profile
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    icon: Icons.lock_outlined,
                    title: 'Change Password',
                    subtitle: 'Update your password',
                    onTap: () {
                      // Navigate to change password
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Manage your notification preferences',
                    onTap: () {
                      // Navigate to notifications
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'Get help and contact support',
                    onTap: () {
                      // Navigate to help
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    subtitle: 'Sign out of your account',
                    onTap: () {
                      _showLogoutDialog(context, ref);
                    },
                    isDestructive: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDestructive 
                  ? AppColors.error.withOpacity(0.1)
                  : AppColors.karigorGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Icon(
                icon,
                color: isDestructive ? AppColors.error : AppColors.karigorGold,
                size: 20,
              ),
            ),
            SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? AppColors.error : null,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.quaternaryText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: AppColors.glassBorder,
      indent: AppSizes.md,
      endIndent: AppSizes.md,
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          title: Text(
            'Logout',
            style: AppTextStyles.headingMedium,
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ),
            KButton(
              text: 'Logout',
              onPressed: () async {
                Navigator.of(context).pop();
                await ref.read(simpleAuthProvider.notifier).logout();
              },
              type: KButtonType.primary,
            ),
          ],
        );
      },
    );
  }
} 