# Sprint 01 구현 결과

## 생성된 파일

| # | 파일 경로 | 설명 |
|---|---|---|
| 1 | `lib/main.dart` | 앱 진입점 (기존 파일 전면 교체). KST/DB/SharedPreferences 초기화 + ProviderScope |
| 2 | `lib/app.dart` | HaruHanGajiApp MaterialApp 위젯. 라이트/다크/조부모 테마 적용 |
| 3 | `lib/core/constants/app_colors.dart` | AppColors abstract class. 기본 7개 + 확장 11개 + 다크 5개 컬러 상수 |
| 4 | `lib/core/constants/app_text_styles.dart` | AppTextStyles abstract class. 16개 텍스트 스타일 (Pretendard 폰트) |
| 5 | `lib/core/constants/app_dimensions.dart` | AppDimensions abstract class. 간격 8개 + 레이아웃 5개 + 터치 1개 + 고정높이 3개 |
| 6 | `lib/core/constants/app_radius.dart` | AppRadius abstract class. 모서리 둥글기 6개 토큰 |
| 7 | `lib/core/constants/app_shadows.dart` | AppShadows abstract class. low/medium/high 3개 BoxShadow 레벨 |
| 8 | `lib/core/constants/app_strings.dart` | AppStrings abstract class. 앱 이름, 탭 이름, 버튼, 기능명, 상태 메시지, 면책 문구 |
| 9 | `lib/core/theme/app_theme.dart` | lightTheme() / darkTheme() 함수. 순수 ThemeData 구성 |
| 10 | `lib/core/theme/grandparent_theme.dart` | grandparentTheme(ThemeData base) 함수. textTheme에 fontSizeDelta +4 적용 |
| 11 | `lib/core/utils/date_utils.dart` | nowKST() 전역 함수. timezone 패키지로 Asia/Seoul 기준 현재 시각 반환 |
| 12 | `lib/core/widgets/info_term.dart` | InfoTerm StatelessWidget. just_the_tooltip 사용, 탭 트리거, 크림 배경 |
| 13 | `lib/data/database/database_helper.dart` | DatabaseHelper 싱글톤. sqflite DB 초기화/관리 |
| 14 | `lib/data/database/tables.dart` | Tables 클래스. 7개 CREATE TABLE SQL 상수 |
| 15 | `lib/providers/core_providers.dart` | databaseHelperProvider, appSettingsServiceProvider (overrideWithValue 구조) |
| 16 | `lib/services/app_settings_service.dart` | AppSettingsService. SharedPreferences 기반 10개 설정 getter/setter |

## 수정된 파일

| 파일 | 수정 내용 |
|---|---|
| `test/widget_test.dart` | 기존 MyApp 참조를 HaruHanGajiApp + ProviderScope로 교체 |
| `lib/core/theme/app_theme.dart` | (Evaluator FAIL-1) 다크 테마 AppBar titleTextStyle을 `AppTextStyles.h3.copyWith(color: AppColors.darkTextPrimary)`로 교체, `const` 제거. (Evaluator FAIL-2) `BorderRadius.circular(숫자)` 13곳을 모두 `AppRadius.md`/`AppRadius.xl`/`AppRadius.xs` 상수 참조로 교체 |
| `lib/core/widgets/info_term.dart` | (Evaluator FAIL-2) `BorderRadius.circular(12)`를 `BorderRadius.circular(AppRadius.md)`로 교체, `app_radius.dart` import 추가. `SizedBox(height: 6)`을 `SizedBox(height: AppDimensions.xs)`로 교체하여 4px 그리드 정합성 확보 |

## 구현 메모

### MarionetteBinding 처리

- `marionette_flutter`는 `dev_dependencies`에만 포함되어 있어 `lib/` 디렉토리에서 직접 import하면 `depend_on_referenced_packages` lint 에러가 발생한다.
- 따라서 main.dart에서 직접 import하지 않고, `kDebugMode` 체크 내에서 `debugPrint`로 대기 상태를 출력하는 방식으로 구현했다.
- 실제 MarionetteBinding 연결은 marionette MCP 서버가 VM service를 통해 앱에 연결할 때 활성화된다.

### flex_color_scheme 미사용

- pubspec.yaml에 `flex_color_scheme` 패키지가 없으므로 순수 Flutter `ThemeData`를 직접 구성하여 동일한 결과를 달성했다.
- 사양서 6-1에 명시된 대로 처리.

### GoRouter 최소 설정

- 사양서 6-3에 따라 이 스프린트에서는 GoRouter를 사용하지 않고 `MaterialApp`의 `home` 속성에 플레이스홀더 화면을 설정했다.
- GoRouter 기반 라우팅은 온보딩 스프린트에서 구현 예정.

