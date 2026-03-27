# Sprint 05: 활동 탭 (3개 화면)

## 1. 구현 범위

### 대상 화면/기능

- **ActivityListScreen** (탭 3: 활동 -- "하루 한 가지씩 실천해 보세요!") (개발기획서 섹션 5-5)
  - 현재 주차의 활동 5개를 카드 리스트로 표시 (`ListView.separated`)
  - 각 카드: 활동 유형 칩(2-3-9), 활동명, 한 줄 설명, 권장 시간, 완료 표시(softGreen 체크)
  - 완료한 활동만 체크 표시 (미완료 표시 없음 -- 죄책감 없음)
  - 상단 안심 메시지: "하루 한 가지씩 실천해 보세요!" / "전부 하지 않아도 괜찮아요."
  - "오늘의 추천" 배지: `todayMissionProvider`와 연동, 오늘 추천 활동 카드에 배지 표시
  - 활동 유형별 필터 칩 행: 전체 / 안기 / 감각 / 소리 / 시각 / 안기 (FilterChip 수평 스크롤)
  - 앱 바 우측 "히스토리" 텍스트 버튼 -> ActivityHistoryScreen 이동 (이 스프린트에서는 라우트만 등록, 화면은 플레이스홀더)
  - 활동 카드 탭 -> ActivityDetailScreen 이동
- **ActivityDetailScreen** (활동 상세) (개발기획서 섹션 5-5 화면 3-1)
  - 2레이어 구조: Layer 1(하기 모드) + Layer 2(더 알아보기)
  - **Layer 1 -- 하기 모드 (진입 시 보이는 영역):**
    - 활동 유형 칩 + 주차/순서 라벨
    - 활동명 + 한 줄 설명
    - "이렇게 해보세요" 단계별 가이드 (steps 1~5, 커스텀 StepGuide)
  - **Layer 2 -- 더 알아보기 (기본 접힘, ExpansionTile):**
    - 관찰 포인트 (리스트)
    - 왜 하나요? (근거 설명 + "전문가가 설계한 활동이에요" 문구)
    - 기대 효과 (리스트)
    - 이런 때는 잠깐 멈춰주세요 (주의사항, 부모 언어)
    - 활용 TIP (리스트)
    - 필요 교구 (교구/준비물 카드 2-2-10)
    - 연결 반사 (InfoTerm 위젯 2-6-1 적용)
  - 하단 고정(sticky) "시작하기 (N초)" 버튼 (2-3-7) -- 스크롤과 무관하게 항상 표시
- **ActivityTimerScreen** (활동 타이머) (개발기획서 섹션 5-5 화면 3-2)
  - 원형 프로그레스 타이머 (CustomPaint + AnimatedBuilder, 2-5-5)
  - 남은 시간 카운트다운 표시 (예: "0:06")
  - 타이머 중 안내 문구 순차 표시 (ActivityStep.timerGuideText 기반)
  - 종료 임박 시(5초 이하) "거의 다 됐어요" 텍스트 표시
  - 시작 / 일시정지 / 리셋 버튼 (아이콘 3개)
  - "타이머 없이 완료하기" 보조 버튼 (2-3-2)
  - 타이머 종료 시 완료 화면: Lottie 축하 애니메이션 + "잘 하셨어요!" + 안심 메시지
  - 완료 화면 버튼: "오늘 아기는 어땠나요? (관찰 기록하기)" CTA + "홈으로 돌아가기" 보조
  - 타이머 종료 시 `HapticFeedback.heavyImpact()` 진동 알림
  - ActivityRecord DB 저장 (activity_records 테이블)
  - 앱 바 우측 "스킵" 버튼 -> 타이머 없이 바로 완료 처리

### 인프라 확장 (기존 코드 수정)

