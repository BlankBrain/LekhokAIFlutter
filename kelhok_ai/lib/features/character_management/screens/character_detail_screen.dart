import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/glassmorphic_container.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../models/character_models.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailScreen({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCharacterHeader(),
                      const SizedBox(height: AppSizes.lg),
                      _buildBasicInfo(),
                      const SizedBox(height: AppSizes.md),
                      _buildAppearanceInfo(),
                      const SizedBox(height: AppSizes.md),
                      _buildPersonalityInfo(),
                      const SizedBox(height: AppSizes.md),
                      _buildBackgroundInfo(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              character.name,
              style: AppTextStyles.headingLarge.copyWith(
                color: AppColors.primaryText,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Implement edit functionality
            },
            icon: Icon(
              Icons.edit,
              color: AppColors.karigorGold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterHeader() {
    return GlassmorphicContainer(
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.karigorGold.withOpacity(0.3),
                  AppColors.karigorGold.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: AppColors.karigorGold.withOpacity(0.5),
                width: 3,
              ),
            ),
            child: character.avatarUrl != null
                ? ClipOval(
                    child: Image.network(
                      character.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
                    ),
                  )
                : _buildDefaultAvatar(),
          ),
          
          const SizedBox(height: AppSizes.md),
          
          // Name and description
          Text(
            character.name,
            style: AppTextStyles.headingLarge.copyWith(
              color: AppColors.primaryText,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppSizes.sm),
          
          Text(
            character.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppSizes.md),
          
          // Tags
          if (character.tags.isNotEmpty)
            Wrap(
              spacing: AppSizes.sm,
              runSpacing: AppSizes.sm,
              children: character.tags.map((tag) => Container(
                padding: const EdgeInsets.symmetric(
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
                  tag,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.karigorGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Center(
      child: Text(
        character.name.isNotEmpty ? character.name[0].toUpperCase() : '?',
        style: AppTextStyles.headingLarge.copyWith(
          color: AppColors.karigorGold,
          fontWeight: FontWeight.bold,
          fontSize: 36,
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return GlassmorphicContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          
          _buildInfoRow('Created', _formatDate(character.createdAt)),
          _buildInfoRow('Last Updated', _formatDate(character.updatedAt)),
          _buildInfoRow('Favorite', character.isFavorite ? 'Yes' : 'No'),
        ],
      ),
    );
  }

  Widget _buildAppearanceInfo() {
    final appearance = character.appearance;
    
    return GlassmorphicContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appearance',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          
          if (appearance.gender != null)
            _buildInfoRow('Gender', appearance.gender!),
          if (appearance.age != null)
            _buildInfoRow('Age', '${appearance.age} years'),
          if (appearance.height != null)
            _buildInfoRow('Height', appearance.height!),
          if (appearance.build != null)
            _buildInfoRow('Build', appearance.build!),
          if (appearance.hairColor != null)
            _buildInfoRow('Hair Color', appearance.hairColor!),
          if (appearance.hairStyle != null)
            _buildInfoRow('Hair Style', appearance.hairStyle!),
          if (appearance.eyeColor != null)
            _buildInfoRow('Eye Color', appearance.eyeColor!),
          if (appearance.skinTone != null)
            _buildInfoRow('Skin Tone', appearance.skinTone!),
          if (appearance.distinctiveFeatures.isNotEmpty)
            _buildInfoRow('Distinctive Features', appearance.distinctiveFeatures.join(', ')),
          if (appearance.clothing != null)
            _buildInfoRow('Clothing', appearance.clothing!),
        ],
      ),
    );
  }

  Widget _buildPersonalityInfo() {
    final personality = character.personality;
    
    return GlassmorphicContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personality',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          
          if (personality.archetype != null)
            _buildInfoRow('Archetype', personality.archetype!.displayName),
          if (personality.traits.isNotEmpty)
            _buildInfoRow('Traits', personality.traits.join(', ')),
          if (personality.strengths.isNotEmpty)
            _buildInfoRow('Strengths', personality.strengths.join(', ')),
          if (personality.weaknesses.isNotEmpty)
            _buildInfoRow('Weaknesses', personality.weaknesses.join(', ')),
          if (personality.fears.isNotEmpty)
            _buildInfoRow('Fears', personality.fears.join(', ')),
          if (personality.motivations.isNotEmpty)
            _buildInfoRow('Motivations', personality.motivations.join(', ')),
          if (personality.speechPattern != null)
            _buildInfoRow('Speech Pattern', personality.speechPattern!),
          if (personality.mannerisms != null)
            _buildInfoRow('Mannerisms', personality.mannerisms!),
        ],
      ),
    );
  }

  Widget _buildBackgroundInfo() {
    final background = character.background;
    
    return GlassmorphicContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Background',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          
          if (background.occupation != null)
            _buildInfoRow('Occupation', background.occupation!),
          if (background.origin != null)
            _buildInfoRow('Origin', background.origin!),
          if (background.education != null)
            _buildInfoRow('Education', background.education!),
          if (background.family != null)
            _buildInfoRow('Family', background.family!),
          if (background.relationships.isNotEmpty)
            _buildInfoRow('Relationships', background.relationships.join(', ')),
          if (background.pastExperiences.isNotEmpty)
            _buildInfoRow('Past Experiences', background.pastExperiences.join(', ')),
          if (background.currentGoal != null)
            _buildInfoRow('Current Goal', background.currentGoal!),
          if (background.backstory != null) ...[
            const SizedBox(height: AppSizes.sm),
            Text(
              'Backstory',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              background.backstory!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 