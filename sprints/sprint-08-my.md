# Sprint 08: 마이 탭 (2개 화면)

## 1. 구현 범위

### 대상 화면/기능

- **MyScreen** (탭 5: 마이 메인) (개발기획서 섹션 5-7)
  - 앱 바: 변형 A (뒤로 가기 없음, 좌측 "마이" 타이틀)
  - **아기 프로필 영역:**
    - 아기 프로필 카드 (2-2-1, 마이 화면 변형): 이름 + 주차 + "태어난 지 N일째" + 우측 끝 "수정 ->" 텍스트 링크 버튼
    - "수정 ->" 탭 시 BabyEditScreen으로 GoRouter push 이동
    - "+ 아기 추가하기" 버튼 (PlaceholderTile -- MVP에서 탭 시 "곧 준비될 기능이에요" 토스트 표시)
  - **알림 설정 섹션 헤더:** "알림 설정"
    - 데일리 활동 알림 SwitchListTile (2-4-8) + "매일 오전 9:00" 서브텍스트 + ON/OFF 토글
    - 기록 리마인더 SwitchListTile (2-4-8) + ON/OFF 토글
    - 주차 전환 알림 SwitchListTile (2-4-8) + ON/OFF 토글
    - 성장 마일스톤 SwitchListTile (2-4-8) + ON/OFF 토글
  - **화면 설정 섹션 헤더:** "화면 설정"
    - 다크 모드 SwitchListTile (2-4-8): 토글 ON 시 themeMode='dark', OFF 시 themeMode='light'
    - 조부모 모드 SwitchListTile (2-4-8): 서브텍스트 "큰 글씨 + 핵심만", 토글 ON 시 isGrandparentMode=true
    - 무음 모드 SwitchListTile (2-4-8): 서브텍스트 "기본 활성화", 기본값 ON
  - **데이터 섹션 헤더:** "데이터"
    - "리포트 내보내기 (PDF)" ListTile -> 탭 시 "곧 준비될 기능이에요" 토스트 (플레이스홀더)
    - "데이터 백업" ListTile -> 탭 시 "곧 준비될 기능이에요" 토스트 (플레이스홀더)
  - **정보 섹션 헤더:** "정보"
    - "앱 정보" ListTile -> GoRouter push -> AppInfoScreen
    - "이용약관" ListTile -> 탭 시 "곧 준비될 기능이에요" 토스트 (플레이스홀더)
    - "개인정보처리방침" ListTile -> 탭 시 "곧 준비될 기능이에요" 토스트 (플레이스홀더)
    - "콘텐츠 출처 안내" ListTile -> 탭 시 면책/출처 다이얼로그 표시
  - **버전 표시:** 화면 최하단 "v1.0.0" (labelSmall, warmGray, 중앙 정렬)
  - 전체 화면: ListView 기반 스크롤 가능 구조

- **BabyEditScreen** (아기 프로필 수정) (개발기획서 섹션 5-7, 화면 5-1)
  - 앱 바: 변형 C (뒤로가기 + "아기 프로필 수정" + 우측 PopupMenuButton)
  - **프로필 사진 영역:**
    - CircleAvatar (직경 80dp) + "사진변경" 텍스트 오버레이
    - 탭 시 BottomSheet: [갤러리에서 선택] [카메라로 촬영] [사진 삭제] (기존 사진 있을 때만)
    - image_picker 패키지 사용 (이미 pubspec.yaml에 등록됨)
    - 선택한 이미지는 앱 문서 디렉토리에 복사하여 경로를 Baby.profileImagePath에 저장
  - **이름 입력:** TextField (2-4-5) -- 기존 이름 pre-fill
  - **생년월일 선택:** CupertinoDatePicker (2-4-3) -- 기존 생년월일 pre-fill, 선택 시 주차 자동 재계산
  - **주차 미리보기:** "현재 주차: 0-1주차" 텍스트 (bodySmall, warmGray)
  - **저장 버튼:** 기본 CTA 버튼 (2-3-1) "저장하기" -- BabyDao.update 호출 -> activeBabyProvider invalidate -> pop
  - **삭제 기능:**
    - PopupMenuButton(우측 상단 "..." 아이콘) 안에 "아기 정보 삭제" 항목 (softRed 텍스트)
    - 탭 시 확인 다이얼로그 (2-6-6): "정말 삭제할까요?" + "삭제하면 모든 기록이 함께 사라져요."
    - 확인 시 BabyDao.delete 호출 -> activeBabyId 초기화 -> /onboarding으로 리다이렉트 (아기가 1명인 경우)