- **Activity 모델 확장** -- Sprint 03에서 최소 필드로 생성됨. 개발기획서 8-2의 전체 필드 추가: `linkedReflex`, `steps`, `observationPoints`, `rationale`, `expectedEffects`, `cautions`, `tips`, `equipment`
- **ActivityStep 모델 신규** -- 단계별 가이드 (stepNumber, instruction, timerGuideText, illustrationAsset)
- **Equipment 모델 신규** -- 교구 정보 (isRequired, itemName, description, diyAlternative, purchaseNote)
- **activity_seed.dart 확장** -- 0-1주차 5개 활동의 전체 필드 데이터 추가
- **ActivityRecord 모델 신규** -- 활동 완료 기록 (개발기획서 4-2)
- **ActivityRecordDao 신규** -- insert, getTodayCompletedActivityIds, getAllByBabyId
- **TimerState 모델 신규** -- 타이머 상태 (totalSeconds, remainingSeconds, isRunning, isCompleted)
- **activity_providers.dart 확장** -- todayCompletedActivityIdsProvider, activityTimerProvider 추가
- **MainShell 수정** -- 활동 탭 플레이스홀더를 ActivityListScreen으로 교체
- **GoRouter 확장** -- `/activity/:id`, `/activity/:id/timer` 라우트 추가
- **AppStrings 확장** -- 활동 탭 관련 문자열 상수 추가

### 참조 기획서 섹션

| 문서 | 섹션 |
|---|---|
| 서비스기획서 | 3-3 주차별 활동 가이드 -- "하루 한 가지씩 실천해 보세요!" |
| 서비스기획서 | 3-4 활동 후 자연 반응 관찰표 (완료 후 이동 대상 -- 이 스프린트에서는 이동 경로만) |
| 서비스기획서 | 6-1 핵심 UX 원칙 5가지 |
| 서비스기획서 | 6-2 입력 최소화 설계 |
| 서비스기획서 | 6-3 용어 통일 가이드 |
| 서비스기획서 | 6-4 접근성 고려 |
| 개발기획서 | 1-2 UX 제약 |
| 개발기획서 | 4-2 ActivityRecord 모델 |
| 개발기획서 | 4-5 ActivityRecordDao |
| 개발기획서 | 5-5 탭 3: 활동 (ActivityListScreen) + 와이어프레임 |
| 개발기획서 | 5-5 화면 3-1: 활동 상세 (ActivityDetailScreen) + 와이어프레임 |
| 개발기획서 | 5-5 화면 3-2: 활동 타이머 (ActivityTimerScreen) + 와이어프레임 |
| 개발기획서 | 8-2 활동 데이터 (Activity, ActivityStep, Equipment) |
| 개발기획서 | 8-6 안심 메시지 데이터 (ReassuranceMessages.activityCompleteMessages) |
| 개발기획서 | 8-8 시드 데이터 예시 (0-1주차) |
| 개발기획서 | 9-2 주요 Provider 정의 (currentActivities, todayMission, ActivityTimer) |
| 개발기획서 | 9-3 상태 흐름 요약 (활동 플로우) |

### 사용 디자인 컴포넌트

