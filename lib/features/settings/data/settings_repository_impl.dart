import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/settings/domain/errors/settings_repository_errors.dart';
import 'package:flutter_ikanban_app/features/settings/domain/repository/settings_repository.dart';
import 'package:flutter_ikanban_app/features/settings/infra/settings_data_source.dart';
import 'package:flutter_ikanban_app/shared/theme/repository/theme_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final ThemeRepository themeRepository;
  final SettingsDataSource dataSource;

  SettingsRepositoryImpl({
    required this.themeRepository,
    required this.dataSource,
  });

  @override
  Future<Outcome<bool, SettingsRepositoryErrors>> getIsDarkMode() {
    try {
      return themeRepository.isDarkModeEnabled().then(
        (isDarkMode) => Outcome.success(value: isDarkMode),
      );
    } catch (e) {
      return Future.value(
        Outcome.failure(
          error: SettingsRepositoryErrors.genericError(),
          throwable: e,
        ),
      );
    }
  }

  @override
  Future<Outcome<String, SettingsRepositoryErrors>> getLanguage() {
    throw UnimplementedError();
  }

  @override
  Future<Outcome<void, SettingsRepositoryErrors>> setIsDarkMode(
    bool isDarkMode,
  ) {
    try {
      return themeRepository.setDarkModeEnabled(isDarkMode).then(
        (_) => Outcome.success(value: null),
      );
    } catch (e) {
      return Future.value(
        Outcome.failure(
          error: SettingsRepositoryErrors.genericError(),
          throwable: e,
        ),
      );
    }
  }

  @override
  Future<Outcome<void, SettingsRepositoryErrors>> setLanguage(String language) {
    throw UnimplementedError();
  }
}
