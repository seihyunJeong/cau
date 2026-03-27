# Sprint 07: 발달 체크 탭 (3개 화면)

## 1. 구현 범위

### 대상 화면/기능

- **DevCheckMainScreen** (탭 4: 발달 메인) (개발기획서 섹션 5-6)
  - 상태 기반 단일 CTA 설계 (메뉴 리스트 대신)
  - **State A -- 이번 주 체크 안 한 경우:**
    - 주차 정보 카드 (2-2-12): 주차 레이블 + 테마 제목
    - "이 시기 아기는..." 요약 3줄 (시드 데이터 keyPoints에서 가져옴)
    - 메인 CTA 버튼: "이번 주 발달 살펴보기" (2-3-1)
    - 서브 링크: "지난 기록 보기 ->" (2-3-6)
    - 면책 문구: 화면 최하단에 Tiny(8sp) 회색 텍스트 한 줄
  - **State B -- 이번 주 체크 한 경우:**
    - 안심 메시지 카드 (2-2-7): 티어별 메시지
    - 레이더 차트 카드 (2-2-6): 6영역 시각화 (200x200dp)
    - 솔루션 메시지 영역: "이렇게 해보세요" + 솔루션 목록
    - 반 너비 버튼 쌍 (2-3-8): [다시 체크하기] [추이 보기]
    - 면책 문구: 화면 최하단에 Tiny(8sp) 회색 텍스트 한 줄
  - 최근 위험 신호 있으면 위험 신호 안내 배너 (2-6-4) 표시
  - 앱 바: 변형 A (홈 앱 바 스타일, 좌측 "발달", 우측에 현재 주차 표시)

- **ChecklistScreen** (발달 체크리스트) (개발기획서 섹션 5-6, 화면 4-1)
  - 6개 영역 x 3문항 = 18문항 (각 0~4점 5단계 선택, ScoreSelector)
  - 점수 기준: 첫 번째 문항 옆에 (?) 아이콘 -> 탭하면 BottomSheet로 점수 기준 설명 (2-6-5)
  - 각 문항에 메모란 (선택, 접힌 상태, ExpansionTile 2-4-6)
  - 중간 저장 자동 (SharedPreferences JSON 임시 저장, 빠른 이탈 대응)
  - 진행률: 프로그레스 바(2-5-6) + "천천히 살펴보세요" 레이블 (숫자 없음)
  - 영역 헤더에 영역명만 표시 (카운터 없음)
  - 하단 고정 [결과 보기] CTA 버튼 (2-3-7 + 2-3-1)
  - **"결과 보기" 탭 후 -- 위험 신호 선택 단계 (별도 화면/페이지로 분리):**
    - "한 가지만 더 확인할게요 (선택)" 제목
    - 위험 신호 6항목 체크박스 (2-4-7, 2-2-11)
    - 1개 이상 체크 시 위험 신호 안내 배너 (2-6-4) 표시
    - 메모 필드 (선택, 2-4-5)
    - 반 너비 버튼 쌍 (2-3-8): [건너뛰기] [결과 보기]
  - 앱 바: 변형 B (뒤로가기 + "이번 주 발달 살펴보기")

- **ChecklistResultScreen** (발달 체크 결과) (개발기획서 섹션 5-6, 화면 4-2)
  - 안심 메시지 카드 (2-2-7): 티어별 메인 안심 메시지만 크게 표시
  - 퍼센트/총점 숫자 완전 제거 (UX 원칙 2: 숫자보다 말로)
  - 영역별 살펴보기 섹션:
    - 레이더 차트 카드 (2-2-6, 2-5-1): 6영역 200x200dp
    - 체크리스트 영역 카드 (2-2-9): 영역명 + 영역 메시지 + 채워진 도트 인디케이터 (2-5-4)
    - 이전 주차 기록 있으면 추이 변화 텍스트 표시 ("좋아지고 있어요" 등)
  - 솔루션 메시지 영역: "이렇게 해보세요" + 솔루션 목록
  - [홈으로 돌아가기] CTA 버튼 (2-3-1)
  - 결과 자동 저장 (ChecklistRecord -> sqflite)
  - 앱 바: 변형 B (뒤로가기 + "오늘의 관찰 결과")

- **TrendScreen** (발달 추이) (개발기획서 섹션 5-6, 화면 4-3)
  - 상단 탭: [주간] [월간] 전환 (2-3-5 변형 C)
  - 안심 메시지: "변화의 흐름을 살펴보세요"
  - 전체 추이 라인 차트 (2-5-3): Y축 "낮음/보통/높음" 질적 레이블 (숫자 제거)
  - 비교 메시지: "좋아지고 있어요" 텍스트 (퍼센트 대신)
  - 영역별 추이: 칩으로 영역 선택 -> 해당 영역 추이 그래프
  - 데이터 없으면 빈 상태 카드 (2-2-8) 표시
  - 앱 바: 변형 D (탭 포함, "발달 추이")

### 추가 구현 (인프라 확장)