| 번호 | 컴포넌트 | 사용 위치 |
|---|---|---|
| 2-1-1 | 하단 탭 바 | MainShell (기존 유지) |
| 2-1-2 (변형 C) | 앱 바 (타이틀 + 우측 메뉴) | ActivityListScreen 상단 "활동" + 우측 "히스토리" |
| 2-1-2 (변형 B) | 앱 바 (뒤로 + 타이틀) | ActivityDetailScreen 상단 "활동 상세" |
| 2-1-2 (변형 C) | 앱 바 (뒤로 + 타이틀 + 우측 메뉴) | ActivityTimerScreen 상단 (활동명 + 우측 "스킵") |
| 2-2-3 | 활동 카드 (리스트 아이템) x5 | ActivityListScreen 활동 카드 |
| 2-3-9 | 활동 유형 칩 | ActivityListScreen 카드 내, ActivityDetailScreen 상단, 필터 칩 행 |
| 2-7-5 | 카드 리스트 | ActivityListScreen 활동 5개 리스트 |
| 2-6-7 | 단계 가이드 인디케이터 | ActivityDetailScreen Layer 1 "이렇게 해보세요" |
| 2-4-6 | 확장 타일 | ActivityDetailScreen Layer 2 "더 알아보기" |
| 2-2-10 | 교구/준비물 카드 | ActivityDetailScreen Layer 2 교구 섹션 |
| 2-6-1 | InfoTerm 툴팁 | ActivityDetailScreen 연결 반사 용어 설명 |
| 2-3-7 | 하단 고정 버튼 (CTA) | ActivityDetailScreen 하단 "시작하기 (N초)" |
| 2-3-1 | 기본 CTA 버튼 | ActivityDetailScreen 시작하기, TimerScreen 완료 후 관찰 기록 |
| 2-3-2 | 보조 버튼 | TimerScreen "타이머 없이 완료하기", 완료 후 "홈으로 돌아가기" |
| 2-5-5 | 원형 타이머 | ActivityTimerScreen 원형 프로그레스 |
| 2-7-1 | 스크롤 가능 페이지 + 하단 고정 버튼 | ActivityDetailScreen 레이아웃 |

---

## 2. 파일 목록

### 신규 생성

| 경로 | 설명 |
|---|---|
| `lib/data/models/activity_step.dart` | ActivityStep 모델 |
| `lib/data/models/equipment.dart` | Equipment 모델 |
| `lib/data/models/activity_record.dart` | ActivityRecord 모델 (DB 저장용) |
| `lib/data/models/timer_state.dart` | TimerState 모델 (타이머 상태) |
| `lib/data/database/daos/activity_record_dao.dart` | ActivityRecordDao (insert, 조회) |
| `lib/features/activity/screens/activity_list_screen.dart` | 활동 탭 메인 화면 |
| `lib/features/activity/screens/activity_detail_screen.dart` | 활동 상세 화면 |
| `lib/features/activity/screens/activity_timer_screen.dart` | 활동 타이머 화면 |
| `lib/features/activity/widgets/activity_card.dart` | 활동 카드 위젯 (2-2-3) |
| `lib/features/activity/widgets/step_guide.dart` | 단계별 가이드 위젯 (2-6-7) |
| `lib/features/activity/widgets/timer_ring_painter.dart` | 원형 타이머 CustomPainter (2-5-5) |
| `lib/features/activity/widgets/equipment_card.dart` | 교구/준비물 카드 (2-2-10) |
| `lib/features/activity/widgets/activity_filter_chips.dart` | 활동 유형 필터 칩 행 |
| `lib/features/activity/widgets/timer_completion_view.dart` | 타이머 완료 축하 화면 |

### 수정 (기존 파일)

| 경로 | 수정 내용 |
|---|---|
| `lib/data/models/activity.dart` | 전체 필드 추가 (linkedReflex, steps, observationPoints, rationale, expectedEffects, cautions, tips, equipment) |
| `lib/data/seed/activity_seed.dart` | 0-1주차 5개 활동 전체 시드 데이터 (steps, observationPoints 등 포함) |
| `lib/providers/activity_providers.dart` | todayCompletedActivityIdsProvider, activityTimerProvider, activityFilterProvider 추가 |
| `lib/features/main_shell/main_shell.dart` | 활동 탭 `_PlaceholderTab` -> `ActivityListScreen`으로 교체 |
| `lib/core/router/app_router.dart` | `/activity/:id`, `/activity/:id/timer` 라우트 추가 |
| `lib/core/constants/app_strings.dart` | 활동 탭 관련 문자열 상수 추가 |

---

## 3. 데이터 모델

### Activity 모델 확장 (기존 `lib/data/models/activity.dart`)

기존 최소 필드에 개발기획서 8-2의 전체 필드를 추가한다.

