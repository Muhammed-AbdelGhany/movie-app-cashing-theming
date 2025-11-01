import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie.freezed.dart';
part 'movie.g.dart';

@freezed
class Movie with _$Movie {
  const factory Movie({
    required int id,
    required String title,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    required String overview,
    @JsonKey(name: 'vote_average') required double voteAverage,
    @JsonKey(name: 'release_date') required String releaseDate,
    @JsonKey(name: 'genre_ids') required List<int> genreIds,
    required double popularity,
    required bool adult,
    @JsonKey(name: 'original_language') required String originalLanguage,
    @JsonKey(name: 'original_title') required String originalTitle,
    required bool video,
    @JsonKey(name: 'vote_count') required int voteCount,
  }) = _Movie;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
}

@freezed
class MoviesResponse with _$MoviesResponse {
  const factory MoviesResponse({
    required int page,
    required List<Movie> results,
    @JsonKey(name: 'total_pages') required int totalPages,
    @JsonKey(name: 'total_results') required int totalResults,
  }) = _MoviesResponse;

  factory MoviesResponse.fromJson(Map<String, dynamic> json) =>
      _$MoviesResponseFromJson(json);
}
