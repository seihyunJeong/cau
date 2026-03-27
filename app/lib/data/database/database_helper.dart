import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'tables.dart';

/// sqflite 데이터베이스 싱글톤 헬퍼.
/// 앱 전체에서 DatabaseHelper.instance로 접근한다.
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// 데이터베이스 인스턴스를 반환한다. 최초 호출 시 초기화된다.
  Future<Database> get database async {
    _database ??= await _initDB('haru_hanagaji.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  /// 최초 DB 생성 시 모든 테이블을 생성한다.
  Future<void> _createDB(Database db, int version) async {
    await db.execute(Tables.createBabies);
    await db.execute(Tables.createDailyRecords);
    await db.execute(Tables.createGrowthRecords);
    await db.execute(Tables.createActivityRecords);
    await db.execute(Tables.createObservationRecords);
    await db.execute(Tables.createChecklistRecords);
    await db.execute(Tables.createDangerSignRecords);
  }

  /// 향후 스키마 변경 시 마이그레이션 로직 추가
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // 향후 스키마 변경 시 마이그레이션 로직 추가
  }

  /// 데이터베이스를 닫는다 (테스트 등에서 사용).
  Future<void> close() async {
    final db = await database;
    db.close();
    _database = null;
  }
}
