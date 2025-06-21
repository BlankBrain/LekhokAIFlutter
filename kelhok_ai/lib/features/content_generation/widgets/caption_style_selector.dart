import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_constants.dart';
import '../models/caption_generation_models.dart';

class CaptionStyleSelector extends StatelessWidget {
  final String selectedStyle;
  final Function(String) onStyleChanged;

  const CaptionStyleSelector({
    Key? key,
    required this.selectedStyle,
    required this.onStyleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Grid of style options
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemCount: CaptionStyle.values.length,
          itemBuilder: (context, index) {
            final style = CaptionStyle.values[index];
            final isSelected = selectedStyle == style.id;
            
            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onStyleChanged(style.id);
              },
              child: AnimatedContainer(
                duration: AppAnimations.fast,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.info.withOpacity(0.1)
                      : AppColors.glassBackground,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(
                    color: isSelected 
                        ? AppColors.info
                        : AppColors.glassBorder,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.info.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.md),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Style icon
                      Container(
                        padding: EdgeInsets.all(AppSizes.sm),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.info.withOpacity(0.2)
                              : AppColors.glassBorder.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        ),
                        child: Icon(
                          _getStyleIcon(style),
                          color: isSelected ? AppColors.info : AppColors.secondaryText,
                          size: 24,
                        ),
                      ),
                      SizedBox(height: AppSizes.sm),
                      
                      // Style name
                      Text(
                        style.name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected 
                              ? AppColors.info 
                              : AppColors.primaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSizes.xs),
                      
                      // Style description
                      Text(
                        style.description,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.secondaryText,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        
        SizedBox(height: AppSizes.md),
        
        // Selected style info
        if (selectedStyle.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(
                color: AppColors.info.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSizes.sm),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Icon(
                    _getStyleIcon(_getSelectedStyle()),
                    color: AppColors.info,
                    size: 20,
                  ),
                ),
                SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected: ${_getSelectedStyle().name}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.info,
                        ),
                      ),
                      SizedBox(height: AppSizes.xs),
                      Text(
                        _getSelectedStyle().description,
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
        ],
      ],
    );
  }

  CaptionStyle _getSelectedStyle() {
    return CaptionStyle.values.firstWhere(
      (style) => style.id == selectedStyle,
      orElse: () => CaptionStyle.descriptive,
    );
  }

  IconData _getStyleIcon(CaptionStyle style) {
    switch (style) {
      case CaptionStyle.descriptive:
        return Icons.description_outlined;
      case CaptionStyle.narrative:
        return Icons.auto_stories_outlined;
      case CaptionStyle.poetic:
        return Icons.format_quote_outlined;
      case CaptionStyle.humorous:
        return Icons.sentiment_very_satisfied_outlined;
      case CaptionStyle.technical:
        return Icons.engineering_outlined;
      case CaptionStyle.emotional:
        return Icons.favorite_outline;
    }
  }
} 