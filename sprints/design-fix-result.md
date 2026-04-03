# Design Fix Result

**수정일:** 2026-03-27
**기준 문서:** `sprints/design-review.md` (FAIL 판정 6.5/7.0)

---

## 수정된 파일 목록

### 테마/디자인 토큰 (1개)
- `lib/core/theme/app_theme.dart` -- 다크 모드 CardTheme에 border 추가

### 공통 위젯 (2개)
- `lib/core/widgets/reassurance_card.dart` -- [P0] 다크 모드 텍스트 대비 치명적 결함 수정
- `lib/core/widgets/empty_state_card.dart` -- 풍부한 빈 상태 디자인 (아이콘 배경 원, 서브 메시지)

### 상수 (1개)
- `lib/core/constants/app_strings.dart` -- `sleepPlaceholderDetailed`, `emptyGrowthSub` 추가

### 홈 화면 (5개)
- `lib/features/home/widgets/baby_profile_card.dart` -- 다크 모드 border 추가
- `lib/features/home/widgets/quick_record_row.dart` -- 다크 모드 border 추가
- `lib/features/home/widgets/today_mission_card.dart` -- 다크 모드 border + "시작하기" 버튼 시각적 피드백 강화 (elevation, shadow, play icon)
- `lib/features/home/widgets/growth_summary_card.dart` -- 빈 상태 풍부화 + 다크 모드 border
- `lib/features/home/widgets/observation_summary_card.dart` -- 빈 상태 풍부화 + 다크 모드 border + 미니 레이더 차트 레이블 잘림 수정

### 기록 탭 (4개)
- `lib/features/record/widgets/counter_card.dart` -- [P1] -/+ 버튼 스타일 완전 통일 (동일 배경, 동일 border, 비활성만 opacity 구분) + 다크 모드 border
- `lib/features/record/widgets/growth_expansion_tile.dart` -- [P0] 다크 모드에서 헤더 텍스트 안 보이는 문제 수정 + 다크 모드용 배경/border + 입력 필드 border 다크 모드 대응
- `lib/features/record/widgets/sleep_input_card.dart` -- 수면 입력 힌트 개선 ("예: 14시간 30분") + 시계 아이콘 추가 + 다크 모드 대응
- `lib/features/record/widgets/memo_input_card.dart` -- 다크 모드 border + 힌트 텍스트 색상 다크 모드 대응

### 발달 체크 탭 (4개)
- `lib/features/dev_check/widgets/radar_chart_card.dart` -- [P0] 레이더 차트 레이블 잘림 수정 (컨테이너 260dp로 확대, 레이블 영역 80px 확보, 폰트 10sp, overflow visible)
- `lib/features/dev_check/widgets/result_message_card.dart` -- 다크 모드 border 추가
- `lib/features/dev_check/widgets/week_info_card.dart` -- 다크 모드 border 추가
- `lib/features/dev_check/screens/dev_check_main_screen.dart` -- 키 포인트 카드 다크 모드 border 추가 (별도 위젯 분리)

### 마이 탭 (2개)
- `lib/features/my/screens/my_screen.dart` -- [P1] 전면 재설계: 카드 그룹핑, 아이콘 추가, warmOrange 섹션 헤더, 구분선 추가
- `lib/features/my/widgets/my_profile_card.dart` -- [P1] 프로필 카드 강화: 큰 아바타, warmOrange 상단 악센트 바, 수정 버튼 스타일링

---

## 이슈별 수정 상세

### P0 치명적 이슈

