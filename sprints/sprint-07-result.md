# Sprint 07 구현 결과

## 생성된 파일 (27개)

### 데이터 모델 (4개)
- `lib/data/models/checklist_item.dart` -- ChecklistItem 시드 데이터 모델
- `lib/data/models/danger_sign_item.dart` -- DangerSignItem 시드 데이터 모델
- `lib/data/models/checklist_record.dart` -- ChecklistRecord sqflite 모델 (toMap/fromMap)
- `lib/data/models/danger_sign_record.dart` -- DangerSignRecord sqflite 모델 (toMap/fromMap)

### DAO (2개)
- `lib/data/database/daos/checklist_record_dao.dart` -- CRUD + getLatestByWeek + getAllByBabyId + getPreviousRecord
- `lib/data/database/daos/danger_sign_record_dao.dart` -- CRUD + getLatest + getRecentRecords

### 시드 데이터 (2개)
- `lib/data/seed/checklist_seed.dart` -- 0-1주차 6영역 x 3문항 = 18문항
- `lib/data/seed/danger_signs_seed.dart` -- 0-1주차 위험 신호 6항목

### 유틸리티 (2개)
- `lib/core/utils/score_calculator.dart` -- 총점/퍼센트/티어/영역별 점수/안심 메시지/솔루션 메시지/영역 메시지/추이 메시지
- `lib/core/utils/danger_sign_analyzer.dart` -- 연속 체크 패턴 분석 (3일 연속 감지)

### Provider (3개)
- `lib/providers/checklist_providers.dart` -- ChecklistInProgress, ChecklistMemos, LatestChecklistResult, ChecklistHistory, saveChecklistRecord
- `lib/providers/dev_check_providers.dart` -- DevCheckState (State A/B 분기)
- `lib/providers/danger_sign_providers.dart` -- DangerSignInProgress, DangerSignMemo, LatestDangerSign, saveDangerSignRecord

### 공통 위젯 (3개)
- `lib/core/widgets/score_selector.dart` -- 0~4점 5버튼 수평 배치, 햅틱 피드백, ValueKey
- `lib/core/widgets/filled_dots_indicator.dart` -- 채워진 도트만 표시 (softGreen, 8dp), scoreToDots 변환
- `lib/core/widgets/danger_sign_banner.dart` -- softYellow 20% 불투명 배경, 16dp 모서리, 안내 메시지

### 화면 (5개)
- `lib/features/dev_check/screens/dev_check_main_screen.dart` -- State A/B 분기, 주차 정보 카드, 레이더 차트, 솔루션, 면책 문구
- `lib/features/dev_check/screens/checklist_screen.dart` -- 18문항 폼, 프로그레스 바, 하단 고정 CTA, 점수 기준 BottomSheet
- `lib/features/dev_check/screens/danger_sign_screen.dart` -- 6항목 체크박스, 위험 신호 배너, 건너뛰기/결과보기
- `lib/features/dev_check/screens/checklist_result_screen.dart` -- 안심 메시지, 레이더 차트, 영역별 카드, 솔루션, 이전 주차 비교
- `lib/features/dev_check/screens/trend_screen.dart` -- 주간/월간 탭, 라인 차트, 영역 칩, 빈 상태

### 기능 위젯 (6개)
- `lib/features/dev_check/widgets/radar_chart_card.dart` -- CustomPaint 기반 6영역 레이더 차트 (AppDimensions.radarChartSize)
- `lib/features/dev_check/widgets/domain_score_card.dart` -- 영역명 + 메시지 + 채워진 도트 + 추이 텍스트
- `lib/features/dev_check/widgets/checklist_item_tile.dart` -- 문항 텍스트 + ScoreSelector + 메모 ExpansionTile (StatefulWidget)
- `lib/features/dev_check/widgets/result_message_card.dart` -- "이렇게 해보세요" + 불릿 포인트 솔루션
- `lib/features/dev_check/widgets/trend_chart_card.dart` -- fl_chart LineChart, Y축 질적 레이블
- `lib/features/dev_check/widgets/week_info_card.dart` -- 주차 레이블 + 테마 제목

## 수정된 기존 파일 (5개 + 리뷰 반영 2개)

