# Sprint 09: 로컬 알림 (3가지 알림 유형)

## 1. 구현 범위

### 대상 기능

- **NotificationService** (알림 서비스 코어) (개발기획서 섹션 7-1)
  - `flutter_local_notifications` 플러그인 초기화
  - Android 알림 채널 4개 설정 (daily_mission, record_reminder, week_transition, milestone)
  - Android 13+ (API 33) `POST_NOTIFICATIONS` 런타임 권한 요청
  - Android 12+ (API 31) `SCHEDULE_EXACT_ALARM` 권한 요청
  - iOS 알림 권한 요청 (alert=true, badge=true, sound=false -- 무음 모드 기본)
  - 알림 탭 시 GoRouter를 통한 화면 이동 처리 (payload 기반)
  - 알림 ID 상수 관리 (dailyMissionId=1, recordReminderId=2, weekTransitionId=3, milestoneId=4, dangerSignTrackingId=5)

- **NotificationScheduler** (알림 스케줄러) (개발기획서 섹션 7-2)
  - **데일리 미션 알림:**
    - 매일 설정 시간 (기본 오전 9:00) "오늘의 활동이 준비되었어요!" 알림
    - `zonedSchedule` + `matchDateTimeComponents: DateTimeComponents.time` 사용 (반복 알림)
    - 알림 탭 시 활동 탭으로 이동 (payload: `/activity`)
    - Android 채널: `daily_mission` / "오늘의 활동" / importance: default / playSound: false
  - **주차 전환 알림:**
    - 아기 생년월일 기준 다음 주차 전환일 계산
    - 전환일 오전 9:00에 "하루가 X-Y주차에 접어들었어요! 새로운 활동을 확인해보세요" 알림
    - `zonedSchedule` 사용 (일회성, 주차 전환 시마다 다음 전환 예약)
    - 알림 탭 시 홈 화면으로 이동 (payload: `/home`)
    - Android 채널: `week_transition` / "주차 전환" / importance: default / playSound: false
  - **마일스톤 알림:**
    - 생년월일 기반 7일, 14일, 21일, 28일, 30일, 60일, 100일, 200일, 365일 기념일 알림
    - 해당 날 오전 9:00에 "[아기이름]가 태어난 지 N일째!" 알림
    - 이미 지난 날짜는 스케줄링 스킵
    - 알림 ID: milestoneId(4) + targetDays (고유 ID 보장)
    - Android 채널: `milestone` / "성장 마일스톤" / importance: default / playSound: false
  - **일괄 스케줄링:** `scheduleAllMilestones(birthDate, babyName)` -- 9개 마일스톤 일괄 등록
  - **알림 취소:** `cancelAll()`, `cancel(int id)`

- **main.dart 수정** (알림 초기화 연동)
  - `TODO: await NotificationService.initialize();` 주석 해제 및 실제 호출
  - 온보딩 완료 후 + 알림 허용 시 기본 알림 스케줄 등록 트리거

- **온보딩 NotificationPermissionScreen 수정** (기존 파일 보강)
  - 알림 허용 시 `NotificationService.requestPermission()` 호출
  - 허용 시 기본 알림 3종 자동 스케줄 등록 (데일리 미션, 주차 전환, 마일스톤)
  - Android 12+: `Permission.scheduleExactAlarm.request()` 추가 호출

- **마이 탭 알림 토글 연동** (기존 MyScreen 수정)
  - 데일리 활동 알림 토글 ON: `NotificationScheduler.scheduleDailyMission()` 호출
  - 데일리 활동 알림 토글 OFF: `NotificationScheduler.cancel(dailyMissionId)` 호출
  - 주차 전환 알림 토글 ON: `NotificationScheduler.scheduleWeekTransition()` 호출
  - 주차 전환 알림 토글 OFF: `NotificationScheduler.cancel(weekTransitionId)` 호출
  - 성장 마일스톤 알림 토글 ON: `NotificationScheduler.scheduleAllMilestones()` 호출
  - 성장 마일스톤 알림 토글 OFF: 마일스톤 관련 모든 알림 취소
  - 기록 리마인더 토글 ON: `NotificationScheduler.scheduleRecordReminder()` 호출
  - 기록 리마인더 토글 OFF: `NotificationScheduler.cancel(recordReminderId)` 호출
  - 알림 권한이 OS 레벨에서 거부된 상태에서 토글 ON 시: 알림 권한 재요청 또는 `openAppSettings()` 안내

