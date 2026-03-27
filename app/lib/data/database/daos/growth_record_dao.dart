import '../../models/growth_record.dart';
import '../database_helper.dart';

/// growth_records 테이블 CRUD.
/// 개발기획서 4-3 기준.
class GrowthRecordDao {
  /// 가장 최근 성장 기록 1건을 조회한다.
  Future<GrowthRecord?> getLatestRecord(int babyId) async {
    final db = await DatabaseHelper.instance.database;
    final results = await db.query(
      'growth_records',
      where: 'baby_id = ?',
      whereArgs: [babyId],
      orderBy: 'date DESC',
      limit: 1,
    );

    if (results.isEmpty) return null;
    return GrowthRecord.fromMap(results.first);
  }

  /// 성장 기록을 삽입한다.
  Future<int> insert(GrowthRecord record) async {
    final db = await DatabaseHelper.instance.database;
    final map = record.toMap();
    map.remove('id');
    return db.insert('growth_records', map);
  }

  /// 성장 기록을 업데이트한다.
  Future<int> update(GrowthRecord record) async {
    final db = await DatabaseHelper.instance.database;
    return db.update(
      'growth_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  /// 특정 아기의 모든 성장 기록을 날짜순(ASC)으로 조회한다 (성장 곡선 그래프용).
  Future<List<GrowthRecord>> getAllByBabyId(int babyId) async {
    final db = await DatabaseHelper.instance.database;
    final results = await db.query(
      'growth_records',
      where: 'baby_id = ?',
      whereArgs: [babyId],
      orderBy: 'date ASC',
    );

    return results.map(GrowthRecord.fromMap).toList();
  }

  /// 특정 날짜의 성장 기록을 조회한다 (오늘 데이터 존재 여부 확인용).
  Future<GrowthRecord?> getByDate(int babyId, DateTime date) async {
    final db = await DatabaseHelper.instance.database;
    final dateStr = date.toIso8601String().substring(0, 10);

    final results = await db.query(
      'growth_records',
      where: 'baby_id = ? AND date LIKE ?',
      whereArgs: [babyId, '$dateStr%'],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return GrowthRecord.fromMap(results.first);
  }
}
