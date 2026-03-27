# Sprint 04 구현 결과

## 생성된 파일

### 기록 화면 (screens)
- `lib/features/record/screens/record_main_screen.dart` -- RecordMainScreen 메인 화면
- `lib/features/record/screens/growth_chart_screen.dart` -- GrowthChartScreen 성장 곡선
- `lib/features/record/screens/record_history_screen.dart` -- RecordHistoryScreen 기록 히스토리

### 기록 화면 위젯 (widgets)
- `lib/features/record/widgets/date_swipe_header.dart` -- 날짜 스와이프 헤더 (2-7-4)
- `lib/features/record/widgets/counter_card.dart` -- 수유/배변 카운터 카드 (2-3-3)
- `lib/features/record/widgets/sleep_input_card.dart` -- 수면 시간 입력 카드 (2-4-4)
- `lib/features/record/widgets/growth_expansion_tile.dart` -- 성장 기록 확장 타일 (2-4-6)
- `lib/features/record/widgets/memo_input_card.dart` -- 부모 메모 입력 카드 (2-4-5)
- `lib/features/record/widgets/record_summary_card.dart` -- 기록 요약 카드 - 히스토리용 (2-2-4)
- `lib/features/record/widgets/growth_chart_widget.dart` -- 성장 곡선 차트 위젯 (2-5-2, fl_chart)
- `lib/features/record/widgets/recent_growth_list.dart` -- 최근 성장 기록 리스트

### 공유 위젯
- `lib/core/widgets/inline_save_indicator.dart` -- 인라인 "저장됨" 피드백 (2-6-3)
- `lib/core/widgets/half_button_pair.dart` -- 반으로 나눈 버튼 쌍 (2-3-8)
- `lib/core/widgets/reassurance_card.dart` -- 안심 메시지 카드 (2-2-7)

### Provider
- `lib/providers/selected_date_provider.dart` -- 선택된 날짜 + 히스토리 Provider

### 시드 데이터
- `lib/data/seed/who_growth_data.dart` -- WHO 성장 참조 데이터 (0~12주 남아, 체중/키/머리둘레)

## 수정된 파일

- `lib/features/main_shell/main_shell.dart` -- 기록 탭 플레이스홀더를 RecordMainScreen으로 교체
- `lib/core/router/app_router.dart` -- `/record/growth-chart`, `/record/history` 하위 라우트 추가
- `lib/providers/record_providers.dart` -- decrementFeeding, decrementDiaper, updateSleep, updateMemo 추가 + DateRecordActions 유틸리티 클래스 + dateRecordProvider (family)
- `lib/providers/growth_providers.dart` -- allGrowthRecordsProvider, todayGrowthRecordProvider 추가
- `lib/data/database/daos/daily_record_dao.dart` -- getRecordsByDateRange, getAllByBabyId 메서드 추가
- `lib/data/database/daos/growth_record_dao.dart` -- insert, update, getAllByBabyId, getByDate 메서드 추가
- `lib/core/constants/app_strings.dart` -- 기록 화면 전용 문자열 추가 (기록 탭, 성장 곡선, 기록 히스토리)
- `lib/core/theme/app_theme.dart` -- displayMedium (Data 32sp) 추가 (라이트/다크 모두)

## 구현 메모

### 기술적 결정
- **Riverpod 3.x 호환**: `StateProvider`가 삭제된 Riverpod 3.3.1에서 `NotifierProvider`를 사용하여 `selectedDateProvider` 구현. `FamilyAsyncNotifier`도 3.x에서 지원하지 않으므로 `FutureProvider.family` + `DateRecordActions` 헬퍼 클래스 패턴으로 대체.
- **날짜별 기록 관리**: `dateRecordProvider(DateTime)` family provider로 날짜별 DailyRecord를 자동 생성/조회. `DateRecordActions` 클래스가 DB 변경 + provider invalidation을 처리.
- **홈-기록 탭 동기화**: DateRecordActions에서 오늘 날짜 기록 변경 시 `todayRecordProvider`를 함께 invalidate하여 홈 화면과 기록 탭의 수유/배변 카운트가 동기화됨.
- **성장 곡선**: fl_chart의 `LineChart`로 구현. WHO 15th~85th 퍼센타일 밴드를 belowBarData overlay 기법으로 표현. "낮은 편/보통/높은 편" 질적 레이블을 우측 축에 표시.
- **displayMedium 추가**: TextTheme에 Data(32sp, Bold) 스타일이 없었으므로 `displayMedium`으로 매핑하여 라이트/다크 테마 모두에 추가.