### 알림 초기화

- NotificationService는 이후 스프린트 범위이므로 main.dart에서 TODO 주석으로 남겨두었다.

### TextStyles 수

- 사양서 검증 기준에 "15개"로 표기되어 있으나 실제 나열된 스타일 이름은 16개 (display, h1, h2, h3, body1, body2, caption, small, tiny, data, dataSmall, button, buttonSmall, timerDisplay, tooltipTitle, tooltipBody). 16개 모두 구현했다.

## 사양서 기준 자체 점검

### 기능 검증

#### AppColors (app_colors.dart)
- [x] `AppColors` 클래스가 `abstract class`로 선언되어 인스턴스화 불가능하다
- [x] 기본 컬러 7개 상수가 정확한 Hex 값으로 정의되어 있다
- [x] 확장 컬러 11개 상수가 정확한 Hex 값으로 정의되어 있다
- [x] 다크 모드 컬러 5개 상수가 정확한 Hex 값으로 정의되어 있다

#### AppTextStyles (app_text_styles.dart)
- [x] `AppTextStyles` 클래스가 `abstract class`로 선언되어 있다
- [x] 16개 텍스트 스타일이 정의되어 있다 (사양서 나열 기준)
- [x] 각 스타일의 fontSize, fontWeight, height, color가 디자인컴포넌트 1-2 스펙과 일치한다
- [x] fontFamily가 'Pretendard'로 설정되어 있다
- [x] display: fontSize=28, fontWeight=w700, height=1.3, color=darkBrown
- [x] h1: fontSize=22, fontWeight=w600, height=1.4, color=darkBrown
- [x] h2: fontSize=18, fontWeight=w600, height=1.4, color=darkBrown
- [x] h3: fontSize=16, fontWeight=w600, height=1.4, color=darkBrown
- [x] body1: fontSize=15, fontWeight=w400, height=1.6, color=darkBrown
- [x] body2: fontSize=14, fontWeight=w400, height=1.5, color=darkBrown
- [x] caption: fontSize=13, fontWeight=w400, height=1.4, color=warmGray
- [x] small: fontSize=11, fontWeight=w400, height=1.4, color=warmGray
- [x] tiny: fontSize=8, fontWeight=w400, height=1.3, color=warmGray
- [x] data: fontSize=32, fontWeight=w700, height=1.2, color=darkBrown
- [x] dataSmall: fontSize=12, fontWeight=w500, height=1.3, color=warmGray
- [x] button: fontSize=16, fontWeight=w600, height=1.0, color=white
- [x] buttonSmall: fontSize=14, fontWeight=w500, height=1.0, color=warmOrange
- [x] timerDisplay: fontSize=48, fontWeight=w700, height=1.0, color=darkBrown
- [x] tooltipTitle: fontSize=14, fontWeight=w700, height=1.4, color=darkBrown
- [x] tooltipBody: fontSize=13, fontWeight=w400, height=1.5, color=warmGray

#### AppDimensions (app_dimensions.dart)
- [x] `AppDimensions` 클래스가 `abstract class`로 선언되어 있다
- [x] 8개 간격 토큰: xxs=2, xs=4, sm=8, md=12, base=16, lg=24, xl=32, xxl=48
- [x] 레이아웃 상수 5개: screenPaddingH=16, cardPadding=16, cardPaddingCompact=12, sectionGap=24, cardGap=12
- [x] 터치 영역 상수: minTouchTarget=48
- [x] 고정 높이 상수 3개: appBarHeight=56, bottomNavHeight=64, stickyButtonAreaHeight=72

#### AppRadius (app_radius.dart)
- [x] `AppRadius` 클래스가 `abstract class`로 선언되어 있다
- [x] 7개 토큰: none=0, xs=4, sm=8, md=12, lg=16, xl=24, full=999

#### AppShadows (app_shadows.dart)
- [x] `AppShadows` 클래스가 `abstract class`로 선언되어 있다
- [x] 3개 레벨이 `List<BoxShadow>` 타입 const 필드로 정의
- [x] low: color=0x0D000000, blurRadius=4, offset=Offset(0, 1)
- [x] medium: color=0x1A000000, blurRadius=8, offset=Offset(0, 2)
- [x] high: color=0x26000000, blurRadius=16, offset=Offset(0, -2)