- **AppInfoScreen** (앱 정보) (개발기획서 섹션 5-7, 화면 5-5)
  - 앱 바: 변형 B (뒤로가기 + "앱 정보")
  - 앱 이름: "하루 한 가지" (Display, 28sp)
  - 버전: "버전 1.0.0" (bodySmall)
  - Divider
  - 면책 문구 섹션: AppStrings.disclaimerMain (Body2, darkBrown)
  - 콘텐츠 출처 섹션: AppStrings.disclaimerSource (Body2, darkBrown)
  - 저작권 정보: "(c) 2026 하루 한 가지 All rights reserved." (bodySmall, warmGray)
  - 전체: SingleChildScrollView 기반

### 추가 구현 (인프라 연동)

- **다크 모드 전환:** MyScreen의 다크 모드 토글 -> AppSettingsService.setThemeMode() 호출 -> app.dart에서 이미 themeMode를 ref.watch하므로 즉시 반영
- **조부모 모드 전환:** MyScreen의 조부모 모드 토글 -> AppSettingsService.setGrandparentMode() 호출 -> app.dart에서 이미 grandparentTheme() 적용 로직 있으므로 즉시 반영
- **알림 토글 연동:** 4개 알림 스위치 -> AppSettingsService의 해당 setter 호출 (실제 알림 스케줄링은 MVP 범위 밖, SharedPreferences에만 플래그 저장)
- **면책 조항 다이얼로그:** "콘텐츠 출처 안내" 탭 시 showDialog로 면책 + 출처 정보 표시 (2-6-6 변형)
- **프로필 사진 변경:** image_picker로 사진 선택 -> 앱 문서 디렉토리에 저장 -> Baby.profileImagePath 업데이트

### 사용 디자인 컴포넌트

| 컴포넌트 번호 | 이름 | 사용 위치 |
|---|---|---|
| 2-1-1 | 하단 탭 바 | MyScreen (탭 5 활성) |
| 2-1-2 | 앱 바 (변형 A) | MyScreen |
| 2-1-2 | 앱 바 (변형 B) | AppInfoScreen |
| 2-1-2 | 앱 바 (변형 C) | BabyEditScreen |
| 2-2-1 | 아기 프로필 카드 (마이 변형) | MyScreen (상단 프로필) |
| 2-3-1 | 기본 CTA 버튼 | BabyEditScreen ("저장하기") |
| 2-3-6 | 텍스트 링크 버튼 | MyScreen ("수정 ->") |
| 2-4-3 | 날짜 선택기 | BabyEditScreen (생년월일) |
| 2-4-5 | 텍스트 입력 필드 | BabyEditScreen (이름) |
| 2-4-8 | 스위치 (SwitchListTile) | MyScreen (7개 토글) |
| 2-6-6 | 알림 다이얼로그 | BabyEditScreen (삭제 확인), MyScreen (면책 조항) |

---

## 2. 파일 목록

### 신규 생성 파일

