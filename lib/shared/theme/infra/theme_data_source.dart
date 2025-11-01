import 'package:flutter_ikanban_app/shared/shared_preferences/shared_prefs_service.dart';

class ThemeDataSource {
  static const String darkModeKey = 'dark_mode';
  
  final SharedPrefsService _preferences = SharedPrefsService.instance;

  Future<bool> isDarkModeEnabled() async {
    return await _preferences.getBool(darkModeKey) ?? false;
  }

  Future<void> setDarkModeEnabled(bool isEnabled) async {
    await _preferences.setBool(darkModeKey, isEnabled);
  }
}
