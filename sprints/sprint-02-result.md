# Sprint 02 구현 결과

## 생성된 파일

### 새로 생성
- `lib/core/router/app_router.dart` -- GoRouter 라우트 정의 (온보딩 4개 + 메인 ShellRoute)
- `lib/core/utils/week_calculator.dart` -- 생년월일 기반 주차 계산 유틸 (KST 기준 nowKST() 사용)
- `lib/core/widgets/primary_cta_button.dart` -- 2-3-1 기본 CTA 버튼 재사용 위젯
- `lib/data/models/baby.dart` -- Baby 모델 + BabyExt extension (toMap, fromMap, copyWith)
- `lib/data/database/daos/baby_dao.dart` -- BabyDao CRUD (insert, getById, getAll, update, delete)
- `lib/data/seed/week_content_seed.dart` -- WeekContent 모델 + 0-1주차/2-3주차 시드 데이터
- `lib/features/onboarding/screens/welcome_screen.dart` -- 화면 A: 웰컴
- `lib/features/onboarding/screens/baby_register_screen.dart` -- 화면 B: 아기 등록
- `lib/features/onboarding/screens/week_intro_screen.dart` -- 화면 C: 주차 소개
- `lib/features/onboarding/screens/notification_permission_screen.dart` -- 화면 D: 알림 권한
- `lib/features/onboarding/providers/onboarding_provider.dart` -- 온보딩 상태 관리 (Notifier 기반)
- `lib/features/main_shell/main_shell.dart` -- MainShell 플레이스홀더 (5개 탭 하단 탭 바)
- `lib/providers/baby_providers.dart` -- activeBabyProvider (FutureProvider)
- `assets/lottie/celebration.json` -- 축하 애니메이션 플레이스홀더
- `assets/lottie/notification_bell.json` -- 벨 애니메이션 플레이스홀더
- `assets/images/onboarding_illustration.png` -- 웰컴 일러스트 플레이스홀더

### 수정된 기존 파일
- `lib/app.dart` -- MaterialApp -> MaterialApp.router 전환, GoRouter 연결
- `lib/providers/core_providers.dart` -- babyDaoProvider 추가
- `lib/core/constants/app_strings.dart` -- 온보딩 관련 한국어 문자열 상수 추가
- `pubspec.yaml` -- permission_handler, image_picker 패키지 추가 + assets 폴더 등록

### FAIL 피드백 대응 수정 파일
- `lib/core/utils/week_calculator.dart` -- FAIL-1: 월 계산 로직 수정 (days ~/ 30 -> (weeks / 4).round())
- `lib/core/constants/app_text_styles.dart` -- FAIL-4/5: 모든 TextStyle에서 hardcoded color 제거. 순수 타이포그래피(font/size/weight/height)만 정의
- `lib/core/theme/app_theme.dart` -- FAIL-4/5: textTheme을 슬롯별 명시적 색상 지정으로 변경. _lightTextTheme()과 _darkTextTheme()으로 분리. appBarTheme.titleTextStyle을 textTheme.headlineSmall로 통일
- `lib/core/theme/grandparent_theme.dart` -- FAIL-5: appBarTheme.titleTextStyle에도 +4sp 적용
- `lib/features/onboarding/screens/welcome_screen.dart` -- FAIL-2/4/5: backgroundColor를 theme.scaffoldBackgroundColor로 변경, 모든 텍스트를 Theme.of(context).textTheme으로 전환
- `lib/features/onboarding/screens/baby_register_screen.dart` -- FAIL-2/4/5 + A-1: 동일. 추가로 DateTime.now() -> nowKST() 수정
- `lib/features/onboarding/screens/week_intro_screen.dart` -- FAIL-2/3/4/5: backgroundColor + 카드 배경 theme.cardColor + 텍스트 theme 전환
- `lib/features/onboarding/screens/notification_permission_screen.dart` -- FAIL-2/4/5: 동일
- `lib/features/main_shell/main_shell.dart` -- FAIL-5: AppTextStyles.h1 -> Theme.of(context).textTheme.headlineLarge
- `lib/core/widgets/info_term.dart` -- 다크 모드 대응: 툴팁 배경/텍스트 색상 분기, 본문 텍스트 textTheme 전환

## 구현 메모

### FAIL 대응 상세

#### FAIL-1: WeekCalculator 월 계산 로직 수정
- **변경 전**: `days ~/ 30` -> 56일이 1개월로 반환
- **변경 후**: `(weeks / 4).round()` -> 8주(56일)가 정확히 2개월로 반환
- 4주 = 1개월 기준으로 반올림 적용. 8주 = 2개월, 12주 = 3개월 등 정확한 매핑

