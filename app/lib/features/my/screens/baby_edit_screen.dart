import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/week_calculator.dart';
import '../../../core/widgets/primary_cta_button.dart';
import '../../../data/models/baby.dart';
import '../../../providers/baby_providers.dart';
import '../../../providers/core_providers.dart';
import '../widgets/delete_baby_dialog.dart';
import '../widgets/photo_picker_bottom_sheet.dart';

/// 아기 프로필 수정 화면.
/// 앱 바 변형 C: 뒤로가기 + "아기 프로필 수정" + 우측 PopupMenuButton.
class BabyEditScreen extends ConsumerStatefulWidget {
  const BabyEditScreen({super.key});

  @override
  ConsumerState<BabyEditScreen> createState() => _BabyEditScreenState();
}

class _BabyEditScreenState extends ConsumerState<BabyEditScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String? _profileImagePath;
  bool _isInitialized = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _initializeFromBaby(Baby baby) {
    if (!_isInitialized) {
      _nameController.text = baby.name;
      _selectedDate = baby.birthDate;
      _profileImagePath = baby.profileImagePath;
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final babyAsync = ref.watch(activeBabyProvider);

    return Scaffold(
      key: const ValueKey('baby_edit_screen'),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          constraints: const BoxConstraints(
            minWidth: AppDimensions.minTouchTarget,
            minHeight: AppDimensions.minTouchTarget,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.babyEditTitle,
          style: theme.textTheme.headlineSmall,
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton<String>(
            key: const ValueKey('delete_baby_menu'),
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteDialog();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'delete',
                child: Text(
                  AppStrings.deleteBabyMenu,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.softRed,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: babyAsync.when(
        data: (baby) {
          if (baby == null) {
            return Center(
              child: Text(
                AppStrings.emptyBabyProfile,
                style: theme.textTheme.bodyLarge,
              ),
            );
          }
          _initializeFromBaby(baby);
          return _buildForm(context, baby, theme, isDark);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            AppStrings.emptyBabyProfile,
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }

  Widget _buildForm(
      BuildContext context, Baby baby, ThemeData theme, bool isDark) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingH,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppDimensions.lg),
                    // ── 프로필 사진 영역 ──
                    _buildProfilePhoto(theme, isDark),
                    const SizedBox(height: AppDimensions.xl),
                    // ── 이름 입력 ──
                    _buildNameField(theme, isDark),
                    const SizedBox(height: AppDimensions.lg),
                    // ── 생년월일 선택 ──
                    _buildBirthDateField(theme, isDark),
                    const SizedBox(height: AppDimensions.md),
                    // ── 주차 미리보기 ──
                    if (_selectedDate != null) _buildWeekPreview(theme),
                    const SizedBox(height: AppDimensions.xxl),
                  ],
                ),
              ),
            ),
          ),
          // ── 저장 버튼 ──
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.screenPaddingH,
                AppDimensions.md,
                AppDimensions.screenPaddingH,
                AppDimensions.base,
              ),
              child: PrimaryCtaButton(
                label: AppStrings.saveButton,
                buttonKey: const ValueKey('save_baby_button'),
                onPressed: _isSaving ? null : _onSave,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePhoto(ThemeData theme, bool isDark) {
    return GestureDetector(
      key: const ValueKey('photo_change_area'),
      onTap: _showPhotoOptions,
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor:
                isDark ? AppColors.darkBorder : AppColors.lightBeige,
            backgroundImage: _profileImagePath != null
                ? FileImage(File(_profileImagePath!))
                : null,
            child: _profileImagePath == null
                ? Icon(
                    Icons.child_care,
                    size: 40,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.warmGray,
                  )
                : null,
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            AppStrings.changePhoto,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildNameField(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.babyNameLabel,
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: AppDimensions.xs),
        TextFormField(
          key: const ValueKey('baby_name_field'),
          controller: _nameController,
          style: theme.textTheme.bodyLarge,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return AppStrings.nameEmptyError;
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: AppStrings.babyNameHint,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
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
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBeige,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: AppColors.warmOrange,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: AppColors.softRed,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: AppColors.softRed,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBirthDateField(ThemeData theme, bool isDark) {
    final dateText = _selectedDate != null
        ? DateFormat('yyyy년 MM월 dd일').format(_selectedDate!)
        : AppStrings.birthDateHint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.birthDateLabel,
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: AppDimensions.xs),
        GestureDetector(
          key: const ValueKey('baby_birthdate_field'),
          onTap: _showDatePicker,
          child: Container(
            constraints: const BoxConstraints(
              minHeight: AppDimensions.minTouchTarget,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.base,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBeige,
              ),
            ),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    dateText,
                    style: _selectedDate != null
                        ? theme.textTheme.bodyLarge
                        : theme.textTheme.bodyLarge?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.mutedBeige,
                          ),
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  size: AppDimensions.iconSizeMd,
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

  Widget _buildWeekPreview(ThemeData theme) {
    final weekLabel = WeekCalculator.calculateWeekLabel(_selectedDate!);
    return Container(
      key: const ValueKey('baby_week_preview'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Text(
        AppStrings.currentWeekPreview(weekLabel),
        style: theme.textTheme.bodySmall,
        textAlign: TextAlign.left,
      ),
    );
  }

  void _showDatePicker() {
    final now = nowKST();
    final minDate = DateTime(now.year - 5, now.month, now.day);
    DateTime tempDate = _selectedDate ?? now;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? AppColors.darkCard : AppColors.white;

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
                        Navigator.pop(ctx);
                      },
                      child: Text(
                        AppStrings.datePickerConfirm,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime:
                      tempDate.isAfter(now) ? now : tempDate,
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
    PhotoPickerBottomSheet.show(
      context: context,
      hasExistingPhoto: _profileImagePath != null,
      onGallery: () => _pickImage(ImageSource.gallery),
      onCamera: () => _pickImage(ImageSource.camera),
      onDelete: () {
        setState(() {
          _profileImagePath = null;
        });
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
        // 앱 문서 디렉토리에 복사
        final appDir = await getApplicationDocumentsDirectory();
        final fileName =
            'profile_${DateTime.now().millisecondsSinceEpoch}${p.extension(pickedFile.path)}';
        final savedFile =
            await File(pickedFile.path).copy('${appDir.path}/$fileName');
        setState(() {
          _profileImagePath = savedFile.path;
        });
      }
    } catch (e) {
      debugPrint('Image pick failed: $e');
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) return;

    setState(() => _isSaving = true);

    try {
      final babyAsync = ref.read(activeBabyProvider);
      final baby = babyAsync.value;
      if (baby == null) return;

      // Baby.copyWith uses null coalescing so we construct directly
      // to allow clearing profileImagePath to null.
      final updatedBaby = Baby(
        id: baby.id,
        name: _nameController.text.trim(),
        birthDate: _selectedDate!,
        profileImagePath: _profileImagePath,
        createdAt: baby.createdAt,
        isActive: baby.isActive,
      );

      final dao = ref.read(babyDaoProvider);
      await dao.update(updatedBaby);

      ref.invalidate(activeBabyProvider);

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      debugPrint('Baby update failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showDeleteDialog() {
    DeleteBabyDialog.show(
      context: context,
      onConfirm: _onDeleteBaby,
    );
  }

  Future<void> _onDeleteBaby() async {
    try {
      final babyAsync = ref.read(activeBabyProvider);
      final baby = babyAsync.value;
      if (baby == null || baby.id == null) return;

      final dao = ref.read(babyDaoProvider);
      await dao.delete(baby.id!);

      final settings = ref.read(appSettingsServiceProvider);
      await settings.setActiveBabyId(null);
      await settings.setOnboardingComplete(false);

      ref.invalidate(activeBabyProvider);
      ref.invalidate(appSettingsServiceProvider);

      if (mounted) {
        context.go('/onboarding');
      }
    } catch (e) {
      debugPrint('Baby delete failed: $e');
    }
  }
}
