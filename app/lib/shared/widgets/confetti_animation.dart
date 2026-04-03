import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Code-based confetti/sparkle celebration animation.
/// Uses CustomPainter + AnimationController to render falling confetti particles.
/// Replaces the Lottie placeholder for celebration.json.
class ConfettiAnimation extends StatefulWidget {
  final double width;
  final double height;
  final bool autoPlay;
  final Duration duration;

  const ConfettiAnimation({
    super.key,
    this.width = 150,
    this.height = 150,
    this.autoPlay = true,
    this.duration = const Duration(milliseconds: 2500),
  });

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_ConfettiParticle> _particles;

  static const _particleCount = 40;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    final rng = math.Random();
    _particles = List.generate(
      _particleCount,
      (_) => _ConfettiParticle.random(rng),
    );

    if (widget.autoPlay) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _ConfettiPainter(
              particles: _particles,
              progress: _controller.value,
            ),
            size: Size(widget.width, widget.height),
          );
        },
      ),
    );
  }
}

/// Individual confetti particle data.
class _ConfettiParticle {
  final double startX;
  final double startY;
  final double size;
  final Color color;
  final double speed;
  final double wobble;
  final double wobbleSpeed;
  final double rotation;
  final int shape; // 0=circle, 1=rect, 2=star

  _ConfettiParticle({
    required this.startX,
    required this.startY,
    required this.size,
    required this.color,
    required this.speed,
    required this.wobble,
    required this.wobbleSpeed,
    required this.rotation,
    required this.shape,
  });

  factory _ConfettiParticle.random(math.Random rng) {
    const colors = [
      AppColors.warmOrange,
      AppColors.softGreen,
      AppColors.softYellow,
      AppColors.domainHolding,
      AppColors.domainSound,
      AppColors.domainVision,
      AppColors.domainBalance,
      AppColors.softRed,
    ];

    return _ConfettiParticle(
      startX: rng.nextDouble(),
      startY: rng.nextDouble() * 0.3,
      size: 4.0 + rng.nextDouble() * 6.0,
      color: colors[rng.nextInt(colors.length)],
      speed: 0.5 + rng.nextDouble() * 1.0,
      wobble: 0.02 + rng.nextDouble() * 0.08,
      wobbleSpeed: 2 + rng.nextDouble() * 6,
      rotation: rng.nextDouble() * math.pi * 2,
      shape: rng.nextInt(3),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final delay = p.startY * 0.3;
      final adjustedProgress =
          ((progress - delay) / (1.0 - delay)).clamp(0.0, 1.0);

      if (adjustedProgress <= 0) continue;

      // Fade out in last 30%
      final opacity = adjustedProgress > 0.7
          ? (1.0 - (adjustedProgress - 0.7) / 0.3)
          : math.min(1.0, adjustedProgress * 5);

      final x = p.startX * size.width +
          math.sin(adjustedProgress * p.wobbleSpeed * math.pi * 2) *
              p.wobble *
              size.width;
      final y = p.startY * size.height +
          adjustedProgress * p.speed * size.height * 0.8;

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity * 0.9)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rotation + adjustedProgress * math.pi * 2 * p.speed);

      switch (p.shape) {
        case 0:
          canvas.drawCircle(Offset.zero, p.size / 2, paint);
        case 1:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset.zero,
                width: p.size,
                height: p.size * 0.6,
              ),
              const Radius.circular(1),
            ),
            paint,
          );
        case 2:
          _drawSparkle(canvas, Offset.zero, p.size / 2, paint);
      }

      canvas.restore();
    }
  }

  void _drawSparkle(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2);
      final outerX = center.dx + radius * math.cos(angle);
      final outerY = center.dy + radius * math.sin(angle);
      final innerAngle = angle + math.pi / 4;
      final innerX = center.dx + radius * 0.3 * math.cos(innerAngle);
      final innerY = center.dy + radius * 0.3 * math.sin(innerAngle);

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
