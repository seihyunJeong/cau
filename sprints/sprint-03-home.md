# Sprint 03: 홈 화면 (대시보드)

## 1. 구현 범위

### 대상 화면/기능

- **MainShell 리팩터링** -- 기존 플레이스홀더를 GoRouter `StatefulShellRoute` 기반 5탭 구조로 전환 (개발기획서 섹션 5-2)
- **HomeScreen** (탭 1: 홈 -- "오늘 우리 아이는?") (개발기획서 섹션 5-3)
  - 아기 프로필 카드 (컴팩트)
  - 빠른 기록 영역 (수유 +1, 배변 +1 원탭 카운터)
  - 오늘의 미션 카드 (활동 1개 추천)
  - 성장 요약 카드 (최근 체중/키 + 안심 메시지)
  - 이번 주 관찰 결과 (레이더 차트 미니 또는 빈 상태 카드)
- **DailyRecord 모델 + DailyRecordDao** (개발기획서 섹션 4-2-2, 4-3)
- **GrowthRecord 모델 + GrowthRecordDao** (개발기획서 섹션 4-2-2) -- 홈 성장 요약에 필요
- **Activity 모델 + Activity 시드 데이터** (개발기획서 섹션 8-2) -- 오늘의 미션 카드에 필요
- **WeekInfo 모델** (개발기획서 섹션 9-2 currentWeekProvider 참조)
- **홈 화면용 Provider들** (개발기획서 섹션 9-2)
- 빈 상태(empty state) 처리
- 자동 저장 피드백 (+1 탭 시 "저장됨" 토스트)

### 참조 기획서 섹션

| 문서 | 섹션 |
|---|---|
| 서비스기획서 | 3-1 메인 화면 (대시보드) |
| 서비스기획서 | 6-1~6-3 UX 원칙 5가지 |
| 개발기획서 | 1-2 UX 제약 |
| 개발기획서 | 4-2-2 DailyRecord, GrowthRecord 모델 |
| 개발기획서 | 4-3 DailyRecordDao |
| 개발기획서 | 5-2 메인 쉘 (MainShell) |
| 개발기획서 | 5-3 탭 1: 홈 (HomeScreen) |
| 개발기획서 | 8-2 Activity 데이터 모델 |
| 개발기획서 | 9-2 주요 Provider 정의 |

### 사용 디자인 컴포넌트

| 번호 | 컴포넌트 | 사용 위치 |
|---|---|---|
| 2-1-1 | 하단 탭 바 | MainShell 하단 네비게이션 |
| 2-1-2 (변형 A) | 앱 바 (홈 앱 바) | HomeScreen 상단 |
| 2-2-1 | 아기 프로필 카드 (컴팩트) | 홈 최상단 |
| 2-3-4 | 빠른 기록 버튼 x2 | 홈 2번째 영역 |
| 2-2-2 | 오늘의 미션 카드 | 홈 3번째 영역 |
| 2-3-9 | 활동 유형 칩 | 미션 카드 내부 |
| 2-3-1 | 기본 CTA 버튼 | 미션 카드 "시작하기" |
| 2-2-5 | 성장 요약 카드 | 홈 4번째 영역 |
| 2-3-6 | 텍스트 링크 버튼 | 성장 요약/관찰 요약 "더보기" |
| 2-2-6 | 레이더 차트 카드 | 홈 5번째 영역 (데이터 있을 때) |
| 2-5-1 | 레이더 차트 | 레이더 차트 카드 내부 |
| 2-2-8 | 빈 상태 카드 | 관찰/성장 데이터 없을 때 |
| 2-6-2 | 토스트/스낵바 | +1 탭 시 "저장됨" 피드백 |

---

## 2. 파일 목록

### 새로 생성할 파일