| # | 파일 경로 | 설명 |
|---|---|---|
| 1 | `lib/features/my/screens/my_screen.dart` | 마이 탭 메인 화면 (프로필 + 설정 + 정보) |
| 2 | `lib/features/my/screens/baby_edit_screen.dart` | 아기 프로필 수정 화면 (이름/생년월일/사진/삭제) |
| 3 | `lib/features/my/screens/app_info_screen.dart` | 앱 정보 화면 (면책/출처/저작권) |
| 4 | `lib/features/my/widgets/my_profile_card.dart` | 마이 화면 전용 프로필 카드 (2-2-1 마이 변형, 수정 -> 버튼 포함) |
| 5 | `lib/features/my/widgets/settings_section_header.dart` | 섹션 구분 헤더 위젯 ("알림 설정", "화면 설정", "데이터", "정보") |
| 6 | `lib/features/my/widgets/placeholder_list_tile.dart` | 플레이스홀더 ListTile (탭 시 "곧 준비될 기능이에요" 토스트) |
| 7 | `lib/features/my/widgets/photo_picker_bottom_sheet.dart` | 프로필 사진 선택 BottomSheet (갤러리/카메라/삭제) |
| 8 | `lib/features/my/widgets/disclaimer_dialog.dart` | 면책 조항 + 콘텐츠 출처 다이얼로그 |
| 9 | `lib/features/my/widgets/delete_baby_dialog.dart` | 아기 삭제 확인 다이얼로그 (2-6-6) |

### 수정할 기존 파일

| # | 파일 경로 | 수정 내용 |
|---|---|---|
| 1 | `lib/features/main_shell/main_shell.dart` | 탭 5(마이) 플레이스홀더를 `MyScreen`으로 교체 |
| 2 | `lib/core/router/app_router.dart` | `/my/edit`, `/my/info` 라우트 추가 |
| 3 | `lib/core/constants/app_strings.dart` | 마이 탭 관련 UI 텍스트 상수 약 40개 추가 |
| 4 | `lib/providers/baby_providers.dart` | `allBabiesProvider` 추가 (다자녀 목록 조회, 향후 확장) |

---

## 3. 데이터 모델

### 3-1. 기존 모델/서비스 활용 (신규 테이블 없음)

이 스프린트는 새로운 DB 테이블을 생성하지 않는다. 기존 인프라를 활용한다.

#### Baby 모델 (기존, `lib/data/models/baby.dart`)

```
Baby {
  id: int?
  name: String
  birthDate: DateTime
  profileImagePath: String?
  createdAt: DateTime
  isActive: bool
}
```

- BabyDao.update(): 이름/생년월일/사진 경로 수정
- BabyDao.delete(): 아기 삭제
- BabyDao.getAll(): 다자녀 목록 조회

#### AppSettingsService (기존, `lib/services/app_settings_service.dart`)

이 스프린트에서 사용하는 키:

| 키 | getter | setter | 기본값 | 용도 |
|---|---|---|---|---|
| `themeMode` | `themeMode` (String) | `setThemeMode(String)` | `'system'` | 다크 모드 전환 (`'light'`/`'dark'`/`'system'`) |
| `isGrandparentMode` | `isGrandparentMode` (bool) | `setGrandparentMode(bool)` | `false` | 조부모 모드 ON/OFF |
| `isDailyNotificationOn` | `isDailyNotificationOn` (bool) | `setDailyNotificationOn(bool)` | `true` | 데일리 활동 알림 |
| `dailyNotificationTime` | `dailyNotificationTime` (String) | `setDailyNotificationTime(String)` | `'09:00'` | 알림 시간 |
| `isRecordReminderOn` | `isRecordReminderOn` (bool) | `setRecordReminderOn(bool)` | `true` | 기록 리마인더 |
| `isWeekTransitionOn` | `isWeekTransitionOn` (bool) | `setWeekTransitionOn(bool)` | `true` | 주차 전환 알림 |
| `isMilestoneOn` | `isMilestoneOn` (bool) | `setMilestoneOn(bool)` | `true` | 성장 마일스톤 알림 |
| `isSilentMode` | `isSilentMode` (bool) | `setSilentMode(bool)` | `true` | 무음 모드 |
| `activeBabyId` | `activeBabyId` (int?) | `setActiveBabyId(int?)` | `null` | 현재 활성 아기 ID |

### 3-2. Providers

