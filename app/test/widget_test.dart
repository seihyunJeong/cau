import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:haru_hanagaji/app.dart';
import 'package:haru_hanagaji/providers/core_providers.dart';
import 'package:haru_hanagaji/data/database/database_helper.dart';
import 'package:haru_hanagaji/services/app_settings_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseHelperProvider
              .overrideWithValue(DatabaseHelper.instance),
          appSettingsServiceProvider
              .overrideWithValue(AppSettingsService(prefs)),
        ],
        child: const HaruHanGajiApp(),
      ),
    );

    expect(find.text('하루 한 가지'), findsWidgets);
  });
}