```
# ── 데이터 모델 ──
lib/data/models/daily_record.dart              # DailyRecord 모델
lib/data/models/growth_record.dart             # GrowthRecord 모델
lib/data/models/activity.dart                  # Activity, ActivityStep, Equipment 모델
lib/data/models/week_info.dart                 # WeekInfo 모델

# ── DAO ──
lib/data/database/daos/daily_record_dao.dart   # DailyRecordDao
lib/data/database/daos/growth_record_dao.dart  # GrowthRecordDao (getLatest 메서드만 구현)

# ── 시드 데이터 ──
lib/data/seed/activity_seed.dart               # 0-1주 활동 5개 시드 데이터

# ── Provider ──
lib/providers/record_providers.dart            # dailyRecordDaoProvider, todayRecordProvider 등
lib/providers/activity_providers.dart          # activityRecordDaoProvider, currentActivitiesProvider, todayMissionProvider
lib/providers/growth_providers.dart            # growthRecordDaoProvider, latestGrowthProvider

# ── 홈 화면 ──
lib/features/home/screens/home_screen.dart     # HomeScreen 화면
lib/features/home/widgets/baby_profile_card.dart    # 아기 프로필 카드
lib/features/home/widgets/quick_record_row.dart     # 빠른 기록 영역 (수유/배변 +1)
lib/features/home/widgets/today_mission_card.dart   # 오늘의 미션 카드
lib/features/home/widgets/growth_summary_card.dart  # 성장 요약 카드
lib/features/home/widgets/observation_summary_card.dart  # 관찰 요약 카드 (레이더 또는 빈 상태)

# ── 공유 위젯 ──
lib/core/widgets/empty_state_card.dart         # 빈 상태 카드 (재사용)
lib/core/widgets/activity_type_chip.dart       # 활동 유형 칩 (재사용)
lib/core/widgets/text_link_button.dart         # 텍스트 링크 버튼 (재사용)
lib/core/widgets/saved_toast.dart              # "저장됨" 토스트 헬퍼 (재사용)
```

### 수정할 기존 파일

```
lib/features/main_shell/main_shell.dart        # 플레이스홀더 -> GoRouter StatefulShellRoute 기반 5탭 쉘로 리팩터링
lib/core/router/app_router.dart                # ShellRoute 추가, /home을 StatefulShellBranch로 변환
lib/providers/core_providers.dart              # dailyRecordDaoProvider, growthRecordDaoProvider 등록
lib/core/constants/app_strings.dart            # 홈 화면 전용 문자열 추가
lib/data/database/database_helper.dart         # daily_records, growth_records 테이블 CREATE 확인/추가
```

---

## 3. 데이터 모델

### 3-1. DailyRecord (daily_records 테이블)

개발기획서 섹션 4-2-2 그대로 구현한다.

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

**DailyRecordDao 필수 메서드:**
- `insert(DailyRecord)` -- 새 레코드 삽입
- `update(DailyRecord)` -- 기존 레코드 업데이트
- `getTodayRecord(int babyId)` -- 오늘 날짜의 레코드 조회

### 3-2. GrowthRecord (growth_records 테이블)

개발기획서 섹션 4-2-2 그대로 구현한다.

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

**GrowthRecordDao 필수 메서드 (이 스프린트에서 필요한 것만):**
- `getLatestRecord(int babyId)` -- 가장 최근 성장 기록 1건 조회

### 3-3. Activity 모델 (시드 데이터 -- DB 저장 아님)

개발기획서 섹션 8-2 그대로 구현한다. 이 스프린트에서는 홈 화면의 todayMission 표시에 필요한 최소 필드만 사용한다.

```dart
class Activity {
  final String id;               // "w0_act1"
  final int weekIndex;
  final int order;
  final String name;             // "품-숨-멈춤 루틴"
  final String type;             // "안기", "감각" 등
  final String description;
  final int recommendedSeconds;
  // ... 나머지 필드는 활동 상세 스프린트에서 사용
}
```

### 3-4. WeekInfo 모델

```dart
class WeekInfo {
  final int weekIndex;       // 0, 1, 2, ...
  final String weekLabel;    // "0-1주", "2-3주", ...
  final int daysSinceBirth;  // 태어난 지 N일

  factory WeekInfo.empty() => WeekInfo(weekIndex: 0, weekLabel: '0-1주', daysSinceBirth: 0);
}
```

### 3-5. Provider 구조

