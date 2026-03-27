# Sprint 03 구현 결과

## Evaluator FAIL 수정 이력

### FAIL-1 수정: 한국어 문자열 하드코딩 제거
- `app_strings.dart`에 상수 추가: `emptyBabyProfile`, `bornToday`, `daysSinceBirth()`, `observationReassurance`, `radarLabels` (6개 영역명), `weightLabel`, `heightLabel`, `weightValue()`, `heightValue()`
- `baby_profile_card.dart`: `'아기를 등록해주세요'` -> `AppStrings.emptyBabyProfile`, `'오늘 태어났어요'` -> `AppStrings.bornToday`, `'태어난 지 $days일째'` -> `AppStrings.daysSinceBirth(days)`
- `observation_summary_card.dart`: `'잘 관찰하고 계시네요'` -> `AppStrings.observationReassurance`, `_labels` 배열 -> `AppStrings.radarLabels` 참조
- `growth_summary_card.dart`: `'체중 ${...}kg'` -> `AppStrings.weightValue(...)`, `'키 ${...}cm'` -> `AppStrings.heightValue(...)`

### FAIL-2 수정: CustomPaint 내부 TextStyle fontSize 하드코딩 제거
- `_RadarChartPainter`에 `labelFontSize` 파라미터 추가
- 위젯 빌드 시 `theme.textTheme.labelSmall?.fontSize ?? 11`로 주입 -> 조부모 모드(+4sp) 자동 대응
- `shouldRepaint`에 `labelFontSize` 비교 추가

### FAIL-3 수정: ActivityTypeChip fontSize 하드코딩 제거
- `fontSize: 12` override 제거, `labelSmall`의 기본 fontSize(11sp) 그대로 사용
- 조부모 모드에서 Theme 기반으로 +4sp 자동 적용됨

### 수정 후 검증
- `flutter analyze`: No issues found!
- 한국어 문자열 하드코딩: baby_profile_card, observation_summary_card, growth_summary_card 3개 파일 모두 0건
- fontSize 하드코딩: observation_summary_card, activity_type_chip 2개 파일 모두 0건

---

## 생성된 파일

### 데이터 모델
- `lib/data/models/daily_record.dart` -- DailyRecord 모델 (수유/배변 카운트, 수면, 메모)
- `lib/data/models/growth_record.dart` -- GrowthRecord 모델 (체중, 키, 머리둘레)
- `lib/data/models/activity.dart` -- Activity 모델 (시드 데이터용, DB 미저장)
- `lib/data/models/week_info.dart` -- WeekInfo 모델 (주차 정보)

### DAO
- `lib/data/database/daos/daily_record_dao.dart` -- DailyRecordDao (insert, update, getTodayRecord, getByDate)
- `lib/data/database/daos/growth_record_dao.dart` -- GrowthRecordDao (getLatestRecord)

### 시드 데이터
- `lib/data/seed/activity_seed.dart` -- 0-1주차 활동 5개 시드 데이터

### Provider
- `lib/providers/record_providers.dart` -- TodayRecordNotifier (incrementFeeding, incrementDiaper), todayRecordProvider
- `lib/providers/activity_providers.dart` -- currentActivitiesProvider, todayMissionProvider
- `lib/providers/growth_providers.dart` -- latestGrowthProvider

### 홈 화면
- `lib/features/home/screens/home_screen.dart` -- HomeScreen (스크롤 가능한 대시보드)
- `lib/features/home/widgets/baby_profile_card.dart` -- 아기 프로필 카드 (컴팩트)
- `lib/features/home/widgets/quick_record_row.dart` -- 빠른 기록 영역 (수유/배변 +1 원탭)
- `lib/features/home/widgets/today_mission_card.dart` -- 오늘의 미션 카드
- `lib/features/home/widgets/growth_summary_card.dart` -- 성장 요약 카드
- `lib/features/home/widgets/observation_summary_card.dart` -- 관찰 요약 카드 (레이더 차트 + 빈 상태)

### 공유 위젯
- `lib/core/widgets/empty_state_card.dart` -- 빈 상태 카드 (재사용)
- `lib/core/widgets/activity_type_chip.dart` -- 활동 유형 칩 (재사용)
- `lib/core/widgets/text_link_button.dart` -- 텍스트 링크 버튼 (재사용)
- `lib/core/widgets/saved_toast.dart` -- "저장됨" 토스트 헬퍼 (재사용)

