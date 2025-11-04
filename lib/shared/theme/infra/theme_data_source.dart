import 'package:flutter_ikanban_app/shared/theme/presentation/theme_enum.dart';
import 'package:flutter_ikanban_app/core/services/shared_prefs_service.dart';

class ThemeDataSource {
  static const String themeKey = 'theme';
  
  final SharedPrefsService _preferences = SharedPrefsService.instance;

  Future<AppTheme> getTheme() async {
    final themeString = await _preferences.getString(themeKey);
    return AppTheme.values.firstWhere(
      (e) => e.name == themeString,
      orElse: () => AppTheme.system,
    );
  }

  Future<void> setTheme(AppTheme theme) async {
    await _preferences.setString(themeKey, theme.name);
  }
}