| Provider | 타입 | 소스 | 용도 |
|---|---|---|---|
| `dailyRecordDaoProvider` | `Provider<DailyRecordDao>` | core_providers | DAO 인스턴스 |
| `growthRecordDaoProvider` | `Provider<GrowthRecordDao>` | core_providers | DAO 인스턴스 |
| `currentWeekProvider` | `Provider<WeekInfo>` | baby_providers | 현재 주차 계산 |
| `todayRecordProvider` | `StateNotifierProvider` 또는 `AsyncNotifierProvider` | record_providers | 오늘의 DailyRecord (incrementFeeding, incrementDiaper 메서드 포함) |
| `currentActivitiesProvider` | `Provider<List<Activity>>` | activity_providers | 현재 주차 활동 목록 |
| `todayMissionProvider` | `FutureProvider<Activity?>` | activity_providers | 오늘 추천 활동 1개 |
| `latestGrowthProvider` | `FutureProvider<GrowthRecord?>` | growth_providers | 최근 성장 기록 |

**todayRecordProvider 핵심 동작:**
- `build()`: activeBabyProvider를 watch하여 오늘 DailyRecord 조회
- `incrementFeeding()`: feedingCount + 1 후 DB update, invalidateSelf()
- `incrementDiaper()`: diaperCount + 1 후 DB update, invalidateSelf()
- `_getOrCreateTodayRecord()`: 오늘 레코드가 없으면 새로 insert하고 반환

---

## 4. 검증 기준 (Evaluator용)

각 기준은 PASS/FAIL로 판정한다.

### 4-1. 빌드 및 실행 검증

- [ ] `flutter analyze`에서 error 0개 (warning은 허용)
- [ ] `flutter build apk --debug` 성공
- [ ] 앱 실행 시 온보딩 완료 후 홈 화면이 정상 표시됨

### 4-2. MainShell (하단 탭 바) 검증

- [ ] 하단에 5개 탭(홈, 기록, 활동, 발달, 마이)이 표시됨
- [ ] 각 탭 아이콘은 디자인컴포넌트 2-1-1 기준: 홈(home), 기록(edit_note), 활동(star), 발달(insights), 마이(person)
- [ ] 활성 탭 색상은 warmOrange(`#F5A623`), 비활성 탭은 warmGray(`#8C7B6B`) -- Theme 기반
- [ ] 탭 전환 시 해당 탭 화면으로 전환됨 (홈 탭은 HomeScreen, 나머지는 플레이스홀더)
- [ ] 각 탭 터치 영역이 최소 48x48dp
- [ ] ValueKey: `bottom_nav_bar` (NavigationBar), `nav_tab_home`, `nav_tab_record`, `nav_tab_activity`, `nav_tab_dev_check`, `nav_tab_my`

### 4-3. 홈 AppBar 검증

- [ ] 좌측에 "하루 한 가지" 텍스트 표시 (headlineSmall / H3 스타일 -- Theme 기반)
- [ ] 배경색: scaffold 배경과 동일 (cream 또는 darkBg -- Theme 기반)
- [ ] 엘리베이션 0 (그림자 없음)
- [ ] ValueKey: `home_app_bar`

### 4-4. 아기 프로필 카드 검증

- [ ] 좌측에 CircleAvatar 40dp (프로필 이미지 있으면 이미지, 없으면 기본 아기 아이콘)
- [ ] 우측에 이름 표시 (headlineSmall / H3) -- 예: "하루 (0-1주차)"
- [ ] 아래에 "태어난 지 N일째" 텍스트 (bodySmall / Caption)
- [ ] 카드 배경: Theme cardColor (white 또는 darkCard)
- [ ] 카드 모서리 둥글기: 12dp
- [ ] 카드 패딩: 12dp (compact)
- [ ] ValueKey: `baby_profile_card`

### 4-5. 빠른 기록 영역 검증

