/// 모든 CREATE TABLE SQL 문을 상수로 관리한다.
/// DatabaseHelper._createDB()에서 순서대로 실행된다.
class Tables {
  // ── Babies 테이블 ──
  static const String createBabies = '''
    CREATE TABLE babies (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      birth_date TEXT NOT NULL,
      profile_image_path TEXT,
      created_at TEXT NOT NULL DEFAULT (datetime('now')),
      is_active INTEGER NOT NULL DEFAULT 1
    )
  ''';

  // ── DailyRecords 테이블 ──
  static const String createDailyRecords = '''
    CREATE TABLE daily_records (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      baby_id INTEGER NOT NULL REFERENCES babies(id),
      date TEXT NOT NULL,
      feeding_count INTEGER NOT NULL DEFAULT 0,
      diaper_count INTEGER NOT NULL DEFAULT 0,
      sleep_hours REAL,
      memo TEXT,
      created_at TEXT NOT NULL DEFAULT (datetime('now')),
      updated_at TEXT
    )
  ''';

  // ── GrowthRecords 테이블 ──
  static const String createGrowthRecords = '''
    CREATE TABLE growth_records (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      baby_id INTEGER NOT NULL REFERENCES babies(id),
      date TEXT NOT NULL,
      weight_kg REAL,
      height_cm REAL,
      head_circum_cm REAL,
      created_at TEXT NOT NULL DEFAULT (datetime('now'))
    )
  ''';

  // ── ActivityRecords 테이블 ──
  static const String createActivityRecords = '''
    CREATE TABLE activity_records (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      baby_id INTEGER NOT NULL REFERENCES babies(id),
      activity_id TEXT NOT NULL,
      week_number INTEGER NOT NULL,
      completed_at TEXT NOT NULL,
      timer_duration_sec INTEGER,
      timer_used INTEGER NOT NULL DEFAULT 0
    )
  ''';

  // ── ObservationRecords 테이블 ──
  // step1_responses, step2_responses는 JSON 문자열로 직렬화하여 저장
  static const String createObservationRecords = '''
    CREATE TABLE observation_records (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      baby_id INTEGER NOT NULL REFERENCES babies(id),
      activity_record_id INTEGER NOT NULL REFERENCES activity_records(id),
      date TEXT NOT NULL,
      step1_responses TEXT NOT NULL,
      step2_responses TEXT NOT NULL,
      comfortable_activity TEXT,
      uncomfortable_activity TEXT,
      adjustment_note TEXT,
      interpretation_level INTEGER NOT NULL,
      created_at TEXT NOT NULL DEFAULT (datetime('now'))
    )
  ''';

  // ── ChecklistRecords 테이블 ──
  // responses, memos, domain_scores는 JSON 문자열로 직렬화하여 저장
  static const String createChecklistRecords = '''
    CREATE TABLE checklist_records (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      baby_id INTEGER NOT NULL REFERENCES babies(id),
      week_number INTEGER NOT NULL,
      date TEXT NOT NULL,
      responses TEXT NOT NULL,
      memos TEXT,
      total_score INTEGER NOT NULL,
      percentage REAL NOT NULL,
      tier INTEGER NOT NULL,
      domain_scores TEXT NOT NULL,
      is_complete INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL DEFAULT (datetime('now'))
    )
  ''';

  // ── DangerSignRecords 테이블 ──
  // signs는 JSON 문자열로 직렬화하여 저장
  static const String createDangerSignRecords = '''
    CREATE TABLE danger_sign_records (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      baby_id INTEGER NOT NULL REFERENCES babies(id),
      week_number INTEGER NOT NULL,
      date TEXT NOT NULL,
      signs TEXT NOT NULL,
      memo TEXT,
      has_any_sign INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL DEFAULT (datetime('now'))
    )
  ''';
}
