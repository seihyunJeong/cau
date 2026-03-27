# Sprint 01: 프로젝트 초기 셋업

## 1. 구현 범위

이 스프린트는 앱의 **기반 인프라**를 구축한다. 이후 모든 스프린트에서 사용할 디자인 토큰, 테마, 데이터베이스, 설정 서비스, 유틸리티, 공통 위젯을 구현한다.

### 구현 항목

| # | 항목 | 설명 | 관련 문서 섹션 |
|---|---|---|---|
| 1 | AppColors | 디자인 토큰 컬러 상수 (라이트 + 다크 + 확장) | 디자인컴포넌트 1-1 |
| 2 | AppTextStyles | 타이포그래피 스케일 상수 (15개 레벨) | 디자인컴포넌트 1-2 |
| 3 | AppDimensions | 스페이싱 / 터치 영역 / 레이아웃 상수 | 디자인컴포넌트 1-3 |
| 4 | AppRadius | 모서리 둥글기 토큰 | 디자인컴포넌트 1-4 |
| 5 | AppShadows | 그림자/엘리베이션 토큰 | 디자인컴포넌트 1-5 |
| 6 | AppTheme | ThemeData 설정 (라이트/다크 모드) | 디자인컴포넌트 4-1 |
| 7 | GrandparentTheme | 조부모 모드 테마 (텍스트 +4sp) | 디자인컴포넌트 4-2 |
| 8 | AppStrings | 한국어 문자열 상수 (용어 통일 가이드) | 개발기획서 1-3, 1-4 |
| 9 | DatabaseHelper | sqflite 싱글톤 + 전체 7개 테이블 생성 | 개발기획서 4-3 |
| 10 | Tables | CREATE TABLE SQL 상수 | 개발기획서 4-2-1 |
| 11 | AppSettingsService | SharedPreferences 기반 설정 관리 | 개발기획서 4-2 (AppSettings) |
| 12 | nowKST() | KST 기준 현재 시각 헬퍼 함수 | 개발기획서 4-4 |
| 13 | InfoTerm | 전문 용어 -> 부모 언어 툴팁 재사용 위젯 | 개발기획서 1-4 |
| 14 | main.dart | 앱 진입점 (KST, DB, SharedPreferences, 알림 초기화) | 개발기획서 4-4 |
| 15 | app.dart | MaterialApp + ProviderScope 래핑 (테마 적용) | 개발기획서 3 |
| 16 | Riverpod Providers | databaseHelperProvider, appSettingsServiceProvider 등 기반 Provider | 개발기획서 4-4 |
| 17 | MarionetteBinding | 디버그 모드 전용 marionette_flutter 바인딩 | pubspec.yaml (dev_dependencies) |

### 사용 디자인 컴포넌트 번호
- 1-1 컬러 팔레트
- 1-2 타이포그래피 스케일
- 1-3 간격 시스템
- 1-4 모서리 둥글기
- 1-5 그림자/엘리베이션
- 1-6 아이콘 크기 (상수 정의만)
- 4-1 라이트/다크 모드
- 4-2 조부모 모드 변형

---

## 2. 파일 목록

### 생성할 파일

```
lib/
├── main.dart                                    # 앱 진입점 (기존 파일 전면 교체)
├── app.dart                                     # HaruHanGajiApp MaterialApp 위젯
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart                      # AppColors 클래스
│   │   ├── app_text_styles.dart                 # AppTextStyles 클래스
│   │   ├── app_dimensions.dart                  # AppDimensions 클래스
│   │   ├── app_radius.dart                      # AppRadius 클래스
│   │   ├── app_shadows.dart                     # AppShadows 클래스
│   │   └── app_strings.dart                     # AppStrings 클래스
│   │
│   ├── theme/
│   │   ├── app_theme.dart                       # lightTheme() / darkTheme()
│   │   └── grandparent_theme.dart               # grandparentTheme(ThemeData base)
│   │
│   ├── utils/
│   │   └── date_utils.dart                      # nowKST() 헬퍼 함수
│   │
│   └── widgets/
│       └── info_term.dart                       # InfoTerm 재사용 위젯
│
├── data/
│   └── database/
│       ├── database_helper.dart                 # DatabaseHelper 싱글톤
│       └── tables.dart                          # Tables SQL 상수
│
├── providers/
│   └── core_providers.dart                      # databaseHelperProvider, appSettingsServiceProvider 등
│
└── services/
    └── app_settings_service.dart                # AppSettingsService 클래스
```

