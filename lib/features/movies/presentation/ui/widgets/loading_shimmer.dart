import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:movie_app_themes_caching/core/theming/colors.dart';

class LoadingShimmer extends StatelessWidget {
  final EdgeInsets margin;

  const LoadingShimmer({
    super.key,
    this.margin = const EdgeInsets.only(bottom: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: margin,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.lightCardBg,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              width: 100.w,
              height: 150.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16.h,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 14.h,
                    width: 200.w,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 14.h,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
