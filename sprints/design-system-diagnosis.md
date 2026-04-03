# 디자인 시스템 진단서: "하루 한 가지" 앱

**진단일:** 2026-03-27
**진단 방법:** 코드 리뷰 + Marionette MCP 실행 스크린샷 분석 (7개 화면)
**대상 파일:** app_colors.dart, app_text_styles.dart, app_dimensions.dart, app_radius.dart, app_shadows.dart, app_theme.dart
**기준 문서:** docs/3_디자인컴포넌트.md

---

## 진단 요약

**핵심 문제:** 앱 전체가 "warmOrange + cream/white" 두 가지 톤으로만 구성되어 있어 모든 화면이 시각적으로 동일한 인상을 준다. 카드 유형, 활동 영역, 기록 항목 간 시각적 차별화가 전혀 없어 정보 위계가 평면적이며, 장식 요소가 Material Icons에 전적으로 의존하고 있어 "기능은 되지만 기억에 남지 않는" 밋밋한 UI가 되었다. 가장 심각한 것은 6개 발달 영역(안기/감각/소리/시각/촉각/균형)이 모두 동일한 warmOrange 칩 색상을 사용하여, 앱의 핵심 콘텐츠인 "다양한 활동 영역"이 시각적으로 구분되지 않는 점이다.

---

## 문제 1: 영역별 구분 컬러 부재 -- 모노크롬 오렌지 앱

### 현재 상태
- `ActivityTypeChip`이 **모든** 활동 유형(안기, 감각, 소리, 시각, 촉각, 균형)에 대해 동일한 `paleCream` 배경 + `warmOrange` 텍스트를 사용한다.
- 스크린샷(활동 목록)에서 "안기", "감각", "소리" 칩이 모두 같은 색이다.
- 기록 탭에서 수유와 배변 카드만 accentColor로 구분되고 (warmOrange vs softGreen), 나머지 영역은 구분 없음.
- 레이더 차트도 6개 영역이 모두 같은 warmOrange로 그려진다.

### 왜 문제인가
- 사용자가 "감각 활동"과 "소리 활동"을 시각적으로 즉시 구분할 수 없다.
- 영유아 앱에서 발달 영역별 색상 코딩은 정보 인지의 핵심이다 -- 색만으로 "아, 이건 감각 활동이구나"를 알 수 있어야 한다.
- 현재는 텍스트를 읽어야만 유형을 파악할 수 있다.

### 구체적 개선안

**6개 활동 영역별 시맨틱 컬러 추가** (app_colors.dart에 추가):

```dart
// ── 활동 영역 컬러 ──
// 기존 warmOrange 톤과 조화로운 파스텔/소프트 톤

static const domainHolding = Color(0xFFE8A0BF);    // 안기 -- 따뜻한 로즈핑크
static const domainSensory = Color(0xFF7BC67E);     // 감각 -- 기존 softGreen 재활용
static const domainSound = Color(0xFF7EB8DA);       // 소리 -- 소프트 스카이블루
static const domainVision = Color(0xFFB49ADB);      // 시각 -- 소프트 라벤더
static const domainTouch = Color(0xFFF5A623);       // 촉각 -- 기존 warmOrange 유지
static const domainBalance = Color(0xFFE8C86A);     // 균형/생활리듬 -- 소프트 골드

// 각 영역의 연한 배경 (칩/카드용, 10% 느낌)
static const domainHoldingBg = Color(0xFFFCF0F5);
static const domainSensoryBg = Color(0xFFF0F9F0);   // 기존 mintTint
static const domainSoundBg = Color(0xFFF0F5FA);
static const domainVisionBg = Color(0xFFF5F0FA);
static const domainTouchBg = Color(0xFFFFF3E8);     // 기존 paleCream
static const domainBalanceBg = Color(0xFFFFF8E8);
```

**적용 위젯:** `ActivityTypeChip`, `ActivityCard` 좌측 악센트바, `RadarChartPainter` 축별 색상, `ActivityFilterChips` 선택 색상.

---

## 문제 2: 배경-카드 대비 부족 + 카드 간 깊이감 부재