### 수정할 파일

| 파일 | 수정 내용 |
|---|---|
| `lib/main.dart` | 기존 Flutter 데모 코드를 완전히 교체하여 KST/DB/SharedPreferences/알림 초기화 + ProviderScope + MarionetteBinding 적용 |

---

## 3. 데이터 모델

이 스프린트에서는 **테이블 스키마(DDL)만 정의**한다. 모델 클래스와 DAO는 이후 스프린트에서 각 기능과 함께 구현한다.

### 3-1. sqflite 테이블 (Tables 클래스)

| 테이블 | SQL 상수명 | 개발기획서 참조 |
|---|---|---|
| `babies` | `Tables.createBabies` | 4-2-1 |
| `daily_records` | `Tables.createDailyRecords` | 4-2-1 |
| `growth_records` | `Tables.createGrowthRecords` | 4-2-1 |
| `activity_records` | `Tables.createActivityRecords` | 4-2-1 |
| `observation_records` | `Tables.createObservationRecords` | 4-2-1 |
| `checklist_records` | `Tables.createChecklistRecords` | 4-2-1 |
| `danger_sign_records` | `Tables.createDangerSignRecords` | 4-2-1 |

### 3-2. SharedPreferences 키 (AppSettingsService)

| 키 | 타입 | 기본값 | 용도 |
|---|---|---|---|
| `isOnboardingComplete` | bool | false | 온보딩 완료 여부 |
| `themeMode` | String | 'system' | 테마 모드 (system/light/dark) |
| `isGrandparentMode` | bool | false | 조부모 모드 ON/OFF |
| `isDailyNotificationOn` | bool | true | 데일리 미션 알림 |
| `dailyNotificationTime` | String | '09:00' | 데일리 알림 시간 |
| `isRecordReminderOn` | bool | true | 기록 리마인더 알림 |
| `isWeekTransitionOn` | bool | true | 주차 전환 알림 |
| `isMilestoneOn` | bool | true | 마일스톤 알림 |
| `isSilentMode` | bool | true | 무음 모드 (기본 ON) |
| `activeBabyId` | int? | null | 현재 활성 아기 ID |

### 3-3. Riverpod Provider (core_providers.dart)

| Provider | 타입 | 용도 |
|---|---|---|
| `databaseHelperProvider` | `Provider<DatabaseHelper>` | DB 싱글톤 주입 |
| `appSettingsServiceProvider` | `Provider<AppSettingsService>` | 설정 서비스 주입 |

---

## 4. 검증 기준 (Evaluator용)

### 기능 검증

#### AppColors (app_colors.dart)
- [ ] `AppColors` 클래스가 `abstract class`로 선언되어 인스턴스화 불가능하다
- [ ] 기본 컬러 7개 상수가 정확한 Hex 값으로 정의되어 있다: cream(`0xFFFFF8F0`), warmOrange(`0xFFF5A623`), softGreen(`0xFF7BC67E`), softYellow(`0xFFFFD93D`), softRed(`0xFFFF6B6B`), darkBrown(`0xFF3D3027`), warmGray(`0xFF8C7B6B`)
- [ ] 확장 컬러 11개 상수가 정확한 Hex 값으로 정의되어 있다: white(`0xFFFFFFFF`), lightBeige(`0xFFF0E6D8`), paleCream(`0xFFFFF3E8`), mutedBeige(`0xFFC4B5A5`), mintTint(`0xFFF0F9F0`), trackGray(`0xFFE8DDD0`), overlayBlack(`0x40000000`), radarFill(`0x33F5A623`), growthBand(`0x337BC67E`), navWhite(=white), tooltipCream(=cream)
- [ ] 다크 모드 컬러 5개 상수가 정확한 Hex 값으로 정의되어 있다: darkBg(`0xFF1A1512`), darkCard(`0xFF2A231D`), darkBorder(`0xFF3D3027`), darkTextPrimary(`0xFFF5EDE3`), darkTextSecondary(`0xFFA89888`)

