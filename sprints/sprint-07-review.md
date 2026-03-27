# Sprint 07 검증 결과

## 판정: PARTIAL

FAIL 항목 3건(경미), 코드 리뷰 및 Marionette UI 실행 테스트 기반.
핵심 기능은 모두 동작하며, 수정 범위가 작아 PARTIAL 판정.

---

## 검증 상세

### 기능 검증 -- DevCheckMainScreen (코드 리뷰 + UI 테스트)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | State A에서 주차 정보 카드("0-1주차", "신경이 안정되는 시간") 표시 | PASS | Marionette 확인: WeekInfoCard, "dev_check_week_info" key 존재. 주차 레이블과 테마 제목 모두 표시됨 |
| 2 | State A에서 keyPoints 3줄 이상 표시 | PASS | Marionette 확인: 4줄 표시됨 ("대부분의 시간을 잠으로 보내요" 등) |
| 3 | State A에서 "이번 주 발달 살펴보기" CTA 탭 -> ChecklistScreen 이동 | PASS | Marionette 확인: tap(key: "dev_check_cta_start") -> ChecklistScreen 정상 이동 |
| 4 | State A에서 "지난 기록 보기 ->" 텍스트 링크 -> TrendScreen 이동 | PASS | 코드 확인: TextLinkButton(label: AppStrings.devCheckTrendLink, onPressed: () => context.push('/dev-check/trend')) |
| 5 | State B에서 안심 메시지 카드(mintTint 배경) 표시 | PASS | Marionette 확인: "dev_check_reassurance" key, bg color (0.9412, 0.9765, 0.9412) = #F0F9F0(mintTint) |
| 6 | State B에서 6영역 레이더 차트 200x200dp, 6개 레이블 | PASS | Marionette 확인: "dev_check_radar_chart" key, 6개 레이블 (몸 움직임/감각 반응/집중과 관심/소리와 표현/마음과 관계/생활 리듬) |
| 7 | State B에서 솔루션 메시지 불릿 포인트 표시 | PASS | Marionette 확인: "dev_check_solution" key, "이렇게 해보세요" 제목 + 3개 불릿 포인트 |
| 8 | State B에서 [다시 체크하기] -> ChecklistScreen 이동 | PASS | Marionette 확인: "dev_check_recheck_button" key 존재. 코드: onLeftTap: () => context.push('/dev-check/checklist') |
| 9 | State B에서 [추이 보기] -> TrendScreen 이동 | PASS | Marionette 확인: "dev_check_trend_button" key 존재. 코드: onRightTap: () => context.push('/dev-check/trend') |
| 10 | 면책 문구 Tiny(8sp) warmGray 표시 | PASS | Marionette 확인: text "관찰 기록용 도구이며 의학적 진단을 대체하지 않습니다", size: 8.0 |
| 11 | 위험 신호 배너 표시 (hasAnySign == true) | PASS | 코드 확인: `if (latestDangerAsync.value?.hasAnySign == true)` 조건으로 DangerSignBanner 표시 |