- **알림 설정 상세 화면** (NotificationSettingsScreen -- 신규) (개발기획서 섹션 5-7, 화면 5-2)
  - 데일리 활동 알림: ON/OFF 토글 + TimePicker로 알림 시간 설정 (기본 09:00)
  - 기록 리마인더: ON/OFF 토글 + TimePicker로 알림 시간 설정 (기본 20:00)
  - 주차 전환 알림: ON/OFF 토글 (시간 설정 없음, 전환일 오전 9:00 고정)
  - 성장 마일스톤 알림: ON/OFF 토글 (시간 설정 없음, 해당일 오전 9:00 고정)
  - 마이 탭의 "알림 설정" 영역 탭 시 이 화면으로 이동 (GoRouter push)

### 사용 디자인 컴포넌트

| 컴포넌트 번호 | 이름 | 사용 위치 |
|---|---|---|
| 2-1-2 | 앱 바 (변형 B) | NotificationSettingsScreen (뒤로가기 + "알림 설정") |
| 2-4-8 | 스위치 (SwitchListTile) | NotificationSettingsScreen (4개 알림 토글) |
| 2-3-1 | 기본 CTA 버튼 | 온보딩 NotificationPermissionScreen (기존) |
| 2-3-6 | 텍스트 링크 버튼 | 온보딩 NotificationPermissionScreen (기존) |

---

## 2. 파일 목록

### 신규 생성 파일

| # | 파일 경로 | 설명 |
|---|---|---|
| 1 | `lib/services/notification_service.dart` | 알림 서비스 코어: 플러그인 초기화, 권한 요청, 알림 채널 설정, 알림 탭 핸들링 |
| 2 | `lib/services/notification_scheduler.dart` | 알림 스케줄러: 데일리 미션/기록 리마인더/주차 전환/마일스톤 알림 스케줄링 및 취소 |
| 3 | `lib/features/my/screens/notification_settings_screen.dart` | 알림 설정 상세 화면: 4개 알림 토글 + TimePicker (개발기획서 화면 5-2) |

### 수정할 기존 파일

| # | 파일 경로 | 수정 내용 |
|---|---|---|
| 1 | `lib/main.dart` | `NotificationService.initialize()` 호출 추가 (TODO 주석 해제 및 import) |
| 2 | `lib/features/onboarding/screens/notification_permission_screen.dart` | 알림 허용 시 NotificationService 권한 요청 + 기본 알림 3종 스케줄 등록 |
| 3 | `lib/features/my/screens/my_screen.dart` | 알림 토글 콜백에 NotificationScheduler 호출 연동, "알림 설정" 섹션 탭 시 NotificationSettingsScreen으로 이동 |
| 4 | `lib/core/router/app_router.dart` | `/my/notifications` 라우트 추가 (NotificationSettingsScreen) |
| 5 | `lib/core/constants/app_strings.dart` | 알림 관련 UI 텍스트 상수 추가 (약 20개) |
| 6 | `lib/providers/core_providers.dart` | `notificationServiceProvider`, `notificationSchedulerProvider` 추가 (선택적, static 메서드 사용 시 불필요) |

---

## 3. 데이터 모델

### 3-1. 기존 모델/서비스 활용 (신규 테이블 없음)

이 스프린트는 새로운 DB 테이블을 생성하지 않는다. SharedPreferences 기반의 기존 AppSettingsService를 활용한다.

#### AppSettingsService (기존, `lib/services/app_settings_service.dart`)

이 스프린트에서 사용하는 키:

| 키 | getter | setter | 기본값 | 용도 |
|---|---|---|---|---|
| `isDailyNotificationOn` | `isDailyNotificationOn` (bool) | `setDailyNotificationOn(bool)` | `true` | 데일리 활동 알림 ON/OFF |
| `dailyNotificationTime` | `dailyNotificationTime` (String) | `setDailyNotificationTime(String)` | `'09:00'` | 데일리 알림 시간 (HH:mm 형식) |
| `isRecordReminderOn` | `isRecordReminderOn` (bool) | `setRecordReminderOn(bool)` | `true` | 기록 리마인더 ON/OFF |
| `isWeekTransitionOn` | `isWeekTransitionOn` (bool) | `setWeekTransitionOn(bool)` | `true` | 주차 전환 알림 ON/OFF |
| `isMilestoneOn` | `isMilestoneOn` (bool) | `setMilestoneOn(bool)` | `true` | 성장 마일스톤 알림 ON/OFF |

**추가 필요 키 (AppSettingsService에 추가):**

| 키 | getter | setter | 기본값 | 용도 |
|---|---|---|---|---|
| `recordReminderTime` | `recordReminderTime` (String) | `setRecordReminderTime(String)` | `'20:00'` | 기록 리마인더 시간 (HH:mm 형식) |

#### Baby 모델 (기존, `lib/data/models/baby.dart`)

알림 스케줄링에 필요한 필드:
- `name` -- 마일스톤 알림 메시지에 사용 ("[아기이름]가 태어난 지 N일째!")
- `birthDate` -- 주차 전환일 계산 및 마일스톤 날짜 계산
- `weekLabel` (BabyExt) -- 주차 전환 알림 메시지에 사용

#### WeekCalculator (기존, `lib/core/utils/week_calculator.dart`)

알림 스케줄링에 필요한 계산:
- `calculateWeekLabel(birthDate)` -- 현재 주차 레이블
- `calculateWeekIndex(birthDate)` -- 현재 주차 인덱스 (다음 주차 전환일 계산에 활용)

### 3-2. 상태 관리 흐름

```
온보딩 NotificationPermissionScreen (알림 받기 버튼)
  -> NotificationService.requestPermission()
  -> OS 권한 팝업
  -> 허용 시:
    -> AppSettingsService.setDailyNotificationOn(true)
    -> NotificationScheduler.scheduleDailyMission(time: 09:00)
    -> NotificationScheduler.scheduleNextWeekTransition(baby)
    -> NotificationScheduler.scheduleAllMilestones(baby)
  -> 거부 시:
    -> AppSettingsService.setDailyNotificationOn(false)
    -> 부정적 메시지 없이 바로 홈 이동
```

```
MyScreen (알림 토글 변경)
  -> AppSettingsService.set[알림유형]On(value)
  -> ref.invalidate(appSettingsServiceProvider)
  -> value == true:
    -> NotificationScheduler.schedule[해당알림]()
  -> value == false:
    -> NotificationScheduler.cancel(해당알림ID)
```

```
NotificationSettingsScreen (알림 시간 변경)
  -> AppSettingsService.setDailyNotificationTime(newTime)
  -> NotificationScheduler.cancel(dailyMissionId)
  -> NotificationScheduler.scheduleDailyMission(time: newTime)
  -> ref.invalidate(appSettingsServiceProvider)
```

```
알림 탭 (NotificationService._onNotificationTapped)
  -> payload 파싱 (예: '/activity', '/home')
  -> GoRouter.go(payload) 호출
  -> 해당 화면으로 이동
```

---

## 4. 검증 기준 (Evaluator용)

각 기준은 PASS/FAIL로 판정 가능합니다.

### 기능 검증 -- NotificationService

- [ ] `NotificationService.initialize()`가 main.dart에서 `runApp()` 이전에 호출된다 (기존 TODO 주석이 실제 코드로 대체됨)
- [ ] Android 초기화: `AndroidInitializationSettings('@mipmap/ic_launcher')`로 앱 아이콘이 알림 아이콘으로 설정된다
- [ ] iOS 초기화: `DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: false)`로 무음 모드 기본 설정이 적용된다
- [ ] `NotificationService.requestPermission()` 호출 시 Android에서 `AndroidFlutterLocalNotificationsPlugin.requestNotificationsPermission()`이 호출된다
- [ ] `NotificationService.requestPermission()` 호출 시 iOS에서 `IOSFlutterLocalNotificationsPlugin.requestPermissions(alert: true, badge: true, sound: false)`가 호출된다
- [ ] 알림 탭 시 `_onNotificationTapped` 콜백이 실행되고, payload에 포함된 라우트 경로로 GoRouter 이동이 발생한다
- [ ] 알림 ID 상수 5개가 정의되어 있다: dailyMissionId=1, recordReminderId=2, weekTransitionId=3, milestoneId=4, dangerSignTrackingId=5
- [ ] `NotificationService` 클래스가 `lib/services/notification_service.dart` 경로에 존재한다

