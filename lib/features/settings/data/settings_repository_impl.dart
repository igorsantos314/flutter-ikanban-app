import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/settings/domain/errors/settings_repository_errors.dart';
import 'package:flutter_ikanban_app/features/settings/domain/model/settings_model.dart';
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
  Future<Outcome<SettingsModel, SettingsRepositoryErrors>>
  loadSettings() async {
    try {
      final settings = SettingsModel(
        appTheme: await themeRepository.getTheme(),
        language: "pt",
        appVersion: "0.0.1",
      );
      return Outcome.success(value: settings);
    } catch (e) {
      return Outcome.failure(
        error: SettingsRepositoryErrors.genericError(),
        message: "Failed to load settings",
        throwable: e,
      );
    }
  }

  @override
  Future<Outcome<void, SettingsRepositoryErrors>> saveSettings(
    SettingsModel settings,
  ) async {
    try {
      await themeRepository.setTheme(settings.appTheme);
      return Outcome.success(value: null);
    } catch (e) {
      return Outcome.failure(
        error: SettingsRepositoryErrors.genericError(),
        message: "Failed to save settings",
        throwable: e,
      );
    }
  }
}