#### FAIL-2: Scaffold 배경 다크 모드 전환
- **변경 전**: 4개 화면 모두 `backgroundColor: AppColors.cream` 하드코딩
- **변경 후**: `backgroundColor: Theme.of(context).scaffoldBackgroundColor`
- ThemeData에서 light=cream, dark=darkBg가 이미 설정되어 있으므로 자동 전환

#### FAIL-3: 카드 배경 다크 모드 전환
- **변경 전**: week_intro_screen.dart에서 `color: AppColors.white` 하드코딩
- **변경 후**: `color: Theme.of(context).cardColor`
- ThemeData에서 light=white, dark=darkCard가 이미 설정되어 있으므로 자동 전환

#### FAIL-4: 텍스트 색상 다크 모드 전환
- **근본 원인**: AppTextStyles에 `color: AppColors.darkBrown` 등이 static const로 하드코딩
- **구조적 해결**:
  1. AppTextStyles에서 모든 `color` 속성 제거 -> 순수 타이포그래피 정의
  2. app_theme.dart에서 `_lightTextTheme()`과 `_darkTextTheme()` 헬퍼 함수 도입
  3. 각 TextTheme 슬롯별로 모드에 맞는 색상을 명시적으로 `.copyWith(color:)`로 지정
  4. 주요 텍스트(display/headline/body): light=darkBrown, dark=darkTextPrimary
  5. 보조 텍스트(caption/small): light=warmGray, dark=darkTextSecondary
  6. 버튼(labelLarge): white (양 모드 동일)
  7. 텍스트 링크(labelMedium): warmOrange (양 모드 동일)

#### FAIL-5: 조부모 모드 실효
- **근본 원인**: 화면에서 `AppTextStyles.display` 등을 직접 사용하여 `Theme.textTheme` 경유 안 함
- **해결**:
  1. 모든 온보딩 화면 + MainShell에서 `AppTextStyles.xxx` 직접 사용을 `Theme.of(context).textTheme.yyy`로 전환
  2. TextTheme 매핑: displayLarge=display, headlineLarge=h1, headlineMedium=h2, headlineSmall=h3, bodyLarge=body1, bodyMedium=body2, bodySmall=caption, labelLarge=button, labelMedium=buttonSmall, labelSmall=small
  3. grandparentTheme()의 `base.textTheme.apply(fontSizeDelta: 4)`가 이제 실제로 화면에 반영됨
  4. grandparentTheme()에 appBarTheme.titleTextStyle +4sp도 추가

#### A-1: DateTime.now() -> nowKST()
- baby_register_screen.dart의 DatePicker min/max 날짜 계산에서 `DateTime.now()` -> `nowKST()` 변경

### 추가 다크 모드 대응
- baby_register_screen.dart: 입력 필드 배경(white/darkCard), 테두리(lightBeige/darkBorder), 힌트 텍스트 색상, 아이콘 색상, 프로필 CircleAvatar 배경, BottomSheet 배경 등 모두 다크 모드 분기
- welcome_screen.dart: 일러스트 원형 배경(paleCream/darkCard), 태그라인 색상(warmGray/darkTextSecondary)
- week_intro_screen.dart: Lottie 에러 플레이스홀더 배경, CTA 메시지 보조 텍스트 색상
- notification_permission_screen.dart: Lottie 에러 플레이스홀더 배경
- info_term.dart: 툴팁 배경, 제목/본문 색상, 아이콘 색상

### 기술적 결정
- **Riverpod 3.x 호환**: flutter_riverpod 3.3.1에서 `StateNotifier`가 제거되었으므로, `Notifier` + `NotifierProvider`로 구현함
- **GoRouter Provider**: `Provider.family<GoRouter, AppSettingsService>`로 구현하여 AppSettingsService의 `isOnboardingComplete` 값에 따라 initialLocation을 결정
- **KST 고정**: WeekCalculator의 모든 계산 + DatePicker의 날짜 범위에서 `nowKST()`를 사용하여 KST 기준 시간 적용
- **한국어 조사 처리**: WeekIntroScreen의 인사 텍스트에서 이름의 마지막 글자 받침 유무에 따라 "아"/"야" 자동 선택
- **babyDaoProvider 중복 방지**: core_providers.dart에 정의하고 baby_providers.dart에서는 import하여 사용

### 디자인 토큰 준수
- 모든 컬러: `AppColors` 상수 사용 (하드코딩 없음)
- 모든 텍스트 스타일: `Theme.of(context).textTheme` 사용 (테마 인식)
- 특수 색상 오버라이드: `.copyWith(color: AppColors.warmOrange)` 등으로 명시적 지정
- 모든 간격: `AppDimensions` 상수 사용
- 모든 모서리 둥글기: `AppRadius` 상수 사용
- 그림자: `AppShadows.low` 사용

