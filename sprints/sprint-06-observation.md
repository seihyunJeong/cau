# Sprint 06: 활동 후 관찰 기록 (2개 화면)

## 1. 구현 범위

### 대상 화면/기능

- **ObservationFormScreen** (관찰 기록 폼) (개발기획서 섹션 5-5, 화면 3-3)
  - 활동 타이머 완료 후 자동 이동 (또는 활동 히스토리에서 수동 진입)
  - 단일 스크롤 폼으로 모든 관찰 기록을 한 화면에 통합
  - **1단계 -- 활동 직후 모습 (필수, 기본 펼침):**
    - 핵심 4항목 기본 노출 (편안함, 표정, 이완, 호흡)
    - 나머지 3항목은 접힌 상태 ("나머지 항목 더 보기" ExpansionTile로 펼침)
    - 각 항목: 예 / 보통 / 아니오 (3단 라디오 그룹 2-4-2, 탭 1번으로 선택)
    - 안내 문구: "3개만 해도 충분해요" (Body2, warmGray)
  - **2단계 -- 자세히 기록하고 싶다면 (선택, 기본 접힘):**
    - "자세히 기록하고 싶다면" ExpansionTile (2-4-6)로 펼침
    - 자연 반응 관찰 7항목 (모로반사, 탐색반사, 파악반사, 족저반사, 보행반사, 빨기반사, 긴장목반사)
    - 각 항목: 뚜렷함 / 약하게 / 잘 안 보임
    - 2단계 항목에 InfoTerm 툴팁 (2-6-1) 적용 -- 전문 용어 설명
  - **인라인 메모 (선택):**
    - 1줄 텍스트 필드 (2-4-5), 플레이스홀더 "한 줄 메모를 남겨보세요"
  - 하단 고정 [기록 완료] CTA 버튼 (2-3-7 + 2-3-1)
  - 핵심 3항목만 입력하면 완료 가능 (최소 3탭)
  - 중간 저장 자동 (빠른 이탈 대응)
  - 안심 메시지: 화면 상단에 "정답은 없어요. 느낌대로 기록해주세요" (Body2, warmGray)
  - 앱 바 제목: "오늘 아기는 어땠나요?" (용어 통일 가이드 기준)

- **ObservationResultScreen** (관찰 결과) (개발기획서 섹션 5-5, 화면 3-4)
  - 관찰 기록 제출 후 자동 전환되는 결과 화면
  - 안심 메시지 카드 (2-2-7):
    - softGreen 아이콘 + H1 메인 메시지 + Body1 서브 메시지
    - 예: "오늘 이 정도면 괜찮아요" + "오늘 아기가 활동에 편안하게 반응했어요."
  - ObservationInterpreter 로직으로 4단계 자동 해석 피드백:
    - 레벨 0: "무리 없이 잘 진행된 것 같아요"
    - 레벨 1: "다음에는 조금 짧게 해볼까요?"
    - 레벨 2: "며칠 이어서 관찰해 보세요"
    - 레벨 3: "전문가와 이야기해 보는 것도 좋아요"
  - 솔루션 메시지 (ObservationInterpreter.getSolutions 기반)
  - 안심 서브 메시지: "관찰 기록이 쌓이면 아기만의 성장 패턴이 보여요" (Body2, warmGray)
  - [홈으로] CTA 버튼 (2-3-1)
  - 숫자 없이 말로만 결과 표현 (UX 원칙 2)

### 추가 구현 (인프라 확장)

- **ObservationRecord 모델** (개발기획서 섹션 4-2) -- `lib/data/models/observation_record.dart`
- **ObservationRecordDao** (개발기획서 섹션 4-5) -- `lib/data/database/daos/observation_record_dao.dart`
- **ObservationItem 모델** -- `lib/data/models/observation_item.dart` (개발기획서 섹션 8-5)
- **observation_items_seed.dart** -- 1단계 7항목 + 2단계 7항목 시드 데이터 (개발기획서 섹션 8-8)
- **ObservationInterpreter** (개발기획서 섹션 6-3) -- `lib/core/utils/observation_interpreter.dart`
- **ObservationItemTile** 위젯 -- `lib/features/activity/widgets/observation_item_tile.dart`
- **observation_providers.dart** -- `lib/providers/observation_providers.dart`
- **홈 화면 ObservationSummaryCard 연동** -- 기존 빈 상태 전용이던 카드에 실제 관찰 데이터 연결
- **GoRouter 라우트 추가** -- `/observation/:activityRecordId` + `/observation/:activityRecordId/result`
- **AppStrings 확장** -- 관찰 기록 관련 모든 UI 텍스트 상수 추가

