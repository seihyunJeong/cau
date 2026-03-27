# Sprint 02: 온보딩 (Onboarding) - 4개 화면

## 1. 구현 범위

### 개요

앱 최초 실행 시 사용자를 안내하는 온보딩 플로우 전체를 구현한다.
로그인/회원가입 없이 즉시 아기 등록으로 진입하며, 온보딩 완료 후 홈 화면으로 이동한다.

> **온보딩 플로우:** 웰컴(A) -> 아기 등록(B) -> 주차 소개(C) -> 알림 권한(D) -> 홈

### 구현할 화면/기능 목록

| # | 항목 | 설명 | 관련 문서 |
|---|---|---|---|
| 1 | **WelcomeScreen** (화면 A) | 앱 브랜딩, 태그라인, "시작하기" CTA 버튼 | 개발기획서 5-1 화면 A |
| 2 | **BabyRegisterScreen** (화면 B) | 이름(필수), 생년월일(필수), 프로필 사진(선택), 주차 자동 계산 미리보기 | 개발기획서 5-1 화면 B |
| 3 | **WeekIntroScreen** (화면 C) | Lottie 축하 애니메이션, 아기 이름 인사, 주차 정보 카드 (테마/특징), "다음" 버튼 | 개발기획서 5-1 화면 C |
| 4 | **NotificationPermissionScreen** (화면 D) | 알림 가치 설명, "알림 받기" CTA, "나중에 설정할게요" 텍스트 링크. 완료 시 `isOnboardingComplete = true` | 개발기획서 5-1 화면 D |
| 5 | **GoRouter 설정** (app_router.dart) | 온보딩 라우트 4개 + 메인 ShellRoute 플레이스홀더 + `isOnboardingComplete` 기반 리다이렉트 | 개발기획서 4-4 (라우터) |
| 6 | **Baby 모델** | `Baby` 순수 Dart 클래스 (id, name, birthDate, profileImagePath, createdAt, isActive) + `BabyExt` extension | 개발기획서 4-2-2 |
| 7 | **BabyDao** | `babies` 테이블 CRUD (insert, getById, getAll, update, delete) | 개발기획서 4-5 |
| 8 | **WeekCalculator** | `calculateWeekLabel()`, `calculateWeekIndex()`, `daysSinceBirth()` | 개발기획서 6-1 |
| 9 | **OnboardingProvider** | 온보딩 상태 관리 (입력값 보관, 등록 처리) | 개발기획서 5-1 |
| 10 | **WeekContent 시드 데이터** (최소 0-1주차) | 주차 소개 화면에 표시할 콘텐츠 | 개발기획서 8-1, 8-8 |
| 11 | **app.dart 수정** | MaterialApp -> MaterialApp.router 로 GoRouter 연결 | 개발기획서 4-4 |
| 12 | **MainShell 플레이스홀더** | 온보딩 완료 후 랜딩될 메인 쉘 최소 구현 (빈 Scaffold + 하단 탭 바) | 개발기획서 5-2 |

### 사용할 디자인 컴포넌트 번호

| 컴포넌트 번호 | 이름 | 사용 화면 |
|---|---|---|
| `2-1-2` 변형 B | 앱 바 (뒤로 가기 + 타이틀) | 화면 B (아기 등록) |
| `2-2-12` | 주차 정보 카드 | 화면 C (주차 소개) |
| `2-3-1` | 기본 CTA 버튼 | 화면 A, B, C, D 모두 |
| `2-3-2` | 보조 버튼 | 화면 D (참고용) |
| `2-3-6` | 텍스트 링크 버튼 | 화면 D ("나중에 설정할게요") |
| `2-4-3` | 날짜 선택기 (CupertinoDatePicker 변형) | 화면 B (생년월일 선택) |
| `2-4-5` | 텍스트 입력 필드 | 화면 B (아기 이름) |

---

## 2. 파일 목록

### 생성할 파일

