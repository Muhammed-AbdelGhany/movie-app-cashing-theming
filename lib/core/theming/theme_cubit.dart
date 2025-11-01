import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_cubit.freezed.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences _prefs;
  static const String _themeKey = 'isDarkMode';

  ThemeCubit({required SharedPreferences prefs})
      : _prefs = prefs,
        super(ThemeState(isDarkMode: prefs.getBool(_themeKey) ?? false));

  Future<void> toggleTheme() async {
    final newValue = !state.isDarkMode;
    await _prefs.setBool(_themeKey, newValue);
    emit(ThemeState(isDarkMode: newValue));
  }

  Future<void> setTheme(bool isDarkMode) async {
    await _prefs.setBool(_themeKey, isDarkMode);
    emit(ThemeState(isDarkMode: isDarkMode));
  }
}
