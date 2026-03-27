import '../../models/danger_sign_record.dart';
import '../database_helper.dart';

/// 위험 신호 기록 DAO.
/// 개발기획서 4-5 기준. danger_sign_records 테이블 CRUD + 최근 조회.
class DangerSignRecordDao {
  /// 위험 신호 기록을 삽입하고 자동 생성된 id를 반환한다.
  Future<int> insert(DangerSignRecord record) async {
    final db = await DatabaseHelper.instance.database;
    final map = record.toMap();
    map.remove('id');
    return db.insert('danger_sign_records', map);
  }

  /// 가장 최근 위험 신호 기록을 반환한다.
  Future<DangerSignRecord?> getLatest(int babyId) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'danger_sign_records',
      where: 'baby_id = ?',
      whereArgs: [babyId],
      orderBy: 'created_at DESC',
      limit: 1,
    );
    if (result.isEmpty) return null;
    return DangerSignRecord.fromMap(result.first);
  }

  /// 최근 N일간 위험 신호 기록을 반환한다.
  Future<List<DangerSignRecord>> getRecentRecords(
    int babyId, {
    int days = 7,
  }) async {
    final db = await DatabaseHelper.instance.database;
    final cutoff =
        DateTime.now().subtract(Duration(days: days)).toIso8601String();
    final result = await db.query(
      'danger_sign_records',
      where: 'baby_id = ? AND date >= ?',
      whereArgs: [babyId, cutoff],
      orderBy: 'created_at DESC',
    );
    return result.map(DangerSignRecord.fromMap).toList();
  }
}
