import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/settings/domain/errors/settings_repository_errors.dart';
import 'package:flutter_ikanban_app/features/settings/domain/repository/settings_repository.dart';
import 'package:flutter_ikanban_app/features/settings/infra/settings_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDataSource dataSource;
  
  SettingsRepositoryImpl({required this.dataSource});

  @override
  Future<Outcome<bool, SettingsRepositoryErrors>> getIsDarkMode() {
    // TODO: implement getIsDarkMode
    throw UnimplementedError();
  }

  @override
  Future<Outcome<String, SettingsRepositoryErrors>> getLanguage() {
    // TODO: implement getLanguage
    throw UnimplementedError();
  }

  @override
  Future<Outcome<void, SettingsRepositoryErrors>> setIsDarkMode(bool isDarkMode) {
    // TODO: implement setIsDarkMode
    throw UnimplementedError();
  }

  @override
  Future<Outcome<void, SettingsRepositoryErrors>> setLanguage(String language) {
    // TODO: implement setLanguage
    throw UnimplementedError();
  }

}