| Provider 이름 | 유형 | 설명 |
|---|---|---|
| `appSettingsServiceProvider` | Provider (기존) | AppSettingsService 인스턴스 |
| `activeBabyProvider` | FutureProvider (기존) | 현재 활성 아기 |
| `babyDaoProvider` | Provider (기존) | BabyDao 인스턴스 |
| `allBabiesProvider` | FutureProvider (신규) | 모든 아기 목록 (`BabyDao.getAll()`) |

### 3-3. 상태 관리 흐름

```
MyScreen (SwitchListTile 토글)
  -> AppSettingsService.setThemeMode() / setGrandparentMode() / etc.
  -> appSettingsServiceProvider invalidate (ref.invalidate)
  -> app.dart에서 ref.watch(appSettingsServiceProvider) 변경 감지
  -> MaterialApp themeMode / theme 재빌드
  -> 전체 앱에 즉시 반영
```

```
BabyEditScreen (저장하기)
  -> BabyDao.update(updatedBaby)
  -> ref.invalidate(activeBabyProvider)
  -> MyScreen / HomeScreen의 프로필 카드 자동 갱신
```

---

## 4. 검증 기준 (Evaluator용)

각 기준은 PASS/FAIL로 판정 가능합니다.

### 기능 검증 -- MyScreen

