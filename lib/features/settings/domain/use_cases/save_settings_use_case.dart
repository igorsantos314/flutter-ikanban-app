import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/settings/domain/model/settings_model.dart';
import 'package:flutter_ikanban_app/features/settings/domain/repository/settings_repository.dart';
import 'package:flutter_ikanban_app/features/settings/domain/errors/settings_repository_errors.dart';

enum SaveSettingsError { unknown, notFound }

class SaveSettingsUseCase {
  final SettingsRepository settingsRepository;

  SaveSettingsUseCase({required this.settingsRepository});

  Future<Outcome<void, SaveSettingsError>> execute(
    SettingsModel settings,
  ) async {
    final result = await settingsRepository.saveSettings(settings);

    return result.when(
      success: (_) => Outcome.success(value: null),
      failure: (error, message, throwable) {
        switch (error) {
          case SettingsRepositoryErrors.notFound:
            return Outcome.failure(error: SaveSettingsError.notFound);
          default:
            return Outcome.failure(error: SaveSettingsError.unknown);
        }
      },
    );
  }
}
