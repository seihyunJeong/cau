import 'package:timezone/timezone.dart' as tz;

/// KST 기준 현재 시각을 반환한다.
/// 시간 관련 로직에서 반드시 이 함수를 사용한다. DateTime.now() 직접 사용 금지.
DateTime nowKST() => tz.TZDateTime.now(tz.getLocation('Asia/Seoul'));
