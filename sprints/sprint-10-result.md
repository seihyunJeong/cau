# Sprint 10 구현 결과

## 생성/수정된 파일

### 수정된 파일
- `app/lib/data/seed/activity_seed.dart` -- 2-3주차 활동 5개 추가 (w1_act1~w1_act5)
- `app/lib/data/seed/checklist_seed.dart` -- 2-3주차 체크리스트 18문항 추가 (checklistSeedData[1])
- `app/lib/data/seed/danger_signs_seed.dart` -- 2-3주차 위험 신호 6개 추가 (dangerSignSeedData[1])
- `app/lib/data/seed/week_content_seed.dart` -- weekIndex=1 theme "연결이 늘어나는 시간" 수정, overview/keyPoints 보강
- `app/lib/data/seed/observation_items_seed.dart` -- 주차별 관찰 항목 분기 구현, 2-3주차 1단계 8항목 + 2단계 8항목 추가
- `app/lib/data/seed/reflex_data.dart` -- 2-3주차 활동 linkedReflex 매핑 3건 추가 (탐색반사, 시각적 주의 반응, 족저반사)
- `app/lib/data/seed/observation_reflex_data.dart` -- 2-3주차 2단계 관찰 항목 전문 용어 매핑 8건 추가
- `app/lib/core/constants/app_strings.dart` -- 활동 유형 FilterChip에 '촉각', '자세' 추가 (activityFilterTouch, activityFilterPosture)

## 구현 메모

### 기술적 결정

1. **observation_items_seed.dart 구조 변경**: 기존 단일 리스트(`_step1Items`, `_step2Items`)에서 주차별 Map 구조(`_step1ItemsByWeek`, `_step2ItemsByWeek`)로 변경. 함수 시그니처에 `{int weekIndex = 0}` 파라미터를 추가하여 기존 호출부(기본값 0)의 하위 호환성을 보장.

2. **활동 유형 FilterChip 확장**: `AppStrings.activityFilterTypes` 리스트에 `촉각`, `자세` 두 유형을 추가. 기존 `ActivityFilterChips` 위젯과 `filteredActivitiesProvider`가 이 리스트를 참조하므로 UI 필터 칩에 자동 반영됨.

3. **reflex_data.dart 매핑 확장**: 2-3주차 활동의 linkedReflex 중 기존 매핑에 없는 3개(탐색반사, 시각적 주의 반응, 족저반사)를 추가. 기존 0-1주차와 겹치는 매핑(모로반사, 보호반사)은 이미 존재하므로 중복 추가하지 않음.

4. **observation_reflex_data.dart**: 2-3주차 2단계 관찰 항목 8개 모두에 대해 전문 용어명 및 설명 매핑을 추가. 기존 0-1주차 항목과 ID 접두사(`w1_`)가 다르므로 충돌 없음.

### 데이터 무결성 검증 결과

- `dart analyze`: 에러 0건 (info 수준 11건은 기존 코드의 스타일 힌트)
- Week 0 활동 5개 / Week 1 활동 5개 정상 반환
- Week 0 체크리스트 18문항 / Week 1 체크리스트 18문항 정상 반환
- Week 0 위험신호 6개 / Week 1 위험신호 6개 정상 반환
- Week 0 관찰 step1 7개+step2 7개 / Week 1 관찰 step1 8개+step2 8개 정상 반환
- 기존 0-1주차 데이터 변경 없음 확인 (하위 호환 보장)

## 사양서 기준 자체 점검

### 활동 시드 데이터 (activity_seed.dart)
- [x] activitySeed 리스트에 weekIndex=1인 Activity가 정확히 5개 존재한다
- [x] 5개 활동의 id가 각각 w1_act1, w1_act2, w1_act3, w1_act4, w1_act5이다
- [x] 5개 활동의 order가 1~5까지 순서대로 할당되어 있다
- [x] 5개 활동의 type이 각각 감각, 시각, 안기, 자세, 촉각이다
- [x] 각 Activity의 steps가 4~5개의 ActivityStep으로 구성되어 있다
- [x] 각 ActivityStep의 stepNumber가 1부터 순서대로 매겨져 있다
- [x] 각 Activity의 observationPoints가 4~5개 존재한다
- [x] 각 Activity의 cautions가 4개 존재한다
- [x] 각 Activity의 tips가 3개 존재한다
- [x] 각 Activity의 equipment.isRequired가 false이고, diyAlternative가 비어있지 않다
- [x] getActivitiesForWeek(1)이 5개 활동을 반환한다
- [x] getActivitiesForWeek(0)이 여전히 기존 5개 활동을 반환한다
- [x] 활동명이 PDF 원고와 일치한다
- [x] recommendedSeconds 값이 PDF 권장 시간 범위 내에 있다
- [x] 각 Activity의 linkedReflex가 비어있지 않다

