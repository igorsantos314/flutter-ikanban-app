import 'package:flutter_ikanban_app/shared/theme/infra/theme_data_source.dart';
import 'package:flutter_ikanban_app/shared/theme/repository/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeDataSource dataSource;

  ThemeRepositoryImpl(this.dataSource);

  @override
  Future<bool> isDarkModeEnabled() {
    return dataSource.isDarkModeEnabled();
  }

  @override
  Future<void> setDarkModeEnabled(bool isEnabled) {
    return dataSource.setDarkModeEnabled(isEnabled);
  }
}
