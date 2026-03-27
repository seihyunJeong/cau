# Sprint 05 구현 결과

## 생성된 파일

### 신규 생성 (15개)

| 경로 | 설명 |
|---|---|
| `lib/data/models/activity_step.dart` | ActivityStep 모델 (stepNumber, instruction, timerGuideText, illustrationAsset) |
| `lib/data/models/equipment.dart` | Equipment 모델 (isRequired, itemName, description, diyAlternative, purchaseNote) |
| `lib/data/models/activity_record.dart` | ActivityRecord 모델 (babyId, activityId, weekNumber, completedAt, timerDurationSec, timerUsed) |
| `lib/data/models/timer_state.dart` | TimerState 모델 (totalSeconds, remainingSeconds, isRunning, isCompleted, formattedTime, progress) |
| `lib/data/database/daos/activity_record_dao.dart` | ActivityRecordDao (insert, getTodayCompletedActivityIds, getAllByBabyId) |
| `lib/data/seed/reassurance_messages.dart` | ReassuranceMessages 안심 메시지 상수 클래스 (activityCompleteMessages 등) |
| `lib/data/seed/reflex_data.dart` | ReflexData 연결 반사 매핑 데이터 (부모 언어 -> 전문 용어명/설명) |
| `lib/features/activity/screens/activity_list_screen.dart` | 활동 탭 메인 화면 (카드 리스트, 필터 칩, 안심 메시지, 빈 상태) |
| `lib/features/activity/screens/activity_detail_screen.dart` | 활동 상세 화면 (Layer 1 하기 모드, Layer 2 더 알아보기, sticky 하단 버튼) |
| `lib/features/activity/screens/activity_timer_screen.dart` | 활동 타이머 화면 (원형 타이머, 가이드 텍스트, 완료 화면, DB 저장) |
| `lib/features/activity/widgets/activity_card.dart` | 활동 카드 위젯 (2-2-3 스펙 준수) |
| `lib/features/activity/widgets/step_guide.dart` | 단계별 가이드 위젯 (2-6-7 스펙: warmOrange 원형 28dp, 수직 연결선) |
| `lib/features/activity/widgets/timer_ring_painter.dart` | 원형 타이머 CustomPainter (2-5-5 스펙: 200dp, 8dp 링) |
| `lib/features/activity/widgets/equipment_card.dart` | 교구/준비물 카드 (2-2-10 스펙) |
| `lib/features/activity/widgets/activity_filter_chips.dart` | 활동 유형 필터 칩 행 (수평 스크롤 FilterChip) |
| `lib/features/activity/widgets/timer_completion_view.dart` | 타이머 완료 축하 화면 (Lottie + 안심 메시지 + CTA/보조 버튼) |

### 수정된 파일 (7개)

| 경로 | 수정 내용 |
|---|---|
| `lib/data/models/activity.dart` | 전체 필드 추가 (linkedReflex, steps, observationPoints, rationale, expectedEffects, cautions, tips, equipment) |
| `lib/data/seed/activity_seed.dart` | 0-1주차 5개 활동 전체 필드 시드 데이터 (steps, observationPoints, rationale, expectedEffects, cautions, tips, equipment) |
| `lib/providers/activity_providers.dart` | ActivityFilterNotifier, filteredActivitiesProvider, todayCompletedActivityIdsProvider, ActivityTimerNotifier, activityTimerProvider, saveActivityRecord() 추가 |
| `lib/features/main_shell/main_shell.dart` | 활동 탭 `_PlaceholderTab` -> `ActivityListScreen` 교체 |
| `lib/core/router/app_router.dart` | `/activity/history`, `/activity/:id`, `/activity/:id/timer` 라우트 추가 + 히스토리 플레이스홀더 화면 |
| `lib/core/constants/app_strings.dart` | 활동 탭/상세/타이머 관련 한국어 문자열 상수 30개 이상 추가 + 필터 타입명 상수 + 반사 기본 설명 상수 |
| `lib/core/theme/app_theme.dart` | displaySmall 슬롯에 timerDisplay(48sp) 매핑 추가 (라이트/다크 모드 모두) |
| `lib/providers/core_providers.dart` | activityRecordDaoProvider 추가 |

## 구현 메모

### 기술적 결정