```
lib/
├── core/
│   ├── router/
│   │   └── app_router.dart                          # GoRouter 라우트 정의 + Provider
│   ├── utils/
│   │   └── week_calculator.dart                     # 주차 계산 유틸
│   └── widgets/
│       └── primary_cta_button.dart                  # 2-3-1 기본 CTA 버튼 재사용 위젯
│
├── data/
│   ├── models/
│   │   └── baby.dart                                # Baby 모델 + BabyExt extension
│   ├── database/
│   │   └── daos/
│   │       └── baby_dao.dart                        # BabyDao CRUD
│   └── seed/
│       └── week_content_seed.dart                   # WeekContent 모델 + 0-1주차 시드 데이터
│
├── features/
│   ├── onboarding/
│   │   ├── screens/
│   │   │   ├── welcome_screen.dart                  # 화면 A: 웰컴
│   │   │   ├── baby_register_screen.dart            # 화면 B: 아기 등록
│   │   │   ├── week_intro_screen.dart               # 화면 C: 주차 소개
│   │   │   └── notification_permission_screen.dart  # 화면 D: 알림 권한
│   │   └── providers/
│   │       └── onboarding_provider.dart             # 온보딩 상태 관리
│   │
│   └── main_shell/
│       └── main_shell.dart                          # MainShell 플레이스홀더 (하단 탭 바)
│
└── providers/
    └── baby_providers.dart                          # babyDaoProvider, activeBabyProvider 등

assets/
├── lottie/
│   ├── celebration.json                             # 축하 애니메이션 (화면 C) -- 플레이스홀더
│   └── notification_bell.json                       # 벨 애니메이션 (화면 D) -- 플레이스홀더
└── images/
    └── onboarding_illustration.png                  # 웰컴 일러스트 -- 플레이스홀더
```

### 수정할 기존 파일

| 파일 | 변경 내용 |
|---|---|
| `lib/app.dart` | `MaterialApp` -> `MaterialApp.router` 전환, GoRouter 연결 |
| `lib/providers/core_providers.dart` | `babyDaoProvider` 추가 |
| `pubspec.yaml` | `permission_handler`, `image_picker` 패키지 추가 + assets 폴더 등록 |

---

## 3. 데이터 모델

### 3-1. Baby 모델 (lib/data/models/baby.dart)

개발기획서 4-2-2 기준. 순수 Dart 클래스, 코드 생성 불필요.

```dart
class Baby {
  final int? id;
  final String name;
  final DateTime birthDate;
  final String? profileImagePath;
  final DateTime createdAt;
  final bool isActive;

  const Baby({
    this.id,
    required this.name,
    required this.birthDate,
    this.profileImagePath,
    required this.createdAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() => { ... };
  factory Baby.fromMap(Map<String, dynamic> map) => ...;
  Baby copyWith({ ... }) => ...;
}

extension BabyExt on Baby {
  int get currentWeek => WeekCalculator.calculateWeekIndex(birthDate);
  int get daysSinceBirth => DateTime.now().difference(birthDate).inDays;
  String get weekLabel => WeekCalculator.calculateWeekLabel(birthDate);
}
```

### 3-2. BabyDao (lib/data/database/daos/baby_dao.dart)

개발기획서 4-5 기준. `DatabaseHelper.instance`를 사용하여 `babies` 테이블에 CRUD 수행.

- `Future<int> insert(Baby baby)` -- id 자동 생성, toMap에서 id 제거
- `Future<Baby?> getById(int id)`
- `Future<List<Baby>> getAll()`
- `Future<int> update(Baby baby)`
- `Future<int> delete(int id)`

### 3-3. WeekContent 시드 데이터 (lib/data/seed/week_content_seed.dart)

개발기획서 8-1, 8-8 기준. 이 스프린트에서는 최소한 0-1주차 데이터를 포함한다.

```dart
class WeekContent {
  final int weekIndex;
  final String weekLabel;
  final String theme;
  final String overview;
  final List<String> keyPoints;
  // activities, devPoints 등은 이후 스프린트에서 확장
}
```

### 3-4. AppSettingsService (기존 -- 수정 없음)

