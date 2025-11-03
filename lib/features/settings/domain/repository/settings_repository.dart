import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/settings/domain/errors/settings_repository_errors.dart';
import 'package:flutter_ikanban_app/features/settings/domain/model/settings_model.dart';

abstract class SettingsRepository {
  Future<Outcome<SettingsModel, SettingsRepositoryErrors>> loadSettings();
  Future<Outcome<void, SettingsRepositoryErrors>> saveSettings(SettingsModel settings);
}