```dart
class Activity {
  final String id;               // "w0_act1"
  final int weekIndex;           // 주차 인덱스
  final int order;               // 순서 (1~5)
  final String name;             // "품-숨-멈춤 루틴"
  final String type;             // 활동 유형: "안기", "감각", "소리", "시각" 등
  final String description;      // 짧은 설명
  final String linkedReflex;     // 연결 반사 (부모 언어)
  final int recommendedSeconds;  // 권장 시간 (초)
  final List<ActivityStep> steps; // 단계별 가이드 (1~5단계)
  final List<String> observationPoints; // 관찰 포인트
  final String rationale;        // 왜 이 활동을 하나요? (근거)
  final List<String> expectedEffects; // 기대 효과
  final List<String> cautions;   // 주의사항 (부모 언어: "이런 때는 잠깐 멈춰주세요")
  final List<String> tips;       // 활용 TIP
  final Equipment equipment;     // 필요 교구
}
```

### ActivityStep 모델 (신규 `lib/data/models/activity_step.dart`)

```dart
class ActivityStep {
  final int stepNumber;          // 1~5
  final String instruction;     // 안내 텍스트
  final String? timerGuideText; // 타이머 중 표시할 안내 문구 (null이면 표시 안 함)
  final String? illustrationAsset; // 일러스트 에셋 경로 (MVP에서는 null)
}
```

### Equipment 모델 (신규 `lib/data/models/equipment.dart`)

```dart
class Equipment {
  final bool isRequired;         // 교구 필요 여부
  final String? itemName;        // 교구명
  final String? description;     // 설명
  final String? diyAlternative;  // 대체/DIY 안내
  final String? purchaseNote;    // 구매 관련 메모
}
```

### ActivityRecord 모델 (신규 `lib/data/models/activity_record.dart`)

```dart
class ActivityRecord {
  final int? id;
  final int babyId;
  final String activityId;    // 시드 데이터의 활동 ID (예: "w0_act1")
  final int weekNumber;       // 주차 (0, 1, 2 ...)
  final DateTime completedAt; // 완료 일시
  final int? timerDurationSec; // 타이머 사용 시간 (초)
  final bool timerUsed;       // 타이머 사용 여부

  Map<String, dynamic> toMap();
  factory ActivityRecord.fromMap(Map<String, dynamic> map);
}
```

### TimerState 모델 (신규 `lib/data/models/timer_state.dart`)

```dart
class TimerState {
  final int totalSeconds;
  final int remainingSeconds;
  final bool isRunning;
  final bool isCompleted;

  factory TimerState.initial({int totalSeconds = 0});
  TimerState copyWith({...});
}
```

### ActivityRecordDao (신규 `lib/data/database/daos/activity_record_dao.dart`)

```dart
class ActivityRecordDao {
  Future<int> insert(ActivityRecord record);
  Future<List<String>> getTodayCompletedActivityIds(int babyId);
  Future<List<ActivityRecord>> getAllByBabyId(int babyId);
}
```

### Provider 확장 (`lib/providers/activity_providers.dart`)

```dart
// 기존 유지:
// - currentActivitiesProvider
// - todayMissionProvider

// 신규 추가:
// - todayCompletedActivityIdsProvider: 오늘 완료한 활동 ID 목록 (FutureProvider)
// - activityTimerProvider: 타이머 상태 관리 (StateNotifierProvider)
// - activityFilterProvider: 활동 유형 필터 상태 ("전체" | "안기" | "감각" | ...)
// - filteredActivitiesProvider: 필터 적용된 활동 목록
```

### DB 테이블

`activity_records` 테이블은 Sprint 01에서 이미 `Tables.createActivityRecords`로 정의 완료. 별도 마이그레이션 불필요.

---

## 4. 검증 기준 (Evaluator용)

각 기준은 PASS/FAIL로 판정 가능합니다.

### 기능 검증 -- ActivityListScreen