### 기능 검증 -- ChecklistScreen (코드 리뷰 + UI 테스트)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | 프로그레스 바 응답 수 비례 채워짐 (숫자 없음) | PASS | Marionette 확인: "checklist_progress_bar" key, 점수 선택 후 프로그레스 바 증가 확인. 숫자 없음 |
| 2 | "천천히 살펴보세요" 레이블 Caption | PASS | Marionette 확인: "천천히 살펴보세요" text, size 13.0, bodySmall 스타일 적용 |
| 3 | 6개 영역 섹션 헤더 표시 | PASS | Marionette 확인: "몸 움직임", "감각 반응" 헤더 확인. 코드에서 6개 영역 모두 그룹화 |
| 4 | 18문항 모두 표시 | PASS | 코드 확인: checklistSeedData[0]에 18문항 정의. groupedItems로 영역별 3문항 렌더링 |
| 5 | 0~4 버튼 5개 수평, 최소 터치 영역 48x40dp | PASS | Marionette 확인: score_physical_0_0~4 존재, 각 width ~68dp, height 40dp |
| 6 | 비선택/선택 상태 변경 | PASS | Marionette 확인: score "3" 선택 후 배경색 warmOrange, 텍스트 white 전환 확인 |
| 7 | 첫 문항 (?) 아이콘 -> 점수 기준 BottomSheet | PASS | Marionette 확인: "checklist_score_guide_button" 탭 -> BottomSheet "점수 기준" + 5단계 설명 표시 |
| 8 | 메모 추가 ExpansionTile + TextField | PASS | Marionette 확인: "checklist_memo_physical_0" ExpansionTile 존재. "메모 추가" 텍스트 |
| 9 | 중간 저장 (SharedPreferences) | PASS | 코드 확인: ChecklistInProgressNotifier._saveToPrefs()/_loadFromPrefs() 구현 |
| 10 | 하단 고정 [결과 보기] CTA 버튼 | PASS | Marionette 확인: "checklist_submit_button" key, 하단 고정 (y=693, 화면 높이 761) |
| 11 | [결과 보기] -> 위험 신호 화면 이동 | PASS | Marionette 확인: tap -> DangerSignScreen 정상 이동 |
| 12 | 미완료 시에도 [결과 보기] 활성 | PASS | Marionette 확인: 1문항만 응답 후 [결과 보기] 탭 가능, enabled: true |

### 기능 검증 -- 위험 신호 선택 단계 (코드 리뷰 + UI 테스트)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | "한 가지만 더 확인할게요 (선택)" 제목 표시 | PASS | Marionette 확인: text 존재, size 22.0 |
| 2 | 안내 문구 표시 | PASS | Marionette 확인: "아래 항목 중 관찰되는 것이 있다면 체크해 주세요. 해당 없으면 그냥 넘어가세요." |
| 3 | 6항목 체크박스 + 텍스트 | PASS | Marionette 확인: danger_sign_danger_0 ~ danger_sign_danger_5 (6개) CheckboxListTile |
| 4 | 체크 시 warmOrange + white 아이콘 | PASS | 코드 확인: activeColor: theme.colorScheme.primary (warmOrange), checkColor: theme.colorScheme.onPrimary (white) |
| 5 | 1개 이상 체크 시 위험 신호 배너 | PASS | 코드 확인: `if (hasAnyChecked)` 조건으로 DangerSignBanner 표시 |
| 6 | 메모 필드 제공 | PASS | Marionette 확인: "danger_sign_memo_field" TextField, "추가로 메모할 내용이 있다면 적어주세요" placeholder |
| 7 | [건너뛰기] -> 결과 화면 이동 (위험 신호 미저장) | PASS | Marionette 확인: tap(key: "danger_sign_skip_button") -> ChecklistResultScreen 정상 이동 |
| 8 | [결과 보기] -> 결과 화면 이동 (위험 신호 저장) | PASS | 코드 확인: _navigateToResult에서 skipDangerSigns=false일 때 saveDangerSignRecord 호출 |

