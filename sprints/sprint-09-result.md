# Sprint 09 구현 결과

## 생성된 파일
- `lib/services/notification_service.dart` -- 알림 서비스 코어: 플러그인 초기화, 권한 요청, Android 채널 4개 설정, 알림 탭 핸들링
- `lib/services/notification_scheduler.dart` -- 알림 스케줄러: 데일리 미션/기록 리마인더/주차 전환/마일스톤 알림 스케줄링 및 취소
- `lib/features/my/screens/notification_settings_screen.dart` -- 알림 설정 상세 화면: 4개 알림 토글 + TimePicker 2개

## 수정된 파일
- `lib/main.dart` -- `NotificationService.initialize()` 호출 추가 (TODO 주석 해제 및 import 추가)
- `lib/app.dart` -- `NotificationService.setRouter(router)` 호출 추가 (알림 탭 시 라우팅용)
- `lib/services/app_settings_service.dart` -- `recordReminderTime` 키/getter/setter 추가
- `lib/core/constants/app_strings.dart` -- 알림 관련 UI 텍스트 상수 19개 추가
- `lib/core/router/app_router.dart` -- `/my/notifications` 라우트 추가 (NotificationSettingsScreen)
- `lib/features/onboarding/screens/notification_permission_screen.dart` -- 알림 허용 시 NotificationService.requestPermission() + 기본 알림 3종 스케줄 등록
- `lib/features/my/screens/my_screen.dart` -- 알림 토글 콜백에 NotificationScheduler 호출 연동, "알림 설정" 섹션 탭 시 NotificationSettingsScreen 이동
- `android/app/src/main/AndroidManifest.xml` -- POST_NOTIFICATIONS, SCHEDULE_EXACT_ALARM, RECEIVE_BOOT_COMPLETED 권한 추가

## 구현 메모
- flutter_local_notifications v21.0.0 API: `zonedSchedule`, `initialize`, `cancel` 모두 named parameter 방식 사용 (v17 이전의 positional parameter 방식과 다름)
- `NotificationService`와 `NotificationScheduler`는 static 메서드로 구성하여 별도 Provider 없이도 호출 가능
- GoRouter 참조는 `app.dart`에서 `NotificationService.setRouter(router)` 호출로 설정
- 온보딩에서 알림 허용 시 데일리 미션 + 주차 전환 + 마일스톤 3종 알림을 자동 스케줄 등록
- 마이 탭의 "알림 설정" 헤더를 ListTile로 변경하여 탭 시 NotificationSettingsScreen으로 이동
- 모든 알림의 `playSound: false`로 무음 모드 기본 설정 적용
- `androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle` 사용 (배터리 최적화 대응)
- 마일스톤 알림 ID: `milestoneId(4) + targetDays`로 고유 ID 보장 (예: 4+7=11, 4+365=369)
- TimePicker는 Flutter 기본 `showTimePicker` 사용 (Material Design)

## 사양서 기준 자체 점검

### 기능 검증 -- NotificationService
- [x] `NotificationService.initialize()`가 main.dart에서 `runApp()` 이전에 호출된다
- [x] Android 초기화: `AndroidInitializationSettings('@mipmap/ic_launcher')` 설정
- [x] iOS 초기화: `DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: false)` 설정
- [x] `requestPermission()` 호출 시 Android에서 `Permission.notification.request()` + `Permission.scheduleExactAlarm.request()` 호출
- [x] `requestPermission()` 호출 시 iOS에서 `IOSFlutterLocalNotificationsPlugin.requestPermissions(alert: true, badge: true, sound: false)` 호출
- [x] 알림 탭 시 `_onNotificationTapped` 콜백 실행, payload 기반 GoRouter 이동
- [x] 알림 ID 상수 5개 정의: dailyMissionId=1, recordReminderId=2, weekTransitionId=3, milestoneId=4, dangerSignTrackingId=5
- [x] `NotificationService` 클래스가 `lib/services/notification_service.dart`에 존재

