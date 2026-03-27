# Sprint 04: 기록 탭 (3개 화면)

## 1. 구현 범위

### 대상 화면/기능

- **RecordMainScreen** (탭 2: 기록 -- "우리 아이 하루 기록") (개발기획서 섹션 5-4)
  - 날짜 스와이프 헤더 (좌/우 화살표 + 스와이프 제스처, 미래 날짜 비활성)
  - 수유 카운터 (+/- 버튼, 0일 때 - 비활성, 30회 이상 시 경고 토스트)
  - 배변 카운터 (+/- 버튼, 동일 사양)
  - 수면 시간 입력 (탭하면 시간 피커 표시)
  - 성장 기록 (체중/키/머리둘레) -- 기본 접힘 ExpansionTile, "성장 기록 추가하기 +"
  - 부모 메모 (자유 텍스트, 선택)
  - 자동 저장 + 피드백: 카운터는 "저장됨" 토스트, 나머지는 인라인 "저장됨"
  - 성장곡선 보기 / 기록 히스토리 바로가기 (반으로 나눈 버튼 쌍)
- **GrowthChartScreen** (성장 곡선 그래프) (개발기획서 섹션 5-4 화면 2-1)
  - 체중/키/머리둘레 탭 전환 (TabBar + TabBarView)
  - WHO "표준 범위" 음영 밴드 (15th~85th 퍼센타일, 퍼센타일 숫자 없음)
  - "낮은 편 / 보통 / 높은 편" 질적 레이블
  - 안심 메시지 상단 표시 ("정상 범위 안에서 잘 자라고 있어요")
  - 최근 기록 리스트 (날짜 + 값 + 변화 방향 아이콘)
- **RecordHistoryScreen** (기록 히스토리) (개발기획서 섹션 5-4 화면 2-2)
  - 타임라인 형태 날짜별 기록 (카드 리스트)
  - 기록 없는 날은 건너뜀 (죄책감 없음)
  - 무한 스크롤 (과거 방향)
  - 빈 상태 처리
- **MainShell 수정** -- 기록 탭 플레이스홀더를 RecordMainScreen으로 교체
- **TodayRecordNotifier 확장** -- decrementFeeding, decrementDiaper, updateSleep, updateMemo 메서드 추가
- **DailyRecordDao 확장** -- getByDate (날짜별 조회), getRecordsByDateRange (히스토리 목록)
- **GrowthRecordDao 확장** -- insert, getAllByBabyId, getTodayRecord 메서드 추가
- **GoRouter 확장** -- /record/growth-chart, /record/history 하위 라우트 추가
- **날짜별 기록 Provider** -- selectedDateRecordProvider (날짜 스와이프 시 해당 날짜 데이터 로드)
- **성장 기록 Provider** -- allGrowthRecordsProvider, todayGrowthRecordProvider

### 참조 기획서 섹션

| 문서 | 섹션 |
|---|---|
| 서비스기획서 | 3-2 데일리 기록 -- "우리 아이 하루 기록" |
| 서비스기획서 | 6-1 핵심 UX 원칙 5가지 |
| 서비스기획서 | 6-2 입력 최소화 설계 |
| 서비스기획서 | 6-3 용어 통일 가이드 |
| 서비스기획서 | 6-4 접근성 고려 |
| 개발기획서 | 1-2 UX 제약 |
| 개발기획서 | 4-2 DailyRecord, GrowthRecord 모델 |
| 개발기획서 | 4-5 DailyRecordDao, GrowthRecordDao |
| 개발기획서 | 5-4 탭 2: 기록 (RecordMainScreen) + 와이어프레임 |
| 개발기획서 | 5-4 화면 2-1: 성장 곡선 그래프 (GrowthChartScreen) |
| 개발기획서 | 5-4 화면 2-2: 기록 히스토리 (RecordHistoryScreen) |
| 개발기획서 | 9-2 주요 Provider 정의 (TodayRecord, 기록 Provider) |

### 사용 디자인 컴포넌트

| 번호 | 컴포넌트 | 사용 위치 |
|---|---|---|
| 2-1-1 | 하단 탭 바 | MainShell (기존 유지) |
| 2-1-2 (변형 A) | 앱 바 (기록 탭 타이틀) | RecordMainScreen 상단 "기록" |
| 2-1-2 (변형 B) | 앱 바 (뒤로 + 타이틀) | GrowthChartScreen, RecordHistoryScreen |
| 2-1-2 (변형 D) | 앱 바 (탭 포함) | GrowthChartScreen (체중/키/머리둘레 탭) |
| 2-7-4 | 날짜 스와이프 헤더 | RecordMainScreen 상단 날짜 영역 |
| 2-4-3 | 날짜 선택기 | RecordMainScreen 날짜 이동 |
| 2-3-3 | 카운터 버튼 x2 | RecordMainScreen 수유/배변 카운터 |
| 2-4-4 | 시간 피커 | RecordMainScreen 수면 시간 입력 |
| 2-4-5 | 텍스트 입력 필드 | RecordMainScreen 메모, 성장 기록 입력 |
| 2-4-6 | 확장 타일 | RecordMainScreen 성장 기록 접힘/펼침 |
| 2-6-2 | 토스트/스낵바 | RecordMainScreen 카운터 +/-1 시 "저장됨" |
| 2-6-3 | 인라인 저장 확인 | RecordMainScreen 수면/성장/메모 입력 시 "저장됨" |
| 2-3-8 | 반으로 나눈 버튼 쌍 | RecordMainScreen 하단 (성장곡선 보기 + 기록 히스토리) |
| 2-3-6 | 텍스트 링크 버튼 | 기존 재사용 (필요 시) |
| 2-5-2 | 성장 곡선 차트 | GrowthChartScreen 메인 그래프 |
| 2-3-5 (변형 C) | 탭/칩 선택기 | GrowthChartScreen 체중/키/머리둘레 탭 |
| 2-2-7 | 안심 메시지 카드 | GrowthChartScreen 상단 안심 메시지 |
| 2-7-5 | 카드 리스트 | RecordHistoryScreen 타임라인 카드 목록 |
| 2-2-4 | 기록 요약 카드 | RecordHistoryScreen 날짜별 기록 카드 |
| 2-2-8 | 빈 상태 카드 | RecordHistoryScreen 데이터 없을 때 |

