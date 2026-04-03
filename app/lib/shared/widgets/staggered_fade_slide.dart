import 'package:flutter/material.dart';

/// Wraps a child widget with a staggered fade-in + slide-up entrance animation.
/// Used on home screen cards for visual rhythm.
///
/// [index] controls the stagger delay (each subsequent item starts later).
/// [controller] is the parent AnimationController driving all staggered children.
class StaggeredFadeSlide extends StatelessWidget {
  final int index;
  final AnimationController controller;
  final Widget child;
  final double slideOffset;

  /// Total number of items in the stagger group (used to calculate intervals).
  final int totalItems;

  const StaggeredFadeSlide({
    super.key,
    required this.index,
    required this.controller,
    required this.child,
    this.slideOffset = 24.0,
    this.totalItems = 5,
  });

  @override
  Widget build(BuildContext context) {
    // Each item gets a portion of the total duration.
    // Stagger: item i starts at i/(total+2) and ends at (i+2)/(total+2).
    final itemCount = totalItems + 2;
    final begin = index / itemCount;
    final end = (index + 2) / itemCount;

    final opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(begin, end, curve: Curves.easeOut),
      ),
    );

    final offset = Tween<Offset>(
      begin: Offset(0, slideOffset),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(begin, end, curve: Curves.easeOutCubic),
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: opacity.value,
          child: Transform.translate(
            offset: offset.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