### 금지 규칙 준수
- AppTextStyles 직접 사용: 없음 -- 모든 텍스트는 `Theme.of(context).textTheme.xxx`
- fontSize 하드코딩: 없음
- 한국어 하드코딩: 없음 -- 모든 텍스트는 `AppStrings`
- BorderRadius.circular(숫자): 없음 -- 모든 모서리는 `AppRadius.xxx`
- Color 하드코딩: 없음 -- Theme 또는 AppColors 상수만 사용

### Evaluator FAIL-1 수정 (2026-03-27)
- **문제**: 입력 필드 배경색이 `AppColors.white`로 하드코딩되어 다크 모드에서 흰색 배경 유지
- **수정 파일 3건**:
  - `lib/features/record/widgets/sleep_input_card.dart:141` -- `AppColors.white` -> `theme.colorScheme.surface`
  - `lib/features/record/widgets/growth_expansion_tile.dart:313` -- `AppColors.white` -> `theme.colorScheme.surface`
  - `lib/features/record/widgets/memo_input_card.dart:111` -- `AppColors.white` -> `theme.colorScheme.surface`
- **검증**: `flutter analyze` error 0, warning 0 (info 5 기존과 동일)

## 사양서 기준 자체 점검

### 4-1. 빌드 및 실행 검증
- [x] `flutter analyze`에서 error 0개 (info 5개만 존재, warning 0개)
- [x] `flutter build apk --debug` 성공

### 4-2. MainShell 수정 검증
- [x] 하단 "기록" 탭(index 1) 탭 시 RecordMainScreen 표시
- [x] ValueKey: `nav_tab_record` 존재

### 4-3. RecordMainScreen 전체 레이아웃 검증
- [x] Scaffold 배경색: Theme.of(context).scaffoldBackgroundColor
- [x] AppBar "기록" 타이틀 (변형 A), 엘리베이션 0
- [x] SingleChildScrollView 세로 스크롤
- [x] 카드 배치 순서: 날짜 -> 수유 -> 배변 -> 수면 -> 성장(접힘) -> 메모 -> 버튼 -> 안내
- [x] 화면 좌우 패딩 16dp (AppDimensions.screenPaddingH)
- [x] 카드 사이 간격 12dp (AppDimensions.cardGap)
- [x] ValueKey: `record_main_screen`, `record_scroll_view`

### 4-4. 날짜 스와이프 헤더 검증
- [x] "yyyy년 M월 d일 (오늘)" 형식 날짜 텍스트 (headlineSmall)
- [x] 오늘이면 "(오늘)" 접미사
- [x] 좌측 chevron_left 버튼 전날 이동
- [x] 우측 chevron_right 오늘이면 비활성 (opacity 0.3, onPressed null)
- [x] 스와이프 제스처 지원
- [x] 화살표 터치 48x48dp
- [x] DateFormat('yyyy년 M월 d일', 'ko_KR') 사용
- [x] ValueKey: `date_swipe_header`, `date_prev_btn`, `date_next_btn`, `date_label`