### 사용 디자인 컴포넌트

| 컴포넌트 번호 | 이름 | 사용 위치 |
|---|---|---|
| 2-1-2 | 앱 바 (변형 B, 뒤로가기) | ObservationFormScreen, ObservationResultScreen |
| 2-2-7 | 안심 메시지 카드 | ObservationResultScreen 메인 카드 |
| 2-3-1 | 기본 CTA 버튼 | "기록 완료", "홈으로" 버튼 |
| 2-3-7 | 하단 고정 버튼 | ObservationFormScreen 하단 CTA |
| 2-4-2 | 라디오 그룹 3단 | 1단계/2단계 관찰 항목 선택지 |
| 2-4-5 | 텍스트 입력 필드 | 인라인 메모 |
| 2-4-6 | 확장 타일 | "나머지 항목 더 보기", "자세히 기록하고 싶다면" |
| 2-6-1 | InfoTerm 툴팁 | 2단계 자연 반응 항목 (모로반사 등) |
| 2-6-3 | 인라인 저장 확인 | 메모 입력 후 "저장됨" |
| 2-7-1 | 스크롤 가능 페이지 + 하단 고정 버튼 | ObservationFormScreen 전체 레이아웃 |

---

## 2. 파일 목록

### 신규 생성 파일

| # | 파일 경로 | 설명 |
|---|---|---|
| 1 | `lib/data/models/observation_record.dart` | ObservationRecord 모델 (개발기획서 4-2) |
| 2 | `lib/data/models/observation_item.dart` | ObservationItem 모델 (개발기획서 8-5) |
| 3 | `lib/data/database/daos/observation_record_dao.dart` | ObservationRecordDao CRUD + 쿼리 |
| 4 | `lib/data/seed/observation_items_seed.dart` | 관찰 항목 시드 데이터 (1단계 7항목, 2단계 7항목) |
| 5 | `lib/core/utils/observation_interpreter.dart` | ObservationInterpreter 해석 로직 (개발기획서 6-3) |
| 6 | `lib/features/activity/screens/observation_form_screen.dart` | 관찰 기록 폼 화면 |
| 7 | `lib/features/activity/screens/observation_result_screen.dart` | 관찰 결과 화면 |
| 8 | `lib/features/activity/widgets/observation_item_tile.dart` | 관찰 항목 타일 위젯 (질문 + 3단 라디오) |
| 9 | `lib/providers/observation_providers.dart` | 관찰 관련 Provider들 |

### 수정 파일

| # | 파일 경로 | 수정 내용 |
|---|---|---|
| 1 | `lib/core/router/app_router.dart` | 관찰 기록/결과 라우트 2개 추가 |
| 2 | `lib/core/constants/app_strings.dart` | 관찰 기록 관련 UI 텍스트 상수 추가 |
| 3 | `lib/providers/core_providers.dart` | `observationRecordDaoProvider` 추가 |
| 4 | `lib/features/home/widgets/observation_summary_card.dart` | 실제 관찰 데이터 연동 (빈 상태 -> 데이터 표시 전환) |
| 5 | `lib/features/activity/screens/activity_timer_screen.dart` | "관찰 기록하기" 버튼 탭 시 ObservationFormScreen으로 네비게이션 연결 |

---

## 3. 데이터 모델

### 3-1. ObservationRecord 모델 (개발기획서 4-2)

```dart
/// 활동 후 관찰 기록 모델.
/// step1Responses, step2Responses는 JSON 문자열로 직렬화하여 저장.
class ObservationRecord {
  final int? id;
  final int babyId;
  final int activityRecordId;       // activity_records.id 참조
  final DateTime date;
  final String step1Responses;       // JSON: {"obs_s1_0": 2, ...} (0=아니오, 1=보통, 2=예)
  final String step2Responses;       // JSON: {"obs_s2_moro": 2, ...} (0=잘안보임, 1=약하게, 2=뚜렷함)
  final String? comfortableActivity; // 편안했던 활동 (미사용, 향후 확장)
  final String? uncomfortableActivity; // 부담스러웠던 활동 (미사용, 향후 확장)
  final String? adjustmentNote;      // 한 줄 메모
  final int interpretationLevel;     // 0~3: 무리없음/짧게조정/며칠이어서/상담고려
  final DateTime createdAt;
}
```