### ValueKey 지정
- 사양서 4-0의 22개 ValueKey가 모두 해당 위젯에 지정됨
- PrimaryCtaButton에서는 `buttonKey` 파라미터로 ElevatedButton 자체에 Key 설정

## 사양서 기준 자체 점검

### 4-0. ValueKey 지정
- [x] 22개 ValueKey가 모두 해당 위젯에 정확히 지정됨

### 4-1. 화면 A (WelcomeScreen)
- [x] isOnboardingComplete == false일 때 WelcomeScreen 표시
- [x] 플레이스홀더 아이콘 (Icons.child_care) 표시
- [x] "하루 한 가지" Display 스타일 (28sp, Bold) 표시
- [x] 태그라인 3줄 표시
- [x] "시작하기" 버튼 화면 하단 위치
- [x] CTA 스타일 (warmOrange, 흰색 텍스트, 52dp, 24dp 둥근 모서리)
- [x] 버튼 탭 시 /onboarding/register 이동
- [x] Scaffold 배경색 theme.scaffoldBackgroundColor (라이트: cream, 다크: darkBg)

### 4-2. 화면 B (BabyRegisterScreen)
- [x] AppBar "아기 등록" 타이틀 (뒤로 가기 + 타이틀)
- [x] 뒤로 가기 탭 시 WelcomeScreen 복귀
- [x] 프로필 사진 CircleAvatar + 카메라/갤러리 BottomSheet
- [x] 아기 이름 TextField (레이블, 플레이스홀더)
- [x] 2-4-5 텍스트 입력 스펙 준수 (배경, 테두리, 포커스 테두리, 둥근 모서리)
- [x] 생년월일 필드 (레이블 + 탭 영역)
- [x] CupertinoDatePicker BottomSheet
- [x] 최대/최소 날짜 설정 (nowKST() 사용)
- [x] 주차 미리보기 자동 표시 (WeekCalculator 사용)
- [x] 미선택 시 미리보기 미표시
- [x] "등록하기" 버튼 하단 위치
- [x] 이름/생년월일 미입력 시 비활성 (mutedBeige)
- [x] 입력 완료 시 활성화
- [x] Baby INSERT + activeBabyId 설정
- [x] /onboarding/intro 이동
- [x] 키보드 바깥 탭 시 키보드 닫힘

### 4-3. 화면 C (WeekIntroScreen)
- [x] Lottie 축하 애니메이션 (에러 시 플레이스홀더 아이콘)
- [x] 인사 텍스트 "{이름}아/야, 반가워!"
- [x] 주차 정보 카드 (2-2-12 스펙)
- [x] 주차 레이블 Caption warmOrange (bodySmall + color override)
- [x] 테마 제목 H2 (headlineMedium)
- [x] 핵심 포인트 불릿 리스트 (warmOrange 점)
- [x] WeekCalculator.calculateWeekIndex() 사용
- [x] CTA 메시지 표시
- [x] "다음" 버튼 -> /onboarding/notification

### 4-4. 화면 D (NotificationPermissionScreen)
- [x] Lottie 벨 애니메이션 (에러 시 플레이스홀더 아이콘)
- [x] 제목 텍스트 표시
- [x] 알림 가치 설명 3개 불릿 리스트
- [x] "알림 받기" CTA 버튼
- [x] "나중에 설정할게요" TextButton (labelMedium, warmOrange)
- [x] "알림 받기" -> permission_handler 권한 요청
- [x] 허용 시 isDailyNotificationOn = true + 홈 이동
- [x] 거부 시 isDailyNotificationOn = false + 부정적 메시지 없이 홈 이동
- [x] "나중에 설정할게요" -> isDailyNotificationOn = false + 홈 이동
- [x] 두 경로 모두 isOnboardingComplete = true 설정
- [x] go() 사용으로 라우트 스택 클리어

### 4-5. GoRouter
- [x] GoRouter가 Riverpod Provider로 정의
- [x] isOnboardingComplete 기반 initialLocation 분기
- [x] 온보딩 라우트 4개 정의
- [x] 메인 ShellRoute /home 정의
- [x] MainShell 5개 탭 표시
- [x] MaterialApp.router 변환 완료

