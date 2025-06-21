import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_constants.dart';

class ImageStyleSelector extends StatelessWidget {
  final String selectedStyle;
  final Function(String) onStyleChanged;

  const ImageStyleSelector({
    Key? key,
    required this.selectedStyle,
    required this.onStyleChanged,
  }) : super(key: key);

  static const List<ImageStyle> _styles = [
    ImageStyle(
      id: 'realistic',
      name: 'Realistic',
      description: 'Photorealistic images with natural lighting',
      icon: Icons.photo_camera_outlined,
      color: Color(0xFF4CAF50),
    ),
    ImageStyle(
      id: 'artistic',
      name: 'Artistic',
      description: 'Creative artistic interpretations',
      icon: Icons.brush_outlined,
      color: Color(0xFF9C27B0),
    ),
    ImageStyle(
      id: 'anime',
      name: 'Anime',
      description: 'Japanese animation style artwork',
      icon: Icons.face_outlined,
      color: Color(0xFFFF5722),
    ),
    ImageStyle(
      id: 'fantasy',
      name: 'Fantasy',
      description: 'Magical and fantastical scenes',
      icon: Icons.auto_awesome_outlined,
      color: Color(0xFF673AB7),
    ),
    ImageStyle(
      id: 'cyberpunk',
      name: 'Cyberpunk',
      description: 'Futuristic neon-lit environments',
      icon: Icons.computer_outlined,
      color: Color(0xFF00BCD4),
    ),
    ImageStyle(
      id: 'watercolor',
      name: 'Watercolor',
      description: 'Soft watercolor painting style',
      icon: Icons.water_drop_outlined,
      color: Color(0xFF2196F3),
    ),
  ];

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
            childAspectRatio: 1.2,
          ),
          itemCount: _styles.length,
          itemBuilder: (context, index) {
            final style = _styles[index];
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
                      ? style.color.withOpacity(0.1)
                      : AppColors.glassBackground,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(
                    color: isSelected 
                        ? style.color
                        : AppColors.glassBorder,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: style.color.withOpacity(0.3),
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
                              ? style.color.withOpacity(0.2)
                              : AppColors.glassBorder.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        ),
                        child: Icon(
                          style.icon,
                          color: isSelected ? style.color : AppColors.secondaryText,
                          size: 28,
                        ),
                      ),
                      SizedBox(height: AppSizes.sm),
                      
                      // Style name
                      Text(
                        style.name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected 
                              ? style.color 
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
              color: _getSelectedStyle().color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(
                color: _getSelectedStyle().color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSizes.sm),
                  decoration: BoxDecoration(
                    color: _getSelectedStyle().color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Icon(
                    _getSelectedStyle().icon,
                    color: _getSelectedStyle().color,
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
                          color: _getSelectedStyle().color,
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

  ImageStyle _getSelectedStyle() {
    return _styles.firstWhere(
      (style) => style.id == selectedStyle,
      orElse: () => _styles.first,
    );
  }
}

class ImageStyle {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  const ImageStyle({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
} 