- [ ] 홈 화면에서 프로필 카드 바로 아래(2번째 위치)에 배치됨
- [ ] 수유 버튼과 배변 버튼이 2열(Row)로 나란히 배치됨
- [ ] 각 버튼에 이모지(수유 아이콘, 배변 아이콘) + 레이블("수유", "배변") + "+1" + 현재 카운트("오늘 N") 표시
- [ ] 수유 +1 버튼 탭 시 feedingCount가 1 증가하고, 카운트 텍스트("오늘 N")가 즉시 업데이트됨
- [ ] 배변 +1 버튼 탭 시 diaperCount가 1 증가하고, 카운트 텍스트("오늘 N")가 즉시 업데이트됨
- [ ] +1 탭 시 "저장됨" 토스트가 화면 하단에 1초간 표시됨 (디자인컴포넌트 2-6-2 기준: darkBrown 80% 배경, white 텍스트, 모서리 8dp)
- [ ] +1 탭 시 카운터 숫자에 scale-up 애니메이션 적용 (잠깐 확대 후 원래 크기)
- [ ] +1 탭 시 햅틱 피드백(lightImpact) 발생
- [ ] 각 버튼의 터치 영역이 최소 48dp 높이
- [ ] 카드 배경: Theme cardColor, 모서리 12dp, 패딩 12dp
- [ ] DailyRecord가 DB에 저장됨 (getTodayRecord로 확인 가능)
- [ ] ValueKey: `quick_record_row`, `quick_feeding_btn`, `quick_diaper_btn`, `feeding_count_text`, `diaper_count_text`

### 4-6. 오늘의 미션 카드 검증

- [ ] 섹션 타이틀 "오늘의 활동" 표시 (headlineMedium / H2)
- [ ] 카드 상단에 활동 유형 칩 표시 (예: [안기]) -- paleCream 배경, warmOrange 텍스트, 12sp, 모서리 8dp
- [ ] 활동명 표시 (headlineMedium / H2) -- 예: "품-숨-멈춤 루틴"
- [ ] 활동 설명 표시 (bodyLarge / Body1)
- [ ] 권장 시간 표시 (bodySmall / Caption) -- 예: "권장 시간: 30초"
- [ ] "시작하기" CTA 버튼 표시 (ElevatedButton, warmOrange 배경, white 텍스트, 모서리 24dp, 높이 52dp)
- [ ] 카드 배경: Theme cardColor, 모서리 16dp, 패딩 16dp
- [ ] 활동 데이터가 없을 때(weekIndex에 해당하는 콘텐츠 없음) 빈 상태 카드 표시
- [ ] "시작하기" 버튼 탭 시 아직 활동 상세 화면이 없으므로, 탭 가능하되 네비게이션은 TODO 처리 (또는 아무 동작 없음)
- [ ] ValueKey: `today_mission_card`, `mission_start_btn`, `activity_type_chip`

### 4-7. 성장 요약 카드 검증

- [ ] 섹션 타이틀 "성장 요약" 표시
- [ ] **데이터 있을 때:** 안심 메시지 표시 (예: "건강하게 자라고 있어요") + 최근 체중 값 표시
- [ ] **데이터 없을 때:** "아직 성장 기록이 없어요" 메시지 표시 (빈 상태)
- [ ] 안심 메시지는 softGreen 아이콘과 함께 표시
- [ ] "더보기" 텍스트 링크 표시 (warmOrange, 14sp) -- 탭 시 TODO (성장 곡선 미구현)
- [ ] 카드 배경: Theme cardColor, 모서리 12dp, 패딩 16dp
- [ ] ValueKey: `growth_summary_card`, `growth_more_link`

### 4-8. 이번 주 관찰 결과 검증

- [ ] 섹션 타이틀 "이번 주 관찰 결과" 표시
- [ ] **데이터 없을 때 (빈 상태):** 소프트 아이콘(seedling 또는 유사 아이콘, 48dp, warmGray 또는 softGreen) + "아직 관찰 기록이 없어요. 처음이라 괜찮아요! 준비되면 발달 탭에서 살펴보세요." 메시지 (bodyLarge / Body1, warmGray, 중앙 정렬)
- [ ] 빈 상태 카드 배경: Theme cardColor, 모서리 12dp, 패딩 24dp
- [ ] **데이터 있을 때:** 안심 메시지 + 6영역 레이더 차트 (160x160dp 미니) + "더보기" 링크
- [ ] 레이더 차트: 6 꼭짓점(몸 움직임, 감각 반응, 집중과 관심, 소리와 표현, 마음과 관계, 생활 리듬), 채움색 radarFill, 테두리 warmOrange 2px
- [ ] ValueKey: `observation_summary_card`, `empty_observation_card`, `radar_chart_mini`, `observation_more_link`

