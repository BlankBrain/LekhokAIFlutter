import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/story_template_models.dart';
import '../../../core/constants/app_constants.dart';

class TemplateCard extends StatelessWidget {
  final StoryTemplate template;
  final VoidCallback onTap;
  final bool isSelected;
  final bool showFavoriteButton;

  const TemplateCard({
    super.key,
    required this.template,
    required this.onTap,
    this.isSelected = false,
    this.showFavoriteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: isSelected
              ? Border.all(color: AppConstants.primaryColor, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildContent(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.radiusMedium),
          topRight: Radius.circular(AppConstants.radiusMedium),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getGradientColors(),
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: TemplatePatternPainter(),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCategoryChip(),
                    if (showFavoriteButton) _buildFavoriteButton(),
                  ],
                ),
                const Spacer(),
                _buildDifficultyIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              template.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppConstants.textPrimaryColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppConstants.spacingXSmall),
            Text(
              template.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppConstants.textSecondaryColor,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            _buildGenreTags(),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingSmall),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppConstants.radiusMedium),
          bottomRight: Radius.circular(AppConstants.radiusMedium),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildEstimatedLength(),
          _buildPremiumBadge(),
        ],
      ),
    );
  }

  Widget _buildCategoryChip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingXSmall,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      child: Text(
        template.category.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppConstants.textPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      child: Icon(
        Icons.favorite_border,
        size: 16,
        color: AppConstants.textSecondaryColor,
      ),
    );
  }

  Widget _buildDifficultyIndicator() {
    final difficultyLevel = _getDifficultyLevel();
    final difficultyColor = _getDifficultyColor();

    return Row(
      children: [
        Text(
          template.difficulty.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(width: AppConstants.spacingXSmall),
        ...List.generate(3, (index) {
          return Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(right: 2),
            decoration: BoxDecoration(
              color: index < difficultyLevel
                  ? difficultyColor
                  : Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildGenreTags() {
    final displayGenres = template.genres.take(2).toList();
    
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        ...displayGenres.map((genre) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          ),
          child: Text(
            genre,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppConstants.primaryColor,
            ),
          ),
        )),
        if (template.genres.length > 2)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Text(
              '+${template.genres.length - 2}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppConstants.textSecondaryColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEstimatedLength() {
    return Row(
      children: [
        Icon(
          Icons.schedule,
          size: 12,
          color: AppConstants.textSecondaryColor,
        ),
        const SizedBox(width: 4),
        Text(
          '${template.estimatedLength}w',
          style: TextStyle(
            fontSize: 10,
            color: AppConstants.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumBadge() {
    if (!template.isPremium) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppConstants.accentColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      child: const Text(
        'PRO',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  List<Color> _getGradientColors() {
    switch (template.category) {
      case 'adventure':
        return [Colors.orange[400]!, Colors.deepOrange[600]!];
      case 'romance':
        return [Colors.pink[300]!, Colors.red[400]!];
      case 'mystery':
        return [Colors.indigo[400]!, Colors.purple[600]!];
      case 'fantasy':
        return [Colors.purple[400]!, Colors.deepPurple[600]!];
      case 'sci-fi':
        return [Colors.cyan[400]!, Colors.blue[600]!];
      case 'horror':
        return [Colors.grey[600]!, Colors.grey[800]!];
      default:
        return [AppConstants.primaryColor, AppConstants.primaryColor.withOpacity(0.7)];
    }
  }

  int _getDifficultyLevel() {
    switch (template.difficulty) {
      case 'easy':
        return 1;
      case 'medium':
        return 2;
      case 'hard':
        return 3;
      default:
        return 2;
    }
  }

  Color _getDifficultyColor() {
    switch (template.difficulty) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}

class TemplatePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    // Draw a subtle geometric pattern
    final spacing = 20.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 