---

## 2. 파일 목록

### 새로 생성할 파일

```
# -- 기록 화면 --
lib/features/record/screens/record_main_screen.dart       # RecordMainScreen 메인 화면
lib/features/record/screens/growth_chart_screen.dart       # GrowthChartScreen 성장 곡선
lib/features/record/screens/record_history_screen.dart     # RecordHistoryScreen 기록 히스토리

# -- 기록 화면 위젯 --
lib/features/record/widgets/date_swipe_header.dart         # 날짜 스와이프 헤더 (2-7-4, 2-4-3)
lib/features/record/widgets/counter_card.dart              # 수유/배변 카운터 카드 (2-3-3)
lib/features/record/widgets/sleep_input_card.dart          # 수면 시간 입력 카드 (2-4-4)
lib/features/record/widgets/growth_expansion_tile.dart     # 성장 기록 확장 타일 (2-4-6)
lib/features/record/widgets/memo_input_card.dart           # 부모 메모 입력 카드 (2-4-5)
lib/features/record/widgets/record_summary_card.dart       # 기록 요약 카드 - 히스토리용 (2-2-4)
lib/features/record/widgets/growth_chart_widget.dart       # 성장 곡선 차트 위젯 (2-5-2)
lib/features/record/widgets/recent_growth_list.dart        # 최근 성장 기록 리스트

# -- 공유 위젯 --
lib/core/widgets/inline_save_indicator.dart                # 인라인 "저장됨" 피드백 (2-6-3)
lib/core/widgets/half_button_pair.dart                     # 반으로 나눈 버튼 쌍 (2-3-8)
lib/core/widgets/reassurance_card.dart                     # 안심 메시지 카드 (2-2-7)

# -- Provider --
lib/providers/selected_date_provider.dart                  # 선택된 날짜 + 해당 날짜 DailyRecord
```

### 수정할 기존 파일

```
lib/features/main_shell/main_shell.dart        # 기록 탭 플레이스홀더 -> RecordMainScreen 교체
lib/core/router/app_router.dart                # /record/growth-chart, /record/history 하위 라우트 추가
lib/providers/record_providers.dart            # decrementFeeding, decrementDiaper, updateSleep, updateMemo 메서드 추가
lib/providers/growth_providers.dart            # allGrowthRecordsProvider, todayGrowthRecordProvider 추가
lib/data/database/daos/daily_record_dao.dart   # getRecordsByDateRange 메서드 추가
lib/data/database/daos/growth_record_dao.dart  # insert, getAllByBabyId, getTodayRecord 메서드 추가
lib/core/constants/app_strings.dart            # 기록 화면 전용 문자열 추가
```

---

## 3. 데이터 모델

### 3-1. DailyRecord (기존 -- Sprint 03에서 생성됨)

Sprint 03에서 생성된 모델을 그대로 활용한다. 변경 없음.

```dart
class DailyRecord {
  final int? id;
  final int babyId;
  final DateTime date;
  final int feedingCount;    // 기본 0
  final int diaperCount;     // 기본 0
  final double? sleepHours;
  final String? memo;
  final DateTime createdAt;
  final DateTime? updatedAt;
}
```

### 3-2. GrowthRecord (기존 -- Sprint 03에서 생성됨)

Sprint 03에서 생성된 모델을 그대로 활용한다. 변경 없음.

```dart
class GrowthRecord {
  final int? id;
  final int babyId;
  final DateTime date;
  final double? weightKg;
  final double? heightCm;
  final double? headCircumCm;
  final DateTime createdAt;
}
```

### 3-3. DailyRecordDao 확장 (기존 파일 수정)

Sprint 03에서 구현된 `insert`, `update`, `getTodayRecord`, `getByDate`에 다음 메서드를 추가한다.

```dart
/// 특정 날짜 범위의 DailyRecord 목록을 조회한다 (히스토리용).
/// 최신 날짜가 먼저 오도록 DESC 정렬.
/// 기록이 없는 날은 포함하지 않는다 (죄책감 없음).
Future<List<DailyRecord>> getRecordsByDateRange(
  int babyId,
  DateTime startDate,
  DateTime endDate,
) async { ... }

/// 특정 아기의 모든 DailyRecord를 최신순으로 조회한다 (페이징 지원).
Future<List<DailyRecord>> getAllByBabyId(
  int babyId, {
  int limit = 20,
  int offset = 0,
}) async { ... }
```

### 3-4. GrowthRecordDao 확장 (기존 파일 수정)

Sprint 03에서 구현된 `getLatestRecord`에 다음 메서드를 추가한다.

```dart
/// 성장 기록을 삽입한다.
Future<int> insert(GrowthRecord record) async { ... }

/// 성장 기록을 업데이트한다.
Future<int> update(GrowthRecord record) async { ... }

/// 특정 아기의 모든 성장 기록을 날짜순(ASC)으로 조회한다 (성장 곡선 그래프용).
Future<List<GrowthRecord>> getAllByBabyId(int babyId) async { ... }

/// 특정 날짜의 성장 기록을 조회한다 (오늘 데이터 존재 여부 확인용).
Future<GrowthRecord?> getByDate(int babyId, DateTime date) async { ... }
```

### 3-5. TodayRecordNotifier 확장 (기존 파일 수정)

Sprint 03에서 구현된 `incrementFeeding`, `incrementDiaper`에 다음 메서드를 추가한다.

```dart
/// 수유 카운트를 1 감소시킨다 (최소 0).
Future<void> decrementFeeding() async { ... }

/// 배변 카운트를 1 감소시킨다 (최소 0).
Future<void> decrementDiaper() async { ... }

/// 수면 시간을 업데이트한다.
Future<void> updateSleep(double hours) async { ... }

/// 메모를 업데이트한다.
Future<void> updateMemo(String memo) async { ... }
```

### 3-6. 신규 Provider