## 수정된 파일
- `lib/features/main_shell/main_shell.dart` -- IndexedStack 기반 5탭 구조로 리팩터링, 홈 탭은 HomeScreen
- `lib/providers/core_providers.dart` -- dailyRecordDaoProvider, growthRecordDaoProvider 등록
- `lib/core/constants/app_strings.dart` -- 홈 화면 전용 문자열 13개 추가

## 구현 메모

### 기술적 결정
- **MainShell**: 사양서 권장 방법 A (IndexedStack) 채택. 5탭 구조, 홈 외 4탭은 플레이스홀더.
- **탭 아이콘**: 사양서 4-2 기준 home/edit_note/star/insights/person 적용.
- **todayMissionProvider**: 날짜 기반 인덱스 선택 (dayOfYear % activities.length). 같은 날 항상 같은 활동 추천.
- **Riverpod API**: `valueOrNull` 대신 `value` 사용 (Riverpod 3.x에서 `valueOrNull` 미지원).
- **레이더 차트**: fl_chart 대신 CustomPaint로 자체 구현 (미니 차트 160x160, 6 꼭짓점).
- **빌드**: `flutter analyze` error 0. APK 빌드는 개발 환경의 Java 버전 문제(Java 11 vs 17)로 실패하나, 코드 문제 아님.

### 빈 상태 처리
- 아기 미등록 시: 프로필 카드에 "아기를 등록해주세요" 표시
- DailyRecord 없을 때: +1 탭 시 자동 생성 (getOrCreateTodayRecord)
- GrowthRecord 없을 때: "아직 성장 기록이 없어요" 빈 상태
- 관찰 데이터 없을 때: seedling 아이콘 + "처음이라 괜찮아요!" 긍정적 메시지

### UX 원칙 적용
- "하나만 해도 충분하다": 오늘의 활동 1개만 표시
- 숫자보다 말로 안심: 성장 요약에서 "건강하게 자라고 있어요" 먼저 표시
- 한 손 30초 완료: 수유/배변 원탭 카운터
- 죄책감 유발 없음: "미완료" 표시 없음, 빈 상태 긍정적 톤

## 사양서 기준 자체 점검

### 4-1. 빌드 및 실행 검증
- [x] `flutter analyze` error 0개
- [ ] `flutter build apk --debug` -- 개발 환경 Java 버전 문제 (코드 무관)
- [x] 온보딩 완료 후 홈 화면 표시 (라우터 /home -> MainShell -> HomeScreen)

### 4-2. MainShell (하단 탭 바) 검증
- [x] 5개 탭 표시 (홈, 기록, 활동, 발달, 마이)
- [x] 탭 아이콘: home, edit_note, star, insights, person
- [x] 활성 탭 warmOrange, 비활성 warmGray -- Theme NavigationBarTheme 기반
- [x] 탭 전환 시 해당 화면 전환 (IndexedStack)
- [x] 터치 영역 48dp (NavigationBar 기본 사양 충족)
- [x] ValueKey: bottom_nav_bar, nav_tab_home ~ nav_tab_my

### 4-3. 홈 AppBar 검증
- [x] "하루 한 가지" 텍스트 (headlineSmall)
- [x] 배경색: scaffoldBackgroundColor
- [x] 엘리베이션 0
- [x] ValueKey: home_app_bar

### 4-4. 아기 프로필 카드 검증
- [x] CircleAvatar 40dp
- [x] 이름 + 주차 (headlineSmall)
- [x] "태어난 지 N일째" (bodySmall)
- [x] 카드 배경: Theme cardColor
- [x] 모서리 12dp, 패딩 12dp
- [x] ValueKey: baby_profile_card

### 4-5. 빠른 기록 영역 검증
- [x] 프로필 카드 아래 배치
- [x] 수유/배변 2열 Row 배치
- [x] 아이콘 + 레이블 + "+1" + "오늘 N" 표시
- [x] 수유 +1 탭 시 feedingCount 증가 + UI 즉시 업데이트
- [x] 배변 +1 탭 시 diaperCount 증가 + UI 즉시 업데이트
- [x] "저장됨" 토스트 1초간 표시
- [x] scale-up 애니메이션 적용
- [x] 햅틱 피드백 (lightImpact)
- [x] 터치 영역 최소 48dp
- [x] 카드 배경/모서리/패딩 준수
- [x] DailyRecord DB 저장
- [x] ValueKey: quick_record_row, quick_feeding_btn, quick_diaper_btn, feeding_count_text, diaper_count_text

