import 'package:shared_preferences/shared_preferences.dart';

/// 앱 설정 -- SharedPreferences로 관리 (단순 key-value).
/// SQLite 테이블이 아닌 SharedPreferences를 사용하는 이유:
/// - 단순 플래그/문자열 값만 저장
/// - 쿼리/관계/집계가 필요 없음
/// - 앱 시작 시 빠른 동기 접근이 필요
class AppSettingsService {
  static const _keyOnboardingComplete = 'isOnboardingComplete';
  static const _keyThemeMode = 'themeMode';
  static const _keyGrandparentMode = 'isGrandparentMode';
  static const _keyDailyNotificationOn = 'isDailyNotificationOn';
  static const _keyDailyNotificationTime = 'dailyNotificationTime';
  static const _keyRecordReminderOn = 'isRecordReminderOn';
  static const _keyWeekTransitionOn = 'isWeekTransitionOn';
  static const _keyMilestoneOn = 'isMilestoneOn';
  static const _keySilentMode = 'isSilentMode';
  static const _keyActiveBabyId = 'activeBabyId';

  final SharedPreferences _prefs;

  AppSettingsService(this._prefs);

  // ── 읽기 (getter) ──

  bool get isOnboardingComplete =>
      _prefs.getBool(_keyOnboardingComplete) ?? false;

  String get themeMode => _prefs.getString(_keyThemeMode) ?? 'system';

  bool get isGrandparentMode =>
      _prefs.getBool(_keyGrandparentMode) ?? false;

  bool get isDailyNotificationOn =>
      _prefs.getBool(_keyDailyNotificationOn) ?? true;

  String get dailyNotificationTime =>
      _prefs.getString(_keyDailyNotificationTime) ?? '09:00';

  bool get isRecordReminderOn =>
      _prefs.getBool(_keyRecordReminderOn) ?? true;

  bool get isWeekTransitionOn =>
      _prefs.getBool(_keyWeekTransitionOn) ?? true;

  bool get isMilestoneOn => _prefs.getBool(_keyMilestoneOn) ?? true;

  bool get isSilentMode => _prefs.getBool(_keySilentMode) ?? true;

  int? get activeBabyId => _prefs.getInt(_keyActiveBabyId);

  // ── 쓰기 (setter) ──

  Future<void> setOnboardingComplete(bool value) =>
      _prefs.setBool(_keyOnboardingComplete, value);

  Future<void> setThemeMode(String value) =>
      _prefs.setString(_keyThemeMode, value);

  Future<void> setGrandparentMode(bool value) =>
      _prefs.setBool(_keyGrandparentMode, value);

  Future<void> setDailyNotificationOn(bool value) =>
      _prefs.setBool(_keyDailyNotificationOn, value);

  Future<void> setDailyNotificationTime(String value) =>
      _prefs.setString(_keyDailyNotificationTime, value);

  Future<void> setRecordReminderOn(bool value) =>
      _prefs.setBool(_keyRecordReminderOn, value);

  Future<void> setWeekTransitionOn(bool value) =>
      _prefs.setBool(_keyWeekTransitionOn, value);

  Future<void> setMilestoneOn(bool value) =>
      _prefs.setBool(_keyMilestoneOn, value);

  Future<void> setSilentMode(bool value) =>
      _prefs.setBool(_keySilentMode, value);

  Future<void> setActiveBabyId(int? value) {
    if (value == null) return _prefs.remove(_keyActiveBabyId);
    return _prefs.setInt(_keyActiveBabyId, value);
  }
}
