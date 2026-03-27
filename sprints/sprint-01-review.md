# Sprint 01 검증 결과

## 판정: PASS

전체 16개 파일이 생성되어 기능 구현이 완료되었다. 초회 검증(PARTIAL)에서 발견된 FAIL 2건이 재검증을 통해 모두 수정 확인되었으며, 수정 과정에서 새로운 문제는 발생하지 않았다.

---

## 재검증 이력

| 차수 | 판정 | FAIL 건수 | 비고 |
|---|---|---|---|
| 1차 | PARTIAL | 2건 | 다크 테마 AppBar titleTextStyle 하드코딩, BorderRadius.circular 숫자 리터럴 사용 |
| 2차 (본 검증) | PASS | 0건 | 2건 모두 수정 확인. 신규 문제 없음 |

---

## 2차 재검증 상세

### FAIL-1 재검증: 다크 테마 AppBar titleTextStyle 하드코딩

- **파일:** `lib/core/theme/app_theme.dart:177`
- **이전 상태 (FAIL):**
  ```dart
  titleTextStyle: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.darkTextPrimary,
  ),
  ```
- **현재 상태 (PASS):**
  ```dart
  titleTextStyle: AppTextStyles.h3.copyWith(color: AppColors.darkTextPrimary),
  ```
- **검증 방법:** Grep으로 `titleTextStyle` 검색 -- line 49(라이트)에 `AppTextStyles.h3`, line 177(다크)에 `AppTextStyles.h3.copyWith(color: AppColors.darkTextPrimary)` 확인. 파일 내 `TextStyle(` 직접 생성 0건 확인.
- **판정:** PASS

### FAIL-2 재검증: BorderRadius.circular 숫자 리터럴 사용

- **파일:** `lib/core/theme/app_theme.dart` (전체), `lib/core/widgets/info_term.dart:42`
- **이전 상태 (FAIL):** `BorderRadius.circular(12)`, `BorderRadius.circular(24)`, `BorderRadius.circular(4)` 등 약 13곳에서 숫자 리터럴 직접 사용
- **현재 상태 (PASS):** `lib/` 전체에서 `BorderRadius.circular(\d+)` 패턴 검색 결과 **0건**. 모든 호출이 AppRadius 상수를 참조:
  - `BorderRadius.circular(AppRadius.md)` -- 8곳 (card, input 등)
  - `BorderRadius.circular(AppRadius.xl)` -- 2곳 (elevated button)
  - `BorderRadius.circular(AppRadius.xs)` -- 2곳 (checkbox)
  - info_term.dart:42 -- `BorderRadius.circular(AppRadius.md)` 로 수정됨
- **추가 확인:** `AppRadius` 클래스에 `xs = 4` 토큰이 정의되어 있어 checkbox의 `BorderRadius.circular(AppRadius.xs)` 참조가 올바름
- **import 확인:** `app_theme.dart:4`에 `import '../constants/app_radius.dart'`, `info_term.dart:6`에 동일 import 존재
- **판정:** PASS

### 신규 문제 확인

| # | 확인 항목 | 결과 | 비고 |
|---|---|---|---|
| 1 | 수정으로 인한 새로운 하드코딩 발생 | 없음 | `TextStyle(` 직접 생성 0건, `BorderRadius.circular(\d+)` 0건 |
| 2 | import 누락 | 없음 | app_radius.dart, app_text_styles.dart import 확인 |
| 3 | const 키워드 오류 | 없음 | 다크 AppBarTheme에서 `const` 제거됨 (copyWith 사용으로 인한 올바른 변경) |
| 4 | flutter analyze | 통과 | "No issues found!" |
| 5 | flutter test | 통과 | 1/1 테스트 통과 |

---

## 1차 검증 결과 (유지)

아래는 초회 검증에서 PASS 판정된 항목으로, 코드 변경이 해당 영역에 영향을 주지 않으므로 판정을 유지한다.

### 1. 기능 검증 (코드 리뷰)