#### AppTextStyles (app_text_styles.dart)
- [ ] `AppTextStyles` 클래스가 `abstract class`로 선언되어 있다
- [ ] 15개 텍스트 스타일이 정의되어 있다: display, h1, h2, h3, body1, body2, caption, small, tiny, data, dataSmall, button, buttonSmall, timerDisplay, tooltipTitle, tooltipBody
- [ ] 각 스타일의 fontSize, fontWeight, height, color가 디자인컴포넌트 1-2 스펙과 일치한다
- [ ] fontFamily가 'Pretendard'로 설정되어 있다
- [ ] display: fontSize=28, fontWeight=w700, height=1.3, color=darkBrown
- [ ] h1: fontSize=22, fontWeight=w600, height=1.4, color=darkBrown
- [ ] h2: fontSize=18, fontWeight=w600, height=1.4, color=darkBrown
- [ ] h3: fontSize=16, fontWeight=w600, height=1.4, color=darkBrown
- [ ] body1: fontSize=15, fontWeight=w400, height=1.6, color=darkBrown
- [ ] body2: fontSize=14, fontWeight=w400, height=1.5, color=darkBrown
- [ ] caption: fontSize=13, fontWeight=w400, height=1.4, color=warmGray
- [ ] small: fontSize=11, fontWeight=w400, height=1.4, color=warmGray
- [ ] tiny: fontSize=8, fontWeight=w400, height=1.3, color=warmGray
- [ ] data: fontSize=32, fontWeight=w700, height=1.2, color=darkBrown
- [ ] dataSmall: fontSize=12, fontWeight=w500, height=1.3, color=warmGray
- [ ] button: fontSize=16, fontWeight=w600, height=1.0, color=white
- [ ] buttonSmall: fontSize=14, fontWeight=w500, height=1.0, color=warmOrange
- [ ] timerDisplay: fontSize=48, fontWeight=w700, height=1.0, color=darkBrown
- [ ] tooltipTitle: fontSize=14, fontWeight=w700, height=1.4, color=darkBrown
- [ ] tooltipBody: fontSize=13, fontWeight=w400, height=1.5, color=warmGray

#### AppDimensions (app_dimensions.dart)
- [ ] `AppDimensions` 클래스가 `abstract class`로 선언되어 있다
- [ ] 8개 간격 토큰이 정확한 값으로 정의되어 있다: xxs=2, xs=4, sm=8, md=12, base=16, lg=24, xl=32, xxl=48
- [ ] 레이아웃 상수 5개가 정의되어 있다: screenPaddingH=16, cardPadding=16, cardPaddingCompact=12, sectionGap=24, cardGap=12
- [ ] 터치 영역 상수가 정의되어 있다: minTouchTarget=48
- [ ] 고정 높이 상수 3개가 정의되어 있다: appBarHeight=56, bottomNavHeight=64, stickyButtonAreaHeight=72

#### AppRadius (app_radius.dart)
- [ ] `AppRadius` 클래스가 `abstract class`로 선언되어 있다
- [ ] 6개 토큰이 정확한 값으로 정의되어 있다: none=0, sm=8, md=12, lg=16, xl=24, full=999

#### AppShadows (app_shadows.dart)
- [ ] `AppShadows` 클래스가 `abstract class`로 선언되어 있다
- [ ] 3개 레벨이 `List<BoxShadow>` 타입 const 필드로 정의되어 있다: low, medium, high
- [ ] low: color=`0x0D000000`, blurRadius=4, offset=Offset(0, 1)
- [ ] medium: color=`0x1A000000`, blurRadius=8, offset=Offset(0, 2)
- [ ] high: color=`0x26000000`, blurRadius=16, offset=Offset(0, -2)

