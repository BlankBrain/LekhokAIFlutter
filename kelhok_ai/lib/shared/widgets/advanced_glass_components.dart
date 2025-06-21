import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/constants/app_constants.dart';

/// Advanced glassmorphic card component with enhanced blur and animations
class AdvancedGlassCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final double blurStrength;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool enableHoverEffect;
  final bool enableShadow;
  final VoidCallback? onTap;
  final Duration animationDuration;
  final double? elevation;
  final Gradient? backgroundGradient;

  const AdvancedGlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = AppSizes.radiusMd,
    this.blurStrength = 10.0,
    this.borderColor,
    this.borderWidth = 1.0,
    this.padding = const EdgeInsets.all(AppSizes.md),
    this.margin = const EdgeInsets.all(AppSizes.sm),
    this.enableHoverEffect = true,
    this.enableShadow = true,
    this.onTap,
    this.animationDuration = const Duration(milliseconds: 200),
    this.elevation,
    this.backgroundGradient,
  });

  @override
  State<AdvancedGlassCard> createState() => _AdvancedGlassCardState();
}

class _AdvancedGlassCardState extends State<AdvancedGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.1,
      end: 0.15,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            margin: widget.margin,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  boxShadow: widget.enableShadow
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: widget.elevation ?? 8,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: AppColors.karigorGold.withOpacity(0.05),
                            blurRadius: widget.elevation ?? 12,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: widget.blurStrength,
                      sigmaY: widget.blurStrength,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: widget.backgroundGradient ?? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.glassBackground.withOpacity(_opacityAnimation.value),
                            AppColors.glassBackground.withOpacity(_opacityAnimation.value * 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(widget.borderRadius),
                        border: Border.all(
                          color: widget.borderColor ?? AppColors.glassBorder,
                          width: widget.borderWidth,
                        ),
                      ),
                      padding: widget.padding,
                      child: widget.child,
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

/// Glassmorphic app bar
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final double elevation;
  final Color? backgroundColor;
  final double blurStrength;
  final bool centerTitle;
  final double? titleSpacing;
  final double toolbarHeight;

  const GlassAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.elevation = 0,
    this.backgroundColor,
    this.blurStrength = 20.0,
    this.centerTitle = true,
    this.titleSpacing,
    this.toolbarHeight = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurStrength, sigmaY: blurStrength),
        child: AppBar(
          title: title,
          actions: actions,
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading,
          elevation: elevation,
          backgroundColor: backgroundColor ?? Colors.transparent,
          centerTitle: centerTitle,
          titleSpacing: titleSpacing,
          toolbarHeight: toolbarHeight,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
} 