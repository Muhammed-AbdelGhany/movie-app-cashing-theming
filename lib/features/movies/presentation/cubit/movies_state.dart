part of 'movies_cubit.dart';

@freezed
class MoviesState with _$MoviesState {
  const factory MoviesState.initial() = _Initial;
  const factory MoviesState.loading() = _Loading;
  const factory MoviesState.success({
    required List<Movie> movies,
    required bool hasMore,
    required int currentPage,
    @Default(false) bool isLoadingMore,
    @Default(false) bool isFromCache,
  }) = _Success;
  const factory MoviesState.error(String message) = _Error;
}
