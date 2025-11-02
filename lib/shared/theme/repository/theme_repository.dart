import 'package:flutter_ikanban_app/shared/theme/presentation/theme_enum.dart';

abstract class ThemeRepository {
  Future<AppTheme> getTheme();
  Future<void> setTheme(AppTheme theme);
}
