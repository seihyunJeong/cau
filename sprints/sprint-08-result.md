# Sprint 08 구현 결과

## 생성된 파일

### 신규 생성 (9개)
- `lib/features/my/screens/my_screen.dart` -- 마이 탭 메인 화면 (프로필 + 4개 설정 섹션 + 버전)
- `lib/features/my/screens/baby_edit_screen.dart` -- 아기 프로필 수정 화면 (이름/생년월일/사진/삭제)
- `lib/features/my/screens/app_info_screen.dart` -- 앱 정보 화면 (면책/출처/저작권)
- `lib/features/my/widgets/my_profile_card.dart` -- 마이 화면 전용 프로필 카드 (2-2-1 마이 변형)
- `lib/features/my/widgets/settings_section_header.dart` -- 섹션 구분 헤더 위젯
- `lib/features/my/widgets/placeholder_list_tile.dart` -- 플레이스홀더 ListTile (미구현 기능용)
- `lib/features/my/widgets/photo_picker_bottom_sheet.dart` -- 프로필 사진 선택 BottomSheet
- `lib/features/my/widgets/disclaimer_dialog.dart` -- 면책 조항 + 콘텐츠 출처 다이얼로그
- `lib/features/my/widgets/delete_baby_dialog.dart` -- 아기 삭제 확인 다이얼로그

### 수정된 기존 파일 (4개)
- `lib/features/main_shell/main_shell.dart` -- 탭 5(마이) _PlaceholderTab을 MyScreen으로 교체, _PlaceholderTab 클래스 제거
- `lib/core/router/app_router.dart` -- `/my/edit`, `/my/info` 라우트 추가, AppInfoScreen/BabyEditScreen import
- `lib/core/constants/app_strings.dart` -- 마이 탭 관련 UI 텍스트 상수 약 40개 추가
- `lib/providers/baby_providers.dart` -- `allBabiesProvider` 추가

## 구현 메모

### 기술적 결정
- **Baby.copyWith의 null 처리 한계:** Baby 모델의 copyWith는 null 매개변수를 기존 값으로 대체하는 패턴이므로, 프로필 사진 삭제(null로 설정) 시 copyWith 대신 Baby 생성자를 직접 사용하여 profileImagePath: null을 명시적으로 전달한다.
- **AppSettingsService 재사용:** 다크 모드/조부모 모드/알림 토글은 모두 기존 AppSettingsService의 getter/setter를 활용하며, 변경 후 ref.invalidate(appSettingsServiceProvider)를 호출하여 app.dart의 ref.watch가 변경을 감지하고 테마를 즉시 재빌드한다.
- **프로필 이미지 저장:** image_picker로 선택한 이미지를 path_provider의 앱 문서 디렉토리에 복사 후 해당 경로를 Baby.profileImagePath에 저장한다. 앱 삭제 시 자동 정리된다.
- **SwitchListTile 스타일:** Flutter 3.31+ 이후 activeColor가 deprecated되었으므로 activeThumbColor를 사용한다. ON 상태: white 썸 + warmOrange 트랙, OFF 상태: white 썸 + mutedBeige(라이트)/darkBorder(다크) 트랙.
- **asyncValue.value 사용:** flutter_riverpod ^3.3.1에서 valueOrNull이 없으므로 .value를 사용. 이는 loading/error 상태에서 null을 반환한다.

### 상태 관리 흐름
```
다크 모드 토글 -> AppSettingsService.setThemeMode('dark'/'light')
  -> ref.invalidate(appSettingsServiceProvider)
  -> app.dart에서 ref.watch(appSettingsServiceProvider) 변경 감지
  -> MaterialApp.router의 themeMode 재빌드 -> 즉시 전체 앱 반영

조부모 모드 토글 -> AppSettingsService.setGrandparentMode(bool)
  -> ref.invalidate(appSettingsServiceProvider)
  -> app.dart에서 grandparentTheme(base) 적용/해제 -> 텍스트 +4sp 즉시 반영
```

## 사양서 기준 자체 점검

### 기능 검증 -- MyScreen
- [x] MainShell 탭 5(마이) 탭 시 MyScreen이 표시되고, 이전 _PlaceholderTab이 제거되었다
- [x] 화면 상단에 아기 프로필 카드가 표시된다: 아기 이름, 주차 레이블, "태어난 지 N일째" 텍스트
- [x] 프로필 카드 우측 끝에 "수정 ->" 텍스트 링크 버튼이 표시되고, 탭 시 BabyEditScreen으로 이동한다
- [x] 프로필 이미지가 있으면 CircleAvatar에 이미지가, 없으면 기본 아기 아이콘이 표시된다
- [x] "+ 아기 추가하기" 영역이 표시되고, 탭 시 "곧 준비될 기능이에요" 토스트가 나타난다
- [x] "알림 설정" 섹션에 4개의 SwitchListTile이 표시된다
- [x] 데일리 활동 알림 토글 아래에 "매일 오전 9:00" 서브텍스트가 표시된다
- [x] 각 알림 SwitchListTile 토글 시 AppSettingsService setter 호출, 상태 즉시 반영
- [x] "화면 설정" 섹션에 3개의 SwitchListTile이 표시된다
- [x] 다크 모드 토글 ON/OFF 시 앱 전체 테마 즉시 전환
- [x] 조부모 모드 토글 ON/OFF 시 텍스트 크기 +4sp 즉시 적용/복귀
- [x] 조부모 모드 서브텍스트에 "큰 글씨 + 핵심만" 표시
- [x] 무음 모드 기본값 ON
- [x] "데이터" 섹션에 2개 PlaceholderListTile
- [x] "정보" 섹션에 4개 ListTile (앱 정보, 이용약관, 개인정보처리방침, 콘텐츠 출처 안내)
- [x] "앱 정보" 탭 시 GoRouter push /my/info
- [x] "이용약관", "개인정보처리방침" 탭 시 "곧 준비될 기능이에요" 토스트
- [x] "콘텐츠 출처 안내" 탭 시 면책 + 출처 다이얼로그 표시
- [x] 화면 최하단 "v1.0.0" 중앙 정렬
- [x] ListView 기반 스크롤 가능
- [x] SharedPreferences 기반 설정 복원