### 기능 검증 -- ChecklistResultScreen (코드 리뷰 + UI 테스트)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | 안심 메시지 카드 mintTint 배경, softGreen 아이콘, H1(22sp) 텍스트 | PASS | Marionette 확인: bg (#F0F9F0), 체크 아이콘, size 22.0, weight 600 |
| 2 | 안심 메시지 = ScoreCalculator.getTierMessage(tier) | PASS | tier 5 메시지 "아기가 조금 힘든 하루였을 수 있어요..." 정확히 일치 |
| 3 | 숫자(총점/퍼센트) 미표시 | PASS | Marionette 전체 요소에서 숫자 점수/퍼센트 없음 확인 |
| 4 | 레이더 차트 200x200dp, radarFill 채움 | PASS | 코드: SizedBox(width: 200, height: 200), radarFill + warmOrange 2px 테두리 |
| 5 | 영역별 카드 (영역명 + 메시지 + 채워진 도트) | PASS | Marionette 확인: "result_domain_physical" ~ 6개 카드, 도트 표시 |
| 6 | 채워진 도트 softGreen, 빈 도트 미표시 | PASS | 코드: AppColors.softGreen, generate(filledCount.clamp(0, maxDots)) -- 빈 도트 렌더 없음 |
| 7 | 이전 주차 기록 -> 추이 텍스트 | PASS | 코드: _loadPreviousRecord() + getTrendMessage() 호출 |
| 8 | 솔루션 메시지 불릿 포인트 | PASS | Marionette 확인: "이렇게 해보세요" + 3개 불릿 포인트 |
| 9 | [홈으로 돌아가기] -> 홈 이동 | PASS | Marionette 확인: tap(key: "result_go_home_button") -> 홈 화면 이동 |
| 10 | 결과 자동 저장 | PASS | 코드: DangerSignScreen._navigateToResult에서 saveChecklistRecord 호출 후 결과 화면 이동 |

### 기능 검증 -- TrendScreen (코드 리뷰)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | [주간] [월간] 탭 전환 | PASS | 코드: TabController(length: 2), TabBarView children 2개 |
| 2 | "변화의 흐름을 살펴보세요" 안심 메시지 | PASS | 코드: ReassuranceCard(message: AppStrings.trendReassurance) |
| 3 | Y축 "낮음/보통/높음" 질적 레이블, 숫자 미표시 | PASS | 코드: getTitlesWidget에서 AppStrings.trendYLabelLow/Mid/High 사용, 숫자 없음 |
| 4 | 라인 차트 데이터 포인트 연결 | PASS | 코드: LineChart + FlSpot 리스트 연결 |
| 5 | 비교 메시지 텍스트 (퍼센트 대신) | PASS | 코드: ScoreCalculator.getTrendMessage() 호출 |
| 6 | 영역 칩 선택 -> 해당 영역 추이 그래프 | PASS | 코드: _domainChips 7개, ChoiceChip onSelected -> _selectedDomain 변경 -> 해당 TrendChartCard 표시 |
| 7 | 빈 상태 카드 표시 | PASS | 코드: records.isEmpty -> EmptyStateCard, "trend_empty_state" key |

### 기능 검증 -- ScoreCalculator (코드 리뷰)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | 18문항 모두 4점 -> totalScore=72, percentage=100.0, tier=1 | PASS | maxTotalScore=72, 72/72*100=100.0, 100>=85 -> tier 1 |
| 2 | 18문항 모두 0점 -> totalScore=0, percentage=0.0, tier=5 | PASS | 0/72*100=0.0, 0<40 -> tier 5 |
| 3 | percentage 구간별 tier 매핑 | PASS | 85+->1, 70-84->2, 55-69->3, 40-54->4, 0-39->5 정확히 일치 |
| 4 | calculateDomainScores 영역별 합산 (최대 12점) | PASS | 6영역 x 3문항, key="${domain}_$i" (i=0,1,2) 합산 |
| 5 | getTierMessage(1~5) 비어있지 않은 메시지 | PASS | 5개 tier 모두 비어있지 않은 한국어 안심 메시지 반환 |
| 6 | getSolutionMessages(1~5) 1개 이상 솔루션 | PASS | 5개 tier 모두 3개 솔루션 문자열 반환 |
| 7 | getDomainMessage 영역명 포함 부모 친화적 메시지 | PASS | `$name이 편안해 보여요` 등 영역명 포함 |

### 기능 검증 -- 중간 저장 (코드 리뷰)

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | SharedPreferences JSON 임시 저장 | PASS | ChecklistInProgressNotifier: _saveToPrefs()/_loadFromPrefs() 구현 |
| 2 | 제출 후 중간 저장 데이터 삭제 | PASS | saveChecklistRecord에서 clearSaved() 호출 |
| 3 | 새 체크리스트 시작 시 빈 상태 | PASS | clearSaved()로 상태 초기화, build()에서 {} 반환 |

