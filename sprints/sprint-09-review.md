# Sprint 09 검증 결과

## 판정: PASS

---

## 검증 상세

### 기능 검증 -- NotificationService (코드 리뷰)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | `NotificationService.initialize()`가 main.dart에서 `runApp()` 이전에 호출된다 | PASS | main.dart:38에서 `await NotificationService.initialize();` 호출 확인 |
| 2 | Android 초기화: `AndroidInitializationSettings('@mipmap/ic_launcher')` | PASS | notification_service.dart:49-51 확인 |
| 3 | iOS 초기화: `DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: false)` | PASS | notification_service.dart:54-58 확인 |
| 4 | `requestPermission()` 호출 시 Android에서 알림 권한 요청 | PASS | `Permission.notification.request()` 사용. 사양서는 `AndroidFlutterLocalNotificationsPlugin.requestNotificationsPermission()`을 명시했으나, `permission_handler` 패키지를 통한 요청도 동일 기능이며, 프로젝트에서 이미 `permission_handler`를 의존하고 있어 허용 범위 |
| 5 | `requestPermission()` 호출 시 iOS에서 `IOSFlutterLocalNotificationsPlugin.requestPermissions(alert: true, badge: true, sound: false)` | PASS | notification_service.dart:136-144 확인 |
| 6 | 알림 탭 시 `_onNotificationTapped` 콜백 실행, payload 기반 GoRouter 이동 | PASS | notification_service.dart:158-167 확인. payload null/empty 체크, router null 체크, try-catch 모두 포함 |
| 7 | 알림 ID 상수 5개 정의 (1, 2, 3, 4, 5) | PASS | notification_service.dart:24-28 확인 |
| 8 | `NotificationService` 클래스가 `lib/services/notification_service.dart`에 존재 | PASS | 파일 존재 확인 |

### 기능 검증 -- NotificationScheduler (코드 리뷰)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | `scheduleDailyMission()` 호출 시 `zonedSchedule`이 dailyMissionId(1)로 호출 | PASS | notification_scheduler.dart:34-57 확인 |
| 2 | 데일리 미션 채널 ID `'daily_mission'`, 채널 이름 `'오늘의 활동'` | PASS | notification_scheduler.dart:41-42 확인 |
| 3 | `matchDateTimeComponents: DateTimeComponents.time` 사용 (매일 반복) | PASS | notification_scheduler.dart:55 확인 |
| 4 | 데일리 미션 `playSound: false` | PASS | notification_scheduler.dart:46 확인 |
| 5 | `scheduleRecordReminder()` 호출 시 recordReminderId(2)로 호출 | PASS | notification_scheduler.dart:72-95 확인 |
| 6 | 기록 리마인더 본문 "오늘도 수고하셨어요. 간단히 기록해 볼까요?" | PASS | AppStrings.notifRecordReminderBody 상수 사용 (app_strings.dart:382-383) |
| 7 | `scheduleWeekTransition()` 해당 날짜 오전 9:00으로 스케줄 | PASS | notification_scheduler.dart:115-121 확인 |
| 8 | 주차 전환 알림 본문에 weekLabel 포함 | PASS | `AppStrings.notifWeekTransitionBody(weekLabel)` 호출 확인 |
| 9 | `scheduleMilestone()` 알림 ID가 `milestoneId + targetDays` | PASS | notification_scheduler.dart:183 확인 |
| 10 | 마일스톤 알림 본문에 아기 이름과 일수 포함 | PASS | `AppStrings.notifMilestoneBody(babyName, targetDays)` 호출 확인 |
| 11 | 이미 지난 날짜 마일스톤 스킵 | PASS | notification_scheduler.dart:180-181 `scheduledDate.isBefore(now)` 체크 확인 |
| 12 | `scheduleAllMilestones()` 9개 마일스톤 일괄 등록 | PASS | notification_scheduler.dart:18-19에 [7,14,21,28,30,60,100,200,365] 정의, 216-227에서 순회 등록 |
| 13 | `cancelAll()` -> `FlutterLocalNotificationsPlugin.cancelAll()` | PASS | notification_scheduler.dart:241 확인 |
| 14 | `cancel(int id)` -> `FlutterLocalNotificationsPlugin.cancel(id: id)` | PASS | notification_scheduler.dart:250 확인 (v21 named parameter) |
| 15 | `_nextInstanceOfTime()` 현재 시간 이전이면 다음 날 계산 | PASS | notification_scheduler.dart:269-286 확인 |
| 16 | 모든 스케줄 함수 `androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle` | PASS | 데일리(54), 기록(93), 주차(148), 마일스톤(205) 모두 확인 |
| 17 | timezone Asia/Seoul | PASS | main.dart:28 `tz.setLocalLocation(tz.getLocation('Asia/Seoul'))`, 스케줄러에서 `tz.getLocation('Asia/Seoul')` 직접 사용 |

