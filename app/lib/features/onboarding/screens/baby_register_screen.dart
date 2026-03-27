import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/week_calculator.dart';
import '../../../core/widgets/primary_cta_button.dart';
import '../../../providers/core_providers.dart';
import '../providers/onboarding_provider.dart';

/// 온보딩 화면 B: 아기 등록 화면.
/// 개발기획서 5-1 화면 B 기준.
/// 이름(필수), 생년월일(필수), 프로필 사진(선택), 주차 자동 계산 미리보기.
class BabyRegisterScreen extends ConsumerStatefulWidget {
  const BabyRegisterScreen({super.key});

  @override
  ConsumerState<BabyRegisterScreen> createState() =>
      _BabyRegisterScreenState();
}

class _BabyRegisterScreenState extends ConsumerState<BabyRegisterScreen> {
  final _nameController = TextEditingController();
  final _nameFocusNode = FocusNode();
  DateTime? _selectedDate;
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    ref.read(onboardingProvider.notifier).setName(_nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      key: const ValueKey('register_screen'),
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 24),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: AppDimensions.minTouchTarget,
            minHeight: AppDimensions.minTouchTarget,
          ),
          onPressed: () => context.go('/onboarding'),
        ),
        title: Text(
          AppStrings.babyRegisterTitle,
          style: textTheme.headlineSmall,
        ),
        centerTitle: false,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPaddingH,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppDimensions.lg),
              // -- 프로필 사진 --
              _buildProfilePhoto(textTheme, isDark),
              const SizedBox(height: AppDimensions.xl),
              // -- 아기 이름 입력 --
              _buildNameField(textTheme, isDark),
              const SizedBox(height: AppDimensions.lg),
              // -- 생년월일 선택 --
              _buildBirthDateField(textTheme, isDark),
              const SizedBox(height: AppDimensions.lg),
              // -- 주차 미리보기 --
              if (_selectedDate != null) _buildWeekPreview(textTheme, isDark),
              const SizedBox(height: AppDimensions.xxl),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.screenPaddingH,
            AppDimensions.md,
            AppDimensions.screenPaddingH,
            AppDimensions.base,
          ),
          child: PrimaryCtaButton(
            label: AppStrings.registerButton,
            buttonKey: const ValueKey('register_submit_button'),
            onPressed: state.isValid && !state.isSubmitting
                ? _onRegister
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePhoto(TextTheme textTheme, bool isDark) {
    return GestureDetector(
      key: const ValueKey('register_photo_button'),
      onTap: _showPhotoOptions,
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: isDark ? AppColors.darkBorder : AppColors.lightBeige,
            backgroundImage: _profileImagePath != null
                ? FileImage(File(_profileImagePath!))
                : null,
            child: _profileImagePath == null
                ? Icon(
                    Icons.camera_alt_outlined,
                    size: 32,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.warmGray,
                  )
                : null,
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            AppStrings.profilePhotoHint,
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildNameField(TextTheme textTheme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.babyNameLabel,
          style: textTheme.bodySmall,
        ),
        const SizedBox(height: AppDimensions.xs),
        SizedBox(
          height: 48,
          child: TextField(
            key: const ValueKey('register_name_field'),
            controller: _nameController,
            focusNode: _nameFocusNode,
            style: textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: AppStrings.babyNameHint,
              hintStyle: textTheme.bodyLarge?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.mutedBeige,
              ),
              filled: true,
              fillColor: isDark ? AppColors.darkCard : AppColors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.base,
                vertical: AppDimensions.md,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBeige,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBeige,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(
                  color: AppColors.warmOrange,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBirthDateField(TextTheme textTheme, bool isDark) {
    final dateText = _selectedDate != null
        ? DateFormat('yyyy년 MM월 dd일').format(_selectedDate!)
        : AppStrings.birthDateHint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.birthDateLabel,
          style: textTheme.bodySmall,
        ),
        const SizedBox(height: AppDimensions.xs),
        GestureDetector(
          key: const ValueKey('register_birthdate_field'),
          onTap: _showDatePicker,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.base,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBeige,
                width: 1,
              ),
            ),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    dateText,
                    style: _selectedDate != null
                        ? textTheme.bodyLarge
                        : textTheme.bodyLarge?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.mutedBeige,
                          ),
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.warmGray,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekPreview(TextTheme textTheme, bool isDark) {
    final weekLabel = WeekCalculator.calculateWeekLabel(_selectedDate!);
    return Container(
      key: const ValueKey('register_week_preview'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.paleCream,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(
        '${AppStrings.weekPreviewPrefix}$weekLabel${AppStrings.weekPreviewSuffix}',
        style: textTheme.bodyLarge?.copyWith(
          color: AppColors.warmOrange,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _showDatePicker() {
    final now = nowKST();
    // 최소 날짜: 오늘로부터 60개월(약 5년) 전
    final minDate = DateTime(now.year - 5, now.month, now.day);
    DateTime tempDate = _selectedDate ?? now;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? AppColors.darkCard : AppColors.white;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
      ),
      builder: (ctx) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              // -- 확인 버튼 --
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.base,
                  vertical: AppDimensions.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedDate = tempDate;
                        });
                        ref
                            .read(onboardingProvider.notifier)
                            .setBirthDate(tempDate);
                        Navigator.pop(ctx);
                      },
                      child: Text(
                        AppStrings.datePickerConfirm,
                        style: textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
              ),
              // -- CupertinoDatePicker (스크롤 휠) --
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: tempDate.isAfter(now) ? now : tempDate,
                  maximumDate: now,
                  minimumDate: minDate,
                  onDateTimeChanged: (date) {
                    tempDate = date;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPhotoOptions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? AppColors.darkCard : AppColors.white;
    final textTheme = Theme.of(context).textTheme;
    final iconColor = isDark ? AppColors.darkTextPrimary : AppColors.darkBrown;

    showModalBottomSheet(
      context: context,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.base),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library_outlined,
                      color: iconColor),
                  title: Text(
                    AppStrings.selectFromGallery,
                    style: textTheme.bodyLarge,
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt_outlined,
                      color: iconColor),
                  title: Text(
                    AppStrings.takePhoto,
                    style: textTheme.bodyLarge,
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _profileImagePath = pickedFile.path;
        });
        ref
            .read(onboardingProvider.notifier)
            .setProfileImagePath(pickedFile.path);
      }
    } catch (e) {
      // 권한 거부 등의 경우 무시 (죄책감 없는 UX)
      debugPrint('이미지 선택 실패: $e');
    }
  }

  Future<void> _onRegister() async {
    try {
      final notifier = ref.read(onboardingProvider.notifier);
      final id = await notifier.registerBaby();

      // activeBabyId 설정
      final settings = ref.read(appSettingsServiceProvider);
      await settings.setActiveBabyId(id);

      if (mounted) {
        context.go('/onboarding/intro');
      }
    } catch (e) {
      debugPrint('아기 등록 실패: $e');
    }
  }
}