Sprint 01에서 구현 완료. 다음 메서드를 온보딩에서 사용:
- `bool get isOnboardingComplete`
- `Future<void> setOnboardingComplete(bool value)`
- `Future<void> setActiveBabyId(int? value)`
- `bool get isDailyNotificationOn`
- `Future<void> setDailyNotificationOn(bool value)`

### 3-5. Riverpod Providers

```dart
// lib/providers/baby_providers.dart
final babyDaoProvider = Provider<BabyDao>((ref) => BabyDao());

final activeBabyProvider = FutureProvider<Baby?>((ref) async {
  final settings = ref.watch(appSettingsServiceProvider);
  final dao = ref.watch(babyDaoProvider);
  final id = settings.activeBabyId;
  if (id == null) return null;
  return dao.getById(id);
});
```

---

## 4. 검증 기준 (Evaluator용)

모든 항목은 PASS/FAIL로 판정한다. Marionette MCP로 앱을 실행하여 UI 상호작용 테스트를 수행할 예정이므로, 주요 위젯에 `ValueKey`를 지정하고 해당 Key로 요소를 탐색한다.

### 4-0. ValueKey 지정 기준 (Marionette 테스트용)

아래의 ValueKey가 각 위젯에 반드시 지정되어야 한다:

| ValueKey | 위젯 | 화면 |
|---|---|---|
| `'welcome_screen'` | WelcomeScreen의 최상위 Scaffold | 화면 A |
| `'welcome_start_button'` | "시작하기" ElevatedButton | 화면 A |
| `'welcome_title'` | "하루 한 가지" 텍스트 | 화면 A |
| `'welcome_tagline'` | 태그라인 텍스트 | 화면 A |
| `'register_screen'` | BabyRegisterScreen의 최상위 Scaffold | 화면 B |
| `'register_name_field'` | 아기 이름 TextField | 화면 B |
| `'register_birthdate_field'` | 생년월일 선택 영역 (탭 가능) | 화면 B |
| `'register_photo_button'` | 사진 추가 버튼 (CircleAvatar 영역) | 화면 B |
| `'register_week_preview'` | 주차 미리보기 텍스트 ("우리 아기는 지금 X주차예요!") | 화면 B |
| `'register_submit_button'` | "등록하기" ElevatedButton | 화면 B |
| `'intro_screen'` | WeekIntroScreen의 최상위 Scaffold | 화면 C |
| `'intro_greeting'` | 인사 텍스트 ("{이름}아, 반가워!") | 화면 C |
| `'intro_week_card'` | 주차 정보 카드 (2-2-12) | 화면 C |
| `'intro_week_label'` | 주차 레이블 텍스트 (예: "0-1주차") | 화면 C |
| `'intro_week_theme'` | 주차 테마 텍스트 (예: "신경이 안정되는 시간") | 화면 C |
| `'intro_next_button'` | "다음" ElevatedButton | 화면 C |
| `'notification_screen'` | NotificationPermissionScreen의 최상위 Scaffold | 화면 D |
| `'notification_allow_button'` | "알림 받기" ElevatedButton | 화면 D |
| `'notification_skip_button'` | "나중에 설정할게요" TextButton | 화면 D |
| `'notification_title'` | 알림 가치 설명 제목 텍스트 | 화면 D |
| `'main_shell'` | MainShell의 최상위 Scaffold | 메인 쉘 |
| `'bottom_nav_bar'` | 하단 탭 바 NavigationBar | 메인 쉘 |

- [ ] 위 표의 모든 ValueKey가 해당 위젯에 정확히 지정되어 있다
- [ ] Marionette `get_interactive_elements`로 각 화면에서 해당 Key의 요소가 탐색된다

---

### 4-1. 기능 검증: 화면 A (WelcomeScreen)

