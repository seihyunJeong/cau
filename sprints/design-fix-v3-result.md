# Design Fix v3 결과: 기록 탭 6.75 -> PASS 목표

## 수정 대상

기록 탭 디자인 점수 6.75 (FAIL, 기준 7.0)

## 수정된 파일

- `lib/features/record/widgets/counter_card.dart` -- 비활성 버튼 가시성 강화 + 카드 레이아웃 재구성
- `lib/features/record/screens/record_main_screen.dart` -- 수유/배변 카드에 구분 색상(accentColor) 적용

## 수정 내용

### FAIL-1 해결: 비활성 카운터 버튼(-) 시각적 존재감 강화

**이전:** `isDisabled` 상태에서 배경 opacity 0.3, 테두리 opacity 0.3, 아이콘은 mutedBeige 단색. 버튼이 거의 보이지 않아 빈 공간으로 오인될 수 있었음.

**수정:**
- 배경 opacity: 0.3 -> **0.5** (50%)
- 테두리 opacity: 0.3 -> **0.6** (60%)
- 아이콘 색상: mutedBeige -> **warmGray** (opacity 0.6) -- 더 진한 회색으로 버튼 존재감 유지
- 다크 모드에서도 동일한 비율로 opacity 적용

이제 비활성 상태의 `-` 버튼이 "비활성이지만 존재하는 버튼"으로 명확히 인식됨.

### FAIL-2 해결: 카운터 카드 간 시각적 리듬 개선

**이전:** 수유/배변 카드가 동일한 구조(emoji + label + counter)로 수직 반복 -> 시각적 단조로움.

**수정:**
1. **좌측 악센트 바 추가 (4dp 폭):**
   - 수유 카드: warmOrange 악센트 바
   - 배변 카드: softGreen 악센트 바
   - 각 카드의 정체성이 색상으로 즉시 구분됨

2. **이모지 영역 분리 (48x48dp 배경 박스):**
   - 이모지를 accent 색상의 tinted 배경(10% opacity) 박스 안에 배치
   - 시각적 focal point 역할 + 카드 간 차별화

3. **레이아웃 변경 (수직 -> 수평 구성):**
   - 이전: 수직 중앙 정렬 (이모지+레이블 -> 카운터)
   - 변경: 수평 배치 (좌측 이모지 박스 | 우측 레이블+카운터)
   - 카드 내부 공간을 더 효율적으로 사용하고 시각적 흥미 추가

4. **`accentColor` 파라미터 추가:**
   - CounterCard에 optional `accentColor` 파라미터 신설
   - 기본값은 warmOrange (하위 호환성 유지)
   - record_main_screen에서 수유=warmOrange, 배변=softGreen으로 지정

## 빌드 검증

- `flutter analyze`: 0 errors, 0 warnings (info 11개, 이전과 동일)
- 기존 기능(+/- 카운터, 햅틱, scale 애니메이션, 30회 경고 토스트, 저장됨 토스트) 모두 유지

## 자체 점검

- [x] 비활성 `-` 버튼이 시각적으로 "버튼"으로 인식됨 (opacity 50%+ 배경 + 60% 테두리)
- [x] 수유/배변 카드가 색상(warmOrange vs softGreen)으로 시각적으로 구분됨
- [x] 좌측 악센트 바로 카드 간 리듬감 형성
- [x] 이모지가 tinted 배경 박스 안에 배치되어 시각적 focal point 역할
- [x] 다크 모드 대응: isDark 조건부 처리 유지 (accent bar, 이모지 배경, 비활성 버튼 모두)
- [x] 최소 터치 영역 48x48dp 유지
- [x] AnimatedContainer 상태 전환 유지
- [x] 빌드 오류 없음
