import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/empty_state_card.dart';
import '../../../data/models/daily_record.dart';
import '../../../providers/selected_date_provider.dart';
import '../widgets/record_summary_card.dart';

/// 기록 히스토리 화면 (개발기획서 5-4 화면 2-2).
/// 타임라인 형태 날짜별 기록 카드 리스트.
/// 기록 없는 날은 건너뜀 (죄책감 없음). 무한 스크롤.
class RecordHistoryScreen extends ConsumerStatefulWidget {
  const RecordHistoryScreen({super.key});

  @override
  ConsumerState<RecordHistoryScreen> createState() =>
      _RecordHistoryScreenState();
}

class _RecordHistoryScreenState extends ConsumerState<RecordHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<DailyRecord> _allRecords = [];
  int _currentOffset = 0;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  bool _initialLoaded = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    setState(() => _isLoadingMore = true);

    final nextOffset = _currentOffset + 20;
    // Trigger the provider with the new offset
    final records = await ref.read(recordHistoryProvider(nextOffset).future);
    if (mounted) {
      setState(() {
        _allRecords.addAll(records);
        _currentOffset = nextOffset;
        _isLoadingMore = false;
        if (records.length < 20) {
          _hasMore = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Load initial data
    final initialAsync = ref.watch(recordHistoryProvider(0));

    return Scaffold(
      key: const ValueKey('record_history_screen'),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppStrings.recordHistoryTitle,
          style: theme.textTheme.headlineSmall,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: initialAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(
          child: Text(e.toString()),
        ),
        data: (initialRecords) {
          // On first load, set _allRecords
          if (!_initialLoaded) {
            _allRecords.clear();
            _allRecords.addAll(initialRecords);
            _initialLoaded = true;
            if (initialRecords.length < 20) {
              _hasMore = false;
            }
          }

          if (_allRecords.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
                child: EmptyStateCard(
                  key: const ValueKey('record_history_empty'),
                  icon: Icons.note_alt_outlined,
                  message: AppStrings.recordHistoryEmpty,
                ),
              ),
            );
          }

          return ListView.separated(
            key: const ValueKey('record_history_list'),
            controller: _scrollController,
            padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
            itemCount: _allRecords.length + (_hasMore ? 1 : 0),
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppDimensions.base),
            itemBuilder: (context, index) {
              if (index >= _allRecords.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.base),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return RecordSummaryCard(record: _allRecords[index]);
            },
          );
        },
      ),
    );
  }
}