- [ ] MainShell 탭 5(마이) 탭 시 MyScreen이 표시되고, 이전 _PlaceholderTab이 제거되었다
- [ ] 화면 상단에 아기 프로필 카드가 표시된다: 아기 이름, 주차 레이블 (예: "0-1주차"), "태어난 지 N일째" 텍스트
- [ ] 프로필 카드 우측 끝에 "수정 ->" 텍스트 링크 버튼이 표시되고, 탭 시 BabyEditScreen으로 이동한다
- [ ] 프로필 이미지가 있으면 CircleAvatar에 이미지가, 없으면 기본 아기 아이콘(Icons.child_care)이 표시된다
- [ ] "+ 아기 추가하기" 영역이 표시되고, 탭 시 "곧 준비될 기능이에요" 토스트가 나타난다
- [ ] "알림 설정" 섹션에 4개의 SwitchListTile이 표시된다: 데일리 활동 알림, 기록 리마인더, 주차 전환 알림, 성장 마일스톤
- [ ] 데일리 활동 알림 토글 아래에 "매일 오전 9:00" 서브텍스트가 표시된다
- [ ] 각 알림 SwitchListTile 토글 시 AppSettingsService의 해당 setter가 호출되고, 토글 상태가 즉시 반영된다
- [ ] "화면 설정" 섹션에 3개의 SwitchListTile이 표시된다: 다크 모드, 조부모 모드, 무음 모드
- [ ] 다크 모드 토글 ON 시 앱 전체가 다크 테마(darkBg #1A1512, darkCard #2A231D 등)로 즉시 전환된다
- [ ] 다크 모드 토글 OFF 시 앱 전체가 라이트 테마(cream #FFF8F0 등)로 즉시 복귀한다
- [ ] 조부모 모드 토글 ON 시 앱 전체 텍스트 크기가 +4sp 증가한다 (grandparentTheme 적용)
- [ ] 조부모 모드 토글 OFF 시 텍스트 크기가 원래대로 복귀한다
- [ ] 조부모 모드 서브텍스트에 "큰 글씨 + 핵심만" 설명이 표시된다
- [ ] 무음 모드의 기본값이 ON이다
- [ ] "데이터" 섹션에 "리포트 내보내기 (PDF)"와 "데이터 백업" 2개 ListTile이 표시된다
- [ ] "리포트 내보내기 (PDF)" 및 "데이터 백업" 탭 시 "곧 준비될 기능이에요" 토스트가 나타난다
- [ ] "정보" 섹션에 4개 ListTile이 표시된다: 앱 정보, 이용약관, 개인정보처리방침, 콘텐츠 출처 안내
- [ ] "앱 정보" 탭 시 AppInfoScreen으로 GoRouter push 이동한다
- [ ] "이용약관", "개인정보처리방침" 탭 시 "곧 준비될 기능이에요" 토스트가 나타난다
- [ ] "콘텐츠 출처 안내" 탭 시 면책 조항 + 콘텐츠 출처가 포함된 다이얼로그가 표시된다
- [ ] 화면 최하단에 "v1.0.0" 버전 텍스트가 중앙 정렬로 표시된다
- [ ] 화면 전체가 ListView로 스크롤 가능하다
- [ ] 앱을 종료 후 재실행해도 다크 모드/조부모 모드/알림 설정 상태가 SharedPreferences에서 복원된다

### 기능 검증 -- BabyEditScreen

- [ ] 앱 바에 "아기 프로필 수정" 타이틀과 뒤로가기 버튼이 표시된다
- [ ] 앱 바 우측에 PopupMenuButton("..." 아이콘)이 있다
- [ ] 프로필 사진 영역: CircleAvatar(직경 80dp)에 현재 프로필 이미지 또는 기본 아이콘이 표시된다
- [ ] 사진 영역 하단에 "사진변경" 텍스트가 표시되고, 전체 영역 탭 시 BottomSheet가 열린다
- [ ] BottomSheet에 "갤러리에서 선택", "카메라로 촬영" 옵션이 표시된다
- [ ] 기존 프로필 사진이 있을 때 BottomSheet에 "사진 삭제" 옵션이 추가로 표시된다
- [ ] 갤러리에서 이미지 선택 시 CircleAvatar에 선택한 이미지가 즉시 미리보기로 표시된다
- [ ] 아기 이름 TextField에 기존 이름이 pre-fill 되어 있다
- [ ] 생년월일 필드에 기존 생년월일이 표시되어 있고, 탭 시 CupertinoDatePicker가 열린다
- [ ] 생년월일 변경 시 "현재 주차: X-Y주차" 텍스트가 즉시 재계산되어 표시된다
- [ ] "저장하기" 버튼 탭 시 BabyDao.update()가 호출되고, activeBabyProvider가 invalidate되며, 이전 화면(MyScreen)으로 pop된다
- [ ] MyScreen으로 복귀 후 프로필 카드에 수정된 정보가 반영되어 있다
- [ ] PopupMenuButton 탭 시 "아기 정보 삭제" 메뉴 항목이 softRed(#FF6B6B) 텍스트로 표시된다
- [ ] "아기 정보 삭제" 탭 시 확인 다이얼로그가 표시된다: 제목 "정말 삭제할까요?", 본문 "삭제하면 모든 기록이 함께 사라져요."
- [ ] 다이얼로그에서 "취소" 탭 시 다이얼로그가 닫히고 아무 동작 없다
- [ ] 다이얼로그에서 "삭제" 탭 시 BabyDao.delete()가 호출되고 온보딩 화면(/onboarding)으로 이동한다
- [ ] 이름 필드가 비어있는 상태에서 "저장하기" 탭 시 저장되지 않고 필드에 오류 표시가 나타난다

### 기능 검증 -- AppInfoScreen

- [ ] 앱 바에 "앱 정보" 타이틀과 뒤로가기 버튼이 표시된다
- [ ] 화면에 "하루 한 가지" 앱 이름이 Display 스타일(28sp)로 표시된다
- [ ] 앱 이름 아래 "버전 1.0.0"이 bodySmall 스타일로 표시된다
- [ ] 면책 문구 섹션에 AppStrings.disclaimerMain 텍스트가 표시된다
- [ ] 콘텐츠 출처 섹션에 AppStrings.disclaimerSource 텍스트가 표시된다
- [ ] 저작권 정보 "(c) 2026 하루 한 가지 All rights reserved."가 bodySmall 스타일로 표시된다
- [ ] 화면이 SingleChildScrollView로 스크롤 가능하다

### UX 원칙 검증

- [ ] **"하나만 해도 충분하다" 원칙:** 마이 화면은 설정 기능 목적이므로 과도한 정보 노출 없이 섹션별로 구분되어 있다. 각 섹션은 명확한 제목을 가진다
- [ ] **숫자보다 말로 안심시키는지:** 주차 표시는 "0-1주차"처럼 기간으로, "태어난 지 N일째"처럼 친근한 표현으로 표시한다
- [ ] **전문 용어 대신 부모 언어 사용 여부:** "테마 모드" 대신 "다크 모드", "알림 퍼미션" 대신 "알림 설정", "폰트 사이즈 증가" 대신 "큰 글씨 + 핵심만" 등 부모가 이해할 수 있는 언어 사용
- [ ] **한 손 30초 완료 가능 여부:** 다크 모드 전환은 토글 1번 탭으로 즉시 완료, 조부모 모드 전환은 토글 1번 탭으로 즉시 완료
- [ ] **죄책감 유발 요소 없음:** 알림을 OFF로 설정해도 부정적 메시지("알림을 끄면 놓칠 수 있어요" 등) 없음, 기록 수/빈도 같은 압박 정보 없음

### 디자인 검증

- [ ] **컬러 팔레트 일치:** Scaffold 배경 cream(#FFF8F0), 카드 배경 white(#FFFFFF), 포인트 warmOrange(#F5A623), 텍스트 darkBrown(#3D3027), 서브텍스트 warmGray(#8C7B6B)
- [ ] **타이포그래피 스케일 일치:** 모든 텍스트가 `Theme.of(context).textTheme`에서 가져온 스타일을 사용하며 하드코딩된 fontSize가 없다
- [ ] **2-2-1 아기 프로필 카드 스펙 일치:** CircleAvatar 직경 40dp, 카드 패딩 12dp, 모서리 12dp, 이름 H3(16sp SemiBold), 주차 Caption(13sp warmGray), 마이 변형 우측 "수정 ->" (ButtonSmall 14sp warmOrange)
- [ ] **2-4-8 스위치 스펙 일치:** 리스트 아이템 높이 최소 48dp, ON 트랙 warmOrange(#F5A623), OFF 트랙 mutedBeige(#C4B5A5), 레이블 Body1(15sp), 보조 설명 Caption(12sp warmGray)
- [ ] **2-3-6 텍스트 링크 버튼 스펙 일치:** ButtonSmall(14sp, Medium, warmOrange), 패딩 최소 8dp, InkWell 48dp 높이
- [ ] **2-6-6 알림 다이얼로그 스펙 일치:** 모서리 16dp, 패딩 24dp, 제목 H3(16sp Bold), "취소" warmGray, "삭제" softRed(#FF6B6B Bold)
- [ ] **다크 모드 대응:** 모든 화면이 다크 모드에서 정상 표시 -- darkBg(#1A1512), darkCard(#2A231D), 텍스트 darkTextPrimary(#F5EDE3), 스위치 OFF 트랙 darkBorder(#3D3027)
- [ ] **조부모 모드 대응:** 조부모 모드 ON 시 모든 텍스트가 +4sp 증가된 상태로 표시, 레이아웃 깨짐이 없다

### 접근성 검증

- [ ] **최소 터치 영역 48x48dp:** 모든 SwitchListTile, ListTile, 버튼, 텍스트 링크의 터치 영역이 48x48dp 이상이다
- [ ] **무음 모드 동작 (햅틱 피드백):** 스위치 토글 시 HapticFeedback.lightImpact()가 실행된다 (무음 모드이므로 소리 대신 진동)
- [ ] **빈 상태(empty state) 처리:** 아기가 등록되지 않은 상태에서 MyScreen 진입 시 프로필 카드에 "아기를 등록해주세요" 텍스트가 표시되고 "수정 ->" 대신 적절한 안내가 표시된다
- [ ] **ValueKey 지정:** 모든 주요 위젯에 ValueKey가 지정되어 있다 -- `my_screen`, `my_profile_card`, `my_edit_button`, `baby_edit_screen`, `app_info_screen`, `dark_mode_switch`, `grandparent_mode_switch`, `silent_mode_switch`, `daily_notification_switch`, `record_reminder_switch`, `week_transition_switch`, `milestone_switch`, `save_baby_button`, `delete_baby_menu`, `photo_change_area`, `version_text`

### 라우팅 검증

- [ ] GoRouter에 `/my/edit` 라우트가 등록되어 있고, BabyEditScreen이 빌드된다
- [ ] GoRouter에 `/my/info` 라우트가 등록되어 있고, AppInfoScreen이 빌드된다
- [ ] BabyEditScreen에서 뒤로가기(AppBar leading 또는 시스템 백 버튼) 시 MyScreen으로 복귀한다
- [ ] AppInfoScreen에서 뒤로가기 시 MyScreen으로 복귀한다
- [ ] 아기 삭제 후 GoRouter.go('/onboarding')으로 온보딩 화면 이동이 정상 동작한다

### 코드 품질 검증

- [ ] 모든 UI 텍스트가 AppStrings 상수를 참조하며 하드코딩된 한국어 문자열이 없다
- [ ] 모든 색상이 AppColors 또는 Theme에서 가져오며 하드코딩된 Color 값이 없다
- [ ] 모든 텍스트 스타일이 `Theme.of(context).textTheme`에서 가져오며 하드코딩된 TextStyle이 없다
- [ ] AppSettingsService의 값 변경 후 `ref.invalidate(appSettingsServiceProvider)`를 호출하여 UI가 즉시 갱신된다
- [ ] ConsumerWidget 또는 ConsumerStatefulWidget을 사용하여 Riverpod ref 접근이 올바르게 이루어진다
- [ ] image_picker 사용 시 예외 처리(권한 거부, 사진 선택 취소 등)가 구현되어 있다

---

## 5. 의존성

### 이전 스프린트 의존

| 스프린트 | 필요 산출물 |
|---|---|
| Sprint 01 (Setup) | 프로젝트 구조, AppColors, AppTextStyles, AppRadius, AppDimensions, AppShadows, AppStrings, lightTheme/darkTheme, grandparentTheme |
| Sprint 02 (Onboarding) | Baby 모델, BabyDao, AppSettingsService, activeBabyProvider, babyDaoProvider, appSettingsServiceProvider, GoRouter 기본 구조, image_picker 연동 패턴 |
| Sprint 03 (Home) | BabyProfileCard (참조용, 마이 변형은 별도 생성), MainShell |

### 필요한 패키지 (이미 설치됨)

| 패키지 | 버전 | 용도 |
|---|---|---|
| `flutter_riverpod` | ^3.3.1 | 상태 관리 |
| `go_router` | ^17.1.0 | 라우팅 |
| `shared_preferences` | ^2.5.5 | AppSettingsService |
| `image_picker` | ^1.1.2 | 프로필 사진 변경 |
| `sqflite` | ^2.4.2 | BabyDao 사용 |
| `path_provider` | (확인 필요) | 프로필 이미지 로컬 저장 경로. 없으면 추가 필요 |

### 추가 패키지 (필요 시)

| 패키지 | 용도 |
|---|---|
| `path_provider` | 앱 문서 디렉토리 경로 조회 (프로필 이미지 저장용). pubspec.yaml에 없으면 추가해야 한다 |

---

## 6. 구현 순서 가이드 (Generator용 참고)

1. **AppStrings 확장** -- 마이 탭 관련 모든 UI 텍스트 상수 추가
2. **baby_providers.dart 확장** -- `allBabiesProvider` 추가
3. **위젯 생성** -- settings_section_header, placeholder_list_tile, my_profile_card, photo_picker_bottom_sheet, disclaimer_dialog, delete_baby_dialog
4. **MyScreen 생성** -- ListView + 프로필 카드 + 4개 섹션 (알림/화면/데이터/정보) + 버전 텍스트
5. **BabyEditScreen 생성** -- 프로필 사진 + 이름 + 생년월일 + 저장 + 삭제
6. **AppInfoScreen 생성** -- 면책/출처/저작권
7. **GoRouter 라우트 추가** -- `/my/edit`, `/my/info`
8. **MainShell 수정** -- 탭 5 플레이스홀더를 MyScreen으로 교체
9. **다크 모드 / 조부모 모드 연동 확인** -- app.dart의 기존 로직과 정상 연동되는지 확인