### 현재 상태
- 배경: `cream` (#FFF8F0), 카드: `white` (#FFFFFF).
- 이 두 색의 명도 차이가 매우 작다 (L*: cream=97.8, white=100.0, 차이 약 2.2).
- 모든 카드가 동일한 `AppShadows.low` (blur 4, alpha 5%)를 사용하거나 그림자를 아예 사용하지 않는다.
- 스크린샷에서 카드 경계가 거의 보이지 않아 "카드가 배경 위에 떠 있다"는 느낌이 아니라 "배경과 한 몸"으로 보인다.
- 특히 홈 화면의 빠른 기록 영역(QuickRecordRow)은 카드 내부에 또 배경색 요소가 있어 레이어 구분이 3단계 이상 필요한데, 현재 cream/white/cream이 거의 동일하게 보인다.

### 왜 문제인가
- 카드 기반 레이아웃의 핵심은 "정보를 시각적 그룹으로 분리"하는 것인데, 카드 테두리가 보이지 않으면 이 기능을 잃는다.
- 사용자가 화면을 빠르게 스캔할 때, 정보 블록의 시작/끝을 시각적으로 구분할 수 없다.

### 구체적 개선안

**방안 A: 카드에 미세한 border 추가 (라이트 모드에서도)**
```dart
// app_theme.dart - lightTheme() 내 cardTheme 수정
cardTheme: CardThemeData(
  color: AppColors.white,
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppRadius.md),
    side: const BorderSide(
      color: AppColors.lightBeige, // #F0E6D8
      width: 1,
    ),
  ),
),
```

**방안 B: 그림자 강도를 단계별로 차별화**
```dart
// app_shadows.dart 보강
static const subtle = [
  BoxShadow(
    color: Color(0x08000000),
    blurRadius: 2,
    offset: Offset(0, 1),
  ),
];

// 기존 low 강도를 약간 올리기
static const low = [
  BoxShadow(
    color: Color(0x14000000),  // 5% -> 8%로 증가
    blurRadius: 6,             // 4 -> 6
    offset: Offset(0, 2),     // 1 -> 2
  ),
];

// 오늘의 미션 카드, 프로필 카드 등 "주요 카드"에만 medium 적용
static const medium = [
  BoxShadow(
    color: Color(0x1F000000),  // 10% -> 12%로 증가
    blurRadius: 12,            // 8 -> 12
    offset: Offset(0, 4),     // 2 -> 4
  ),
];
```

**방안 C (권장): A+B 병행** -- 미세한 border로 경계를 확보하고, 주요 카드에만 medium 그림자를 적용하여 깊이감 위계를 만든다.

---

## 문제 3: 타이포그래피 위계의 시각적 구분 부족

### 현재 상태
- h2(18sp/w600)와 h3(16sp/w600)의 크기 차이가 2sp밖에 안 된다.
- body1(15sp/w400)과 body2(14sp/w400)의 차이도 1sp.
- **모든 heading이 같은 weight(w600)**이고 색상도 동일(darkBrown)이다.
- 스크린샷에서 "오늘의 활동" 섹션 제목(h2)과 카드 내 "손바닥 감싸기" 제목(h2)이 같은 스타일이라, 섹션-콘텐츠 간 위계가 약하다.
- 특히 홈 화면에서 "오늘의 활동" / "성장 요약" / "이번 주 관찰 결과" 섹션 제목들이 콘텐츠 제목과 구분되지 않는다.

### 왜 문제인가
- 섹션 제목과 카드 제목의 시각적 위계가 없으면, 사용자가 화면 구조를 파악하기 어렵다.
- "이게 새로운 섹션인지, 이전 카드의 내용인지" 구분이 안 된다.

### 구체적 개선안

**섹션 제목에 캡션 프리픽스 패턴 도입:**
현재 텍스트 스케일 자체를 바꾸지 않더라도, 섹션 제목의 **시각적 처리**를 차별화해야 한다.

```dart
// 새로운 위젯: SectionHeader
class SectionHeader extends StatelessWidget {
  final String title;

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: AppDimensions.lg,  // 섹션 상단 여백 강화 (16 -> 24)
        bottom: AppDimensions.md,
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.warmOrange,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: AppDimensions.sm),
          Text(title, style: theme.textTheme.headlineMedium),
        ],
      ),
    );
  }
}
```

또는 **weight 차별화:**
```dart
// app_text_styles.dart 수정
// 현재: h1=w600, h2=w600, h3=w600 (모두 동일)
// 개선: h1=w700, h2=w600, h3=w500

static const h1 = TextStyle(
  fontFamily: _fontFamily,
  fontSize: 22,
  fontWeight: FontWeight.w700,  // 600 -> 700
  height: 1.4,
);

static const h3 = TextStyle(
  fontFamily: _fontFamily,
  fontSize: 16,
  fontWeight: FontWeight.w500,  // 600 -> 500
  height: 1.4,
);
```

이렇게 하면 섹션 제목(h2, w600)과 카드 제목(h3, w500)의 시각적 무게감 차이가 생긴다.

---

## 문제 4: 카드 스타일의 단조로움 -- 모든 카드가 동일한 외형

### 현재 상태
- 홈 화면의 BabyProfileCard, QuickRecordRow, TodayMissionCard, GrowthSummaryCard, ObservationSummaryCard가 **모두** 동일한 시각 스타일을 사용한다:
  - `color: theme.cardColor` (white)
  - `borderRadius: AppRadius.md` (12dp)
  - 그림자 없음 또는 AppShadows.low
- 유일한 예외: TodayMissionCard가 AppRadius.lg (16dp)를 사용하고, MyProfileCard에 상단 그라데이션 악센트 바가 있다.
- 스크린샷에서 홈 화면의 5개 카드가 "같은 흰색 사각형"으로 보인다.

### 왜 문제인가
- **정보 중요도가 시각적으로 평등하게 표현된다.** "오늘의 미션 카드"는 이 앱의 핵심 가치인데, 성장 요약 카드와 동일한 시각적 무게를 가진다.
- 사용자가 "지금 해야 할 한 가지"를 한눈에 찾기 어렵다.
- 앱의 UX 원칙 1번("하나만 해도 충분하다")을 시각적으로 지원하지 못한다.

### 구체적 개선안

**카드 유형별 3단계 시각 위계:**

**Tier 1 -- 히어로 카드** (TodayMissionCard, ReassuranceCard):
```dart
decoration: BoxDecoration(
  color: theme.cardColor,
  borderRadius: BorderRadius.circular(AppRadius.lg),  // 16dp
  boxShadow: AppShadows.medium,                       // 강한 그림자
  border: Border.all(
    color: AppColors.warmOrange.withOpacity(0.15),     // 은은한 오렌지 테두리
    width: 1,
  ),
),
```

**Tier 2 -- 표준 카드** (GrowthSummaryCard, ActivityCard, CounterCard):
```dart
decoration: BoxDecoration(
  color: theme.cardColor,
  borderRadius: BorderRadius.circular(AppRadius.md),  // 12dp
  boxShadow: AppShadows.low,
  border: Border.all(
    color: AppColors.lightBeige,                      // 기본 border
    width: 1,
  ),
),
```

**Tier 3 -- 인라인 카드** (BabyProfileCard, QuickRecordRow):
```dart
decoration: BoxDecoration(
  color: theme.cardColor,
  borderRadius: BorderRadius.circular(AppRadius.md),
  // 그림자 없음, 얇은 border만
  border: Border.all(
    color: AppColors.lightBeige.withOpacity(0.7),
    width: 0.5,
  ),
),
```

---

## 문제 5: 상태 컬러 시스템 불완전

### 현재 상태
- 성공: `softGreen` (#7BC67E) -- 사용됨 (안심 메시지, 완료 체크)
- 경고: `softYellow` (#FFD93D) -- 사용됨 (위험 신호 배너)
- 에러: `softRed` (#FF6B6B) -- 사용됨 (위험 텍스트, 삭제)
- **정보(info)**: 전용 색상 없음. 발달 탭 상단 info 배너가 `softYellow` 배경을 사용하는데, 이는 "주의"와 "정보"를 구분하지 못한다.
- **진행중/활성(active)**: warmOrange만 사용. "타이머 실행 중" 상태에 별도 색상 없음.

### 왜 문제인가
- "며칠 더 지켜본 뒤, 걱정이 계속되면 전문가와 이야기해 보세요" 같은 **정보성 안내**가 softYellow(주의) 배경에 있으면, 사용자가 "경고인가?" 하고 불안해할 수 있다. UX 원칙 5번("죄책감 금지")에 위배될 가능성.

### 구체적 개선안

```dart
// app_colors.dart에 추가
// ── 상태 컬러 (시맨틱) ──
static const success = Color(0xFF7BC67E);      // 기존 softGreen
static const successBg = Color(0xFFF0F9F0);    // 기존 mintTint
static const warning = Color(0xFFFFD93D);      // 기존 softYellow
static const warningBg = Color(0xFFFFF8E0);    // 새로 추가 (연한 노랑)
static const error = Color(0xFFFF6B6B);        // 기존 softRed
static const errorBg = Color(0xFFFFF0F0);      // 새로 추가 (연한 빨강)
static const info = Color(0xFF7EB8DA);         // 새로 추가 (소프트 블루)
static const infoBg = Color(0xFFF0F5FA);       // 새로 추가 (연한 파랑)
```

발달 탭 상단 info 배너를 `softYellow` -> `infoBg` + `info` 아이콘으로 변경.

---

## 문제 6: 장식 요소 부재 -- 전적으로 Material Icons 의존

### 현재 상태
- 앱 전체에서 사용되는 시각 요소가 **Material Icons**뿐이다.
- 스크린샷에서 확인: 홈 아이콘(home), 기록 아이콘(edit_note), 활동 아이콘(star), 아기 아이콘(child_care), 수유 아이콘(local_drink_outlined) 등 전부 Material 기본 아이콘.
- 온보딩, 빈 상태, 타이머 완료 등에 **커스텀 일러스트가 없다**.
- 디자인 스펙(2-2-8)에서 빈 상태에 "소프트 아이콘 또는 일러스트"를 명시했으나, 실제로는 Material Icon + tinted circle만 사용.
- 그라데이션은 MyProfileCard 상단 바(warmOrange -> 50% warmOrange)에만 사용.

### 왜 문제인가
- Material Icons는 범용적이라 앱의 개성/브랜드를 전달할 수 없다.
- 영유아 앱은 감성적 연결이 중요한데, 기계적인 아이콘은 "차갑다".
- 경쟁 앱(그로잉, 베이비타임 등)은 커스텀 일러스트를 통해 따뜻하고 귀여운 느낌을 전달한다.

### 구체적 개선안

**단기 (코드 레벨):**

1. **아이콘 색상 페어링으로 생동감 추가** -- 아이콘 뒤에 영역별 tinted circle 배경을 일괄 적용.
2. **그라데이션 활용 확대:**

```dart
// app_colors.dart에 추가
// ── 그라데이션 프리셋 ──
static const headerGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFFFF8F0),  // cream
    Color(0xFFFFF0E0),  // 약간 더 진한 cream
  ],
);

static const missionCardGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFFFFFFF),
    Color(0xFFFFF8F0),  // white -> cream 미세 그라데이션
  ],
);

static const timerBgGradient = RadialGradient(
  center: Alignment.center,
  radius: 0.8,
  colors: [
    Color(0xFFFFF8F0),
    Color(0xFFFFF0E0),
  ],
);
```

3. **타이머 화면 배경에 미세 방사형 그라데이션 적용** -- 현재 타이머 화면이 단색 cream으로 매우 밋밋하다. 중앙에서 바깥으로 약간 어두워지는 그라데이션이면 시각적 깊이가 생긴다.

4. **카드 내부 장식 요소:**
```dart
// 오늘의 미션 카드 상단에 도메인 컬러 스트라이프
Container(
  height: 3,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [domainColor, domainColor.withOpacity(0.3)],
    ),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(AppRadius.lg),
      topRight: Radius.circular(AppRadius.lg),
    ),
  ),
),
```

**중기 (에셋 제작 필요):**
- Lottie 애니메이션: 타이머 완료 축하, 온보딩 웰컴
- SVG 커스텀 아이콘: 수유/배변/수면/성장/활동 전용 아이콘
- 빈 상태 일러스트: 아기 관련 소프트 일러스트

---

## 문제 7: 섹션 간 간격과 시각적 구분 부족

### 현재 상태
- 홈 화면의 섹션 간격: `SizedBox(height: AppDimensions.base)` = 16dp.
- 카드 간 간격: `SizedBox(height: AppDimensions.cardGap)` = 12dp.
- **섹션 간(16dp)과 카드 간(12dp)의 차이가 4dp뿐**이라 시각적으로 구분이 안 된다.
- 섹션 제목("오늘의 활동", "성장 요약")과 이전 카드 사이에 추가적인 구분 장치가 없다.
- 스크린샷에서 "빠른 기록 -> 오늘의 활동 -> 손바닥 감싸기 카드 -> 성장 요약 -> 빈 상태 카드"가 하나의 연속된 흐름으로 보인다.

### 왜 문제인가
- 정보가 5개 블록으로 나뉘어야 하는데, 시각적으로 1개의 긴 목록처럼 보인다.
- 스캔(훑어보기) 속도가 느려진다.

### 구체적 개선안

```dart
// app_dimensions.dart 수정
static const double sectionGap = 32;   // 24 -> 32 (섹션 사이)
static const double cardGap = 12;      // 유지 (같은 섹션 내 카드 사이)
static const double sectionDivider = 1; // 새로 추가 (선택적 구분선 두께)

// 또는 시각적 섹션 구분선 위젯 추가
class SectionDivider extends StatelessWidget {
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.lg),
      child: Divider(
        color: AppColors.lightBeige,
        thickness: 1,
        height: 1,
      ),
    );
  }
}
```

홈 화면에서 섹션 간격을 32dp로 늘리면, 16dp인 카드 간격과 2배 차이가 나서 시각적 그룹핑이 가능해진다.

---

## 문제 8: 기록 탭의 단조로운 카드 레이아웃

### 현재 상태
- 기록 탭의 수유/배변 카드가 **완전히 동일한 구조**(좌측 악센트바 + 이모지 + 카운터)인데, 유일한 차이점인 악센트바 색상(warmOrange vs softGreen)이 스크린샷에서 거의 인식되지 않는다.
- 수면 카드는 다른 구조(드롭다운)이지만 시각적 톤이 동일하다.
- 스크린샷에서 기록 탭이 "같은 카드 3개 반복"처럼 보인다.
- 이모지(젖병, 기저귀, zzz)가 너무 작고(24sp) 시각적 앵커 역할을 하지 못한다.

### 왜 문제인가
- 기록은 매일 반복하는 핵심 행위인데, 시각적으로 지루하면 사용 동기가 떨어진다.
- UX 원칙 4번("한 손, 30초")을 만족하려면 각 항목을 빠르게 시각적으로 구분할 수 있어야 한다.

### 구체적 개선안

1. **이모지 배경 원의 색상을 영역별로 차별화:**
```dart
// 수유 카드 이모지 배경
Container(
  width: 48,
  height: 48,
  decoration: BoxDecoration(
    color: Color(0xFFFFF0E0),  // warmOrange 연한 배경
    borderRadius: BorderRadius.circular(AppRadius.sm),
  ),
  child: Text(emoji, style: TextStyle(fontSize: 28)),  // 24 -> 28
),

// 배변 카드 이모지 배경
Container(
  width: 48,
  height: 48,
  decoration: BoxDecoration(
    color: Color(0xFFF0F9F0),  // softGreen 연한 배경 (mintTint)
    borderRadius: BorderRadius.circular(AppRadius.sm),
  ),
  child: Text(emoji, style: TextStyle(fontSize: 28)),
),

// 수면 카드 이모지 배경
Container(
  width: 48,
  height: 48,
  decoration: BoxDecoration(
    color: Color(0xFFF0F0FA),  // 소프트 라벤더 배경
    borderRadius: BorderRadius.circular(AppRadius.sm),
  ),
  child: Text(emoji, style: TextStyle(fontSize: 28)),
),
```

2. **악센트바 두께 강화:** 4px -> 6px으로 늘려서 색상 구분을 더 눈에 띄게.

3. **카운터 숫자에 영역별 색상 적용:**
```dart
// 현재: 모든 카운터가 darkBrown
// 개선: 수유는 warmOrange, 배변은 softGreen
Text(
  '${count}회',
  style: theme.textTheme.displayMedium?.copyWith(
    color: accentColor,  // 영역별 색상
  ),
),
```

---

## 문제 9: 타이머 화면의 시각적 빈곤

### 현재 상태
- 타이머 화면 스크린샷: cream 배경 + 원형 링 + 큰 숫자 + 2개 버튼.
- 링의 트랙 색상(trackGray)이 배경(cream)과 대비가 약해 링 자체가 희미하게 보인다.
- 가이드 텍스트("아기의 손을 살며시 열어주세요")가 작고 warmGray라 거의 안 보인다.
- 타이머 진행 중 상태/완료 상태 간 시각적 전환이 빈약하다 (색상만 변경, 레이아웃 동일).
- 플레이 버튼은 warmOrange로 눈에 띄지만, 리셋 버튼은 너무 밋밋하다.

### 왜 문제인가
- 타이머 화면은 활동의 핵심 경험이다. 30초를 세는 동안 사용자가 보는 화면이 밋밋하면 경험의 질이 떨어진다.
- 가이드 텍스트는 "아기에게 뭘 해야 하는지" 안내하는 핵심 정보인데 너무 약하다.

### 구체적 개선안

```dart
// 1. 링 트랙 대비 강화
TimerRingPainter(
  trackColor: AppColors.lightBeige,  // trackGray(#E8DDD0) -> lightBeige(#F0E6D8)는 더 약하므로
  // 대신 전용 색상 추가:
  // static const timerTrack = Color(0xFFE0D4C4); // 더 진한 트랙
  strokeWidth: 10,  // 8 -> 10 (존재감 강화)
),

// 2. 가이드 텍스트 스타일 강화
Text(
  guideText,
  style: theme.textTheme.bodyLarge?.copyWith(  // bodySmall -> bodyLarge
    color: AppColors.darkBrown,                // warmGray -> darkBrown
    fontWeight: FontWeight.w500,
  ),
),

// 3. 타이머 배경에 미세 그라데이션 또는 배경 원 추가
Container(
  decoration: BoxDecoration(
    gradient: RadialGradient(
      center: Alignment.center,
      radius: 0.6,
      colors: [
        AppColors.paleCream,  // 중앙 약간 따뜻한 색
        AppColors.cream,      // 바깥 기본 배경
      ],
    ),
  ),
),
```

---

## 문제 10: 활동 상세 화면의 레이아웃 단조로움

### 현재 상태
- 스크린샷에서 활동 상세 화면이 순수 텍스트 나열이다: 칩 + 제목 + 설명 + "이렇게 해보세요" + 번호 리스트 + "더 알아보기" + CTA 버튼.
- 스텝 가이드의 번호(1-5)가 warmOrange 원 + 세로 연결선으로 되어 있어 그나마 시각적 포인트가 있지만, 상단부(칩~설명 영역)는 완전히 텍스트만 있다.
- 화면의 상단 1/3이 텍스트로만 채워져 있어 시각적 앵커가 없다.

### 왜 문제인가
- "활동 상세"는 부모가 "이 활동을 시작할 것인가?"를 결정하는 화면이다. 시각적으로 매력적이지 않으면 시작 동기가 떨어진다.
- 활동 유형(감각, 안기, 소리 등)에 따라 화면 분위기가 달라져야 활동 다양성이 느껴지는데, 현재는 모든 활동 상세가 동일하다.

### 구체적 개선안

1. **상단에 영역별 컬러 헤더 영역 추가:**
```dart
// 활동 유형에 따라 배경 그라데이션 적용
Container(
  padding: EdgeInsets.all(AppDimensions.lg),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        domainBgColor,        // 영역별 연한 배경
        AppColors.cream,      // 기본 배경으로 자연스럽게 전환
      ],
    ),
  ),
  child: Column(
    children: [
      ActivityTypeChip(type: activity.type),
      Text(activity.name, style: ...),
      Text(activity.description, style: ...),
    ],
  ),
),
```

2. **이모지/아이콘을 활동별로 표시** -- 활동 데이터에 대표 이모지나 아이콘이 있다면 72dp 크기로 상단에 배치.

---

## Generator에게 전달할 수정 지시

### 우선순위 1 (핵심 -- 즉시 적용)

**파일: `lib/core/constants/app_colors.dart`**
1. 활동 영역별 6색 추가 (domainHolding/domainSensory/domainSound/domainVision/domainTouch/domainBalance + 각 Bg 색상)
2. 상태 시맨틱 컬러 추가 (info/infoBg)
3. 타이머 전용 트랙 색상 추가 (timerTrack)

**파일: `lib/core/widgets/activity_type_chip.dart`**
4. 활동 유형별 색상 매핑 추가. type 파라미터에 따라 domainColor/domainBgColor를 자동 선택하도록 수정.

**파일: `lib/core/constants/app_shadows.dart`**
5. `low` 그림자 강도 약간 증가 (alpha 0x0D -> 0x14, blur 4 -> 6).
6. `subtle` 레벨 추가.

**파일: `lib/core/theme/app_theme.dart`**
7. 라이트 모드 CardTheme에 `side: BorderSide(color: AppColors.lightBeige, width: 1)` 추가.

### 우선순위 2 (개선 -- 스프린트 내 적용)

**파일: `lib/core/constants/app_text_styles.dart`**
8. h1 weight를 w600 -> w700으로, h3 weight를 w600 -> w500으로 변경하여 heading 위계 차별화.

**파일: `lib/core/constants/app_dimensions.dart`**
9. sectionGap을 24 -> 32로 변경.

**파일: `lib/features/home/screens/home_screen.dart`**
10. 섹션 제목 위 간격을 `SizedBox(height: AppDimensions.sectionGap)`으로 통일.
11. (선택) SectionHeader 위젯 도입하여 섹션 제목 좌측에 3px warmOrange 바 추가.

**파일: `lib/features/record/widgets/counter_card.dart`**
12. 악센트바 두께 4px -> 6px.
13. 이모지 크기 24 -> 28.
14. 카운터 숫자 색상에 accentColor 적용 옵션 추가.

**파일: `lib/features/activity/widgets/activity_card.dart`**
15. 카드 좌측에 영역별 색상 악센트바 추가 (CounterCard 패턴과 동일).

**파일: `lib/features/dev_check/widgets/radar_chart_card.dart`**
16. 6축에 영역별 domainColor 적용 (레이블 텍스트 색상, 꼭짓점 색상).

### 우선순위 3 (보강 -- 시간 여유 시)

**파일: `lib/features/activity/screens/activity_timer_screen.dart`**
17. 타이머 배경에 RadialGradient 추가.
18. 가이드 텍스트를 bodyLarge + darkBrown으로 강화.
19. 링 strokeWidth 8 -> 10.

**파일: `lib/features/activity/screens/activity_detail_screen.dart`**
20. 상단에 영역별 그라데이션 헤더 영역 추가.

**파일: `lib/features/home/widgets/today_mission_card.dart`**
21. 카드 상단에 영역별 색상 스트라이프 추가.
22. AppShadows.medium 적용으로 히어로 카드 강조.

**파일: `lib/core/widgets/empty_state_card.dart`**
23. 아이콘 배경 색상을 warmOrange 고정이 아닌, 컨텍스트별로 전달받도록 파라미터화.

---

## 변경 영향도 분석

| 변경 사항 | 영향 범위 | 파괴적 변경 | 비고 |
|---|---|---|---|
| 영역별 컬러 추가 | app_colors.dart만 | 아님 (추가만) | 기존 코드 영향 없음 |
| CardTheme border 추가 | 전체 카드 | 미미함 | 이미 다크 모드에서 border 사용 중 |
| 그림자 강도 변경 | 전체 카드 | 미미함 | 시각적 차이만 |
| h1/h3 weight 변경 | 전체 heading | 약간 | 화면별 확인 필요 |
| sectionGap 변경 | 전체 레이아웃 | 약간 | 스크롤 길이 약간 증가 |
| ActivityTypeChip 색상 | 활동 관련 화면 | 아님 | 기존 paleCream -> 영역별 색상 |
| 카운터 악센트바 강화 | 기록 탭 | 아님 | 시각적 변경만 |

---

## 결론

현재 디자인 시스템은 **기능적으로는 완전하지만 감성적으로 부족하다.** 핵심 원인은 (1) 모노크롬 컬러 팔레트, (2) 카드 간 시각적 위계 부재, (3) 장식 요소 부재의 삼중 문제이다. 우선순위 1의 컬러 시스템 확장과 카드 border 추가만으로도 체감 품질이 크게 올라갈 것이다. 영역별 6색 시스템은 앱의 정보 아키텍처와 직접적으로 연결되므로, 단순 "꾸미기"가 아니라 **정보 전달력 향상**으로 봐야 한다.