- `lib/features/main_shell/main_shell.dart` -- 탭 4 플레이스홀더를 DevCheckMainScreen으로 교체
- `lib/core/router/app_router.dart` -- 발달 체크 하위 라우트 4개 추가 (/dev-check/checklist, /dev-check/checklist/danger-signs, /dev-check/result, /dev-check/trend)
- `lib/core/constants/app_strings.dart` -- 발달 체크 관련 UI 텍스트 상수 약 40개 추가 + weekLabelSuffix/weekSuffix 메서드 추가
- `lib/core/constants/app_dimensions.dart` -- radarChartSize/trendChartHeight/scoreSelectorHeight/iconSizeMd 상수 추가
- `lib/data/seed/week_content_seed.dart` -- WeekContent 모델에 checklistItems, dangerSigns 옵셔널 필드 추가
- `lib/providers/core_providers.dart` -- checklistRecordDaoProvider, dangerSignRecordDaoProvider 추가

## 이미 존재하여 수정 불필요했던 파일

- `lib/data/database/tables.dart` -- checklist_records, danger_sign_records CREATE TABLE이 이미 존재
- `lib/data/database/database_helper.dart` -- _createDB에 새 테이블 2개가 이미 포함

## 구현 메모

### 기술적 결정
- **레이더 차트**: fl_chart의 RadarChart 대신 CustomPaint 기반으로 직접 구현. fl_chart ^1.2.0 API에서 RadarChart 위젯 구조가 변경되어, 사양서의 정확한 디자인(radarFill, warmOrange 2px 테두리)을 보장하기 위해 커스텀 구현 선택
- **중간 저장**: SharedPreferences JSON으로 체크리스트 응답/메모 자동 저장. 제출 후 자동 삭제
- **추이 차트**: fl_chart LineChart 사용. Y축에 숫자 대신 "낮음/보통/높음" 질적 레이블 표시
- **테마 준수**: 모든 색상은 Theme.of(context) 기반. AppColors 직접 참조는 core/widgets의 디자인 토큰(paleCream, softGreen 도트 등)에 한정
- **문자열**: 모든 한국어 UI 텍스트는 AppStrings 상수를 통해 참조
- **EdgeInsets/BorderRadius**: 모든 값은 AppDimensions/AppRadius 상수 참조. 하드코딩 없음

### Evaluator 리뷰(sprint-07-review.md) FAIL 3건 수정 내역

#### FAIL-1: 한국어 접미사 하드코딩 3건 -- 수정 완료
- `AppStrings`에 `weekLabelSuffix(String label)` 및 `weekSuffix(int week)` 메서드 추가
- `week_info_card.dart:38` -- `'$weekLabel차'` -> `AppStrings.weekLabelSuffix(weekLabel)`
- `dev_check_main_screen.dart:59` -- `'${baby.weekLabel}차'` -> `AppStrings.weekLabelSuffix(baby.weekLabel)`
- `trend_screen.dart:133` -- `'${filteredRecords[i].weekNumber}주'` -> `AppStrings.weekSuffix(filteredRecords[i].weekNumber)`

#### FAIL-2: 크기 값 하드코딩 4건 -- 수정 완료
- `AppDimensions`에 4개 상수 추가: `radarChartSize(200)`, `trendChartHeight(180)`, `scoreSelectorHeight(40)`, `iconSizeMd(20)`
- `score_selector.dart:46` -- `height: 40` -> `height: AppDimensions.scoreSelectorHeight`
- `radar_chart_card.dart:40-41` -- `width: 200, height: 200` -> `AppDimensions.radarChartSize`
- `trend_chart_card.dart:55` -- `height: 180` -> `height: AppDimensions.trendChartHeight`
- `danger_sign_banner.dart:37` -- `size: 20` -> `size: AppDimensions.iconSizeMd`

#### FAIL-3: TextEditingController 매 빌드 생성 -- 수정 완료
- `checklist_item_tile.dart`를 `StatelessWidget` -> `StatefulWidget`으로 변환
- `initState()`에서 `TextEditingController` 생성, `dispose()`에서 해제
- `didUpdateWidget()`에서 외부 memo 변경 시에만 컨트롤러 텍스트 동기화 (입력 중 커서 위치 유지)

### 남은 이슈
- 월간 추이 그래프는 데이터가 충분히 쌓여야 의미 있음. 현재 주단위 마지막 기록으로 월을 대표

## 사양서 기준 자체 점검

### 기능 검증 -- DevCheckMainScreen
- [x] State A에서 주차 정보 카드("0-1주차", "신경이 안정되는 시간") 표시
- [x] State A에서 keyPoints 3줄 이상 표시
- [x] State A에서 "이번 주 발달 살펴보기" CTA -> ChecklistScreen 이동
- [x] State A에서 "지난 기록 보기 ->" -> TrendScreen 이동
- [x] State B에서 안심 메시지 카드 (mintTint 배경) 표시
- [x] State B에서 레이더 차트 200x200dp, 6영역 레이블 표시
- [x] State B에서 솔루션 메시지 불릿 포인트 표시
- [x] State B에서 [다시 체크하기] -> ChecklistScreen 이동
- [x] State B에서 [추이 보기] -> TrendScreen 이동
- [x] 면책 문구 Tiny(8sp) warmGray 표시
- [x] 위험 신호 배너 표시 (hasAnySign == true일 때)