### 기능 검증 -- BabyEditScreen
- [x] 앱 바에 "아기 프로필 수정" 타이틀 + 뒤로가기 버튼
- [x] 앱 바 우측 PopupMenuButton ("..." 아이콘)
- [x] CircleAvatar(직경 80dp = radius 40) 프로필 이미지 또는 기본 아이콘
- [x] "사진변경" 텍스트, 전체 영역 탭 시 BottomSheet
- [x] BottomSheet: "갤러리에서 선택", "카메라로 촬영" 옵션
- [x] 기존 사진 있을 때 "사진 삭제" 옵션 추가
- [x] 갤러리 선택 시 CircleAvatar 즉시 미리보기
- [x] 이름 TextField 기존 이름 pre-fill
- [x] 생년월일 기존 값 표시, 탭 시 CupertinoDatePicker
- [x] 생년월일 변경 시 주차 텍스트 즉시 재계산
- [x] "저장하기" 탭 시 BabyDao.update() + activeBabyProvider invalidate + pop
- [x] PopupMenuButton -> "아기 정보 삭제" softRed 텍스트
- [x] 삭제 확인 다이얼로그 표시
- [x] "취소" 시 다이얼로그 닫힘
- [x] "삭제" 시 BabyDao.delete() + /onboarding 이동
- [x] 이름 필드 비어있으면 저장되지 않고 오류 표시

### 기능 검증 -- AppInfoScreen
- [x] 앱 바에 "앱 정보" + 뒤로가기
- [x] "하루 한 가지" Display 스타일
- [x] "버전 1.0.0" bodySmall 스타일
- [x] AppStrings.disclaimerMain 표시
- [x] AppStrings.disclaimerSource 표시
- [x] 저작권 정보 표시
- [x] SingleChildScrollView 기반

### UX 원칙 검증
- [x] 섹션별 구분으로 과도한 정보 노출 방지
- [x] 주차 표시: "0-1주차", "태어난 지 N일째" 등 친근한 표현
- [x] "다크 모드", "큰 글씨 + 핵심만" 등 부모 언어 사용
- [x] 토글 1번 탭으로 즉시 완료
- [x] 알림 OFF 시 부정적 메시지 없음

### 디자인 검증
- [x] Theme 기반 색상 (AppColors 상수 + theme.cardColor, theme.dividerColor 등)
- [x] Theme.of(context).textTheme 기반 타이포그래피 (하드코딩 fontSize 없음)
- [x] 프로필 카드: CircleAvatar radius 20, 패딩 cardPaddingCompact(12), 모서리 AppRadius.md(12)
- [x] SwitchListTile: warmOrange 트랙, mutedBeige OFF, contentPadding 적용
- [x] 텍스트 링크: labelMedium(warmOrange), minTouchTarget 48dp
- [x] 다이얼로그: 모서리 AppRadius.lg(16), 패딩 AppDimensions.lg(24)
- [x] 다크 모드 대응: isDark 분기 처리
- [x] 조부모 모드: grandparentTheme(base) 연동

### 접근성 검증
- [x] 최소 터치 영역 48x48dp (minTouchTarget, SwitchListTile, ListTile)
- [x] 햅틱 피드백 (HapticFeedback.lightImpact)
- [x] 빈 상태: baby == null 시 "아기를 등록해주세요" 표시
- [x] ValueKey 지정: my_screen, my_profile_card, my_edit_button, baby_edit_screen, app_info_screen, dark_mode_switch, grandparent_mode_switch, silent_mode_switch, daily_notification_switch, record_reminder_switch, week_transition_switch, milestone_switch, save_baby_button, delete_baby_menu, photo_change_area, version_text

### 라우팅 검증
- [x] GoRouter /my/edit -> BabyEditScreen
- [x] GoRouter /my/info -> AppInfoScreen
- [x] BabyEditScreen 뒤로가기 -> MyScreen 복귀 (context.pop)
- [x] AppInfoScreen 뒤로가기 -> MyScreen 복귀 (Navigator.pop)
- [x] 아기 삭제 후 context.go('/onboarding')

### 코드 품질 검증
- [x] 모든 UI 텍스트 AppStrings 상수 참조 (한국어 하드코딩 없음)
- [x] 모든 색상 AppColors 또는 Theme 기반 (하드코딩 Color 없음)
- [x] 모든 텍스트 스타일 Theme.of(context).textTheme (하드코딩 TextStyle 없음)
- [x] ref.invalidate(appSettingsServiceProvider) 호출로 UI 즉시 갱신
- [x] ConsumerStatefulWidget/ConsumerWidget 사용
- [x] image_picker 예외 처리 구현 (try-catch)
- [x] 스페이싱 AppDimensions, 모서리 AppRadius 사용 (EdgeInsets/fontSize/BorderRadius 하드코딩 없음)

### flutter analyze 결과
- 0 errors, 0 warnings (info-level만 10개, 모두 pre-existing)