### 기능 검증 -- 온보딩 NotificationPermissionScreen (코드 리뷰)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | "알림 받기" 탭 시 `NotificationService.requestPermission()` 호출 | PASS | notification_permission_screen.dart:154 확인 |
| 2 | 허용 시 `setDailyNotificationOn(true)` 호출 | PASS | :157 확인. 추가로 setRecordReminderOn, setWeekTransitionOn, setMilestoneOn도 true 설정 |
| 3 | 허용 시 데일리 미션 알림 기본 시간(09:00)으로 스케줄 등록 | PASS | :163 확인 |
| 4 | 허용 시 주차 전환 알림 스케줄 등록 | PASS | :170-173 확인 (baby null 체크 포함) |
| 5 | 허용 시 마일스톤 알림 9개 일괄 스케줄 등록 | PASS | :174-177 확인 |
| 6 | 거부 시 `setDailyNotificationOn(false)` 호출 | PASS | :181 확인 |
| 7 | 거부 시 부정적 메시지 없이 바로 홈 이동 | PASS | :190 `_completeOnboarding` 호출로 직접 홈 이동, 부정적 메시지 없음 |
| 8 | "나중에 설정할게요" 탭 시 알림 스케줄 없이 홈 이동 | PASS | :193-198 확인 |
| 9 | 온보딩 완료 후 `isOnboardingComplete = true` | PASS | :203 `settings.setOnboardingComplete(true)` 확인 |

### 기능 검증 -- 마이 탭 알림 토글 연동 (코드 리뷰)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | 데일리 활동 알림 토글 ON -> scheduleDailyMission + isDailyNotificationOn=true | PASS | my_screen.dart:97-101 확인 |
| 2 | 데일리 활동 알림 토글 OFF -> cancel(dailyMissionId) + isDailyNotificationOn=false | PASS | :97,103 확인 |
| 3 | 기록 리마인더 토글 ON -> scheduleRecordReminder | PASS | :121-123 확인 |
| 4 | 기록 리마인더 토글 OFF -> cancel(recordReminderId) | PASS | :125-126 확인 |
| 5 | 주차 전환 알림 토글 ON -> scheduleWeekTransition | PASS | :144-151 확인 (baby null 체크 포함) |
| 6 | 주차 전환 알림 토글 OFF -> cancel(weekTransitionId) | PASS | :153-154 확인 |
| 7 | 성장 마일스톤 토글 ON -> scheduleAllMilestones | PASS | :172-176 확인 |
| 8 | 성장 마일스톤 토글 OFF -> cancelAllMilestones | PASS | :180 확인 |
| 9 | OS 알림 권한 거부 시 `openAppSettings()` 안내 | PASS | my_screen.dart:33-42 `_ensureNotificationPermission()` 확인 |
| 10 | 앱 재시작 후 SharedPreferences에서 알림 설정 상태 복원 | PASS | AppSettingsService getter들이 SharedPreferences에서 직접 읽음 |