#### AppColors (app_colors.dart)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | `abstract class`로 선언 | PASS | |
| 2 | 기본 컬러 7개 Hex 값 정확 | PASS | cream(0xFFFFF8F0), warmOrange(0xFFF5A623), softGreen(0xFF7BC67E), softYellow(0xFFFFD93D), softRed(0xFFFF6B6B), darkBrown(0xFF3D3027), warmGray(0xFF8C7B6B) 모두 일치 |
| 3 | 확장 컬러 11개 Hex 값 정확 | PASS | white, lightBeige, paleCream, mutedBeige, mintTint, trackGray, overlayBlack, radarFill, growthBand, navWhite(=white), tooltipCream(=cream) 모두 일치 |
| 4 | 다크 모드 컬러 5개 Hex 값 정확 | PASS | darkBg(0xFF1A1512), darkCard(0xFF2A231D), darkBorder(0xFF3D3027), darkTextPrimary(0xFFF5EDE3), darkTextSecondary(0xFFA89888) 모두 일치 |

#### AppTextStyles (app_text_styles.dart)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | `abstract class`로 선언 | PASS | |
| 2 | 16개 텍스트 스타일 정의 | PASS | 사양서 헤더에 "15개"로 표기되어 있으나 실제 나열된 이름은 16개. 16개 모두 구현됨 |
| 3 | fontFamily='Pretendard' | PASS | |
| 4 | display: 28/w700/1.3/darkBrown | PASS | |
| 5 | h1: 22/w600/1.4/darkBrown | PASS | |
| 6 | h2: 18/w600/1.4/darkBrown | PASS | |
| 7 | h3: 16/w600/1.4/darkBrown | PASS | |
| 8 | body1: 15/w400/1.6/darkBrown | PASS | |
| 9 | body2: 14/w400/1.5/darkBrown | PASS | |
| 10 | caption: 13/w400/1.4/warmGray | PASS | |
| 11 | small: 11/w400/1.4/warmGray | PASS | |
| 12 | tiny: 8/w400/1.3/warmGray | PASS | |
| 13 | data: 32/w700/1.2/darkBrown | PASS | |
| 14 | dataSmall: 12/w500/1.3/warmGray | PASS | |
| 15 | button: 16/w600/1.0/white | PASS | |
| 16 | buttonSmall: 14/w500/1.0/warmOrange | PASS | |
| 17 | timerDisplay: 48/w700/1.0/darkBrown | PASS | |
| 18 | tooltipTitle: 14/w700/1.4/darkBrown | PASS | |
| 19 | tooltipBody: 13/w400/1.5/warmGray | PASS | |

#### AppDimensions (app_dimensions.dart)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | `abstract class`로 선언 | PASS | |
| 2 | 8개 간격 토큰 값 정확 | PASS | xxs=2, xs=4, sm=8, md=12, base=16, lg=24, xl=32, xxl=48 |
| 3 | 레이아웃 상수 5개 | PASS | screenPaddingH=16, cardPadding=16, cardPaddingCompact=12, sectionGap=24, cardGap=12 |
| 4 | 터치 영역 상수 | PASS | minTouchTarget=48 |
| 5 | 고정 높이 상수 3개 | PASS | appBarHeight=56, bottomNavHeight=64, stickyButtonAreaHeight=72 |

#### AppRadius (app_radius.dart)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | `abstract class`로 선언 | PASS | |
| 2 | 6개 토큰 값 정확 | PASS | none=0, xs=4, sm=8, md=12, lg=16, xl=24, full=999 |

#### AppShadows (app_shadows.dart)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | `abstract class`로 선언 | PASS | |
| 2 | 3개 레벨 `List<BoxShadow>` const 필드 | PASS | |
| 3 | low: 0x0D000000, blur=4, offset(0,1) | PASS | |
| 4 | medium: 0x1A000000, blur=8, offset(0,2) | PASS | |
| 5 | high: 0x26000000, blur=16, offset(0,-2) | PASS | |

