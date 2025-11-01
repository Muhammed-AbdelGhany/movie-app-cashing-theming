import 'dart:convert';
import 'package:movie_app_themes_caching/features/movies/data/models/movie.dart';

class MovieEntity {
  final int id;
  final int page;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String overview;
  final double voteAverage;
  final String releaseDate;
  final List<int> genreIds;
  final double popularity;
  final bool adult;
  final String originalLanguage;
  final String originalTitle;
  final bool video;
  final int voteCount;
  final DateTime cachedAt;

  MovieEntity({
    required this.id,
    required this.page,
    required this.title,
    this.posterPath,
    this.backdropPath,
    required this.overview,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
    required this.popularity,
    required this.adult,
    required this.originalLanguage,
    required this.originalTitle,
    required this.video,
    required this.voteCount,
    required this.cachedAt,
  });

  /// Convert MovieEntity to SQLite Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'page': page,
      'title': title,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'overview': overview,
      'vote_average': voteAverage,
      'release_date': releaseDate,
      'genre_ids': jsonEncode(genreIds), // Store as JSON string
      'popularity': popularity,
      'adult': adult ? 1 : 0,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'video': video ? 1 : 0,
      'vote_count': voteCount,
      'cached_at': cachedAt.millisecondsSinceEpoch,
    };
  }

  /// Create MovieEntity from SQLite Map
  factory MovieEntity.fromMap(Map<String, dynamic> map) {
    return MovieEntity(
      id: map['id'] as int,
      page: map['page'] as int,
      title: map['title'] as String,
      posterPath: map['poster_path'] as String?,
      backdropPath: map['backdrop_path'] as String?,
      overview: map['overview'] as String,
      voteAverage: map['vote_average'] as double,
      releaseDate: map['release_date'] as String,
      genreIds: List<int>.from(jsonDecode(map['genre_ids'] as String)),
      popularity: map['popularity'] as double,
      adult: (map['adult'] as int) == 1,
      originalLanguage: map['original_language'] as String,
      originalTitle: map['original_title'] as String,
      video: (map['video'] as int) == 1,
      voteCount: map['vote_count'] as int,
      cachedAt: DateTime.fromMillisecondsSinceEpoch(map['cached_at'] as int),
    );
  }

  /// Convert MovieEntity to Movie (for UI)
  Movie toMovie() {
    return Movie(
      id: id,
      title: title,
      posterPath: posterPath,
      backdropPath: backdropPath,
      overview: overview,
      voteAverage: voteAverage,
      releaseDate: releaseDate,
      genreIds: genreIds,
      popularity: popularity,
      adult: adult,
      originalLanguage: originalLanguage,
      originalTitle: originalTitle,
      video: video,
      voteCount: voteCount,
    );
  }

  /// Create MovieEntity from Movie (for caching)
  factory MovieEntity.fromMovie(Movie movie, int page) {
    return MovieEntity(
      id: movie.id,
      page: page,
      title: movie.title,
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      overview: movie.overview,
      voteAverage: movie.voteAverage,
      releaseDate: movie.releaseDate,
      genreIds: movie.genreIds,
      popularity: movie.popularity,
      adult: movie.adult,
      originalLanguage: movie.originalLanguage,
      originalTitle: movie.originalTitle,
      video: movie.video,
      voteCount: movie.voteCount,
      cachedAt: DateTime.now(),
    );
  }
}

/// Cache metadata for tracking pagination and freshness
class CacheMetadata {
  final String endpoint;
  final int lastPage;
  final int totalPages;
  final int totalResults;
  final DateTime cachedAt;
  final DateTime expiresAt;

  CacheMetadata({
    required this.endpoint,
    required this.lastPage,
    required this.totalPages,
    required this.totalResults,
    required this.cachedAt,
    required this.expiresAt,
  });

  /// Convert to SQLite Map
  Map<String, dynamic> toMap() {
    return {
      'endpoint': endpoint,
      'last_page': lastPage,
      'total_pages': totalPages,
      'total_results': totalResults,
      'cached_at': cachedAt.millisecondsSinceEpoch,
      'expires_at': expiresAt.millisecondsSinceEpoch,
    };
  }

  /// Create from SQLite Map
  factory CacheMetadata.fromMap(Map<String, dynamic> map) {
    return CacheMetadata(
      endpoint: map['endpoint'] as String,
      lastPage: map['last_page'] as int,
      totalPages: map['total_pages'] as int,
      totalResults: map['total_results'] as int,
      cachedAt:
          DateTime.fromMillisecondsSinceEpoch(map['cached_at'] as int),
      expiresAt:
          DateTime.fromMillisecondsSinceEpoch(map['expires_at'] as int),
    );
  }

  /// Check if cache is still fresh
  bool isExpired() {
    return DateTime.now().isAfter(expiresAt);
  }

  /// Create metadata from API response
  factory CacheMetadata.fromResponse({
    required String endpoint,
    required int currentPage,
    required int totalPages,
    required int totalResults,
    required int cacheValidityMinutes,
  }) {
    final now = DateTime.now();
    return CacheMetadata(
      endpoint: endpoint,
      lastPage: currentPage,
      totalPages: totalPages,
      totalResults: totalResults,
      cachedAt: now,
      expiresAt: now.add(Duration(minutes: cacheValidityMinutes)),
    );
  }
}