### 4-5. 수유 카운터 카드 검증
- [x] 이모지 + "수유" 레이블 (headlineSmall)
- [x] 카운트 "N회" 표시 (displayMedium)
- [x] +/- 버튼 48x48dp
- [x] 버튼 배경 paleCream, 모서리 8dp
- [x] + 탭 시 카운트 증가, scale-up 애니메이션 (1.2배 150ms), 토스트 1초
- [x] - 탭 시 카운트 감소, 동일 피드백
- [x] 0일 때 - 비활성 (mutedBeige, onTap null)
- [x] 30 이상 시 경고 토스트
- [x] HapticFeedback.lightImpact()
- [x] 카드 배경 Theme cardColor, 모서리 12dp, 패딩 16dp
- [x] 버튼 눌림 시 warmOrange 배경
- [x] ValueKey: `feeding_counter_card`, `feeding_count`, `feeding_plus_btn`, `feeding_minus_btn`

### 4-6. 배변 카운터 카드 검증
- [x] 수유 카운터와 동일 사양 (CounterCard 재사용)
- [x] ValueKey: `diaper_counter_card`, `diaper_count`, `diaper_plus_btn`, `diaper_minus_btn`

### 4-7. 수면 시간 입력 카드 검증
- [x] 이모지 + "수면" 레이블 (headlineSmall)
- [x] 수면 시간 "N시간 M분" (bodyLarge), 미입력 시 "탭해서 입력" (mutedBeige)
- [x] 입력 필드 배경 white, 모서리 12dp, 테두리 lightBeige, 높이 48dp
- [x] 탭 시 CupertinoTimerPicker (hm 모드)
- [x] 저장 후 인라인 "저장됨" (labelSmall, softGreen), 2초 후 페이드아웃
- [x] ValueKey: `sleep_input_card`, `sleep_value`, `sleep_save_indicator`

### 4-8. 성장 기록 확장 타일 검증
- [x] 접힘 기본: "성장 기록 추가하기 +" (headlineSmall), paleCream 배경, 모서리 12dp
- [x] 오늘 데이터 존재 시 컴팩트 카드 표시
- [x] 펼침/접힘 애니메이션 200ms ease-in-out
- [x] 체중(kg), 키(cm), 머리둘레(cm) 3개 입력 필드 (숫자 키보드)
- [x] 각 필드 저장 후 인라인 "저장됨"
- [x] 성장 데이터 입력 시 안심 메시지 "건강하게 자라고 있어요"
- [x] ValueKey: `growth_expansion_tile`, `growth_weight_field`, `growth_height_field`, `growth_head_field`, `growth_reassurance_msg`

### 4-9. 부모 메모 입력 카드 검증
- [x] 이모지 + "오늘의 메모 (선택)" (headlineSmall)
- [x] 다중 줄 TextField, 플레이스홀더 (mutedBeige)
- [x] 필드 배경 white, 테두리 lightBeige, 포커스 시 warmOrange 2px, 모서리 12dp
- [x] debounce 1초 후 자동 저장
- [x] 인라인 "저장됨" 표시, 2초 후 페이드아웃
- [x] ValueKey: `memo_input_card`, `memo_text_field`, `memo_save_indicator`

### 4-10. 하단 버튼 쌍 검증
- [x] 2개 버튼 수평 배치 (Row + Expanded), 간격 8dp
- [x] OutlinedButton 스타일, 테두리 warmOrange, 텍스트 warmOrange
- [x] 각 버튼 높이 48dp, 모서리 12dp
- [x] 좌측 버튼 -> /record/growth-chart
- [x] 우측 버튼 -> /record/history
- [x] 하단 "모든 입력은 자동 저장됩니다" (bodySmall, warmGray, 중앙)
- [x] ValueKey: `growth_chart_btn`, `record_history_btn`, `auto_save_notice`

### 4-11. 자동 저장 피드백 검증
- [x] 카운터 +/- 시 "저장됨" 토스트 (showSavedToast 재사용)
- [x] 수면/성장/메모 시 인라인 "저장됨" (InlineSaveIndicator)
- [x] 별도 "저장" 버튼 없음

