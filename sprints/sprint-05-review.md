# Sprint 05 검증 결과

## 판정: PARTIAL

FAIL 항목이 있지만 핵심 기능은 모두 동작하며, 경미한 수정으로 해결 가능한 수준이다.

---

## 검증 상세

### 기능 검증 -- ActivityListScreen (코드 리뷰)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | 활동 탭 진입 시 현재 주차의 활동 5개가 카드 리스트로 표시된다 | PASS | currentActivitiesProvider 연동, ListView.separated 사용 |
| 2 | 각 활동 카드에 활동 유형 칩, 활동명, 권장 시간, 한 줄 설명이 표시된다 | PASS | ActivityCard 위젯에서 모두 표시 확인 |
| 3 | 화면 상단에 안심 메시지 + 서브 메시지가 표시된다 | PASS | AppStrings.activityReassurance / activitySubReassurance 사용 |
| 4 | 오늘 추천 활동 카드에 "오늘의 추천" 배지가 표시된다 | PASS | todayMissionProvider 연동, isTodayMission 분기 확인 |
| 5 | 활동 유형 필터 칩 행이 표시되고 수평 스크롤 가능하다 | PASS | ActivityFilterChips, ListView horizontal |
| 6 | 필터 선택 시 해당 유형 활동만 표시된다 | PASS | filteredActivitiesProvider 로직 정상 |
| 7 | 오늘 완료한 활동 카드에 softGreen 체크 아이콘이 표시된다 | PASS | isCompleted 분기, AppColors.softGreen 사용 |
| 8 | 미완료 활동 카드에는 체크 아이콘이 표시되지 않는다 | PASS | if (isCompleted) 조건부 렌더링 |
| 9 | 활동 카드 탭 시 ActivityDetailScreen으로 이동한다 | PASS | context.push('/activity/${activity.id}') |
| 10 | 앱 바 우측 "히스토리" 버튼 탭 시 히스토리 라우트로 이동한다 | PASS | context.push('/activity/history') |
| 11 | 빈 상태(주차/필터) 메시지가 표시된다 | PASS | EmptyStateCard 사용, 주차/필터 빈 상태 모두 처리 |

### 기능 검증 -- ActivityDetailScreen (코드 리뷰)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | Layer 1 표시: 유형 칩, 주차/순서 라벨, 활동명, 한 줄 설명 | PASS | 모두 구현 확인 |
| 2 | 단계별 가이드 (1~5) warmOrange 원형 28dp + 수직 연결선 | PASS | StepGuide 위젯, 28x28 원형, 2px 연결선 |
| 3 | "더 알아보기" 기본 접힘 상태 | PASS | initiallyExpanded: false |
| 4 | 펼치면 관찰 포인트, 왜 하나요?, 기대 효과, 주의사항, TIP, 교구, 연결 반사 표시 | PASS | _LearnMoreExpansion 위젯에서 모두 구현 |
| 5 | 관찰 포인트가 불릿 포인트 리스트로 표시된다 | PASS | _BulletPoint 위젯 사용 |
| 6 | "전문가가 설계한 활동이에요" 문구 표시 | PASS | AppStrings.expertDesigned |
| 7 | 주의사항 제목 "이런 때는 잠깐 멈춰주세요" | PASS | AppStrings.cautionsTitle |
| 8 | Equipment 카드 표시 | PASS | EquipmentCard 위젯 |
| 9 | 교구 불필요 시 softGreen 텍스트 | PASS | AppColors.softGreen, AppStrings.equipmentNotRequired |
| 10 | 연결 반사 InfoTerm 위젯 | PASS | InfoTerm 위젯 적용, 부모 언어 -> 전문 용어 매핑 |
| 11 | 하단 sticky "시작하기 (N초)" 버튼 | PASS | bottomNavigationBar, SafeArea 사용 |
| 12 | 스크롤 콘텐츠 하단 80dp 여백 | PASS | padding bottom: 80 |