- [ ] 활동 탭 진입 시 현재 주차의 활동 5개가 카드 리스트로 표시된다
- [ ] 각 활동 카드에 활동 유형 칩(예: [안기]), 활동명, 권장 시간("권장 30초"), 한 줄 설명이 표시된다
- [ ] 화면 상단에 "하루 한 가지씩 실천해 보세요!" 메시지와 "전부 하지 않아도 괜찮아요." 서브 메시지가 표시된다
- [ ] 오늘 추천 활동 카드에 "오늘의 추천" 배지가 표시되며, todayMissionProvider의 결과와 일치한다
- [ ] 활동 유형 필터 칩 행(전체/안기/감각/소리/시각)이 표시되고 수평 스크롤 가능하다
- [ ] "전체" 필터 선택 시 5개 모두 표시, 특정 유형(예: "안기") 선택 시 해당 유형 활동만 표시된다
- [ ] 오늘 완료한 활동 카드 좌측에 softGreen 체크 아이콘이 표시된다
- [ ] 미완료 활동 카드에는 체크 아이콘이 표시되지 않는다 (빈 공간 또는 표시 없음)
- [ ] 활동 카드 탭 시 ActivityDetailScreen으로 이동한다 (GoRouter `/activity/:id`)
- [ ] 앱 바 우측 "히스토리" 버튼 탭 시 활동 히스토리 라우트로 이동한다
- [ ] 활동이 없는 주차의 경우 빈 상태(empty state) 메시지가 표시된다

### 기능 검증 -- ActivityDetailScreen

- [ ] 화면 진입 시 Layer 1(하기 모드)이 표시된다: 활동 유형 칩, 주차/순서 라벨, 활동명, 한 줄 설명
- [ ] "이렇게 해보세요" 섹션에 단계별 가이드(1~5)가 번호 + 연결선 + 안내 텍스트로 표시된다 (2-6-7 스펙: warmOrange 원형 28dp 번호, 2px 수직 연결선)
- [ ] "더 알아보기" 영역은 기본 접힘 상태이다
- [ ] "더 알아보기" 탭 시 Layer 2가 펼쳐지며 관찰 포인트, 왜 하나요?, 기대 효과, 주의사항, 활용 TIP, 필요 교구 섹션이 표시된다
- [ ] 관찰 포인트가 불릿 포인트 리스트로 표시된다
- [ ] "왜 하나요?" 섹션에 rationale 텍스트 + "전문가가 설계한 활동이에요" 문구가 표시된다
- [ ] 주의사항 섹션 제목이 "이런 때는 잠깐 멈춰주세요"로 표시된다 (부모 언어)
- [ ] 필요 교구 섹션에 Equipment 정보가 교구/준비물 카드(2-2-10)로 표시된다
- [ ] 교구 불필요 시 "별도 교구 없이 가능" 메시지가 softGreen 텍스트로 표시된다
- [ ] 연결 반사 텍스트에 InfoTerm 위젯(2-6-1)이 적용되어, 탭 시 전문 용어 + 설명 툴팁이 표시된다
- [ ] 하단에 "시작하기 (N초)" sticky 버튼이 스크롤과 무관하게 항상 표시된다
- [ ] "시작하기" 버튼 탭 시 ActivityTimerScreen으로 이동한다 (GoRouter `/activity/:id/timer`)
- [ ] 스크롤 콘텐츠 하단에 sticky 버튼 높이만큼 여백(padding bottom ~80dp)이 확보되어 콘텐츠가 버튼에 가리지 않는다

### 기능 검증 -- ActivityTimerScreen

