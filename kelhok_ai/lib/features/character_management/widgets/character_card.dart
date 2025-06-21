import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/glassmorphic_container.dart';
import '../models/character_models.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final bool isListView;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onTap,
    required this.onFavoriteToggle,
    this.isListView = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isListView) {
      return _buildListCard();
    }
    return _buildGridCard();
  }

  Widget _buildGridCard() {
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphicContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with avatar and favorite
            Row(
              children: [
                _buildAvatar(),
                const Spacer(),
                _buildFavoriteButton(),
              ],
            ),
            
            const SizedBox(height: AppSizes.sm),
            
            // Character name
            Text(
              character.name,
              style: AppTextStyles.headingSmall.copyWith(
                color: AppColors.primaryText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: AppSizes.xs),
            
            // Character description
            Text(
              character.description,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.secondaryText,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const Spacer(),
            
            // Character details
            _buildCharacterDetails(),
            
            const SizedBox(height: AppSizes.sm),
            
            // Tags
            _buildTags(),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard() {
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphicContainer(
        child: Row(
          children: [
            _buildAvatar(),
            
            const SizedBox(width: AppSizes.md),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          character.name,
                          style: AppTextStyles.headingSmall.copyWith(
                            color: AppColors.primaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildFavoriteButton(),
                    ],
                  ),
                  
                  const SizedBox(height: AppSizes.xs),
                  
                  Text(
                    character.description,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.secondaryText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: AppSizes.sm),
                  
                  Row(
                    children: [
                      Expanded(child: _buildCharacterDetails()),
                      const SizedBox(width: AppSizes.sm),
                      _buildTags(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: isListView ? 60 : 50,
      height: isListView ? 60 : 50,
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
          width: 2,
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
    );
  }

  Widget _buildDefaultAvatar() {
    return Center(
      child: Text(
        character.name.isNotEmpty ? character.name[0].toUpperCase() : '?',
        style: AppTextStyles.headingMedium.copyWith(
          color: AppColors.karigorGold,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return GestureDetector(
      onTap: onFavoriteToggle,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.xs),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: character.isFavorite
              ? AppColors.karigorGold.withOpacity(0.2)
              : Colors.transparent,
        ),
        child: Icon(
          character.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: character.isFavorite 
              ? AppColors.karigorGold
              : AppColors.secondaryText,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildCharacterDetails() {
    final details = <String>[];
    
    if (character.personality.archetype != null) {
      details.add(character.personality.archetype!.displayName);
    }
    
    if (character.background.occupation != null && character.background.occupation!.isNotEmpty) {
      details.add(character.background.occupation!);
    }
    
    if (character.appearance.age != null) {
      details.add('Age ${character.appearance.age}');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: details.take(isListView ? 3 : 2).map((detail) => Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.karigorGold.withOpacity(0.6),
              ),
            ),
            const SizedBox(width: AppSizes.xs),
            Expanded(
              child: Text(
                detail,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.secondaryText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildTags() {
    final tags = character.tags.take(isListView ? 3 : 2).toList();
    
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Wrap(
      spacing: AppSizes.xs,
      runSpacing: AppSizes.xs,
      children: tags.map((tag) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.xs,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.karigorGold.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusXs),
          border: Border.all(
            color: AppColors.karigorGold.withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: Text(
          tag,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.karigorGold,
            fontSize: 10,
          ),
        ),
      )).toList(),
    );
  }
}