### 기능 검증 -- ActivityTimerScreen (코드 리뷰)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | 원형 프로그레스 타이머 (외경 200dp, 링 두께 8dp) | PASS | SizedBox 200x200, strokeWidth: 8 |
| 2 | 남은 시간 "M:SS" 형식 표시 | PASS | TimerState.formattedTime |
| 3 | 시작 -> 카운트다운 + 프로그레스 감소 | PASS | Timer.periodic, sweepAngle 계산 |
| 4 | 일시정지/재개 가능 | PASS | pause(), start() 구현 |
| 5 | 리셋 -> 권장 시간으로 초기화 | PASS | reset() 구현 |
| 6 | 타이머 중 가이드 문구 순차 전환 | PASS | _getCurrentGuideText() |
| 7 | 5초 이하 "거의 다 됐어요" 텍스트 | PASS | remainingSeconds <= 5 조건 |
| 8 | HapticFeedback.heavyImpact() 진동 | PASS | _handleCompletion에서 호출 |
| 9 | 완료 화면: Lottie + "잘 하셨어요!" + 안심 메시지 | PASS | TimerCompletionView |
| 10 | 안심 메시지 랜덤 선택 | PASS | ReassuranceMessages.getRandomActivityCompleteMessage() |
| 11 | "관찰 기록하기" CTA 버튼 | PASS | go_to_observation_button |
| 12 | "홈으로 돌아가기" 보조 버튼 | PASS | go_home_button |
| 13 | "타이머 없이 완료하기" 보조 버튼 | PASS | complete_without_timer_button |
| 14 | 앱 바 "스킵" 버튼 | PASS | timer_skip_button |
| 15 | ActivityRecord DB 저장 | PASS | saveActivityRecord() 호출 |
| 16 | timerUsed=true, timerDurationSec=실제시간 (타이머 사용 시) | PASS | elapsedSeconds 전달 |
| 17 | timerUsed=false, timerDurationSec=null (타이머 미사용 시) | PASS | timerUsed: false, timerDurationSec 미전달 |
| 18 | 완료 후 돌아오면 softGreen 체크 표시 | PASS | todayCompletedActivityIdsProvider invalidate |

### 기능 검증 -- 통합 (코드 리뷰)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | MainShell 활동 탭(index 2) 탭 시 ActivityListScreen 표시 | PASS | 플레이스홀더 제거, ActivityListScreen 교체 |
| 2 | GoRouter `/activity/:id` 라우트 등록 | PASS | app_router.dart 확인 |
| 3 | GoRouter `/activity/:id/timer` 라우트 등록 | PASS | 중첩 라우트 확인 |
| 4 | 활동 완료 후 todayMissionProvider 업데이트 | PASS | todayCompletedActivityIdsProvider invalidate |

### 기능 검증 (UI 실행 테스트 -- Marionette)

