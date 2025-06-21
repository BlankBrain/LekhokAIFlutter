import 'package:flutter/material.dart';
import '../models/story_template_models.dart';
import '../../../core/constants/app_constants.dart';

class TemplatePreviewCard extends StatelessWidget {
  final StoryTemplate template;
  final TemplateCustomization customization;

  const TemplatePreviewCard({
    super.key,
    required this.template,
    required this.customization,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: AppColors.glassBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Template header with image and title
          _buildTemplateHeader(),
          
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Template description
                Text(
                  template.description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                
                const SizedBox(height: AppSizes.md),
                
                // Preview content
                _buildPreviewContent(),
                
                const SizedBox(height: AppSizes.md),
                
                // Customization summary
                _buildCustomizationSummary(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateHeader() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getCategoryColor().withOpacity(0.8),
            _getCategoryColor().withOpacity(0.6),
          ],
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusMd),
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSizes.radiusMd),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getCategoryIcon(),
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Text(
                      template.category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        template.difficulty.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSizes.sm),
                
                Text(
                  template.name,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: AppSizes.sm),
                
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: template.tags.take(4).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '#$tag',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.primaryBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(
          color: AppColors.glassBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preview',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            template.previewContent,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primaryText,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomizationSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Customization',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.secondaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildCustomizationChip(
              'Genres',
              customization.selectedGenres.isEmpty 
                  ? 'Default' 
                  : customization.selectedGenres.length.toString(),
              Icons.category,
            ),
            _buildCustomizationChip(
              'Tone',
              customization.selectedTone.capitalize(),
              Icons.mood,
            ),
            _buildCustomizationChip(
              'Mood',
              customization.selectedMood.capitalize(),
              Icons.psychology,
            ),
            _buildCustomizationChip(
              'Length',
              '${customization.targetLength}w',
              Icons.text_fields,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomizationChip(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.karigorGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.karigorGold.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.karigorGold,
          ),
          const SizedBox(width: 4),
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.karigorGold,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor() {
    switch (template.category.toLowerCase()) {
      case 'adventure':
        return const Color(0xFF4CAF50);
      case 'romance':
        return const Color(0xFFE91E63);
      case 'mystery':
        return const Color(0xFF9C27B0);
      case 'sci-fi':
        return const Color(0xFF2196F3);
      case 'fantasy':
        return const Color(0xFFFF9800);
      case 'horror':
        return const Color(0xFFD32F2F);
      case 'comedy':
        return const Color(0xFFFFC107);
      default:
        return AppColors.karigorGold;
    }
  }

  IconData _getCategoryIcon() {
    switch (template.category.toLowerCase()) {
      case 'adventure':
        return Icons.explore;
      case 'romance':
        return Icons.favorite;
      case 'mystery':
        return Icons.search;
      case 'sci-fi':
        return Icons.rocket_launch;
      case 'fantasy':
        return Icons.auto_awesome;
      case 'horror':
        return Icons.dark_mode;
      case 'comedy':
        return Icons.sentiment_very_satisfied;
      default:
        return Icons.book;
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
} 