### 기능 검증 -- NotificationScheduler
- [x] `scheduleDailyMission()` 호출 시 `zonedSchedule`이 dailyMissionId(1)로 호출
- [x] 데일리 미션 채널 ID: `'daily_mission'`, 채널 이름: `'오늘의 활동'`
- [x] 데일리 미션 알림: `matchDateTimeComponents: DateTimeComponents.time` 사용 (매일 반복)
- [x] 데일리 미션 알림: `playSound: false` 설정
- [x] `scheduleRecordReminder()` 호출 시 `zonedSchedule`이 recordReminderId(2)로 호출
- [x] 기록 리마인더 본문: "오늘도 수고하셨어요. 간단히 기록해 볼까요?" (AppStrings.notifRecordReminderBody)
- [x] `scheduleWeekTransition()` 호출 시 해당 날짜 오전 9:00으로 스케줄
- [x] 주차 전환 알림 본문에 weekLabel 포함
- [x] `scheduleMilestone()` 호출 시 알림 ID가 `milestoneId + targetDays`로 설정
- [x] 마일스톤 알림 본문에 아기 이름과 일수 포함
- [x] 이미 지난 날짜 마일스톤 스케줄 스킵 (`scheduledDate.isBefore(now)` 체크)
- [x] `scheduleAllMilestones()` 호출 시 9개 마일스톤(7, 14, 21, 28, 30, 60, 100, 200, 365) 일괄 등록
- [x] `cancelAll()` -> `FlutterLocalNotificationsPlugin.cancelAll()` 호출
- [x] `cancel(int id)` -> `FlutterLocalNotificationsPlugin.cancel(id: id)` 호출
- [x] `_nextInstanceOfTime()` 현재 시간 이전이면 다음 날로 계산
- [x] 모든 스케줄 함수: `androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle`
- [x] 모든 알림 timezone Asia/Seoul (main.dart에서 `tz.setLocalLocation` 호출)

### 기능 검증 -- 온보딩 NotificationPermissionScreen 수정
- [x] "알림 받기" 탭 시 `NotificationService.requestPermission()` 호출
- [x] 허용 시 `setDailyNotificationOn(true)` 호출
- [x] 허용 시 데일리 미션 알림 기본 시간(09:00)으로 스케줄 등록
- [x] 허용 시 주차 전환 알림 스케줄 등록
- [x] 허용 시 마일스톤 알림 9개 일괄 스케줄 등록
- [x] 거부 시 `setDailyNotificationOn(false)` 호출
- [x] 거부 시 부정적 메시지 없이 바로 홈 이동
- [x] "나중에 설정할게요" 탭 시 알림 스케줄 등록 없이 홈 이동
- [x] 온보딩 완료 후 `isOnboardingComplete = true` 설정 (기존 동작 유지)

### 기능 검증 -- 마이 탭 알림 토글 연동
- [x] 데일리 활동 알림 토글 ON -> `scheduleDailyMission()` + `isDailyNotificationOn=true`
- [x] 데일리 활동 알림 토글 OFF -> `cancel(dailyMissionId)` + `isDailyNotificationOn=false`
- [x] 기록 리마인더 토글 ON -> `scheduleRecordReminder()` 호출
- [x] 기록 리마인더 토글 OFF -> `cancel(recordReminderId)` 호출
- [x] 주차 전환 알림 토글 ON -> `scheduleWeekTransition()` 호출
- [x] 주차 전환 알림 토글 OFF -> `cancel(weekTransitionId)` 호출
- [x] 성장 마일스톤 토글 ON -> `scheduleAllMilestones()` 호출
- [x] 성장 마일스톤 토글 OFF -> `cancelAllMilestones()` 호출 (각 targetDays에 대해 cancel)
- [x] OS 알림 권한 거부 시 `openAppSettings()` 안내
- [x] 앱 재시작 후 SharedPreferences에서 알림 설정 상태 복원