### 3-2. ObservationItem 모델 (개발기획서 8-5)

```dart
/// 관찰 항목 모델. 시드 데이터에서 사용.
class ObservationItem {
  final String id;            // "obs_s1_0" 또는 "obs_s2_moro"
  final int step;             // 1 또는 2
  final String text;          // 관찰 항목 텍스트 (부모 언어)
  final List<String> options; // 선택지: ["예", "보통", "아니오"] 또는 ["뚜렷함", "약하게", "잘 안 보임"]
}
```

### 3-3. ObservationRecordDao 주요 메서드

```dart
class ObservationRecordDao {
  Future<int> insert(ObservationRecord record);
  Future<ObservationRecord?> getById(int id);
  Future<ObservationRecord?> getByActivityRecordId(int activityRecordId);
  Future<List<ObservationRecord>> getRecentByBabyId(int babyId, {int limit = 7});
  Future<ObservationRecord?> getLatestByBabyId(int babyId);
}
```

### 3-4. 관찰 시드 데이터 (observation_items_seed.dart)

- 1단계 7항목 (obs_s1_0 ~ obs_s1_6): 개발기획서 8-8 기준
- 2단계 7항목 (obs_s2_moro ~ obs_s2_tonic): 개발기획서 8-8 기준
- 편의 함수: `getObservationStep1Items()`, `getObservationStep2Items()`

### 3-5. Provider 정의 (observation_providers.dart)

```dart
/// ObservationRecordDao Provider (core_providers.dart에 추가)
final observationRecordDaoProvider = Provider<ObservationRecordDao>((ref) => ObservationRecordDao());

/// 관찰 폼 응답 상태 Notifier.
/// step1 응답 Map, step2 응답 Map, 메모를 관리한다.
class ObservationFormNotifier extends Notifier<ObservationFormState> { ... }

/// 관찰 폼 Provider.
final observationFormProvider =
    NotifierProvider<ObservationFormNotifier, ObservationFormState>(...);

/// 최근 관찰 기록 Provider (홈 화면 연동용).
final latestObservationProvider = FutureProvider<ObservationRecord?>((ref) async { ... });

/// 관찰 기록 저장 함수.
Future<ObservationRecord> saveObservationRecord(WidgetRef ref, {
  required int babyId,
  required int activityRecordId,
}) async { ... }
```

### 3-6. ObservationInterpreter (개발기획서 6-3)

```dart
class ObservationInterpreter {
  /// 1단계+2단계 응답 기반 해석 레벨 계산 (0~3)
  static int interpret({
    required Map<String, int> step1Responses,
    required Map<String, int> step2Responses,
  });

  /// 해석 레벨 -> 안심 메시지 반환
  static String getMessage(int level);

  /// 해석 레벨 -> 솔루션 목록 반환
  static List<String> getSolutions(int level);

  /// 해석 레벨 -> 아이콘 데이터 반환 (softGreen/softYellow/softRed)
  static IconData getIcon(int level);

  /// 해석 레벨 -> 아이콘 색상 반환
  static Color getIconColor(int level);
}
```

---

## 4. 검증 기준 (Evaluator용)

각 기준은 PASS/FAIL로 판정. Marionette MCP로 실행 중인 앱에서 검증한다.

### 4-1. 파일 구조 검증

- [ ] `lib/data/models/observation_record.dart` 파일이 존재하고, `ObservationRecord` 클래스가 개발기획서 4-2의 모든 필드(id, babyId, activityRecordId, date, step1Responses, step2Responses, comfortableActivity, uncomfortableActivity, adjustmentNote, interpretationLevel, createdAt)를 포함한다.
- [ ] `lib/data/models/observation_item.dart` 파일이 존재하고, `ObservationItem` 클래스가 id, step, text, options 필드를 포함한다.
- [ ] `lib/data/database/daos/observation_record_dao.dart` 파일이 존재하고, insert, getById, getByActivityRecordId, getRecentByBabyId, getLatestByBabyId 메서드가 정의되어 있다.
- [ ] `lib/data/seed/observation_items_seed.dart` 파일이 존재하고, 1단계 7항목 + 2단계 7항목 총 14개 시드 데이터가 포함된다.
- [ ] `lib/core/utils/observation_interpreter.dart` 파일이 존재하고, interpret, getMessage, getSolutions 정적 메서드가 정의되어 있다.
- [ ] `lib/features/activity/screens/observation_form_screen.dart` 파일이 존재한다.
- [ ] `lib/features/activity/screens/observation_result_screen.dart` 파일이 존재한다.
- [ ] `lib/features/activity/widgets/observation_item_tile.dart` 파일이 존재한다.
- [ ] `lib/providers/observation_providers.dart` 파일이 존재한다.

