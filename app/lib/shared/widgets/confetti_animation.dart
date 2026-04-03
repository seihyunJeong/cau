import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Code-based confetti/sparkle celebration animation.
/// Uses CustomPainter + AnimationController to render rising and falling
/// confetti particles with burst, drift, rotation and fade.
/// Replaces the Lottie placeholder for celebration.json.
class ConfettiAnimation extends StatefulWidget {
  final double width;
  final double height;
  final bool autoPlay;
  final Duration duration;

  const ConfettiAnimation({
    super.key,
    this.width = 180,
    this.height = 180,
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

  static const _particleCount = 55;

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
  final double rotationSpeed;
  final int shape; // 0=circle, 1=rect, 2=star, 3=ring
  final double burstAngle; // Initial burst direction
  final double burstSpeed; // How fast it bursts outward initially
  final double delay; // Start delay (0..0.2)

  _ConfettiParticle({
    required this.startX,
    required this.startY,
    required this.size,
    required this.color,
    required this.speed,
    required this.wobble,
    required this.wobbleSpeed,
    required this.rotation,
    required this.rotationSpeed,
    required this.shape,
    required this.burstAngle,
    required this.burstSpeed,
    required this.delay,
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
      startX: 0.3 + rng.nextDouble() * 0.4, // Center cluster
      startY: 0.3 + rng.nextDouble() * 0.2,
      size: 3.0 + rng.nextDouble() * 7.0,
      color: colors[rng.nextInt(colors.length)],
      speed: 0.3 + rng.nextDouble() * 0.8,
      wobble: 0.03 + rng.nextDouble() * 0.1,
      wobbleSpeed: 2 + rng.nextDouble() * 6,
      rotation: rng.nextDouble() * math.pi * 2,
      rotationSpeed: 1 + rng.nextDouble() * 4,
      shape: rng.nextInt(4),
      burstAngle: rng.nextDouble() * math.pi * 2,
      burstSpeed: 0.2 + rng.nextDouble() * 0.4,
      delay: rng.nextDouble() * 0.15,
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
    // Draw a soft central glow first
    if (progress < 0.5) {
      final glowOpacity = (1.0 - progress * 2).clamp(0.0, 0.3);
      final glowPaint = Paint()
        ..color = AppColors.softYellow.withValues(alpha: glowOpacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, size.width * 0.2);
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width * 0.15,
        glowPaint,
      );
    }

    for (final p in particles) {
      final adjustedProgress =
          ((progress - p.delay) / (1.0 - p.delay)).clamp(0.0, 1.0);

      if (adjustedProgress <= 0) continue;

      // Burst phase (first 30%) then drift phase
      final burstPhase = (adjustedProgress / 0.3).clamp(0.0, 1.0);
      final driftPhase = ((adjustedProgress - 0.15) / 0.85).clamp(0.0, 1.0);

      // Fade out in last 30%
      final opacity = adjustedProgress > 0.7
          ? (1.0 - (adjustedProgress - 0.7) / 0.3)
          : math.min(1.0, adjustedProgress * 6);

      // Position: burst outward then drift down with wobble
      final burstX =
          math.cos(p.burstAngle) * p.burstSpeed * burstPhase * size.width;
      final burstY =
          math.sin(p.burstAngle) * p.burstSpeed * burstPhase * size.height;

      final x = p.startX * size.width +
          burstX +
          math.sin(driftPhase * p.wobbleSpeed * math.pi * 2) *
              p.wobble *
              size.width;
      final y = p.startY * size.height +
          burstY +
          driftPhase * p.speed * size.height * 0.6;

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity * 0.9)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(
          p.rotation + adjustedProgress * math.pi * 2 * p.rotationSpeed);

      switch (p.shape) {
        case 0: // Circle
          canvas.drawCircle(Offset.zero, p.size / 2, paint);
        case 1: // Rectangle (confetti strip)
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset.zero,
                width: p.size,
                height: p.size * 0.45,
              ),
              const Radius.circular(1),
            ),
            paint,
          );
        case 2: // Star/sparkle
          _drawSparkle(canvas, Offset.zero, p.size / 2, paint);
        case 3: // Ring
          paint.style = PaintingStyle.stroke;
          paint.strokeWidth = 1.5;
          canvas.drawCircle(Offset.zero, p.size / 2.5, paint);
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
