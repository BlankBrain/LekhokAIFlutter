import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_constants.dart';
import '../models/caption_generation_models.dart';

class CaptionToneSelector extends StatelessWidget {
  final String selectedTone;
  final Function(String) onToneChanged;

  const CaptionToneSelector({
    Key? key,
    required this.selectedTone,
    required this.onToneChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Grid of tone options
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemCount: CaptionTone.values.length,
          itemBuilder: (context, index) {
            final tone = CaptionTone.values[index];
            final isSelected = selectedTone == tone.id;
            
            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onToneChanged(tone.id);
              },
              child: AnimatedContainer(
                duration: AppAnimations.fast,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.karigorGold.withOpacity(0.1)
                      : AppColors.glassBackground,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(
                    color: isSelected 
                        ? AppColors.karigorGold
                        : AppColors.glassBorder,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.karigorGold.withOpacity(0.3),
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
                      // Tone icon
                      Container(
                        padding: EdgeInsets.all(AppSizes.sm),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.karigorGold.withOpacity(0.2)
                              : AppColors.glassBorder.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        ),
                        child: Icon(
                          _getToneIcon(tone),
                          color: isSelected ? AppColors.karigorGold : AppColors.secondaryText,
                          size: 24,
                        ),
                      ),
                      SizedBox(height: AppSizes.sm),
                      
                      // Tone name
                      Text(
                        tone.name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected 
                              ? AppColors.karigorGold 
                              : AppColors.primaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSizes.xs),
                      
                      // Tone description
                      Text(
                        tone.description,
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
        
        // Selected tone info
        if (selectedTone.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.karigorGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(
                color: AppColors.karigorGold.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSizes.sm),
                  decoration: BoxDecoration(
                    color: AppColors.karigorGold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Icon(
                    _getToneIcon(_getSelectedTone()),
                    color: AppColors.karigorGold,
                    size: 20,
                  ),
                ),
                SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected: ${_getSelectedTone().name}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.karigorGold,
                        ),
                      ),
                      SizedBox(height: AppSizes.xs),
                      Text(
                        _getSelectedTone().description,
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

  CaptionTone _getSelectedTone() {
    return CaptionTone.values.firstWhere(
      (tone) => tone.id == selectedTone,
      orElse: () => CaptionTone.casual,
    );
  }

  IconData _getToneIcon(CaptionTone tone) {
    switch (tone) {
      case CaptionTone.casual:
        return Icons.chat_bubble_outline;
      case CaptionTone.professional:
        return Icons.business_center_outlined;
      case CaptionTone.playful:
        return Icons.celebration_outlined;
      case CaptionTone.dramatic:
        return Icons.theater_comedy_outlined;
      case CaptionTone.inspirational:
        return Icons.lightbulb_outline;
      case CaptionTone.mysterious:
        return Icons.help_outline;
    }
  }
} 