- [ ] 화면 중앙에 원형 프로그레스 타이머가 표시된다 (외경 200dp, 링 두께 8dp)
- [ ] 타이머 중앙에 남은 시간이 "M:SS" 형식으로 표시된다 (예: "0:30", "0:06")
- [ ] 시작 버튼 탭 시 타이머가 카운트다운을 시작하고 원형 프로그레스가 시계 방향으로 감소한다
- [ ] 일시정지 버튼 탭 시 타이머가 멈추고 재개 가능하다
- [ ] 리셋 버튼 탭 시 타이머가 권장 시간으로 초기화된다
- [ ] 타이머 진행 중 안내 문구가 하단에 표시된다 (ActivityStep.timerGuideText 기반 순차 전환)
- [ ] 남은 시간 5초 이하일 때 "거의 다 됐어요" 텍스트가 표시된다
- [ ] 타이머 종료 시 `HapticFeedback.heavyImpact()` 진동이 실행된다
- [ ] 타이머 종료 시 완료 화면으로 전환된다: Lottie 애니메이션 + "잘 하셨어요!" + 안심 메시지
- [ ] 완료 화면의 안심 메시지는 `ReassuranceMessages.activityCompleteMessages` 중 랜덤 1개가 표시된다
- [ ] 완료 화면에 "오늘 아기는 어땠나요? (관찰 기록하기)" CTA 버튼이 표시된다
- [ ] 완료 화면에 "홈으로 돌아가기" 보조 버튼이 표시된다
- [ ] "홈으로 돌아가기" 탭 시 홈 화면으로 이동하며, 관찰 기록을 하지 않아도 활동 완료로 처리된다
- [ ] "타이머 없이 완료하기" 보조 버튼 탭 시 타이머를 건너뛰고 바로 완료 화면이 표시된다
- [ ] 앱 바 우측 "스킵" 버튼 탭 시 "타이머 없이 완료하기"와 동일하게 동작한다
- [ ] 활동 완료 시 ActivityRecord가 activity_records 테이블에 저장된다 (babyId, activityId, weekNumber, completedAt, timerDurationSec, timerUsed)
- [ ] 타이머 사용 완료 시 timerUsed=true, timerDurationSec=실제 사용 시간이 저장된다
- [ ] 타이머 없이 완료 시 timerUsed=false, timerDurationSec=null이 저장된다
- [ ] 완료 후 ActivityListScreen으로 돌아오면 해당 활동 카드에 softGreen 체크 아이콘이 표시된다

### 기능 검증 -- 통합

- [ ] MainShell 활동 탭(index 2) 탭 시 ActivityListScreen이 표시된다 (플레이스홀더 제거)
- [ ] GoRouter에 `/activity/:id` 라우트가 등록되어 있고, ActivityDetailScreen이 올바른 activity id를 수신한다
- [ ] GoRouter에 `/activity/:id/timer` 라우트가 등록되어 있고, ActivityTimerScreen이 올바른 activity id를 수신한다
- [ ] 활동 완료 후 홈 화면의 todayMissionProvider가 다음 미완료 활동으로 업데이트된다

### UX 원칙 검증

- [ ] **원칙 1 -- 하나만 해도 충분하다:** 활동 탭 상단에 "전부 하지 않아도 괜찮아요" 메시지가 표시된다. 타이머 완료 후 관찰 기록은 선택이며 "홈으로 돌아가기"로 바로 완료 가능하다
- [ ] **원칙 2 -- 숫자보다 말로 안심시킨다:** 활동 완료 시 "잘 하셨어요! 오늘 한 가지를 해냈어요." 등 안심 메시지가 표시된다. 완료율 퍼센트는 어디에도 표시되지 않는다
- [ ] **원칙 3 -- 전문 용어 부모 언어 사용:** 연결 반사 텍스트가 부모 언어로 표시된다 (예: "깜짝 놀라며 팔을 벌리는 반응"). 전문 용어는 InfoTerm 툴팁 탭 시에만 노출된다. 주의사항 제목이 "이런 때는 잠깐 멈춰주세요"로 표시된다
- [ ] **원칙 4 -- 한 손 30초 완료:** 활동 상세 -> 시작하기 -> 타이머 종료 -> 완료 버튼 1탭 플로우가 가능하다. 모든 버튼 터치 영역이 48x48dp 이상이다
- [ ] **원칙 5 -- 죄책감 없음:** 미완료 활동에 "미완료" 텍스트나 빈 체크 박스 등의 시각적 미완료 표시가 없다. 완료한 활동만 체크 표시된다. 활동 완료율/진행률 표시가 없다