| # | 테스트 시나리오 | 판정 | 비고 |
|---|---|---|---|
| 1 | 활동 탭 이동 (nav_tab_activity 탭) | PASS | 활동 탭으로 정상 전환 |
| 2 | 활동 목록 5개 카드 표시 | PASS | 3개 확인 (스크롤하면 2개 추가), 카드 리스트 표시 |
| 3 | 안심 메시지 "하루 한 가지씩 실천해 보세요!" + "전부 하지 않아도 괜찮아요." | PASS | 화면 상단에 표시 |
| 4 | 필터 칩 표시 (전체/안기/감각/소리/시각) + ValueKey | PASS | 5개 칩 모두 표시, ValueKey 확인 |
| 5 | "오늘의 추천" 배지 표시 (today_mission_badge) | PASS | 첫 번째 카드에 표시 |
| 6 | 활동 카드 탭 -> 상세 화면 이동 | PASS | activity_card_w0_act1 탭 -> ActivityDetailScreen |
| 7 | 상세 화면: 유형 칩 + 주차 라벨 + 활동명 + 설명 | PASS | "안기", "0-1주차 \| 활동 1", "품-숨-멈춤 루틴" |
| 8 | 단계별 가이드 1~5 표시 (step_guide_1~5) | PASS | 5개 스텝 모두 ValueKey 포함 표시 |
| 9 | "더 알아보기" 접힌 상태 (learn_more_expansion) | PASS | ExpansionTile, initiallyExpanded: false |
| 10 | 하단 sticky "시작하기 (30초)" 버튼 | PASS | start_activity_button 확인 |
| 11 | "시작하기" 탭 -> 타이머 화면 이동 | PASS | ActivityTimerScreen 진입 |
| 12 | 원형 타이머 "0:30" 표시 (circular_timer) | PASS | SizedBox 200x200, "0:30" 텍스트 |
| 13 | 타이머 가이드 텍스트 표시 (timer_guide_text) | PASS | "아기를 가슴에 대고 양손으로 감싸주세요" |
| 14 | 타이머 컨트롤 버튼 표시 (start/reset) | PASS | timer_start_button, timer_reset_button |
| 15 | "스킵" 버튼 표시 (timer_skip_button) | PASS | 앱 바 우측 |
| 16 | "타이머 없이 완료하기" 탭 -> 완료 화면 | PASS | 축하 화면 전환 |
| 17 | 완료 화면: "잘 하셨어요!" + 안심 메시지 | PASS | completion_reassurance_message 확인 |
| 18 | 완료 화면: "관찰 기록하기" CTA + "홈으로 돌아가기" 보조 | PASS | go_to_observation_button, go_home_button |
| 19 | "홈으로 돌아가기" 탭 -> 홈 이동 | PASS | 정상 네비게이션 |
| 20 | 활동 탭 복귀 시 완료 활동에 softGreen 체크 표시 | PASS | 첫 번째 카드에 초록 체크 확인 |
| 21 | 필터 "안기" 선택 시 안기 유형만 표시 | PASS | 2개 카드만 표시 (품-숨-멈춤 루틴, 배 위에 얹기) |
| 22 | 미완료 활동에 "미완료" 텍스트 없음 | PASS | 체크 없이 깨끗한 상태 |
| 23 | Lottie 에셋 없을 때 폴백 아이콘 표시 | PASS | celebration 아이콘 폴백 정상 |

### UX 원칙 검증

| 원칙 | 판정 | 비고 |
|---|---|---|
| 하나만 해도 충분 | PASS | "전부 하지 않아도 괜찮아요" 메시지, 관찰 기록 선택적, 홈으로 바로 돌아가기 가능 |
| 숫자보다 말 | PASS | "잘 하셨어요!" 안심 메시지 우선, 완료율/퍼센트 없음 |
| 부모 언어 | PASS | "깜짝 놀라며 팔을 벌리는 반응" 부모 언어, 전문 용어는 InfoTerm 탭 시에만. "이런 때는 잠깐 멈춰주세요" |
| 한 손 30초 | PASS | 활동상세 -> 시작 -> 완료 1탭 플로우. CTA 하단 배치. 터치 영역 48dp+ |
| 죄책감 금지 | PASS | 미완료 표시 없음. 완료만 체크. 진행률 없음 |

### 디자인 검증

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | 활동 카드: white 배경, 12dp 모서리, 16dp 패딩, AppShadows.low | PASS | theme.cardColor, AppRadius.md(12), AppDimensions.cardPadding(16), AppShadows.low |
| 2 | 활동 유형 칩: paleCream 배경, warmOrange 텍스트, 8dp 모서리 | PASS | ActivityTypeChip 재사용 |
| 3 | 활동명 H3 (16sp, SemiBold) | PASS | textTheme.headlineSmall (16sp) |
| 4 | 완료 체크 아이콘: softGreen | PASS | AppColors.softGreen |
| 5 | 원형 타이머: 외경 200dp, 링 8dp, warmOrange/trackGray | PASS | TimerRingPainter 기본값 확인 |
| 6 | 타이머 중앙 시간: TimerDisplay (48sp, Bold) | FAIL | 코드에서 textTheme.displayMedium 사용 (32sp). 사양서 기준 48sp |
| 7 | 단계 가이드: warmOrange 28dp 원형, 2px 연결선, Body1 텍스트 | PASS | StepGuide 위젯 확인 |
| 8 | 하단 고정 버튼: white 배경, AppShadows.high, EdgeInsets(16,12,16,16) | PASS | theme.cardColor, AppShadows.high, AppDimensions 상수 사용 |
| 9 | CTA 버튼: warmOrange 배경, white 텍스트, 52dp, 24dp 모서리 | PASS | theme.colorScheme.primary, height 52, AppRadius.xl(24) |
| 10 | 보조 버튼: 투명 배경, lightBeige 1.5px 테두리, 48dp, 24dp 모서리 | PASS | OutlinedButton, AppColors.lightBeige, width 1.5, AppDimensions.minTouchTarget, AppRadius.xl |
| 11 | 카드 리스트: 수평 16dp, 카드 간격 12dp | PASS | AppDimensions.screenPaddingH, AppDimensions.cardGap |
| 12 | 모든 텍스트 Theme.of(context).textTheme 사용 | PASS | 하드코딩 없음 |
| 13 | AppTextStyles 직접 참조 없음 | PASS | grep 결과 0건 |

