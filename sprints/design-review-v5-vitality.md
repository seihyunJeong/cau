# Design Review v5 -- Vitality (Post-Fix)

**App:** "하루 한 가지" (영유아 발달 관찰 앱)
**Date:** 2026-04-03
**Reviewer:** QA Verification Agent (Claude Opus 4.6)
**Method:** Code review (Read/Grep) + Marionette MCP live UI inspection (light + dark mode)
**Previous Review:** design-review-v4-vitality.md (Score: 6.2/10 FAIL, 8 FAIL items)

---

## Overall Verdict: PASS -- Average 7.4/10

총점 37/50. 평균 7.4점으로 7점 이상이므로 **PASS** 판정.
이전 대비 +1.2점 개선. P0/P1 수정 항목 7개 중 7개 모두 검증 통과.

---

## FAIL Item Fix Verification

### FAIL-1: 페이지 전환 애니메이션 (P0) -- FIXED

**코드 확인:**
- `app/lib/core/router/app_router.dart` -- 모든 GoRoute에 `pageBuilder:` + `CustomTransitionPage` 적용 확인
- 3가지 전환 타입 구현:
  - `_slideTransitionPage()`: SlideTransition(우->좌) + FadeTransition(0~50% interval). 300ms, easeOutCubic. 온보딩/탭 내 네비게이션에 사용.
  - `_fadeTransitionPage()`: FadeTransition 단독. 350ms, easeOut. 메인 쉘 진입에 사용.
  - `_scaleTransitionPage()`: ScaleTransition(0.92->1.0) + FadeTransition(0~60% interval). 400ms, easeOutCubic. 결과/완료 화면에 사용 (checklist_result, observation_result).
- **Marionette 확인:** 활동 리스트 -> 활동 상세 전환 시 슬라이드+페이드 전환 확인. 기본 MaterialPageRoute 아님.

**판정: PASS**

### FAIL-2: 커스텀 비주얼 에셋 (P0) -- FIXED

**코드 확인:**
- `app/lib/shared/widgets/confetti_animation.dart` -- 55개 파티클, 4종 형태(circle, rect strip, star/sparkle, ring), burst phase(0~30%) + drift phase, 중심 glow 효과. AppColors 상수 사용(8개 색상). 2500ms.
- `app/lib/shared/widgets/bell_animation.dart` -- CustomPainter로 벨 형태 직접 그리기(bezier curves), TweenSequence로 dampening oscillation(15% -> -12% -> 10% -> -8% -> 5% -> -3% -> 0), glow pulse, sound wave arcs. 1500ms 반복.
- Lottie 의존성 완전 제거: `import 'package:lottie/lottie.dart'` 0건, `Lottie.` 호출 0건.
- `week_intro_screen.dart` -- ConfettiAnimation 적용 확인 (line 113)
- `notification_permission_screen.dart` -- BellAnimation 적용 확인 (line 94)
- `timer_completion_view.dart` -- ConfettiAnimation 적용 + 텍스트 fade-in 300ms delay 확인 (line 80-84)

**판정: PASS**

### FAIL-3: 다크 모드 깊이감 (P0) -- FIXED

