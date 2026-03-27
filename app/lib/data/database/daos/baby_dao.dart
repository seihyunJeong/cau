import '../database_helper.dart';
import '../../models/baby.dart';

/// babies 테이블 CRUD.
/// 개발기획서 4-5 기준. DatabaseHelper.instance를 사용한다.
class BabyDao {
  /// Baby를 삽입하고 자동 생성된 id를 반환한다.
  Future<int> insert(Baby baby) async {
    final db = await DatabaseHelper.instance.database;
    final map = baby.toMap();
    // id는 자동 생성이므로 제거
    map.remove('id');
    return db.insert('babies', map);
  }

  /// id로 Baby를 조회한다. 없으면 null을 반환한다.
  Future<Baby?> getById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final results = await db.query(
      'babies',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isEmpty) return null;
    return Baby.fromMap(results.first);
  }

  /// 모든 Baby를 조회한다.
  Future<List<Baby>> getAll() async {
    final db = await DatabaseHelper.instance.database;
    final results = await db.query('babies');
    return results.map((map) => Baby.fromMap(map)).toList();
  }

  /// Baby를 업데이트하고 영향받은 행 수를 반환한다.
  Future<int> update(Baby baby) async {
    final db = await DatabaseHelper.instance.database;
    return db.update(
      'babies',
      baby.toMap(),
      where: 'id = ?',
      whereArgs: [baby.id],
    );
  }

  /// id로 Baby를 삭제하고 영향받은 행 수를 반환한다.
  Future<int> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    return db.delete(
      'babies',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
