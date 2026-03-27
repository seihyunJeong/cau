/// 앱 전체 한국어 문자열 상수.
/// 개발기획서 1-3, 1-4 기준. 용어 통일 가이드를 준수한다.
/// 모든 UI 텍스트는 이 상수를 참조하며 하드코딩 금지.
abstract class AppStrings {
  // ── 앱 이름 ──
  static const appName = '하루 한 가지';

  // ── 탭 이름 (용어 통일: 기획 용어 -> 앱 표현) ──
  static const home = '홈';
  static const record = '기록';
  static const activity = '활동';
  static const devCheck = '발달';
  static const my = '마이';

  // ── 버튼 텍스트 ──
  static const startActivity = '시작하기';
  static const recordComplete = '기록 완료';
  static const viewResult = '결과 보기';

  // ── 기능명 문자열 ──
  static const observationTitle = '오늘 아기는 어땠나요?';
  static const checklistTitle = '이번 주 발달 살펴보기';
  static const resultTitle = '오늘의 관찰 결과';
  static const dangerSignTitle = '함께 살펴볼 점';
  static const solutionTitle = '이렇게 해보세요';

  // ── 상태 메시지 (죄책감 유발 요소 없음) ──
  static const notRecorded = '언제든 기록할 수 있어요';
  static const welcomeBack = '다시 오셨네요. 오늘부터 편하게 시작해요.';

  // ── 면책 문구 ──
  static const disclaimerMain =
      '본 관찰표는 표준화 검사가 아닌 부모 관찰 기록용 구조입니다. '
      '의학적 진단을 대체하지 않습니다.';
  static const disclaimerSource =
      '본 콘텐츠는 NBAS, Bayley-4, ASQ-3 등을 참고하여 '
      '전문가가 설계하였습니다.';
  static const disclaimerDangerSign =
      '걱정이 되시면, 다음 소아과 방문 시 이 기록을 보여주세요. '
      '이 앱은 의료 조언을 제공하지 않습니다.';
  static const disclaimerShort =
      '관찰 기록용 도구이며 의학적 진단을 대체하지 않습니다';

  // ── 빈 상태 (empty state) 메시지 ──
  static const emptyObservation =
      '아직 관찰 기록이 없어요.\n처음이라 괜찮아요!\n준비되면 발달 탭에서 살펴보세요.';
  static const emptyRecord =
      '아직 기록이 없어요.\n기록 탭에서 첫 기록을 시작해보세요.';
  static const emptyGrowth = '아직 성장 기록이 없어요';

  // ── 오늘의 활동 관련 ──
  static const todayActivity = '오늘의 활동';
  static const noActivityToday = '오늘의 활동이 아직 없어요';
  static const expertDesigned = '전문가가 설계한 활동이에요';

  // ── 온보딩: 화면 A (웰컴) ──
  static const welcomeTagline1 = '오늘 하나만 해도 충분해요';
  static const welcomeTagline2 = '전문가가 설계한 우리 아이';
  static const welcomeTagline3 = '맞춤 발달 가이드';
  static const startButton = '시작하기';

  // ── 온보딩: 화면 B (아기 등록) ──
  static const babyRegisterTitle = '아기 등록';
  static const babyNameLabel = '아기 이름 *';
  static const babyNameHint = '예) 하루';
  static const birthDateLabel = '생년월일 *';
  static const birthDateHint = '생년월일을 선택해주세요';
  static const profilePhotoLabel = '프로필 사진';
  static const profilePhotoHint = '사진 추가';
  static const registerButton = '등록하기';
  static const weekPreviewPrefix = '우리 아기는 지금 ';
  static const weekPreviewSuffix = '차예요!';
  static const selectFromGallery = '갤러리에서 선택';
  static const takePhoto = '카메라로 촬영';

  // ── 온보딩: 화면 C (주차 소개) ──
  static const introGreetingSuffix = '아, 반가워!';
  static const introCtaMessage = '오늘부터 하루 한 가지, 함께 시작해볼까요?';
  static const introNextButton = '다음';

  // ── 온보딩: 화면 D (알림 권한) ──
  static const notificationTitle = '아기에게 맞는 활동 시간을\n알려드릴까요?';
  static const notificationBenefit1 = '매일 오늘의 활동을 알려드려요';
  static const notificationBenefit2 = '주차가 바뀌면 새로운 활동을 안내해요';
  static const notificationBenefit3 = '아기의 성장 기념일을 함께 축하해요';
  static const notificationAllowButton = '알림 받기';
  static const notificationSkipButton = '나중에 설정할게요';

