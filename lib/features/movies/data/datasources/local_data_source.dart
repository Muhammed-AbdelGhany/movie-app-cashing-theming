import 'package:sqflite/sqflite.dart';
import 'package:movie_app_themes_caching/core/database/db_helper.dart';
import 'package:movie_app_themes_caching/features/movies/data/models/movie_entity.dart';

class LocalDataSource {
  final DbHelper _dbHelper;

  LocalDataSource(this._dbHelper);

  /// Cache movies for a specific page
  Future<void> cacheMovies({
    required List<MovieEntity> movies,
    required int currentPage,
    required int totalPages,
    required int totalResults,
    required String endpoint,
  }) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      // Insert movies
      for (final movie in movies) {
        await txn.insert(
          'movies',
          movie.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Update or insert cache metadata
      final metadata = CacheMetadata.fromResponse(
        endpoint: endpoint,
        currentPage: currentPage,
        totalPages: totalPages,
        totalResults: totalResults,
        cacheValidityMinutes: 60, // Cache valid for 1 hour
      );

      await txn.insert(
        'cache_metadata',
        metadata.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  /// Get cached movies for a specific page
  Future<List<MovieEntity>> getMoviesByPage(int page) async {
    final db = await _dbHelper.database;

    final results = await db.query(
      'movies',
      where: 'page = ?',
      whereArgs: [page],
      orderBy: 'id DESC',
    );

    return results
        .map((map) => MovieEntity.fromMap(map as Map<String, dynamic>))
        .toList();
  }

  /// Get all cached movies (for offline access)
  Future<List<MovieEntity>> getAllCachedMovies() async {
    final db = await _dbHelper.database;

    final results = await db.query(
      'movies',
      orderBy: 'page ASC, id DESC',
    );

    return results
        .map((map) => MovieEntity.fromMap(map as Map<String, dynamic>))
        .toList();
  }

  /// Get cached movies for multiple pages (e.g., pages 1-3)
  Future<List<MovieEntity>> getMoviesByPages(List<int> pages) async {
    if (pages.isEmpty) return [];

    final db = await _dbHelper.database;
    final placeholders = pages.map((_) => '?').join(',');

    final results = await db.query(
      'movies',
      where: 'page IN ($placeholders)',
      whereArgs: pages,
      orderBy: 'page ASC, id DESC',
    );

    return results
        .map((map) => MovieEntity.fromMap(map as Map<String, dynamic>))
        .toList();
  }

  /// Get cache metadata for an endpoint
  Future<CacheMetadata?> getCacheMetadata(String endpoint) async {
    final db = await _dbHelper.database;

    final results = await db.query(
      'cache_metadata',
      where: 'endpoint = ?',
      whereArgs: [endpoint],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return CacheMetadata.fromMap(results.first as Map<String, dynamic>);
  }

  /// Check if cache is fresh (not expired)
  Future<bool> isCacheFresh(String endpoint) async {
    final metadata = await getCacheMetadata(endpoint);
    if (metadata == null) return false;
    return !metadata.isExpired();
  }

  /// Clear movies cache for a specific page
  Future<void> clearMoviesPage(int page) async {
    final db = await _dbHelper.database;
    await db.delete('movies', where: 'page = ?', whereArgs: [page]);
  }

  /// Clear all movies cache
  Future<void> clearAllMovies() async {
    final db = await _dbHelper.database;
    await db.delete('movies');
  }

  /// Clear all cache including metadata
  Future<void> clearAllCache() async {
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      await txn.delete('movies');
      await txn.delete('cache_metadata');
    });
  }

  /// Get cache size in bytes (for monitoring)
  Future<int> getCacheSize() async {
    final db = await _dbHelper.database;

    final moviesCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM movies'));
    final metadataCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM cache_metadata'));

    // Rough estimate: each movie ~500 bytes, metadata ~200 bytes
    return (moviesCount ?? 0) * 500 + (metadataCount ?? 0) * 200;
  }

  /// Get total number of cached movies
  Future<int> getCachedMovieCount() async {
    final db = await _dbHelper.database;
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM movies'));
    return count ?? 0;
  }
}
