import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Code-based bell shake animation.
/// CustomPainter draws a bell icon that wobbles left-right.
/// Replaces the Lottie placeholder for notification_bell.json.
class BellAnimation extends StatefulWidget {
  final double size;
  final bool autoPlay;
  final Duration duration;

  const BellAnimation({
    super.key,
    this.size = 48,
    this.autoPlay = true,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<BellAnimation> createState() => _BellAnimationState();
}

class _BellAnimationState extends State<BellAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;

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
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _shakeAnimation.value * math.pi,
          alignment: const Alignment(0, -0.8),
          child: child,
        );
      },
      child: Icon(
        Icons.notifications_active,
        size: widget.size,
        color: AppColors.warmOrange,
      ),
    );
  }
}
