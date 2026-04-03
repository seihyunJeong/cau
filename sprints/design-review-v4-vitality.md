# Design Review v4 -- Vitality

**App:** "하루 한 가지" (영유아 발달 관찰 앱)
**Date:** 2026-03-27
**Reviewer:** QA Verification Agent (Claude Opus 4.6)
**Method:** Code review (Read/Grep) + Marionette MCP live UI inspection (dark mode)

---

## Overall Verdict: PARTIAL PASS -- Average 6.4/10

총점 32/50. 평균 6.4점으로 7점 미만이므로 **FAIL** 판정.
특히 Vitality(생동감)과 Originality(독창성) 항목에서 심각한 부족이 확인됨.

---

## 1. Design Quality -- 7/10

### 잘 된 점
- **일관된 컬러 시스템:** `AppColors` 상수를 체계적으로 정의하고, 거의 모든 위젯에서 하드코딩 없이 참조. 1건의 예외만 발견 (`observation_form_screen.dart:360` -- `Color(0x1A000000)` 그림자).
- **따뜻한 톤 팔레트:** cream(#FFF8F0), warmOrange(#F5A623), softGreen(#7BC67E) 등 파스텔 계열로 부모 앱에 맞는 안심감 전달.
- **다크 모드 지원:** darkBg(#1A1512), darkCard(#2A231D) 등 야간 수유 시 눈부심 방지 고려. 라이트/다크 모두 ThemeData 분리.
- **6개 발달 영역 컬러 분화:** domainHolding(로즈핑크), domainSensory(그린), domainSound(스카이블루), domainVision(라벤더), domainTouch(오렌지), domainBalance(골드) -- 영역별 시각적 구분 우수.
- **타이포그래피 체계:** Pretendard 기반 12단계 텍스트 스케일, 조부모 모드(+4sp) 지원.

### 문제점
- **다크 모드 단조로움:** 스크린샷 확인 결과, 다크 모드에서 darkBg와 darkCard의 차이가 미미하여 카드 경계가 불명확. 카드 내부와 배경의 대비가 약해 요소 구분이 어려움.
- **컬러 계층 부족:** warmOrange가 CTA, 칩, 악센트바, 섹션 헤더 아이콘, 네비게이션 등 거의 모든 곳에 사용되어 시각적 피로감 유발. secondary/tertiary 컬러 역할이 불분명.
- **그림자 시스템 활용도 낮음:** AppShadows에 4단계(subtle/low/medium/high) 정의했지만, 실제 다크 모드에서는 그림자가 모두 비활성화(`isDark ? null : AppShadows.xxx`). 카드 간 깊이감이 전무.

---

## 2. Originality -- 5/10

### 잘 된 점
- **앱 컨셉 고유성:** "하루 한 가지"라는 미니멀 육아 앱 컨셉은 차별화됨.
- **영역별 악센트바:** 카드 좌측에 4px 영역별 색상 바를 배치하는 패턴은 정보 구분에 효과적.
- **StepGuide 타임라인:** warmOrange 번호 원형 + 수직 연결선 디자인은 앱 정체성을 부여.

### 문제점
- **Material 기본 위젯 의존:** NavigationBar, SwitchListTile, FilterChip, ElevatedButton, ExpansionTile 등 Material 3 기본 위젯을 거의 그대로 사용. 커스텀 스타일링은 색상/모서리 변경 수준에 그침.
- **아이콘 전부 Material Icons:** `Icons.home`, `Icons.edit_note`, `Icons.star_outline`, `Icons.child_care` 등 모든 아이콘이 Material Icons. 커스텀 아이콘/SVG/일러스트 전무.
- **카드 레이아웃 단조:** 모든 카드가 `Container + BoxDecoration + BorderRadius.circular(12)` 동일 패턴. 홈 화면의 BabyProfileCard, QuickRecordRow, GrowthSummaryCard, ObservationSummaryCard가 모두 같은 모서리/패딩/구조.
- **네비게이션 바 기본형:** NavigationBar에 `indicatorColor: warmOrange.withAlpha(0.1)` 정도만 커스터마이징. 완전히 Material 3 기본 형태.
- **온보딩 일러스트 placeholder:** `onboarding_illustration.png`가 70바이트(빈 파일), Lottie 파일들도 단순 원형 애니메이션 placeholder(575, 734바이트).

---

## 3. Craft -- 7/10

### 잘 된 점
- **4px 그리드 시스템:** `AppDimensions`에서 xxs(2), xs(4), sm(8), md(12), base(16), lg(24), xl(32) 일관된 간격 체계.
- **터치 영역 준수:** `minTouchTarget = 48` 상수 정의, CounterCard/QuickRecordButton 등에서 실제 적용 확인.
- **카드 패딩 일관성:** cardPadding(16), cardPaddingCompact(12) 두 단계로 상황별 적용.
- **Border radius 토큰화:** `AppRadius.xs(4), sm(8), md(12), lg(16), xl(24)` 일관된 모서리.
- **다크 모드 보더:** 다크 모드에서 `Border.all(color: AppColors.darkBorder, width: 1)` 일관 적용.

### 문제점
- **카운터 카드 간격 불균형:** 스크린샷 확인 시, 수유/배변 카운터 카드에서 이모지 영역(48x48)과 "-" 버튼 사이 간격, 숫자("0회")와 "+" 버튼 사이 간격이 다소 넓어 시각적 무게중심이 불안정.
- **레이더 차트 데이터 없을 때:** dev_check 화면 스크린샷에서 레이더 차트가 데이터가 매우 낮은 상태(점 수준)로 표시됨. 빈 데이터일 때 차트 영역이 과도하게 넓은 빈 공간 차지.
- **스크롤 하단 여백:** 홈 화면 하단이 `SizedBox(height: AppDimensions.lg)` (24dp)로 끝나는데, 이 여백이 NavigationBar 바로 위까지만 이어져 콘텐츠가 NavBar에 밀착되는 느낌.
- **"수정 ->" 버튼 텍스트:** 마이 화면 프로필 카드의 "수정 ->" 텍스트가 화살표 기호를 사용하여 약간 조잡한 인상.

---

## 4. Functionality -- 7/10

### 잘 된 점
- **CTA 가시성 우수:** 활동 상세 화면의 "시작하기 (30초)" 버튼이 하단 고정(bottomNavigationBar)으로 배치. 높이 52dp, warmOrange 배경, 흰색 텍스트로 명확.
- **빠른 기록 원탭:** 홈 화면 QuickRecordRow의 수유/배변 +1 버튼이 즉시 DB 저장 + 토스트 + 햅틱 피드백.
- **빈 상태 처리:** GrowthSummaryCard, ObservationSummaryCard, ActivityListScreen 모두 빈 상태 UI 구현. 아이콘 + 메시지 조합.
- **자동 저장:** 카운터 변경, 수면 시간 선택, 메모 입력 시 자동 저장 + InlineSaveIndicator 표시.
- **FilterChip 기반 활동 필터:** 영역별 필터 칩이 수평 스크롤 가능하고, 선택 시 영역별 색상 적용.
- **정보 밀도 적절:** 홈 화면이 5개 섹션(프로필/빠른기록/오늘활동/성장요약/관찰요약)을 스크롤로 배치하여 한눈에 파악 가능.

### 문제점
- **오늘의 활동 카드 "시작하기" 미연결:** 홈 화면 TodayMissionCard의 "시작하기" 버튼에 `// TODO: 활동 상세 화면 네비게이션 (Sprint 05+)` 주석. 실제로 탭해도 아무 동작 없음.
- **활동 히스토리 placeholder:** `/activity/history` 경로가 빈 플레이스홀더 화면.
- **날짜 변경 시 UX:** RecordMainScreen의 DateSwipeHeader에서 날짜 탐색은 가능하지만, 특정 날짜 점프(달력 팝업 등)가 보이지 않음.

---

## 5. Vitality (생동감) -- 5/10

### 코드 리뷰 결과

#### 마이크로 인터랙션 (부분 구현)
| 항목 | 상태 | 상세 |
|---|---|---|
| 카운터 탭 ScaleTransition | O | `counter_card.dart` -- AnimationController + TweenSequence(1.0->1.2->1.0, 150ms) |
| 빠른기록 ScaleTransition | O | `quick_record_row.dart` -- TweenSequence(1.0->1.3->1.0, 200ms) |
| 카운터 +/- 버튼 press state | O | `_CounterButton` -- GestureDetector + AnimatedContainer(120ms)로 배경/테두리/아이콘색 변화 |
| 성장 확장 타일 | O | `growth_expansion_tile.dart` -- AnimatedContainer + AnimatedCrossFade |
| 저장 표시 AnimatedOpacity | O | `inline_save_indicator.dart` -- AnimatedOpacity(500ms) |
| 햅틱 피드백 | O | HapticFeedback.lightImpact() 수유/배변/설정 토글 등 |

#### 그라데이션/깊이감 (최소한)
| 항목 | 상태 | 상세 |
|---|---|---|
| TodayMissionCard 상단 스트라이프 그라데이션 | O | LinearGradient(accentColor -> 30% alpha) |
| MyProfileCard 상단 바 그라데이션 | O | LinearGradient(warmOrange -> 50% alpha) |
| 다크 모드 깊이감 | X | 카드 elevation 0, 그림자 비활성, darkBg-darkCard 차이 미미 |
| 라이트 모드 그림자 | 부분 | AppShadows.low/medium 적용하지만 매우 약한 강도(alpha 0x08~0x1A) |

#### 일러스트/커스텀 비주얼 (심각한 부족)
| 항목 | 상태 | 상세 |
|---|---|---|
| Lottie 애니메이션 | placeholder | `celebration.json`(575B) -- 단순 원형 스케일 애니메이션, `notification_bell.json`(734B) -- 유사 |
| 온보딩 일러스트 | placeholder | `onboarding_illustration.png`(70B) -- 빈 파일 |
| CustomPainter | O | TimerRingPainter(타이머 링), RadarChartPainter(레이더 차트) -- 2개만 |
| 커스텀 아이콘/SVG | X | 전체 앱이 Material Icons만 사용 |
| 이모지 활용 | O | 카운터 카드에 젖병/기저귀 이모지, 수면에 zzz 이모지 |

#### 레이아웃 리듬감 (부분)
| 항목 | 상태 | 상세 |
|---|---|---|
| 히어로 카드 차별화 | O | TodayMissionCard -- 상단 그라데이션 + CTA 버튼 포함, 다른 카드보다 크고 눈에 띔 |
| 카드 크기 변화 | 미약 | BabyProfileCard(컴팩트), QuickRecordRow(컴팩트), TodayMissionCard(히어로) 정도만 구분 |
| 섹션 강약 | 부분 | sectionGap(32) + headlineMedium 섹션 헤더로 리듬 형성, 그러나 카드 사이 cardGap(12)이 일률적 |
| 악센트 바 리듬 | O | 수유 카드(warmOrange) vs 배변 카드(softGreen) 좌측 악센트바 색상 차이로 시각적 리듬 |

#### 화면 전환 (미구현)
| 항목 | 상태 | 상세 |
|---|---|---|
| 페이지 전환 애니메이션 | X | GoRouter에 `pageBuilder`, `CustomTransitionPage` 등 전혀 없음. 기본 MaterialPage 전환만 사용 |
| Hero 애니메이션 | X | `Hero` 위젯 사용 0건 |
| 탭 전환 애니메이션 | X | IndexedStack 기반이라 탭 전환 시 애니메이션 없음(즉시 전환) |

### Marionette 실행 검증 소견
- **수유 +1 탭 시:** 카운터 숫자에 ScaleTransition 적용 확인 (코드상 1.3배 확대 후 복귀). 그러나 200ms로 매우 짧아 육안 인식이 어려울 수 있음.
- **카운터 +/- 버튼:** press 상태에서 배경이 warmOrange로 채워지고, release 시 복귀하는 AnimatedContainer 확인.
- **타이머 화면:** CustomPaint 기반 TimerRingPainter가 원형 프로그레스를 그리지만, 실시간 애니메이션(tick 기반 리페인트)은 확인 필요.
- **탭 전환:** 홈->기록->활동->발달->마이 전환 시 트랜지션 없이 즉시 전환. IndexedStack 특성상 페이드/슬라이드 없음.
- **활동 카드 -> 상세 전환:** 기본 MaterialPageRoute push로 우에서 좌 슬라이드. 커스텀 전환 없음.

---

## Screen-by-Screen Assessment

### 1. Home Screen (홈)
- **Layout:** 5개 섹션 수직 배치, 스크롤 가능. 섹션 헤더(h2) + 카드 조합 반복.
- **Good:** 오늘의 활동 카드가 히어로 사이즈로 돋보임. 빠른 기록 영역 compact.
- **Issue:** 성장 요약/관찰 요약이 빈 상태일 때 비슷한 placeholder 아이콘(tinted circle 안 Material Icon)이 반복되어 단조.

### 2. Record Screen (기록)
- **Layout:** 날짜 헤더 + 카운터 2개 + 수면 + 성장 확장 + 메모 + 반 너비 버튼.
- **Good:** 수유(warmOrange 악센트) vs 배변(softGreen 악센트) 카드 구분. 이모지 아이콘 활용.
- **Issue:** 다크 모드에서 카드 배경과 전체 배경 구분 약함. 카드 간 구분이 보더 라인 1px에만 의존.

### 3. Activity Screen (활동)
- **Layout:** 안심 메시지 + 필터 칩 행 + 카드 리스트.
- **Good:** 6개 영역별 필터 칩 색상 구분. 카드에 "오늘의 추천" 배지. 영역별 악센트바.
- **Issue:** 카드 구조가 모두 동일(악센트바 + 칩 + 제목 + 시간 + 설명 + chevron). 시각적 변화 없음.

### 4. Activity Detail Screen (활동 상세)
- **Layout:** 칩 + 제목 + 설명 + StepGuide 타임라인 + "더 알아보기" 확장 + 하단 CTA.
- **Good:** StepGuide 타임라인 디자인(warmOrange 원형 + 연결선)이 앱 고유 느낌. CTA 하단 고정 우수.
- **Issue:** "더 알아보기" ExpansionTile 펼침 시 애니메이션이 Material 기본 높이 변환만 사용.

### 5. Timer Screen (타이머)
- **Layout:** 중앙 원형 타이머(200dp) + 가이드 텍스트 + 컨트롤 버튼 + 보조 버튼.
- **Good:** CustomPaint 기반 TimerRingPainter, trackGray 트랙 위에 warmOrange 프로그레스. 깔끔한 레이아웃.
- **Issue:** 원형 버튼들(play/reset)에 press 상태 피드백 없음(GestureDetector만 사용). Lottie 완료 애니메이션이 placeholder.

### 6. Dev Check Screen (발달)
- **Layout:** 위험 신호 배너 + 안심 메시지 카드 + 레이더 차트 + 솔루션 메시지 + 버튼.
- **Good:** RadarChartCard CustomPainter로 6축 차트 렌더링. 안심 메시지 카드에 softGreen 체크 아이콘.
- **Issue:** 레이더 차트에 진입/표시 애니메이션 없음(즉시 그려짐). 데이터가 낮을 때 차트가 거의 점으로 표시.

### 7. My Screen (마이)
- **Layout:** 프로필 카드 + 아기 추가 + 알림 설정 + 화면 설정 + 데이터 + 정보 + 버전.
- **Good:** 섹션별 warmOrange 아이콘 + 카드 그룹핑. 프로필 카드에 warmOrange 링 + 그라데이션 상단바.
- **Issue:** SwitchListTile / ListTile 기본 위젯 직접 사용. iOS 네이티브 설정 화면 느낌이 강함.

---

## FAIL Items & Improvement Feedback

### FAIL-1: 페이지 전환 애니메이션 전무 (Vitality Critical)
- **위치:** `lib/core/router/app_router.dart`
- **현재:** 모든 GoRoute에 `builder:` 사용. `pageBuilder:` + `CustomTransitionPage` 없음.
- **영향:** 화면 전환 시 딱딱한 기본 MaterialPageRoute만 사용. 앱의 생동감 대폭 저하.
- **수정:** 최소한 주요 전환(활동 카드 -> 상세, 상세 -> 타이머, 체크리스트 -> 결과)에 `FadeTransition` + `SlideTransition` 조합 적용. 탭 전환에도 `AnimatedSwitcher` 또는 `PageView` 고려.

### FAIL-2: 커스텀 비주얼 에셋 전무 (Originality Critical)
- **위치:** `assets/` 폴더
- **현재:** `onboarding_illustration.png`(70B 빈 파일), Lottie 2개(각각 575B, 734B -- 단순 원형 placeholder)
- **영향:** 앱 전체가 Material Icons + 이모지에만 의존. 고유 브랜드 이미지 부재.
- **수정:** (1) 온보딩 일러스트 실제 이미지 제작, (2) Lottie 애니메이션 실제 에셋으로 교체(celebration에 confetti/sparkle, notification_bell에 실제 벨 흔들림), (3) 앱 로고/마스코트 아이콘 커스텀 SVG 추가, (4) 빈 상태 일러스트 전용 SVG/PNG 제작.

### FAIL-3: 다크 모드 깊이감 부재 (Design Quality)
- **위치:** `lib/core/theme/app_theme.dart`, 각 위젯의 `isDark ? null : AppShadows.xxx` 패턴
- **현재:** 다크 모드에서 모든 그림자 비활성. darkBg(#1A1512)와 darkCard(#2A231D)의 명도 차이가 불과 12%. 카드 간 구분이 1px 보더에만 의존.
- **수정:** (1) 다크 모드 전용 그림자 추가(밝은 색상 기반 glow 또는 더 진한 overlay), (2) darkBg-darkCard 간 명도 차이 확대(현재 ~5% -> 최소 10~15%), (3) 카드 보더 두께를 1.5px로 증가하거나 alpha 값 조정.

### FAIL-4: Hero 애니메이션 미사용 (Vitality)
- **현재:** `Hero` 위젯 사용 0건.
- **수정:** 활동 카드의 아이콘/제목을 Hero 위젯으로 감싸서, 리스트 -> 상세 전환 시 자연스러운 요소 이동 구현. 프로필 아바타 홈 -> 마이 전환에도 활용 가능.

### FAIL-5: 탭 전환 애니메이션 없음 (Vitality)
- **위치:** `lib/features/main_shell/main_shell.dart:59`
- **현재:** `IndexedStack(index: _currentIndex)` -- 즉시 전환.
- **수정:** (1) `AnimatedSwitcher` 또는 `PageView`로 탭 전환 시 fade/slide 트랜지션 추가, (2) 또는 IndexedStack 유지하되 각 탭에 `AnimatedOpacity` 래핑.

### FAIL-6: 레이더 차트 진입 애니메이션 없음 (Vitality)
- **위치:** `lib/features/dev_check/widgets/radar_chart_card.dart`
- **현재:** CustomPainter가 즉시 최종 상태로 그려짐.
- **수정:** AnimationController로 0% -> 100% 까지 점진적으로 데이터 포인트를 확장하는 진입 애니메이션 추가(500ms~800ms, Curves.easeOutCubic).

### FAIL-7: 타이머 컨트롤 버튼 피드백 없음 (Vitality)
- **위치:** `lib/features/activity/screens/activity_timer_screen.dart` -- `_ControlButton`
- **현재:** `GestureDetector(onTap: ...)` + 정적 Container. press 시 시각적 변화 없음.
- **수정:** `_CounterButton`처럼 press 상태에서 배경색 변화 + 약간의 scale 애니메이션 추가.

### FAIL-8: 카드 레이아웃 단조로움 (Originality)
- **영향 화면:** 홈, 기록, 활동 탭 모두
- **현재:** 거의 모든 카드가 `Container(decoration: BoxDecoration(borderRadius: 12, color: cardColor))` 동일 패턴.
- **수정:** (1) 카드 타입별 차별화(히어로 카드에 더 큰 radius/그림자, 정보 카드에 좌측 색상 바, 액션 카드에 그라데이션 배경), (2) 카드 크기에 변화를 주어 시각적 리듬 강화, (3) 일부 카드에 배경 패턴/텍스처 적용.

---

## Score Summary

| Criterion | Score | Weight | Notes |
|---|---|---|---|
| **Design Quality** | 7/10 | 20% | 컬러 체계 우수, 다크 모드 깊이감 부족 |
| **Originality** | 5/10 | 20% | Material 기본 위젯 의존, 커스텀 비주얼 전무 |
| **Craft** | 7/10 | 20% | 간격/정렬 체계 우수, 세부 요소 간 불균형 일부 |
| **Functionality** | 7/10 | 20% | CTA/빈 상태/자동저장 우수, 일부 TODO 미구현 |
| **Vitality** | 5/10 | 20% | 카운터 애니메이션 일부만 구현, 전환/차트/비주얼 에셋 전무 |
| **Total** | **31/50** | | **Average: 6.2/10 -- FAIL** |

---

## Priority Improvement Roadmap

### P0 (Critical -- 평균 7점 달성에 필수)
1. **커스텀 비주얼 에셋 교체:** Lottie/PNG placeholder를 실제 에셋으로 교체 (+Originality 1~2점)
2. **페이지 전환 애니메이션:** GoRouter pageBuilder + CustomTransitionPage 적용 (+Vitality 1점)
3. **다크 모드 깊이감 개선:** 카드-배경 명도 차이 확대 + 보더/그림자 강화 (+Design Quality 0.5점)

### P1 (Important -- 7점 이상 목표)
4. **레이더 차트 진입 애니메이션:** 데이터 확장 트랜지션 (+Vitality 0.5점)
5. **탭 전환 애니메이션:** AnimatedSwitcher/fade 적용 (+Vitality 0.5점)
6. **카드 타입별 차별화:** 히어로/정보/액션 카드 스타일 분리 (+Originality 0.5점)

### P2 (Nice-to-have)
7. Hero 애니메이션 (활동 카드 -> 상세)
8. 타이머 컨트롤 버튼 press 피드백
9. 빈 상태 전용 커스텀 일러스트
10. 네비게이션 바 커스텀 디자인