### 기능 검증 -- NotificationScheduler

- [ ] `scheduleDailyMission(time, activityName, duration)` 호출 시 `zonedSchedule`이 dailyMissionId(1)로 호출된다
- [ ] 데일리 미션 알림의 Android 채널 ID가 `'daily_mission'`이고 채널 이름이 `'오늘의 활동'`이다
- [ ] 데일리 미션 알림이 `matchDateTimeComponents: DateTimeComponents.time`을 사용하여 매일 반복된다
- [ ] 데일리 미션 알림의 `playSound`가 `false`로 설정되어 있다 (무음 모드 기본)
- [ ] `scheduleRecordReminder(time)` 호출 시 `zonedSchedule`이 recordReminderId(2)로 호출된다
- [ ] 기록 리마인더 알림 본문이 "오늘도 수고하셨어요. 간단히 기록해 볼까요?"이다 (죄책감 없는 표현)
- [ ] `scheduleWeekTransition(transitionDate, weekLabel)` 호출 시 해당 날짜 오전 9:00으로 스케줄된다
- [ ] 주차 전환 알림 본문에 weekLabel이 포함된다: "오늘부터 {weekLabel}예요! 새로운 활동을 확인해 보세요."
- [ ] `scheduleMilestone(birthDate, targetDays, babyName)` 호출 시 알림 ID가 `milestoneId + targetDays`로 설정된다 (고유 ID)
- [ ] 마일스톤 알림 본문에 아기 이름과 일수가 포함된다: "{babyName}가 태어난 지 {targetDays}일째!"
- [ ] 이미 지난 날짜에 대한 마일스톤 알림은 스케줄되지 않는다 (`scheduledDate.isBefore(now)` 체크)
- [ ] `scheduleAllMilestones(birthDate, babyName)` 호출 시 9개 마일스톤(7, 14, 21, 28, 30, 60, 100, 200, 365일)이 일괄 등록된다
- [ ] `cancelAll()` 호출 시 `FlutterLocalNotificationsPlugin.cancelAll()`이 호출된다
- [ ] `cancel(int id)` 호출 시 `FlutterLocalNotificationsPlugin.cancel(id)`가 호출된다
- [ ] `_nextInstanceOfTime(TimeOfDay)` 유틸 함수가 현재 시간 이전이면 다음 날로 계산한다
- [ ] 모든 스케줄 함수에서 `androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle`이 사용된다
- [ ] 모든 알림의 timezone이 Asia/Seoul(KST)로 설정되어 있다 (main.dart에서 `tz.setLocalLocation` 호출 확인)

### 기능 검증 -- 온보딩 NotificationPermissionScreen 수정

- [ ] "알림 받기" 버튼 탭 시 `NotificationService.requestPermission()`이 호출된다
- [ ] OS 알림 권한 허용 시 `AppSettingsService.setDailyNotificationOn(true)`가 호출된다
- [ ] OS 알림 권한 허용 시 데일리 미션 알림이 기본 시간(09:00)으로 스케줄 등록된다
- [ ] OS 알림 권한 허용 시 현재 아기의 다음 주차 전환 알림이 스케줄 등록된다
- [ ] OS 알림 권한 허용 시 현재 아기의 마일스톤 알림 9개가 일괄 스케줄 등록된다
- [ ] OS 알림 권한 거부 시 `AppSettingsService.setDailyNotificationOn(false)`가 호출된다
- [ ] OS 알림 권한 거부 시 부정적 메시지 없이 바로 홈으로 이동한다
- [ ] "나중에 설정할게요" 탭 시 알림 스케줄 등록 없이 홈으로 이동한다
- [ ] 온보딩 완료 후 `isOnboardingComplete = true`가 설정된다 (기존 동작 유지)

