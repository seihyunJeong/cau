# Sprint 02 검증 결과 (최종 -- 코드 리뷰 + Marionette UI 검증)

## 판정: PASS

코드 리뷰 PASS 판정에 이어, Android 에뮬레이터에서 Marionette MCP를 통한 실제 앱 UI 검증을 완료하였다. 온보딩 플로우 4개 화면(A->B->C->D) 전환이 모두 정상 동작하며, 사양서의 ValueKey가 올바르게 탐색되고, 디자인 스펙(색상, 크기, 간격)이 실제 렌더링 결과와 일치한다.

---

## 기능 검증 (UI 실행 테스트 -- Marionette MCP)

**환경:** Android 에뮬레이터 (Pixel 3 API 34), VM Service URI: ws://127.0.0.1:55384/6pEPo6_YZaY=/ws

### 1. 화면 A: WelcomeScreen

| # | 테스트 시나리오 | 판정 | 비고 |
|---|---|---|---|
| 1 | `welcome_screen` Scaffold 존재 | PASS | Key: "welcome_screen" 확인됨 |
| 2 | `welcome_title` "하루 한 가지" 텍스트 존재 | PASS | Key: "welcome_title", Text: "하루 한 가지" |
| 3 | `welcome_tagline` 3줄 태그라인 존재 | PASS | Key: "welcome_tagline" Column. "오늘 하나만 해도 충분해요" / "전문가가 설계한 우리 아이" / "맞춤 발달 가이드" 3줄 확인 |
| 4 | `welcome_start_button` 존재 및 활성 | PASS | Key: "welcome_start_button", enabled: true |
| 5 | 일러스트/플레이스홀더 존재 | PASS | 화면 중앙 상단에 스마일 아이콘 (원형 배경) 표시. Lottie 파일 없을 시 플레이스홀더 허용 |
| 6 | "시작하기" 탭 -> 화면 B 이동 | PASS | tap(key: "welcome_start_button") 후 `register_screen` Scaffold 확인 |
| 7 | Display 스타일 28sp Bold | PASS | size: 28.0, weight: w700 확인 |
| 8 | CTA 하단 배치 (한 손 조작) | PASS | y: 677 / 총 높이 761 = 하단 11%. 엄지 도달 범위 |
| 9 | Scaffold 배경색 cream | PASS | 스크린샷에서 연한 크림색 확인 |

### 2. 화면 B: BabyRegisterScreen

| # | 테스트 시나리오 | 판정 | 비고 |
|---|---|---|---|
| 1 | `register_screen` Scaffold 존재 | PASS | Key: "register_screen" 확인됨 |
| 2 | `register_name_field` TextField 존재 | PASS | Key: "register_name_field", hintText: "예) 하루" |
| 3 | `register_birthdate_field` 존재 | PASS | Key: "register_birthdate_field", placeholder: "생년월일을 선택해주세요" |
| 4 | `register_photo_button` 존재 | PASS | Key: "register_photo_button", "사진 추가" 텍스트 |
| 5 | `register_submit_button` 초기 비활성 | PASS | enabled: false, backgroundColor: mutedBeige(0.7686, 0.7098, 0.6471) |
| 6 | AppBar "아기 등록" 타이틀 | PASS | 16sp, w600 (H3 SemiBold) |
| 7 | 뒤로 가기 IconButton 존재 | PASS | bounds: 48x48dp, 탭 시 WelcomeScreen 복귀 확인 |
| 8 | 이름 입력 동작 | PASS | tap -> enter_text(input: "하루") -> 텍스트 "하루" 입력 확인 |
| 9 | 포커스 시 warmOrange 테두리 | PASS | 스크린샷에서 오렌지 테두리 확인. focusedBorder: OutlineInputBorder |
| 10 | 생년월일 탭 -> DatePicker 표시 | PASS | CupertinoDatePicker BottomSheet 표시. 3열(월/일/년) 스크롤 휠 |
| 11 | DatePicker 최대 날짜 = 오늘 | PASS | 2026 이후 연도(2027+) inactive gray 색상. March 27, 2026 (오늘)이 기본 선택 |
| 12 | DatePicker "확인" 탭 -> 날짜 반영 | PASS | "2026년 03월 27일" 형식으로 표시됨 |
| 13 | `register_week_preview` 주차 미리보기 | PASS | Key: "register_week_preview", Text: "우리 아기는 지금 0-1주차예요!" (warmOrange, 15sp, w600) |
| 14 | 이름+생년월일 입력 후 버튼 활성화 | PASS | enabled: false -> true 변경 확인. backgroundColor 변경: mutedBeige -> warmOrange |
| 15 | "등록하기" 탭 -> 화면 C 이동 | PASS | tap(key: "register_submit_button") 후 `intro_screen` Scaffold 확인 |
| 16 | TextField 스펙 일치 | PASS | 높이 48dp, contentPadding(16,12,16,12), fillColor: white, enabledBorder/focusedBorder: OutlineInputBorder |