#### AppTheme (app_theme.dart)
- [ ] `lightTheme()` 함수가 `ThemeData`를 반환한다
- [ ] `darkTheme()` 함수가 `ThemeData`를 반환한다
- [ ] 라이트 테마의 scaffoldBackgroundColor가 `AppColors.cream` (`#FFF8F0`)이다
- [ ] 다크 테마의 scaffoldBackgroundColor가 `AppColors.darkBg` (`#1A1512`)이다
- [ ] 라이트 테마의 primaryColor/colorScheme.primary가 `AppColors.warmOrange`이다
- [ ] 다크 테마의 primaryColor/colorScheme.primary가 `AppColors.warmOrange`이다
- [ ] 라이트 테마의 cardColor/cardTheme.color가 `AppColors.white`이다
- [ ] 다크 테마의 cardColor/cardTheme.color가 `AppColors.darkCard`이다
- [ ] AppBar 테마에서 elevation이 0이다 (라이트/다크 모두)
- [ ] AppBar 배경이 라이트: cream, 다크: darkBg로 설정되어 있다
- [ ] 라이트/다크 모두에서 텍스트 테마 기본 색상이 각각 darkBrown/darkTextPrimary로 설정되어 있다

#### GrandparentTheme (grandparent_theme.dart)
- [ ] `grandparentTheme(ThemeData base)` 함수가 `ThemeData`를 반환한다
- [ ] 반환된 테마의 textTheme에 fontSizeDelta +4가 적용되어 있다
- [ ] 원본 base 테마의 나머지 속성(색상 등)이 유지된다

#### AppStrings (app_strings.dart)
- [ ] `AppStrings` 클래스가 `abstract class`로 선언되어 있다
- [ ] 탭 이름 5개가 정의되어 있다: home='홈', record='기록', activity='활동', devCheck='발달', my='마이'
- [ ] 버튼 텍스트가 정의되어 있다: startActivity='시작하기', recordComplete='기록 완료', viewResult='결과 보기'
- [ ] 기능명 문자열이 정의되어 있다: observationTitle='오늘 아기는 어땠나요?', checklistTitle='이번 주 발달 살펴보기', resultTitle='오늘의 관찰 결과', dangerSignTitle='함께 살펴볼 점', solutionTitle='이렇게 해보세요'
- [ ] 상태 메시지가 정의되어 있다: notRecorded='언제든 기록할 수 있어요', welcomeBack='다시 오셨네요. 오늘부터 편하게 시작해요.'
- [ ] 앱 이름이 정의되어 있다: appName='하루 한 가지'
- [ ] 면책 문구가 정의되어 있다 (발달 탭 하단에 사용할 전문가 면책 문구)

#### DatabaseHelper (database_helper.dart)
- [ ] `DatabaseHelper` 클래스에 `static final instance` 싱글톤 패턴이 적용되어 있다
- [ ] `Future<Database> get database` getter가 존재하며, 최초 호출 시 DB를 초기화한다
- [ ] DB 파일명이 'haru_hanagaji.db'이다
- [ ] `_createDB` 메서드에서 7개 테이블(`babies`, `daily_records`, `growth_records`, `activity_records`, `observation_records`, `checklist_records`, `danger_sign_records`)을 생성한다
- [ ] `_upgradeDB` 메서드가 존재한다 (빈 구현이라도)
- [ ] `close()` 메서드가 존재하며 DB를 닫고 `_database`를 null로 초기화한다

#### Tables (tables.dart)
- [ ] `Tables` 클래스에 7개의 static const String 필드가 존재한다
- [ ] `createBabies` SQL에 id, name, birth_date, profile_image_path, created_at, is_active 컬럼이 포함되어 있다
- [ ] `createDailyRecords` SQL에 id, baby_id, date, feeding_count, diaper_count, sleep_hours, memo, created_at, updated_at 컬럼이 포함되어 있다
- [ ] `createGrowthRecords` SQL에 id, baby_id, date, weight_kg, height_cm, head_circum_cm, created_at 컬럼이 포함되어 있다
- [ ] `createActivityRecords` SQL에 id, baby_id, activity_id, week_number, completed_at, timer_duration_sec, timer_used 컬럼이 포함되어 있다
- [ ] `createObservationRecords` SQL에 id, baby_id, activity_record_id, date, step1_responses, step2_responses, comfortable_activity, uncomfortable_activity, adjustment_note, interpretation_level, created_at 컬럼이 포함되어 있다
- [ ] `createChecklistRecords` SQL에 id, baby_id, week_number, date, responses, memos, total_score, percentage, tier, domain_scores, is_complete, created_at 컬럼이 포함되어 있다
- [ ] `createDangerSignRecords` SQL에 id, baby_id, week_number, date, signs, memo, has_any_sign, created_at 컬럼이 포함되어 있다