- **ChecklistItem 모델** -- `lib/data/models/checklist_item.dart` (개발기획서 섹션 8-3)
- **DangerSignItem 모델** -- `lib/data/models/danger_sign_item.dart` (개발기획서 섹션 8-4)
- **ChecklistRecord 모델** -- `lib/data/models/checklist_record.dart` (개발기획서 섹션 4-2)
- **DangerSignRecord 모델** -- `lib/data/models/danger_sign_record.dart` (개발기획서 섹션 4-2)
- **ChecklistRecordDao** -- `lib/data/database/daos/checklist_record_dao.dart` (개발기획서 섹션 4-5)
- **DangerSignRecordDao** -- `lib/data/database/daos/danger_sign_record_dao.dart` (개발기획서 섹션 4-5)
- **checklist_seed.dart** -- 0-1주차 체크리스트 18문항 시드 데이터 (개발기획서 섹션 8-8)
- **danger_signs_seed.dart** -- 0-1주차 위험 신호 6항목 시드 데이터 (개발기획서 섹션 8-8)
- **ScoreCalculator** -- `lib/core/utils/score_calculator.dart` (개발기획서 섹션 6-2)
- **DangerSignAnalyzer** -- `lib/core/utils/danger_sign_analyzer.dart` (개발기획서 섹션 6-4)
- **checklist_providers.dart** -- ChecklistInProgress, LatestChecklistResult, ChecklistHistory Providers (개발기획서 섹션 9-2)
- **dev_check_providers.dart** -- DevCheckMain 상태 Provider (State A/B 분기)
- **danger_sign_providers.dart** -- 위험 신호 관련 Providers
- **ScoreSelector 위젯** -- `lib/core/widgets/score_selector.dart` (2-4-1)
- **FilledDotsIndicator 위젯** -- `lib/core/widgets/filled_dots_indicator.dart` (2-5-4)
- **RadarChartCard 위젯** -- `lib/features/dev_check/widgets/radar_chart_card.dart` (2-2-6, 2-5-1)
- **DomainScoreCard 위젯** -- `lib/features/dev_check/widgets/domain_score_card.dart` (2-2-9)
- **ChecklistItemTile 위젯** -- `lib/features/dev_check/widgets/checklist_item_tile.dart`
- **ResultMessageCard 위젯** -- `lib/features/dev_check/widgets/result_message_card.dart`
- **TrendChartCard 위젯** -- `lib/features/dev_check/widgets/trend_chart_card.dart`
- **DangerSignBanner 위젯** -- `lib/core/widgets/danger_sign_banner.dart` (2-6-4)
- **GoRouter 라우트 추가** -- `/dev-check/checklist`, `/dev-check/checklist/danger-signs`, `/dev-check/result`, `/dev-check/trend`
- **AppStrings 확장** -- 발달 체크 관련 모든 UI 텍스트 상수 추가
- **MainShell 수정** -- 탭 4(발달) 플레이스홀더를 DevCheckMainScreen으로 교체
- **tables.dart 수정** -- checklist_records, danger_sign_records CREATE TABLE 추가
- **database_helper.dart 수정** -- 새 테이블 생성 로직 추가

### 사용 디자인 컴포넌트

| 컴포넌트 번호 | 이름 | 사용 위치 |
|---|---|---|
| 2-1-1 | 하단 탭 바 | DevCheckMainScreen (탭 4 활성) |
| 2-1-2 | 앱 바 (변형 A) | DevCheckMainScreen |
| 2-1-2 | 앱 바 (변형 B) | ChecklistScreen, ChecklistResultScreen |
| 2-1-2 | 앱 바 (변형 D, 탭 포함) | TrendScreen |
| 2-2-6 | 레이더 차트 카드 | DevCheckMainScreen (State B), ChecklistResultScreen |
| 2-2-7 | 안심 메시지 카드 | DevCheckMainScreen (State B), ChecklistResultScreen, TrendScreen |
| 2-2-8 | 빈 상태 카드 | TrendScreen (데이터 없을 때) |
| 2-2-9 | 체크리스트 영역 카드 | ChecklistResultScreen |
| 2-2-11 | 위험 신호 카드 | ChecklistScreen (위험 신호 단계) |
| 2-2-12 | 주차 정보 카드 | DevCheckMainScreen (State A) |
| 2-3-1 | 기본 CTA 버튼 | DevCheckMainScreen, ChecklistScreen, ChecklistResultScreen |
| 2-3-2 | 보조 버튼 | ChecklistScreen (위험 신호 "건너뛰기") |
| 2-3-5 | 탭/칩 선택기 (변형 C) | TrendScreen (주간/월간, 영역 선택) |
| 2-3-6 | 텍스트 링크 버튼 | DevCheckMainScreen ("지난 기록 보기 ->") |
| 2-3-7 | 하단 고정 버튼 | ChecklistScreen ("결과 보기") |
| 2-3-8 | 반으로 나눈 버튼 쌍 | DevCheckMainScreen (State B), ChecklistScreen (위험 신호) |
| 2-4-1 | 점수 선택기 (0~4) | ChecklistScreen (18문항 각각) |
| 2-4-5 | 텍스트 입력 필드 | ChecklistScreen (메모), 위험 신호 (메모) |
| 2-4-6 | 확장 타일 | ChecklistScreen (메모 추가) |
| 2-4-7 | 체크박스 | ChecklistScreen (위험 신호 6항목) |
| 2-5-1 | 레이더 차트 | DevCheckMainScreen (State B), ChecklistResultScreen |
| 2-5-3 | 추이 라인 차트 | TrendScreen |
| 2-5-4 | 채워진 도트 인디케이터 | ChecklistResultScreen (영역별) |
| 2-5-6 | 프로그레스 바 | ChecklistScreen (진행률) |
| 2-6-1 | InfoTerm 툴팁 | DevCheckMainScreen (이 시기 아기 요약 내 전문 용어) |
| 2-6-4 | 위험 신호 안내 배너 | ChecklistScreen (위험 신호 단계), DevCheckMainScreen (최근 위험 신호) |
| 2-6-5 | 점수 기준 BottomSheet | ChecklistScreen (첫 문항 (?) 아이콘) |
| 2-7-1 | 스크롤 가능 페이지 + 하단 고정 버튼 | ChecklistScreen |
| 2-7-2 | 탭 바 페이지 | TrendScreen |

---

## 2. 파일 목록

### 신규 생성 파일

