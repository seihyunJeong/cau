# 디자인 시스템 진단 수정 결과

**수정일:** 2026-03-27
**대상:** 우선순위 1 수정 7건
**flutter analyze:** 통과 (에러/경고 0건, 기존 info 11건 유지)

---

## 수정된 파일 목록

### 디자인 토큰 (4파일)

1. **`lib/core/constants/app_colors.dart`**
   - 활동 영역별 6색 추가: domainHolding(로즈핑크), domainSensory(그린), domainSound(스카이블루), domainVision(라벤더), domainTouch(warmOrange), domainBalance(골드)
   - 각 영역의 배경 버전(xxxBg) 6색 추가
   - 시맨틱 상태 컬러 추가: info(소프트 블루), infoBg(연한 파랑)

2. **`lib/core/constants/app_shadows.dart`**
   - low 그림자 강도 증가: alpha 0x0D->0x14, blur 4->6, offset y 1->2
   - subtle 레벨 신규 추가 (가장 약한 그림자, 인라인 카드용)

3. **`lib/core/constants/app_text_styles.dart`**
   - h1 fontWeight: w600 -> w700 (섹션 제목 강조)
   - h3 fontWeight: w600 -> w500 (카드 내 제목과 섹션 제목 간 위계 차별화)

4. **`lib/core/constants/app_dimensions.dart`**
   - sectionGap: 24 -> 32 (섹션 간 간격 차별화, 카드 간 12dp와 2.6배 차이)

### 테마 (1파일)

5. **`lib/core/theme/app_theme.dart`**
   - 라이트 모드 CardTheme에 `BorderSide(color: AppColors.lightBeige, width: 1)` 추가
   - 카드 경계가 배경과 구분되어 정보 블록 인식 향상

### 컴포넌트 (1파일)

6. **`lib/core/widgets/activity_type_chip.dart`**
   - 활동 유형별 색상 자동 매핑 로직 추가 (static 메서드 domainColor/domainBgColor)
   - 안기=로즈핑크, 감각=그린, 소리=스카이블루, 시각=라벤더, 촉각=warmOrange, 자세=골드
   - 칩 텍스트에 fontWeight w600 추가 (가독성 강화)
   - 외부 위젯에서도 `ActivityTypeChip.domainColor(type)` 으로 색상 조회 가능

### 화면 위젯 (4파일)

7. **`lib/features/home/screens/home_screen.dart`**
   - 섹션 간 간격을 `AppDimensions.base`(16) -> `AppDimensions.sectionGap`(32)으로 통일

8. **`lib/features/home/widgets/today_mission_card.dart`**
   - 영역별 색상 상단 스트라이프(3px) 추가 (gradient: accentColor -> 30% alpha)
   - AppShadows.medium 적용 (히어로 카드 강조)
   - 라이트 모드: 영역 색상 15% alpha 테두리 추가
   - clipBehavior: Clip.antiAlias 적용 (스트라이프가 borderRadius 내부에 정확히 들어감)

9. **`lib/features/activity/widgets/activity_card.dart`**
   - 좌측 4px 영역별 색상 악센트바 추가
   - IntrinsicHeight + Row(stretch) 패턴으로 악센트바가 카드 전체 높이에 맞춤
   - clipBehavior: Clip.antiAlias 적용

10. **`lib/features/record/widgets/record_summary_card.dart`**
    - 각 기록 행(수유/배변/수면/메모)에 36x36 색상 배경 이모지 아이콘 추가
    - 수유=warmOrange, 배변=softGreen, 수면=domainVision(라벤더), 메모=warmGray
    - 다크 모드: alpha 15%, 라이트 모드: alpha 10%

11. **`lib/features/activity/widgets/activity_filter_chips.dart`**
    - 선택 상태에서 영역별 색상 적용 ("전체"는 warmOrange 유지)
    - selectedColor, checkmarkColor, labelStyle, side 모두 영역별 색상 반영

---

## 변경 영향도

| 변경 사항 | 영향 범위 | 파괴적 변경 |
|---|---|---|
| 영역별 컬러 12색 추가 | app_colors.dart만 | 아님 (추가만) |
| info/infoBg 추가 | app_colors.dart만 | 아님 (추가만) |
| subtle 그림자 추가 | app_shadows.dart만 | 아님 (추가만) |
| low 그림자 강도 변경 | 전체 카드 | 미미함 (시각적 차이만) |
| CardTheme border 추가 | 전체 Card 위젯 | 미미함 (다크 모드는 이미 border 사용) |
| h1 w700 / h3 w500 | 전체 heading | 약간 (시각적 무게감 변화) |
| sectionGap 24->32 | 사용하는 화면 | 약간 (스크롤 길이 증가) |
| ActivityTypeChip 색상 | 활동 관련 화면 전체 | 아님 (기존 API 호환) |

---

## 사양서 기준 자체 점검

- [x] app_colors.dart: 활동 영역별 6색 + 6 배경색 추가
- [x] app_colors.dart: info / infoBg 시맨틱 컬러 추가
- [x] app_shadows.dart: low 그림자 강도 증가
- [x] app_shadows.dart: subtle 레벨 추가
- [x] app_theme.dart: 라이트 모드 CardTheme에 lightBeige 테두리 추가
- [x] app_text_styles.dart: h1 w600->w700, h3 w600->w500
- [x] app_dimensions.dart: sectionGap 24->32
- [x] activity_type_chip.dart: 유형별 색상 자동 매핑
- [x] today_mission_card.dart: 영역별 색상 상단 스트라이프 + medium 그림자
- [x] activity_card.dart: 좌측 영역별 색상 악센트바
- [x] record_summary_card.dart: 기록 유형별 색상 배경 이모지
- [x] activity_filter_chips.dart: 선택 상태 영역별 색상 적용
- [x] home_screen.dart: 섹션 간격 sectionGap(32)으로 통일
- [x] flutter analyze 통과 (에러/경고 0건)