### 4-12. GrowthChartScreen 검증
- [x] AppBar 변형 B (뒤로가기 + "성장 곡선")
- [x] 안심 메시지 카드 (mintTint 배경, softGreen 아이콘)
- [x] TabBar: 체중/키/머리둘레 3개 탭 (warmOrange 선택, warmGray 비선택)
- [x] 그래프: WHO 밴드(growthBand), 아기 데이터(warmOrange), 범례
- [x] 최근 기록 리스트 (늘었어요/비슷해요)
- [x] 빈 상태 처리
- [x] ValueKey: `growth_chart_screen`, `growth_chart_tab_weight`, `growth_chart_tab_height`, `growth_chart_tab_head`, `growth_chart_graph`, `growth_reassurance_card`, `recent_growth_list`

### 4-13. RecordHistoryScreen 검증
- [x] AppBar 변형 B (뒤로가기 + "기록 히스토리")
- [x] 타임라인 날짜별 기록 카드 (ListView.separated)
- [x] 각 카드: 날짜 헤더 + 수유/배변/수면/메모 (조건부 표시)
- [x] 기록 없는 날 건너뜀
- [x] 무한 스크롤 (페이징 20건)
- [x] 빈 상태 EmptyStateCard
- [x] ValueKey: `record_history_screen`, `record_history_list`, `record_history_empty`, `record_card_{date}`

### 4-14. GoRouter 라우트 검증
- [x] `/record/growth-chart` 경로 등록
- [x] `/record/history` 경로 등록
- [x] 탭 바 위에 push (별도 GoRoute)

### 4-15. 데이터 흐름 검증
- [x] 수유/배변 +/-1 시 DB 반영 (DateRecordActions -> DailyRecordDao.update)
- [x] 수면 입력 시 DB 반영
- [x] 메모 입력 시 DB 반영
- [x] 성장 데이터 입력 시 GrowthRecord DB 삽입/업데이트
- [x] 홈-기록 탭 동기화 (todayRecordProvider invalidation)
- [x] 날짜 스와이프 시 해당 날짜 DailyRecord 표시
- [x] 성장 곡선에서 전체 GrowthRecord 이력 표시
- [x] 기록 히스토리에서 최신순 표시

### 4-16. UX 원칙 검증
- [x] "하나만 해도 충분하다" -- 성장 기록 접힘, 전부 채우라는 메시지 없음
- [x] "숫자보다 말로 안심" -- 퍼센타일 숫자 없음, 안심 메시지 우선
- [x] "전문 용어 없음" -- "표준 범위", "낮은 편/보통/높은 편" 사용
- [x] "한 손 30초 완료" -- 원탭 카운터, 모든 터치 48dp
- [x] "죄책감 유발 없음" -- 미완료 표시 없음, 히스토리 빈 날 건너뜀, 긍정적 빈 상태

### 4-17. 디자인 검증
- [x] Scaffold 배경: Theme scaffoldBackgroundColor
- [x] 카드 배경: Theme cardColor
- [x] 텍스트: Theme.of(context).textTheme.xxx
- [x] 색상: Theme.colorScheme 또는 AppColors 상수
- [x] 인라인 "저장됨": labelSmall, softGreen (theme.colorScheme.secondary)
- [x] 각 카드 모서리 12dp (AppRadius.md)
- [x] 다크 모드 입력 필드 배경: theme.colorScheme.surface (FAIL-1 수정 완료)

### 4-18. 접근성 검증
- [x] 모든 탭 가능 영역 48x48dp (AppDimensions.minTouchTarget)
- [x] HapticFeedback.lightImpact() 카운터 +/-
- [x] 빈 상태 EmptyStateCard 표시
- [x] 성장 곡선 빈 상태 처리
- [x] 아기 미등록 시 null 안전 처리 (provider가 null 반환)

### 4-19. ValueKey 전체 목록
- [x] 사양서의 모든 30개 ValueKey가 구현됨