| # | 파일 경로 | 설명 |
|---|---|---|
| 1 | `lib/data/models/checklist_item.dart` | ChecklistItem 모델 (개발기획서 8-3) |
| 2 | `lib/data/models/danger_sign_item.dart` | DangerSignItem 모델 (개발기획서 8-4) |
| 3 | `lib/data/models/checklist_record.dart` | ChecklistRecord 모델 (개발기획서 4-2) |
| 4 | `lib/data/models/danger_sign_record.dart` | DangerSignRecord 모델 (개발기획서 4-2) |
| 5 | `lib/data/database/daos/checklist_record_dao.dart` | ChecklistRecordDao (CRUD + 추이 조회 + 최신 조회) |
| 6 | `lib/data/database/daos/danger_sign_record_dao.dart` | DangerSignRecordDao (CRUD + 최근 조회) |
| 7 | `lib/data/seed/checklist_seed.dart` | 0-1주차 체크리스트 18문항 시드 데이터 |
| 8 | `lib/data/seed/danger_signs_seed.dart` | 0-1주차 위험 신호 6항목 시드 데이터 |
| 9 | `lib/core/utils/score_calculator.dart` | ScoreCalculator (점수 계산 + 구간 매핑 + 안심 메시지) |
| 10 | `lib/core/utils/danger_sign_analyzer.dart` | DangerSignAnalyzer (연속 체크 패턴 분석) |
| 11 | `lib/providers/checklist_providers.dart` | ChecklistInProgress, LatestChecklistResult, ChecklistHistory |
| 12 | `lib/providers/dev_check_providers.dart` | DevCheck 메인 화면 상태 Provider (State A/B 분기) |
| 13 | `lib/providers/danger_sign_providers.dart` | DangerSignInProgress, LatestDangerSignRecord |
| 14 | `lib/core/widgets/score_selector.dart` | ScoreSelector 위젯 (0~4점 5버튼 수평 배치) |
| 15 | `lib/core/widgets/filled_dots_indicator.dart` | FilledDotsIndicator 위젯 (채워진 도트만 표시) |
| 16 | `lib/core/widgets/danger_sign_banner.dart` | DangerSignBanner 위젯 (softYellow 배경 안내 배너) |
| 17 | `lib/features/dev_check/screens/dev_check_main_screen.dart` | 발달 탭 메인 (State A/B) |
| 18 | `lib/features/dev_check/screens/checklist_screen.dart` | 체크리스트 18문항 폼 |
| 19 | `lib/features/dev_check/screens/danger_sign_screen.dart` | 위험 신호 선택 단계 (체크리스트 결과 보기 후) |
| 20 | `lib/features/dev_check/screens/checklist_result_screen.dart` | 체크리스트 결과 화면 |
| 21 | `lib/features/dev_check/screens/trend_screen.dart` | 주간/월간 추이 화면 |
| 22 | `lib/features/dev_check/widgets/radar_chart_card.dart` | 레이더 차트 카드 위젯 |
| 23 | `lib/features/dev_check/widgets/domain_score_card.dart` | 영역별 결과 카드 위젯 |
| 24 | `lib/features/dev_check/widgets/checklist_item_tile.dart` | 체크리스트 문항 타일 위젯 |
| 25 | `lib/features/dev_check/widgets/result_message_card.dart` | 솔루션 메시지 카드 위젯 |
| 26 | `lib/features/dev_check/widgets/trend_chart_card.dart` | 추이 라인 차트 카드 위젯 |
| 27 | `lib/features/dev_check/widgets/week_info_card.dart` | 주차 정보 카드 위젯 (State A용) |

### 수정할 기존 파일

| # | 파일 경로 | 수정 내용 |
|---|---|---|
| 1 | `lib/features/main_shell/main_shell.dart` | 탭 4(발달) 플레이스홀더를 `DevCheckMainScreen`으로 교체 |
| 2 | `lib/core/router/app_router.dart` | 발달 체크 하위 라우트 4개 추가 |
| 3 | `lib/core/constants/app_strings.dart` | 발달 체크 관련 UI 텍스트 상수 약 60개 추가 |
| 4 | `lib/data/database/tables.dart` | `createChecklistRecords`, `createDangerSignRecords` SQL 추가 |
| 5 | `lib/data/database/database_helper.dart` | `_createDB`에 새 테이블 2개 추가 |
| 6 | `lib/data/seed/week_content_seed.dart` | checklistItems, dangerSigns 필드 추가 (WeekContent 확장) |
| 7 | `lib/providers/core_providers.dart` | ChecklistRecordDao, DangerSignRecordDao Provider 추가 |

---

## 3. 데이터 모델

### 3-1. ChecklistItem (시드 데이터 모델, DB 저장 아님)

```
ChecklistItem {
  id: String              // "physical_0"
  domain: String           // 영역 ID (physical, sensory, cognitive, language, emotional, regulation)
  domainDisplayName: String // "몸 움직임"
  orderInDomain: int       // 영역 내 순서 (0, 1, 2)
  questionText: String     // 문항 텍스트 (부모 언어)
}
```

- 시드 데이터로 Dart 상수에 임베딩
- 6개 영역 x 3문항 = 18문항
- 점수 기준은 공통: 4=자주 안정적, 3=종종 보임, 2=가끔 보임, 1=드물게 보임, 0=거의 안 보임

### 3-2. DangerSignItem (시드 데이터 모델, DB 저장 아님)

```
DangerSignItem {
  id: String       // "danger_0"
  weekIndex: int   // 주차
  text: String     // 위험 신호 설명 (부모 언어)
}
```

- 0-1주차 6개 항목 시드 데이터

### 3-3. ChecklistRecord (sqflite 테이블: checklist_records)

```
checklist_records {
  id: INTEGER PRIMARY KEY AUTOINCREMENT
  baby_id: INTEGER NOT NULL REFERENCES babies(id)
  week_number: INTEGER NOT NULL
  date: TEXT NOT NULL
  responses: TEXT NOT NULL        -- JSON: {"physical_0": 3, "physical_1": 2, ...}
  memos: TEXT                     -- JSON: {"physical_0": "메모 텍스트", ...}
  total_score: INTEGER NOT NULL   -- 총점 (0~72)
  percentage: REAL NOT NULL       -- 퍼센트 (0~100)
  tier: INTEGER NOT NULL          -- 구간 (1~5)
  domain_scores: TEXT NOT NULL    -- JSON: {"physical": 10, "sensory": 8, ...}
  is_complete: INTEGER NOT NULL DEFAULT 0  -- 18문항 모두 완료 여부
  created_at: TEXT NOT NULL DEFAULT (datetime('now'))
}
```

### 3-4. DangerSignRecord (sqflite 테이블: danger_sign_records)

```
danger_sign_records {
  id: INTEGER PRIMARY KEY AUTOINCREMENT
  baby_id: INTEGER NOT NULL REFERENCES babies(id)
  week_number: INTEGER NOT NULL
  date: TEXT NOT NULL
  signs: TEXT NOT NULL            -- JSON: {"danger_0": true, "danger_1": false, ...}
  memo: TEXT
  has_any_sign: INTEGER NOT NULL DEFAULT 0  -- 1개 이상 체크 여부
  created_at: TEXT NOT NULL DEFAULT (datetime('now'))
}
```

