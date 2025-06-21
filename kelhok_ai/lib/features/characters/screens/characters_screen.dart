import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/k_card.dart';
import '../../../shared/widgets/k_button.dart';
import '../../../shared/widgets/k_text_field.dart';

class CharactersScreen extends ConsumerStatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends ConsumerState<CharactersScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _characters = [
    {
      'name': 'Himu',
      'description': 'Professional storyteller with a magical touch',
      'createdAt': '2 days ago',
      'usageCount': 45,
    },
    {
      'name': 'Harry Potter',
      'description': 'Young wizard character with incredible powers',
      'createdAt': '1 week ago',
      'usageCount': 12,
    },
    {
      'name': 'Wonder Woman',
      'description': 'Powerful superhero with compassion and strength',
      'createdAt': '2 weeks ago',
      'usageCount': 8,
    },
    {
      'name': 'Sherlock Holmes',
      'description': 'Brilliant detective with sharp observation skills',
      'createdAt': '3 weeks ago',
      'usageCount': 25,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Characters',
          style: AppTextStyles.headingMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Create new character
            },
            icon: Icon(
              Icons.add,
              color: AppColors.karigorGold,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          children: [
            _buildSearchField(),
            SizedBox(height: AppSizes.lg),
            _buildCharacterLimit(),
            SizedBox(height: AppSizes.lg),
            Expanded(child: _buildCharactersList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return KSearchField(
      controller: _searchController,
      hintText: AppStrings.searchCharacters,
      onChanged: (value) {
        // Filter characters
      },
    );
  }

  Widget _buildCharacterLimit() {
    return KCard(
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.info,
            size: 20,
          ),
          SizedBox(width: AppSizes.sm),
          Text(
            'Character Limit: ${_characters.length}/5',
            style: AppTextStyles.bodyMedium,
          ),
          const Spacer(),
          if (_characters.length < 5)
            KButton(
              text: 'Create New',
              type: KButtonType.outline,
              size: KButtonSize.small,
              onPressed: () {
                // Create new character
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCharactersList() {
    return ListView.builder(
      itemCount: _characters.length,
      itemBuilder: (context, index) {
        final character = _characters[index];
        return Padding(
          padding: EdgeInsets.only(bottom: AppSizes.md),
          child: _buildCharacterCard(character),
        );
      },
    );
  }

  Widget _buildCharacterCard(Map<String, dynamic> character) {
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.karigorGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Icon(
                  Icons.person,
                  color: AppColors.karigorGold,
                  size: 24,
                ),
              ),
              SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character['name'],
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSizes.xs),
                    Text(
                      character['description'],
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: AppColors.quaternaryText,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 16),
                        SizedBox(width: AppSizes.sm),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 16, color: AppColors.error),
                        SizedBox(width: AppSizes.sm),
                        Text('Delete', style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    // Edit character
                  } else if (value == 'delete') {
                    // Delete character
                  }
                },
              ),
            ],
          ),
          SizedBox(height: AppSizes.md),
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.schedule,
                label: 'Created: ${character['createdAt']}',
              ),
              SizedBox(width: AppSizes.md),
              _buildInfoChip(
                icon: Icons.trending_up,
                label: 'Used: ${character['usageCount']} times',
              ),
            ],
          ),
          SizedBox(height: AppSizes.md),
          Row(
            children: [
              Expanded(
                child: KButton(
                  text: 'Use Character',
                  type: KButtonType.secondary,
                  size: KButtonSize.small,
                  onPressed: () {
                    // Use character in story generation
                  },
                ),
              ),
              SizedBox(width: AppSizes.sm),
              KButton(
                text: 'Test',
                type: KButtonType.outline,
                size: KButtonSize.small,
                onPressed: () {
                  // Test character
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.glassBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppSizes.radiusXs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: AppColors.quaternaryText,
          ),
          SizedBox(width: AppSizes.xs),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.quaternaryText,
            ),
          ),
        ],
      ),
    );
  }
} 