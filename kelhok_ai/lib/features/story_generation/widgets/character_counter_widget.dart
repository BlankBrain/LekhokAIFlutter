import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class CharacterCounterWidget extends StatelessWidget {
  final int currentCount;
  final int maxCount;
  final int minCount;

  const CharacterCounterWidget({
    Key? key,
    required this.currentCount,
    required this.maxCount,
    required this.minCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double progress = currentCount / maxCount;
    final bool isOverLimit = currentCount > maxCount;
    final bool isUnderMin = currentCount < minCount;
    
    Color getProgressColor() {
      if (isOverLimit) return AppColors.error;
      if (isUnderMin) return AppColors.warning;
      if (progress > 0.8) return AppColors.warning;
      return AppColors.success;
    }

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: AppColors.glassBorder,
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: getProgressColor(),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSizes.sm),
        Text(
          '$currentCount/$maxCount',
          style: AppTextStyles.bodySmall.copyWith(
            color: getProgressColor(),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
} 