import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app_themes_caching/core/di/dependency_injection.dart';
import 'package:movie_app_themes_caching/core/theming/app_theme.dart';
import 'package:movie_app_themes_caching/core/theming/theme_cubit.dart';
import 'package:movie_app_themes_caching/features/movies/presentation/cubit/movies_cubit.dart';
import 'package:movie_app_themes_caching/features/movies/presentation/ui/movies_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => getIt<ThemeCubit>(),
            ),
            BlocProvider(
              create: (context) => getIt<MoviesCubit>(),
            ),
          ],
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                title: 'Movie App',
                theme: AppTheme.lightTheme(),
                darkTheme: AppTheme.darkTheme(),
                themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                home: const MoviesScreen(),
              );
            },
          ),
        );
      },
    );
  }
}