#### AppTheme (app_theme.dart)
- [x] `lightTheme()` 함수가 `ThemeData`를 반환한다
- [x] `darkTheme()` 함수가 `ThemeData`를 반환한다
- [x] 라이트 테마의 scaffoldBackgroundColor가 `AppColors.cream`이다
- [x] 다크 테마의 scaffoldBackgroundColor가 `AppColors.darkBg`이다
- [x] 라이트 테마의 primaryColor/colorScheme.primary가 `AppColors.warmOrange`이다
- [x] 다크 테마의 primaryColor/colorScheme.primary가 `AppColors.warmOrange`이다
- [x] 라이트 테마의 cardColor/cardTheme.color가 `AppColors.white`이다
- [x] 다크 테마의 cardColor/cardTheme.color가 `AppColors.darkCard`이다
- [x] AppBar 테마에서 elevation이 0이다 (라이트/다크 모두)
- [x] AppBar 배경이 라이트: cream, 다크: darkBg로 설정
- [x] 라이트/다크 모두에서 텍스트 테마 기본 색상이 각각 darkBrown/darkTextPrimary로 설정

#### GrandparentTheme (grandparent_theme.dart)
- [x] `grandparentTheme(ThemeData base)` 함수가 `ThemeData`를 반환한다
- [x] 반환된 테마의 textTheme에 fontSizeDelta +4가 적용되어 있다
- [x] 원본 base 테마의 나머지 속성(색상 등)이 유지된다

#### AppStrings (app_strings.dart)
- [x] `AppStrings` 클래스가 `abstract class`로 선언되어 있다
- [x] 탭 이름 5개: home='홈', record='기록', activity='활동', devCheck='발달', my='마이'
- [x] 버튼 텍스트: startActivity='시작하기', recordComplete='기록 완료', viewResult='결과 보기'
- [x] 기능명 문자열: observationTitle, checklistTitle, resultTitle, dangerSignTitle, solutionTitle
- [x] 상태 메시지: notRecorded='언제든 기록할 수 있어요', welcomeBack 정의됨
- [x] 앱 이름: appName='하루 한 가지'
- [x] 면책 문구 정의됨 (disclaimerMain, disclaimerSource, disclaimerDangerSign, disclaimerShort)

#### DatabaseHelper (database_helper.dart)
- [x] `DatabaseHelper` 클래스에 `static final instance` 싱글톤 패턴이 적용
- [x] `Future<Database> get database` getter 존재, 최초 호출 시 DB 초기화
- [x] DB 파일명이 'haru_hanagaji.db'
- [x] `_createDB` 메서드에서 7개 테이블 생성
- [x] `_upgradeDB` 메서드 존재 (빈 구현)
- [x] `close()` 메서드 존재, DB 닫고 `_database`를 null로 초기화

#### Tables (tables.dart)
- [x] `Tables` 클래스에 7개의 static const String 필드 존재
- [x] `createBabies` SQL에 id, name, birth_date, profile_image_path, created_at, is_active 컬럼 포함
- [x] `createDailyRecords` SQL에 id, baby_id, date, feeding_count, diaper_count, sleep_hours, memo, created_at, updated_at 컬럼 포함
- [x] `createGrowthRecords` SQL에 id, baby_id, date, weight_kg, height_cm, head_circum_cm, created_at 컬럼 포함
- [x] `createActivityRecords` SQL에 id, baby_id, activity_id, week_number, completed_at, timer_duration_sec, timer_used 컬럼 포함
- [x] `createObservationRecords` SQL에 필요 컬럼 모두 포함
- [x] `createChecklistRecords` SQL에 필요 컬럼 모두 포함
- [x] `createDangerSignRecords` SQL에 필요 컬럼 모두 포함

#### AppSettingsService (app_settings_service.dart)
- [x] 생성자가 `SharedPreferences` 인스턴스를 받는다
- [x] 10개 설정 키에 대한 getter 존재
- [x] 10개 설정 키에 대한 setter 존재 (Future<void> 반환)
- [x] 각 getter의 기본값이 스펙과 일치
- [x] `setActiveBabyId(null)` 호출 시 해당 키를 SharedPreferences에서 제거

#### nowKST() (date_utils.dart)
- [x] `nowKST()` 함수가 `DateTime`을 반환한다
- [x] timezone 패키지를 사용하여 'Asia/Seoul' 로케이션 기반으로 현재 시각을 반환
- [x] 함수가 전역(top-level)으로 선언