### 4-6. WeekCalculator
- [x] calculateWeekLabel: 0~13일 -> "0-1주"
- [x] calculateWeekLabel: 14~27일 -> "2-3주"
- [x] calculateWeekLabel: 28~41일 -> "4-5주"
- [x] calculateWeekLabel: 56일 -> "2개월" (수정 완료: (weeks / 4).round() = (8/4).round() = 2)
- [x] calculateWeekIndex: 0~13일 -> 0
- [x] calculateWeekIndex: 14~27일 -> 1
- [x] calculateWeekIndex: 28~41일 -> 2
- [x] 미래 날짜 -> "0-1주" / 인덱스 0
- [x] daysSinceBirth 정확한 일수 반환
- [x] 모든 계산에 nowKST() 사용

### 4-7. Baby 모델 + BabyDao
- [x] toMap(), fromMap(), copyWith() 구현
- [x] BabyExt: currentWeek, daysSinceBirth, weekLabel
- [x] BabyDao: insert, getById, getAll, update, delete

### 4-8. 온보딩 완료 후 재실행
- [x] isOnboardingComplete == true -> /home 직행

### 4-9. UX 원칙
- [x] 화면당 주요 행동 1개
- [x] 주차 소개: 테마 텍스트가 headlineMedium(H2), 주차 레이블은 bodySmall(caption)
- [x] 전문 용어 미사용
- [x] CTA 버튼 하단 배치
- [x] 필수 입력 최소화 (이름 + 생년월일)
- [x] 알림 거부 시 부정적 메시지 없음

### 4-10. 디자인 검증
- [x] Scaffold 배경: theme.scaffoldBackgroundColor (라이트: cream, 다크: darkBg)
- [x] CTA 배경 warmOrange, 텍스트 white
- [x] 비활성 버튼 mutedBeige
- [x] 주요 텍스트: theme.textTheme (라이트: darkBrown, 다크: darkTextPrimary)
- [x] 보조 텍스트: bodySmall/labelSmall (라이트: warmGray, 다크: darkTextSecondary)
- [x] 주차 레이블 warmOrange (color override)
- [x] Display 28sp Bold / H3 16sp SemiBold / H2 18sp SemiBold / Body1 15sp / Button 16sp SemiBold / ButtonSmall 14sp Medium
- [x] CTA 높이 52dp, 전체 너비, 24dp 둥근 모서리, elevation 1
- [x] 텍스트 입력 높이 48dp, 12dp 둥근, lightBeige/darkBorder 1px, 포커스 warmOrange 2px
- [x] AppBar 높이 56dp, theme 배경, elevation 0
- [x] 주차 정보 카드: theme.cardColor (white/darkCard), 16dp 둥근, 20dp 패딩, AppShadows.low
- [x] 텍스트 링크 labelMedium warmOrange, 48dp 터치 영역
- [x] 다크 모드: Scaffold 배경 darkBg, 카드 배경 darkCard, 텍스트 darkTextPrimary/darkTextSecondary, warmOrange 유지
- [x] 조부모 모드: Theme.of(context).textTheme 경유로 grandparentTheme의 fontSizeDelta +4sp 적용됨

### 4-11. 접근성
- [x] 버튼 터치 영역 최소 48x48dp
- [x] CTA 버튼 높이 52dp
- [x] AppBar 뒤로 가기 48x48dp
- [x] "나중에 설정할게요" 48dp 높이
- [x] 소리 의존 없음
- [x] 비활성 버튼으로 빈 상태 안내

### 빌드/분석
- [x] flutter analyze: 경고 0건, 에러 0건
- [x] flutter test: 1/1 통과 (smoke test)

## 알려진 제한사항 / 다음 스프린트 이슈

1. **Lottie 애니메이션**: 플레이스홀더 JSON으로 최소한의 애니메이션만 포함. 실제 디자인 에셋은 이후 교체 필요
2. **프로필 사진**: 앱 재시작 시 임시 경로의 이미지가 유실될 수 있음. 영구 저장소로의 복사 로직은 이후 개선 필요
3. **PrimaryCtaButton**: AppTextStyles.button을 textStyle로 직접 사용 중이나, ElevatedButton.styleFrom의 foregroundColor가 실제 텍스트 색상을 제어하므로 기능적 문제 없음. 조부모 모드에서 CTA 버튼 텍스트도 +4sp 적용하려면 Theme의 elevatedButtonTheme.textStyle을 참조하도록 변경 필요 (향후 개선)
4. **NavigationBar label**: AppTextStyles.small을 직접 사용하지만 NavigationBarThemeData에서 관리되므로 조부모 모드 적용을 위해서는 NavigationBarThemeData도 textTheme에서 가져오도록 변경 필요 (향후 개선)
5. **주차 카드 패딩**: `EdgeInsets.all(20)` 하드코딩. AppDimensions에 20 값 상수 없어 직접 지정 (A-2)
