import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app_themes_caching/core/helpers/spacing.dart';
import 'package:movie_app_themes_caching/core/theming/colors.dart';
import 'package:movie_app_themes_caching/core/theming/theme_cubit.dart';
import 'package:movie_app_themes_caching/features/movies/data/models/movie.dart';
import 'package:movie_app_themes_caching/features/movies/presentation/cubit/movies_cubit.dart';
import 'package:movie_app_themes_caching/features/movies/presentation/ui/widgets/movie_card.dart';
import 'package:movie_app_themes_caching/features/movies/presentation/ui/widgets/loading_shimmer.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<MoviesCubit>().getPopularMovies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      final moviesCubit = context.read<MoviesCubit>();
      final state = moviesCubit.state;
      state.whenOrNull(
        success: (movies, hasMore, currentPage, isLoadingMore, isFromCache) {
          if (hasMore && !isLoadingMore) {
            moviesCubit.loadMoreMovies();
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state.isDarkMode;
    final bgColor = isDarkMode ? AppColors.darkBg : AppColors.lightBg;
    final textColor = isDarkMode ? AppColors.darkText : AppColors.lightText;
    final primaryColor = isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Popular Movies',
          style: TextStyle(
            color: textColor,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: bgColor,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: primaryColor,
                    size: 24.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: bgColor,
      body: BlocBuilder<MoviesCubit, MoviesState>(
        builder: (context, state) {
          return Stack(
            children: [
              state.when(
                initial: () => _buildLoading(),
                loading: () => _buildLoading(),
                success: (movies, hasMore, currentPage, isLoadingMore, isFromCache) =>
                    _buildMoviesList(context, isDarkMode, isLoadingMore),
                error: (message) => _buildError(message, isDarkMode, textColor),
              ),
              // Show offline indicator if data is from cache
              state.whenOrNull(
                success: (movies, hasMore, currentPage, isLoadingMore, isFromCache) {
                  if (isFromCache) {
                    return _buildOfflineIndicator(isDarkMode, primaryColor);
                  }
                  return null;
                },
              ) ?? const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoading() {
    return ListView.builder(
      itemCount: 10,
      padding: EdgeInsets.all(12.w),
      itemBuilder: (context, index) => LoadingShimmer(
        margin: EdgeInsets.only(bottom: 12.h),
      ),
    );
  }

  Widget _buildMoviesList(BuildContext context, bool isDarkMode, bool isLoadingMore) {
    // We're already in a BlocBuilder from the body, so just display the list
    final state = context.read<MoviesCubit>().state;
    return state.whenOrNull(
      success: (movies, hasMore, currentPage, isLoadingMore, isFromCache) {
        return _buildSuccessList(movies, hasMore, isDarkMode, isLoadingMore);
      },
    ) ??
        const SizedBox.shrink();
  }

  Widget _buildSuccessList(List<Movie> movies, bool hasMore, bool isDarkMode, bool isLoadingMore) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(12.w),
      itemCount: movies.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == movies.length && isLoadingMore) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
                ),
              ),
            ),
          );
        }

        return MovieCard(
          movie: movies[index],
          isDarkMode: isDarkMode,
        );
      },
    );
  }

  Widget _buildError(String message, bool isDarkMode, Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: AppColors.error,
          ),
          Spacing.verticalSpacing16,
          Text(
            'Failed to Load Movies',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Spacing.verticalSpacing8,
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: textColor.withOpacity(0.7),
            ),
          ),
          Spacing.verticalSpacing24,
          ElevatedButton.icon(
            onPressed: () {
              context.read<MoviesCubit>().getPopularMovies();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 12.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineIndicator(bool isDarkMode, Color primaryColor) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.orange.shade600,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.cloud_off,
              color: Colors.white,
              size: 18.sp,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'Showing cached data - No internet connection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
