import 'package:movie_app_themes_caching/features/movies/data/models/movie.dart';

abstract class MoviesRepo {
  Future<MoviesResponse?> getPopularMovies({
    required int page,
    required String authorization,
  });
}
