import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:movie_app_themes_caching/features/movies/data/models/movie.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: 'https://api.themoviedb.org/3')
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('/movie/popular')
  Future<MoviesResponse> getPopularMovies(
    @Query('language') String language,
    @Query('page') int page,
    @Header('Authorization') String authorization,
  );
}