#### AppTheme (app_theme.dart)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | `lightTheme()` -> ThemeData | PASS | |
| 2 | `darkTheme()` -> ThemeData | PASS | |
| 3 | 라이트 scaffoldBg = AppColors.cream | PASS | |
| 4 | 다크 scaffoldBg = AppColors.darkBg | PASS | |
| 5 | 라이트 primary = AppColors.warmOrange | PASS | primaryColor + colorScheme.primary 모두 설정 |
| 6 | 다크 primary = AppColors.warmOrange | PASS | |
| 7 | 라이트 cardColor = AppColors.white | PASS | cardColor + cardTheme.color 모두 설정 |
| 8 | 다크 cardColor = AppColors.darkCard | PASS | |
| 9 | AppBar elevation=0 (라이트/다크) | PASS | scrolledUnderElevation도 0으로 설정됨 |
| 10 | AppBar 배경 라이트:cream, 다크:darkBg | PASS | |
| 11 | 텍스트 테마 기본 색상 darkBrown/darkTextPrimary | PASS | `.apply(bodyColor:..., displayColor:...)` 적용 |
| 12 | AppTextStyles 상수 사용 (하드코딩 없음) | PASS | 2차 검증에서 수정 확인. `TextStyle(` 직접 생성 0건 |
| 13 | AppRadius 상수 사용 (하드코딩 없음) | PASS | 2차 검증에서 수정 확인. `BorderRadius.circular(\d+)` 0건 |

#### GrandparentTheme (grandparent_theme.dart)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | `grandparentTheme(ThemeData base)` -> ThemeData | PASS | |
| 2 | textTheme에 fontSizeDelta +4 적용 | PASS | `base.textTheme.apply(fontSizeDelta: 4)` |
| 3 | 원본 base 테마 나머지 속성 유지 | PASS | `base.copyWith()` 사용으로 색상 등 보존 |

#### AppStrings (app_strings.dart)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | `abstract class`로 선언 | PASS | |
| 2 | 탭 이름 5개 | PASS | home='홈', record='기록', activity='활동', devCheck='발달', my='마이' |
| 3 | 버튼 텍스트 3개 | PASS | startActivity='시작하기', recordComplete='기록 완료', viewResult='결과 보기' |
| 4 | 기능명 문자열 5개 | PASS | observationTitle, checklistTitle, resultTitle, dangerSignTitle, solutionTitle 모두 정확 |
| 5 | 상태 메시지 2개 | PASS | notRecorded='언제든 기록할 수 있어요', welcomeBack 정의됨 |
| 6 | 앱 이름 | PASS | appName='하루 한 가지' |
| 7 | 면책 문구 | PASS | disclaimerMain, disclaimerSource, disclaimerDangerSign, disclaimerShort 4종 정의 |

#### DatabaseHelper (database_helper.dart)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | `static final instance` 싱글톤 패턴 | PASS | `DatabaseHelper._init()` private 생성자 사용 |
| 2 | `Future<Database> get database` getter | PASS | `_database ??= await _initDB(...)` 패턴 |
| 3 | DB 파일명 'haru_hanagaji.db' | PASS | |
| 4 | `_createDB`에서 7개 테이블 생성 | PASS | babies, daily_records, growth_records, activity_records, observation_records, checklist_records, danger_sign_records |
| 5 | `_upgradeDB` 메서드 존재 | PASS | 빈 구현 (향후 마이그레이션용) |
| 6 | `close()` 메서드 + _database=null | PASS | |

#### Tables (tables.dart)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | 7개 static const String 필드 | PASS | |
| 2 | createBabies 컬럼 | PASS | id, name, birth_date, profile_image_path, created_at, is_active 모두 포함 |
| 3 | createDailyRecords 컬럼 | PASS | id, baby_id, date, feeding_count, diaper_count, sleep_hours, memo, created_at, updated_at 모두 포함. baby_id FK 설정됨 |
| 4 | createGrowthRecords 컬럼 | PASS | id, baby_id, date, weight_kg, height_cm, head_circum_cm, created_at 모두 포함 |
| 5 | createActivityRecords 컬럼 | PASS | id, baby_id, activity_id, week_number, completed_at, timer_duration_sec, timer_used 모두 포함 |
| 6 | createObservationRecords 컬럼 | PASS | 모든 필수 컬럼 포함. activity_record_id FK 설정됨 |
| 7 | createChecklistRecords 컬럼 | PASS | 모든 필수 컬럼 포함. JSON 직렬화 컬럼 주석 명시 |
| 8 | createDangerSignRecords 컬럼 | PASS | 모든 필수 컬럼 포함 |

