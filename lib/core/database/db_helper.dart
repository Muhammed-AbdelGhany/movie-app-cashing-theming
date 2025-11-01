import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();

  factory DbHelper() {
    return _instance;
  }

  DbHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'movie_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Movies cache table
    await db.execute('''
      CREATE TABLE movies (
        id INTEGER PRIMARY KEY,
        page INTEGER NOT NULL,
        title TEXT NOT NULL,
        poster_path TEXT,
        backdrop_path TEXT,
        overview TEXT NOT NULL,
        vote_average REAL NOT NULL,
        release_date TEXT NOT NULL,
        genre_ids TEXT NOT NULL,
        popularity REAL NOT NULL,
        adult INTEGER NOT NULL,
        original_language TEXT NOT NULL,
        original_title TEXT NOT NULL,
        video INTEGER NOT NULL,
        vote_count INTEGER NOT NULL,
        cached_at INTEGER NOT NULL
      )
    ''');

    // Cache metadata table (for tracking pagination and freshness)
    await db.execute('''
      CREATE TABLE cache_metadata (
        id INTEGER PRIMARY KEY,
        endpoint TEXT NOT NULL UNIQUE,
        last_page INTEGER NOT NULL,
        total_pages INTEGER NOT NULL,
        total_results INTEGER NOT NULL,
        cached_at INTEGER NOT NULL,
        expires_at INTEGER NOT NULL
      )
    ''');

    // Create indexes for better query performance
    await db.execute(
      'CREATE INDEX idx_movies_page ON movies(page)',
    );
    await db.execute(
      'CREATE INDEX idx_movies_cached_at ON movies(cached_at)',
    );
  }

  Future<void> closeDb() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