- [ ] 앱 최초 실행 시 (`isOnboardingComplete == false`) WelcomeScreen이 표시된다
- [ ] 화면 중앙 상단에 일러스트(또는 플레이스홀더 이미지/아이콘)가 표시된다
- [ ] "하루 한 가지" 앱 이름이 Display 스타일(28sp, Bold)로 표시된다
- [ ] 태그라인 3줄이 표시된다: "오늘 하나만 해도 충분해요" / "전문가가 설계한 우리 아이" / "맞춤 발달 가이드"
- [ ] "시작하기" 버튼이 화면 하단에 위치한다 (한 손 조작 고려)
- [ ] "시작하기" 버튼은 기본 CTA 스타일(2-3-1): warmOrange 배경, 흰색 텍스트, 52dp 높이, 24dp 둥근 모서리
- [ ] "시작하기" 버튼 탭 시 `/onboarding/register` 경로로 이동하여 BabyRegisterScreen이 표시된다
- [ ] Scaffold 배경색은 `AppColors.cream` (#FFF8F0)이다

### 4-2. 기능 검증: 화면 B (BabyRegisterScreen)

- [ ] AppBar에 "아기 등록" 타이틀이 표시된다 (변형 B: 뒤로 가기 + 타이틀)
- [ ] AppBar 뒤로 가기 버튼 탭 시 WelcomeScreen으로 돌아간다
- [ ] 프로필 사진 영역이 CircleAvatar로 표시되며, 탭하면 카메라/갤러리 선택 BottomSheet가 뜬다 (또는 image_picker 다이얼로그). 사진 미선택 시에도 등록 진행 가능하다
- [ ] 아기 이름 TextField가 표시된다: 레이블 "아기 이름 *", 플레이스홀더 "예) 하루"
- [ ] 이름 필드는 2-4-5 스펙: 배경 #FFFFFF, 기본 테두리 lightBeige 1px, 포커스 시 warmOrange 2px, 12dp 둥근 모서리
- [ ] 생년월일 필드가 표시된다: 레이블 "생년월일 *"
- [ ] 생년월일 필드 탭 시 CupertinoDatePicker(스크롤 휠 방식)가 BottomSheet로 표시된다
- [ ] DatePicker의 최대 날짜는 오늘, 최소 날짜는 오늘로부터 60개월 전으로 설정된다
- [ ] 생년월일 선택 시 주차 미리보기 텍스트가 자동으로 표시된다: "우리 아기는 지금 X주차예요!" (WeekCalculator 사용)
- [ ] 생년월일 미선택 상태에서는 주차 미리보기가 표시되지 않는다
- [ ] "등록하기" 버튼이 화면 하단에 위치한다 (기본 CTA 스타일 2-3-1)
- [ ] 이름이 비어 있거나 생년월일이 미선택인 상태에서는 "등록하기" 버튼이 비활성(disabled) 상태이다: 배경색 mutedBeige(#C4B5A5), 탭 불가
- [ ] 이름 입력 + 생년월일 선택 완료 시 "등록하기" 버튼이 활성화된다
- [ ] "등록하기" 탭 시: Baby 객체가 생성되어 `babies` 테이블에 INSERT 된다
- [ ] INSERT 후 반환된 id가 `AppSettingsService.setActiveBabyId(id)`로 저장된다
- [ ] INSERT 성공 후 `/onboarding/intro` 경로로 이동하여 WeekIntroScreen이 표시된다
- [ ] 이름 입력 시 키보드가 표시되며, 키보드 바깥 영역 탭 시 키보드가 닫힌다

### 4-3. 기능 검증: 화면 C (WeekIntroScreen)

- [ ] Lottie 축하 애니메이션이 상단에 표시된다 (파일 없을 시 플레이스홀더 아이콘으로 대체)
- [ ] 인사 텍스트가 등록된 아기 이름을 포함하여 표시된다: "{이름}아, 반가워!" (예: "하루야, 반가워!")
- [ ] 주차 정보 카드(2-2-12)가 표시된다: 배경 #FFFFFF, 16dp 둥근 모서리, 20dp 패딩
- [ ] 카드 내 주차 레이블이 Caption 스타일(13sp, warmOrange)로 표시된다: "0-1주차"
- [ ] 카드 내 테마 제목이 H2 스타일(18sp, SemiBold)로 표시된다: "신경이 안정되는 시간"
- [ ] 카드 내 핵심 포인트 목록이 Body1(15sp)로 불릿 리스트 형태로 표시된다 (warmOrange 불릿 점)
- [ ] 주차 정보는 WeekCalculator.calculateWeekIndex()로 계산한 인덱스로 WeekContent 시드 데이터에서 조회한다
- [ ] 하단 CTA 메시지 "오늘부터 하루 한 가지, 함께 시작해볼까요?"가 표시된다
- [ ] "다음" 버튼(기본 CTA 스타일 2-3-1)이 화면 하단에 위치한다
- [ ] "다음" 버튼 탭 시 `/onboarding/notification` 경로로 이동하여 NotificationPermissionScreen이 표시된다

### 4-4. 기능 검증: 화면 D (NotificationPermissionScreen)

- [ ] Lottie 벨 애니메이션이 상단에 표시된다 (파일 없을 시 플레이스홀더 아이콘으로 대체)
- [ ] 제목 텍스트가 표시된다: "아기에게 맞는 활동 시간을 알려드릴까요?"
- [ ] 알림 가치 설명 3개 항목이 불릿 리스트로 표시된다:
  - "매일 오늘의 활동을 알려드려요"
  - "주차가 바뀌면 새로운 활동을 안내해요"
  - "아기의 성장 기념일을 함께 축하해요"
- [ ] "알림 받기" 버튼(기본 CTA 스타일 2-3-1)이 표시된다
- [ ] "나중에 설정할게요" 텍스트 링크 버튼(2-3-6)이 CTA 아래에 표시된다: ButtonSmall 14sp, warmOrange
- [ ] "알림 받기" 버튼 탭 시 OS 알림 권한 요청 팝업이 트리거된다 (permission_handler)
- [ ] 알림 허용 시: `isDailyNotificationOn = true` 설정 후 홈(`/home`)으로 이동한다
- [ ] 알림 거부 시: `isDailyNotificationOn = false` 설정 후 부정적 메시지 없이 홈(`/home`)으로 이동한다
- [ ] "나중에 설정할게요" 탭 시: `isDailyNotificationOn = false` 설정 후 바로 홈(`/home`)으로 이동한다
- [ ] 두 경로 모두 홈 이동 전에 `isOnboardingComplete = true`가 설정된다
- [ ] 홈 이동 시 뒤로 가기로 온보딩 화면에 재진입할 수 없다 (라우트 스택 클리어 -- `go()` 사용)

### 4-5. 기능 검증: GoRouter 네비게이션

- [ ] `app_router.dart`에 GoRouter가 Riverpod Provider로 정의되어 있다
- [ ] `isOnboardingComplete == false`일 때 initialLocation은 `/onboarding`이다
- [ ] `isOnboardingComplete == true`일 때 initialLocation은 `/home`이다
- [ ] 온보딩 라우트 4개가 정의되어 있다: `/onboarding`, `/onboarding/register`, `/onboarding/intro`, `/onboarding/notification`
- [ ] 메인 ShellRoute가 정의되어 있으며, `/home` 경로로 MainShell이 렌더링된다
- [ ] MainShell에 5개 탭(홈, 기록, 활동, 발달 체크, 마이)의 하단 탭 바가 표시된다 (각 탭은 플레이스홀더)
- [ ] `app.dart`가 `MaterialApp.router`로 변경되어 GoRouter의 `routerConfig`를 사용한다

### 4-6. 기능 검증: WeekCalculator

- [ ] `WeekCalculator.calculateWeekLabel(birthDate)`가 올바른 주차 레이블을 반환한다:
  - 생후 0~13일 -> "0-1주"
  - 생후 14~27일 -> "2-3주"
  - 생후 28~41일 -> "4-5주"
  - 생후 56일 (8주) -> "2개월"
- [ ] `WeekCalculator.calculateWeekIndex(birthDate)`가 올바른 인덱스를 반환한다:
  - 0~13일 -> 0
  - 14~27일 -> 1
  - 28~41일 -> 2
- [ ] 미래 날짜(아직 태어나지 않은 아기) 입력 시 "0-1주" / 인덱스 0을 반환한다
- [ ] `WeekCalculator.daysSinceBirth(birthDate)`가 정확한 일수를 반환한다

### 4-7. 기능 검증: Baby 모델 + BabyDao

- [ ] `Baby` 클래스에 `toMap()`, `fromMap()`, `copyWith()` 메서드가 정상 동작한다
- [ ] `BabyExt` extension에 `currentWeek`, `daysSinceBirth`, `weekLabel` 계산 프로퍼티가 있다
- [ ] `BabyDao.insert(baby)`가 `babies` 테이블에 레코드를 삽입하고 id를 반환한다
- [ ] `BabyDao.getById(id)`가 삽입한 레코드를 정확히 조회한다
- [ ] `BabyDao.getAll()`이 모든 아기 목록을 반환한다

### 4-8. 기능 검증: 온보딩 완료 후 재실행

- [ ] 온보딩 완료 후 앱을 종료하고 재실행하면 (`isOnboardingComplete == true`) 홈 화면으로 바로 이동한다
- [ ] 온보딩 화면이 다시 표시되지 않는다

---

### 4-9. UX 원칙 검증

모든 온보딩 화면에 대해 서비스기획서 섹션 6의 UX 원칙 5가지를 검증한다.

#### 원칙 1: "하나만 해도 충분하다"
- [ ] 각 온보딩 화면에 주요 행동이 1개만 존재한다 (시작하기/등록하기/다음/알림 받기)
- [ ] 화면당 사용자에게 요구하는 결정이 최소화되어 있다

#### 원칙 2: "숫자보다 말로 안심시킨다"
- [ ] 주차 소개 화면(C)에서 주차 번호보다 테마 텍스트("신경이 안정되는 시간")가 더 크고 눈에 띈다
- [ ] 주차 미리보기(B)가 "우리 아기는 지금 X주차예요!"라는 자연어 문장으로 표현된다

#### 원칙 3: "전문 용어 대신 부모 언어 사용"
- [ ] 온보딩 4개 화면 전체에서 전문 용어(모로반사, NBAS 등)가 직접 노출되지 않는다
- [ ] 주차 소개(C)의 핵심 포인트가 부모 친화적 언어로 작성되어 있다 (예: "깜짝 놀라는 반응은 자연스러운 거예요")

#### 원칙 4: "한 손, 30초 안에 끝낼 수 있어야 한다"
- [ ] 모든 CTA 버튼이 화면 하단에 배치되어 한 손 엄지로 닿을 수 있다
- [ ] 아기 등록(B)에서 필수 입력은 이름(키보드)과 생년월일(스크롤 피커)뿐이다
- [ ] 프로필 사진은 선택사항으로, 건너뛰어도 등록 가능하다

#### 원칙 5: "죄책감을 주지 않는다"
- [ ] 알림 권한 거부 시 부정적 메시지가 표시되지 않는다 ("알림을 켜지 않으면..." 등 없음)
- [ ] "나중에 설정할게요"가 중립적 톤으로 표현되며, 바로 홈으로 이동한다
- [ ] 온보딩 중 건너뛰기/돌아가기에 대한 경고나 압박이 없다

---

### 4-10. 디자인 검증

#### 컬러 팔레트
- [ ] 모든 화면의 Scaffold 배경이 `AppColors.cream` (#FFF8F0)이다
- [ ] CTA 버튼 배경이 `AppColors.warmOrange` (#F5A623)이다
- [ ] CTA 버튼 텍스트가 흰색이다
- [ ] 비활성 버튼 배경이 `AppColors.mutedBeige` (#C4B5A5)이다
- [ ] 주요 텍스트 색상이 `AppColors.darkBrown` (#3D3027)이다
- [ ] 보조 텍스트/플레이스홀더 색상이 `AppColors.warmGray` (#8C7B6B) 또는 `AppColors.mutedBeige` (#C4B5A5)이다
- [ ] 주차 레이블 색상이 `AppColors.warmOrange` (#F5A623)이다

#### 타이포그래피
- [ ] 웰컴 화면 앱 이름이 Display 스타일 (28sp, Bold 700)이다
- [ ] AppBar 타이틀이 H3 스타일 (16sp, SemiBold 600)이다
- [ ] 주차 정보 카드 테마 제목이 H2 스타일 (18sp, SemiBold 600)이다
- [ ] 본문 텍스트가 Body1 스타일 (15sp)이다
- [ ] CTA 버튼 텍스트가 Button 스타일 (16sp, SemiBold 600)이다
- [ ] 텍스트 링크가 ButtonSmall 스타일 (14sp, Medium 500)이다

#### 컴포넌트 스펙 일치
- [ ] 기본 CTA 버튼(2-3-1): 높이 52dp, 전체 너비 (좌우 패딩 16dp 제외), 24dp 둥근 모서리, elevation 1
- [ ] 텍스트 입력 필드(2-4-5): 높이 48dp, 12dp 둥근 모서리, 기본 테두리 lightBeige 1px, 포커스 테두리 warmOrange 2px, 수평 패딩 16dp
- [ ] 앱 바 변형 B(2-1-2): 높이 56dp, 배경 cream, elevation 0, 좌측 뒤로 가기 아이콘 24dp (터치 영역 48x48dp)
- [ ] 주차 정보 카드(2-2-12): 배경 #FFFFFF, 16dp 둥근 모서리, 20dp 패딩, AppShadows.low 그림자
- [ ] 텍스트 링크 버튼(2-3-6): ButtonSmall 14sp, warmOrange, 터치 영역 48dp 높이 확보

#### 다크 모드
- [ ] 다크 모드에서 Scaffold 배경이 `AppColors.darkBg` (#1A1512)로 변경된다
- [ ] 다크 모드에서 카드 배경이 `AppColors.darkCard` (#2A231D)로 변경된다
- [ ] 다크 모드에서 주요 텍스트가 `AppColors.darkTextPrimary` (#F5EDE3)로 변경된다
- [ ] 다크 모드에서 warmOrange 포인트 색상은 변경 없이 유지된다 (#F5A623)

#### 조부모 모드
- [ ] 조부모 모드 활성화 시 모든 텍스트 크기가 +4sp 증가한다
- [ ] 조부모 모드에서도 레이아웃이 깨지지 않고 정상적으로 표시된다

---

### 4-11. 접근성 검증

- [ ] 모든 버튼의 터치 영역이 최소 48x48dp이다
- [ ] "시작하기", "등록하기", "다음", "알림 받기" 버튼 높이가 52dp이다
- [ ] AppBar 뒤로 가기 아이콘의 터치 영역이 48x48dp이다
- [ ] "나중에 설정할게요" 텍스트 링크의 InkWell/탭 영역이 최소 높이 48dp이다
- [ ] 무음 모드에서도 앱이 정상 동작한다 (소리 의존 없음)
- [ ] 화면 전환 시 시각적 전환 효과가 있어 현재 위치를 인식할 수 있다
- [ ] 빈 상태 처리: 아기 이름 미입력 시 버튼 비활성화로 명확히 안내된다 (에러 메시지가 아닌 비활성 상태)

---

### 4-12. 엣지 케이스 검증

- [ ] 아기 이름에 공백만 입력한 경우 "등록하기" 버튼이 비활성 상태를 유지한다 (trim 처리)
- [ ] 아기 이름에 이모지를 입력해도 정상 저장 및 표시된다
- [ ] 매우 긴 아기 이름(20자 이상) 입력 시 UI가 깨지지 않는다 (ellipsis 또는 줄바꿈 처리)
- [ ] 생년월일을 오늘로 선택해도 정상 동작한다 (생후 0일 = 0-1주)
- [ ] 화면 회전(가로 모드) 시에도 레이아웃이 크게 깨지지 않는다
- [ ] 키보드가 올라온 상태에서 "등록하기" 버튼이 가려지지 않는다 (스크롤 또는 키보드 회피)

---

## 5. 의존성

### 이전 스프린트 의존

| 스프린트 | 필요 항목 |
|---|---|
| **Sprint 01** (프로젝트 셋업) | AppColors, AppTextStyles, AppDimensions, AppRadius, AppShadows, AppStrings, AppTheme, GrandparentTheme, DatabaseHelper, Tables, AppSettingsService, core_providers, InfoTerm, main.dart, app.dart |

### 필요한 패키지 (pubspec.yaml 추가)

| 패키지 | 버전 | 용도 | 비고 |
|---|---|---|---|
| `permission_handler` | ^11.0.0 | 알림 권한 요청 (화면 D) | 신규 추가 |
| `image_picker` | ^1.0.0 | 프로필 사진 선택 (화면 B) | 신규 추가 |

### 기존 패키지 (Sprint 01에서 설치 완료)

| 패키지 | 용도 |
|---|---|
| `go_router` | GoRouter 네비게이션 |
| `flutter_riverpod` | 상태 관리 |
| `sqflite` | 로컬 DB (BabyDao) |
| `shared_preferences` | 앱 설정 (isOnboardingComplete) |
| `lottie` | Lottie 애니메이션 (화면 C, D) |
| `google_fonts` | Pretendard 폰트 |
| `intl` | 날짜 포맷 |
| `path_provider` | 파일 경로 (프로필 사진 저장) |
| `path` | 경로 유틸 |

### 에셋 파일 (플레이스홀더)

Lottie 애니메이션과 온보딩 일러스트는 실제 에셋이 준비되기 전까지 다음과 같이 처리한다:
- Lottie 파일이 없으면 `Icon(Icons.celebration, size: 80)` 또는 `Icon(Icons.notifications_active, size: 80)` 로 플레이스홀더 표시
- 웰컴 일러스트가 없으면 `Icon(Icons.child_care, size: 120, color: AppColors.warmOrange)` 로 플레이스홀더 표시
- `pubspec.yaml`의 assets 섹션에 `assets/lottie/` 및 `assets/images/` 경로를 등록하되, 파일이 없어도 빌드가 실패하지 않도록 조건부 로딩 처리

---

## 6. 구현 참고 사항

### 6-1. GoRouter 전환 패턴

`app.dart`를 `MaterialApp` -> `MaterialApp.router`로 전환할 때:

```dart
// 변경 전
MaterialApp(home: const _PlaceholderScreen())

// 변경 후
MaterialApp.router(routerConfig: ref.watch(appRouterProvider))
```

### 6-2. 날짜 선택기 구현 가이드

개발기획서에서 CupertinoDatePicker(스크롤 휠 방식)를 명시했으므로, BottomSheet 내에 CupertinoDatePicker를 배치한다:

```dart
showModalBottomSheet(
  context: context,
  builder: (_) => SizedBox(
    height: 280,
    child: CupertinoDatePicker(
      mode: CupertinoDatePickerMode.date,
      maximumDate: DateTime.now(),
      minimumDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      onDateTimeChanged: (date) { ... },
    ),
  ),
);
```

### 6-3. 온보딩 완료 로직 순서

화면 D에서 "알림 받기" 또는 "나중에 설정할게요" 선택 후:

1. 알림 설정 반영 (`setDailyNotificationOn`)
2. `setOnboardingComplete(true)` 호출
3. `context.go('/home')` 으로 이동 (push가 아닌 go -- 스택 초기화)

### 6-4. MainShell 플레이스홀더

이 스프린트에서는 MainShell을 최소한으로 구현한다:
- Scaffold + BottomNavigationBar (5개 탭: 홈, 기록, 활동, 발달 체크, 마이)
- 각 탭 내용은 `Center(child: Text('홈'))` 형태의 플레이스홀더
- 이후 스프린트에서 각 탭의 실제 화면으로 교체

### 6-5. 프로필 사진 저장

`image_picker`로 선택한 이미지를 앱의 documents 디렉토리에 복사하여 저장한다:

```dart
final dir = await getApplicationDocumentsDirectory();
final savedPath = '${dir.path}/baby_profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
await pickedFile.saveTo(savedPath);
// Baby.profileImagePath = savedPath
```