### 디자인 검증

- [ ] 활동 카드 배경: `#FFFFFF`, 모서리 12dp, 패딩 16dp, 그림자 `AppShadows.low`
- [ ] 활동 유형 칩: paleCream(`#FFF3E8`) 배경, warmOrange(`#F5A623`) 텍스트, 12sp, 모서리 8dp
- [ ] 활동명: H3 (16sp, SemiBold), 권장 시간: Caption (13sp, warmGray), 설명: Body2 (14sp, darkBrown)
- [ ] 완료 체크 아이콘: softGreen(`#7BC67E`)
- [ ] 원형 타이머: 외경 200dp, 링 두께 8dp, warmOrange(`#F5A623`) 프로그레스, trackGray(`#E8DDD0`) 트랙
- [ ] 타이머 중앙 시간: TimerDisplay (48sp, Bold, darkBrown)
- [ ] 단계 가이드: warmOrange 원형 28dp 번호, warmOrange 2px 수직 연결선, Body1 (15sp, darkBrown) 텍스트
- [ ] 하단 고정 버튼: 배경 white, 상단 그림자 `AppShadows.high`, 패딩 `EdgeInsets.fromLTRB(16, 12, 16, 16)` + SafeArea
- [ ] CTA 버튼: warmOrange 배경, white 텍스트, 높이 52dp, 모서리 24dp
- [ ] 보조 버튼: 투명 배경, lightBeige 1.5px 테두리, darkBrown 텍스트, 높이 48dp, 모서리 24dp
- [ ] 카드 리스트: 수평 패딩 16dp, 수직 패딩 16dp, 카드 간격 12dp (`ListView.separated`)
- [ ] 모든 텍스트 스타일이 `Theme.of(context).textTheme`을 사용한다 (하드코딩 금지)
- [ ] 다크 모드 대응: darkBg(`#1A1512`) 배경, darkCard(`#2A231D`) 카드, darkTextPrimary(`#F5EDE3`) 텍스트
- [ ] 조부모 모드 대응: 기존 grandparent_theme.dart의 확대 글씨/터치 영역 적용 시 레이아웃 깨지지 않음

### 접근성 검증

- [ ] 활동 카드 전체가 탭 가능하며 최소 터치 영역 48x48dp 이상이다
- [ ] 타이머 시작/일시정지/리셋 각 버튼의 터치 영역이 48x48dp 이상이다
- [ ] 타이머 완료 시 `HapticFeedback.heavyImpact()` 진동이 실행된다 (무음 모드 대응)
- [ ] 타이머 안내 문구가 화면에 텍스트로 표시된다 (시각적 안내 -- 무음 모드에서도 정보 전달)
- [ ] 빈 상태(empty state): 활동 없는 주차 진입 시 안내 메시지가 표시된다
- [ ] 빈 상태(empty state): 필터 적용 후 해당 유형 활동이 없을 때 안내 메시지가 표시된다

### ValueKey 검증 (Marionette MCP 테스트용)