  // ── 날짜 선택기 ──
  static const datePickerConfirm = '확인';

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

  // ── 아기 프로필 카드 ──
  static const emptyBabyProfile = '아기를 등록해주세요';
  static const bornToday = '오늘 태어났어요';
  static String daysSinceBirth(int days) => '태어난 지 $days일째';

  // ── 관찰 요약 카드 ──
  static const observationReassurance = '잘 관찰하고 계시네요';
  static const radarLabelBody = '몸 움직임';
  static const radarLabelSensory = '감각 반응';
  static const radarLabelFocus = '집중과 관심';
  static const radarLabelSound = '소리와 표현';
  static const radarLabelHeart = '마음과 관계';
  static const radarLabelRhythm = '생활 리듬';
  static const radarLabels = [
    radarLabelBody,
    radarLabelSensory,
    radarLabelFocus,
    radarLabelSound,
    radarLabelHeart,
    radarLabelRhythm,
  ];

  // ── 성장 요약 카드 (체중/키 레이블) ──
  static const weightLabel = '체중';
  static const heightLabel = '키';
  static String weightValue(String kg) => '체중 ${kg}kg';
  static String heightValue(String cm) => '키 ${cm}cm';

  // ── 기록 탭 ──
  static const recordTitle = '기록';
  static const recordSubtitle = '우리 아이 하루 기록';
  static const feedingLabel = '수유';
  static const diaperLabel = '배변';
  static const sleepLabel = '수면';
  static const sleepPlaceholder = '탭해서 입력';
  static String sleepValue(int hours, int minutes) => '${hours}시간 ${minutes}분';
  static const growthAddLabel = '성장 기록 추가하기 +';
  static String growthTodayCompact(String weight, String height) =>
      '오늘 측정: ${weight}kg, ${height}cm';
  static const weightUnit = 'kg';
  static const heightUnit = 'cm';
  static const headCircumUnit = 'cm';
  static const memoLabel = '오늘의 메모 (선택)';
  static const memoPlaceholder = '오늘 아기의 특별한 순간을 기록해보세요';
  static const growthChartButton = '성장곡선 보기';
  static const recordHistoryButton = '기록 히스토리';
  static const autoSaveNotice = '모든 입력은 자동 저장됩니다';
  static const today = '오늘';
  static const countSuffix = '회';
  static const counterWarning = '정말 맞나요? 한 번 확인해 주세요';
  static const savedInline = '\u2713 저장됨';

  // ── 성장 곡선 ──
  static const growthChartTitle = '성장 곡선';
  static const growthReassuranceChart = '정상 범위 안에서 잘 자라고 있어요';
  static const growthEmptyChart = '기록이 쌓이면 성장 곡선을 보여드릴게요';
  static const growthTabWeight = '체중';
  static const growthTabHeight = '키';
  static const growthTabHead = '머리둘레';
  static const growthLabelLow = '낮은 편';
  static const growthLabelNormal = '보통';
  static const growthLabelHigh = '높은 편';
  static const growthLegendBaby = '우리 아기 측정값';
  static const growthLegendStandard = '표준 범위';
  static const growthRecentTitle = '최근 기록';
  static const growthIncreased = '늘었어요';
  static const growthSame = '비슷해요';
  static const growthWeightLabel = '체중';
  static const growthHeightLabel = '키';
  static const growthHeadLabel = '머리둘레';

  // ── 기록 히스토리 ──
  static const recordHistoryTitle = '기록 히스토리';
  static const recordHistoryEmpty =
      '아직 기록이 없어요.\n기록 탭에서 첫 기록을 시작해보세요.';

  // ── 활동 탭 ──
  static const activityTitle = '활동';
  static const activityReassurance = '하루 한 가지씩 실천해 보세요!';
  static const activitySubReassurance = '전부 하지 않아도 괜찮아요.';
  static const todayRecommend = '오늘의 추천';
  static const activityHistory = '히스토리';
  static const activityFilterAll = '전체';
  static const activityFilterHolding = '안기';
  static const activityFilterSensory = '감각';
  static const activityFilterSound = '소리';
  static const activityFilterVisual = '시각';
  static const activityFilterTypes = [
    activityFilterAll,
    activityFilterHolding,
    activityFilterSensory,
    activityFilterSound,
    activityFilterVisual,
  ];
  static const activityEmptyWeek =
      '이 주차에는 아직 활동이 없어요.\n곧 준비될 거예요.';
  static const activityEmptyFilter =
      '해당 유형의 활동이 없어요.';
  static String recommendedDuration(int seconds) => '권장 $seconds초';

