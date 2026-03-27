import '../../models/checklist_record.dart';
import '../database_helper.dart';

/// 체크리스트 기록 DAO.
/// 개발기획서 4-5 기준. checklist_records 테이블 CRUD + 추이 조회 + 최신 조회.
class ChecklistRecordDao {
  /// 체크리스트 기록을 삽입하고 자동 생성된 id를 반환한다.
  Future<int> insert(ChecklistRecord record) async {
    final db = await DatabaseHelper.instance.database;
    final map = record.toMap();
    map.remove('id');
    return db.insert('checklist_records', map);
  }

  /// 이번 주차의 가장 최근 결과를 반환한다.
  Future<ChecklistRecord?> getLatestByWeek(int babyId, int weekNumber) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'checklist_records',
      where: 'baby_id = ? AND week_number = ?',
      whereArgs: [babyId, weekNumber],
      orderBy: 'created_at DESC',
      limit: 1,
    );
    if (result.isEmpty) return null;
    return ChecklistRecord.fromMap(result.first);
  }

  /// 가장 최근 결과를 반환한다.
  Future<ChecklistRecord?> getLatest(int babyId) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'checklist_records',
      where: 'baby_id = ?',
      whereArgs: [babyId],
      orderBy: 'created_at DESC',
      limit: 1,
    );
    if (result.isEmpty) return null;
    return ChecklistRecord.fromMap(result.first);
  }

  /// 해당 아기의 전체 체크리스트 기록을 반환한다 (추이 조회용).
  Future<List<ChecklistRecord>> getAllByBabyId(int babyId) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'checklist_records',
      where: 'baby_id = ?',
      whereArgs: [babyId],
      orderBy: 'created_at ASC',
    );
    return result.map(ChecklistRecord.fromMap).toList();
  }

  /// 이전 주차 결과를 반환한다 (비교용).
  Future<ChecklistRecord?> getPreviousRecord(
    int babyId,
    int weekNumber,
  ) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'checklist_records',
      where: 'baby_id = ? AND week_number < ?',
      whereArgs: [babyId, weekNumber],
      orderBy: 'created_at DESC',
      limit: 1,
    );
    if (result.isEmpty) return null;
    return ChecklistRecord.fromMap(result.first);
  }
}