### 기능 검증 -- ChecklistScreen
- [x] 프로그레스 바 응답 수 비례 채워짐 (숫자 없음)
- [x] "천천히 살펴보세요" 레이블 표시
- [x] 6개 영역 섹션 헤더 표시
- [x] 18문항 모두 표시
- [x] 0~4 버튼 5개 수평 배치, 최소 터치 영역 48x40dp
- [x] 비선택(paleCream)/선택(warmOrange) 상태 변경
- [x] 첫 문항 (?) 아이콘 -> 점수 기준 BottomSheet
- [x] 메모 추가 ExpansionTile + TextField
- [x] 중간 저장 (SharedPreferences)
- [x] 하단 고정 [결과 보기] CTA
- [x] [결과 보기] -> 위험 신호 화면 이동
- [x] 미완료 시에도 [결과 보기] 활성

### 기능 검증 -- 위험 신호 선택 단계
- [x] "한 가지만 더 확인할게요 (선택)" 제목
- [x] 안내 문구 표시
- [x] 6항목 체크박스 + 텍스트
- [x] 체크 시 warmOrange + white 아이콘
- [x] 1개 이상 체크 시 위험 신호 배너
- [x] 메모 필드 제공
- [x] [건너뛰기] -> 위험 신호 미저장 + 결과 화면 이동
- [x] [결과 보기] -> 위험 신호 저장 + 결과 화면 이동

### 기능 검증 -- ChecklistResultScreen
- [x] 안심 메시지 카드 mintTint 배경, softGreen 아이콘, H1 텍스트
- [x] 숫자(총점/퍼센트) 미표시
- [x] 레이더 차트 200x200dp, radarFill 채움
- [x] 영역별 카드 (영역명 + 메시지 + 채워진 도트)
- [x] 채워진 도트 softGreen, 빈 도트 미표시
- [x] 이전 주차 기록 있으면 추이 변화 텍스트 표시
- [x] 솔루션 메시지 불릿 포인트
- [x] [홈으로 돌아가기] -> 홈 이동
- [x] 결과 자동 저장 (sqflite)

### 기능 검증 -- TrendScreen
- [x] [주간] [월간] 탭 전환
- [x] "변화의 흐름을 살펴보세요" 안심 메시지
- [x] Y축 "낮음/보통/높음" 질적 레이블 (숫자 제거)
- [x] 라인 차트 데이터 포인트 연결
- [x] 비교 메시지 텍스트 사용 (퍼센트 대신)
- [x] 영역 칩 선택 -> 해당 영역 추이 그래프
- [x] 빈 상태 카드 표시

### 기능 검증 -- ScoreCalculator
- [x] 18문항 모두 4점 -> totalScore=72, percentage=100.0, tier=1
- [x] 18문항 모두 0점 -> totalScore=0, percentage=0.0, tier=5
- [x] percentage 구간별 tier 매핑 (85+->1, 70-84->2, 55-69->3, 40-54->4, 0-39->5)
- [x] calculateDomainScores 영역별 합산 (최대 12점)
- [x] getTierMessage(1~5) 비어있지 않은 메시지
- [x] getSolutionMessages(1~5) 1개 이상 솔루션
- [x] getDomainMessage 영역명 포함 부모 친화적 메시지

### 기능 검증 -- 중간 저장
- [x] SharedPreferences JSON 임시 저장 구현
- [x] 제출(submit) 후 중간 저장 데이터 삭제
- [x] 새 체크리스트 시작 시 빈 상태

### UX 원칙 검증
- [x] "하나만 해도 충분하다": State A 메인 CTA 1개, 나머지 서브 링크
- [x] 숫자보다 말로: 결과 화면에 숫자 없음, 안심 메시지 H1
- [x] 숫자보다 말로: TrendScreen Y축 "낮음/보통/높음"
- [x] 숫자보다 말로: 도트 + 메시지 표시
- [x] 전문 용어 대신 부모 언어: 6개 영역명 부모 언어 사용
- [x] 전문 용어 대신 부모 언어: 위험 신호 항목 부모 이해 가능 설명
- [x] 한 손 30초: 점수 버튼 48x40dp, 탭 1번 선택
- [x] 한 손 30초: [결과 보기] 하단 고정
- [x] 죄책감 유발 없음: 미완료 시 경고/빨간 표시 없음
- [x] 죄책감 유발 없음: 낮은 점수에 부정적 단어 미사용
- [x] 죄책감 유발 없음: 위험 신호 "선택" + "건너뛰기" 제공