- **Riverpod 3.x 호환**: `StateNotifier`/`StateProvider` 대신 `Notifier`/`NotifierProvider` 패턴 사용. `FamilyNotifier`가 불안정하여 단일 `ActivityTimerNotifier`로 구현, `initTimer()`로 초기화.
- **Lottie 에셋**: 기존 `assets/lottie/celebration.json` 활용. 에셋 로드 실패 시 `Icons.celebration` 아이콘으로 폴백.
- **관찰 기록 화면**: 미구현 상태이므로 "곧 준비될 기능이에요" SnackBar 후 홈으로 이동.
- **활동 히스토리 화면**: 라우트 등록 + 플레이스홀더 화면 배치 완료.
- **연결 반사 InfoTerm**: 부모 언어 -> 전문 용어 매핑을 별도 시드 데이터 파일(`reflex_data.dart`)로 분리. 5개 반사 항목 매핑 완료.
- **타이머 가이드 텍스트**: timerGuideText가 있는 step들만 필터링하여 경과 시간에 따라 순차 전환.
- **DB 테이블**: Sprint 01에서 `activity_records` 테이블 이미 생성됨 -- 별도 마이그레이션 불필요.
- **타이머 시간 표시**: `textTheme.displaySmall` = `AppTextStyles.timerDisplay`(48sp, Bold)로 사양서 기준 충족.

### 디자인 토큰 사용

- 색상: `theme.cardColor`, `theme.colorScheme.primary/onPrimary/onSurface/secondary`, `AppColors.warmOrange/softGreen/paleCream/lightBeige/trackGray` (테마 미제공 특수 색상만)
- 타이포그래피: 모든 텍스트 `Theme.of(context).textTheme.*` 사용 (AppTextStyles 직접 사용 금지 준수)
- 스페이싱: `AppDimensions.*` 상수 사용 (하드코딩 금지 준수)
- 모서리: `AppRadius.*` 상수 사용 (`BorderRadius.circular(숫자)` 금지 준수)
- 그림자: `AppShadows.low/high` 사용

### Evaluator 리뷰 FAIL 항목 수정 내역

| FAIL | 수정 내용 |
|---|---|
| FAIL-1 | `activity_filter_chips.dart` 필터 타입명 하드코딩('안기','감각','소리','시각') -> `AppStrings.activityFilterTypes` 상수 리스트 참조로 변경 |
| FAIL-2 | `activity_detail_screen.dart` 반사 매핑 데이터 -> `lib/data/seed/reflex_data.dart`로 분리, `ReflexData.getTermName()` / `ReflexData.getDescription()` 사용 |
| FAIL-3 | `activity_providers.dart` 한국어 '전체' 하드코딩 2건 -> `AppStrings.activityFilterAll` 참조로 변경 |
| FAIL-4 | `activity_timer_screen.dart` 타이머 시간 `textTheme.displayMedium`(32sp) -> `textTheme.displaySmall`(48sp, timerDisplay) 변경. `app_theme.dart`에 `displaySmall` 슬롯 매핑 추가 |
| FAIL-5 | `activity_detail_screen.dart` `EdgeInsets.only(top: 8, right: 8)` -> `AppDimensions.sm` 사용. `activity_card.dart` `horizontal: 8, vertical: 2` -> `AppDimensions.sm` / `AppDimensions.xxs` 사용 |

## 사양서 기준 자체 점검

### 기능 검증 -- ActivityListScreen

- [x] 활동 탭 진입 시 현재 주차의 활동 5개가 카드 리스트로 표시된다
- [x] 각 활동 카드에 활동 유형 칩, 활동명, 권장 시간, 한 줄 설명이 표시된다
- [x] 화면 상단에 "하루 한 가지씩 실천해 보세요!" + "전부 하지 않아도 괜찮아요." 표시
- [x] 오늘 추천 활동 카드에 "오늘의 추천" 배지가 표시된다
- [x] 활동 유형 필터 칩 행 표시, 수평 스크롤 가능
- [x] 필터 선택 시 해당 유형 활동만 표시
- [x] 오늘 완료한 활동 카드에 softGreen 체크 아이콘 표시
- [x] 미완료 활동 카드에는 체크 아이콘 미표시
- [x] 활동 카드 탭 시 ActivityDetailScreen으로 이동
- [x] 앱 바 우측 "히스토리" 버튼 -> 히스토리 라우트 이동
- [x] 빈 상태 메시지 표시 (주차 빈 상태, 필터 빈 상태)