#### AppSettingsService (app_settings_service.dart)
- [ ] 생성자가 `SharedPreferences` 인스턴스를 받는다
- [ ] 10개 설정 키에 대한 getter가 존재한다: isOnboardingComplete, themeMode, isGrandparentMode, isDailyNotificationOn, dailyNotificationTime, isRecordReminderOn, isWeekTransitionOn, isMilestoneOn, isSilentMode, activeBabyId
- [ ] 10개 설정 키에 대한 setter가 존재한다 (Future<void> 반환)
- [ ] 각 getter의 기본값이 개발기획서 스펙과 일치한다: isOnboardingComplete=false, themeMode='system', isGrandparentMode=false, isDailyNotificationOn=true, dailyNotificationTime='09:00', isRecordReminderOn=true, isWeekTransitionOn=true, isMilestoneOn=true, isSilentMode=true, activeBabyId=null
- [ ] `setActiveBabyId(null)` 호출 시 해당 키를 SharedPreferences에서 제거한다

#### nowKST() (date_utils.dart)
- [ ] `nowKST()` 함수가 `DateTime`을 반환한다
- [ ] timezone 패키지를 사용하여 'Asia/Seoul' 로케이션 기반으로 현재 시각을 반환한다
- [ ] 함수가 전역(top-level)으로 선언되어 앱 어디서든 import하여 사용 가능하다

#### InfoTerm (info_term.dart)
- [ ] `InfoTerm`이 `StatelessWidget`을 상속한다
- [ ] 3개의 required 파라미터가 존재한다: parentLabel(String), termName(String), description(String)
- [ ] `just_the_tooltip` 패키지의 `JustTheTooltip` 위젯을 사용한다
- [ ] triggerMode가 `TooltipTriggerMode.tap`으로 설정되어 있다
- [ ] 툴팁 배경색이 `AppColors.cream` (`#FFF8F0`)이다
- [ ] 툴팁 모서리 둥글기가 12dp이다
- [ ] 툴팁 콘텐츠에 termName(bold, 14sp, darkBrown)과 description(13sp, warmGray, height 1.5)이 표시된다
- [ ] 자식 위젯에 parentLabel 텍스트와 info_outline 아이콘(16dp, warmGray)이 Row로 배치된다
- [ ] parentLabel 텍스트가 Flexible로 감싸져 오버플로우를 방지한다

#### main.dart
- [ ] `WidgetsFlutterBinding.ensureInitialized()`가 호출된다
- [ ] timezone 패키지로 시간대가 초기화된다 (`initializeTimeZones()`)
- [ ] 로컬 로케이션이 'Asia/Seoul'로 설정된다
- [ ] `initializeDateFormatting('ko_KR')`이 호출된다
- [ ] SharedPreferences 인스턴스가 비동기로 초기화된다
- [ ] DatabaseHelper.instance.database가 호출되어 DB가 초기화된다
- [ ] `ProviderScope`로 앱이 감싸져 있다
- [ ] ProviderScope의 overrides에 databaseHelperProvider와 appSettingsServiceProvider가 포함되어 있다
- [ ] `runApp()`에 `HaruHanGajiApp` (또는 ProviderScope 래핑된 앱)이 전달된다

#### app.dart
- [ ] `HaruHanGajiApp` 위젯이 `ConsumerWidget` 또는 `StatelessWidget`이다
- [ ] `MaterialApp`(또는 `MaterialApp.router`)이 반환된다
- [ ] theme에 `lightTheme()`이 적용되어 있다
- [ ] darkTheme에 `darkTheme()`이 적용되어 있다
- [ ] themeMode가 설정에 따라 동적으로 변경 가능한 구조이다
- [ ] title이 '하루 한 가지'이다

