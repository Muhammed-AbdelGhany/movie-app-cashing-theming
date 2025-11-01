import 'package:movie_app_themes_caching/core/networking/api_service.dart';
import 'package:movie_app_themes_caching/features/movies/data/datasources/local_data_source.dart';
import 'package:movie_app_themes_caching/features/movies/data/models/movie.dart';
import 'package:movie_app_themes_caching/features/movies/data/models/movie_entity.dart';
import 'package:movie_app_themes_caching/features/movies/domain/repos/movies_repo.dart';

class MoviesRepoImpl implements MoviesRepo {
  final ApiService _apiService;
  final LocalDataSource _localDataSource;
  static const String _cacheEndpoint = '/movie/popular';

  MoviesRepoImpl(this._apiService, this._localDataSource);

  @override
  Future<MoviesResponse?> getPopularMovies({
    required int page,
    required String authorization,
  }) async {
    try {
      // Network-first strategy: Try to fetch from API
      final response = await _apiService.getPopularMovies(
        'en-US',
        page,
        'Bearer $authorization',
      );

      // Cache the response for offline access
      await _cacheMoviesResponse(response, page);
      return response;
    } catch (e) {
      // Network error: Fall back to cache
      return await _getMoviesFromCache(page);
    }
  }

  /// Cache the API response to SQLite
  Future<void> _cacheMoviesResponse(MoviesResponse response, int page) async {
    try {
      final movieEntities = response.results
          .map((movie) => MovieEntity.fromMovie(movie, page))
          .toList();

      await _localDataSource.cacheMovies(
        movies: movieEntities,
        currentPage: response.page,
        totalPages: response.totalPages,
        totalResults: response.totalResults,
        endpoint: _cacheEndpoint,
      );
    } catch (_) {
      // Silently fail cache operations - don't break the app
    }
  }

  /// Get movies from local cache
  Future<MoviesResponse?> _getMoviesFromCache(int page) async {
    try {
      final cachedMovies = await _localDataSource.getMoviesByPage(page);
      if (cachedMovies.isEmpty) return null;

      // Get metadata for pagination info
      final metadata = await _localDataSource.getCacheMetadata(_cacheEndpoint);

      return MoviesResponse(
        page: page,
        results: cachedMovies.map((entity) => entity.toMovie()).toList(),
        totalPages: metadata?.totalPages ?? 0,
        totalResults: metadata?.totalResults ?? cachedMovies.length,
      );
    } catch (_) {
      return null;
    }
  }
}