  // ── 활동 상세 ──
  static const activityDetailTitle = '활동 상세';
  static String weekOrderLabel(int weekIndex, int order) =>
      '$weekIndex-${weekIndex + 1}주차 | 활동 $order';
  static const stepGuideTitle = '이렇게 해보세요';
  static const learnMore = '더 알아보기';
  static const observationPointsTitle = '관찰 포인트';
  static const rationaleTitle = '왜 하나요?';
  static const expectedEffectsTitle = '기대 효과';
  static const cautionsTitle = '이런 때는 잠깐 멈춰주세요';
  static const tipsTitle = '활용 TIP';
  static const equipmentTitle = '필요 교구';
  static const equipmentNotRequired = '별도 교구 없이 가능';
  static const equipmentAlternative = '대체';
  static const linkedReflexTitle = '연결 반사';
  static String startActivityWithDuration(int seconds) =>
      '시작하기 ($seconds초)';

  // ── 활동 타이머 ──
  static const timerSkip = '스킵';
  static const timerAlmostDone = '거의 다 됐어요';
  static const completeWithoutTimer = '타이머 없이 완료하기';
  static const completionCongrats = '잘 하셨어요!';
  static const goToObservation = '오늘 아기는 어땠나요? (관찰 기록하기)';
  static const goHome = '홈으로 돌아가기';
  static const featureComingSoon = '곧 준비될 기능이에요';

  // ── 연결 반사 (부모 언어 -> 전문 용어 매핑) ──
  static const reflexDefaultDescription = '이 반응은 아기의 자연스러운 발달 과정의 일부예요.';

  // ── 활동 히스토리 ──
  static const activityHistoryTitle = '활동 히스토리';
  static const activityHistoryPlaceholder = '활동 히스토리 화면은 곧 준비될 거예요.';

  // ── 관찰 기록 폼 ──
  static const observationReassuranceHint =
      '정답은 없어요. 느낌대로 기록해주세요';
  static const observationStep1Title = '활동 직후 모습';
  static const observationStep1Hint = '3개만 해도 충분해요';
  static const observationStep1MoreLabel = '나머지 항목 더 보기';
  static const observationStep2Title = '자세히 기록하고 싶다면';
  static const observationMemoHint = '한 줄 메모를 남겨보세요';

  // ── 관찰 결과 ──
  static const observationGoHome = '홈으로';
  static const observationGrowthPatternHint =
      '관찰 기록이 쌓이면 아기만의 성장 패턴이 보여요';

  // ── 발달 체크 탭 (DevCheck) ──
  static const devCheckTitle = '발달';
  static const devCheckThisPeriod = '이 시기 아기는...';
  static const devCheckCtaStart = '이번 주 발달 살펴보기';
  static const devCheckTrendLink = '지난 기록 보기 ->';
  static const devCheckRecheckButton = '다시 체크하기';
  static const devCheckTrendButton = '추이 보기';

  // ── 체크리스트 화면 ──
  static const checklistProgressLabel = '천천히 살펴보세요';
  static const checklistSubmitButton = '결과 보기';
  static const checklistMemoAdd = '메모 추가';
  static const checklistScoreGuideTitle = '점수 기준';
  static const checklistScoreGuide4 = '4 = 자주 안정적';
  static const checklistScoreGuide3 = '3 = 종종 보임';
  static const checklistScoreGuide2 = '2 = 가끔 보임';
  static const checklistScoreGuide1 = '1 = 드물게 보임';
  static const checklistScoreGuide0 = '0 = 거의 안 보임';
  static const checklistMemoPlaceholder = '관찰한 내용을 메모해 보세요';

  // ── 위험 신호 화면 ──
  static const dangerSignScreenTitle = '한 가지만 더 확인할게요 (선택)';
  static const dangerSignGuideText =
      '아래 항목 중 관찰되는 것이 있다면 체크해 주세요. 해당 없으면 그냥 넘어가세요.';
  static const dangerSignSkipButton = '건너뛰기';
  static const dangerSignSubmitButton = '결과 보기';
  static const dangerSignBannerMessage =
      '며칠 더 지켜본 뒤, 걱정이 계속되면 전문가와 이야기해 보세요.';
  static const dangerSignMemoPlaceholder = '추가로 메모할 내용이 있다면 적어주세요';

