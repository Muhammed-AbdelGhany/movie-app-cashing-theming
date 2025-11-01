import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app_themes_caching/core/helpers/spacing.dart';
import 'package:movie_app_themes_caching/core/theming/colors.dart';
import 'package:movie_app_themes_caching/features/movies/data/models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isDarkMode;

  const MovieCard({
    super.key,
    required this.movie,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkMode ? AppColors.darkCardBg : AppColors.lightCardBg;
    final textColor = isDarkMode ? AppColors.darkText : AppColors.lightText;
    final primaryColor =
        isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Row(
          children: [
            _buildPoster(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Spacing.verticalSpacing8,
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14.sp,
                          color: primaryColor,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          movie.releaseDate,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: textColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    Spacing.verticalSpacing8,
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 14.sp,
                          color: AppColors.starColor,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            '${movie.voteCount} votes',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacing.verticalSpacing12,
                    Text(
                      movie.overview,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: textColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoster() {
    const posterBaseUrl = 'https://image.tmdb.org/t/p/w342';

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12.r),
        bottomLeft: Radius.circular(12.r),
      ),
      child: CachedNetworkImage(
        imageUrl: movie.posterPath != null
            ? '$posterBaseUrl${movie.posterPath}'
            : 'https://via.placeholder.com/100x150?text=No+Image',
        width: 100.w,
        height: 150.h,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: 100.w,
          height: 150.h,
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: 100.w,
          height: 150.h,
          color: Colors.grey[300],
          child: Icon(
            Icons.error,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