#### MarionetteBinding
- [ ] 디버그 모드(`kDebugMode`)에서만 marionette_flutter 바인딩이 활성화된다
- [ ] 릴리즈 빌드에서는 marionette 관련 코드가 실행되지 않는다
- [ ] marionette_flutter 패키지 import가 조건부이거나 kDebugMode 체크 내에서만 사용된다

#### Riverpod Providers (core_providers.dart)
- [ ] `databaseHelperProvider`가 `Provider<DatabaseHelper>` 타입으로 선언되어 있다
- [ ] `appSettingsServiceProvider`가 `Provider<AppSettingsService>` 타입으로 선언되어 있다
- [ ] 두 Provider 모두 main.dart에서 overrideWithValue로 초기화된 실제 인스턴스를 주입받는 구조이다

---

### UX 원칙 검증

이 스프린트는 인프라 구축이므로 UX 원칙은 **구조적 준비 상태**를 검증한다.

- [ ] **"하나만 해도 충분하다" 원칙 준비**: AppStrings에 "오늘의 활동", "시작하기" 등 단일 행동 유도 문자열이 정의되어 있다
- [ ] **숫자보다 말로 안심시키는 원칙 준비**: AppStrings에 안심 메시지 관련 문자열 패턴이 정의되어 있다 (예: '오늘의 관찰 결과', '이렇게 해보세요')
- [ ] **전문 용어 대신 부모 언어 사용 준비**: InfoTerm 위젯이 구현되어 전문 용어를 부모 언어로 변환하는 UI 패턴이 앱 전체에서 재사용 가능하다
- [ ] **한 손 30초 완료 준비**: AppDimensions.minTouchTarget이 48dp로 정의되어 있고, 이후 모든 버튼/터치 영역에 적용할 수 있다
- [ ] **죄책감 유발 요소 없음 준비**: AppStrings에 "미완료", "스트릭 끊김" 등 부정적 상태 문자열이 존재하지 않는다. 미기록 상태는 '언제든 기록할 수 있어요'로 표현된다

---

### 디자인 검증

- [ ] AppColors의 모든 Hex 값이 디자인컴포넌트 1-1 표의 값과 **정확히** 일치한다
- [ ] AppTextStyles의 모든 fontSize/fontWeight/height/color가 디자인컴포넌트 1-2 표의 값과 **정확히** 일치한다
- [ ] AppDimensions의 모든 간격 값이 디자인컴포넌트 1-3 표의 값과 **정확히** 일치한다
- [ ] AppRadius의 모든 값이 디자인컴포넌트 1-4 표의 값과 **정확히** 일치한다
- [ ] AppShadows의 모든 BoxShadow 파라미터가 디자인컴포넌트 1-5 표의 값과 **정확히** 일치한다
- [ ] lightTheme()의 scaffoldBackgroundColor가 `#FFF8F0`이다
- [ ] darkTheme()의 scaffoldBackgroundColor가 `#1A1512`이다
- [ ] 라이트/다크 테마 모두에서 포인트 색상(primary)이 warmOrange(`#F5A623`)로 동일하다
- [ ] 라이트/다크 테마 모두에서 안정/긍정 색상(softGreen)이 `#7BC67E`로 동일하다 (변경 없음)
- [ ] 조부모 모드에서 모든 텍스트 크기가 +4sp 증가한다

---

### 접근성 검증

- [ ] AppDimensions.minTouchTarget이 48dp로 정의되어 있다 (48x48dp 최소 터치 영역 보장 준비)
- [ ] AppSettingsService에 isSilentMode getter/setter가 존재하고 기본값이 true이다 (무음 모드 기본 활성화)
- [ ] AppSettingsService에 isGrandparentMode getter/setter가 존재한다 (조부모 모드 지원)
- [ ] 다크 모드 컬러가 정의되어 야간 수유 시 눈부심 방지에 대응할 수 있다
- [ ] InfoTerm 위젯의 터치 대상(아이콘 + 텍스트 Row)이 충분한 크기를 가진다