### 기능 검증 -- 마이 탭 알림 토글 연동

- [ ] 데일리 활동 알림 토글 ON -> `NotificationScheduler.scheduleDailyMission()`이 호출되고 SharedPreferences에 `isDailyNotificationOn=true`가 저장된다
- [ ] 데일리 활동 알림 토글 OFF -> `NotificationScheduler.cancel(dailyMissionId)`가 호출되고 SharedPreferences에 `isDailyNotificationOn=false`가 저장된다
- [ ] 기록 리마인더 토글 ON -> `NotificationScheduler.scheduleRecordReminder()`가 호출된다
- [ ] 기록 리마인더 토글 OFF -> `NotificationScheduler.cancel(recordReminderId)`가 호출된다
- [ ] 주차 전환 알림 토글 ON -> `NotificationScheduler.scheduleWeekTransition()`이 호출된다
- [ ] 주차 전환 알림 토글 OFF -> `NotificationScheduler.cancel(weekTransitionId)`가 호출된다
- [ ] 성장 마일스톤 토글 ON -> `NotificationScheduler.scheduleAllMilestones()`가 호출된다
- [ ] 성장 마일스톤 토글 OFF -> 마일스톤 관련 알림들이 취소된다 (milestoneId + 각 targetDays에 대해 cancel 호출)
- [ ] OS 레벨에서 알림 권한이 거부된 상태에서 토글 ON 시 적절한 안내가 제공된다 (openAppSettings 호출 또는 권한 재요청)
- [ ] 앱 재시작 후에도 SharedPreferences에서 알림 설정 상태가 복원되고, 복원된 설정에 따라 알림 스케줄이 유지된다

### 기능 검증 -- NotificationSettingsScreen

- [ ] 앱 바에 "알림 설정" 타이틀과 뒤로가기 버튼이 표시된다 (2-1-2 변형 B)
- [ ] 데일리 활동 알림 섹션: SwitchListTile(ON/OFF) + "오늘의 활동 알림" 서브텍스트 + 알림 시간 표시 ("오전 9:00")
- [ ] 데일리 활동 알림 시간 영역 탭 시 TimePicker(또는 CupertinoTimePicker)가 열린다
- [ ] TimePicker에서 시간 선택 시 AppSettingsService.setDailyNotificationTime()이 호출되고, 기존 알림 취소 후 새 시간으로 재스케줄된다
- [ ] 기록 리마인더 섹션: SwitchListTile(ON/OFF) + "오늘 기록을 아직 안 하셨을 때 알림" 서브텍스트 + 알림 시간 표시 ("오후 8:00")
- [ ] 기록 리마인더 시간 영역 탭 시 TimePicker가 열린다
- [ ] 주차 전환 알림 섹션: SwitchListTile(ON/OFF) + "새로운 주차에 접어들면 알림" 서브텍스트 (시간 설정 없음)
- [ ] 성장 마일스톤 알림 섹션: SwitchListTile(ON/OFF) + "태어난 지 N일!" 서브텍스트 (시간 설정 없음)
- [ ] GoRouter에 `/my/notifications` 라우트가 등록되어 있고, NotificationSettingsScreen이 빌드된다
- [ ] MyScreen에서 "알림 설정" 영역 탭 시 NotificationSettingsScreen으로 GoRouter push 이동한다
- [ ] NotificationSettingsScreen에서 뒤로가기 시 MyScreen으로 복귀한다
- [ ] 데일리 활동 알림이 OFF 상태일 때 알림 시간 영역이 비활성화(dimmed)되고 탭 불가하다

### UX 원칙 검증

