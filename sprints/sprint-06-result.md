# Sprint 06 구현 결과

## 생성된 파일

| # | 파일 경로 | 설명 |
|---|---|---|
| 1 | `lib/data/models/observation_record.dart` | ObservationRecord 모델 (11개 필드, toMap/fromMap) |
| 2 | `lib/data/models/observation_item.dart` | ObservationItem 모델 (id, step, text, options) |
| 3 | `lib/data/database/daos/observation_record_dao.dart` | ObservationRecordDao (insert, getById, getByActivityRecordId, getRecentByBabyId, getLatestByBabyId) |
| 4 | `lib/data/seed/observation_items_seed.dart` | 1단계 7항목 + 2단계 7항목 시드 데이터 (14개 항목) + 편의 함수 4개 |
| 5 | `lib/data/seed/observation_reflex_data.dart` | 2단계 자연 반응 항목 전문 용어 매핑 (InfoTerm용) |
| 6 | `lib/core/utils/observation_interpreter.dart` | ObservationInterpreter (interpret, getMessage, getTitle, getSolutions, getIcon, getIconColor) |
| 7 | `lib/features/activity/screens/observation_form_screen.dart` | 관찰 기록 폼 화면 (단일 스크롤 + 하단 고정 CTA) |
| 8 | `lib/features/activity/screens/observation_result_screen.dart` | 관찰 결과 화면 (안심 카드 + 솔루션 + 홈으로 CTA) |
| 9 | `lib/features/activity/widgets/observation_item_tile.dart` | 관찰 항목 타일 위젯 (질문 + 3단 라디오 그룹) |
| 10 | `lib/providers/observation_providers.dart` | ObservationFormNotifier, latestObservationProvider, saveObservationRecord |

## 수정된 파일

| # | 파일 경로 | 수정 내용 |
|---|---|---|
| 1 | `lib/core/router/app_router.dart` | `/observation/:activityRecordId` + `/observation/:activityRecordId/result` 라우트 2개 추가 |
| 2 | `lib/core/constants/app_strings.dart` | 관찰 기록 관련 UI 텍스트 상수 8개 추가 (observationReassuranceHint, observationStep1Title, observationStep1Hint, observationStep1MoreLabel, observationStep2Title, observationMemoHint, observationGoHome, observationGrowthPatternHint) |
| 3 | `lib/providers/core_providers.dart` | `observationRecordDaoProvider` 추가 |
| 4 | `lib/features/home/widgets/observation_summary_card.dart` | StatelessWidget -> ConsumerWidget 전환, latestObservationProvider 연동으로 빈 상태/데이터 있음 자동 전환 |
| 5 | `lib/features/activity/screens/activity_timer_screen.dart` | onGoToObservation에서 `/observation/{activityRecordId}`로 실제 네비게이션 연결, saveActivityRecord 반환값(int)으로 activityRecordId 획득 |
| 6 | `lib/providers/activity_providers.dart` | saveActivityRecord 반환 타입 `Future<void>` -> `Future<int>` 변경 (삽입된 ID 반환) |
| 7 | `lib/features/home/screens/home_screen.dart` | ObservationSummaryCard 호출에서 `const` 제거 (ConsumerWidget 전환 대응) |

## 구현 메모

- **데이터 저장 방식**: step1Responses, step2Responses는 JSON 문자열(`Map<String, int>`)로 직렬화하여 sqflite TEXT 컬럼에 저장. dart:convert의 jsonEncode/jsonDecode 사용.
- **값 매핑**: 옵션 인덱스 0(예/뚜렷함) -> 값 2, 인덱스 1(보통/약하게) -> 값 1, 인덱스 2(아니오/잘 안 보임) -> 값 0. 높은 값이 긍정적 응답.
- **중복 방지**: _checkExistingRecord()에서 동일 activityRecordId에 대한 기존 관찰 기록이 있으면 바로 결과 화면으로 리다이렉트.
- **ObservationInterpreter**: 개발기획서 6-3 로직을 그대로 구현. 2단계가 비어있으면 1단계만으로 해석. overallRatio 기반 4단계 레벨 산정.
- **PopScope**: 결과 화면에서 뒤로가기 시 폼으로 돌아가지 않고 홈으로 이동 (PopScope canPop: false).
- **다크 모드**: 모든 위젯에서 isDark 분기 처리. 카드 배경, 텍스트 색상, ExpansionTile 배경 등 다크 모드 대응 완료.
- **ObservationReflexData**: reflex_data.dart와 별개로 관찰 2단계 전용 반사 데이터 파일 생성. 항목 ID 기반 매핑으로 InfoTerm에 전문 용어명/설명 제공.

## 사양서 기준 자체 점검

### 4-1. 파일 구조 검증
- [x] observation_record.dart - 11개 필드 포함
- [x] observation_item.dart - id, step, text, options 필드 포함
- [x] observation_record_dao.dart - 5개 메서드 정의
- [x] observation_items_seed.dart - 14개 시드 데이터 포함
- [x] observation_interpreter.dart - interpret, getMessage, getSolutions 정적 메서드 정의
- [x] observation_form_screen.dart 존재
- [x] observation_result_screen.dart 존재
- [x] observation_item_tile.dart 존재
- [x] observation_providers.dart 존재