### 4-2. 기능 검증 -- ObservationFormScreen

- [ ] ActivityTimerScreen의 완료 화면에서 "오늘 아기는 어땠나요? (관찰 기록하기)" 버튼을 탭하면 ObservationFormScreen으로 이동한다.
- [ ] 앱 바 제목이 "오늘 아기는 어땠나요?"로 표시된다 (AppStrings.observationTitle 참조).
- [ ] 화면 상단에 "정답은 없어요. 느낌대로 기록해주세요" 안심 메시지가 표시된다.
- [ ] 1단계 섹션 제목 "활동 직후 모습"이 표시되고, 그 아래 "3개만 해도 충분해요" 안내 문구가 표시된다.
- [ ] 1단계 핵심 4항목(활동 후 편안해 보였어요, 표정이 부드러워졌어요, 몸이 이완되었어요, 호흡이 안정적이었어요)이 기본 펼침 상태로 표시된다.
- [ ] 각 1단계 항목에 [예] [보통] [아니오] 3개 선택 버튼이 수평 배치된다.
- [ ] 선택 버튼 탭 시 해당 버튼이 warmOrange 배경 + white 텍스트로 활성 표시되고, 나머지 2개는 비선택 상태(paleCream 배경)로 유지된다.
- [ ] "나머지 항목 더 보기" ExpansionTile이 존재하며, 탭하면 나머지 3항목(울음이 줄었어요, 활동에 반응을 보였어요, 수면으로 잘 전환되었어요)이 펼쳐진다.
- [ ] "자세히 기록하고 싶다면" ExpansionTile이 존재하며, 기본 접힘 상태이다.
- [ ] "자세히 기록하고 싶다면" 펼침 시 2단계 7항목(깜짝 놀라며 팔을 벌리는 반응, 입 주변을 건드리면 고개를 돌리는 반응, 손바닥을 건드리면 꽉 쥐는 반응, 발바닥을 건드리면 발가락을 오므리는 반응, 세워주면 걷는 듯한 움직임, 빨기 반응, 고개를 돌리면 같은 쪽 팔다리를 펴는 반응)이 표시된다.
- [ ] 2단계 각 항목에 [뚜렷함] [약하게] [잘 안 보임] 3개 선택 버튼이 수평 배치된다.
- [ ] 2단계 항목 텍스트 옆에 InfoTerm 툴팁 아이콘(i)이 표시되고, 탭 시 전문 용어 이름과 설명이 툴팁으로 표시된다 (예: "깜짝 놀라며 팔을 벌리는 반응" 옆 (i) 탭 -> "모로반사 (Moro Reflex)" + 설명 표시).
- [ ] 인라인 메모 텍스트 필드가 존재하며, 플레이스홀더가 "한 줄 메모를 남겨보세요"로 표시된다.
- [ ] 하단에 [기록 완료] CTA 버튼이 고정되어 있으며, 스크롤과 무관하게 항상 표시된다.
- [ ] 1단계 핵심 3항목 이상 선택하지 않으면 [기록 완료] 버튼이 비활성 상태(mutedBeige 배경)이다.
- [ ] 1단계 핵심 3항목 이상 선택 후 [기록 완료] 버튼이 활성 상태(warmOrange 배경)로 변경된다.
- [ ] [기록 완료] 버튼 탭 시 ObservationRecord가 DB에 저장되고, ObservationResultScreen으로 자동 이동한다.
- [ ] 2단계 항목을 입력하지 않아도 [기록 완료]가 가능하다 (2단계는 선택 사항).
- [ ] 인라인 메모를 입력하지 않아도 [기록 완료]가 가능하다 (메모는 선택 사항).

### 4-3. 기능 검증 -- ObservationResultScreen