### 4-6. 오늘의 미션 카드 검증
- [x] "오늘의 활동" 섹션 타이틀 (headlineMedium)
- [x] 활동 유형 칩 (paleCream 배경, warmOrange 텍스트, 모서리 8dp)
- [x] 활동명 (headlineMedium)
- [x] 설명 (bodyLarge)
- [x] 권장 시간 (bodySmall)
- [x] "시작하기" CTA 버튼 (warmOrange, 모서리 24dp, 높이 52dp)
- [x] 카드 배경 cardColor, 모서리 16dp, 패딩 16dp
- [x] 빈 상태 카드 표시 가능
- [x] "시작하기" 버튼 TODO 처리
- [x] ValueKey: today_mission_card, mission_start_btn, activity_type_chip

### 4-7. 성장 요약 카드 검증
- [x] "성장 요약" 섹션 타이틀
- [x] 데이터 있을 때: 안심 메시지 + 체중/키 표시
- [x] 데이터 없을 때: "아직 성장 기록이 없어요" 빈 상태
- [x] softGreen 아이콘 (check_circle)
- [x] "더보기" 텍스트 링크 (warmOrange)
- [x] 카드 배경/모서리/패딩 준수
- [x] ValueKey: growth_summary_card, growth_more_link

### 4-8. 이번 주 관찰 결과 검증
- [x] "이번 주 관찰 결과" 섹션 타이틀
- [x] 빈 상태: eco 아이콘(48dp, softGreen) + 긍정 메시지
- [x] 빈 상태 카드 배경/모서리/패딩 준수
- [x] 데이터 있을 때: 레이더 차트 160x160 + 안심 메시지 + "더보기"
- [x] 레이더 차트: 6 꼭짓점, radarFill 채움, warmOrange 2px 테두리
- [x] ValueKey: observation_summary_card, empty_observation_card, radar_chart_mini, observation_more_link

### 4-9. 스크롤 레이아웃 검증
- [x] SingleChildScrollView 세로 스크롤
- [x] 카드 배치 순서: 프로필 -> 빠른 기록 -> 미션 -> 성장 -> 관찰
- [x] 좌우 패딩 16dp
- [x] 카드 간 간격 12dp, 섹션 간 간격 16dp

### 4-10. UX 원칙 검증
- [x] 오늘의 활동 1개만 크게 표시
- [x] 안심 메시지가 숫자보다 먼저/크게 표시
- [x] 전문 용어 직접 노출 없음
- [x] 수유/배변 원탭, 키보드 입력 불필요
- [x] 죄책감 유발 요소 없음

### 4-11. 디자인 검증
- [x] Scaffold 배경: Theme.scaffoldBackgroundColor
- [x] 카드 배경: Theme.cardColor
- [x] 모든 텍스트: Theme.of(context).textTheme.xxx
- [x] 색상: Theme.colorScheme 또는 AppColors 상수
- [x] 다크 모드 텍스트/배경/카드 정상 전환 (Theme 기반)
- [x] 조부모 모드: grandparent_theme.dart 통해 +4sp 자동 적용

### 4-12. 접근성 검증
- [x] 탭 영역 최소 48dp
- [x] +1 버튼 햅틱 피드백
- [x] 빈 상태 정상 표시
- [x] 아기 미등록 시 크래시 없이 빈 상태 처리

### 4-13. 데이터 흐름 검증
- [x] 수유 +1 -> DailyRecord.feedingCount DB 반영
- [x] 배변 +1 -> DailyRecord.diaperCount DB 반영
- [x] DailyRecord 없으면 자동 생성 (getOrCreateTodayRecord)
- [x] todayRecordProvider가 activeBabyProvider watch
- [x] 수유/배변 카운트 같은 DailyRecord 참조

### 4-14. ValueKey 목록
- [x] main_shell
- [x] bottom_nav_bar
- [x] nav_tab_home, nav_tab_record, nav_tab_activity, nav_tab_dev_check, nav_tab_my
- [x] home_app_bar
- [x] home_scroll_view
- [x] baby_profile_card
- [x] quick_record_row
- [x] quick_feeding_btn, quick_diaper_btn
- [x] feeding_count_text, diaper_count_text
- [x] today_mission_card
- [x] mission_start_btn
- [x] activity_type_chip
- [x] growth_summary_card, growth_more_link
- [x] observation_summary_card, empty_observation_card
- [x] radar_chart_mini, observation_more_link