| Provider | 타입 | 파일 | 용도 |
|---|---|---|---|
| `selectedDateProvider` | `StateProvider<DateTime>` | selected_date_provider.dart | 기록 화면에서 현재 선택된 날짜 |
| `selectedDateRecordProvider` | `FutureProvider<DailyRecord?>` | selected_date_provider.dart | 선택된 날짜의 DailyRecord 조회 (selectedDateProvider + activeBabyProvider watch) |
| `allGrowthRecordsProvider` | `FutureProvider<List<GrowthRecord>>` | growth_providers.dart | 활성 아기의 전체 성장 기록 (성장 곡선 그래프용) |
| `todayGrowthRecordProvider` | `FutureProvider<GrowthRecord?>` | growth_providers.dart | 오늘 성장 기록 (ExpansionTile 상태 판단용) |
| `recordHistoryProvider` | `FutureProvider<List<DailyRecord>>` | selected_date_provider.dart | 히스토리 목록 (전체 기록 최신순) |

### 3-7. 날짜별 기록 로직

RecordMainScreen은 날짜 스와이프로 과거 날짜를 탐색할 수 있다.

- **오늘 날짜 선택 시**: `todayRecordProvider`를 사용하여 자동 생성 + 업데이트 (기존 로직)
- **과거 날짜 선택 시**: `selectedDateRecordProvider`로 읽기 전용 조회 (해당 날짜의 데이터를 표시하되, 카운터/입력은 비활성화 또는 해당 날짜 레코드에 직접 write)
- **미래 날짜**: 우측 화살표 비활성, 탐색 불가

**구현 전략:**
- `selectedDateProvider`가 오늘이면 `todayRecordProvider`를 사용
- `selectedDateProvider`가 과거이면 `selectedDateRecordProvider` (DB 조회만, 없으면 null)
- 과거 날짜에서도 기록 수정 가능 (해당 날짜의 DailyRecord에 직접 write). 단, _getOrCreateRecord(date) 패턴으로 처리
- **이 스프린트에서는 선택된 날짜가 변경되면 해당 날짜의 DailyRecord를 조회하여 UI에 반영**한다. 날짜별로 카운터를 조작하면 해당 날짜의 레코드가 업데이트된다.

---

## 4. 검증 기준 (Evaluator용)

각 기준은 PASS/FAIL로 판정한다.

### 4-1. 빌드 및 실행 검증

- [ ] `flutter analyze`에서 error 0개 (warning은 허용)
- [ ] `flutter build apk --debug` 성공
- [ ] 앱 실행 시 홈 화면에서 하단 "기록" 탭 탭 -> RecordMainScreen 표시됨

### 4-2. MainShell 수정 검증

- [ ] 하단 "기록" 탭(index 1) 탭 시 RecordMainScreen이 표시됨 (플레이스홀더 아님)
- [ ] 기록 탭에서 다른 탭으로 전환 후 다시 돌아오면 상태(날짜, 카운터 값)가 유지됨
- [ ] ValueKey: `nav_tab_record` 탭 시 RecordMainScreen 진입

### 4-3. RecordMainScreen 전체 레이아웃 검증

- [ ] Scaffold 배경색이 `Theme.of(context).scaffoldBackgroundColor` 사용
- [ ] AppBar에 "기록" 타이틀 표시 (변형 A: 타이틀만, 뒤로가기 없음), 엘리베이션 0
- [ ] 화면 전체가 세로 스크롤 가능 (SingleChildScrollView 또는 CustomScrollView)
- [ ] 카드 배치 순서 (위에서 아래): 날짜 스와이프 헤더 -> 수유 카운터 -> 배변 카운터 -> 수면 입력 -> 성장 기록 (접힘) -> 메모 -> 하단 버튼 쌍 -> "모든 입력은 자동 저장됩니다" 안내
- [ ] 화면 좌우 패딩: 16dp
- [ ] 카드 사이 간격: 12dp
- [ ] ValueKey: `record_main_screen`, `record_scroll_view`

### 4-4. 날짜 스와이프 헤더 검증

- [ ] "2026년 3월 25일 (오늘)" 형식의 날짜 텍스트 중앙 표시 (headlineSmall / H3, SemiBold)
- [ ] 오늘인 경우 "(오늘)" 접미사 표시
- [ ] 좌측 화살표(chevron_left) 버튼: 탭 시 전날로 이동, 날짜 텍스트 갱신
- [ ] 우측 화살표(chevron_right) 버튼: 오늘 날짜일 때 비활성 (opacity 30%, 탭 불가)
- [ ] 과거 날짜에서 우측 화살표 탭 시 다음 날로 이동
- [ ] 좌우 스와이프 제스처로도 날짜 이동 가능
- [ ] 화살표 터치 영역: 최소 48x48dp
- [ ] 날짜 형식: `intl` 패키지의 `DateFormat('yyyy년 M월 d일', 'ko_KR')` 사용
- [ ] 날짜 변경 시 해당 날짜의 DailyRecord 데이터가 화면에 반영됨
- [ ] ValueKey: `date_swipe_header`, `date_prev_btn`, `date_next_btn`, `date_label`

### 4-5. 수유 카운터 카드 검증

- [ ] 카드 상단에 이모지 + "수유" 레이블 (headlineSmall / H3, 16sp, SemiBold)
- [ ] 중앙에 큰 숫자 표시: "3회" (displayMedium / Data, 32sp, Bold, darkBrown)
- [ ] 좌측 "-" 버튼, 우측 "+" 버튼, 각 48x48dp 이상
- [ ] 버튼 배경: paleCream(`#FFF3E8`), 모서리 8dp, 아이콘 24dp
- [ ] "+" 버튼 탭 시: feedingCount +1, 숫자 scale-up 애니메이션 (1.2배 -> 0.15초 후 원래), "저장됨" 토스트 1초 표시
- [ ] "-" 버튼 탭 시: feedingCount -1 (최소 0), 숫자 scale-up 애니메이션, "저장됨" 토스트 1초 표시
- [ ] feedingCount가 0일 때: "-" 버튼 비활성 (mutedBeige 색상), 탭 불가
- [ ] feedingCount가 30 이상일 때: "정말 맞나요? 한 번 확인해 주세요" 토스트 표시
- [ ] +/- 탭 시 `HapticFeedback.lightImpact()` 햅틱 피드백 발생
- [ ] 카드 배경: Theme cardColor (`#FFFFFF` / 다크 `#2A231D`), 모서리 12dp, 패딩 16dp
- [ ] 버튼 눌림 시: warmOrange 배경으로 변경
- [ ] ValueKey: `feeding_counter_card`, `feeding_count`, `feeding_plus_btn`, `feeding_minus_btn`