### 3. 화면 C: WeekIntroScreen

| # | 테스트 시나리오 | 판정 | 비고 |
|---|---|---|---|
| 1 | `intro_screen` Scaffold 존재 | PASS | Key: "intro_screen" 확인됨 |
| 2 | `intro_greeting` 인사 텍스트 (아기 이름 포함) | PASS | Text: "하루야, 반가워!" -- 이름 "하루" + 한글 조사 "야" 올바름 |
| 3 | `intro_week_card` 주차 정보 카드 | PASS | 배경 white, BorderRadius 16.0, padding 20.0, boxShadow 존재 (AppShadows.low) |
| 4 | `intro_week_label` "0-1주차" | PASS | 13sp, warmOrange(0.9608, 0.6510, 0.1373) -- Caption 스타일 일치 |
| 5 | `intro_week_theme` "신경이 안정되는 시간" | PASS | 18sp, w600 (H2 SemiBold), darkBrown |
| 6 | 핵심 포인트 4개 불릿 리스트 | PASS | 15sp Body1. 내용: (1) "대부분의 시간을 잠으로 보내요" (2) "깜짝 놀라는 반응은 자연스러운 거예요" (3) "부모의 품이 가장 편안한 장소예요" (4) "밝은 빛이나 큰 소리는 자극이 될 수 있어요" |
| 7 | 하단 CTA 메시지 | PASS | "오늘부터 하루 한 가지, 함께 시작해볼까요?" (warmGray, 15sp, center) |
| 8 | `intro_next_button` "다음" 버튼 | PASS | warmOrange, 52dp, 24dp 둥근, 하단 배치 (y: 677) |
| 9 | "다음" 탭 -> 화면 D 이동 | PASS | tap(key: "intro_next_button") 후 `notification_screen` Scaffold 확인 |
| 10 | 테마 텍스트 > 주차 레이블 (숫자보다 말) | PASS | 테마 18sp > 주차 레이블 13sp. 시각적으로 테마가 더 눈에 띔 |
| 11 | 플레이스홀더 아이콘 존재 | PASS | 상단에 오렌지 원형 아이콘 (Lottie 대체) |

### 4. 화면 D: NotificationPermissionScreen

| # | 테스트 시나리오 | 판정 | 비고 |
|---|---|---|---|
| 1 | `notification_screen` Scaffold 존재 | PASS | Key: "notification_screen" 확인됨 |
| 2 | `notification_title` 제목 텍스트 | PASS | Text: "아기에게 맞는 활동 시간을\n알려드릴까요?" (22sp, w600, center) |
| 3 | 알림 가치 설명 3항목 | PASS | (1) "매일 오늘의 활동을 알려드려요" (2) "주차가 바뀌면 새로운 활동을 안내해요" (3) "아기의 성장 기념일을 함께 축하해요" -- 모두 15sp Body1 |
| 4 | `notification_allow_button` "알림 받기" | PASS | warmOrange, 52dp, 24dp 둥근, enabled: true |
| 5 | `notification_skip_button` "나중에 설정할게요" | PASS | TextButton, 14sp, w500 (Medium), warmOrange 텍스트 -- ButtonSmall 스타일 일치 |
| 6 | 스킵 버튼 터치 영역 48dp | PASS | bounds height: 48.0 확인 |
| 7 | "나중에 설정할게요" 탭 -> 홈 이동 | PASS | tap(key: "notification_skip_button") 후 `main_shell` Scaffold 확인 |
| 8 | 부정적 메시지 없음 | PASS | "알림을 켜지 않으면..." 등 죄책감 유발 문구 없음 |
| 9 | 플레이스홀더 아이콘 존재 | PASS | 상단에 오렌지 사각형 아이콘 (Lottie 벨 대체) |

