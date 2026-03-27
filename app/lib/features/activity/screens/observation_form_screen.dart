import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/inline_save_indicator.dart';
import '../../../data/seed/observation_items_seed.dart';
import '../../../providers/baby_providers.dart';
import '../../../providers/core_providers.dart';
import '../../../providers/observation_providers.dart';
import '../widgets/observation_item_tile.dart';

/// 관찰 기록 폼 화면 (화면 3-3).
/// 개발기획서 5-5 화면 3-3 기준.
/// 단일 스크롤 폼으로 모든 관찰 기록을 한 화면에 통합한다.
class ObservationFormScreen extends ConsumerStatefulWidget {
  final String activityRecordId;

  const ObservationFormScreen({
    super.key,
    required this.activityRecordId,
  });

  @override
  ConsumerState<ObservationFormScreen> createState() =>
      _ObservationFormScreenState();
}

class _ObservationFormScreenState extends ConsumerState<ObservationFormScreen> {
  final _memoController = TextEditingController();
  bool _showMemoSaved = false;
  bool _isSaving = false;
  bool _existingRecordChecked = false;

  @override
  void initState() {
    super.initState();
    // 폼 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(observationFormProvider.notifier).reset();
      _checkExistingRecord();
    });
  }

  /// 이미 해당 활동에 대한 관찰 기록이 존재하는지 확인한다.
  Future<void> _checkExistingRecord() async {
    final dao = ref.read(observationRecordDaoProvider);
    final activityRecordIdInt = int.tryParse(widget.activityRecordId);
    if (activityRecordIdInt == null) return;

    final existing = await dao.getByActivityRecordId(activityRecordIdInt);
    if (existing != null && mounted) {
      // 이미 기록이 존재하면 결과 화면으로 이동
      context.go('/observation/${widget.activityRecordId}/result',
          extra: existing.interpretationLevel);
    }
    if (mounted) {
      setState(() => _existingRecordChecked = true);
    }
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    HapticFeedback.lightImpact();

    final baby = ref.read(activeBabyProvider).value;
    if (baby == null || baby.id == null) {
      setState(() => _isSaving = false);
      return;
    }

    final activityRecordIdInt = int.tryParse(widget.activityRecordId);
    if (activityRecordIdInt == null) {
      setState(() => _isSaving = false);
      return;
    }

    try {
      final record = await saveObservationRecord(
        ref,
        babyId: baby.id!,
        activityRecordId: activityRecordIdInt,
      );

      if (mounted) {
        context.go(
          '/observation/${widget.activityRecordId}/result',
          extra: record.interpretationLevel,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final formState = ref.watch(observationFormProvider);
    final formNotifier = ref.read(observationFormProvider.notifier);

    final step1CoreItems = getObservationStep1CoreItems();
    final step1ExtraItems = getObservationStep1ExtraItems();
    final step2Items = getObservationStep2Items();

    if (!_existingRecordChecked) {
      return Scaffold(
        key: const ValueKey('observation_form_screen'),
        appBar: AppBar(
          title: Text(AppStrings.observationTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      key: const ValueKey('observation_form_screen'),
      appBar: AppBar(
        title: Text(AppStrings.observationTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingH,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimensions.base),
                  // 안심 메시지
                  Text(
                    AppStrings.observationReassuranceHint,
                    key: const ValueKey('observation_reassurance_hint'),
                    style: textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.warmGray,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.lg),

                  // ── 1단계: 활동 직후 모습 (필수) ──
                  Text(
                    AppStrings.observationStep1Title,
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    AppStrings.observationStep1Hint,
                    style: textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.warmGray,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.base),

                  // 핵심 4항목 (기본 펼침)
                  ...step1CoreItems.map((item) => Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppDimensions.md),
                        child: ObservationItemTile(
                          item: item,
                          selectedValue:
                              formState.step1Responses[item.id],
                          onChanged: (value) {
                            formNotifier.setStep1Response(item.id, value);
                          },
                        ),
                      )),

                  // "나머지 항목 더 보기" ExpansionTile
                  Container(
                    key: const ValueKey('obs_step1_expansion'),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.paleCream,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Theme(
                      data: theme.copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        title: Text(
                          AppStrings.observationStep1MoreLabel,
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.cardPadding,
                        ),
                        childrenPadding: const EdgeInsets.fromLTRB(
                          AppDimensions.cardPadding,
                          0,
                          AppDimensions.cardPadding,
                          AppDimensions.cardPadding,
                        ),
                        children: step1ExtraItems
                            .map((item) => Padding(
                                  padding: const EdgeInsets.only(
                                      top: AppDimensions.md),
                                  child: ObservationItemTile(
                                    item: item,
                                    selectedValue:
                                        formState.step1Responses[item.id],
                                    onChanged: (value) {
                                      formNotifier.setStep1Response(
                                          item.id, value);
                                    },
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.lg),

                  // ── 2단계: 자세히 기록하고 싶다면 (선택) ──
                  Container(
                    key: const ValueKey('obs_step2_expansion'),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.paleCream,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Theme(
                      data: theme.copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        title: Text(
                          AppStrings.observationStep2Title,
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.cardPadding,
                        ),
                        childrenPadding: const EdgeInsets.fromLTRB(
                          AppDimensions.cardPadding,
                          0,
                          AppDimensions.cardPadding,
                          AppDimensions.cardPadding,
                        ),
                        children: step2Items
                            .map((item) => Padding(
                                  padding: const EdgeInsets.only(
                                      top: AppDimensions.md),
                                  child: ObservationItemTile(
                                    item: item,
                                    selectedValue:
                                        formState.step2Responses[item.id],
                                    onChanged: (value) {
                                      formNotifier.setStep2Response(
                                          item.id, value);
                                    },
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.lg),

                  // ── 인라인 메모 ──
                  TextField(
                    key: const ValueKey('observation_memo_field'),
                    controller: _memoController,
                    decoration: InputDecoration(
                      hintText: AppStrings.observationMemoHint,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.base,
                        vertical: AppDimensions.md,
                      ),
                    ),
                    onChanged: (value) {
                      formNotifier.setMemo(value);
                      setState(() => _showMemoSaved = true);
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) {
                          setState(() => _showMemoSaved = false);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  InlineSaveIndicator(
                    show: _showMemoSaved,
                    indicatorKey:
                        const ValueKey('observation_memo_save_indicator'),
                  ),
                  // 하단 여백 (버튼 영역 확보)
                  const SizedBox(height: AppDimensions.stickyButtonAreaHeight),
                ],
              ),
            ),
          ),
          // ── 하단 고정 CTA 버튼 ──
          _BottomSubmitBar(
            isEnabled: formState.isSubmittable && !_isSaving,
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}

/// 하단 고정 버튼 영역 (2-3-7).
class _BottomSubmitBar extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;

  const _BottomSubmitBar({
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
        vertical: AppDimensions.md,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBg : AppColors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            key: const ValueKey('observation_submit_button'),
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isEnabled ? AppColors.warmOrange : AppColors.mutedBeige,
              foregroundColor: isEnabled
                  ? AppColors.white
                  : AppColors.white.withValues(alpha: 0.6),
              disabledBackgroundColor: AppColors.mutedBeige,
              disabledForegroundColor:
                  AppColors.white.withValues(alpha: 0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
            ),
            child: Text(
              AppStrings.recordComplete,
              style: theme.textTheme.labelLarge,
            ),
          ),
        ),
      ),
    );
  }
}