### 4-2. 기능 검증 - ObservationFormScreen
- [x] 타이머 완료 -> "관찰 기록하기" -> ObservationFormScreen 이동
- [x] 앱 바 제목 "오늘 아기는 어땠나요?"
- [x] 상단 안심 메시지 "정답은 없어요. 느낌대로 기록해주세요"
- [x] 1단계 섹션 제목 "활동 직후 모습" + "3개만 해도 충분해요"
- [x] 핵심 4항목 기본 펼침
- [x] 3단 라디오 그룹 (예/보통/아니오)
- [x] 선택 시 warmOrange 배경 + white 텍스트
- [x] "나머지 항목 더 보기" ExpansionTile
- [x] "자세히 기록하고 싶다면" ExpansionTile (기본 접힘)
- [x] 2단계 7항목 (뚜렷함/약하게/잘 안 보임)
- [x] InfoTerm 툴팁 (2단계 항목)
- [x] 인라인 메모 필드 (플레이스홀더 "한 줄 메모를 남겨보세요")
- [x] 하단 고정 [기록 완료] CTA 버튼
- [x] 핵심 3항목 미만 -> 비활성 (mutedBeige)
- [x] 핵심 3항목 이상 -> 활성 (warmOrange)
- [x] 기록 완료 -> DB 저장 -> ObservationResultScreen 이동
- [x] 2단계 미입력도 완료 가능
- [x] 메모 미입력도 완료 가능

### 4-3. 기능 검증 - ObservationResultScreen
- [x] 자동 전환 표시
- [x] 안심 메시지 카드 (mintTint 배경, 16dp 모서리, 24dp 패딩)
- [x] 아이콘 표시 (레벨별 색상)
- [x] 메인 메시지 H1 중앙 정렬
- [x] 서브 메시지 Body1 warmGray 중앙 정렬
- [x] 레벨 0 메시지 "무리 없이 잘 진행된 것 같아요"
- [x] 솔루션 목록 표시
- [x] 안심 서브 메시지 "관찰 기록이 쌓이면 아기만의 성장 패턴이 보여요"
- [x] [홈으로] CTA 버튼 -> /home 이동
- [x] 숫자 없이 말로만 표현
- [x] 뒤로가기 -> 홈 이동 (PopScope)

### 4-4. 기능 검증 - 홈 화면 연동
- [x] 관찰 기록 있으면 실제 데이터 표시 (해석 결과 메시지)
- [x] 관찰 기록 없으면 빈 상태 메시지

### 4-5. 기능 검증 - 데이터 저장
- [x] step1Responses JSON 형식 저장
- [x] step2Responses JSON 형식 저장 (미입력 시 빈 Map {})
- [x] adjustmentNote 저장 (미입력 시 null)
- [x] interpretationLevel 0~3 저장
- [x] activityRecordId 올바르게 저장
- [x] 중복 기록 방지 (_checkExistingRecord)

### 4-6. 기능 검증 - ObservationInterpreter 로직
- [x] 모든 최대값 -> 레벨 0
- [x] 모든 최소값 -> 레벨 3
- [x] 2단계 비어있을 때 1단계만으로 해석
- [x] getMessage(0) "무리 없이 잘 진행된 것 같아요." 포함
- [x] getMessage(3) "전문가와 이야기해 보세요" 포함
- [x] getSolutions(0) 최소 1개 이상 반환

### 4-7. UX 원칙 검증
- [x] "3개만 해도 충분해요" 안내 + 3항목 활성화
- [x] 숫자 없이 말로만 피드백
- [x] 부모 언어 사용 + InfoTerm으로 전문 용어
- [x] 4탭으로 관찰 기록 완료 가능
- [x] 죄책감 유발 요소 없음

### 4-8. 디자인 검증
- [x] cream 배경색 (Scaffold)
- [x] mintTint 안심 카드 배경
- [x] warmOrange CTA 버튼 (52dp, 24dp 모서리)
- [x] mutedBeige 비활성 CTA
- [x] 3단 라디오 그룹 색상 (paleCream/warmOrange)
- [x] 텍스트 입력 필드 (lightBeige 테두리, warmOrange 포커스)
- [x] ExpansionTile (paleCream 배경, 12dp 모서리)
- [x] 하단 고정 버튼 (white 배경, 상단 그림자)
- [x] 관찰 항목 카드 (white 배경, 12dp 모서리, 16dp 패딩)
- [x] 모든 텍스트 Theme.of(context).textTheme

### 4-9. 다크 모드 검증
- [x] darkBg 배경
- [x] darkCard 카드 배경
- [x] darkTextPrimary 텍스트
- [x] warmOrange CTA 유지
- [x] mintTint -> darkCard 조정

### 4-12. ValueKey 검증
- [x] observation_form_screen
- [x] observation_result_screen
- [x] obs_item_${item.id} (1단계/2단계)
- [x] obs_option_${item.id}_${optionIndex}
- [x] observation_submit_button
- [x] observation_go_home_button
- [x] observation_memo_field
- [x] observation_result_card
- [x] obs_step1_expansion
- [x] obs_step2_expansion

### 4-13. 라우팅 검증
- [x] /observation/:activityRecordId 등록
- [x] /observation/:activityRecordId/result 등록
- [x] 타이머 완료 -> /observation/{id} 이동
- [x] 기록 저장 -> /observation/{id}/result 이동
- [x] 결과 [홈으로] -> /home 이동

### 4-14. 코드 품질 검증
- [x] 모든 UI 텍스트 AppStrings 참조
- [x] 모든 텍스트 스타일 Theme.of(context).textTheme
- [x] 모든 색상 AppColors 또는 theme.colorScheme
- [x] flutter analyze 에러 0개
- [x] 앱 정상 빌드 완료

### 미구현/다음 스프린트 연기
- [ ] 조부모 모드 +4sp 텍스트 크기 증가 (테마 레벨 처리 필요, Sprint 01 인프라 의존)
- [ ] 중간 저장 자동 (빠른 이탈 대응) -- 현재 폼 상태는 Provider로 관리되지만 DB에 중간 저장하는 로직은 미구현. 앱 종료 시 데이터 유실 가능.
