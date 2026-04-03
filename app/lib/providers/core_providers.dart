import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/database_helper.dart';
import '../data/database/daos/baby_dao.dart';
import '../data/database/daos/checklist_record_dao.dart';
import '../data/database/daos/daily_record_dao.dart';
import '../data/database/daos/activity_record_dao.dart';
import '../data/database/daos/danger_sign_record_dao.dart';
import '../data/database/daos/growth_record_dao.dart';
import '../data/database/daos/observation_record_dao.dart';
import '../services/app_settings_service.dart';

/// DatabaseHelper 인스턴스 Provider.
/// main.dart에서 overrideWithValue로 실제 인스턴스를 주입한다.
final databaseHelperProvider = Provider<DatabaseHelper>(
  (ref) => throw UnimplementedError(
    'databaseHelperProvider는 main.dart에서 overrideWithValue로 초기화되어야 합니다.',
  ),
);

/// AppSettingsService 인스턴스 Provider.
/// main.dart에서 overrideWithValue로 실제 인스턴스를 주입한다.
final appSettingsServiceProvider = Provider<AppSettingsService>(
  (ref) => throw UnimplementedError(
    'appSettingsServiceProvider는 main.dart에서 overrideWithValue로 초기화되어야 합니다.',
  ),
);

/// 테마 모드 리액티브 상태. 토글 시 즉시 UI 반영.
class ThemeModeNotifier extends Notifier<String> {
  @override
  String build() => ref.read(appSettingsServiceProvider).themeMode;

  void update(String mode) => state = mode;
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, String>(ThemeModeNotifier.new);

/// 조부모 모드 리액티브 상태. 토글 시 즉시 UI 반영.
class GrandparentModeNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(appSettingsServiceProvider).isGrandparentMode;

  void update(bool value) => state = value;
}

final grandparentModeProvider =
    NotifierProvider<GrandparentModeNotifier, bool>(
        GrandparentModeNotifier.new);

/// BabyDao 인스턴스 Provider.
final babyDaoProvider = Provider<BabyDao>((ref) => BabyDao());

/// DailyRecordDao 인스턴스 Provider.
final dailyRecordDaoProvider = Provider<DailyRecordDao>(
  (ref) => DailyRecordDao(),
);

/// GrowthRecordDao 인스턴스 Provider.
final growthRecordDaoProvider = Provider<GrowthRecordDao>(
  (ref) => GrowthRecordDao(),
);

/// ActivityRecordDao 인스턴스 Provider.
final activityRecordDaoProvider = Provider<ActivityRecordDao>(
  (ref) => ActivityRecordDao(),
);

/// ObservationRecordDao 인스턴스 Provider.
final observationRecordDaoProvider = Provider<ObservationRecordDao>(
  (ref) => ObservationRecordDao(),
);

/// ChecklistRecordDao 인스턴스 Provider.
final checklistRecordDaoProvider = Provider<ChecklistRecordDao>(
  (ref) => ChecklistRecordDao(),
);

/// DangerSignRecordDao 인스턴스 Provider.
final dangerSignRecordDaoProvider = Provider<DangerSignRecordDao>(
  (ref) => DangerSignRecordDao(),
);