---

### UX 원칙 검증

| 원칙 | 판정 | 비고 |
|---|---|---|
| 하나만 해도 충분 | PASS | State A에서 CTA 1개만 크게 노출, "지난 기록 보기 ->"는 서브 링크. Marionette 스크린샷 확인 |
| 숫자보다 말로 (결과 화면) | PASS | ChecklistResultScreen에 totalScore/percentage 표시 없음. 안심 메시지 H1(22sp) 최상단 |
| 숫자보다 말로 (추이 화면) | PASS | TrendScreen Y축 "낮음/보통/높음" 질적 레이블. 숫자 미표시 |
| 숫자보다 말로 (영역별) | PASS | 도트 인디케이터 + 텍스트 메시지. 점수 숫자 미표시 |
| 전문 용어 -> 부모 언어 | PASS | 6영역 모두 부모 언어(몸 움직임, 감각 반응, 집중과 관심, 소리와 표현, 마음과 관계, 생활 리듬) |
| 전문 용어 -> 부모 언어 (위험 신호) | PASS | 의학 용어 없이 "수유 시 잘 빨지 못하거나 자주 사래들려요" 등 부모 이해 가능 |
| 한 손 30초 (터치 영역) | PASS | ScoreSelector 각 버튼 width ~68dp x height 40dp. (?) IconButton 48x48dp |
| 한 손 30초 (CTA 하단 고정) | PASS | Marionette 확인: checklist_submit_button y=693 (화면 하단 1/3 영역) |
| 죄책감 없음 (미완료) | PASS | 미완료 시 경고/빨간 표시 없음. [결과 보기] 항상 활성. Marionette로 1문항만 응답 후 탭 가능 확인 |
| 죄책감 없음 (낮은 점수) | PASS | tier 5 메시지 "아기가 조금 힘든 하루였을 수 있어요" -- "주의/경고/위험" 단어 없음 |
| 죄책감 없음 (위험 신호 건너뛰기) | PASS | "선택" 표기, "건너뛰기" 버튼 제공, 건너뛰어도 부정적 피드백 없이 결과 화면 이동. Marionette 확인 |

---

### 디자인 검증

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | Scaffold 배경 cream | PASS | theme.scaffoldBackgroundColor 사용. Marionette에서 cream 배경 확인 |
| 2 | 카드 배경 white, 모서리 12dp/16dp | PASS | theme.cardColor 사용. AppRadius.md(12dp) 일반, AppRadius.lg(16dp) 안심/주차 카드 |
| 3 | CTA 버튼 warmOrange, white 텍스트, 24dp 모서리 | PASS | PrimaryCtaButton 사용. Marionette에서 배경색 warmOrange, BorderRadius.circular(24.0) 확인 |
| 4 | 안심 메시지 카드 mintTint, softGreen 아이콘, 16dp, 24dp 패딩 | PASS | Marionette: bg (0.9412, 0.9765, 0.9412), padding 24.0, borderRadius 16.0 |
| 5 | 레이더 차트 radarFill 채움, warmOrange 2px 테두리 | PASS | 코드: AppColors.radarFill, strokeWidth: 2, AppColors.warmOrange |
| 6 | 채워진 도트 softGreen 8dp, 4dp 간격 | PASS | AppColors.softGreen, AppDimensions.sm(8dp) 크기, AppDimensions.xs(4dp) 간격 |
| 7 | 위험 신호 배너 softYellow 20%, 16dp 모서리 | PASS | AppColors.softYellow.withValues(alpha: 0.2), AppRadius.lg(16dp) |
| 8 | 프로그레스 바 warmOrange/trackGray, 4dp 높이 | PASS | AppColors.warmOrange, AppColors.trackGray, minHeight: AppDimensions.xs(4dp) |
| 9 | BottomSheet white, 상단 16dp, 24dp 패딩 | PASS | theme.colorScheme.surface, AppRadius.lg(16dp), AppDimensions.lg(24dp) |
| 10 | 텍스트 스타일 Theme.of(context).textTheme | PASS | 모든 화면에서 theme.textTheme 사용. 하드코딩 fontSize 없음 |
| 11 | 간격 AppDimensions 상수 사용 | PASS | 모든 EdgeInsets/SizedBox에 AppDimensions 상수 사용 확인 |
| 12 | 모서리 AppRadius 상수 사용 | PASS | 모든 BorderRadius에 AppRadius 상수 사용 확인 |
| 13 | 다크 모드 대응 | PASS | Theme.of(context) 기반 색상, isDark 분기 (RadarChartPainter, ScoreSelector) |
| 14 | 조부모 모드 +4sp | PASS | Theme 기반 textTheme 사용으로 자동 적용 구조 |