- [ ] 관찰 기록 저장 후 자동으로 ObservationResultScreen이 표시된다.
- [ ] 화면 중앙에 안심 메시지 카드(2-2-7)가 표시된다: mintTint 배경, 16dp 모서리, 24dp 패딩.
- [ ] 카드 상단에 softGreen 아이콘이 표시된다.
- [ ] 해석 레벨에 따른 메인 메시지가 H1(22sp, SemiBold)으로 중앙 정렬 표시된다.
- [ ] 해석 레벨에 따른 서브 메시지가 Body1(15sp, warmGray)으로 중앙 정렬 표시된다.
- [ ] 모든 응답을 "예"/"뚜렷함"으로 선택한 경우 레벨 0 메시지 "무리 없이 잘 진행된 것 같아요"가 표시된다.
- [ ] 솔루션 메시지가 메인 카드 아래에 목록으로 표시된다.
- [ ] "관찰 기록이 쌓이면 아기만의 성장 패턴이 보여요" 서브 메시지가 표시된다.
- [ ] [홈으로] CTA 버튼이 하단에 표시되며, 탭 시 홈 화면으로 이동한다 (GoRouter /home).
- [ ] 결과 화면에 숫자(점수, 퍼센트)가 표시되지 않는다 (UX 원칙 2: 숫자보다 말로 안심시킨다).
- [ ] 안드로이드 뒤로가기 버튼/앱 바 뒤로가기 시 홈 화면으로 이동한다 (관찰 폼으로 돌아가지 않는다).

### 4-4. 기능 검증 -- 홈 화면 연동

- [ ] 관찰 기록 저장 후 홈 화면의 ObservationSummaryCard가 빈 상태 대신 실제 데이터(안심 메시지 + 레이더 차트 미니)를 표시한다.
- [ ] 관찰 기록이 없는 상태에서 ObservationSummaryCard는 기존 빈 상태 메시지("아직 관찰 기록이 없어요...")를 표시한다.

### 4-5. 기능 검증 -- 데이터 저장

- [ ] ObservationRecord.step1Responses에 1단계 응답이 JSON 형식으로 저장된다 (예: `{"obs_s1_0": 2, "obs_s1_1": 1, ...}`).
- [ ] ObservationRecord.step2Responses에 2단계 응답이 JSON 형식으로 저장된다 (미입력 항목은 빈 Map `{}`).
- [ ] ObservationRecord.adjustmentNote에 인라인 메모가 저장된다 (미입력 시 null).
- [ ] ObservationRecord.interpretationLevel에 ObservationInterpreter.interpret() 결과(0~3)가 저장된다.
- [ ] ObservationRecord.activityRecordId에 연결된 활동 기록 ID가 올바르게 저장된다.
- [ ] 같은 activity_record_id로 중복 관찰 기록이 생성되지 않는다 (이미 기록된 활동에 대해 폼을 다시 열면 기존 데이터를 보여주거나 재기록 방지).

### 4-6. 기능 검증 -- ObservationInterpreter 로직

- [ ] 1단계+2단계 모든 응답이 최대값(예=2, 뚜렷함=2)일 때 레벨 0을 반환한다.
- [ ] 1단계+2단계 모든 응답이 최소값(아니오=0, 잘안보임=0)일 때 레벨 3을 반환한다.
- [ ] 2단계 응답이 비어있을 때(빈 Map) 1단계만으로 해석하며, 1단계 전체 "예" 선택 시 레벨 0을 반환한다.
- [ ] getMessage(0)이 "무리 없이 잘 진행된 것 같아요."를 포함하는 문자열을 반환한다.
- [ ] getMessage(3)이 "전문가와 이야기해 보세요"를 포함하는 문자열을 반환한다.
- [ ] getSolutions(0)이 최소 1개 이상의 솔루션 문자열을 포함하는 리스트를 반환한다.

### 4-7. UX 원칙 검증

