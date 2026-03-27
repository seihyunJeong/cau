import '../../models/daily_record.dart';
import '../database_helper.dart';
import '../../../core/utils/date_utils.dart';

/// daily_records 테이블 CRUD.
/// 개발기획서 4-3 기준.
class DailyRecordDao {
  /// DailyRecord를 삽입하고 자동 생성된 id를 반환한다.
  Future<int> insert(DailyRecord record) async {
    final db = await DatabaseHelper.instance.database;
    final map = record.toMap();
    map.remove('id');
    return db.insert('daily_records', map);
  }

  /// DailyRecord를 업데이트하고 영향받은 행 수를 반환한다.
  Future<int> update(DailyRecord record) async {
    final db = await DatabaseHelper.instance.database;
    final map = record.toMap();
    map['updated_at'] = nowKST().toIso8601String();
    return db.update(
      'daily_records',
      map,
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  /// 오늘 날짜의 DailyRecord를 조회한다.
  /// KST 기준 오늘 날짜로 필터링한다.
  Future<DailyRecord?> getTodayRecord(int babyId) async {
    final db = await DatabaseHelper.instance.database;
    final now = nowKST();
    final todayStr = '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';

    final results = await db.query(
      'daily_records',
      where: 'baby_id = ? AND date = ?',
      whereArgs: [babyId, todayStr],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return DailyRecord.fromMap(results.first);
  }

  /// 특정 날짜의 DailyRecord를 조회한다.
  Future<DailyRecord?> getByDate(int babyId, DateTime date) async {
    final db = await DatabaseHelper.instance.database;
    final dateStr = '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';

    final results = await db.query(
      'daily_records',
      where: 'baby_id = ? AND date = ?',
      whereArgs: [babyId, dateStr],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return DailyRecord.fromMap(results.first);
  }

  /// 특정 날짜 범위의 DailyRecord 목록을 조회한다 (히스토리용).
  /// 최신 날짜가 먼저 오도록 DESC 정렬.
  /// 기록이 없는 날은 포함하지 않는다 (죄책감 없음).
  Future<List<DailyRecord>> getRecordsByDateRange(
    int babyId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await DatabaseHelper.instance.database;
    final startStr = '${startDate.year.toString().padLeft(4, '0')}-'
        '${startDate.month.toString().padLeft(2, '0')}-'
        '${startDate.day.toString().padLeft(2, '0')}';
    final endStr = '${endDate.year.toString().padLeft(4, '0')}-'
        '${endDate.month.toString().padLeft(2, '0')}-'
        '${endDate.day.toString().padLeft(2, '0')}';

    final results = await db.query(
      'daily_records',
      where: 'baby_id = ? AND date >= ? AND date <= ?',
      whereArgs: [babyId, startStr, endStr],
      orderBy: 'date DESC',
    );

    return results.map(DailyRecord.fromMap).toList();
  }

  /// 특정 아기의 모든 DailyRecord를 최신순으로 조회한다 (페이징 지원).
  Future<List<DailyRecord>> getAllByBabyId(
    int babyId, {
    int limit = 20,
    int offset = 0,
  }) async {
    final db = await DatabaseHelper.instance.database;
    final results = await db.query(
      'daily_records',
      where: 'baby_id = ?',
      whereArgs: [babyId],
      orderBy: 'date DESC',
      limit: limit,
      offset: offset,
    );

    return results.map(DailyRecord.fromMap).toList();
  }
}
