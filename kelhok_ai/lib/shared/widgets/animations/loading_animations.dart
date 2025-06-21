import 'package:flutter/material.dart';
import 'dart:math';
import '../../../core/constants/app_constants.dart';

class LoadingAnimations {
  static Widget storyGenerationLoader({
    String? message,
    double? progress,
    Color? primaryColor,
  }) {
    return StoryGenerationLoader(
      message: message ?? 'Generating your story...',
      progress: progress,
      primaryColor: primaryColor ?? AppColors.karigorGold,
    );
  }

  static Widget pulsingDots({
    Color? color,
    double size = 50.0,
  }) {
    return PulsingDotsLoader(
      color: color ?? AppColors.karigorGold,
      size: size,
    );
  }

  static Widget typingAnimation({
    String text = 'AI is thinking',
    Color? textColor,
    Color? dotColor,
  }) {
    return TypingAnimationLoader(
      text: text,
      textColor: textColor ?? AppColors.primaryText,
      dotColor: dotColor ?? AppColors.karigorGold,
    );
  }

  static Widget circularProgress({
    double? progress,
    Color? color,
    String? label,
  }) {
    return CircularProgressLoader(
      progress: progress,
      color: color ?? AppColors.karigorGold,
      label: label,
    );
  }
}

class StoryGenerationLoader extends StatefulWidget {
  final String message;
  final double? progress;
  final Color primaryColor;

  const StoryGenerationLoader({
    Key? key,
    required this.message,
    this.progress,
    required this.primaryColor,
  }) : super(key: key);

  @override
  State<StoryGenerationLoader> createState() => _StoryGenerationLoaderState();
}

class _StoryGenerationLoaderState extends State<StoryGenerationLoader>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: AppAnimations.slow,
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: AppAnimations.easeInOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.linear,
    ));

    _pulseController.repeat(reverse: true);
    _rotateController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Main loading animation
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer rotating ring
                AnimatedBuilder(
                  animation: _rotateAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotateAnimation.value * 2 * 3.14159,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: widget.primaryColor.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: CustomPaint(
                          painter: ProgressRingPainter(
                            progress: widget.progress ?? 0.0,
                            color: widget.primaryColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Inner pulsing icon
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.primaryColor.withOpacity(0.2),
                        ),
                        child: Icon(
                          Icons.auto_stories,
                          color: widget.primaryColor,
                          size: 30,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.lg),
          // Progress indicator
          if (widget.progress != null) ...[
            Container(
              width: 200,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: AppColors.glassBorder,
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: widget.progress!.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: LinearGradient(
                      colors: [
                        widget.primaryColor,
                        widget.primaryColor.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSizes.sm),
            Text(
              '${(widget.progress! * 100).toInt()}%',
              style: AppTextStyles.bodySmall.copyWith(
                color: widget.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSizes.md),
          ],
          // Loading message
          Text(
            widget.message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class PulsingDotsLoader extends StatefulWidget {
  final Color color;
  final double size;

  const PulsingDotsLoader({
    Key? key,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  State<PulsingDotsLoader> createState() => _PulsingDotsLoaderState();
}

class _PulsingDotsLoaderState extends State<PulsingDotsLoader>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: AppAnimations.medium,
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.5,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: AppAnimations.easeInOut,
      ));
    }).toList();

    // Start animations with delays
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: AppSizes.xs),
              child: Transform.scale(
                scale: _animations[index].value,
                child: Container(
                  width: widget.size / 5,
                  height: widget.size / 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withOpacity(_animations[index].value),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class TypingAnimationLoader extends StatefulWidget {
  final String text;
  final Color textColor;
  final Color dotColor;

  const TypingAnimationLoader({
    Key? key,
    required this.text,
    required this.textColor,
    required this.dotColor,
  }) : super(key: key);

  @override
  State<TypingAnimationLoader> createState() => _TypingAnimationLoaderState();
}

class _TypingAnimationLoaderState extends State<TypingAnimationLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _characterCount;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.text.length * 100),
      vsync: this,
    );
    _characterCount = IntTween(
      begin: 0,
      end: widget.text.length,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _characterCount,
          builder: (context, child) {
            String displayText = widget.text.substring(0, _characterCount.value);
            return Text(
              displayText,
              style: AppTextStyles.bodyMedium.copyWith(
                color: widget.textColor,
              ),
            );
          },
        ),
        PulsingDotsLoader(
          color: widget.dotColor,
          size: 30,
        ),
      ],
    );
  }
}

class CircularProgressLoader extends StatelessWidget {
  final double? progress;
  final Color color;
  final String? label;

  const CircularProgressLoader({
    Key? key,
    this.progress,
    required this.color,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 6,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        if (label != null) ...[
          SizedBox(height: AppSizes.md),
          Text(
            label!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  ProgressRingPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 4) / 2;
    
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // Start from top
      2 * 3.14159 * progress, // Progress amount
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
} 