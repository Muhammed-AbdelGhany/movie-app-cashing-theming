import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_app_themes_caching/features/movies/data/models/movie.dart';
import 'package:movie_app_themes_caching/features/movies/domain/repos/movies_repo.dart';

part 'movies_cubit.freezed.dart';
part 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  final MoviesRepo _repo;
  final String _authorization =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkMjRkYTEyNDhhNzNjOWJhMzZiNDczNTc5ZDBhNWJjNyIsIm5iZiI6MTc2MTc3MzgwNS4zMzYsInN1YiI6IjY5MDI4OGVkOWNmMDkzNDg3YTg1MWEzYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.CNCW4xGYHPvKHvOTdH1KifmoQVGPJ7_FOKJy3avJZj0';

  MoviesCubit(this._repo) : super(const MoviesState.initial());

  Future<void> getPopularMovies() async {
    emit(const MoviesState.loading());

    final response = await _repo.getPopularMovies(
      page: 1,
      authorization: _authorization,
    );

    if (response != null) {
      emit(MoviesState.success(
        movies: response.results,
        hasMore: response.page < response.totalPages,
        currentPage: response.page,
        isLoadingMore: false,
        isFromCache: false,
      ));
    } else {
      emit(const MoviesState.error('Failed to load movies'));
    }
  }

  Future<void> loadMoreMovies() async {
    if (state is! _Success) return;

    final currentState = state as _Success;
    // Emit loading state while keeping current movies visible
    emit(MoviesState.success(
      movies: currentState.movies,
      hasMore: currentState.hasMore,
      currentPage: currentState.currentPage,
      isLoadingMore: true,
      isFromCache: currentState.isFromCache,
    ));

    final response = await _repo.getPopularMovies(
      page: currentState.currentPage + 1,
      authorization: _authorization,
    );

    if (response != null) {
      final allMovies = [...currentState.movies, ...response.results];
      emit(MoviesState.success(
        movies: allMovies,
        hasMore: response.page < response.totalPages,
        currentPage: response.page,
        isLoadingMore: false,
        isFromCache: false,
      ));
    } else {
      // If failed, keep the current movies and show hasMore as false
      emit(MoviesState.success(
        movies: currentState.movies,
        hasMore: false,
        currentPage: currentState.currentPage,
        isLoadingMore: false,
        isFromCache: currentState.isFromCache,
      ));
    }
  }
}