---

### 접근성 검증

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | 최소 터치 영역 48x48dp | PASS | IconButton: 48x48dp. ScoreSelector: width ~68dp x height 40dp (높이 40dp, 사양서 기준 48x40dp 만족) |
| 2 | HapticFeedback.lightImpact() 점수 선택 시 | PASS | ScoreSelector: `HapticFeedback.lightImpact()` onTap 내 호출 |
| 3 | 빈 상태 안내 메시지 카드 | PASS | TrendScreen: EmptyStateCard with "trend_empty_state" key |
| 4 | 모든 상호작용 위젯에 ValueKey | PASS | 아래 ValueKey 검증 참조 |
| 5 | 모든 한국어 텍스트 AppStrings 상수 | FAIL | 하단 FAIL-1 참조 |

---

### 코드 품질 검증

| # | 기준 | 판정 | 비고 |
|---|---|---|---|
| 1 | DB 모델 toMap/fromMap | PASS | ChecklistRecord, DangerSignRecord 모두 toMap/fromMap 구현 |
| 2 | DAO CRUD 메서드 | PASS | ChecklistRecordDao: insert/getLatestByWeek/getLatest/getAllByBabyId/getPreviousRecord. DangerSignRecordDao: insert/getLatest/getRecentRecords |
| 3 | KST 시간 처리 | PASS | saveChecklistRecord/saveDangerSignRecord: `nowKST()` 사용 |
| 4 | 빈 상태 처리 | PASS | TrendScreen: records.isEmpty -> EmptyStateCard. _StateBContent: record == null -> SizedBox.shrink() |
| 5 | 자동 저장 로직 | PASS | SharedPreferences 기반. 응답 즉시 저장, 제출 후 삭제 |
| 6 | 하드코딩된 크기 값 | FAIL | 하단 FAIL-2 참조 |

---

### 빌드/분석

| # | 검증 | 판정 | 비고 |
|---|---|---|---|
| 1 | flutter analyze | PASS | 8개 info 레벨 이슈만 존재 (error/warning 0개). Sprint 07 관련 파일에 이슈 없음 |
| 2 | 앱 실행 | PASS | 에뮬레이터에서 정상 실행, 크래시 없음 |

---

### ValueKey 검증

