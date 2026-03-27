import 'package:flutter/material.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/score_selector.dart';
import '../../../data/models/checklist_item.dart';

/// 체크리스트 문항 타일 위젯.
/// 문항 텍스트 + ScoreSelector + 메모 추가(ExpansionTile)를 포함한다.
/// StatefulWidget으로 구현하여 TextEditingController를 올바르게 관리한다.
class ChecklistItemTile extends StatefulWidget {
  final ChecklistItem item;
  final int? selectedScore;
  final String? memo;
  final bool showScoreGuide;
  final ValueChanged<int> onScoreSelected;
  final ValueChanged<String> onMemoChanged;
  final VoidCallback? onScoreGuidePressed;

  const ChecklistItemTile({
    super.key,
    required this.item,
    this.selectedScore,
    this.memo,
    this.showScoreGuide = false,
    required this.onScoreSelected,
    required this.onMemoChanged,
    this.onScoreGuidePressed,
  });

  @override
  State<ChecklistItemTile> createState() => _ChecklistItemTileState();
}

class _ChecklistItemTileState extends State<ChecklistItemTile> {
  late TextEditingController _memoController;

  @override
  void initState() {
    super.initState();
    _memoController = TextEditingController(text: widget.memo ?? '');
  }

  @override
  void didUpdateWidget(covariant ChecklistItemTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 외부에서 memo 값이 변경된 경우에만 컨트롤러 텍스트를 업데이트한다.
    // 사용자가 직접 입력 중인 경우(커서 위치 유지)와 구분하기 위해
    // 현재 컨트롤러 텍스트와 비교한다.
    if (widget.memo != oldWidget.memo &&
        widget.memo != _memoController.text) {
      _memoController.text = widget.memo ?? '';
      _memoController.selection = TextSelection.fromPosition(
        TextPosition(offset: _memoController.text.length),
      );
    }
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      key: ValueKey('checklist_item_${widget.item.id}'),
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 문항 텍스트 + (?) 아이콘
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.item.questionText,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              if (widget.showScoreGuide && widget.onScoreGuidePressed != null)
                IconButton(
                  key: const ValueKey('checklist_score_guide_button'),
                  icon: Icon(
                    Icons.help_outline,
                    size: AppDimensions.iconSizeMd,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  onPressed: widget.onScoreGuidePressed,
                  constraints: const BoxConstraints(
                    minWidth: AppDimensions.minTouchTarget,
                    minHeight: AppDimensions.minTouchTarget,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          // ScoreSelector
          ScoreSelector(
            questionId: widget.item.id,
            selectedScore: widget.selectedScore,
            onScoreSelected: widget.onScoreSelected,
          ),
          // 메모 추가 (ExpansionTile)
          Theme(
            data: theme.copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              key: ValueKey('checklist_memo_${widget.item.id}'),
              tilePadding: EdgeInsets.zero,
              title: Text(
                AppStrings.checklistMemoAdd,
                style: theme.textTheme.bodySmall,
              ),
              children: [
                TextField(
                  key: ValueKey('checklist_memo_field_${widget.item.id}'),
                  controller: _memoController,
                  decoration: InputDecoration(
                    hintText: AppStrings.checklistMemoPlaceholder,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    contentPadding: const EdgeInsets.all(AppDimensions.md),
                  ),
                  maxLines: 2,
                  onChanged: widget.onMemoChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