### 4-6. 배변 카운터 카드 검증

- [ ] 수유 카운터와 동일한 사양 (이모지 + "배변" 레이블)
- [ ] +/- 동작, 애니메이션, 토스트, 햅틱, 비활성 조건 모두 수유와 동일
- [ ] ValueKey: `diaper_counter_card`, `diaper_count`, `diaper_plus_btn`, `diaper_minus_btn`

### 4-7. 수면 시간 입력 카드 검증

- [ ] 카드 상단에 이모지 + "수면" 레이블 (headlineSmall / H3)
- [ ] 수면 시간 표시: "14시간 30분" (bodyLarge / Body1, 15sp) -- 미입력 시 플레이스홀더 "탭해서 입력" (mutedBeige)
- [ ] 입력 필드 배경: `#FFFFFF`, 모서리 12dp, 테두리 lightBeige 1px, 높이 48dp
- [ ] 입력 필드 탭 시 시간 피커 표시 (`showTimePicker` 또는 `CupertinoTimerPicker`)
- [ ] 시간 선택 후 값이 즉시 반영되고 DailyRecord.sleepHours가 DB에 저장됨
- [ ] 저장 후 인라인 "저장됨" 표시 (Small, 11sp, softGreen): 필드 우측 하단, 2초 후 페이드아웃
- [ ] ValueKey: `sleep_input_card`, `sleep_value`, `sleep_save_indicator`

### 4-8. 성장 기록 확장 타일 검증

- [ ] **접힘 상태 (기본)**: "성장 기록 추가하기 +" 텍스트 (headlineSmall / H3, SemiBold), paleCream 배경, 모서리 12dp
- [ ] **오늘 성장 데이터 존재 시**: 접힌 상태에서 "오늘 측정: 3.2kg, 50cm" 컴팩트 카드로 대체 표시 (펼침 아이콘 포함)
- [ ] 탭 시 펼침/접힘 애니메이션 200ms ease-in-out
- [ ] **펼침 상태**: 체중(kg), 키(cm), 머리둘레(cm) 3개 입력 필드 노출
  - 각 필드: 레이블 (Caption, 13sp, warmGray) + TextField (Body1, 15sp)
  - 필드 배경 `#FFFFFF`, 테두리 lightBeige 1px, 포커스 시 warmOrange 2px
  - 키보드: 숫자 키보드 (`TextInputType.numberWithOptions(decimal: true)`)
  - 각 필드 입력 완료(onSubmitted 또는 포커스 해제) 시 GrowthRecord에 저장
  - 각 필드 저장 후 인라인 "저장됨" 표시 (Small, 11sp, softGreen), 2초 후 페이드아웃
- [ ] 성장 데이터 입력 시 안심 메시지 "건강하게 자라고 있어요" 표시 (softGreen 아이콘 포함)
- [ ] ValueKey: `growth_expansion_tile`, `growth_weight_field`, `growth_height_field`, `growth_head_field`, `growth_reassurance_msg`

### 4-9. 부모 메모 입력 카드 검증

- [ ] 카드 상단에 이모지 + "오늘의 메모 (선택)" 레이블 (headlineSmall / H3)
- [ ] TextField: 다중 줄 (높이 120dp), 플레이스홀더 "오늘 아기의 특별한 순간을 기록해보세요" (mutedBeige)
- [ ] 필드 배경 `#FFFFFF`, 테두리 lightBeige 1px, 포커스 시 warmOrange 2px, 모서리 12dp
- [ ] 포커스 해제 또는 일정 시간(debounce 1초) 후 자동 저장
- [ ] 저장 후 인라인 "저장됨" 표시, 2초 후 페이드아웃
- [ ] ValueKey: `memo_input_card`, `memo_text_field`, `memo_save_indicator`

### 4-10. 하단 버튼 쌍 검증

- [ ] 2개 버튼 수평 배치 (Row + Expanded), 간격 8dp
- [ ] 좌측: "성장곡선 보기" (OutlinedButton 스타일, 테두리 warmOrange, 텍스트 warmOrange)
- [ ] 우측: "기록 히스토리" (OutlinedButton 스타일 또는 채움)
- [ ] 각 버튼 높이: 48dp, 모서리 12dp
- [ ] 좌측 버튼 탭 시 GrowthChartScreen으로 이동 (GoRouter push `/record/growth-chart`)
- [ ] 우측 버튼 탭 시 RecordHistoryScreen으로 이동 (GoRouter push `/record/history`)
- [ ] 버튼 하단에 "모든 입력은 자동 저장됩니다" 안내 텍스트 (bodySmall / Caption, warmGray, 중앙)
- [ ] ValueKey: `growth_chart_btn`, `record_history_btn`, `auto_save_notice`

### 4-11. 자동 저장 피드백 검증

- [ ] 수유/배변 카운터 +/- 탭 시: "저장됨" 토스트 표시 (디자인컴포넌트 2-6-2: darkBrown 80% 배경, white 텍스트, 모서리 8dp, 1초 표시)
- [ ] 수면 시간 입력 시: 인라인 "저장됨" 표시 (디자인컴포넌트 2-6-3: Small 11sp, softGreen, 2초 후 페이드아웃 0.5초)
- [ ] 성장 데이터 각 필드 입력 시: 인라인 "저장됨" 표시
- [ ] 메모 입력 시: 인라인 "저장됨" 표시
- [ ] 별도 "저장" 버튼 없음 -- 모든 입력은 변경 즉시 자동 저장

### 4-12. GrowthChartScreen 검증