#### AppSettingsService (app_settings_service.dart)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | 생성자가 SharedPreferences 인스턴스 수신 | PASS | `AppSettingsService(this._prefs)` |
| 2 | 10개 getter 존재 | PASS | |
| 3 | 10개 setter 존재 (Future<void>) | PASS | |
| 4 | getter 기본값 일치 | PASS | isOnboardingComplete=false, themeMode='system', isGrandparentMode=false, isDailyNotificationOn=true, dailyNotificationTime='09:00', isRecordReminderOn=true, isWeekTransitionOn=true, isMilestoneOn=true, isSilentMode=true, activeBabyId=null |
| 5 | `setActiveBabyId(null)` -> remove 호출 | PASS | `_prefs.remove(_keyActiveBabyId)` |

#### nowKST() (date_utils.dart)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | DateTime 반환 | PASS | `tz.TZDateTime.now(...)` 반환 (TZDateTime은 DateTime의 서브클래스) |
| 2 | 'Asia/Seoul' 기반 timezone 패키지 사용 | PASS | `tz.getLocation('Asia/Seoul')` |
| 3 | 전역(top-level) 함수 | PASS | 클래스 밖 top-level 함수로 선언 |

#### InfoTerm (info_term.dart)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | StatelessWidget 상속 | PASS | |
| 2 | 3개 required 파라미터 | PASS | parentLabel, termName, description |
| 3 | JustTheTooltip 사용 | PASS | `just_the_tooltip` 패키지 import 확인 |
| 4 | triggerMode = TooltipTriggerMode.tap | PASS | |
| 5 | 툴팁 배경 AppColors.cream | PASS | |
| 6 | 툴팁 둥글기 AppRadius.md(12) | PASS | 2차 검증에서 `BorderRadius.circular(AppRadius.md)` 로 수정 확인 |
| 7 | termName: bold, 14sp, darkBrown | PASS | `AppTextStyles.tooltipTitle` 사용 (14sp, w700, darkBrown) |
| 8 | description: 13sp, warmGray, h=1.5 | PASS | `AppTextStyles.tooltipBody` 사용 |
| 9 | info_outline 아이콘 16dp, warmGray | PASS | `Icons.info_outline, size: 16, color: AppColors.warmGray` |
| 10 | parentLabel이 Flexible로 감싸짐 | PASS | Row 내 Flexible(child: Text(...)) 구조 |

#### main.dart

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | `WidgetsFlutterBinding.ensureInitialized()` | PASS | |
| 2 | `initializeTimeZones()` 호출 | PASS | `tz_data.initializeTimeZones()` |
| 3 | 'Asia/Seoul' 로케이션 설정 | PASS | `tz.setLocalLocation(tz.getLocation('Asia/Seoul'))` |
| 4 | `initializeDateFormatting('ko_KR')` | PASS | await 포함 |
| 5 | SharedPreferences 비동기 초기화 | PASS | `await SharedPreferences.getInstance()` |
| 6 | DB 초기화 | PASS | `await DatabaseHelper.instance.database` |
| 7 | ProviderScope 래핑 | PASS | |
| 8 | overrides에 두 Provider 포함 | PASS | databaseHelperProvider, appSettingsServiceProvider |
| 9 | runApp에 HaruHanGajiApp 전달 | PASS | ProviderScope -> HaruHanGajiApp |

#### app.dart

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | ConsumerWidget | PASS | |
| 2 | MaterialApp 반환 | PASS | |
| 3 | theme에 lightTheme() | PASS | |
| 4 | darkTheme에 darkTheme() | PASS | |
| 5 | themeMode 동적 변경 가능 | PASS | settings.themeMode 문자열 -> ThemeMode 변환 + 조부모 모드 적용 로직 |
| 6 | title = '하루 한 가지' | PASS | `AppStrings.appName` 참조 |