### 3-5. Providers

| Provider 이름 | 유형 | 설명 |
|---|---|---|
| `checklistRecordDaoProvider` | Provider | ChecklistRecordDao 인스턴스 |
| `dangerSignRecordDaoProvider` | Provider | DangerSignRecordDao 인스턴스 |
| `checklistInProgressProvider` | Notifier | 현재 작성 중인 체크리스트 응답 Map<String,int> (중간 저장 지원) |
| `checklistMemosInProgressProvider` | Notifier | 현재 작성 중인 체크리스트 메모 Map<String,String> |
| `latestChecklistResultProvider` | FutureProvider | 이번 주차 최근 ChecklistRecord |
| `checklistHistoryProvider` | FutureProvider | 해당 아기의 전체 ChecklistRecord 목록 (추이용) |
| `dangerSignInProgressProvider` | Notifier | 현재 작성 중인 위험 신호 Map<String,bool> |
| `latestDangerSignProvider` | FutureProvider | 최근 DangerSignRecord |
| `devCheckStateProvider` | Provider | State A/B 분기 (latestChecklistResult 기반) |
| `currentChecklistItemsProvider` | Provider | 현재 주차 ChecklistItem 18문항 리스트 (시드 데이터) |
| `currentDangerSignItemsProvider` | Provider | 현재 주차 DangerSignItem 6항목 리스트 (시드 데이터) |

### 3-6. DAO 메서드

**ChecklistRecordDao:**
- `insert(ChecklistRecord)` -> int (insertedId)
- `getLatestByWeek(int babyId, int weekNumber)` -> ChecklistRecord? (이번 주 최근 결과)
- `getLatest(int babyId)` -> ChecklistRecord? (가장 최근 결과)
- `getAllByBabyId(int babyId)` -> List<ChecklistRecord> (전체 추이)
- `getPreviousRecord(int babyId, int weekNumber)` -> ChecklistRecord? (이전 주차 결과, 비교용)

**DangerSignRecordDao:**
- `insert(DangerSignRecord)` -> int
- `getLatest(int babyId)` -> DangerSignRecord?
- `getRecentRecords(int babyId, {int days = 7})` -> List<DangerSignRecord>

---

## 4. 검증 기준 (Evaluator용)

각 기준은 PASS/FAIL로 판정한다.

### 기능 검증 -- DevCheckMainScreen

- [ ] 이번 주 체크 기록이 없는 상태(State A)에서 앱 실행 시, DevCheckMainScreen에 주차 정보 카드("0-1주차", "신경이 안정되는 시간")가 표시된다
- [ ] State A에서 "이 시기 아기는..." 영역에 시드 데이터의 keyPoints 목록이 3줄 이상 표시된다
- [ ] State A에서 "이번 주 발달 살펴보기" CTA 버튼을 탭하면 ChecklistScreen으로 이동한다
- [ ] State A에서 "지난 기록 보기 ->" 텍스트 링크를 탭하면 TrendScreen으로 이동한다
- [ ] 이번 주 체크 기록이 있는 상태(State B)에서 DevCheckMainScreen에 안심 메시지 카드(mintTint 배경)가 표시되고, 메시지는 ScoreCalculator.getTierMessage() 결과와 일치한다
- [ ] State B에서 6영역 레이더 차트가 200x200dp 크기로 표시되고, 각 꼭짓점 레이블(몸 움직임, 감각 반응, 집중과 관심, 소리와 표현, 마음과 관계, 생활 리듬)이 표시된다
- [ ] State B에서 "이렇게 해보세요" 섹션에 ScoreCalculator.getSolutionMessages() 결과가 불릿 포인트로 표시된다
- [ ] State B에서 [다시 체크하기] 버튼 탭 시 ChecklistScreen으로 이동한다
- [ ] State B에서 [추이 보기] 버튼 탭 시 TrendScreen으로 이동한다
- [ ] 화면 최하단에 면책 문구 "관찰 기록용 도구이며 의학적 진단을 대체하지 않습니다"가 Tiny(8sp) warmGray로 표시된다
- [ ] 최근 위험 신호 기록(has_any_sign == true)이 있으면 softYellow 배경의 위험 신호 안내 배너가 표시된다

### 기능 검증 -- ChecklistScreen

- [ ] 화면 상단에 프로그레스 바가 표시되고, 응답 수에 비례하여 채워진다 (숫자 없음)
- [ ] 프로그레스 바 아래에 "천천히 살펴보세요" 레이블이 Caption(13sp, warmGray)으로 표시된다
- [ ] 6개 영역("몸 움직임", "감각 반응", "집중과 관심", "소리와 표현", "마음과 관계", "생활 리듬")이 섹션 헤더로 구분되어 표시된다
- [ ] 각 영역 아래 3문항이 표시되어 총 18문항이 모두 화면에 나타난다
- [ ] 각 문항에 [0] [1] [2] [3] [4] 버튼 5개가 수평으로 배치되고, 각 버튼의 최소 터치 영역이 48x40dp 이상이다
- [ ] 점수 버튼 탭 시 비선택 상태(paleCream 배경, darkBrown 텍스트)에서 선택 상태(warmOrange 배경, white 텍스트)로 변경된다
- [ ] 첫 번째 문항 옆 (?) 아이콘을 탭하면 점수 기준 BottomSheet가 표시되고, "4 = 자주 안정적 / 3 = 종종 보임 / 2 = 가끔 보임 / 1 = 드물게 보임 / 0 = 거의 안 보임" 5단계 설명이 표시된다
- [ ] 각 문항 아래 "메모 추가" 접힘 영역(ExpansionTile)이 있고, 펼치면 TextField가 나타난다
- [ ] 문항에 응답 후 앱을 종료하고 다시 진입하면, 이전 응답이 복원된다 (중간 저장)
- [ ] 하단 고정 [결과 보기] CTA 버튼이 스크롤과 무관하게 항상 화면 하단에 고정된다
- [ ] [결과 보기] 탭 시 위험 신호 선택 화면으로 이동한다
- [ ] 18문항을 모두 완료하지 않아도 [결과 보기] 버튼을 탭할 수 있다