- [ ] **"하나만 해도 충분하다" 원칙:** 알림 설정 화면은 4개 유형으로 명확히 구분되어 있으며, 각 알림의 목적이 한 줄 서브텍스트로 설명된다. 과도한 옵션이나 복잡한 설정이 없다
- [ ] **숫자보다 말로 안심시키는지:** 기록 리마인더 메시지가 "오늘 하루 기록을 아직 안 하셨어요"가 아니라 "오늘도 수고하셨어요. 간단히 기록해 볼까요?"로 부드럽게 표현된다. 주차 전환 메시지가 "새로운 활동을 확인해 보세요"로 긍정적 동기를 부여한다
- [ ] **전문 용어 대신 부모 언어 사용 여부:** "로컬 푸시 알림" 대신 "데일리 활동 알림", "스케줄 노티피케이션" 대신 "알림 시간", "알림 채널" 같은 기술 용어가 UI에 노출되지 않는다. 알림 제목/본문에 전문 용어 없이 부모가 이해할 수 있는 언어만 사용된다
- [ ] **한 손 30초 완료 가능 여부:** 알림 ON/OFF는 토글 1번 탭으로 즉시 완료. 알림 시간 변경은 TimePicker 1번 조작으로 완료. 온보딩 알림 권한은 "알림 받기" 또는 "나중에 설정할게요" 1번 탭으로 완료
- [ ] **죄책감 유발 요소 없음:** 알림을 OFF로 설정해도 "알림을 끄면 활동을 놓칠 수 있어요" 같은 부정적 메시지가 없다. 알림 권한 거부 시에도 부정적 피드백 없이 바로 진행된다. 기록 리마인더 알림에 "아직 안 하셨어요" 대신 "수고하셨어요" 긍정 표현을 사용한다

### 디자인 검증

