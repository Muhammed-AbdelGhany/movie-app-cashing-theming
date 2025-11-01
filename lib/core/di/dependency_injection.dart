import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_app_themes_caching/core/database/db_helper.dart';
import 'package:movie_app_themes_caching/core/networking/api_service.dart';
import 'package:movie_app_themes_caching/core/networking/dio_factory.dart';
import 'package:movie_app_themes_caching/core/theming/theme_cubit.dart';
import 'package:movie_app_themes_caching/features/movies/data/datasources/local_data_source.dart';
import 'package:movie_app_themes_caching/features/movies/data/repos/movies_repo_impl.dart';
import 'package:movie_app_themes_caching/features/movies/domain/repos/movies_repo.dart';
import 'package:movie_app_themes_caching/features/movies/presentation/cubit/movies_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Shared Preferences
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Database
  getIt.registerSingleton<DbHelper>(DbHelper());

  // Local Data Source
  getIt.registerSingleton<LocalDataSource>(
    LocalDataSource(getIt<DbHelper>()),
  );

  // Networking
  getIt.registerSingleton(DioFactory.createDio());
  getIt.registerSingleton<ApiService>(
    ApiService(getIt()),
  );

  // Theme Cubit
  getIt.registerSingleton<ThemeCubit>(
    ThemeCubit(prefs: getIt()),
  );

  // Movies Repository
  getIt.registerLazySingleton<MoviesRepo>(
    () => MoviesRepoImpl(
      getIt<ApiService>(),
      getIt<LocalDataSource>(),
    ),
  );

  // Movies Cubit
  getIt.registerFactory<MoviesCubit>(
    () => MoviesCubit(getIt<MoviesRepo>()),
  );
}