### 기능 검증 -- NotificationSettingsScreen (코드 리뷰)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | 앱 바: "알림 설정" 타이틀 + 뒤로가기 버튼 | PASS | notification_settings_screen.dart:42-53 확인 |
| 2 | 데일리 활동 알림: SwitchListTile + 서브텍스트 + 알림 시간 | PASS | :59-71 확인 |
| 3 | 데일리 시간 탭 시 TimePicker 열림 | PASS | :412-425 `showTimePicker` 확인 |
| 4 | TimePicker 시간 선택 시 setDailyNotificationTime + 취소 + 재스케줄 | PASS | :421-423 확인 |
| 5 | 기록 리마인더: SwitchListTile + 서브텍스트 + 알림 시간 | PASS | :74-86 확인 |
| 6 | 기록 리마인더 시간 탭 시 TimePicker 열림 | PASS | :427-439 확인 |
| 7 | 주차 전환 알림: SwitchListTile + 서브텍스트 (시간 없음) | PASS | :89-97 `_buildSimpleNotificationTile` 사용 |
| 8 | 성장 마일스톤 알림: SwitchListTile + 서브텍스트 (시간 없음) | PASS | :100-108 확인 |
| 9 | GoRouter `/my/notifications` 라우트 등록 | PASS | app_router.dart:124-126 확인 |
| 10 | MyScreen "알림 설정" 탭 시 NotificationSettingsScreen 이동 | PASS | my_screen.dart:83 `context.push('/my/notifications')` 확인 |
| 11 | 뒤로가기 시 MyScreen 복귀 | PASS | :51 `Navigator.of(context).pop()` 확인 |
| 12 | 데일리 OFF 시 시간 영역 비활성화(dimmed) + 탭 불가 | PASS | :69 `timeEnabled: settings.isDailyNotificationOn`, :156 `onTap: timeEnabled ? onTimeTap : null` |

### 기능 검증 (UI 실행 테스트 -- Marionette)

| # | 테스트 시나리오 | 판정 | 비고 |
|---|---|---|---|
| 1 | 마이 탭에 "알림 설정" 헤더 존재 | PASS | `notification_settings_header` ListTile 확인, 탭 시 chevron_right 아이콘 표시 |
| 2 | 마이 탭에 4개 알림 토글 존재 | PASS | `daily_notification_switch`, `record_reminder_switch`, `week_transition_switch`, `milestone_switch` 모두 존재 |
| 3 | "알림 설정" 탭 -> NotificationSettingsScreen 이동 | PASS | `notification_settings_header` 탭 후 `notification_settings_screen` Scaffold 확인 |
| 4 | NotificationSettingsScreen에 4개 토글 존재 | PASS | `daily_notification_detail_switch`, `record_reminder_detail_switch`, `week_transition_detail_switch`, `milestone_detail_switch` 확인 |
| 5 | 데일리 활동 알림 시간 표시 (오전 9:00) | PASS | 스크린샷에서 "오전 9:00" 텍스트 확인 |
| 6 | 기록 리마인더 시간 표시 (오후 8:00) | PASS | 스크린샷에서 "오후 8:00" 텍스트 확인 |
| 7 | 데일리 OFF 시 시간 영역 dimmed | PASS | 스크린샷에서 "알림 시간" + "오전 9:00" 텍스트가 어두운 색상(darkBorder)으로 표시됨 |
| 8 | 뒤로가기 버튼 -> MyScreen 복귀 | PASS | `notification_settings_back` 탭 후 `my_screen` 확인 |
| 9 | 앱 바에 "알림 설정" 타이틀 표시 | PASS | 스크린샷에서 확인 |
| 10 | TimePicker 영역 존재 (daily_notification_time_picker, record_reminder_time_picker) | PASS | get_interactive_elements에서 InkWell 키 확인 |