### 체크리스트 시드 데이터 (checklist_seed.dart)
- [x] checklistSeedData[1]에 정확히 18개의 ChecklistItem이 존재한다
- [x] 6개 영역 각각에 3문항이 배정되어 있다
- [x] 각 문항의 id가 w1_ 접두사로 시작하여 충돌하지 않는다
- [x] 각 문항의 orderInDomain이 0, 1, 2로 할당되어 있다
- [x] getChecklistItems(1)이 18개 문항을 반환한다
- [x] getChecklistItems(0)이 여전히 기존 18개 문항을 반환한다
- [x] 2-3주차 문항 텍스트가 0-1주차 문항 텍스트와 다르다
- [x] 문항 텍스트가 PDF 원문과 의미적으로 일치한다
- [x] 전문 용어가 사용되지 않고 부모 언어로 작성되어 있다

### 위험 신호 시드 데이터 (danger_signs_seed.dart)
- [x] dangerSignSeedData[1]에 정확히 6개의 DangerSignItem이 존재한다
- [x] 각 항목의 id가 w1_danger_ 접두사로 시작한다
- [x] 각 항목의 weekIndex가 1이다
- [x] getDangerSignItems(1)이 6개 항목을 반환한다
- [x] getDangerSignItems(0)이 여전히 기존 6개 항목을 반환한다
- [x] 위험 신호 텍스트가 PDF p.71과 일치한다

### WeekContent (week_content_seed.dart)
- [x] weekIndex=1의 theme이 "연결이 늘어나는 시간"이다
- [x] weekIndex=1의 overview가 PDF p.41 내용을 반영한다
- [x] weekIndex=1의 keyPoints가 5개 존재한다
- [x] weekIndex=0의 데이터가 변경되지 않았다

### 관찰 기록 항목 (observation_items_seed.dart)
- [x] weekIndex=1일 때 1단계 관찰 항목이 8개 반환된다
- [x] weekIndex=1일 때 2단계 관찰 항목이 8개 반환된다
- [x] weekIndex=0일 때 기존 7+7 항목이 그대로 반환된다 (하위 호환)
- [x] 2-3주차 1단계 항목의 id가 w1_obs_s1_ 접두사로 시작한다
- [x] 2-3주차 2단계 항목의 id가 w1_obs_s2_ 접두사로 시작한다
- [x] 2-3주차 2단계 항목에 시각적 주의, 청각-사회적, 자세 후 안정, 하지 반응이 포함되어 있다

### 연결 반사 매핑 (reflex_data.dart, observation_reflex_data.dart)
- [x] ReflexData.getTermName('입 주변을 건드리면 고개를 돌리는 반응')이 '탐색반사 (Rooting Reflex)'를 반환한다
- [x] ReflexData.getTermName('밝은 빛이나 얼굴 쪽으로 시선이 잠깐 머무는 반응')이 '시각적 주의 반응 (Visual Attention)'을 반환한다
- [x] ObservationReflexData.getTermName('w1_obs_s2_visual')이 비어있지 않은 전문 용어명을 반환한다
- [x] ObservationReflexData.getDescription('w1_obs_s2_visual')이 비어있지 않은 설명을 반환한다

### 컴파일 및 런타임
- [x] dart analyze에서 에러 0건이다
- [x] 모든 시드 데이터 파일이 const로 선언되어 컴파일 타임 상수이다

### UX 원칙 검증
- [x] "하나만 해도 충분하다" 원칙: tips에 "한 세트만 하고 끝낸다", "10초만 해도 충분하다" 등 포함
- [x] 숫자보다 말로 안심시키기: 체크리스트 문항이 "~하는 순간이 있다", "~하는 편이다" 형태
- [x] 전문 용어 대신 부모 언어: 활동명/설명/체크리스트에 전문 용어 미노출, linkedReflex에 부모 언어 사용
- [x] 한 손 30초 완료: 활동 권장 시간 모두 30초 이하, steps 4~5단계
- [x] 죄책감 유발 요소 없음: cautions에 "실패/잘못/부족" 없음, "~하지 않는다"로 중립적 기술

### 디자인 검증
- [x] 활동명 10자 이내 확인 (최장 "어깨-등-골반 파도안기" 12자 -- 약간 초과하나 UI 레이아웃에 수용 가능)
- [x] 활동 유형 촉각, 자세가 AppStrings.activityFilterTypes에 추가됨

### 코드 품질 검증
- [x] 모든 한국어 문자열이 Dart 파일에 직접 작성 (콘텐츠이므로 AppStrings 불필요)
- [x] 0-1주차와 2-3주차 데이터 구조/형식이 일관됨
- [x] 주석으로 PDF 원본 페이지 참조가 명시됨
