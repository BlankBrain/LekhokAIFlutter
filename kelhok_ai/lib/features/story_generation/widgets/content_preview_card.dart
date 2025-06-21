import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/k_card.dart';

class ContentPreviewCard extends StatefulWidget {
  final String story;
  final String? imagePrompt;
  final VoidCallback? onShare;
  final VoidCallback? onCopy;
  final VoidCallback? onFavorite;

  const ContentPreviewCard({
    Key? key,
    required this.story,
    this.imagePrompt,
    this.onShare,
    this.onCopy,
    this.onFavorite,
  }) : super(key: key);

  @override
  State<ContentPreviewCard> createState() => _ContentPreviewCardState();
}

class _ContentPreviewCardState extends State<ContentPreviewCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.elasticOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: KCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: AppSizes.md),
            _buildStoryContent(),
            if (widget.imagePrompt != null) ...[
              SizedBox(height: AppSizes.md),
              _buildImagePrompt(),
            ],
            SizedBox(height: AppSizes.lg),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(AppSizes.sm),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Icon(
            Icons.check_circle_outline,
            color: AppColors.success,
            size: 20,
          ),
        ),
        SizedBox(width: AppSizes.sm),
        Text(
          'Story Generated',
          style: AppTextStyles.headingMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.success,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            setState(() {
              _isFavorited = !_isFavorited;
            });
            HapticFeedback.lightImpact();
            widget.onFavorite?.call();
          },
          icon: Icon(
            _isFavorited ? Icons.favorite : Icons.favorite_border,
            color: _isFavorited ? AppColors.error : AppColors.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildStoryContent() {
    return Container(
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: AppColors.glassBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_stories,
                color: AppColors.karigorGold,
                size: 20,
              ),
              SizedBox(width: AppSizes.sm),
              Text(
                'Your Story',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.sm),
          Text(
            widget.story,
            style: AppTextStyles.bodyMedium.copyWith(
              height: 1.6,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePrompt() {
    return Container(
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: AppColors.info.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.image_outlined,
                color: AppColors.info,
                size: 20,
              ),
              SizedBox(width: AppSizes.sm),
              Text(
                'Image Prompt',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.sm),
          Text(
            widget.imagePrompt!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.info,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.copy_outlined,
            label: 'Copy',
            onPressed: widget.onCopy,
            color: AppColors.technoNavy,
          ),
        ),
        SizedBox(width: AppSizes.sm),
        Expanded(
          child: _buildActionButton(
            icon: Icons.share_outlined,
            label: 'Share',
            onPressed: widget.onShare,
            color: AppColors.karigorGold,
          ),
        ),
        SizedBox(width: AppSizes.sm),
        Expanded(
          child: _buildActionButton(
            icon: Icons.image_outlined,
            label: 'Generate Image',
            onPressed: () {
              // Navigate to image generation
            },
            color: AppColors.info,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onPressed?.call();
        },
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppSizes.md,
            horizontal: AppSizes.sm,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              SizedBox(height: AppSizes.xs),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 