### 코드 품질 검증

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | Color 하드코딩 없음 | PASS | Color(0x...) grep 결과 0건 |
| 2 | DateTime.now 대신 nowKST() 사용 | PASS | activity_providers.dart, activity_record_dao.dart에서 nowKST() 사용 |
| 3 | fontSize 하드코딩 없음 | PASS | fontSize grep 결과 0건 |
| 4 | AppTextStyles 직접 사용 없음 | PASS | AppTextStyles grep 결과 0건 |
| 5 | BorderRadius.circular(숫자) 대신 AppRadius 사용 | PASS | BorderRadius.circular(AppRadius.xxx) 형태 |
| 6 | 한국어 문자열 AppStrings 상수 사용 | PARTIAL | 대부분 상수화되었으나 아래 FAIL 항목 참조 |
| 7 | EdgeInsets 패딩 하드코딩 | PARTIAL | 대부분 AppDimensions 사용. 일부 하드코딩 존재 (아래 FAIL 항목 참조) |
| 8 | 빈 상태(empty state) 처리 | PASS | 주차 빈 상태 + 필터 빈 상태 모두 처리 |

### ValueKey 검증

| # | 키 | 판정 | 비고 |
|---|---|---|---|
| 1 | activity_list_screen | PASS | Scaffold key |
| 2 | activity_detail_screen | PASS | Scaffold key |
| 3 | activity_timer_screen | PASS | Scaffold key |
| 4 | activity_card_$activityId | PASS | GestureDetector key |
| 5 | activity_filter_$type | PASS | FilterChip key |
| 6 | today_mission_badge | PASS | Container key |
| 7 | step_guide_$stepNumber | PASS | IntrinsicHeight key |
| 8 | learn_more_expansion | PASS | ExpansionTile key |
| 9 | start_activity_button | PASS | ElevatedButton key |
| 10 | circular_timer | PASS | SizedBox key |
| 11 | timer_start_button | PASS | _ControlButton key |
| 12 | timer_pause_button | PASS | _ControlButton key (조건부 렌더링 시 표시) |
| 13 | timer_reset_button | PASS | _ControlButton key |
| 14 | complete_without_timer_button | PASS | OutlinedButton key |
| 15 | go_to_observation_button | PASS | ElevatedButton key |
| 16 | go_home_button | PASS | OutlinedButton key |
| 17 | activity_history_button | PASS | TextButton key |
| 18 | timer_skip_button | PASS | TextButton key |
| 19 | timer_guide_text | PASS | Text key |
| 20 | timer_almost_done_text | PASS | Text key (5초 이하 조건부) |
| 21 | completion_lottie | PASS | SizedBox key |
| 22 | completion_reassurance_message | PASS | Text key |

### 빌드/분석

| # | 검증 | 판정 | 비고 |
|---|---|---|---|
| 1 | flutter analyze | PASS | error 0건, warning 0건 (info 7건: 기존 코드 포함, 모두 경미한 스타일 이슈) |

---

## FAIL 항목 피드백 (Generator용)

### FAIL-1: 한국어 문자열 하드코딩 -- 필터 칩 타입명

- **위치:** `lib/features/activity/widgets/activity_filter_chips.dart:17-20`
- **기준:** 모든 UI 텍스트는 AppStrings 상수를 참조하며 하드코딩 금지
- **현재 상태:** 필터 칩 타입명 '안기', '감각', '소리', '시각'이 위젯 파일에 직접 하드코딩되어 있다
- **수정 방법:** AppStrings에 상수를 추가하거나, 기존 시드 데이터에서 활동 유형 목록을 동적으로 추출한다