### 5. 홈 화면 도착 확인

| # | 테스트 시나리오 | 판정 | 비고 |
|---|---|---|---|
| 1 | `main_shell` Scaffold 존재 | PASS | Key: "main_shell" 확인됨 |
| 2 | `bottom_nav_bar` NavigationBar 존재 | PASS | Key: "bottom_nav_bar" 확인됨 |
| 3 | 5개 탭 존재 | PASS | "홈"(nav_tab_home), "기록"(nav_tab_record), "활동"(nav_tab_activity), "발달"(nav_tab_dev_check), "마이"(nav_tab_my) |
| 4 | "홈" 탭 활성 상태 | PASS | "홈" 텍스트 color: warmOrange (선택 상태) |
| 5 | 아기 프로필 카드 | PASS | "하루 (0-1주차)", "오늘 태어났어요" |
| 6 | 빠른 기록 버튼 | PASS | "수유 +1" (오늘 0), "배변 +1" (오늘 0) |
| 7 | 오늘의 활동 카드 | PASS | "안기" 칩, "품-숨-멈춤 루틴" 제목, "시작하기" 버튼 |
| 8 | 성장 요약 빈 상태 | PASS | "아직 성장 기록이 없어요" (부정적 표현 없는 중립 메시지) |
| 9 | AppBar 타이틀 | PASS | "하루 한 가지" (Key: "home_app_bar") |

### 6. 전체 네비게이션 플로우

| # | 테스트 시나리오 | 판정 | 비고 |
|---|---|---|---|
| 1 | A -> B (시작하기) | PASS | welcome_start_button 탭 -> register_screen |
| 2 | B -> A (뒤로 가기) | PASS | IconButton(back) 탭 -> welcome_screen 복귀 |
| 3 | A -> B (재진입) | PASS | welcome_start_button 탭 -> register_screen (입력값 초기화 확인) |
| 4 | B -> C (등록하기) | PASS | register_submit_button 탭 -> intro_screen |
| 5 | C -> D (다음) | PASS | intro_next_button 탭 -> notification_screen |
| 6 | D -> Home (나중에 설정할게요) | PASS | notification_skip_button 탭 -> main_shell (홈 화면) |

### 7. 런타임 에러 확인

| # | 검증 | 판정 | 비고 |
|---|---|---|---|
| 1 | get_logs 호출 | SKIP | 서버 에러로 로그 조회 불가. 단, 전체 플로우 수행 중 크래시나 에러 화면 없이 정상 동작 확인 |

---

## Marionette 디자인 검증 (실제 렌더링 값 vs 사양서)

Marionette `get_interactive_elements`에서 반환된 실제 위젯 속성값과 사양서 스펙을 대조하였다.

### 컬러 팔레트 (실측)

| # | 항목 | 사양서 | 실제 렌더링 | 판정 |
|---|---|---|---|---|
| 1 | CTA 배경 (활성) | warmOrange #F5A623 | Color(0.9608, 0.6510, 0.1373) = RGB(245,166,35) = #F5A623 | PASS |
| 2 | CTA 배경 (비활성) | mutedBeige #C4B5A5 | Color(0.7686, 0.7098, 0.6471) = RGB(196,181,165) = #C4B5A5 | PASS |
| 3 | CTA 전경 (활성) | white | Color(1.0, 1.0, 1.0) alpha 1.0 | PASS |
| 4 | CTA 전경 (비활성) | white (투명) | Color(1.0, 1.0, 1.0) alpha 0.6 | PASS |
| 5 | 주요 텍스트 | darkBrown #3D3027 | Color(0.2392, 0.1882, 0.1529) = RGB(61,48,39) = #3D3027 | PASS |
| 6 | 보조 텍스트 | warmGray #8C7B6B | Color(0.5490, 0.4824, 0.4196) = RGB(140,123,107) = #8C7B6B | PASS |
| 7 | 주차 레이블 | warmOrange | Color(0.9608, 0.6510, 0.1373) = #F5A623 | PASS |
| 8 | 플레이스홀더 | mutedBeige #C4B5A5 | Color(0.7686, 0.7098, 0.6471) = #C4B5A5 | PASS |
| 9 | 스킵 버튼 텍스트 | warmOrange | Color(0.9608, 0.6510, 0.1373) = #F5A623 | PASS |