- [ ] AppBar: 좌측 뒤로가기 화살표 + "성장 곡선" 타이틀 (변형 B)
- [ ] 뒤로가기 탭 시 RecordMainScreen으로 복귀
- [ ] 상단에 안심 메시지 카드: mintTint 배경(`#F0F9F0`), 패딩 24dp, 모서리 16dp
  - softGreen 아이콘 (24dp) + "정상 범위 안에서 잘 자라고 있어요" (headlineLarge / H1, 22sp, SemiBold, 중앙)
  - 데이터 없을 때: "기록이 쌓이면 성장 곡선을 보여드릴게요" 안내
- [ ] TabBar: [체중] [키] [머리둘레] 3개 탭
  - 선택 탭: warmOrange 텍스트 + warmOrange 밑줄 (indicatorColor)
  - 비선택 탭: warmGray 텍스트
- [ ] 각 탭의 그래프 영역:
  - 크기: 화면 너비 - 32dp, 높이 240dp
  - X축: 주차 또는 날짜 (DataSmall, 12sp)
  - Y축: 단위(kg/cm) (DataSmall, 12sp)
  - WHO 표준 범위 밴드: growthBand(`#7BC67E33`) -- 15th~85th 퍼센타일 영역
  - 밴드 레이블: "낮은 편", "보통", "높은 편" (DataSmall, 12sp, warmGray)
  - 아기 데이터 점: warmOrange 직경 8dp, 선 warmOrange 2px
  - 퍼센타일 숫자는 표시하지 않음 (숫자보다 말로)
  - 범례: 하단에 "우리 아기 측정값", "표준 범위" (bodySmall / Caption, 13sp)
- [ ] 그래프 아래 "최근 기록" 리스트:
  - 각 항목: 날짜 + 값 + 변화 방향 아이콘 ("늘었어요" / "비슷해요")
  - 변화 방향: 이전 값 대비 증가 시 "늘었어요" (softGreen), 유사 시 "비슷해요" (warmGray)
- [ ] 데이터가 없을 때: 빈 상태 처리 (그래프 영역에 안내 메시지)
- [ ] ValueKey: `growth_chart_screen`, `growth_chart_tab_weight`, `growth_chart_tab_height`, `growth_chart_tab_head`, `growth_chart_graph`, `growth_reassurance_card`, `recent_growth_list`

### 4-13. RecordHistoryScreen 검증

- [ ] AppBar: 좌측 뒤로가기 화살표 + "기록 히스토리" 타이틀 (변형 B)
- [ ] 뒤로가기 탭 시 RecordMainScreen으로 복귀
- [ ] 타임라인 형태의 날짜별 기록 카드 리스트 (ListView.builder 또는 ListView.separated)
- [ ] 각 카드 (디자인컴포넌트 2-2-4):
  - 날짜 헤더: 카드 바깥 상단 (headlineSmall / H3, 16sp, darkBrown), "3월 25일 (오늘)"
  - 카드 내부: 이모지 + 레이블 + 값 (bodyLarge / Body1, 15sp) 여러 줄
  - 카드 배경: `#FFFFFF`, 모서리 12dp, 패딩 12dp
  - 구분선: lightBeige 1px (항목 사이)
  - 수유 0회, 배변 0회인 항목도 표시 (기록이 있는 날만 카드 표시)
  - 수면 시간이 null이면 해당 줄 미표시
  - 메모가 있으면 메모도 표시
- [ ] 기록이 없는 날은 카드 자체를 표시하지 않음 (건너뜀 -- 죄책감 없음)
- [ ] 무한 스크롤: 하단 도달 시 과거 기록 추가 로드 (페이징)
- [ ] **빈 상태 (데이터 없을 때)**: EmptyStateCard 표시 -- "아직 기록이 없어요. 기록 탭에서 첫 기록을 시작해보세요." (bodyLarge / Body1, warmGray, 중앙)
- [ ] ValueKey: `record_history_screen`, `record_history_list`, `record_history_empty`, `record_card_{date}` (날짜별 카드 키)

### 4-14. GoRouter 라우트 검증

- [ ] `/record/growth-chart` 경로로 GrowthChartScreen에 접근 가능
- [ ] `/record/history` 경로로 RecordHistoryScreen에 접근 가능
- [ ] 두 화면 모두 탭 바 위에 push (탭 바 숨김)
- [ ] 뒤로가기(시스템 백 버튼 또는 AppBar 뒤로가기)로 RecordMainScreen 복귀

### 4-15. 데이터 흐름 검증

- [ ] 기록 탭에서 수유 +1 시 DailyRecord.feedingCount가 DB에 반영됨
- [ ] 기록 탭에서 수유 -1 시 DailyRecord.feedingCount가 DB에 반영됨 (최소 0 보장)
- [ ] 기록 탭에서 배변 +/-1도 동일하게 DB 반영
- [ ] 수면 시간 입력 시 DailyRecord.sleepHours가 DB에 반영됨
- [ ] 메모 입력 시 DailyRecord.memo가 DB에 반영됨
- [ ] 성장 데이터 입력 시 GrowthRecord가 DB에 삽입/업데이트됨
- [ ] 홈 화면의 수유/배변 카운트와 기록 탭의 수유/배변 카운트가 동일 DailyRecord를 참조하여 값이 동기화됨 (홈에서 +1 후 기록 탭 진입 시 증가된 값 표시)
- [ ] 날짜 스와이프로 과거 날짜 선택 시 해당 날짜의 DailyRecord가 표시됨
- [ ] 성장 곡선에서 전체 GrowthRecord 이력이 그래프에 표시됨
- [ ] 기록 히스토리에서 DailyRecord 목록이 최신순으로 표시됨

### 4-16. UX 원칙 검증

