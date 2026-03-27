/// 활동 타이머 상태 모델.
/// 개발기획서 9-2 기준.
class TimerState {
  final int totalSeconds;
  final int remainingSeconds;
  final bool isRunning;
  final bool isCompleted;

  const TimerState({
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.isRunning,
    required this.isCompleted,
  });

  factory TimerState.initial({int totalSeconds = 0}) => TimerState(
        totalSeconds: totalSeconds,
        remainingSeconds: totalSeconds,
        isRunning: false,
        isCompleted: false,
      );

  TimerState copyWith({
    int? totalSeconds,
    int? remainingSeconds,
    bool? isRunning,
    bool? isCompleted,
  }) =>
      TimerState(
        totalSeconds: totalSeconds ?? this.totalSeconds,
        remainingSeconds: remainingSeconds ?? this.remainingSeconds,
        isRunning: isRunning ?? this.isRunning,
        isCompleted: isCompleted ?? this.isCompleted,
      );

  /// 경과 시간 (초).
  int get elapsedSeconds => totalSeconds - remainingSeconds;

  /// "M:SS" 형식의 남은 시간 문자열.
  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// 진행 비율 (0.0 ~ 1.0). 1.0이 완료.
  double get progress {
    if (totalSeconds == 0) return 0.0;
    return 1.0 - (remainingSeconds / totalSeconds);
  }

  @override
  String toString() =>
      'TimerState(total: $totalSeconds, remaining: $remainingSeconds, '
      'running: $isRunning, completed: $isCompleted)';
}