**코드 확인:**
- `AppColors.darkBg`: #1A1512 -> **#121010** (더 어두워짐)
- `AppColors.darkCard`: #2A231D -> **#342B23** (더 밝아짐)
- `AppColors.darkCardElevated`: **#3D3328** 신규 추가 (히어로/액션 카드용 3단계 깊이)
- `AppColors.darkBorder`: #3D3027 -> **#4A3D32** (더 밝아짐, 가시성 향상)
- 명도 차이: darkBg(#121010) vs darkCard(#342B23) -- RGB 기준 약 20% 차이로 이전(~5%)대비 크게 개선.
- `AppShadows` -- 4종 다크 모드 그림자 추가:
  - `darkSubtle`: cream 4% alpha glow
  - `darkLow`: cream 5% alpha + ambient shadow
  - `darkMedium`: warmOrange 7% alpha glow + ambient shadow
  - `darkHigh`: warmOrange 9% alpha glow + ambient shadow
- `adaptive*()` 헬퍼 4종: `adaptiveSubtle/Low/Medium/High(bool isDark)`
- `isDark ? null : AppShadows.*` 안티패턴 완전 제거 (0건). 18개 위젯에서 `AppShadows.adaptive*()` 사용 확인.
- **Marionette 확인:** 다크 모드 스크린샷에서 카드-배경 구분이 명확. 히어로 카드(TodayMissionCard)의 darkCardElevated gradient 배경이 일반 카드(GrowthSummaryCard)보다 밝아 깊이 계층 형성. 보더 라인(#4A3D32)도 가시적.

**판정: PASS**

### FAIL-5: 탭 전환 애니메이션 (P0) -- FIXED

**코드 확인:**
- `app/lib/features/main_shell/main_shell.dart` -- IndexedStack 대신 Stack + AnimationController 크로스페이드:
  - AnimationController(250ms, easeOut)
  - 이전 탭: `Opacity(opacity: 1.0 - fadeAnimation.value)` + `IgnorePointer`
  - 현재 탭: `Opacity(opacity: fadeAnimation.value)`
  - `_onTabSelected()`: forward(from: 0)로 탭 전환 시 매번 새 애니메이션 트리거
- **Marionette 확인:** 홈->기록->활동->발달->마이 탭 전환 시 부드러운 크로스페이드 확인 (즉시 전환 아님).

**판정: PASS**

### FAIL-6: 레이더 차트 진입 애니메이션 (P1) -- FIXED

**코드 확인:**
- `app/lib/features/dev_check/widgets/radar_chart_card.dart`:
  - AnimationController(800ms) + CurvedAnimation(Curves.easeOutCubic)
  - `WidgetsBinding.instance.addPostFrameCallback`으로 첫 프레임 후 자동 시작
  - `animationProgress` multiplier가 `_RadarChartPainter`에 전달되어 데이터 포인트 * progress로 0->100% 확장
  - `didUpdateWidget`에서 데이터 변경 시 재애니메이션
- **Marionette 확인:** 발달 탭 진입 시 레이더 차트가 중심점에서 바깥으로 확장되는 애니메이션 확인 불가 (데이터가 0이라 점 상태). 하지만 코드 로직은 올바름.

**판정: PASS** (코드 로직 정상. 데이터 0인 상태에서는 시각적 차이가 미미하나 구현 자체는 올바름)

### FAIL-7: 타이머 컨트롤 버튼 피드백 (P1) -- FIXED

**코드 확인:**
- `app/lib/features/activity/screens/activity_timer_screen.dart`:
  - `_ControlButton` -- StatefulWidget + SingleTickerProviderStateMixin
  - AnimationController(100ms) + ScaleTransition(1.0 -> 0.9)
  - GestureDetector: onTapDown(forward) + onTapUp(reverse + onTap) + onTapCancel(reverse)
  - press 상태에서 배경색 변화: primary 버튼은 85% alpha, secondary는 warmOrange 15% tint
  - primary 버튼에 그림자 on/off (press 시 사라짐)
  - AnimatedContainer(100ms)로 부드러운 색상 전환

**판정: PASS**

### FAIL-8: 카드 타입 차별화 (P1) -- FIXED

**코드 확인 + Marionette 확인:**

| 카드 타입 | 적용 위젯 | radius | 그림자 | 배경 | 특수 요소 |
|---|---|---|---|---|---|
| **히어로** | TodayMissionCard | AppRadius.lg (16) | adaptiveMedium | gradient(cream->paleCream / darkCardElevated->darkCard) | 상단 3px 영역별 색상 스트라이프, 1.5px 다크 보더 |
| **정보** | GrowthSummaryCard, ObservationSummaryCard | AppRadius.md (12) | adaptiveLow | 단색 cardColor | 좌측 4px 색상 바, IntrinsicHeight+Row, cardPaddingCompact(12) |
| **액션** | QuickRecordRow | AppRadius.md (12) | adaptiveSubtle | gradient(white->paleCream / darkCard->darkCardElevated) | 내부 버튼 2개 |

- **Marionette 라이트 모드:** TodayMissionCard가 다른 카드보다 더 큰 radius, 진한 그림자, 그라데이션 배경으로 시각적으로 "히어로" 역할 수행. GrowthSummaryCard의 좌측 softGreen 바가 명확히 보임. QuickRecordRow는 미묘한 gradient로 "액션 영역" 느낌.
- **Marionette 다크 모드:** 히어로 카드의 darkCardElevated gradient가 일반 darkCard 카드보다 밝아 깊이 계층 형성. 정보 카드의 좌측 색상 바가 다크 배경에서도 명확.

**판정: PASS**

### FAIL-4: Hero 애니메이션 (P2, 범위 밖) -- NOT IN SCOPE

이전 리뷰에서 P2(Nice-to-have)로 분류. Generator도 범위 밖으로 표시. 채점에서 불이익 없음.

---

## Design Quality Scoring

### 1. Design Quality -- 8/10 (이전: 7/10, +1)

**개선된 점:**
- **다크 모드 깊이감 대폭 개선:** darkBg(#121010) vs darkCard(#342B23) vs darkCardElevated(#3D3328) 3단계 명도 계층이 확립됨. 카드-배경 구분이 이전 리뷰 시점 대비 크게 명확해짐.
- **다크 모드 그림자:** warmOrange/cream 기반 subtle glow로 다크 모드에서도 카드 간 시각적 깊이 존재. `isDark ? null` 안티패턴 완전 제거.
- **카드 타입별 시각적 위계:** 히어로(강한 그림자, gradient, 큰 radius) > 정보(좌측 바, compact) > 액션(미묘한 gradient) 순서로 시각적 중요도 명확.

**잔여 이슈:**
- warmOrange 과다 사용(CTA, 칩, 악센트바, 아이콘, 네비게이션)은 이전과 동일. secondary/tertiary 역할 불분명.
- 다크 모드에서 warmOrange 테마 색상과 darkBg의 대비가 강해 일부 요소(NavigationBar의 선택 아이콘, Switch의 active track)가 과하게 눈에 띔.

### 2. Originality -- 6/10 (이전: 5/10, +1)

**개선된 점:**
- **CustomPainter 비주얼 에셋:** BellAnimation(bezier curve 벨 형태 + glow + sound wave)과 ConfettiAnimation(55개 파티클, 4종 형태, burst phase)이 앱 고유의 비주얼 아이덴티티 제공. Material Icons 아이콘이 아닌 실제 커스텀 그래픽.
- **Lottie placeholder 완전 제거:** 빈 파일/placeholder에 의존하지 않게 됨.
- **카드 타입 차별화:** 히어로/정보/액션 3종 카드 스타일로 "모든 카드가 동일 패턴" 문제 해결.

**잔여 이슈:**
- 여전히 모든 아이콘이 Material Icons (Icons.home, Icons.edit_note, Icons.child_care 등). 커스텀 SVG/아이콘셋 없음.
- NavigationBar, SwitchListTile, FilterChip 등 Material 3 기본 위젯을 거의 그대로 사용.
- 온보딩 일러스트(실제 이미지)는 여전히 부재. ConfettiAnimation이 대체하지만 감성적 일러스트는 아님.

### 3. Craft -- 7/10 (이전: 7/10, 유지)

**유지된 강점:**
- 4px 그리드 시스템, 48dp 터치 영역, BorderRadius 토큰화, 카드 패딩 일관성 등 이전 강점 모두 유지.
- `AppColors`, `AppDimensions`, `AppRadius`, `AppShadows` 상수 일관 사용.
- `Theme.of(context).textTheme` 일관 사용 (하드코딩 없음).

**잔여 이슈:**
- `observation_form_screen.dart:360`에 `Color(0x1A000000)` 하드코딩 1건 잔존 (이전 리뷰 시점부터 있던 것).
- 마이 화면 "수정 ->" 텍스트의 화살표 기호가 여전히 조잡. 아이콘(Icons.chevron_right)으로 교체하는 것이 바람직.
- 다크 모드 초기 전환 시 hot reload 필요 (테마 변경 후 즉시 반영 안 되는 가능성 -- Riverpod 상태 관리 이슈일 수 있음).

### 4. Functionality -- 7/10 (이전: 7/10, 유지)

**유지된 강점:**
- CTA 하단 고정, 빈 상태 처리, 자동 저장, FilterChip 필터링 등 모두 정상 동작.
- 다크 모드에서도 모든 기능 정상 (스크린샷으로 확인).

**잔여 이슈:**
- TodayMissionCard "시작하기" 버튼 TODO 미구현 (이전과 동일).
- 활동 히스토리 placeholder 화면 (이전과 동일).
- 이 이슈들은 기능 스프린트 범위이므로 Vitality 리뷰에서는 감점하지 않음.

### 5. Vitality -- 9/10 (이전: 5/10, +4)

**대폭 개선:**

| 항목 | 이전 | 현재 | 상세 |
|---|---|---|---|
| 페이지 전환 | X | O | 3종 전환(slide+fade, fade, scale+fade). 모든 GoRoute에 적용. |
| 탭 전환 | X | O | AnimationController 크로스페이드 250ms. IndexedStack 제거. |
| 카운터 ScaleTransition | O | O | 유지 (1.0->1.3->1.0, 200ms) |
| 빠른기록 ScaleTransition | O | O | 유지 (1.0->1.3->1.0, 200ms) |
| 카운터 +/- press state | O | O | 유지 (AnimatedContainer 120ms) |
| 타이머 버튼 press state | X | O | ScaleTransition(1.0->0.9) + 배경색 변화 + 그림자 on/off |
| 레이더 차트 진입 | X | O | 800ms easeOutCubic, 0->100% 데이터 확장 |
| 홈 화면 staggered entrance | X | O | 5개 섹션 FadeIn+SlideUp, 800ms staggered intervals |
| 타이머 완료 텍스트 fade-in | X | O | 300ms delay 후 600ms FadeTransition |
| 커스텀 벨 애니메이션 | X | O | CustomPainter 벨 + wobble + glow + sound waves, 1500ms repeat |
| 커스텀 축하 애니메이션 | X | O | CustomPainter confetti, 55 particles, 4 shapes, burst+drift, 2500ms |
| 다크 모드 그림자 | X | O | 4단계 warm glow 그림자 (subtle/low/medium/high) |
| 카드 그라데이션 배경 | 부분 | O | 히어로/액션 카드에 방향성 gradient 적용, 라이트+다크 모두 |

**잔여 미구현 (P2):**
- Hero 위젯 애니메이션 (리스트->상세 요소 이동) -- P2, 범위 밖
- 커스텀 아이콘/SVG -- 별도 에셋 제작 필요
- 네비게이션 바 커스텀 디자인

---

## Screen-by-Screen Assessment (Dark Mode)

### 1. Home Screen -- Dark Mode
- **Layout:** 5개 섹션 staggered entrance 애니메이션으로 순차 등장. 이전의 정적 렌더링과 크게 다름.
- **Depth:** darkBg(#121010) 위에 BabyProfileCard(darkCard gradient), QuickRecordRow(darkCard->darkCardElevated gradient), TodayMissionCard(darkCardElevated->darkCard gradient)가 명확히 구분됨.
- **Issues:** 없음.

### 2. Activity List -- Dark Mode
- **Depth:** 카드들이 배경과 명확히 분리. 좌측 영역별 색상 바가 다크 배경에서 더 돋보임.
- **Badge:** "오늘의 추천" 배지가 warmOrange로 다크 모드에서도 시인성 우수.

### 3. Activity Detail -- Dark Mode
- **StepGuide:** warmOrange 번호 원형 + 연결선이 다크 배경에서 강렬한 시각적 리듬 형성.
- **CTA:** 하단 고정 "시작하기" 버튼이 warmOrange로 다크 모드에서도 명확.

### 4. Dev Check -- Dark Mode
- **Radar Chart:** 그리드 선이 darkBorder(#4A3D32)로 가시적. 데이터 영역 warmOrange 2px 테두리 + radarFill 채움.
- **Reassurance Card:** mintTint 대신 darkBg 배경 사용으로 다크 모드 적응 완료.

### 5. My Screen -- Dark Mode
- **Profile Card:** warmOrange 상단 그라데이션 바가 다크 배경에서 브랜드 아이덴티티 역할.
- **Settings Cards:** 카드 그룹이 darkBorder로 구분되어 깔끔.

---

## Build/Analyze Results

| # | 검증 | 판정 | 비고 |
|---|---|---|---|
| 1 | flutter analyze | PASS | 0 errors, 0 warnings. 11 info-level notices (pre-existing, 수정 무관) |
| 2 | 하드코딩 Color 검사 | PARTIAL | `observation_form_screen.dart:360`에 1건 잔존. `AppColors`/`AppShadows` 상수 파일 내 Color는 정상. |
| 3 | Lottie 의존성 제거 | PASS | `import 'package:lottie'` 0건, `Lottie.` 호출 0건 |
| 4 | `isDark ? null : AppShadows` 제거 | PASS | 0건. 모두 `AppShadows.adaptive*()` 사용 |
| 5 | Theme.textTheme 사용 | PASS | 하드코딩 TextStyle 없음 |

---

## Score Summary

| Criterion | Previous | Current | Delta | Notes |
|---|---|---|---|---|
| **Design Quality** | 7/10 | 8/10 | +1 | 다크 모드 3단계 깊이 계층 + adaptive shadow 체계 |
| **Originality** | 5/10 | 6/10 | +1 | CustomPainter 비주얼(벨/confetti) + 카드 3종 차별화. 아이콘은 여전히 Material. |
| **Craft** | 7/10 | 7/10 | 0 | 기존 강점 유지. 하드코딩 1건 잔존. |
| **Functionality** | 7/10 | 7/10 | 0 | 기존 강점 유지. 기능 TODO는 별도 스프린트 범위. |
| **Vitality** | 5/10 | 9/10 | +4 | 페이지/탭 전환, 커스텀 비주얼, staggered entrance, 차트 애니메이션, 버튼 피드백 모두 구현. |
| **Total** | **31/50** | **37/50** | **+6** | **Average: 7.4/10 -- PASS** |

---

## Remaining Improvement Opportunities (Future Sprints)

이하 항목은 현재 PASS 판정에 영향 없음. 향후 개선 시 8점 이상 목표.

### P2 (Nice-to-have)
1. **커스텀 아이콘:** Material Icons 대신 앱 전용 아이콘셋/SVG 제작 (+Originality 1점)
2. **Hero 애니메이션:** 활동 카드 -> 상세 전환 시 요소 이동 (+Vitality 0.5점)
3. **네비게이션 바 커스텀:** Material NavigationBar 대신 앱 고유 디자인 (+Originality 0.5점)
4. **빈 상태 감성 일러스트:** Material Icons 대신 커스텀 일러스트 (+Originality 0.5점)
5. **"수정 ->" 텍스트:** Icons.chevron_right 아이콘으로 교체 (+Craft 0.2점)
6. **observation_form_screen.dart:360 하드코딩:** AppShadows.subtle 또는 AppColors 참조로 교체 (+Craft 0.1점)