### 4-9. 스크롤 레이아웃 검증

- [ ] 홈 화면 전체가 세로 스크롤 가능 (CustomScrollView 또는 SingleChildScrollView)
- [ ] 카드 배치 순서 (위에서 아래): 아기 프로필 -> 빠른 기록 -> 오늘의 미션 -> 성장 요약 -> 관찰 요약
- [ ] 화면 좌우 패딩: 16dp
- [ ] 카드 사이 간격: 12~16dp
- [ ] 섹션 사이 간격: 16~24dp

### 4-10. UX 원칙 검증

- [ ] **"하나만 해도 충분하다"**: 오늘의 활동 카드가 1개만 크게 표시됨 (활동 목록 전체가 홈에 노출되지 않음)
- [ ] **숫자보다 말로 안심**: 성장 요약에서 안심 메시지("건강하게 자라고 있어요")가 숫자(3.2kg)보다 먼저/크게 표시됨
- [ ] **전문 용어 없음**: 홈 화면 전체에 전문 용어(모로반사, consolability 등)가 직접 노출되지 않음
- [ ] **한 손 30초 완료**: 수유/배변 +1이 원탭으로 동작하며, 키보드 입력이 필요 없음
- [ ] **죄책감 유발 요소 없음**: "미완료" 표시 없음, 연속 기록 끊김 표시 없음, 활동 완료율 표시 없음, 빈 상태 메시지가 "처음이라 괜찮아요!" 등 긍정적 톤

### 4-11. 디자인 검증

- [ ] Scaffold 배경색이 Theme.scaffoldBackgroundColor 사용 (라이트: cream `#FFF8F0`, 다크: `#1A1512`)
- [ ] 카드 배경이 Theme.cardColor 사용 (라이트: white, 다크: `#2A231D`)
- [ ] 모든 텍스트 스타일이 `Theme.of(context).textTheme.xxx` 사용 (AppTextStyles 직접 참조 금지)
- [ ] 색상 참조 시 하드코딩 대신 Theme.colorScheme 또는 AppColors 상수 사용
- [ ] 각 카드의 모서리 둥글기, 패딩, 그림자가 디자인컴포넌트 스펙과 일치
- [ ] 다크 모드에서 텍스트, 배경, 카드 색상이 정상 전환됨
- [ ] 조부모 모드 대응: 조부모 모드 ThemeData 적용 시 글자 크기가 +4sp 증가함 (grandparent_theme.dart 활용)

### 4-12. 접근성 검증

- [ ] 모든 탭 가능한 영역의 최소 크기가 48x48dp
- [ ] +1 버튼 탭 시 햅틱 피드백 발생 (무음 모드 대응)
- [ ] 빈 상태(empty state)가 관찰 요약, 성장 요약 각각에서 데이터 없을 때 정상 표시됨
- [ ] 아기가 등록되지 않은 극단적 상태에서 크래시 없이 빈 상태 처리됨

### 4-13. 데이터 흐름 검증

- [ ] 홈에서 수유 +1 탭 시 DailyRecord.feedingCount가 DB에 반영됨 (DailyRecordDao.getTodayRecord로 확인)
- [ ] 홈에서 배변 +1 탭 시 DailyRecord.diaperCount가 DB에 반영됨
- [ ] 오늘 DailyRecord가 존재하지 않을 때 +1 탭 하면 새 레코드가 자동 생성됨
- [ ] todayRecordProvider가 activeBabyProvider를 watch하여, 활성 아기 변경 시 데이터가 갱신됨
- [ ] 홈 화면의 수유/배변 카운트와 (향후) 기록 탭의 수유/배변 카운트가 같은 DailyRecord를 참조함