- [ ] **"하나만 해도 충분하다"**: 아무 항목 1개(수유 or 배변 +1)만 입력해도 오늘 기록 완료 인정. "전부 채워야 한다"는 메시지 없음. 성장 기록은 접힘 상태로 시작하여 빈 필드 노출 방지.
- [ ] **숫자보다 말로 안심**: 성장 곡선에서 퍼센타일 숫자 없음. "정상 범위 안에서 잘 자라고 있어요" 안심 메시지가 그래프보다 먼저 표시됨. 성장 입력 시 "건강하게 자라고 있어요" 안심 메시지 표시.
- [ ] **전문 용어 없음**: "퍼센타일", "WHO Growth Standards" 등 전문 용어 미표시. 대신 "표준 범위", "낮은 편/보통/높은 편" 부모 언어 사용. 전문 용어가 필요한 곳은 InfoTerm 위젯 적용.
- [ ] **한 손 30초 완료**: 수유/배변은 원탭(+1/-1)으로 동작. 수면은 탭 1번 -> 피커 선택 -> 완료. 키보드 입력은 성장 데이터/메모에만 사용 (선택 항목). 모든 터치 영역 48x48dp 이상.
- [ ] **죄책감 유발 요소 없음**: "미완료" 표시 없음. 기록 히스토리에서 기록 없는 날 건너뜀. 빈 상태 메시지 긍정적 톤. 성장 기록 접힘으로 빈 필드 미노출. "모든 입력은 자동 저장됩니다" 안내로 부담 감소.

### 4-17. 디자인 검증

- [ ] Scaffold 배경색이 `Theme.of(context).scaffoldBackgroundColor` 사용 (라이트: cream `#FFF8F0`, 다크: `#1A1512`)
- [ ] 카드 배경이 `Theme.of(context).cardColor` 사용 (라이트: white, 다크: `#2A231D`)
- [ ] 모든 텍스트 스타일이 `Theme.of(context).textTheme.xxx` 사용 (직접 스타일 하드코딩 금지)
- [ ] 색상 참조 시 하드코딩 대신 Theme.colorScheme 또는 AppColors 상수 사용
- [ ] 카운터 버튼 색상: paleCream 배경, 눌림 시 warmOrange
- [ ] 안심 메시지 카드: mintTint(`#F0F9F0`) 배경, softGreen 아이콘
- [ ] 성장 곡선 밴드: growthBand(`#7BC67E33`)
- [ ] "저장됨" 토스트: darkBrown 80% 배경, white 텍스트 -- 기존 `showSavedToast` 재사용
- [ ] 인라인 "저장됨": Small(11sp), softGreen -- 새 InlineSaveIndicator 위젯
- [ ] 다크 모드에서 텍스트, 배경, 카드, 버튼 색상이 정상 전환됨
- [ ] 조부모 모드 대응: ThemeData 적용 시 글자 크기 +4sp (grandparent_theme.dart 활용)
- [ ] 각 카드 모서리 둥글기: 12dp (AppRadius.md)
- [ ] 확장 타일 접힘 배경: paleCream, 모서리 12dp

### 4-18. 접근성 검증

- [ ] 모든 탭 가능한 영역의 최소 크기가 48x48dp (카운터 +/- 버튼, 날짜 화살표, 시간 피커, 하단 버튼 등)
- [ ] 카운터 +/- 탭 시 `HapticFeedback.lightImpact()` 진동 피드백 (무음 모드 대응)
- [ ] 빈 상태(empty state): RecordHistoryScreen에서 기록 없을 때 EmptyStateCard 정상 표시
- [ ] 성장 곡선에서 데이터 없을 때 빈 상태 처리
- [ ] 아기가 등록되지 않은 극단적 상태에서 크래시 없이 처리

### 4-19. ValueKey 전체 목록 (Marionette MCP 테스트용)

| 위젯 | ValueKey |
|---|---|
| RecordMainScreen | `record_main_screen` |
| 기록 스크롤 뷰 | `record_scroll_view` |
| 날짜 스와이프 헤더 | `date_swipe_header` |
| 날짜 이전 버튼 | `date_prev_btn` |
| 날짜 다음 버튼 | `date_next_btn` |
| 날짜 레이블 | `date_label` |
| 수유 카운터 카드 | `feeding_counter_card` |
| 수유 카운트 텍스트 | `feeding_count` |
| 수유 + 버튼 | `feeding_plus_btn` |
| 수유 - 버튼 | `feeding_minus_btn` |
| 배변 카운터 카드 | `diaper_counter_card` |
| 배변 카운트 텍스트 | `diaper_count` |
| 배변 + 버튼 | `diaper_plus_btn` |
| 배변 - 버튼 | `diaper_minus_btn` |
| 수면 입력 카드 | `sleep_input_card` |
| 수면 값 텍스트 | `sleep_value` |
| 수면 저장 인디케이터 | `sleep_save_indicator` |
| 성장 기록 확장 타일 | `growth_expansion_tile` |
| 체중 입력 필드 | `growth_weight_field` |
| 키 입력 필드 | `growth_height_field` |
| 머리둘레 입력 필드 | `growth_head_field` |
| 성장 안심 메시지 | `growth_reassurance_msg` |
| 메모 입력 카드 | `memo_input_card` |
| 메모 텍스트 필드 | `memo_text_field` |
| 메모 저장 인디케이터 | `memo_save_indicator` |
| 성장곡선 보기 버튼 | `growth_chart_btn` |
| 기록 히스토리 버튼 | `record_history_btn` |
| 자동 저장 안내 | `auto_save_notice` |
| GrowthChartScreen | `growth_chart_screen` |
| 성장 곡선 안심 카드 | `growth_reassurance_card` |
| 체중 탭 | `growth_chart_tab_weight` |
| 키 탭 | `growth_chart_tab_height` |
| 머리둘레 탭 | `growth_chart_tab_head` |
| 성장 곡선 그래프 | `growth_chart_graph` |
| 최근 성장 기록 리스트 | `recent_growth_list` |
| RecordHistoryScreen | `record_history_screen` |
| 히스토리 리스트 | `record_history_list` |
| 히스토리 빈 상태 | `record_history_empty` |
| 히스토리 날짜별 카드 | `record_card_{yyyy-MM-dd}` |

---

## 5. 구현 가이드 (Generator용)

### 5-1. RecordMainScreen 구조