---

### 컴파일/실행 검증

- [ ] `flutter analyze`에서 에러가 0건이다 (warning은 허용)
- [ ] `flutter build apk --debug` (또는 해당 플랫폼 빌드)가 에러 없이 성공한다
- [ ] 앱 실행 시 크래시 없이 화면이 표시된다 (빈 화면이라도 정상 실행)
- [ ] 앱 실행 시 콘솔에 DB 초기화 관련 에러가 없다
- [ ] 디버그 모드에서 MarionetteBinding이 정상 초기화된다 (에러 로그 없음)

---

## 5. 의존성

### 선행 스프린트
- 없음 (첫 번째 스프린트)

### 필요 패키지 (pubspec.yaml에 이미 설치됨)

| 패키지 | 용도 | pubspec.yaml 확인 |
|---|---|---|
| `sqflite` | SQLite DB | dependencies |
| `path` | DB 파일 경로 조합 | dependencies |
| `shared_preferences` | 앱 설정 저장 | dependencies |
| `flutter_riverpod` | 상태 관리 / Provider | dependencies |
| `timezone` | KST 시간대 처리 | dependencies |
| `intl` | 날짜 포맷 한국어 초기화 | dependencies |
| `just_the_tooltip` | InfoTerm 툴팁 위젯 | dependencies |
| `google_fonts` | Pretendard 폰트 (선택적 사용) | dependencies |
| `flutter_local_notifications` | 알림 초기화 (main.dart에서 호출) | dependencies |
| `marionette_flutter` | 디버그 모드 UI 자동화 | dev_dependencies |

### 후속 스프린트에서 이 스프린트에 의존하는 항목

이 스프린트의 산출물은 **모든 후속 스프린트의 기반**이 된다:
- 모든 화면에서 AppColors, AppTextStyles, AppDimensions, AppRadius, AppShadows를 참조
- 모든 데이터 접근에서 DatabaseHelper, Tables를 사용
- 모든 설정 읽기/쓰기에서 AppSettingsService를 사용
- 전문 용어가 등장하는 모든 화면에서 InfoTerm 위젯을 사용
- 모든 날짜/시간 처리에서 nowKST()를 사용

---

## 6. 구현 시 주의사항

### 6-1. flex_color_scheme 사용 여부

pubspec.yaml에 `flex_color_scheme`이 포함되어 있지 않다. 디자인컴포넌트 문서에서 `FlexThemeData.light()` / `FlexThemeData.dark()` 사용을 언급하지만, 현재 pubspec에 해당 패키지가 없으므로 **순수 Flutter `ThemeData`를 직접 구성**하여 동일한 결과를 달성한다. 만약 Generator가 flex_color_scheme을 사용하고 싶다면 pubspec.yaml에 추가 후 사용해도 무방하다.

### 6-2. 알림 초기화

main.dart에서 `NotificationService.initialize()`를 호출하는 것으로 기획되어 있으나, NotificationService 클래스는 이 스프린트 범위에 포함되지 않는다. 따라서 main.dart에서는 **알림 초기화 호출 부분을 주석으로 남기거나 try-catch로 감싸서** 해당 클래스가 아직 없어도 앱이 정상 실행되도록 한다. NotificationService는 이후 스프린트에서 구현한다.

### 6-3. GoRouter 최소 설정

app.dart에서 GoRouter를 사용한 라우팅은 이 스프린트에서 **최소한의 플레이스홀더 라우트**만 설정한다 (예: 루트 '/' 경로에 빈 Scaffold). 전체 라우트 구성은 온보딩 스프린트에서 구현한다.

### 6-4. MarionetteBinding 구현 방식

marionette_flutter는 dev_dependencies에만 포함되어 있다. `kDebugMode` 체크 내에서만 import/초기화하여 릴리즈 빌드에 포함되지 않도록 한다. 구체적으로는 main.dart 또는 별도 파일에서 다음 패턴을 사용한다:

```dart
// 디버그 모드에서만 MarionetteBinding 활성화
if (kDebugMode) {
  MarionetteBinding.ensureInitialized();
}
```
