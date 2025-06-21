import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class KBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const KBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        border: Border(
          top: BorderSide(
            color: AppColors.glassBorder,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: AppStrings.navHome,
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.edit_outlined,
                activeIcon: Icons.edit,
                label: AppStrings.navGenerate,
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.people_outline,
                activeIcon: Icons.people,
                label: AppStrings.navCharacters,
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.history_outlined,
                activeIcon: Icons.history,
                label: AppStrings.navHistory,
              ),
              _buildNavItem(
                index: 4,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: AppStrings.navProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = currentIndex == index;
    
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: AppAnimations.medium,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? AppSizes.md : AppSizes.sm,
          vertical: AppSizes.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.karigorGold.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: isSelected 
              ? Border.all(
                  color: AppColors.karigorGold.withOpacity(0.3),
                  width: 1,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: AppAnimations.fast,
              child: Icon(
                isSelected ? activeIcon : icon,
                key: ValueKey(isSelected),
                color: isSelected 
                    ? AppColors.karigorGold 
                    : AppColors.quaternaryText,
                size: 24,
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: AppSizes.xs),
              AnimatedOpacity(
                duration: AppAnimations.medium,
                opacity: isSelected ? 1.0 : 0.0,
                child: Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.karigorGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 