```
RecordMainScreen (Scaffold)
  +- AppBar (변형 A: "기록" 타이틀, 엘리베이션 0)
  +- body: SingleChildScrollView
       +- Padding(horizontal: 16)
            +- Column
                 +- DateSwipeHeader  (날짜 스와이프)
                 +- SizedBox(h: 12)
                 +- CounterCard(label: "수유", emoji: ..., type: feeding)
                 +- SizedBox(h: 12)
                 +- CounterCard(label: "배변", emoji: ..., type: diaper)
                 +- SizedBox(h: 12)
                 +- SleepInputCard
                 +- SizedBox(h: 12)
                 +- GrowthExpansionTile
                 +- SizedBox(h: 12)
                 +- MemoInputCard
                 +- SizedBox(h: 16)
                 +- HalfButtonPair(left: "성장곡선 보기", right: "기록 히스토리")
                 +- SizedBox(h: 8)
                 +- Text("모든 입력은 자동 저장됩니다")  // Caption, warmGray, 중앙
                 +- SizedBox(h: 24)
```

### 5-2. 날짜 스와이프 헤더 구현

- `selectedDateProvider`를 StateProvider로 정의 (초기값: today)
- DateSwipeHeader 위젯에서 `ref.watch(selectedDateProvider)`로 현재 날짜 표시
- 화살표 버튼 또는 스와이프 제스처로 날짜 변경 시 `ref.read(selectedDateProvider.notifier).state = newDate`
- 오늘 날짜일 때 우측 화살표 비활성 (opacity 0.3, onTap: null)
- 날짜 텍스트 형식: `DateFormat('yyyy년 M월 d일', 'ko_KR').format(date)` + (오늘이면 " (오늘)")

### 5-3. 카운터 버튼 구현 (CounterCard)

재사용 가능한 카운터 카드 위젯. 수유/배변에 동일 위젯 사용.

```dart
class CounterCard extends StatelessWidget {
  final String label;       // "수유" or "배변"
  final String emoji;       // 이모지 또는 아이콘
  final int count;          // 현재 카운트
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueKey<String> cardKey;
  final ValueKey<String> countKey;
  final ValueKey<String> plusKey;
  final ValueKey<String> minusKey;
}
```

- scale-up 애니메이션: `AnimatedScale` 또는 `ScaleTransition` (1.0 -> 1.2 -> 1.0, 150ms)
- 0일 때 - 버튼: `AppColors.mutedBeige` 색상, onTap null
- +/- 탭 시 `showSavedToast(context)` 호출 (기존 위젯 재사용)
- +/- 탭 시 `HapticFeedback.lightImpact()` 호출

### 5-4. 인라인 저장 인디케이터 구현 (InlineSaveIndicator)

새 공유 위젯. 수면/성장/메모에서 사용.

```dart
class InlineSaveIndicator extends StatefulWidget {
  /// true로 설정하면 "저장됨" 표시 후 2초 뒤 페이드아웃
  final bool show;
  final ValueKey<String>? indicatorKey;
}
```

- 표시: "저장됨" (labelSmall / Small, 11sp, softGreen) -- 텍스트에 체크 유니코드 포함
- 애니메이션: 즉시 표시 -> 2초 유지 -> 페이드아웃 0.5초 (`AnimatedOpacity`)
- 위치: 입력 필드 우측 하단 (위젯 외부에서 배치 결정)

### 5-5. 성장 곡선 차트 구현 (fl_chart)

`LineChart` (fl_chart 패키지)를 사용한다.

- WHO 표준 범위 밴드: `BetweenBarsData` 또는 `AreaData`로 15th~85th 퍼센타일 영역을 growthBand 색으로 채움
- WHO 데이터는 하드코딩된 Dart 상수로 제공 (이 스프린트에서는 체중 0~12주 샘플 데이터만 준비)
- 아기 데이터: FlSpot 리스트로 변환하여 표시
- 레이블: "낮은 편", "보통", "높은 편"을 그래프 우측 또는 밴드 영역에 텍스트로 표시

**WHO 표준 범위 데이터 (샘플):**

성장 곡선에 사용할 WHO 참조 데이터는 `lib/data/seed/who_growth_data.dart`로 별도 파일에 상수로 관리한다. 이 스프린트에서는 체중(0~12주), 키(0~12주), 머리둘레(0~12주)의 15th/50th/85th 퍼센타일 샘플값을 포함한다.

### 5-6. 반으로 나눈 버튼 쌍 구현 (HalfButtonPair)

새 공유 위젯.

```dart
class HalfButtonPair extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final VoidCallback? onLeftTap;
  final VoidCallback? onRightTap;
  final ValueKey<String>? leftKey;
  final ValueKey<String>? rightKey;
}
```

- Row + Expanded + OutlinedButton/ElevatedButton
- 높이: 48dp, 간격: 8dp, 모서리: 12dp
- 좌측: OutlinedButton (테두리 warmOrange, 텍스트 warmOrange)
- 우측: OutlinedButton (테두리 warmOrange, 텍스트 warmOrange)

### 5-7. 안심 메시지 카드 구현 (ReassuranceCard)

새 공유 위젯. 성장 곡선, 관찰 결과 등에서 재사용.

```dart
class ReassuranceCard extends StatelessWidget {
  final String message;        // 메인 메시지
  final String? subMessage;    // 서브 메시지 (선택)
  final ValueKey<String>? cardKey;
}
```

- 배경: mintTint(`#F0F9F0`), 모서리 16dp, 패딩 24dp
- 상단 중앙: softGreen 아이콘 24dp (Icons.check_circle 또는 유사)
- 메인 텍스트: headlineLarge / H1 (22sp, SemiBold), 중앙 정렬
- 서브 텍스트: bodyLarge / Body1 (15sp, warmGray), 중앙 정렬, 상단 8dp

### 5-8. AppStrings 추가 항목

