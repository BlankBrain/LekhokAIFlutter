import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/k_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.technoNavy,
              AppColors.primaryBackground,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              _buildAppBar(),
              _buildWelcomeSection(),
              _buildQuickActions(),
              _buildRecentStories(),
              _buildAnalytics(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      floating: true,
      title: Text(
        AppStrings.appName,
        style: AppTextStyles.headingMedium.copyWith(
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Handle notifications
          },
          icon: const Icon(
            Icons.notifications_outlined,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            // Handle profile
          },
          icon: const Icon(
            Icons.person_outline,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, User!',
              style: AppTextStyles.headingLarge.copyWith(
                color: Colors.white,
              ),
            ),
            SizedBox(height: AppSizes.sm),
            Text(
              'Ready to create amazing stories today?',
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: AppTextStyles.headingMedium.copyWith(
                color: AppColors.primaryText,
              ),
            ),
            SizedBox(height: AppSizes.md),
            Row(
              children: [
                Expanded(
                  child: KQuickActionCard(
                    title: 'Generate\nStories',
                    icon: Icons.edit_note,
                    onTap: () {
                      // Navigate to story generation
                    },
                  ),
                ),
                SizedBox(width: AppSizes.md),
                Expanded(
                  child: KQuickActionCard(
                    title: 'Manage\nCharacters',
                    icon: Icons.people,
                    onTap: () {
                      // Navigate to characters
                    },
                  ),
                ),
                SizedBox(width: AppSizes.md),
                Expanded(
                  child: KQuickActionCard(
                    title: 'Generate\nCaption',
                    icon: Icons.image,
                    onTap: () {
                      // Navigate to caption generation
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentStories() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Stories',
                  style: AppTextStyles.headingMedium,
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to history
                  },
                  child: Text(
                    'View All',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.karigorGold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: AppSizes.md),
                  child: KStoryCard(
                    title: 'A brave cat story that changes everything',
                    characterName: 'Himu',
                    preview: 'Once upon a time in a magical kingdom, there lived a brave cat who had extraordinary powers...',
                    timeAgo: '2 hours ago',
                    isFavorite: index == 0,
                    onTap: () {
                      // View story details
                    },
                    onFavorite: () {
                      // Toggle favorite
                    },
                    onShare: () {
                      // Share story
                    },
                    onDelete: () {
                      // Delete story
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalytics() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Analytics',
              style: AppTextStyles.headingMedium,
            ),
            SizedBox(height: AppSizes.md),
            Row(
              children: [
                Expanded(
                  child: KCard(
                    child: Column(
                      children: [
                        Text(
                          '150',
                          style: AppTextStyles.headingLarge.copyWith(
                            color: AppColors.karigorGold,
                          ),
                        ),
                        SizedBox(height: AppSizes.xs),
                        Text(
                          'Stories Created',
                          style: AppTextStyles.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.md),
                Expanded(
                  child: KCard(
                    child: Column(
                      children: [
                        Text(
                          '5',
                          style: AppTextStyles.headingLarge.copyWith(
                            color: AppColors.karigorGold,
                          ),
                        ),
                        SizedBox(height: AppSizes.xs),
                        Text(
                          'Characters',
                          style: AppTextStyles.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.xxl),
          ],
        ),
      ),
    );
  }
} 