### 4-14. ValueKey 목록 (Marionette MCP 테스트용)

| 위젯 | ValueKey |
|---|---|
| MainShell | `main_shell` |
| NavigationBar | `bottom_nav_bar` |
| 홈 탭 | `nav_tab_home` |
| 기록 탭 | `nav_tab_record` |
| 활동 탭 | `nav_tab_activity` |
| 발달 탭 | `nav_tab_dev_check` |
| 마이 탭 | `nav_tab_my` |
| 홈 AppBar | `home_app_bar` |
| 홈 스크롤 뷰 | `home_scroll_view` |
| 아기 프로필 카드 | `baby_profile_card` |
| 빠른 기록 영역 | `quick_record_row` |
| 수유 +1 버튼 | `quick_feeding_btn` |
| 배변 +1 버튼 | `quick_diaper_btn` |
| 수유 카운트 텍스트 | `feeding_count_text` |
| 배변 카운트 텍스트 | `diaper_count_text` |
| 오늘의 미션 카드 | `today_mission_card` |
| 미션 시작 버튼 | `mission_start_btn` |
| 활동 유형 칩 | `activity_type_chip` |
| 성장 요약 카드 | `growth_summary_card` |
| 성장 더보기 링크 | `growth_more_link` |
| 관찰 요약 카드 | `observation_summary_card` |
| 빈 관찰 카드 | `empty_observation_card` |
| 레이더 차트 미니 | `radar_chart_mini` |
| 관찰 더보기 링크 | `observation_more_link` |

---

## 5. 구현 가이드 (Generator용)

### 5-1. MainShell 리팩터링

현재 `main_shell.dart`는 `IndexedStack` 없이 단순 텍스트 플레이스홀더다. 다음과 같이 리팩터링한다:

**방법 A (권장 -- 간단한 IndexedStack 기반):**
- MainShell이 `IndexedStack`으로 5개 탭 화면을 관리
- 홈 탭(index 0)은 `HomeScreen`, 나머지 탭은 `Placeholder` 위젯 + 탭 이름 텍스트
- GoRouter `/home` 경로는 기존대로 MainShell을 빌드

**방법 B (StatefulShellRoute -- 향후 확장성):**
- GoRouter `StatefulShellRoute.indexedStack`으로 5개 branch 구성
- 각 branch에 독립 네비게이터 부여
- 이 방법은 탭별 독립 라우팅이 필요할 때 장점이 있음

**이 스프린트에서는 방법 A를 기본으로 한다.** 향후 스프린트에서 StatefulShellRoute로 전환할 수 있다.

### 5-2. 홈 화면 구조

```
HomeScreen (Scaffold)
  +- AppBar (변형 A: "하루 한 가지" 타이틀)
  +- body: SingleChildScrollView (또는 CustomScrollView)
       +- Padding(horizontal: 16)
            +- Column
                 +- BabyProfileCard
                 +- SizedBox(h: 12)
                 +- QuickRecordRow
                 +- SizedBox(h: 16)
                 +- SectionTitle("오늘의 활동")
                 +- SizedBox(h: 8)
                 +- TodayMissionCard
                 +- SizedBox(h: 16)
                 +- SectionTitle("성장 요약")
                 +- SizedBox(h: 8)
                 +- GrowthSummaryCard
                 +- SizedBox(h: 16)
                 +- SectionTitle("이번 주 관찰 결과")
                 +- SizedBox(h: 8)
                 +- ObservationSummaryCard
                 +- SizedBox(h: 24) // 하단 여백
```

### 5-3. 텍스트 스타일 규칙

모든 텍스트는 반드시 `Theme.of(context).textTheme`을 사용한다:

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

**금지:** `AppTextStyles.h2` 등 직접 참조. 항상 `Theme.of(context).textTheme.headlineMedium` 사용.

### 5-4. 색상 규칙