### 기능 검증 -- ActivityDetailScreen

- [x] Layer 1 표시: 활동 유형 칩, 주차/순서 라벨, 활동명, 한 줄 설명
- [x] 단계별 가이드 (1~5) warmOrange 원형 28dp + 수직 연결선
- [x] "더 알아보기" 기본 접힘 상태
- [x] 펼치면 관찰 포인트, 왜 하나요?, 기대 효과, 주의사항, TIP, 교구, 연결 반사 표시
- [x] 불릿 포인트 리스트
- [x] "전문가가 설계한 활동이에요" 문구
- [x] 주의사항 제목 "이런 때는 잠깐 멈춰주세요"
- [x] Equipment 카드 표시
- [x] 교구 불필요 시 "별도 교구 없이 가능" softGreen 텍스트
- [x] 연결 반사 InfoTerm 위젯 (ReflexData에서 매핑)
- [x] 하단 sticky "시작하기 (N초)" 버튼
- [x] 스크롤 콘텐츠 하단 80dp 여백

### 기능 검증 -- ActivityTimerScreen

- [x] 원형 프로그레스 타이머 (외경 200dp, 링 두께 8dp)
- [x] 남은 시간 "M:SS" 형식
- [x] 타이머 시간 표시 48sp Bold (textTheme.displaySmall = timerDisplay)
- [x] 시작 -> 카운트다운 + 프로그레스 감소
- [x] 일시정지/재개 가능
- [x] 리셋 -> 권장 시간으로 초기화
- [x] 타이머 중 가이드 문구 순차 전환
- [x] 5초 이하 "거의 다 됐어요" 텍스트
- [x] HapticFeedback.heavyImpact() 진동
- [x] 완료 화면: Lottie + "잘 하셨어요!" + 안심 메시지
- [x] 안심 메시지 랜덤 선택
- [x] "관찰 기록하기" CTA 버튼
- [x] "홈으로 돌아가기" 보조 버튼
- [x] "타이머 없이 완료하기" 보조 버튼
- [x] "스킵" 앱 바 버튼
- [x] ActivityRecord DB 저장 (timerUsed, timerDurationSec)

### ValueKey 검증

- [x] `activity_list_screen`
- [x] `activity_detail_screen`
- [x] `activity_timer_screen`
- [x] `activity_card_$activityId`
- [x] `activity_filter_$type`
- [x] `today_mission_badge`
- [x] `step_guide_$stepNumber`
- [x] `learn_more_expansion`
- [x] `start_activity_button`
- [x] `circular_timer`
- [x] `timer_start_button`
- [x] `timer_pause_button`
- [x] `timer_reset_button`
- [x] `complete_without_timer_button`
- [x] `go_to_observation_button`
- [x] `go_home_button`
- [x] `activity_history_button`
- [x] `timer_skip_button`
- [x] `timer_guide_text`
- [x] `timer_almost_done_text`
- [x] `completion_lottie`
- [x] `completion_reassurance_message`

### UX 원칙 검증

- [x] 원칙 1: "전부 하지 않아도 괜찮아요" 메시지, 관찰 기록 선택적
- [x] 원칙 2: 안심 메시지 표시, 완료율 퍼센트 없음
- [x] 원칙 3: 부모 언어 사용, InfoTerm으로 전문 용어 분리
- [x] 원칙 4: 활동 상세 -> 시작 -> 완료 1탭 플로우, 48x48dp 터치 영역
- [x] 원칙 5: 미완료 표시 없음, 완료만 체크

### 코드 품질 검증

- [x] `flutter analyze` 오류 0건, warning 0건 (info 7건: 기존 코드 포함, 모두 경미한 스타일 이슈)
- [x] fontSize 하드코딩 없음
- [x] BorderRadius.circular(숫자) 없음 (모두 AppRadius 사용)
- [x] 한국어 하드코딩 없음 -- 필터 타입명 AppStrings.activityFilterTypes, 반사 데이터 ReflexData, 필터 초기값 AppStrings.activityFilterAll
- [x] Theme.of(context).textTheme 사용 (AppTextStyles 직접 참조 없음)
- [x] EdgeInsets 숫자 하드코딩 없음 (모두 AppDimensions 상수 사용)
- [x] 타이머 시간 표시 48sp (textTheme.displaySmall = AppTextStyles.timerDisplay)