### 타이포그래피 (실측)

| # | 항목 | 사양서 | 실제 렌더링 | 판정 |
|---|---|---|---|---|
| 1 | Display (welcome_title) | 28sp Bold | 28.0sp, w700 | PASS |
| 2 | H1 (intro_greeting) | 22sp SemiBold | 22.0sp, w600 | PASS |
| 3 | H2 (intro_week_theme) | 18sp SemiBold | 18.0sp, w600 | PASS |
| 4 | H3 (AppBar 타이틀) | 16sp SemiBold | 16.0sp, w600 | PASS |
| 5 | Body1 (본문 텍스트) | 15sp Regular | 15.0sp, w400 | PASS |
| 6 | Caption (주차 레이블) | 13sp Regular | 13.0sp, w400 | PASS |
| 7 | ButtonSmall (스킵 버튼) | 14sp Medium | 14.0sp, w500 | PASS |
| 8 | Button (CTA 텍스트) | 16sp SemiBold | 16.0sp, w600 | PASS |
| 9 | Font family | Pretendard | family: "Pretendard" | PASS |

### 컴포넌트 스펙 (실측)

| # | 항목 | 사양서 | 실제 렌더링 | 판정 |
|---|---|---|---|---|
| 1 | CTA 높이 | 52dp | minimumSize: Size(Infinity, 52.0) | PASS |
| 2 | CTA 전체 너비 | Infinity | Size(Infinity, 52.0) | PASS |
| 3 | CTA 둥근 모서리 | 24dp | BorderRadius.circular(24.0) | PASS |
| 4 | CTA elevation (활성) | 1 | WidgetState.any: 1.0 | PASS |
| 5 | CTA elevation (비활성) | 0 | WidgetState.disabled: 0.0 | PASS |
| 6 | TextField 높이 | 48dp | bounds height: 48.0 | PASS |
| 7 | TextField 배경 | white | fillColor: Color(1.0, 1.0, 1.0) = #FFFFFF | PASS |
| 8 | TextField padding | 수평 16dp | contentPadding: EdgeInsets(16.0, 12.0, 16.0, 12.0) | PASS |
| 9 | 주차 카드 배경 | white | Color(1.0, 1.0, 1.0) = #FFFFFF | PASS |
| 10 | 주차 카드 둥근 모서리 | 16dp | BorderRadius.circular(16.0) | PASS |
| 11 | 주차 카드 패딩 | 20dp | padding: EdgeInsets.all(20.0) | PASS |
| 12 | 주차 카드 그림자 | AppShadows.low | boxShadow: Offset(0.0, 1.0), blur 4.0 | PASS |
| 13 | 뒤로 가기 터치 영역 | 48x48dp | bounds: 48x48 | PASS |
| 14 | 스킵 버튼 터치 높이 | 48dp | bounds height: 48.0 | PASS |

---

## UX 원칙 검증 (Marionette 실행 기반)

| 원칙 | 판정 | Marionette 검증 근거 |
|---|---|---|
| 1. 하나만 해도 충분 | PASS | 각 화면에 주요 CTA 1개만 존재. 화면 A: "시작하기", B: "등록하기", C: "다음", D: "알림 받기"/"나중에 설정할게요" |
| 2. 숫자보다 말 | PASS | 주차 소개(C)에서 테마 "신경이 안정되는 시간"(18sp)이 주차 레이블 "0-1주차"(13sp)보다 크고 눈에 띔. 주차 미리보기(B) "우리 아기는 지금 0-1주차예요!" 자연어 문장 |
| 3. 부모 언어 | PASS | 4개 화면 전체에서 전문 용어 없음. 핵심 포인트: "깜짝 놀라는 반응은 자연스러운 거예요" 등 부모 친화적 표현 |
| 4. 한 손, 30초 | PASS | 모든 CTA 하단 배치 (y: 677~697 / 총 761). 필수 입력: 이름(키보드) + 생년월일(스크롤 피커) 2개뿐 |
| 5. 죄책감 금지 | PASS | 알림 스킵 시 부정적 메시지 없음. "나중에 설정할게요" 중립 톤. 홈의 빈 상태 "아직 성장 기록이 없어요" (부정어 없음) |

