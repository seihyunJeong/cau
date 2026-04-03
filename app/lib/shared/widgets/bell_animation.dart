import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Code-based bell shake animation with CustomPainter.
/// Draws a bell shape that wobbles left-right with a gentle glow effect.
/// Replaces the Lottie placeholder for notification_bell.json.
class BellAnimation extends StatefulWidget {
  final double size;
  final bool autoPlay;
  final Duration duration;

  const BellAnimation({
    super.key,
    this.size = 48,
    this.autoPlay = true,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<BellAnimation> createState() => _BellAnimationState();
}

class _BellAnimationState extends State<BellAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Bell wobble: quick oscillation that dampens over time
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.15),
        weight: 8,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.15, end: -0.12),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -0.12, end: 0.10),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.10, end: -0.08),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -0.08, end: 0.05),
        weight: 12,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.05, end: -0.03),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -0.03, end: 0.0),
        weight: 35,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Glow pulse: peak at 30% then fade
    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.3),
        weight: 70,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    if (widget.autoPlay) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _BellPainter(
            shakeAngle: _shakeAnimation.value,
            glowIntensity: _glowAnimation.value,
          ),
          size: Size(widget.size, widget.size),
        );
      },
    );
  }
}

class _BellPainter extends CustomPainter {
  final double shakeAngle;
  final double glowIntensity;

  _BellPainter({
    required this.shakeAngle,
    required this.glowIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final bellSize = size.width * 0.7;
    final bellCenter = Offset(center.dx, center.dy + bellSize * 0.05);

    canvas.save();
    // Rotate from top center (handle point)
    canvas.translate(center.dx, center.dy - bellSize * 0.35);
    canvas.rotate(shakeAngle * math.pi);
    canvas.translate(-center.dx, -(center.dy - bellSize * 0.35));

    // Glow circle behind bell
    if (glowIntensity > 0) {
      final glowPaint = Paint()
        ..color = AppColors.warmOrange.withValues(alpha: 0.12 * glowIntensity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, bellSize * 0.3);
      canvas.drawCircle(bellCenter, bellSize * 0.45, glowPaint);
    }

    // Bell body
    final bellPaint = Paint()
      ..color = AppColors.warmOrange
      ..style = PaintingStyle.fill;

    final bellPath = Path();
    // Bell top curve
    bellPath.moveTo(
      bellCenter.dx - bellSize * 0.35,
      bellCenter.dy + bellSize * 0.1,
    );
    // Left side
    bellPath.quadraticBezierTo(
      bellCenter.dx - bellSize * 0.38,
      bellCenter.dy - bellSize * 0.2,
      bellCenter.dx - bellSize * 0.12,
      bellCenter.dy - bellSize * 0.35,
    );
    // Top curve
    bellPath.quadraticBezierTo(
      bellCenter.dx,
      bellCenter.dy - bellSize * 0.45,
      bellCenter.dx + bellSize * 0.12,
      bellCenter.dy - bellSize * 0.35,
    );
    // Right side
    bellPath.quadraticBezierTo(
      bellCenter.dx + bellSize * 0.38,
      bellCenter.dy - bellSize * 0.2,
      bellCenter.dx + bellSize * 0.35,
      bellCenter.dy + bellSize * 0.1,
    );
    // Bottom rim
    bellPath.lineTo(
      bellCenter.dx + bellSize * 0.4,
      bellCenter.dy + bellSize * 0.15,
    );
    bellPath.lineTo(
      bellCenter.dx - bellSize * 0.4,
      bellCenter.dy + bellSize * 0.15,
    );
    bellPath.close();

    canvas.drawPath(bellPath, bellPaint);

    // Bell rim highlight
    final rimPaint = Paint()
      ..color = AppColors.softYellow.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(bellCenter.dx - bellSize * 0.38, bellCenter.dy + bellSize * 0.13),
      Offset(bellCenter.dx + bellSize * 0.38, bellCenter.dy + bellSize * 0.13),
      rimPaint,
    );

    // Handle (small circle at top)
    final handlePaint = Paint()
      ..color = AppColors.warmOrange
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(bellCenter.dx, bellCenter.dy - bellSize * 0.38),
      bellSize * 0.06,
      handlePaint,
    );

    // Clapper (small circle at bottom)
    final clapperPaint = Paint()
      ..color = AppColors.darkBrown
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(bellCenter.dx, bellCenter.dy + bellSize * 0.22),
      bellSize * 0.06,
      clapperPaint,
    );

    // Sound waves (two arcs on each side)
    if (shakeAngle.abs() > 0.01) {
      final wavePaint = Paint()
        ..color = AppColors.warmOrange.withValues(
            alpha: (shakeAngle.abs() * 4).clamp(0.0, 0.5))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round;

      // Left wave
      final leftWaveRect = Rect.fromCenter(
        center: Offset(
          bellCenter.dx - bellSize * 0.45,
          bellCenter.dy - bellSize * 0.1,
        ),
        width: bellSize * 0.15,
        height: bellSize * 0.25,
      );
      canvas.drawArc(leftWaveRect, math.pi * 0.6, math.pi * 0.8, false, wavePaint);

      // Right wave
      final rightWaveRect = Rect.fromCenter(
        center: Offset(
          bellCenter.dx + bellSize * 0.45,
          bellCenter.dy - bellSize * 0.1,
        ),
        width: bellSize * 0.15,
        height: bellSize * 0.25,
      );
      canvas.drawArc(rightWaveRect, -math.pi * 0.4, -math.pi * 0.8, false, wavePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BellPainter oldDelegate) {
    return shakeAngle != oldDelegate.shakeAngle ||
        glowIntensity != oldDelegate.glowIntensity;
  }
}
