import 'package:flutter_ikanban_app/core/theme/theme_enum.dart';
import 'package:flutter_ikanban_app/shared/shared_preferences/shared_prefs_service.dart';

class ThemeDataSource {
  static const String darkModeKey = 'dark_mode';
  
  final SharedPrefsService _preferences = SharedPrefsService.instance;

  Future<AppTheme> getTheme() async {
    final themeString = await _preferences.getString(darkModeKey);
    return AppTheme.values.firstWhere(
      (e) => e.name == themeString,
      orElse: () => AppTheme.system,
    );
  }

  Future<void> setTheme(AppTheme theme) async {
    await _preferences.setString(darkModeKey, theme.name);
  }
}