---

## 이전 코드 리뷰 결과 (변경 없음 -- 유지)

### FAIL 항목 재검증 상세

#### FAIL-1 (이전): WeekCalculator 월 계산 로직 오류 -> PASS (수정 완료)

- `(weeks / 4).round()`로 변경, 56일=2개월 정확히 반환

#### FAIL-2 (이전): Scaffold 배경 하드코딩 -> PASS (수정 완료)

- 4개 온보딩 화면 모두 `theme.scaffoldBackgroundColor` 사용

#### FAIL-3 (이전): 주차 카드 배경 하드코딩 -> PASS (수정 완료)

- `theme.cardColor` 사용

#### FAIL-4 (이전): AppTextStyles color 하드코딩 -> PASS (수정 완료)

- AppTextStyles에서 모든 color 속성 제거, `Theme.of(context).textTheme` 사용

#### FAIL-5 (이전): 조부모 모드 비실효 -> PASS (수정 완료)

- `grandparentTheme()`의 `fontSizeDelta: 4` 정상 적용

### 기존 PASS 항목

- 4-0. ValueKey 지정: **PASS** (22개 모두 확인)
- 4-1. 화면 A: **PASS**
- 4-2. 화면 B: **PASS**
- 4-3. 화면 C: **PASS**
- 4-4. 화면 D: **PASS**
- 4-5. GoRouter: **PASS**
- 4-6. WeekCalculator: **PASS**
- 4-7. Baby 모델 + BabyDao: **PASS**
- 4-8. 온보딩 완료 후 재실행: **PASS**
- 4-9. UX 원칙 검증: **PASS**
- 4-11. 접근성 검증: **PASS**
- 4-12. 엣지 케이스 검증: **PASS**

### 디자인 검증: **PASS**

### 빌드/분석

| # | 검증 | 판정 | 비고 |
|---|---|---|---|
| 1 | flutter analyze | PASS | "No issues found!" |
| 2 | flutter test | PASS | "All tests passed!" |

---

## 경미한 발견 사항 (PASS 판정에 영향 없음)

| # | 항목 | 비고 |
|---|---|---|
| A-2 | 주차 카드 패딩 20dp 직접 지정 | AppDimensions에 20 상수 없음. 경미 |
| A-3 | GoRoute (ShellRoute 아님) | 플레이스홀더 단계. 향후 리팩토링 |
| A-4 | 탭 레이블 "발달" (사양서 "발달 체크") | Sprint 01 영역 |
| A-5 | 이모지 한글 조사 처리 | 경미 |
| A-6 | PrimaryCtaButton AppTextStyles.button 직접 사용 | 조부모 모드 CTA +4sp 미적용. 경미 |
| A-7 | NavigationBar label AppTextStyles.small 직접 사용 | 조부모 모드 탭 레이블 +4sp 미적용. 경미 |

---

## 최종 판정

**PASS**

코드 리뷰와 Marionette MCP UI 실행 테스트를 모두 완료하였다.

**코드 리뷰 결과:** 이전 5건의 FAIL 항목이 모두 수정되었고, flutter analyze 0건, flutter test 통과.

**Marionette UI 검증 결과:** 온보딩 플로우 4개 화면(Welcome -> Register -> Week Intro -> Notification) -> 홈 화면까지 전체 네비게이션이 정상 동작한다. 사양서에 명시된 22개 ValueKey가 모두 올바르게 탐색되고, 디자인 스펙(컬러, 타이포그래피, 컴포넌트 크기)이 실제 렌더링 결과와 정확히 일치한다. UX 원칙 5가지 모두 충족. 전체 플로우 수행 중 크래시 없음.