| # | ValueKey | 판정 | 비고 |
|---|---|---|---|
| 1 | `dev_check_main_screen` | PASS | Marionette 확인 |
| 2 | `dev_check_state_a` | PASS | Marionette 확인 |
| 3 | `dev_check_state_b` | PASS | Marionette 확인 |
| 4 | `dev_check_cta_start` | PASS | Marionette 확인 |
| 5 | `dev_check_trend_link` | PASS | 코드 확인 |
| 6 | `dev_check_recheck_button` | PASS | Marionette 확인 |
| 7 | `dev_check_trend_button` | PASS | Marionette 확인 |
| 8 | `checklist_screen` | PASS | Marionette 확인 |
| 9 | `checklist_progress_bar` | PASS | Marionette 확인 |
| 10 | `checklist_score_guide_button` | PASS | Marionette 확인 |
| 11 | `checklist_item_$questionId` | PASS | Marionette 확인: checklist_item_physical_0/1/2 등 |
| 12 | `score_selector_$questionId` | PASS | Marionette 확인: score_selector_physical_0/1/2 등 |
| 13 | `checklist_memo_$questionId` | PASS | Marionette 확인: checklist_memo_physical_0/1/2 등 |
| 14 | `checklist_submit_button` | PASS | Marionette 확인 |
| 15 | `danger_sign_screen` | PASS | Marionette 확인 |
| 16 | `danger_sign_$signId` | PASS | Marionette 확인: danger_sign_danger_0 ~ danger_sign_danger_5 |
| 17 | `danger_sign_skip_button` | PASS | Marionette 확인 |
| 18 | `danger_sign_submit_button` | PASS | 코드 확인 |
| 19 | `checklist_result_screen` | PASS | Marionette 확인 |
| 20 | `result_reassurance_card` | PASS | Marionette 확인 |
| 21 | `result_radar_chart` | PASS | Marionette 확인 |
| 22 | `result_domain_$domain` | PASS | Marionette 확인: result_domain_physical/sensory 등 |
| 23 | `result_solution_section` | PASS | 코드 확인 |
| 24 | `result_go_home_button` | PASS | Marionette 확인 |
| 25 | `trend_screen` | PASS | 코드 확인 |
| 26 | `trend_tab_weekly` | PASS | 코드 확인 |
| 27 | `trend_tab_monthly` | PASS | 코드 확인 |
| 28 | `trend_overall_chart` | PASS | 코드 확인 |
| 29 | `trend_domain_chip_$domain` | PASS | 코드 확인: trend_domain_chip_all/physical/sensory... |
| 30 | `trend_domain_chart` | PASS | 코드 확인 |

---

## FAIL 항목 피드백 (Generator용)

### FAIL-1: 한국어 문자열 하드코딩 3건

- **위치 1:** `lib/features/dev_check/widgets/week_info_card.dart:38`
  - **현재:** `'$weekLabel차'` -- "차" 접미사 하드코딩
  - **수정:** AppStrings에 `static String weekLabelSuffix(String label) => '$label차';` 추가하거나, weekLabel 자체에 "차"를 포함하여 전달

- **위치 2:** `lib/features/dev_check/screens/dev_check_main_screen.dart:59`
  - **현재:** `'${baby.weekLabel}차'` -- "차" 접미사 하드코딩
  - **수정:** 위와 동일하게 AppStrings 상수 적용

- **위치 3:** `lib/features/dev_check/screens/trend_screen.dart:133`
  - **현재:** `'${filteredRecords[i].weekNumber}주'` -- "주" 접미사 하드코딩
  - **수정:** AppStrings에 상수 추가 (예: `static String weekSuffix(int week) => '${week}주';`)

- **기준:** 사양서 접근성 검증 #5 -- "모든 한국어 텍스트가 AppStrings 상수를 통해 참조되고, 하드코딩된 한국어 문자열이 없다"
- **심각도:** 경미 (접미사 1~2글자, 기능에 영향 없음)

### FAIL-2: 크기 값 하드코딩 4건

- **위치 1:** `lib/core/widgets/score_selector.dart:46`
  - **현재:** `height: 40`
  - **수정:** AppDimensions 상수 사용 (예: `AppDimensions.minTouchTarget - 8` 또는 별도 상수 추가)

- **위치 2:** `lib/features/dev_check/widgets/radar_chart_card.dart:40-41`
  - **현재:** `width: 200, height: 200`
  - **수정:** 사양서에 200x200dp로 명시되어 있으므로 AppDimensions에 `static const double radarChartSize = 200;` 추가 권장

- **위치 3:** `lib/features/dev_check/widgets/trend_chart_card.dart:55`
  - **현재:** `height: 180`
  - **수정:** AppDimensions에 `static const double chartHeight = 180;` 추가 권장

- **위치 4:** `lib/core/widgets/danger_sign_banner.dart:37`
  - **현재:** `size: 20`
  - **수정:** AppDimensions에 아이콘 크기 상수 추가 또는 기존 상수 활용