### 기능 검증 -- NotificationSettingsScreen
- [x] 앱 바: "알림 설정" 타이틀 + 뒤로가기 버튼 (2-1-2 변형 B)
- [x] 데일리 활동 알림: SwitchListTile(ON/OFF) + 서브텍스트 + 알림 시간 표시
- [x] 데일리 활동 알림 시간 탭 시 TimePicker 열림
- [x] TimePicker 시간 선택 시 `setDailyNotificationTime()` + 기존 취소 + 재스케줄
- [x] 기록 리마인더: SwitchListTile(ON/OFF) + 서브텍스트 + 알림 시간 표시
- [x] 기록 리마인더 시간 탭 시 TimePicker 열림
- [x] 주차 전환 알림: SwitchListTile(ON/OFF) + 서브텍스트 (시간 설정 없음)
- [x] 성장 마일스톤 알림: SwitchListTile(ON/OFF) + 서브텍스트 (시간 설정 없음)
- [x] GoRouter `/my/notifications` 라우트 등록
- [x] MyScreen "알림 설정" 탭 시 NotificationSettingsScreen 이동
- [x] 뒤로가기 시 MyScreen 복귀
- [x] 데일리 OFF 시 시간 영역 비활성화(dimmed) + 탭 불가

### UX 원칙 검증
- [x] 4개 유형 명확 구분, 한 줄 서브텍스트 설명, 과도한 옵션 없음
- [x] 기록 리마인더: "오늘도 수고하셨어요" 긍정 표현, 주차 전환: "새로운 활동을 확인해 보세요"
- [x] 기술 용어 UI 미노출 (부모 언어만 사용)
- [x] 토글 1탭 즉시 완료, TimePicker 1회 조작 완료, 온보딩 1탭 완료
- [x] 알림 OFF 시 부정적 메시지 없음, 권한 거부 시 부정적 피드백 없음

### 디자인 검증
- [x] 컬러: Scaffold 배경 theme, 스위치 ON warmOrange, OFF mutedBeige(라이트)/darkBorder(다크)
- [x] 타이포그래피: 모든 텍스트 `Theme.of(context).textTheme` 사용
- [x] 앱 바 스펙: 뒤로가기 + "알림 설정" 타이틀
- [x] 스위치 스펙: ON warmOrange, OFF mutedBeige(라이트)/darkBorder(다크), bodyLarge/bodySmall 사용
- [x] 다크 모드 대응: theme.brightness 기반 분기
- [x] 조부모 모드 대응: Theme textTheme 사용으로 +4sp 자동 적용

### 접근성 검증
- [x] 최소 터치 영역 48x48dp: SwitchListTile, 시간 영역 icon+row, 뒤로가기 IconButton
- [x] 무음 모드: 토글 전환 시 `HapticFeedback.lightImpact()`, 모든 알림 `playSound: false`
- [x] 빈 상태: 아기 미등록 시 null 체크로 크래시 방지
- [x] ValueKey 지정: `notification_settings_screen`, `daily_notification_detail_switch`, `record_reminder_detail_switch`, `week_transition_detail_switch`, `milestone_detail_switch`, `daily_notification_time_picker`, `record_reminder_time_picker`

### 코드 품질 검증
- [x] 모든 알림 텍스트: AppStrings 상수 참조, 하드코딩 한국어 없음
- [x] 모든 색상: AppColors 또는 Theme 참조, 하드코딩 Color 없음
- [x] 모든 텍스트 스타일: `Theme.of(context).textTheme` 참조
- [x] static 메서드 구성으로 Provider 불필요
- [x] import 경로 올바름
- [x] Android 채널 4개 고유 ID
- [x] 모든 스케줄 함수 try-catch 예외 처리
- [x] `recordReminderTime` getter/setter 추가
- [x] ConsumerStatefulWidget 사용 (Riverpod ref 접근)
- [x] 기존 온보딩 동작 유지 (isOnboardingComplete, go('/home'))

### 라우팅 검증
- [x] GoRouter `/my/notifications` 라우트 등록
- [x] 뒤로가기 시 MyScreen 복귀 (Navigator.of(context).pop())
- [x] 알림 탭 시 payload 기반 라우팅 (`/activity`, `/home`)
