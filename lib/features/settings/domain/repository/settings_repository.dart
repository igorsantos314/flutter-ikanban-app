import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/settings/domain/errors/settings_repository_errors.dart';

abstract class SettingsRepository {
  Future<Outcome<bool, SettingsRepositoryErrors>> getIsDarkMode();
  Future<Outcome<void, SettingsRepositoryErrors>> setIsDarkMode(bool isDarkMode);
  
  Future<Outcome<String, SettingsRepositoryErrors>> getLanguage();
  Future<Outcome<void, SettingsRepositoryErrors>> setLanguage(String language);
}