import '../../models/observation_record.dart';
import '../database_helper.dart';

/// 관찰 기록 DAO.
/// 개발기획서 4-5 기준. observation_records 테이블 CRUD.
class ObservationRecordDao {
  /// 관찰 기록을 삽입한다.
  Future<int> insert(ObservationRecord record) async {
    final db = await DatabaseHelper.instance.database;
    return db.insert('observation_records', record.toMap());
  }

  /// ID로 관찰 기록을 조회한다.
  Future<ObservationRecord?> getById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'observation_records',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return ObservationRecord.fromMap(result.first);
  }

  /// 활동 기록 ID로 관찰 기록을 조회한다.
  /// 같은 활동에 대한 중복 기록 방지용으로 사용된다.
  Future<ObservationRecord?> getByActivityRecordId(
    int activityRecordId,
  ) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'observation_records',
      where: 'activity_record_id = ?',
      whereArgs: [activityRecordId],
    );
    if (result.isEmpty) return null;
    return ObservationRecord.fromMap(result.first);
  }

  /// 특정 아기의 최근 관찰 기록 목록을 반환한다.
  Future<List<ObservationRecord>> getRecentByBabyId(
    int babyId, {
    int limit = 7,
  }) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'observation_records',
      where: 'baby_id = ?',
      whereArgs: [babyId],
      orderBy: 'created_at DESC',
      limit: limit,
    );
    return result.map(ObservationRecord.fromMap).toList();
  }

  /// 특정 아기의 가장 최근 관찰 기록을 반환한다.
  Future<ObservationRecord?> getLatestByBabyId(int babyId) async {
    final records = await getRecentByBabyId(babyId, limit: 1);
    return records.isEmpty ? null : records.first;
  }
}