```dart
// -- 기록 탭 --
static const recordTitle = '기록';
static const recordSubtitle = '우리 아이 하루 기록';
static const feedingLabel = '수유';
static const diaperLabel = '배변';
static const sleepLabel = '수면';
static const sleepPlaceholder = '탭해서 입력';
static String sleepValue(int hours, int minutes) => '${hours}시간 ${minutes}분';
static const growthAddLabel = '성장 기록 추가하기 +';
static String growthTodayCompact(String weight, String height) =>
    '오늘 측정: ${weight}kg, ${height}cm';
static const weightUnit = 'kg';
static const heightUnit = 'cm';
static const headCircumUnit = 'cm';
static const memoLabel = '오늘의 메모 (선택)';
static const memoPlaceholder = '오늘 아기의 특별한 순간을 기록해보세요';
static const growthChartButton = '성장곡선 보기';
static const recordHistoryButton = '기록 히스토리';
static const autoSaveNotice = '모든 입력은 자동 저장됩니다';
static const today = '오늘';
static const countSuffix = '회';
static const counterWarning = '정말 맞나요? 한 번 확인해 주세요';
static const savedInline = '\u2713 저장됨';

// -- 성장 곡선 --
static const growthChartTitle = '성장 곡선';
static const growthReassuranceChart = '정상 범위 안에서 잘 자라고 있어요';
static const growthEmptyChart = '기록이 쌓이면 성장 곡선을 보여드릴게요';
static const growthTabWeight = '체중';
static const growthTabHeight = '키';
static const growthTabHead = '머리둘레';
static const growthLabelLow = '낮은 편';
static const growthLabelNormal = '보통';
static const growthLabelHigh = '높은 편';
static const growthLegendBaby = '우리 아기 측정값';
static const growthLegendStandard = '표준 범위';
static const growthRecentTitle = '최근 기록';
static const growthIncreased = '늘었어요';
static const growthSame = '비슷해요';

// -- 기록 히스토리 --
static const recordHistoryTitle = '기록 히스토리';
```

### 5-9. 텍스트 스타일 규칙 (Sprint 03과 동일)

| 디자인 토큰 | Theme.textTheme 매핑 |
|---|---|
| Display (28sp) | `displayLarge` |
| H1 (22sp) | `headlineLarge` |
| H2 (18sp) | `headlineMedium` |
| H3 (16sp) | `headlineSmall` |
| Body1 (15sp) | `bodyLarge` |
| Body2 (14sp) | `bodyMedium` |
| Caption (13sp) | `bodySmall` |
| Button (16sp) | `labelLarge` |
| ButtonSmall (14sp) | `labelMedium` |
| Small (11sp) | `labelSmall` |
| Data (32sp) | `displayMedium` (또는 커스텀 -- 카운터 숫자용) |

**금지:** AppTextStyles 직접 참조. 항상 `Theme.of(context).textTheme.xxx` 사용.

### 5-10. 색상 규칙 (Sprint 03과 동일)

- Scaffold 배경: `Theme.of(context).scaffoldBackgroundColor`
- 카드 배경: `Theme.of(context).cardColor`
- 포인트 색상: `Theme.of(context).colorScheme.primary` (warmOrange)
- 긍정/안심 색상: `Theme.of(context).colorScheme.secondary` (softGreen)
- 텍스트 주색상: `Theme.of(context).colorScheme.onSurface`
- 비활성: `AppColors.mutedBeige`
- 성장 밴드: `AppColors.growthBand` (직접 사용 -- 차트 전용)
- 안심 카드 배경: `AppColors.mintTint` (직접 사용)

### 5-11. GoRouter 라우트 추가

```dart
// 하위 화면 (탭 바 위에 push)
GoRoute(
  path: '/record/growth-chart',
  builder: (_, __) => const GrowthChartScreen(),
),
GoRoute(
  path: '/record/history',
  builder: (_, __) => const RecordHistoryScreen(),
),
```

### 5-12. WHO 성장 데이터 시드 파일

```
lib/data/seed/who_growth_data.dart
```

체중/키/머리둘레의 15th, 50th, 85th 퍼센타일 값을 주 단위(0~12주)로 정의한다. 이 스프린트에서는 0~12주 남아 기준 샘플 데이터만 포함한다. 향후 성별 분리 및 전체 월령 확장 가능.

---

## 6. 의존성

### 이전 스프린트 의존

| 스프린트 | 산출물 | 이 스프린트에서 사용 |
|---|---|---|
| Sprint 01 | AppColors, AppTextStyles, AppDimensions, AppShadows, AppRadius, AppTheme (light/dark), DatabaseHelper, Tables, GoRouter, PrimaryCtaButton | 전체 |
| Sprint 02 | 온보딩 4화면, Baby 모델, BabyDao, activeBabyProvider, AppSettingsService, MainShell, AppStrings, WeekCalculator, WeekContentSeed, InfoTerm, GrandparentTheme | 전체 |
| Sprint 03 | HomeScreen, DailyRecord 모델, DailyRecordDao (insert/update/getTodayRecord/getByDate), GrowthRecord 모델, GrowthRecordDao (getLatestRecord), TodayRecordNotifier (incrementFeeding/incrementDiaper), todayRecordProvider, latestGrowthProvider, Activity 모델, activity seed, EmptyStateCard, TextLinkButton, SavedToast | 직접 재사용/확장 |

### 필요 패키지

| 패키지 | 버전 | 용도 | 비고 |
|---|---|---|---|
| `flutter_riverpod` | ^2.5.0 | Provider 상태 관리 | Sprint 01에서 설치 완료 |
| `go_router` | ^14.0.0 | 라우팅 | Sprint 01에서 설치 완료 |
| `sqflite` | ^2.4.0 | 로컬 DB | Sprint 01에서 설치 완료 |
| `fl_chart` | ^0.68.0 | 성장 곡선 LineChart | Sprint 03에서 설치 완료 (레이더 차트용으로 추가됨) |
| `intl` | ^0.19.0 | 날짜 포맷 (DateFormat) | Sprint 01 또는 02에서 설치 완료 확인. 없으면 추가 |

### 다음 스프린트와의 관계

- **Sprint 05+ (활동 탭):** 기록 탭과 독립적. 이 스프린트의 DailyRecord/GrowthRecord 인프라를 공유.
- **Sprint 06+ (발달 체크):** 기록 탭과 독립적.
- **향후 확장:** WHO 성장 데이터를 성별 분리(남/여), 전체 월령(0~60개월)으로 확장. 주간/월간 뷰 전환. 성장 곡선에서 직접 기록 입력.
