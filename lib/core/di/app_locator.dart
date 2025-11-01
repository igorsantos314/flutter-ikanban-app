import 'package:flutter_ikanban_app/core/database/app_database.dart';
import 'package:flutter_ikanban_app/features/settings/data/settings_repository_impl.dart';
import 'package:flutter_ikanban_app/features/settings/domain/repository/settings_repository.dart';
import 'package:flutter_ikanban_app/features/settings/infra/settings_data_source.dart';
import 'package:flutter_ikanban_app/features/task/data/task_repository_impl.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';
import 'package:flutter_ikanban_app/features/task/infra/local/task_local_data_source.dart';
import 'package:flutter_ikanban_app/shared/theme/data/theme_repository_impl.dart';
import 'package:flutter_ikanban_app/shared/theme/infra/theme_data_source.dart';
import 'package:flutter_ikanban_app/shared/theme/repository/theme_repository.dart';
import 'package:get_it/get_it.dart';

// Dependency Injection
final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  _setupThemeModule();

  _setupTaskModule();
  _setupSettingsModule();
}

void _setupThemeModule() {
  getIt.registerLazySingleton<ThemeDataSource>(
    () => ThemeDataSource(),
  );

  getIt.registerLazySingleton<ThemeRepository>(
    () => ThemeRepositoryImpl(getIt()),
  );
}

void _setupTaskModule() {
  getIt.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSource(getIt.get<AppDatabase>()),
  );

  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(getIt()),
  );
}

void _setupSettingsModule() {
  getIt.registerLazySingleton<SettingsDataSource>(() => SettingsDataSource());
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      themeRepository: getIt(),
      dataSource: getIt(),
    ),
  );
}