### FAIL-2: 한국어 문자열 하드코딩 -- 반사 매핑 데이터

- **위치:** `lib/features/activity/screens/activity_detail_screen.dart:261-291`
- **기준:** 모든 UI 텍스트는 AppStrings 상수를 참조하며 하드코딩 금지
- **현재 상태:** `_getReflexTermName()`과 `_getReflexDescription()`의 매핑 맵이 화면 파일에 한국어로 직접 하드코딩되어 있다
- **수정 방법:** 별도 상수 파일(예: `lib/data/seed/reflex_data.dart`)로 분리하거나, AppStrings에 상수를 추가한다. 또는 Activity 모델에 전문 용어명/설명 필드를 추가한다

### FAIL-3: 한국어 문자열 하드코딩 -- activityFilterProvider 초기값

- **위치:** `lib/providers/activity_providers.dart:42, 60`
- **기준:** 한국어 문자열 하드코딩 금지
- **현재 상태:** `build() => '전체'`, `if (filter == '전체')` 로 직접 한국어 하드코딩
- **수정 방법:** `AppStrings.activityFilterAll` 상수를 사용한다 (이미 정의되어 있음: `static const activityFilterAll = '전체'`)

### FAIL-4: 타이머 시간 표시 폰트 크기 불일치

- **위치:** `lib/features/activity/screens/activity_timer_screen.dart:170`
- **기준:** 사양서 디자인 검증 -- "타이머 중앙 시간: TimerDisplay (48sp, Bold, darkBrown)"
- **현재 상태:** `textTheme.displayMedium` 사용 (32sp). 사양서 기준 48sp와 불일치
- **Marionette 확인:** 타이머 텍스트 size: 32.0 확인
- **수정 방법:** `textTheme.displayLarge`(48sp)를 사용하거나, displayMedium에 copyWith(fontSize)로 48sp 적용. 단, fontSize 하드코딩 금지 원칙상 테마 레벨에서 조정 필요

### FAIL-5: EdgeInsets 패딩 하드코딩

- **위치:** `lib/features/activity/screens/activity_detail_screen.dart:326` -- `EdgeInsets.only(top: 8, right: 8)`
- **위치:** `lib/features/activity/widgets/activity_card.dart:73-74` -- `horizontal: 8, vertical: 2`
- **기준:** 모든 간격은 AppDimensions 상수를 사용한다
- **수정 방법:**
  - `EdgeInsets.only(top: 8, right: 8)` -> `EdgeInsets.only(top: AppDimensions.sm, right: AppDimensions.sm)`
  - `horizontal: 8, vertical: 2` -> `horizontal: AppDimensions.sm, vertical: AppDimensions.xxs`

---

## FAIL 심각도 분류

| 항목 | 심각도 | 이유 |
|---|---|---|
| FAIL-1 | 경미 | 기능에 영향 없음. 코드 품질 규칙 위반 |
| FAIL-2 | 경미 | 기능에 영향 없음. 한국어 데이터 분리 원칙 위반 |
| FAIL-3 | 경미 | 기능에 영향 없음. 이미 상수가 존재하므로 참조만 변경하면 됨 |
| FAIL-4 | 경미 | 디자인 스펙 불일치. 시각적 차이만 있고 기능 영향 없음 |
| FAIL-5 | 경미 | 기능에 영향 없음. 코드 품질 규칙 위반 |

---

## 재구현 필요 여부

모든 FAIL 항목이 경미한 수준이며 핵심 기능에 영향을 주지 않는다. 5개 항목 모두 단순 상수 참조 변경 또는 데이터 분리 수준의 수정으로 해결 가능하다.

**종합 평가:** 핵심 기능(활동 목록, 상세, 타이머, 완료, DB 저장, 필터, 빈 상태)이 모두 정상 동작하며, UX 원칙 5가지를 잘 준수하고 있다. 디자인 토큰/상수 시스템도 대부분 올바르게 사용되었다. FAIL 항목은 한국어 하드코딩과 폰트 크기 불일치로, 경미한 수정만 필요하다.