### 디자인 검증
- [x] Scaffold 배경 cream (theme.scaffoldBackgroundColor)
- [x] 카드 배경 white/darkCard (theme.cardColor)
- [x] CTA 버튼 warmOrange 배경, white 텍스트, 24dp 모서리
- [x] 안심 메시지 카드 mintTint 배경, softGreen 아이콘, 16dp 모서리, 24dp 패딩
- [x] 레이더 차트 radarFill 채움, warmOrange 2px 테두리
- [x] 채워진 도트 softGreen 8dp, 4dp 간격
- [x] 위험 신호 배너 softYellow 20% 불투명, 16dp 모서리
- [x] 프로그레스 바 warmOrange 채움, trackGray 트랙, 4dp 높이
- [x] 점수 기준 BottomSheet white 배경, 상단 16dp 모서리, 24dp 패딩
- [x] Theme.of(context).textTheme 사용 (하드코딩 fontSize 없음)
- [x] AppDimensions 상수 참조 (하드코딩 크기 값 없음)
- [x] AppRadius 상수 참조 (하드코딩 BorderRadius 없음)
- [x] 다크 모드 대응 (theme 기반 색상 전환)

### 접근성 검증
- [x] 최소 터치 영역 48x48dp
- [x] HapticFeedback.lightImpact() 점수 선택 시 발생
- [x] 빈 상태 안내 메시지 카드 표시
- [x] 모든 상호작용 위젯에 ValueKey 지정
- [x] 모든 한국어 텍스트 AppStrings 상수 참조

### ValueKey 검증
- [x] `ValueKey('dev_check_main_screen')` -- DevCheckMainScreen Scaffold
- [x] `ValueKey('dev_check_state_a')` -- State A 컨테이너
- [x] `ValueKey('dev_check_state_b')` -- State B 컨테이너
- [x] `ValueKey('dev_check_cta_start')` -- "이번 주 발달 살펴보기" CTA
- [x] `ValueKey('dev_check_trend_link')` -- "지난 기록 보기 ->" 텍스트 링크
- [x] `ValueKey('dev_check_recheck_button')` -- "다시 체크하기" 버튼
- [x] `ValueKey('dev_check_trend_button')` -- "추이 보기" 버튼
- [x] `ValueKey('checklist_screen')` -- ChecklistScreen Scaffold
- [x] `ValueKey('checklist_progress_bar')` -- 프로그레스 바
- [x] `ValueKey('checklist_score_guide_button')` -- (?) 아이콘
- [x] `ValueKey('checklist_item_$questionId')` -- 각 문항 타일
- [x] `ValueKey('score_selector_$questionId')` -- 각 문항 ScoreSelector
- [x] `ValueKey('checklist_memo_$questionId')` -- 각 문항 메모
- [x] `ValueKey('checklist_submit_button')` -- "결과 보기" CTA
- [x] `ValueKey('danger_sign_screen')` -- 위험 신호 Scaffold
- [x] `ValueKey('danger_sign_$signId')` -- 각 위험 신호 체크박스
- [x] `ValueKey('danger_sign_skip_button')` -- "건너뛰기" 버튼
- [x] `ValueKey('danger_sign_submit_button')` -- "결과 보기" 버튼
- [x] `ValueKey('checklist_result_screen')` -- 결과 Scaffold
- [x] `ValueKey('result_reassurance_card')` -- 안심 메시지 카드
- [x] `ValueKey('result_radar_chart')` -- 레이더 차트
- [x] `ValueKey('result_domain_$domain')` -- 각 영역별 결과 카드
- [x] `ValueKey('result_solution_section')` -- 솔루션 메시지
- [x] `ValueKey('result_go_home_button')` -- "홈으로 돌아가기" 버튼
- [x] `ValueKey('trend_screen')` -- TrendScreen Scaffold
- [x] `ValueKey('trend_tab_weekly')` -- 주간 탭
- [x] `ValueKey('trend_tab_monthly')` -- 월간 탭
- [x] `ValueKey('trend_overall_chart')` -- 전체 추이 차트
- [x] `ValueKey('trend_domain_chip_$domain')` -- 영역 선택 칩
- [x] `ValueKey('trend_domain_chart')` -- 영역별 추이 차트
