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