- [ ] **"하나만 해도 충분하다" 원칙:** "3개만 해도 충분해요" 안내 문구가 표시되고, 실제로 핵심 3항목만 선택하면 [기록 완료] 버튼이 활성화된다. 관찰 기록 자체가 선택 사항이다 (활동 완료 시 "관찰 기록하기"는 선택, "홈으로 돌아가기"도 가능).
- [ ] **숫자보다 말로 안심시키는지:** 결과 화면에 점수, 퍼센트, 비율 등 숫자가 일체 표시되지 않는다. 오직 말(문장)로만 피드백을 제공한다.
- [ ] **전문 용어 대신 부모 언어 사용:** 2단계 관찰 항목에서 "모로반사"가 아닌 "깜짝 놀라며 팔을 벌리는 반응"으로 표시된다. 전문 용어는 InfoTerm 툴팁 탭 시에만 노출된다.
- [ ] **한 손 30초 완료 가능:** 1단계 핵심 3항목 각각 탭 1번 (3탭) + [기록 완료] 1탭 = 총 4탭으로 관찰 기록을 완료할 수 있다.
- [ ] **죄책감 유발 요소 없음:** "미완료", "필수", "경고" 등의 부정적 표현이 없다. 2단계/메모를 건너뛰어도 아무런 경고나 부정적 메시지가 표시되지 않는다. [기록 완료] 비활성 상태에서도 "부족합니다"가 아닌 조건 충족 시 자연스럽게 활성화된다.

### 4-8. 디자인 검증

- [ ] ObservationFormScreen 배경색이 `#FFF8F0` (cream)이다.
- [ ] 안심 메시지 카드 배경색이 `#F0F9F0` (mintTint)이다.
- [ ] CTA 버튼(기록 완료, 홈으로) 배경색이 `#F5A623` (warmOrange), 텍스트 white, 높이 52dp, 모서리 24dp이다.
- [ ] 비활성 CTA 버튼 배경색이 `#C4B5A5` (mutedBeige)이다.
- [ ] 3단 라디오 그룹 -- 비선택 상태: `#FFF3E8` 배경, darkBrown 텍스트. 선택 상태: `#F5A623` 배경, white 텍스트.
- [ ] 텍스트 입력 필드 -- 기본 테두리 `#F0E6D8` 1px, 포커스 테두리 `#F5A623` 2px, 12dp 모서리, 48dp 높이.
- [ ] ExpansionTile -- 접힌 상태: `#FFF3E8` 배경, 12dp 모서리. 펼침/접힘 애니메이션 200ms.
- [ ] 하단 고정 버튼 컨테이너: white 배경, 상단 그림자, SafeArea 하단 패딩 적용.
- [ ] 관찰 항목 카드: `#FFFFFF` 배경, 12dp 모서리, 16dp 패딩.
- [ ] InfoTerm 툴팁: `#FFF8F0` 배경, 12dp 모서리, 12dp 패딩, 제목 14sp Bold, 설명 13sp Regular.
- [ ] 모든 텍스트는 `Theme.of(context).textTheme`를 통해 적용한다 (하드코딩 금지).

### 4-9. 다크 모드 검증

- [ ] 다크 모드에서 배경색이 `#1A1512` (darkBg)로 변경된다.
- [ ] 다크 모드에서 카드 배경색이 `#2A231D` (darkCard)로 변경된다.
- [ ] 다크 모드에서 텍스트 색상이 `#F5EDE3` (darkTextPrimary)로 변경된다.
- [ ] 다크 모드에서 warmOrange CTA 버튼은 색상 변경 없이 유지된다.
- [ ] 다크 모드에서 안심 메시지 카드의 mintTint 배경이 다크 모드에 맞게 조정된다.

### 4-10. 조부모 모드 검증

- [ ] 조부모 모드에서 모든 텍스트 크기가 +4sp 적용된다 (Body1: 15sp -> 19sp, H1: 22sp -> 26sp 등).
- [ ] 조부모 모드에서 라디오 그룹 버튼 최소 터치 영역이 48x48dp 이상 유지된다.

### 4-11. 접근성 검증

- [ ] 모든 탭 가능 요소의 최소 터치 영역이 48x48dp 이상이다 (라디오 버튼, CTA 버튼, ExpansionTile, InfoTerm 아이콘).
- [ ] 무음 모드에서 [기록 완료] 탭 시 `HapticFeedback.lightImpact()` 햅틱 피드백이 동작한다.
- [ ] 관찰 기록이 없는 빈 상태에서 ObservationSummaryCard에 빈 상태 아이콘과 안심 메시지가 표시된다 ("아직 관찰 기록이 없어요...").

### 4-12. ValueKey 검증

