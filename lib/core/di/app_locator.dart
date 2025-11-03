import 'package:flutter_ikanban_app/core/database/app_database.dart';
import 'package:flutter_ikanban_app/core/services/file/file_service.dart';
import 'package:flutter_ikanban_app/core/services/file/file_share_service.dart';
import 'package:flutter_ikanban_app/core/use_cases/theme/get_theme_use_case.dart';
import 'package:flutter_ikanban_app/core/use_cases/theme/set_theme_use_case.dart';
import 'package:flutter_ikanban_app/features/settings/domain/use_cases/load_settings_use_case.dart';
import 'package:flutter_ikanban_app/features/settings/domain/use_cases/save_settings_use_case.dart';
import 'package:flutter_ikanban_app/features/task/domain/use_cases/create_task_use_case.dart';
import 'package:flutter_ikanban_app/features/task/domain/use_cases/delete_task_use_case.dart';
import 'package:flutter_ikanban_app/features/task/domain/use_cases/get_task_by_id_use_case.dart';
import 'package:flutter_ikanban_app/features/task/domain/use_cases/list_task_use_case.dart';
import 'package:flutter_ikanban_app/features/task/domain/use_cases/update_task_use_case.dart';
import 'package:flutter_ikanban_app/shared/theme/presentation/theme_provider.dart';
import 'package:flutter_ikanban_app/features/settings/domain/use_cases/export_data_use_case.dart';
import 'package:flutter_ikanban_app/features/settings/domain/use_cases/import_data_use_case.dart';
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
  _setupCoreServices();
}

void _setupThemeModule() {
  getIt.registerLazySingleton<ThemeDataSource>(() => ThemeDataSource());

  getIt.registerLazySingleton<ThemeRepository>(
    () => ThemeRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<ThemeProvider>(() => ThemeProvider());
}

void _setupTaskModule() {
  getIt.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSource(getIt.get<AppDatabase>()),
  );

  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<CreateTaskUseCase>(
    () => CreateTaskUseCase(getIt()),
  );

  getIt.registerLazySingleton<UpdateTaskUseCase>(
    () => UpdateTaskUseCase(getIt()),
  );

  getIt.registerLazySingleton<GetTaskByIdUseCase>(
    () => GetTaskByIdUseCase(getIt()),
  );

  getIt.registerLazySingleton<ListTaskUseCase>(() => ListTaskUseCase(getIt()));

  getIt.registerLazySingleton<DeleteTaskUseCase>(
    () => DeleteTaskUseCase(getIt()),
  );
}

void _setupSettingsModule() {
  getIt.registerLazySingleton<SettingsDataSource>(() => SettingsDataSource());
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(themeRepository: getIt(), dataSource: getIt()),
  );

  getIt.registerLazySingleton<LoadSettingsUseCase>(
    () => LoadSettingsUseCase(settingsRepository: getIt()),
  );

  getIt.registerLazySingleton<SaveSettingsUseCase>(
    () => SaveSettingsUseCase(settingsRepository: getIt()),
  );
}

void _setupCoreServices() {
  // Backup/Restore Service
  getIt.registerLazySingleton<FileService>(() => FileService());

  getIt.registerLazySingleton<FileShareService>(() => FileShareService());

  // Theme Use Cases
  getIt.registerLazySingleton<SetThemeUseCase>(() => SetThemeUseCase(getIt()));

  getIt.registerLazySingleton<GetThemeUseCase>(() => GetThemeUseCase(getIt()));

  // Data Use Cases
  getIt.registerLazySingleton<ExportDataUseCase>(
    () => ExportDataUseCase(
      fileService: getIt(),
      fileShareService: getIt(),
      settingsRepository: getIt(),
      taskRepository: getIt(),
    ),
  );

  getIt.registerLazySingleton<ImportDataUseCase>(
    () => ImportDataUseCase(
      settingsRepository: getIt(),
      taskRepository: getIt(),
      fileService: getIt(),
      fileShareService: getIt(),
    ),
  );
}