- Scaffold 배경: `Theme.of(context).scaffoldBackgroundColor`
- 카드 배경: `Theme.of(context).cardColor`
- 포인트 색상: `Theme.of(context).colorScheme.primary` (warmOrange)
- 긍정/안심 색상: `Theme.of(context).colorScheme.secondary` (softGreen)
- 텍스트 주색상: `Theme.of(context).colorScheme.onSurface`
- 보조 텍스트: bodySmall 스타일의 color (warmGray / darkTextSecondary)
- 비활성: `AppColors.mutedBeige` (다크 모드 미변경 항목은 AppColors 직접 사용 가능)

### 5-5. AppStrings 추가 항목

```dart
// ── 홈 화면 ──
static const homeTitle = '오늘 우리 아이는?';
static const quickRecordTitle = '빠른 기록';
static const feeding = '수유';
static const diaper = '배변';
static const plusOne = '+1';
static const todayCount = '오늘';
static const saved = '저장됨';
static const growthSummaryTitle = '성장 요약';
static const growthReassurance = '건강하게 자라고 있어요';
static const observationSummaryTitle = '이번 주 관찰 결과';
static const moreLink = '더보기';
static const recommendedTime = '권장 시간';
static const seconds = '초';
```

### 5-6. "저장됨" 토스트 구현

디자인컴포넌트 2-6-2 기준:
- 위치: 화면 하단 중앙, 하단 탭 바 위 16dp
- 배경: darkBrown 80% 불투명
- 텍스트: "저장됨" (Caption, 13sp, white)
- 모서리: 8dp
- 표시 시간: 1초
- 애니메이션: 페이드인 0.2초 -> 1초 유지 -> 페이드아웃 0.2초

`ScaffoldMessenger.showSnackBar` 사용:
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('저장됨'),
    duration: Duration(seconds: 1),
    behavior: SnackBarBehavior.floating,
    // ... 스타일링
  ),
);
```

### 5-7. Activity 시드 데이터 (최소 구현)

홈 화면의 todayMission 표시를 위해 0-1주차 활동 5개를 최소한으로 정의한다. 상세 필드(steps, observationPoints 등)는 활동 상세 스프린트에서 채운다. 이 스프린트에서는 `id`, `weekIndex`, `order`, `name`, `type`, `description`, `recommendedSeconds` 필드만 필수로 채운다.

---

## 6. 의존성

### 이전 스프린트 의존

| 스프린트 | 산출물 | 이 스프린트에서 사용 |
|---|---|---|
| Sprint 01 | AppColors, AppTextStyles, AppDimensions, AppShadows, AppRadius, AppTheme (light/dark), DatabaseHelper, Tables, GoRouter, PrimaryCtaButton | 전체 |
| Sprint 02 | 온보딩 4화면, Baby 모델, BabyDao, activeBabyProvider, AppSettingsService, MainShell (플레이스홀더), AppStrings, WeekCalculator, WeekContentSeed, InfoTerm, GrandparentTheme | 전체 |

### 필요 패키지

| 패키지 | 버전 | 용도 | 비고 |
|---|---|---|---|
| `flutter_riverpod` | ^2.5.0 | Provider 상태 관리 | Sprint 01에서 설치 완료 |
| `go_router` | ^14.0.0 | 라우팅 | Sprint 01에서 설치 완료 |
| `sqflite` | ^2.4.0 | 로컬 DB | Sprint 01에서 설치 완료 |
| `fl_chart` | ^0.68.0 | 레이더 차트 | **이 스프린트에서 추가 필요** (pubspec.yaml에 없으면 추가) |

### 다음 스프린트와의 관계

- **Sprint 04 (기록 탭):** 이 스프린트의 DailyRecord/DailyRecordDao/todayRecordProvider를 그대로 공유. 홈의 수유/배변 +1과 기록 탭의 카운터가 같은 데이터를 참조해야 함.
- **Sprint 05+ (활동 상세):** 이 스프린트의 Activity 모델/시드 데이터를 확장. todayMissionCard의 "시작하기" 버튼이 활동 상세 화면으로 네비게이션.
- **Sprint 06+ (발달 체크):** 이 스프린트의 ObservationSummaryCard가 ChecklistRecord 데이터를 표시. 현재는 빈 상태만 구현.
