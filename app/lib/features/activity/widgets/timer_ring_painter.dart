import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

/// 원형 타이머 CustomPainter (2-5-5).
/// 디자인컴포넌트 2-5-5 기준.
/// 외경 200dp, 링 두께 8dp, warmOrange 프로그레스, trackGray 트랙.
/// 시계 방향, 12시 방향에서 시작.
class TimerRingPainter extends CustomPainter {
  /// 진행률 (0.0 ~ 1.0). 0.0 = 아직 시작 안 함, 1.0 = 완료.
  final double progress;
  final Color progressColor;
  final Color trackColor;
  final double strokeWidth;

  TimerRingPainter({
    required this.progress,
    this.progressColor = AppColors.warmOrange,
    this.trackColor = AppColors.trackGray,
    this.strokeWidth = 8,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // 트랙 (전체 원)
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // 프로그레스 (남은 비율만큼 호)
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      // 12시 방향에서 시작, 시계 방향으로 진행률만큼
      // 남은 시간 = (1 - progress), 시작각 = -90도
      final sweepAngle = 2 * pi * (1.0 - progress);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2, // 12시 방향 시작
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant TimerRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
