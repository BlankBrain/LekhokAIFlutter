import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';

/// Advanced loading animations with multiple types
class AdvancedLoadingAnimation extends StatefulWidget {
  final LoadingType type;
  final double size;
  final Color? color;
  final Duration duration;
  final String? message;

  const AdvancedLoadingAnimation({
    super.key,
    this.type = LoadingType.pulsingCircles,
    this.size = 50.0,
    this.color,
    this.duration = const Duration(milliseconds: 1500),
    this.message,
  });

  @override
  State<AdvancedLoadingAnimation> createState() => _AdvancedLoadingAnimationState();
}

class _AdvancedLoadingAnimationState extends State<AdvancedLoadingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.karigorGold;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: _buildAnimation(color),
        ),
        if (widget.message != null) ...[
          const SizedBox(height: AppSizes.md),
          Text(
            widget.message!,
            style: TextStyle(color: AppColors.secondaryText),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildAnimation(Color color) {
    switch (widget.type) {
      case LoadingType.pulsingCircles:
        return _PulsingCircles(controller: _controller, color: color);
      case LoadingType.morphingShapes:
        return _MorphingShapes(controller: _controller, color: color);
      case LoadingType.floatingParticles:
        return _FloatingParticles(controller: _controller, color: color);
      case LoadingType.typingIndicator:
        return _TypingIndicator(controller: _controller, color: color);
      case LoadingType.waveLoading:
        return _WaveLoading(controller: _controller, color: color);
      case LoadingType.spinningArcs:
        return _SpinningArcs(controller: _controller, color: color);
    }
  }
}

/// Pulsing circles animation
class _PulsingCircles extends StatelessWidget {
  final AnimationController controller;
  final Color color;

  const _PulsingCircles({required this.controller, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: PulsingCirclesPainter(
            animation: controller,
            color: color,
          ),
        );
      },
    );
  }
}

/// Morphing shapes animation
class _MorphingShapes extends StatelessWidget {
  final AnimationController controller;
  final Color color;

  const _MorphingShapes({required this.controller, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: MorphingShapesPainter(
            animation: controller,
            color: color,
          ),
        );
      },
    );
  }
}

/// Floating particles animation
class _FloatingParticles extends StatelessWidget {
  final AnimationController controller;
  final Color color;

  const _FloatingParticles({required this.controller, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: FloatingParticlesPainter(
            animation: controller,
            color: color,
          ),
        );
      },
    );
  }
}

/// Typing indicator animation
class _TypingIndicator extends StatelessWidget {
  final AnimationController controller;
  final Color color;

  const _TypingIndicator({required this.controller, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final animationValue = (controller.value - delay) % 1.0;
            final scale = animationValue < 0.5
                ? 1.0 + (animationValue * 2) * 0.5
                : 1.5 - ((animationValue - 0.5) * 2) * 0.5;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Transform.scale(
                scale: scale.clamp(0.5, 1.5),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
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

/// Wave loading animation
class _WaveLoading extends StatelessWidget {
  final AnimationController controller;
  final Color color;

  const _WaveLoading({required this.controller, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: WaveLoadingPainter(
            animation: controller,
            color: color,
          ),
        );
      },
    );
  }
}

/// Spinning arcs animation
class _SpinningArcs extends StatelessWidget {
  final AnimationController controller;
  final Color color;

  const _SpinningArcs({required this.controller, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: SpinningArcsPainter(
            animation: controller,
            color: color,
          ),
        );
      },
    );
  }
}

/// Custom painters for different animation types
class PulsingCirclesPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  PulsingCirclesPainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 0; i < 3; i++) {
      final progress = (animation.value + i * 0.3) % 1.0;
      final radius = maxRadius * progress;
      final opacity = 1.0 - progress;

      final paint = Paint()
        ..color = color.withOpacity(opacity * 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(PulsingCirclesPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value;
  }
}

class MorphingShapesPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  MorphingShapesPainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    const sides = 6;
    
    for (int i = 0; i < sides; i++) {
      final angle = (i / sides) * 2 * math.pi + animation.value * 2 * math.pi;
      final morphFactor = 0.5 + 0.5 * math.sin(animation.value * 4 * math.pi + i);
      final currentRadius = radius * morphFactor;
      
      final x = center.dx + currentRadius * math.cos(angle);
      final y = center.dy + currentRadius * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(MorphingShapesPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value;
  }
}

class FloatingParticlesPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  FloatingParticlesPainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..color = color;

    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * math.pi;
      final progress = (animation.value + i * 0.125) % 1.0;
      final distance = size.width * 0.3 * math.sin(progress * math.pi);
      final opacity = math.sin(progress * math.pi);
      
      final x = center.dx + distance * math.cos(angle);
      final y = center.dy + distance * math.sin(angle);
      
      paint.color = color.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), 3, paint);
    }
  }

  @override
  bool shouldRepaint(FloatingParticlesPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value;
  }
}

class WaveLoadingPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  WaveLoadingPainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final waveHeight = size.height * 0.3;
    final baseY = size.height * 0.7;
    
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, baseY);
    
    for (double x = 0; x <= size.width; x += 2) {
      final normalizedX = x / size.width;
      final waveOffset = animation.value * 2 * math.pi;
      final y = baseY - waveHeight * math.sin(normalizedX * 4 * math.pi + waveOffset);
      path.lineTo(x, y);
    }
    
    path.lineTo(size.width, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WaveLoadingPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value;
  }
}

class SpinningArcsPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  SpinningArcsPainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    for (int i = 0; i < 3; i++) {
      final paint = Paint()
        ..color = color.withOpacity(0.7 - i * 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round;

      final startAngle = animation.value * 2 * math.pi + i * math.pi / 3;
      const sweepAngle = math.pi;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius + i * 5),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(SpinningArcsPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value;
  }
}

/// Loading overlay widget
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final LoadingType loadingType;
  final String? message;
  final Color? backgroundColor;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingType = LoadingType.pulsingCircles,
    this.message,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ?? Colors.black.withOpacity(0.3),
            child: Center(
              child: AdvancedLoadingAnimation(
                type: loadingType,
                message: message,
              ),
            ),
          ),
      ],
    );
  }
}

enum LoadingType {
  pulsingCircles,
  morphingShapes,
  floatingParticles,
  typingIndicator,
  waveLoading,
  spinningArcs,
}
