import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// 활동 후 관찰 기록을 분석하여 4단계 피드백을 생성한다.
/// 개발기획서 6-3 기준.
///
/// 해석 레벨:
/// - 0: 무리 없음
/// - 1: 짧게 조정 권장
/// - 2: 며칠 이어서 관찰
/// - 3: 전문가 상담 고려
class ObservationInterpreter {
  ObservationInterpreter._();

  /// 1단계 + 2단계 응답을 기반으로 해석 레벨을 계산한다.
  /// 각 항목 값: 0(아니오/잘안보임) ~ 2(예/뚜렷함).
  /// 2단계가 비어있으면 1단계만으로 해석한다.
  static int interpret({
    required Map<String, int> step1Responses,
    required Map<String, int> step2Responses,
  }) {
    // 1단계 점수 합산
    final step1Total = step1Responses.values.fold(0, (sum, v) => sum + v);
    final step1Max = step1Responses.length * 2;
    final step1Ratio = step1Max > 0 ? step1Total / step1Max : 0.5;

    // 2단계 점수 합산
    final step2Total = step2Responses.values.fold(0, (sum, v) => sum + v);
    final step2Max = step2Responses.length * 2;
    final step2Ratio = step2Max > 0 ? step2Total / step2Max : 0.5;

    // 종합 비율: 2단계가 비어있으면 1단계만 사용
    final double overallRatio;
    if (step2Responses.isEmpty) {
      overallRatio = step1Ratio;
    } else {
      overallRatio = (step1Ratio + step2Ratio) / 2;
    }

    if (overallRatio >= 0.75) return 0;
    if (overallRatio >= 0.50) return 1;
    if (overallRatio >= 0.30) return 2;
    return 3;
  }

  /// 해석 레벨에 따른 안심 메시지를 반환한다.
  static String getMessage(int level) {
    switch (level) {
      case 0:
        return '무리 없이 잘 진행된 것 같아요.\n'
            '오늘 아기가 활동에 편안하게 반응했어요.';
      case 1:
        return '다음에는 조금 짧게 해볼까요?\n'
            '아기가 조금 지친 것 같은 신호가 보였어요.';
      case 2:
        return '며칠 이어서 관찰해 보세요.\n'
            '아기의 반응이 날마다 다를 수 있어요.';
      case 3:
        return '아기가 조금 힘들어하는 것 같아요.\n'
            '걱정이 계속되면 전문가와 이야기해 보세요.';
      default:
        return '';
    }
  }

  /// 해석 레벨에 따른 메인 제목 메시지를 반환한다.
  static String getTitle(int level) {
    switch (level) {
      case 0:
        return '오늘 이 정도면 괜찮아요';
      case 1:
        return '조금 조정해 볼까요?';
      case 2:
        return '며칠 더 지켜봐요';
      case 3:
        return '함께 살펴봐요';
      default:
        return '';
    }
  }

  /// 해석 레벨에 따른 솔루션 목록을 반환한다.
  static List<String> getSolutions(int level) {
    switch (level) {
      case 0:
        return [
          '내일도 비슷한 시간에 시도해 보세요.',
          '아기가 좋아하는 활동을 반복해도 좋아요.',
        ];
      case 1:
        return [
          '활동 시간을 절반으로 줄여서 시도해 보세요.',
          '아기가 편안한 상태일 때 해보세요.',
        ];
      case 2:
        return [
          '하루 쉬고 내일 다시 관찰해 보세요.',
          '다른 활동으로 바꿔서 시도해 볼 수도 있어요.',
        ];
      case 3:
        return [
          '활동을 잠시 쉬어도 괜찮아요.',
          '다음 소아과 방문 시 이 기록을 보여주세요.',
        ];
      default:
        return [];
    }
  }

  /// 해석 레벨에 따른 아이콘 데이터를 반환한다.
  static IconData getIcon(int level) {
    switch (level) {
      case 0:
        return Icons.check_circle;
      case 1:
        return Icons.access_time;
      case 2:
        return Icons.visibility;
      case 3:
        return Icons.favorite;
      default:
        return Icons.check_circle;
    }
  }

  /// 해석 레벨에 따른 아이콘 색상을 반환한다.
  static Color getIconColor(int level) {
    switch (level) {
      case 0:
        return AppColors.softGreen;
      case 1:
        return AppColors.softYellow;
      case 2:
        return AppColors.warmOrange;
      case 3:
        return AppColors.softRed;
      default:
        return AppColors.softGreen;
    }
  }
}
