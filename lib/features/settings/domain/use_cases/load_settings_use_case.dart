import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/settings/domain/errors/settings_repository_errors.dart';
import 'package:flutter_ikanban_app/features/settings/domain/model/settings_model.dart';
import 'package:flutter_ikanban_app/features/settings/domain/repository/settings_repository.dart';

enum LoadSettingsError { unknown, notFound }

class LoadSettingsUseCase {
  final SettingsRepository settingsRepository;

  LoadSettingsUseCase({required this.settingsRepository});

  Future<Outcome<SettingsModel?, LoadSettingsError>> execute() async {
    final result = await settingsRepository.loadSettings();

    return result.when(
      success: (value) {
        return Outcome.success(value: value);
      },
      failure: (error, message, throwable) {
        switch (error) {
          case SettingsRepositoryErrors.notFound:
            return Outcome.failure(error: LoadSettingsError.notFound);
          default:
            return Outcome.failure(error: LoadSettingsError.unknown);
        }
      },
    );
  }
}
