import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

enum KButtonType { primary, secondary, outline }
enum KButtonSize { small, medium, large }

class KButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final KButtonType type;
  final KButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final Widget? icon;
  final bool fullWidth;

  const KButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = KButtonType.primary,
    this.size = KButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.fullWidth = false,
  }) : super(key: key);

  @override
  State<KButton> createState() => _KButtonState();
}

class _KButtonState extends State<KButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double get _height {
    switch (widget.size) {
      case KButtonSize.small:
        return AppSizes.buttonHeightSm;
      case KButtonSize.medium:
        return AppSizes.buttonHeightMd;
      case KButtonSize.large:
        return AppSizes.buttonHeightLg;
    }
  }

  Color get _backgroundColor {
    if (widget.isDisabled) return AppColors.quaternaryText;
    
    switch (widget.type) {
      case KButtonType.primary:
        return AppColors.karigorGold;
      case KButtonType.secondary:
        return AppColors.glassBackground;
      case KButtonType.outline:
        return Colors.transparent;
    }
  }

  Color get _textColor {
    if (widget.isDisabled) return Colors.white;
    
    switch (widget.type) {
      case KButtonType.primary:
        return Colors.white;
      case KButtonType.secondary:
        return AppColors.primaryText;
      case KButtonType.outline:
        return AppColors.karigorGold;
    }
  }

  Border? get _border {
    if (widget.type == KButtonType.outline) {
      return Border.all(
        color: widget.isDisabled ? AppColors.quaternaryText : AppColors.karigorGold,
        width: 1,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: widget.isDisabled || widget.isLoading 
                ? null 
                : (_) => _animationController.forward(),
            onTapUp: widget.isDisabled || widget.isLoading 
                ? null 
                : (_) => _animationController.reverse(),
            onTapCancel: () => _animationController.reverse(),
            child: Container(
              width: widget.fullWidth ? double.infinity : null,
              height: _height,
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                border: _border,
                boxShadow: widget.type == KButtonType.primary && !widget.isDisabled
                    ? [
                        BoxShadow(
                          color: const Color.fromRGBO(230, 164, 38, 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.isDisabled || widget.isLoading ? null : widget.onPressed,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.sm,
                    ),
                    child: Row(
                      mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.isLoading)
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(_textColor),
                            ),
                          )
                        else if (widget.icon != null) ...[
                          widget.icon!,
                          SizedBox(width: AppSizes.sm),
                        ],
                        if (!widget.isLoading)
                          Text(
                            widget.text,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: _textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 