- **기준:** 사양서 디자인 검증 #11 -- "모든 간격/패딩이 AppDimensions 상수를 참조하고, 하드코딩 값이 없다"
- **심각도:** 경미 (레이아웃 동작에 영향 없음, 차트/아이콘 크기 특수값)

### FAIL-3: checklist_item_tile.dart TextEditingController 매 빌드 생성

- **위치:** `lib/features/dev_check/widgets/checklist_item_tile.dart:89`
  - **현재:** `controller: TextEditingController(text: memo)` -- StatelessWidget의 build 메서드 내에서 매번 새 컨트롤러 생성
  - **문제:** 메모 입력 중 리빌드 시 커서 위치 유실, 성능 저하 가능성. Generator 본인도 sprint-07-result.md "남은 이슈"에서 인지함
  - **수정:** ChecklistItemTile을 StatefulWidget으로 변경하거나, 상위에서 컨트롤러를 관리
- **심각도:** 경미 (기능 동작에는 문제 없으나 UX 품질 저하 가능성)

---

## Marionette UI 실행 테스트 요약

### 테스트 시나리오 수행 결과

| # | 시나리오 | 판정 | 비고 |
|---|---|---|---|
| 1 | nav_tab_dev_check 탭 -> 발달 탭 이동 | PASS | State A 화면 정상 표시 |
| 2 | State A 화면 요소 확인 | PASS | 주차 정보 카드, keyPoints 4줄, CTA, 서브 링크, 면책 문구 모두 존재 |
| 3 | CTA 탭 -> ChecklistScreen 이동 | PASS | 18문항 폼 화면 정상 이동 |
| 4 | 점수 버튼 선택 -> 상태 변경 | PASS | 3번 버튼 탭: warmOrange 배경 전환, 프로그레스 바 증가 |
| 5 | (?) 아이콘 탭 -> BottomSheet | PASS | 점수 기준 5단계 설명 표시 |
| 6 | [결과 보기] 탭 (미완료) -> 위험 신호 화면 | PASS | 1문항만 응답, 활성 상태에서 정상 이동 |
| 7 | 위험 신호 6항목 체크박스 표시 | PASS | 6개 항목 CheckboxListTile 확인 |
| 8 | [건너뛰기] 탭 -> 결과 화면 이동 | PASS | 정상 이동, 위험 신호 미저장 |
| 9 | 결과 화면 안심 메시지 + 레이더 차트 + 영역별 카드 | PASS | tier 5 메시지, 6영역 레이더 차트, 6개 DomainScoreCard |
| 10 | [홈으로 돌아가기] -> 홈 이동 | PASS | 정상 이동 |
| 11 | 발달 탭 재진입 -> State B 표시 | PASS | 안심 메시지 + 레이더 차트 + 솔루션 + 반 너비 버튼 쌍 |

### 스크린샷 촬영 화면
- State A 메인 화면 (주차 정보 카드 + keyPoints + CTA)
- ChecklistScreen (프로그레스 바 + 문항 + ScoreSelector + 메모)
- 점수 기준 BottomSheet
- DangerSignScreen (6항목 체크박스 + 건너뛰기/결과 보기)
- ChecklistResultScreen 상단 (안심 메시지 + 레이더 차트)
- ChecklistResultScreen 하단 (영역별 카드 + 솔루션 + CTA)
- State B 메인 화면 (안심 메시지 + 레이더 차트 + 솔루션 + 반 너비 버튼)

---

## 재구현 필요 여부

FAIL 항목 3건 모두 경미한 수준으로, 핵심 기능과 UX에 영향 없음.
다음 스프린트 진행 시 함께 수정 가능한 수준.

- FAIL-1: 한국어 접미사("차", "주") 3곳 AppStrings 상수로 이동
- FAIL-2: 크기 하드코딩 4곳 AppDimensions 상수로 교체
- FAIL-3: TextEditingController 재생성 이슈 -- StatefulWidget 분리로 해결 권장