- [ ] `ActivityListScreen` -> `ValueKey('activity_list_screen')`
- [ ] `ActivityDetailScreen` -> `ValueKey('activity_detail_screen')`
- [ ] `ActivityTimerScreen` -> `ValueKey('activity_timer_screen')`
- [ ] 각 활동 카드 -> `ValueKey('activity_card_$activityId')` (예: `activity_card_w0_act1`)
- [ ] 활동 유형 필터 칩 -> `ValueKey('activity_filter_$type')` (예: `activity_filter_전체`, `activity_filter_안기`)
- [ ] "오늘의 추천" 배지 -> `ValueKey('today_mission_badge')`
- [ ] 단계 가이드 각 스텝 -> `ValueKey('step_guide_$stepNumber')` (예: `step_guide_1`)
- [ ] "더 알아보기" 확장 타일 -> `ValueKey('learn_more_expansion')`
- [ ] "시작하기" 하단 고정 버튼 -> `ValueKey('start_activity_button')`
- [ ] 원형 타이머 -> `ValueKey('circular_timer')`
- [ ] 타이머 시작 버튼 -> `ValueKey('timer_start_button')`
- [ ] 타이머 일시정지 버튼 -> `ValueKey('timer_pause_button')`
- [ ] 타이머 리셋 버튼 -> `ValueKey('timer_reset_button')`
- [ ] "타이머 없이 완료하기" 버튼 -> `ValueKey('complete_without_timer_button')`
- [ ] 타이머 완료 후 관찰 기록 CTA -> `ValueKey('go_to_observation_button')`
- [ ] 타이머 완료 후 홈으로 버튼 -> `ValueKey('go_home_button')`
- [ ] 앱 바 히스토리 버튼 -> `ValueKey('activity_history_button')`
- [ ] 앱 바 스킵 버튼 -> `ValueKey('timer_skip_button')`
- [ ] 타이머 안내 문구 텍스트 -> `ValueKey('timer_guide_text')`
- [ ] 타이머 "거의 다 됐어요" 텍스트 -> `ValueKey('timer_almost_done_text')`
- [ ] 완료 축하 Lottie -> `ValueKey('completion_lottie')`
- [ ] 완료 안심 메시지 -> `ValueKey('completion_reassurance_message')`

---

## 5. 의존성

### 선행 스프린트

| 스프린트 | 필요 이유 |
|---|---|
| Sprint 01 (프로젝트 세팅) | Flutter 프로젝트 구조, sqflite, Riverpod, GoRouter, 테마(AppColors, AppTextStyles, AppShadows 등) |
| Sprint 02 (온보딩) | 아기 등록 완료 -> activeBabyProvider -> currentWeekProvider 동작 전제 |
| Sprint 03 (홈) | Activity 모델(최소 필드), activity_seed.dart, currentActivitiesProvider, todayMissionProvider, ActivityTypeChip, InfoTerm, EmptyStateCard, SavedToast, PrimaryCtaButton, MainShell, AppRouter, AppStrings 기본 상수 |
| Sprint 04 (기록) | DailyRecordDao, RecordMainScreen (MainShell의 기록 탭 동작 확인용) |

### 필요 패키지

| 패키지 | 버전 | 용도 |
|---|---|---|
| `flutter_riverpod` | 기존 설치 | Provider 상태 관리 |
| `go_router` | 기존 설치 | 라우팅 (`/activity/:id`, `/activity/:id/timer`) |
| `sqflite` | 기존 설치 | ActivityRecord DB 저장 |
| `lottie` | ^3.1.0 | 완료 축하 애니메이션 (신규 추가 필요) |

### Lottie 에셋

- `assets/lottie/completion.json` -- 활동 완료 축하 애니메이션 파일 필요
- 에셋이 준비되지 않은 경우 플레이스홀더(아이콘 + 텍스트)로 대체 가능하되, Lottie 로드 코드는 구현해둔다
- `pubspec.yaml`의 assets 섹션에 `assets/lottie/` 경로 등록 필요

### 관찰 기록 화면 (이 스프린트의 범위 밖)

- 타이머 완료 후 "오늘 아기는 어땠나요?" 버튼의 이동 대상인 ObservationFormScreen은 **다음 스프린트**에서 구현한다
- 이 스프린트에서는 해당 버튼 탭 시:
  - ObservationFormScreen 라우트가 있으면 이동
  - 없으면 "곧 준비될 기능이에요" 토스트를 표시하고 홈으로 이동

### 활동 히스토리 화면 (이 스프린트의 범위 밖)

- ActivityHistoryScreen(개발기획서 화면 3-5)은 이 스프린트에서 라우트만 등록하고 플레이스홀더 화면을 배치한다
- 실제 구현은 이후 스프린트에서 진행한다