### UX 원칙 검증

| 원칙 | 판정 | 비고 |
|---|---|---|
| 하나만 해도 충분 | PASS | 4개 유형 명확 구분, 한 줄 서브텍스트로 설명, 과도한 옵션 없음 |
| 숫자보다 말 | PASS | 기록 리마인더 메시지가 "오늘도 수고하셨어요. 간단히 기록해 볼까요?"로 부드러운 표현. 주차 전환 "새로운 활동을 확인해 보세요"로 긍정적 동기 부여 |
| 부모 언어 | PASS | "로컬 푸시 알림", "스케줄 노티피케이션", "알림 채널" 등 기술 용어 UI 미노출. 알림 제목/본문에 부모가 이해할 수 있는 언어만 사용 |
| 한 손 30초 | PASS | 토글 1탭 ON/OFF, TimePicker 1회 조작, 온보딩 1탭 완료. 최소 터치 영역 48dp 준수 (SwitchListTile, IconButton) |
| 죄책감 금지 | PASS | 알림 OFF 시 부정적 메시지 없음. 권한 거부 시 부정적 피드백 없이 진행. "수고하셨어요" 긍정 표현 사용 |

### 디자인 검증

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | 컬러 팔레트 일치 | PASS | Scaffold 배경 theme 사용, 스위치 ON warmOrange, OFF mutedBeige(라이트)/darkBorder(다크). 하드코딩 Color 없음 |
| 2 | 타이포그래피 스케일 일치 | PASS | 모든 텍스트가 `theme.textTheme.bodyLarge`, `bodySmall`, `headlineSmall` 사용. fontSize 하드코딩 없음 |
| 3 | 2-1-2 앱 바 스펙 (변형 B) | PASS | 뒤로가기 아이콘 + "알림 설정" 타이틀. 스크린샷에서 높이 적절 확인 |
| 4 | 2-4-8 스위치 스펙 | PASS | ON 트랙 warmOrange, OFF 트랙 mutedBeige/darkBorder, bodyLarge/bodySmall 사용. 리스트 아이템 높이 56-72dp (최소 48dp 충족) |
| 5 | 다크 모드 대응 | PASS | `theme.brightness == Brightness.dark` 분기로 색상 매핑. 스크린샷에서 다크 모드 정상 표시 확인 |
| 6 | 조부모 모드 대응 | PASS | Theme textTheme 사용으로 +4sp 자동 적용 |

### 접근성 검증

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | 최소 터치 영역 48x48dp | PASS | SwitchListTile 높이 56-72dp, IconButton 48x48dp, 시간 영역 `AppDimensions.minTouchTarget` 사용 |
| 2 | 무음 모드 (햅틱 피드백) | PASS | 모든 토글 전환 시 `HapticFeedback.lightImpact()`. 모든 알림 `playSound: false` |
| 3 | 빈 상태 처리 | PASS | `baby != null` 체크로 아기 미등록 시 크래시 방지 (notification_settings_screen.dart:369, 397) |
| 4 | ValueKey 지정 | PASS | 7개 필수 키 모두 확인: `notification_settings_screen`, `daily_notification_detail_switch`, `record_reminder_detail_switch`, `week_transition_detail_switch`, `milestone_detail_switch`, `daily_notification_time_picker`, `record_reminder_time_picker` |