### 기능 검증 -- 위험 신호 선택 단계

- [ ] "한 가지만 더 확인할게요 (선택)" 제목이 표시된다
- [ ] "아래 항목 중 관찰되는 것이 있다면 체크해 주세요. 해당 없으면 그냥 넘어가세요." 안내 문구가 표시된다
- [ ] 위험 신호 6항목이 체크박스 + 텍스트로 표시된다 (0-1주차 시드 데이터 기준)
- [ ] 체크박스 체크 시 warmOrange 배경 + white 체크 아이콘으로 표시된다
- [ ] 1개 이상 체크 시 softYellow 배경의 위험 신호 안내 배너가 "며칠 더 지켜본 뒤, 걱정이 계속되면 전문가와 이야기해 보세요." 메시지와 함께 표시된다
- [ ] 메모 필드(선택)가 제공된다
- [ ] [건너뛰기] 버튼 탭 시 위험 신호 기록 없이 ChecklistResultScreen으로 이동한다
- [ ] [결과 보기] 버튼 탭 시 위험 신호 기록 저장 후 ChecklistResultScreen으로 이동한다

### 기능 검증 -- ChecklistResultScreen

- [ ] 화면 상단에 안심 메시지 카드가 mintTint(#F0F9F0) 배경, softGreen 아이콘, H1(22sp) 텍스트로 표시된다
- [ ] 안심 메시지가 ScoreCalculator.getTierMessage(tier) 결과와 일치한다
- [ ] 숫자(총점, 퍼센트)가 화면 어디에도 표시되지 않는다
- [ ] 6영역 레이더 차트가 200x200dp로 표시되고, 데이터 영역이 warmOrange 20% 불투명으로 채워진다
- [ ] 6개 영역별 카드에 영역명, 영역 메시지(ScoreCalculator.getDomainMessage 결과), 채워진 도트 인디케이터가 표시된다
- [ ] 채워진 도트는 softGreen(#7BC67E)이고 빈 도트는 표시되지 않는다
- [ ] 이전 주차 기록이 있으면 해당 영역에 "좋아지고 있어요" 등 추이 변화 텍스트가 표시된다
- [ ] "이렇게 해보세요" 섹션에 솔루션 메시지가 불릿 포인트로 표시된다
- [ ] [홈으로 돌아가기] 버튼 탭 시 홈 화면으로 이동한다
- [ ] 결과 화면 진입 시 ChecklistRecord가 sqflite에 자동 저장된다

### 기능 검증 -- TrendScreen

- [ ] 상단에 [주간] [월간] 탭이 표시되고, 탭 전환 시 그래프가 변경된다
- [ ] "변화의 흐름을 살펴보세요" 안심 메시지가 표시된다
- [ ] 전체 추이 라인 차트의 Y축에 "낮음", "보통", "높음" 질적 레이블이 표시되고 숫자(20, 40, 60, 80, 100)가 표시되지 않는다
- [ ] 체크리스트 기록이 2개 이상이면 라인 차트에 데이터 포인트가 연결되어 표시된다
- [ ] 비교 메시지에 퍼센트 대신 "좋아지고 있어요" 등 텍스트가 사용된다
- [ ] 영역별 추이 섹션에 영역 칩([전체][몸][감각][집중][소리][마음][리듬])이 표시되고, 탭하면 해당 영역 추이 그래프가 표시된다
- [ ] 데이터가 없으면 빈 상태 카드(2-2-8)가 표시되고, 차트 영역에 친근한 안내 메시지가 나타난다

### 기능 검증 -- ScoreCalculator

- [ ] 18문항 모두 4점(최고)일 때 totalScore=72, percentage=100.0, tier=1이 반환된다
- [ ] 18문항 모두 0점일 때 totalScore=0, percentage=0.0, tier=5가 반환된다
- [ ] percentage 85 이상이면 tier=1, 70~84이면 tier=2, 55~69이면 tier=3, 40~54이면 tier=4, 0~39이면 tier=5가 반환된다
- [ ] calculateDomainScores가 6개 영역별로 정확한 합산 점수를 반환한다 (각 영역 최대 12점)
- [ ] getTierMessage(1~5)가 각각 비어있지 않은 안심 메시지를 반환한다
- [ ] getSolutionMessages(1~5)가 각각 1개 이상의 솔루션 문자열 목록을 반환한다
- [ ] getDomainMessage가 영역명을 포함한 부모 친화적 메시지를 반환한다

### 기능 검증 -- 중간 저장

- [ ] 체크리스트 응답을 5문항 입력 후 앱을 백그라운드로 보낸 후 다시 열면, 5문항의 응답이 그대로 유지된다
- [ ] 체크리스트 제출(submit) 후에는 중간 저장 데이터가 삭제된다
- [ ] 새로운 체크리스트를 시작하면 이전 중간 저장 데이터가 아닌 빈 상태에서 시작된다

### UX 원칙 검증

- [ ] **"하나만 해도 충분하다"**: DevCheckMainScreen State A에서 메인 CTA 1개만 크게 노출되고, 다른 기능(추이, 히스토리)은 서브 링크로만 제공된다
- [ ] **숫자보다 말로 안심시키는지**: ChecklistResultScreen에 총점/퍼센트 숫자가 노출되지 않고, 안심 메시지만 크게 H1으로 표시된다
- [ ] **숫자보다 말로 안심시키는지**: TrendScreen Y축에 숫자 퍼센트가 아닌 "낮음/보통/높음"이 표시된다
- [ ] **숫자보다 말로 안심시키는지**: 영역별 점수가 숫자가 아닌 채워진 도트(최대 4개) + 메시지("편안해 보여요")로 표시된다
- [ ] **전문 용어 대신 부모 언어**: 6개 영역명이 전문 용어(신체/성장, 감각/지각, 인지/주의, 언어/의사소통, 정서/사회, 조절/수면/생리)가 아닌 부모 언어(몸 움직임, 감각 반응, 집중과 관심, 소리와 표현, 마음과 관계, 생활 리듬)로 표시된다
- [ ] **전문 용어 대신 부모 언어**: 위험 신호 항목이 의학 용어 없이 부모가 이해할 수 있는 설명으로 표시된다
- [ ] **한 손 30초 완료**: 각 문항의 점수 선택 버튼이 최소 48x40dp이고, 탭 1번으로 선택 가능하다
- [ ] **한 손 30초 완료**: [결과 보기] 버튼이 화면 하단에 고정되어 스크롤 없이 접근 가능하다
- [ ] **죄책감 유발 요소 없음**: 18문항 미완료 시에도 "미완료" 경고나 빨간 표시 없이 [결과 보기] 버튼이 활성 상태이다
- [ ] **죄책감 유발 요소 없음**: 낮은 점수(tier 4~5)에서도 "주의", "경고", "위험" 등의 부정적 단어가 사용되지 않고, 안심 톤의 메시지가 표시된다
- [ ] **죄책감 유발 요소 없음**: 위험 신호 단계가 "선택"으로 표기되고, "건너뛰기" 버튼이 제공되며, 건너뛰어도 부정적 피드백이 없다

### 디자인 검증

- [ ] 전체 Scaffold 배경색이 cream(#FFF8F0)이다
- [ ] 카드 배경색이 white(#FFFFFF)이고, 모서리 둥글기가 12dp(일반) 또는 16dp(안심 메시지, 주차 정보)이다
- [ ] CTA 버튼이 warmOrange(#F5A623) 배경, white 텍스트, 24dp 모서리 둥글기이다
- [ ] 안심 메시지 카드가 mintTint(#F0F9F0) 배경, softGreen(#7BC67E) 아이콘, 16dp 모서리 둥글기, 24dp 패딩이다
- [ ] 레이더 차트 데이터 영역이 radarFill(#F5A62333) 채움, warmOrange(#F5A623) 2px 테두리이다
- [ ] 채워진 도트 인디케이터가 softGreen(#7BC67E) 8dp 원형, 4dp 간격이다
- [ ] 위험 신호 안내 배너가 softYellow 20% 불투명(#33FFD93D) 배경, 16dp 모서리 둥글기이다
- [ ] 프로그레스 바가 warmOrange(#F5A623) 채움, trackGray(#E8DDD0) 트랙, 4dp 높이이다
- [ ] 점수 기준 BottomSheet가 white 배경, 상단 16dp 모서리 둥글기, 24dp 패딩이다
- [ ] 모든 텍스트 스타일이 `Theme.of(context).textTheme`을 통해 적용되고, 하드코딩된 fontSize/Color가 없다
- [ ] 모든 간격/패딩이 AppDimensions 상수를 참조하고, 하드코딩된 EdgeInsets/SizedBox 값이 없다
- [ ] 모든 모서리 둥글기가 AppRadius 상수를 참조하고, 하드코딩된 BorderRadius 값이 없다
- [ ] 다크 모드에서 배경이 darkBg(#1A1512), 카드 배경이 darkCard(#2A231D), 텍스트가 darkTextPrimary(#F5EDE3)로 전환된다
- [ ] 조부모 모드에서 모든 텍스트가 +4sp 적용된다

### 접근성 검증

- [ ] 모든 버튼/탭 가능 요소의 최소 터치 영역이 48x48dp이다
- [ ] 무음 모드에서 점수 선택 시 `HapticFeedback.lightImpact()` 햅틱 피드백이 발생한다
- [ ] 빈 상태(체크리스트 기록 없을 때) TrendScreen에서 차트 대신 안내 메시지 카드가 표시된다
- [ ] 모든 상호작용 가능한 위젯에 ValueKey가 지정되어 있다
- [ ] 모든 한국어 텍스트가 AppStrings 상수를 통해 참조되고, 하드코딩된 한국어 문자열이 없다

### ValueKey 검증

다음 위젯에 ValueKey가 지정되어 있는지 확인한다:

- [ ] `ValueKey('dev_check_main_screen')` -- DevCheckMainScreen Scaffold
- [ ] `ValueKey('dev_check_state_a')` -- State A 컨테이너
- [ ] `ValueKey('dev_check_state_b')` -- State B 컨테이너
- [ ] `ValueKey('dev_check_cta_start')` -- "이번 주 발달 살펴보기" CTA 버튼
- [ ] `ValueKey('dev_check_trend_link')` -- "지난 기록 보기 ->" 텍스트 링크
- [ ] `ValueKey('dev_check_recheck_button')` -- "다시 체크하기" 버튼
- [ ] `ValueKey('dev_check_trend_button')` -- "추이 보기" 버튼
- [ ] `ValueKey('checklist_screen')` -- ChecklistScreen Scaffold
- [ ] `ValueKey('checklist_progress_bar')` -- 프로그레스 바
- [ ] `ValueKey('checklist_score_guide_button')` -- (?) 점수 기준 아이콘 버튼
- [ ] `ValueKey('checklist_item_$questionId')` -- 각 문항 타일 (questionId별 고유)
- [ ] `ValueKey('score_selector_$questionId')` -- 각 문항의 ScoreSelector
- [ ] `ValueKey('checklist_memo_$questionId')` -- 각 문항의 메모 ExpansionTile
- [ ] `ValueKey('checklist_submit_button')` -- "결과 보기" 하단 CTA 버튼
- [ ] `ValueKey('danger_sign_screen')` -- 위험 신호 화면 Scaffold
- [ ] `ValueKey('danger_sign_$signId')` -- 각 위험 신호 체크박스
- [ ] `ValueKey('danger_sign_skip_button')` -- "건너뛰기" 버튼
- [ ] `ValueKey('danger_sign_submit_button')` -- "결과 보기" 버튼
- [ ] `ValueKey('checklist_result_screen')` -- ChecklistResultScreen Scaffold
- [ ] `ValueKey('result_reassurance_card')` -- 안심 메시지 카드
- [ ] `ValueKey('result_radar_chart')` -- 레이더 차트
- [ ] `ValueKey('result_domain_$domain')` -- 각 영역별 결과 카드 (domain별 고유)
- [ ] `ValueKey('result_solution_section')` -- 솔루션 메시지 영역
- [ ] `ValueKey('result_go_home_button')` -- "홈으로 돌아가기" 버튼
- [ ] `ValueKey('trend_screen')` -- TrendScreen Scaffold
- [ ] `ValueKey('trend_tab_weekly')` -- 주간 탭
- [ ] `ValueKey('trend_tab_monthly')` -- 월간 탭
- [ ] `ValueKey('trend_overall_chart')` -- 전체 추이 차트
- [ ] `ValueKey('trend_domain_chip_$domain')` -- 영역 선택 칩 (domain별 고유)
- [ ] `ValueKey('trend_domain_chart')` -- 영역별 추이 차트

---

## 5. 의존성

### 이전 스프린트 의존

| 스프린트 | 필요 항목 |
|---|---|
| Sprint 01 (Setup) | Flutter 프로젝트, 테마, AppColors, AppTextStyles, AppDimensions, AppRadius, AppShadows, sqflite DatabaseHelper, tables.dart |
| Sprint 02 (Onboarding) | Baby 모델/DAO, BabyProvider, AppSettingsService, GoRouter 기본 구조 |
| Sprint 03 (Home) | MainShell (탭 바), HomeScreen, BabyProfileCard, ReassuranceCard, EmptyStateCard, TextLinkButton, HalfButtonPair |
| Sprint 04 (Record) | DailyRecord 모델/DAO, core_providers.dart |
| Sprint 05 (Activity) | Activity 시드 데이터, ActivityRecord 모델/DAO, WeekContent 구조, week_content_seed.dart |
| Sprint 06 (Observation) | InfoTerm 위젯, ObservationRecord 모델, AppStrings (기존 문자열들) |

### 필요한 패키지

| 패키지 | 버전 | 용도 | 이미 설치 여부 |
|---|---|---|---|
| `fl_chart` | ^0.68.0 | 레이더 차트 (RadarChart), 추이 라인 차트 (LineChart) | 설치됨 (Sprint 04에서 성장 곡선용) |
| `flutter_riverpod` | ^2.5.0 | 상태 관리 | 설치됨 |
| `go_router` | ^14.0.0 | 라우팅 | 설치됨 |
| `sqflite` | ^2.4.0 | 로컬 DB | 설치됨 |
| `shared_preferences` | ^2.2.0 | 중간 저장 (체크리스트 임시 데이터) | 설치됨 |
| `just_the_tooltip` | ^0.0.12 | InfoTerm 위젯 (전문 용어 설명) | 설치됨 |

### 참조 문서 섹션

| 문서 | 섹션 | 내용 |
|---|---|---|
| 서비스기획서 | 2-3 | 6개 발달 관찰 영역 정의 |
| 서비스기획서 | 2-4 | 점수 체계 (18문항 x 4점 = 72점, 5구간) |
| 서비스기획서 | 3-5 | 발달 스크리닝 기능 정의 |
| 서비스기획서 | 3-6 | 위험 신호 알림 |
| 서비스기획서 | 5-3 | 주간 체크 사용자 플로우 |
| 서비스기획서 | 6-1 | UX 원칙 5가지 |
| 개발기획서 | 4-2 | ChecklistRecord, DangerSignRecord SQL/모델 |
| 개발기획서 | 5-6 | 발달 탭 화면 4개 와이어프레임 |
| 개발기획서 | 6-2 | ScoreCalculator 전체 코드 |
| 개발기획서 | 6-4 | DangerSignAnalyzer 코드 |
| 개발기획서 | 8-3 | ChecklistItem 시드 구조 |
| 개발기획서 | 8-4 | DangerSignItem 시드 구조 |
| 개발기획서 | 8-8 | 0-1주차 시드 데이터 전체 예시 |
| 개발기획서 | 9-2 | 체크리스트 Provider 전체 코드 |
| 디자인컴포넌트 | 2-2-6 | 레이더 차트 카드 시각 스펙 |
| 디자인컴포넌트 | 2-2-7 | 안심 메시지 카드 시각 스펙 |
| 디자인컴포넌트 | 2-2-9 | 체크리스트 영역 카드 시각 스펙 |
| 디자인컴포넌트 | 2-2-11 | 위험 신호 카드 시각 스펙 |
| 디자인컴포넌트 | 2-2-12 | 주차 정보 카드 시각 스펙 |
| 디자인컴포넌트 | 2-4-1 | 점수 선택기 (0~4) 시각 스펙 |
| 디자인컴포넌트 | 2-5-1 | 레이더 차트 시각 스펙 |
| 디자인컴포넌트 | 2-5-3 | 추이 라인 차트 시각 스펙 |
| 디자인컴포넌트 | 2-5-4 | 채워진 도트 인디케이터 시각 스펙 |
| 디자인컴포넌트 | 2-5-6 | 프로그레스 바 시각 스펙 |
| 디자인컴포넌트 | 2-6-4 | 위험 신호 안내 배너 시각 스펙 |
| 디자인컴포넌트 | 2-6-5 | 점수 기준 BottomSheet 시각 스펙 |

---

## 6. AppStrings 추가 목록

아래 상수는 `app_strings.dart`에 추가해야 하며, 모든 UI 텍스트에서 하드코딩 대신 이 상수를 참조한다.

```
// ── 발달 체크 메인 ──
devCheckTitle                     // '발달'
devCheckWeekSuffix               // '주차' (앱 바 우측)
devCheckThisPeriodBaby           // '이 시기 아기는...'
devCheckCtaStart                 // '이번 주 발달 살펴보기'
devCheckPastRecords              // '지난 기록 보기'
devCheckRecheck                  // '다시 체크하기'
devCheckTrendButton              // '추이 보기'
devCheckSolutionTitle            // '이렇게 해보세요'

// ── 체크리스트 ──
checklistProgressLabel           // '천천히 살펴보세요'
checklistScoreGuideTitle         // '점수 기준 안내'
checklistScoreGuide4             // '자주 안정적'
checklistScoreGuide3             // '종종 보임'
checklistScoreGuide2             // '가끔 보임'
checklistScoreGuide1             // '드물게 보임'
checklistScoreGuide0             // '거의 안 보임'
checklistMemoAdd                 // '메모 추가'

// ── 위험 신호 ──
dangerSignScreenTitle            // '한 가지만 더 확인할게요 (선택)'
dangerSignInstruction            // '아래 항목 중 관찰되는 것이 있다면 체크해 주세요.\n해당 없으면 그냥 넘어가세요.'
dangerSignWarning                // '며칠 더 지켜본 뒤, 걱정이 계속되면 전문가와 이야기해 보세요.'
dangerSignHospitalHint           // '다음 소아과 방문 시 이 기록을 보여주시면 도움이 돼요.'
dangerSignMemoLabel              // '메모 (선택)'
dangerSignSkipButton             // '건너뛰기'

// ── 결과 ──
resultDomainTitle                // '영역별 살펴보기'
resultTrendImproving             // '좋아지고 있어요'
resultTrendStable                // '안정적이에요'
resultGoHomeButton               // '홈으로 돌아가기'

// ── 추이 ──
trendScreenTitle                 // '발달 추이'
trendTabWeekly                   // '주간'
trendTabMonthly                  // '월간'
trendReassurance                 // '변화의 흐름을 살펴보세요'
trendCompareImproving            // '지난 주보다 안정적인 흐름이에요'
trendDomainAll                   // '전체'
trendDomainChips                 // ['전체','몸','감각','집중','소리','마음','리듬']
trendYAxisLow                    // '낮음'
trendYAxisMid                    // '보통'
trendYAxisHigh                   // '높음'
trendEmpty                       // '아직 추이를 볼 수 있는 기록이 없어요.\n발달 체크를 시작하면 변화를 보여드릴게요.'
trendGrowingMessage              // '꾸준히 성장하고 있어요'

// ── 빈 상태 ──
devCheckEmptyResult              // '아직 발달 체크를 해본 적이 없어요.\n준비되면 시작해보세요.'
```

---

## 7. 시드 데이터 상세 (0-1주차 18문항)

아래 18문항은 `checklist_seed.dart`에 포함한다. 개발기획서 섹션 8-8 기준.

| # | id | domain | domainDisplayName | orderInDomain | questionText |
|---|---|---|---|---|---|
| 1 | physical_0 | physical | 몸 움직임 | 0 | 팔다리를 몸 쪽으로 모은 자세를 해요 |
| 2 | physical_1 | physical | 몸 움직임 | 1 | 몸에 적당한 힘이 느껴져요 |
| 3 | physical_2 | physical | 몸 움직임 | 2 | 움직임이 부드러워요 |
| 4 | sensory_0 | sensory | 감각 반응 | 0 | 빛에 적절히 반응해요 |
| 5 | sensory_1 | sensory | 감각 반응 | 1 | 소리에 반응을 보여요 |
| 6 | sensory_2 | sensory | 감각 반응 | 2 | 부드러운 접촉에 편안해해요 |
| 7 | cognitive_0 | cognitive | 집중과 관심 | 0 | 가까운 얼굴에 잠시 시선을 머물러요 |
| 8 | cognitive_1 | cognitive | 집중과 관심 | 1 | 밝은 물체에 관심을 보여요 |
| 9 | cognitive_2 | cognitive | 집중과 관심 | 2 | 자극에 적절히 반응해요 |
| 10 | language_0 | language | 소리와 표현 | 0 | 울음으로 필요를 표현해요 |
| 11 | language_1 | language | 소리와 표현 | 1 | 부모 목소리에 반응을 보여요 |
| 12 | language_2 | language | 소리와 표현 | 2 | 다양한 울음 소리를 내요 |
| 13 | emotional_0 | emotional | 마음과 관계 | 0 | 안아주면 편안해져요 |
| 14 | emotional_1 | emotional | 마음과 관계 | 1 | 부드러운 표정을 보여요 |
| 15 | emotional_2 | emotional | 마음과 관계 | 2 | 접촉 시 진정되는 모습이 보여요 |
| 16 | regulation_0 | regulation | 생활 리듬 | 0 | 잠-깸 전환이 자연스러워요 |
| 17 | regulation_1 | regulation | 생활 리듬 | 1 | 수유 후 진정되는 모습이 보여요 |
| 18 | regulation_2 | regulation | 생활 리듬 | 2 | 하루 중 편안한 시간이 있어요 |

위험 신호 6항목 (개발기획서 8-8):

| # | id | text |
|---|---|---|
| 1 | danger_0 | 수유 시 잘 빨지 못하거나 자주 사래들려요 |
| 2 | danger_1 | 하루 종일 거의 깨어나지 않거나 반대로 거의 잠을 자지 못해요 |
| 3 | danger_2 | 몸이 너무 축 늘어져 있거나 너무 뻣뻣해요 |
| 4 | danger_3 | 달래줘도 30분 이상 울음이 그치지 않아요 |
| 5 | danger_4 | 소리에 전혀 반응하지 않아요 |
| 6 | danger_5 | 피부색이 푸르거나 노란빛이 심해요 |

---

## 8. GoRouter 라우트 추가

```
기존 라우트에 추가:

/dev-check/checklist           -> ChecklistScreen
/dev-check/danger-signs        -> DangerSignScreen (위험 신호 선택, extra로 체크리스트 응답 전달)
/dev-check/result              -> ChecklistResultScreen (extra로 ChecklistRecord 전달)
/dev-check/trend               -> TrendScreen
```

---

## 9. 와이어프레임 참조

모든 화면의 와이어프레임은 개발기획서 섹션 5-6에 ASCII art로 정의되어 있다. 구현 시 이 와이어프레임의 레이아웃 구조, 요소 배치 순서, 섹션 구분을 정확히 따른다.

- DevCheckMainScreen State A: 개발기획서 2358-2395행
- DevCheckMainScreen State B: 개발기획서 2397-2443행
- ChecklistScreen: 개발기획서 2465-2519행
- 위험 신호 선택 단계: 개발기획서 2521-2577행
- ChecklistResultScreen: 개발기획서 2595-2668행
- TrendScreen: 개발기획서 2683-2717행