#### 1. 다크 모드 밝은 배경 카드 텍스트 가독성
**문제:** 안심 메시지 카드(mintTint 배경)에서 다크 모드 onSurface 텍스트가 거의 안 보임.
**수정:** `ReassuranceCard`에서 다크 모드일 때:
- 배경을 `darkCard`(#2A231D)로 변경
- 텍스트를 `darkTextPrimary`(#F5EDE3)로 변경
- softGreen border(0.3 alpha)로 안심 느낌 유지

#### 2. 레이더 차트 축 레이블 잘림 ("마음과 관계" -> "1음과 관계")
**문제:** SizedBox width 60px에 maxLines: 1, overflow: ellipsis 설정으로 한글 5자가 잘림.
**수정:**
- 차트 컨테이너: 200dp -> 260dp로 확대
- 차트 polygon radius: `size/2 - 30` -> `size/2 - 50`으로 내부 여유 확보
- 레이블 SizedBox: 60px -> 80px로 확대
- 레이블 폰트: 11sp -> 10sp로 축소
- overflow: `TextOverflow.ellipsis` -> `TextOverflow.visible`로 변경 (잘림 방지)
- 미니 차트(홈)도 동일 패턴 적용: 160dp -> 200dp, radius 여유 확대

#### 3. 성장 기록 추가하기 텍스트 다크 모드 미표시
**문제:** paleCream(#FFF3E8) 배경에 라이트 모드 전용 텍스트 색상 적용.
**수정:** 다크 모드에서는 배경을 `cardColor`(darkCard)로, 헤더 텍스트를 `darkTextPrimary`로 오버라이드.

### P1 중요 이슈

#### 4. 카드/배경 명도 차이 부족
**문제:** 다크 모드에서 darkBg(#1A1512)와 darkCard(#2A231D) 명도차 5-6%로 시각적 구분 안 됨.
**수정:**
- `darkTheme()` CardTheme에 `BorderSide(color: darkBorder)` 1px 추가
- 모든 직접 Container 카드에도 동일 border 조건부 추가 (다크 모드만)
- 총 16개 카드 위젯에 일관 적용

#### 5. 카운터 -/+ 버튼 스타일 불일치
**문제:** -버튼이 어두운 회색, +버튼이 밝은 흰색으로 비대칭. -버튼이 비활성으로 오인.
**수정:** 통일된 스타일 적용:
- 기본 상태: warmOrange 10% 배경 + warmOrange 40% border + warmOrange 아이콘
- 눌림 상태: solid warmOrange 배경 + white 아이콘
- 비활성 상태(count=0): muted 30% 배경 + muted border + muted 아이콘
- AnimatedContainer로 상태 전환 애니메이션 추가

#### 6. 마이 탭 디자인 차별화
**문제:** 단순 SwitchListTile 나열로 시스템 설정 앱 느낌.
**수정:**
- **카드 그룹핑:** 각 설정 섹션(알림/화면/데이터/정보)을 rounded card로 감쌈
- **아이콘 추가:** 모든 설정 항목에 leading 아이콘 추가 (wb_sunny, edit_note, auto_awesome, celebration, dark_mode, text_increase, volume_off, picture_as_pdf, cloud_upload, smartphone, description, shield, menu_book)
- **섹션 헤더 강화:** warmOrange 아이콘 + 텍스트 헤더
- **구분선 추가:** 카드 내 항목 사이에 Divider 추가 (indent 적용)
- **프로필 카드 강화:** 큰 아바타(28dp radius) + warmOrange gradient 상단 바 + 수정 버튼 배경 강화
- **"+ 아기 추가하기" 버튼:** warmOrange 테두리와 아이콘으로 브랜드 통일

### P2 보통 이슈

#### 7. 빈 상태 디자인 강화
**문제:** 작은 아이콘 + 텍스트만으로 빈약.
**수정:**
- `EmptyStateCard`: 아이콘을 warmOrange 8% 배경 원형 안에 배치 (56dp 아이콘 + 80dp 원)
- 선택적 subMessage 파라미터 추가
- 성장 요약 빈 상태: 서브 메시지 "기록 탭에서 체중, 키를 입력해보세요" 추가
- 관찰 요약 빈 상태: 동일 패턴 적용 (warmOrange tinted icon circle)
- 전체적으로 "의도적으로 비운 것"이 명확한 디자인

#### 8. 수면 입력 힌트 개선
**문제:** "탭해서 입력"만으로 무엇을 입력할지 모호.
**수정:**
- 힌트 텍스트: "탭해서 시간 선택 (예: 14시간 30분)"
- 시계 아이콘(access_time_rounded) 추가
- 드롭다운 화살표(keyboard_arrow_down) 추가로 피커 존재 암시

#### 9. "시작하기" 버튼 시각적 피드백 강화
**문제:** 탭해도 시각적 반응 없는 느낌.
**수정:**
- elevation: 2 + warmOrange 40% shadow 추가
- play_arrow_rounded 아이콘 추가 (ElevatedButton.icon)

---

## 사양서 기준 자체 점검

### P0 시급 이슈
- [x] 안심 메시지 카드 텍스트 가독성 (다크 모드) -- darkCard 배경 + darkTextPrimary 텍스트
- [x] 레이더 차트 축 레이블 잘림 -- 컨테이너 확대 + 레이블 영역 확대 + overflow visible

### P1 중요 이슈
- [x] 카드/배경 명도 차이 부족 -- CardTheme border + 개별 카드 border 추가 (16개)
- [x] 카운터 -/+ 버튼 스타일 불일치 -- 통일된 warmOrange 기반 스타일
- [x] 마이 탭 디자인 차별화 -- 카드 그룹 + 아이콘 + 구분선 + 브랜드 컬러

### P2 보통 이슈
- [x] 빈 상태 디자인 강화 -- tinted icon circle + sub message
- [x] 수면 입력 힌트 개선 -- 구체적 예시 + 아이콘
- [x] "시작하기" 버튼 피드백 강화 -- elevation + shadow + icon

### 미수정 사항
- [ ] 프로필 아바타 커스텀 일러스트 -- 에셋 제작 필요 (코드 범위 밖)
- [ ] 카드에 시각적 요소(일러스트) 추가 -- 에셋 제작 필요 (코드 범위 밖)
- [ ] 다크 모드 토글 기능 비작동 -- 별도 기능 버그 조사 필요
- [ ] "시작하기" 버튼 네비게이션 미구현 -- 라우팅 로직은 이 PR 범위 밖

---

## 빌드 검증

```
flutter analyze: 11 issues found (all info-level, no errors, no warnings)
변경으로 인한 새로운 warning/error: 0건
```
