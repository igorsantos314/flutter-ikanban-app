import 'package:flutter_ikanban_app/core/di/app_locator.dart';
import 'package:flutter_ikanban_app/shared/theme/presentation/theme_enum.dart';
import 'package:flutter_ikanban_app/shared/theme/infra/theme_data_source.dart';
import 'package:flutter_ikanban_app/shared/theme/repository/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeDataSource dataSource;

  ThemeRepositoryImpl(this.dataSource);

  static Future<AppTheme> getThemePrefs() async {
    return await ThemeRepositoryImpl(
      getIt<ThemeDataSource>(),
    ).getTheme();
  }

  @override
  Future<AppTheme> getTheme() {
    return dataSource.getTheme();
  }

  @override
  Future<void> setTheme(AppTheme theme) {
    return dataSource.setTheme(theme);
  }
}
