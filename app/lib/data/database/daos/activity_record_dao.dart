import '../../models/activity_record.dart';
import '../database_helper.dart';
import '../../../core/utils/date_utils.dart';

/// 활동 완료 기록 DAO.
/// 개발기획서 4-5 기준. activity_records 테이블 CRUD.
class ActivityRecordDao {
  /// 활동 완료 기록을 삽입한다.
  Future<int> insert(ActivityRecord record) async {
    final db = await DatabaseHelper.instance.database;
    return db.insert('activity_records', record.toMap());
  }

  /// 오늘 완료한 활동 ID 목록을 반환한다.
  /// KST 기준 오늘 날짜의 기록만 조회한다.
  Future<List<String>> getTodayCompletedActivityIds(int babyId) async {
    final db = await DatabaseHelper.instance.database;
    final now = nowKST();
    final todayStart = DateTime(now.year, now.month, now.day).toIso8601String();
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59)
        .toIso8601String();

    final result = await db.query(
      'activity_records',
      columns: ['activity_id'],
      where: 'baby_id = ? AND completed_at >= ? AND completed_at <= ?',
      whereArgs: [babyId, todayStart, todayEnd],
    );

    return result.map((row) => row['activity_id'] as String).toList();
  }

  /// 특정 아기의 모든 활동 완료 기록을 반환한다.
  Future<List<ActivityRecord>> getAllByBabyId(int babyId) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'activity_records',
      where: 'baby_id = ?',
      whereArgs: [babyId],
      orderBy: 'completed_at DESC',
    );

    return result.map(ActivityRecord.fromMap).toList();
  }
}