- [ ] **컬러 팔레트 일치:** NotificationSettingsScreen의 Scaffold 배경 cream(#FFF8F0), 스위치 활성 트랙 warmOrange(#F5A623), 비활성 트랙 mutedBeige(#C4B5A5), 텍스트 darkBrown(#3D3027), 서브텍스트 warmGray(#8C7B6B)
- [ ] **타이포그래피 스케일 일치:** 모든 텍스트가 `Theme.of(context).textTheme`에서 가져온 스타일을 사용하며 하드코딩된 fontSize가 없다
- [ ] **2-1-2 앱 바 스펙 일치 (변형 B):** NotificationSettingsScreen 앱 바에 뒤로가기 아이콘 + "알림 설정" 타이틀, 높이 56dp
- [ ] **2-4-8 스위치 스펙 일치:** 리스트 아이템 높이 최소 48dp, ON 트랙 warmOrange(#F5A623), OFF 트랙 mutedBeige(#C4B5A5), 레이블 Body1(15sp), 보조 설명 Caption(12sp warmGray)
- [ ] **다크 모드 대응:** NotificationSettingsScreen이 다크 모드에서 정상 표시 -- darkBg(#1A1512), 텍스트 darkTextPrimary(#F5EDE3), 스위치 OFF 트랙 darkBorder(#3D3027)
- [ ] **조부모 모드 대응:** 조부모 모드 ON 시 NotificationSettingsScreen의 모든 텍스트가 +4sp 증가된 상태로 표시되고 레이아웃 깨짐이 없다

### 접근성 검증

- [ ] **최소 터치 영역 48x48dp:** NotificationSettingsScreen의 모든 SwitchListTile, TimePicker 영역, 뒤로가기 버튼의 터치 영역이 48x48dp 이상이다
- [ ] **무음 모드 동작 (햅틱 피드백):** 알림 토글 전환 시 `HapticFeedback.lightImpact()`가 실행된다. 모든 알림의 `playSound`가 `false`로 설정되어 있다 (무음 모드 기본)
- [ ] **빈 상태(empty state) 처리:** 아기가 등록되지 않은 상태에서 알림 스케줄링 시도 시 크래시 없이 안전하게 처리된다 (null 체크)
- [ ] **ValueKey 지정:** 모든 주요 위젯에 ValueKey가 지정되어 있다 -- `notification_settings_screen`, `daily_notification_detail_switch`, `record_reminder_detail_switch`, `week_transition_detail_switch`, `milestone_detail_switch`, `daily_notification_time_picker`, `record_reminder_time_picker`

### 코드 품질 검증

- [ ] 모든 알림 제목/본문 텍스트가 AppStrings 상수를 참조하며 하드코딩된 한국어 문자열이 없다
- [ ] 모든 색상이 AppColors 또는 Theme에서 가져오며 하드코딩된 Color 값이 없다
- [ ] 모든 텍스트 스타일이 `Theme.of(context).textTheme`에서 가져오며 하드코딩된 TextStyle이 없다
- [ ] `NotificationService`와 `NotificationScheduler`가 static 메서드로 구성되어 별도 Provider 없이도 호출 가능하다
- [ ] `flutter_local_notifications`, `timezone`, `permission_handler` 패키지의 import 경로가 올바르다
- [ ] Android 알림 채널 4개(`daily_mission`, `record_reminder`, `week_transition`, `milestone`)가 각각 고유한 채널 ID를 가진다
- [ ] 모든 알림 스케줄 함수에 try-catch 예외 처리가 있어 플랫폼 미지원 등의 에러 시 앱이 크래시하지 않는다
- [ ] AppSettingsService에 `recordReminderTime` 키가 추가되고, getter/setter가 올바르게 구현된다
- [ ] ConsumerWidget 또는 ConsumerStatefulWidget을 사용하여 Riverpod ref 접근이 올바르게 이루어진다
- [ ] `notification_permission_screen.dart` 수정 시 기존 동작(온보딩 완료 플래그 설정, 홈 이동)이 깨지지 않는다

### 라우팅 검증

- [ ] GoRouter에 `/my/notifications` 라우트가 등록되어 있고, NotificationSettingsScreen이 빌드된다
- [ ] NotificationSettingsScreen에서 뒤로가기(AppBar leading 또는 시스템 백 버튼) 시 MyScreen으로 복귀한다
- [ ] 알림 탭 시 payload로 전달된 라우트(`/activity`, `/home` 등)로 정상 이동한다

---

## 5. 의존성

### 이전 스프린트 의존

| 스프린트 | 필요 산출물 |
|---|---|
| Sprint 01 (Setup) | 프로젝트 구조, AppColors, AppTextStyles, AppRadius, AppDimensions, AppShadows, AppStrings, lightTheme/darkTheme, grandparentTheme, timezone 초기화 (Asia/Seoul) |
| Sprint 02 (Onboarding) | Baby 모델, BabyDao, AppSettingsService (알림 관련 키 포함), activeBabyProvider, appSettingsServiceProvider, GoRouter 기본 구조, NotificationPermissionScreen (기존) |
| Sprint 03 (Home) | MainShell, HomeScreen (알림 탭 시 이동 대상) |
| Sprint 05 (Activity) | ActivityListScreen (데일리 미션 알림 탭 시 이동 대상) |
| Sprint 08 (My) | MyScreen (알림 토글 UI -- 기존 SharedPreferences 플래그만 저장, 이번 스프린트에서 실제 스케줄링 연동) |

### 필요한 패키지 (이미 설치됨)

| 패키지 | 버전 (pubspec.yaml) | 용도 |
|---|---|---|
| `flutter_local_notifications` | ^21.0.0 | 로컬 알림 플러그인 (채널 설정, 스케줄링, 표시) |
| `timezone` | ^0.11.0 | 시간대 처리 (Asia/Seoul KST 고정, TZDateTime 생성) |
| `permission_handler` | ^11.3.1 | OS 알림 권한 요청 (Android 13+, iOS) |
| `flutter_riverpod` | ^3.3.1 | 상태 관리 (AppSettingsService 참조) |
| `go_router` | ^17.1.0 | 라우팅 (알림 탭 시 화면 이동, 라우트 추가) |
| `shared_preferences` | ^2.5.5 | AppSettingsService (알림 설정 저장) |

### 추가 패키지

없음. 모든 필요 패키지가 이미 설치되어 있다.

### Android 네이티브 설정 (확인 필요)

- `android/app/src/main/AndroidManifest.xml`에 다음 권한이 있는지 확인:
  - `<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>` (Android 13+)
  - `<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>` (Android 12+)
  - `<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>` (기기 재부팅 후 알림 복원)
- `android/app/build.gradle`에서 `compileSdkVersion`이 33 이상인지 확인

### iOS 네이티브 설정 (확인 필요)

- `ios/Runner/AppDelegate.swift`에서 알림 관련 초기 설정이 필요할 수 있다 (flutter_local_notifications 문서 참조)

---

## 6. 구현 순서 가이드 (Generator용 참고)

1. **AppStrings 확장** -- 알림 관련 모든 UI 텍스트 상수 추가 (알림 제목, 본문, 설정 화면 레이블 등 약 20개)
2. **AppSettingsService 확장** -- `recordReminderTime` 키/getter/setter 추가
3. **NotificationService 생성** -- 플러그인 초기화, 권한 요청, 알림 탭 핸들링
4. **NotificationScheduler 생성** -- 4종 알림 스케줄링/취소 함수, `_nextInstanceOfTime` 유틸
5. **main.dart 수정** -- `NotificationService.initialize()` 호출 추가
6. **notification_permission_screen.dart 수정** -- 알림 허용 시 기본 알림 스케줄 등록 (activeBabyProvider에서 아기 정보 조회 필요)
7. **NotificationSettingsScreen 생성** -- 4개 알림 토글 + TimePicker 2개 + 화면 레이아웃
8. **app_router.dart 수정** -- `/my/notifications` 라우트 추가
9. **my_screen.dart 수정** -- 알림 토글 콜백에 NotificationScheduler 호출 추가, "알림 설정" 헤더 또는 영역 탭 시 NotificationSettingsScreen 이동 추가
10. **Android/iOS 네이티브 설정 확인 및 수정** -- 권한, 채널 설정

## 7. 알림 메시지 텍스트 (AppStrings에 추가할 상수)

Generator가 참조할 알림 메시지 목록:

| 상수 이름 | 값 | 용도 |
|---|---|---|
| `notifDailyMissionTitle` | `'오늘의 활동'` | 데일리 미션 알림 제목 |
| `notifDailyMissionBodyTemplate` | `'{activityName} ({duration})'` | 데일리 미션 알림 본문 (동적 치환) |
| `notifDailyMissionDefaultBody` | `'오늘의 활동이 준비되었어요!'` | 데일리 미션 알림 기본 본문 (활동명 미확정 시) |
| `notifRecordReminderTitle` | `'하루 한 가지'` | 기록 리마인더 알림 제목 |
| `notifRecordReminderBody` | `'오늘도 수고하셨어요. 간단히 기록해 볼까요?'` | 기록 리마인더 알림 본문 |
| `notifWeekTransitionTitle` | `'새로운 주차!'` | 주차 전환 알림 제목 |
| `notifWeekTransitionBodyTemplate` | `'오늘부터 {weekLabel}예요! 새로운 활동을 확인해 보세요.'` | 주차 전환 알림 본문 (동적 치환) |
| `notifMilestoneTitle` | `'성장 마일스톤!'` | 마일스톤 알림 제목 |
| `notifMilestoneBodyTemplate` | `'{babyName}가 태어난 지 {days}일째!'` | 마일스톤 알림 본문 (동적 치환) |
| `notifSettingsTitle` | `'알림 설정'` | NotificationSettingsScreen 앱 바 타이틀 |
| `notifDailyActivityLabel` | `'데일리 활동 알림'` | 설정 화면 토글 레이블 |
| `notifDailyActivitySub` | `'"오늘의 활동" 알림'` | 설정 화면 서브텍스트 |
| `notifDailyTimeLabel` | `'알림 시간'` | 설정 화면 시간 레이블 |
| `notifRecordReminderLabel` | `'기록 리마인더'` | 설정 화면 토글 레이블 |
| `notifRecordReminderSub` | `'오늘 기록을 아직 안 하셨을 때 알림'` | 설정 화면 서브텍스트 |
| `notifWeekTransitionLabel` | `'주차 전환 알림'` | 설정 화면 토글 레이블 |
| `notifWeekTransitionSub` | `'새로운 주차에 접어들면 알림'` | 설정 화면 서브텍스트 |
| `notifMilestoneLabel` | `'성장 마일스톤 알림'` | 설정 화면 토글 레이블 |
| `notifMilestoneSub` | `'"태어난 지 N일!"'` | 설정 화면 서브텍스트 |

**참고:** 일부 상수는 기존 AppStrings에 이미 존재하므로 (예: `dailyActivityNotification`, `recordReminder`, `weekTransitionNotification`, `growthMilestone`), 중복 방지를 위해 기존 상수를 우선 활용하고 부족한 것만 추가한다.
