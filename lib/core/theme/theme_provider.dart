import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/core/theme/theme_enum.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light; // Usa o tema do sistema por padrão

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  setTheme(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        _themeMode = ThemeMode.light;
        break;
      case AppTheme.dark:
        _themeMode = ThemeMode.dark;
        break;
      case AppTheme.system:
        _themeMode = ThemeMode.system;
        break;
    }
    notifyListeners();
  }
}