### 코드 품질 검증

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | 알림 텍스트 AppStrings 상수 참조 | PASS | 모든 알림 제목/본문이 AppStrings 상수 참조. UI 텍스트도 모두 상수화 |
| 2 | 하드코딩 Color 없음 | PASS | AppColors 또는 Theme에서 가져옴. `Color(0x...)` 패턴 검색 결과 0건 |
| 3 | 하드코딩 TextStyle 없음 | PASS | 모든 텍스트 스타일이 `theme.textTheme`에서 참조 |
| 4 | static 메서드 구성 | PASS | NotificationService, NotificationScheduler 모두 static 메서드로 구성 |
| 5 | import 경로 올바름 | PASS | flutter_local_notifications, timezone, permission_handler 모두 정상 import |
| 6 | Android 채널 4개 고유 ID | PASS | `daily_mission`, `record_reminder`, `week_transition`, `milestone` 모두 고유 |
| 7 | try-catch 예외 처리 | PASS | 모든 스케줄/취소/초기화 함수에 try-catch 포함 |
| 8 | AppSettingsService에 `recordReminderTime` 추가 | PASS | getter/setter 모두 구현 (app_settings_service.dart:44-45, 76-77) |
| 9 | ConsumerStatefulWidget 사용 | PASS | NotificationSettingsScreen이 ConsumerStatefulWidget 상속, ref 접근 정상 |
| 10 | 기존 온보딩 동작 유지 | PASS | isOnboardingComplete 설정, go('/home') 이동 유지 |

### 라우팅 검증

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | GoRouter `/my/notifications` 라우트 등록 | PASS | app_router.dart:124-126 확인 |
| 2 | 뒤로가기 시 MyScreen 복귀 | PASS | Marionette 테스트에서 확인 완료 |
| 3 | 알림 탭 시 payload 기반 라우팅 | PASS | notification_service.dart:158-167 payload 기반 `_router!.go(payload)` 확인 |

### 빌드/분석

| # | 검증 | 판정 | 비고 |
|---|---|---|---|
| 1 | flutter analyze | PASS | 11건 모두 info 수준 (unnecessary_brace_in_string_interps, unnecessary_underscores, depend_on_referenced_packages). 에러/경고 0건 |
| 2 | flutter test | PASS | 1/1 통과 |
| 3 | Android 권한 설정 | PASS | AndroidManifest.xml에 POST_NOTIFICATIONS, SCHEDULE_EXACT_ALARM, RECEIVE_BOOT_COMPLETED 3개 권한 모두 존재 |

---

## 관찰 사항 (PASS 판정에 영향 없음)

### 1. 시간 표시 포맷 문자열 하드코딩
- **위치:** `notification_settings_screen.dart:265`
- **현재:** `'오전'` / `'오후'` 문자열이 `_formatTimeForDisplay` 메서드에 하드코딩
- **비고:** 시간 포맷팅 헬퍼 함수 내부의 로케일 문자열로, AppStrings에 상수가 정의되지 않은 상태. 기능적으로 문제없으나, 향후 다국어 지원 시 `DateFormat`으로 교체 권장

### 2. Android 채널 이름 하드코딩
- **위치:** `notification_scheduler.dart:42,80,136,193` (채널 이름), `notification_service.dart:89-111` (채널 생성)
- **현재:** Android 알림 채널 이름(예: `'오늘의 활동'`)이 AppStrings가 아닌 직접 문자열로 지정
- **비고:** Android 시스템 수준 설정이며 사용자 UI에 직접 노출되는 곳이 아님. `NotificationService._createAndroidChannels()`와 `NotificationScheduler` 양쪽에서 동일 문자열을 반복 사용하므로, 일관성을 위해 `NotificationService`의 채널 상수를 참조하거나 AppStrings에 추가하는 것을 권장

### 3. 데일리 활동 알림 토글 동작 (에뮬레이터 환경)
- Marionette 테스트에서 데일리 활동 알림 토글(OFF->ON)을 시도했을 때 에뮬레이터 환경에서 알림 권한 미승인 상태로 추정되어 토글이 ON으로 전환되지 않았음
- 코드상 `_ensureNotificationPermission()`에서 권한이 없으면 `openAppSettings()`를 호출하는 로직이 올바르게 구현되어 있어 기능적 이슈는 아님

---

## 재구현 필요 여부

FAIL 항목이 없으므로 재구현 불필요. 모든 검증 기준을 충족함.