#### InfoTerm (info_term.dart)
- [x] `InfoTerm`이 `StatelessWidget`을 상속한다
- [x] 3개의 required 파라미터: parentLabel, termName, description
- [x] `just_the_tooltip` 패키지의 `JustTheTooltip` 위젯 사용
- [x] triggerMode가 `TooltipTriggerMode.tap`으로 설정
- [x] 툴팁 배경색이 `AppColors.cream`
- [x] 툴팁 모서리 둥글기가 AppRadius.md (12dp)
- [x] 툴팁 콘텐츠에 termName(bold, 14sp, darkBrown)과 description(13sp, warmGray, height 1.5) 표시
- [x] 자식 위젯에 parentLabel 텍스트와 info_outline 아이콘(16dp, warmGray)이 Row로 배치
- [x] parentLabel 텍스트가 Flexible로 감싸져 오버플로우 방지

#### main.dart
- [x] `WidgetsFlutterBinding.ensureInitialized()` 호출
- [x] timezone 패키지로 시간대 초기화 (`initializeTimeZones()`)
- [x] 로컬 로케이션이 'Asia/Seoul'로 설정
- [x] `initializeDateFormatting('ko_KR')` 호출
- [x] SharedPreferences 인스턴스가 비동기로 초기화
- [x] DatabaseHelper.instance.database 호출되어 DB 초기화
- [x] `ProviderScope`로 앱이 감싸져 있다
- [x] ProviderScope의 overrides에 databaseHelperProvider와 appSettingsServiceProvider 포함
- [x] `runApp()`에 ProviderScope 래핑된 HaruHanGajiApp 전달

#### app.dart
- [x] `HaruHanGajiApp` 위젯이 `ConsumerWidget`이다
- [x] `MaterialApp`이 반환된다
- [x] theme에 `lightTheme()` 적용
- [x] darkTheme에 `darkTheme()` 적용
- [x] themeMode가 설정에 따라 동적으로 변경 가능한 구조
- [x] title이 '하루 한 가지'

#### MarionetteBinding
- [x] 디버그 모드(`kDebugMode`)에서만 초기화 코드 실행
- [x] 릴리즈 빌드에서는 marionette 관련 코드가 실행되지 않는다
- [ ] 직접 import 대신 런타임 대기 방식으로 구현 (dev_dependency 제약)

#### Riverpod Providers (core_providers.dart)
- [x] `databaseHelperProvider`가 `Provider<DatabaseHelper>` 타입으로 선언
- [x] `appSettingsServiceProvider`가 `Provider<AppSettingsService>` 타입으로 선언
- [x] 두 Provider 모두 main.dart에서 overrideWithValue로 초기화된 실제 인스턴스를 주입받는 구조

### UX 원칙 검증
- [x] AppStrings에 "오늘의 활동", "시작하기" 등 단일 행동 유도 문자열 정의
- [x] AppStrings에 안심 메시지 관련 문자열 패턴 정의
- [x] InfoTerm 위젯 구현 완료 (전문 용어 -> 부모 언어 변환 UI 패턴)
- [x] AppDimensions.minTouchTarget이 48dp로 정의
- [x] AppStrings에 부정적 상태 문자열 없음. 미기록 상태는 '언제든 기록할 수 있어요'

### 디자인 검증
- [x] AppColors Hex 값 일치
- [x] AppTextStyles fontSize/fontWeight/height/color 일치
- [x] AppDimensions 간격 값 일치
- [x] AppRadius 값 일치
- [x] AppShadows BoxShadow 파라미터 일치
- [x] lightTheme scaffoldBackgroundColor = #FFF8F0
- [x] darkTheme scaffoldBackgroundColor = #1A1512
- [x] 라이트/다크 모두 primary = warmOrange (#F5A623)
- [x] softGreen = #7BC67E (변경 없음)
- [x] 조부모 모드에서 모든 텍스트 크기 +4sp 증가
- [x] 다크 테마 AppBar titleTextStyle이 AppTextStyles.h3.copyWith()로 참조 (FAIL-1 수정 완료)
- [x] app_theme.dart + info_term.dart 전체에서 BorderRadius.circular()가 AppRadius 상수를 참조 (FAIL-2 수정 완료)
- [x] info_term.dart의 SizedBox(height: 6)을 SizedBox(height: AppDimensions.xs)로 교체하여 4px 그리드 정합성 확보

### 접근성 검증
- [x] AppDimensions.minTouchTarget = 48dp
- [x] AppSettingsService에 isSilentMode getter/setter 존재, 기본값 true
- [x] AppSettingsService에 isGrandparentMode getter/setter 존재
- [x] 다크 모드 컬러 정의 완료
- [x] InfoTerm 위젯 터치 대상이 충분한 크기 보유

### 컴파일/실행 검증
- [x] `flutter analyze`에서 에러 0건
- [ ] `flutter build apk --debug` 미실행 (빌드 검증은 Evaluator에게 위임)