  // ── 체크리스트 결과 화면 ──
  static const checklistResultTitle = '오늘의 관찰 결과';
  static const checklistResultGoHome = '홈으로 돌아가기';
  static const checklistResultDomainSection = '영역별 살펴보기';

  // ── 추이 화면 ──
  static const trendTitle = '발달 추이';
  static const trendTabWeekly = '주간';
  static const trendTabMonthly = '월간';
  static const trendReassurance = '변화의 흐름을 살펴보세요';
  static const trendOverallTitle = '전체 추이';
  static const trendDomainTitle = '영역별 추이';
  static const trendYLabelLow = '낮음';
  static const trendYLabelMid = '보통';
  static const trendYLabelHigh = '높음';
  static const trendEmpty =
      '아직 기록이 쌓이지 않았어요.\n발달 탭에서 첫 관찰을 시작해보세요.';
  static const trendCompareGood = '좋아지고 있어요';
  static const trendCompareSimilar = '비슷한 흐름이에요';
  static const trendCompareLittle = '조금씩 나아지고 있어요';
  static const trendCompareWatch = '며칠 더 지켜볼까요?';

  // ── 영역 칩 레이블 ──
  static const domainChipAll = '전체';
  static const domainChipBody = '몸';
  static const domainChipSensory = '감각';
  static const domainChipFocus = '집중';
  static const domainChipSound = '소리';
  static const domainChipHeart = '마음';
  static const domainChipRhythm = '리듬';

  // ── 마이 탭 ──
  static const myTitle = '마이';
  static const myEditButton = '수정 ->';
  static const myAddBaby = '+ 아기 추가하기';

  // ── 마이: 알림 설정 ──
  static const notificationSettingsHeader = '알림 설정';
  static const dailyActivityNotification = '데일리 활동 알림';
  static const dailyActivityNotificationSub = '매일 오전 9:00';
  static const recordReminder = '기록 리마인더';
  static const weekTransitionNotification = '주차 전환 알림';
  static const growthMilestone = '성장 마일스톤';

  // ── 마이: 화면 설정 ──
  static const displaySettingsHeader = '화면 설정';
  static const darkMode = '다크 모드';
  static const grandparentMode = '조부모 모드';
  static const grandparentModeSub = '큰 글씨 + 핵심만';
  static const silentMode = '무음 모드';
  static const silentModeSub = '기본 활성화';

  // ── 마이: 데이터 ──
  static const dataHeader = '데이터';
  static const exportReport = '리포트 내보내기 (PDF)';
  static const dataBackup = '데이터 백업';

  // ── 마이: 정보 ──
  static const infoHeader = '정보';
  static const appInfo = '앱 정보';
  static const termsOfService = '이용약관';
  static const privacyPolicy = '개인정보처리방침';
  static const contentSourceInfo = '콘텐츠 출처 안내';

  // ── 마이: 버전 ──
  static const versionLabel = 'v1.0.0';

  // ── 아기 프로필 수정 ──
  static const babyEditTitle = '아기 프로필 수정';
  static const changePhoto = '사진변경';
  static const deletePhoto = '사진 삭제';
  static const saveButton = '저장하기';
  static const deleteBabyMenu = '아기 정보 삭제';
  static const deleteBabyDialogTitle = '정말 삭제할까요?';
  static const deleteBabyDialogMessage = '삭제하면 모든 기록이 함께 사라져요.';
  static const deleteBabyDialogCancel = '취소';
  static const deleteBabyDialogConfirm = '삭제';
  static const nameEmptyError = '이름을 입력해주세요';
  static String currentWeekPreview(String label) => '현재 주차: $label차';

  // ── 앱 정보 ──
  static const appInfoTitle = '앱 정보';
  static const appVersion = '버전 1.0.0';
  static const copyright = '(c) 2026 하루 한 가지 All rights reserved.';
  static const disclaimerSectionTitle = '면책 문구';
  static const sourceSectionTitle = '콘텐츠 출처';

  // ── 면책 다이얼로그 ──
  static const disclaimerDialogTitle = '콘텐츠 출처 안내';
  static const disclaimerDialogClose = '닫기';

  // ── 주차/단위 접미사 ──
  /// 주차 레이블에 "차" 접미사를 붙인다. 예: "0-1주" -> "0-1주차"
  static String weekLabelSuffix(String label) => '$label차';
  /// 주 번호에 "주" 접미사를 붙인다. 예: 3 -> "3주"
  static String weekSuffix(int week) => '$week주';
}
