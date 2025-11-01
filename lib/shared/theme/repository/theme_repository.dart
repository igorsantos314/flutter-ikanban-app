import 'package:flutter_ikanban_app/core/theme/theme_enum.dart';

abstract class ThemeRepository {
  Future<AppTheme> getTheme();
  Future<void> setTheme(AppTheme theme);
}