- [ ] ObservationFormScreen에 `ValueKey('observation_form_screen')` 지정.
- [ ] ObservationResultScreen에 `ValueKey('observation_result_screen')` 지정.
- [ ] 각 1단계 관찰 항목 타일에 `ValueKey('obs_item_${item.id}')` 지정 (예: `ValueKey('obs_item_obs_s1_0')`).
- [ ] 각 2단계 관찰 항목 타일에 `ValueKey('obs_item_${item.id}')` 지정.
- [ ] 3단 라디오 그룹의 각 선택 버튼에 `ValueKey('obs_option_${item.id}_${optionIndex}')` 지정.
- [ ] [기록 완료] 버튼에 `ValueKey('observation_submit_button')` 지정.
- [ ] [홈으로] 버튼에 `ValueKey('observation_go_home_button')` 지정.
- [ ] 인라인 메모 필드에 `ValueKey('observation_memo_field')` 지정.
- [ ] 안심 메시지 카드에 `ValueKey('observation_result_card')` 지정.
- [ ] "나머지 항목 더 보기" ExpansionTile에 `ValueKey('obs_step1_expansion')` 지정.
- [ ] "자세히 기록하고 싶다면" ExpansionTile에 `ValueKey('obs_step2_expansion')` 지정.

### 4-13. 라우팅 검증

- [ ] GoRouter에 `/observation/:activityRecordId` 라우트가 등록되어 있다.
- [ ] GoRouter에 `/observation/:activityRecordId/result` 라우트가 등록되어 있다.
- [ ] ActivityTimerScreen 완료 화면의 "관찰 기록하기" 버튼 탭 시 `/observation/{activityRecordId}` 로 이동한다.
- [ ] 관찰 기록 저장 후 `/observation/{activityRecordId}/result` 로 자동 이동한다.
- [ ] 결과 화면의 [홈으로] 버튼 탭 시 `/home`으로 이동한다.

### 4-14. 코드 품질 검증

- [ ] 모든 UI 텍스트가 `AppStrings` 상수를 참조한다 (문자열 하드코딩 없음).
- [ ] 모든 텍스트 스타일이 `Theme.of(context).textTheme`를 통해 적용된다 (직접 TextStyle 생성 금지).
- [ ] 모든 색상이 `AppColors` 상수 또는 `Theme.of(context).colorScheme`을 통해 적용된다 (Color 리터럴 하드코딩 금지).
- [ ] `flutter analyze` 실행 시 에러가 0개이다.
- [ ] 앱이 정상적으로 빌드되고 실행된다.

---

## 5. 의존성

### 이전 스프린트 의존

| 스프린트 | 필요 항목 |
|---|---|
| Sprint 01 (인프라) | 프로젝트 세팅, sqflite, Riverpod, GoRouter, 테마/컬러/텍스트스타일 상수, DatabaseHelper |
| Sprint 02 (온보딩) | 아기 등록 완료 상태, activeBabyProvider |
| Sprint 03 (홈) | HomeScreen, ObservationSummaryCard (빈 상태 구현), AppStrings 기본 상수 |
| Sprint 05 (활동) | ActivityTimerScreen (완료 화면 + "관찰 기록하기" 버튼), ActivityRecord 모델/DAO, activityRecordDaoProvider, activity_seed.dart |

### 필요 패키지

| 패키지 | 용도 | 이미 설치 여부 |
|---|---|---|
| `sqflite` | 로컬 DB (observation_records 테이블) | 설치됨 (Sprint 01) |
| `flutter_riverpod` | 상태 관리 | 설치됨 (Sprint 01) |
| `go_router` | 라우팅 | 설치됨 (Sprint 01) |
| `just_the_tooltip` | InfoTerm 툴팁 | 설치됨 (Sprint 05) |
| `dart:convert` | JSON 직렬화/역직렬화 (step1/step2 responses) | Dart 내장 |

### 후속 스프린트 영향

- **Sprint 07 (발달 체크):** 이 스프린트에서 구현한 관찰 데이터 구조가 체크리스트 결과와 함께 홈 화면 레이더 차트에 통합된다.
- **Sprint 08+ (추이 분석):** 관찰 기록 히스토리 데이터가 추이 분석에 사용된다.
- **활동 히스토리:** 기존 `_ActivityHistoryPlaceholder`에 관찰 기록 완료 여부 표시가 추가된다 (이 스프린트 범위 밖).