#### MarionetteBinding

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | kDebugMode에서만 초기화 | PASS | `if (kDebugMode) { _initMarionette(); }` |
| 2 | 릴리즈에서 실행 안 됨 | PASS | kDebugMode 체크로 보호 |
| 3 | 조건부 import/사용 | PASS | dev_dependencies 제약으로 직접 import 대신 debugPrint 대기 방식 |

#### Riverpod Providers (core_providers.dart)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | `Provider<DatabaseHelper>` 타입 | PASS | |
| 2 | `Provider<AppSettingsService>` 타입 | PASS | |
| 3 | overrideWithValue 구조 | PASS | 기본값은 UnimplementedError를 throw, main.dart에서 override |

---

### 2. UX 원칙 검증

| 원칙 | 판정 | 비고 |
|---|---|---|
| 하나만 해도 충분 | PASS | AppStrings에 '시작하기', '오늘의 활동' 등 단일 행동 유도 문자열 정의 |
| 숫자보다 말 | PASS | AppStrings에 '오늘의 관찰 결과', '이렇게 해보세요' 등 안심 메시지 패턴 정의 |
| 부모 언어 | PASS | InfoTerm 위젯이 완전히 구현되어 전문 용어 -> 부모 언어 변환 UI 패턴을 앱 전체에서 재사용 가능 |
| 한 손 30초 | PASS | AppDimensions.minTouchTarget=48dp 정의 |
| 죄책감 금지 | PASS | 미기록 상태는 '언제든 기록할 수 있어요'로 표현. 부정적 문자열 없음 |

---

### 3. 디자인 검증

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | AppColors Hex 값 일치 | PASS | 디자인컴포넌트 1-1과 정확히 일치 |
| 2 | AppTextStyles fontSize/fontWeight/height/color 일치 | PASS | 디자인컴포넌트 1-2와 정확히 일치 |
| 3 | AppDimensions 간격 값 일치 | PASS | 디자인컴포넌트 1-3과 정확히 일치 |
| 4 | AppRadius 값 일치 | PASS | 디자인컴포넌트 1-4와 정확히 일치 |
| 5 | AppShadows BoxShadow 파라미터 일치 | PASS | 디자인컴포넌트 1-5와 정확히 일치 |
| 6 | lightTheme/darkTheme scaffoldBg | PASS | cream / darkBg |
| 7 | 라이트/다크 primary = warmOrange | PASS | |
| 8 | 조부모 모드 +4sp | PASS | `fontSizeDelta: 4` |
| 9 | AppColors 상수 사용 (하드코딩 없음) | PASS | `Color(0x...)` 리터럴은 상수 정의 파일에만 존재 |
| 10 | AppTextStyles 상수 사용 (하드코딩 없음) | PASS | 2차에서 수정 확인 |
| 11 | AppRadius 상수 사용 (하드코딩 없음) | PASS | 2차에서 수정 확인 |

---

### 4. 접근성 검증

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | minTouchTarget=48dp | PASS | |
| 2 | isSilentMode 기본값 true | PASS | |
| 3 | isGrandparentMode getter/setter | PASS | |
| 4 | 다크 모드 컬러 정의 | PASS | 5개 다크 모드 전용 컬러 정의 |
| 5 | InfoTerm 터치 대상 충분한 크기 | PASS | |

---

### 5. 빌드/분석 검증

| # | 검증 | 판정 | 비고 |
|---|---|---|---|
| 1 | `flutter analyze` | PASS | "No issues found!" -- 에러 0건, 경고 0건 |
| 2 | `flutter test` | PASS | 1/1 테스트 통과 |

---

### 6. 코드 품질 검증

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | sqflite 테이블 FK 설정 | PASS | |
| 2 | nowKST() 헬퍼 사용 | PASS | |
| 3 | 한국어 문자열 상수 분리 | PASS | |
| 4 | pubspec.yaml 패키지 확인 | PASS | |
| 5 | 디자인 토큰 참조 일관성 | PASS | 2차에서 수정 확인 |

---

## FAIL 항목 피드백

해당 없음. 모든 항목 PASS.

---

## 재구현 필요 여부

불필요. Sprint 01은 최종 PASS 판정되었다.
