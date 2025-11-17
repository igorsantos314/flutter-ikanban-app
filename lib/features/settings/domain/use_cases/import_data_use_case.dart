import 'dart:convert';
import 'dart:developer';
import 'package:flutter_ikanban_app/core/services/file/file_service.dart';
import 'package:flutter_ikanban_app/core/services/file/file_share_service.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/settings/domain/repository/settings_repository.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';
import 'package:flutter_ikanban_app/features/task/presentation/colors/task_colors.dart';

class ImportDataUseCase {
  final TaskRepository _taskRepository;
  final FileService _fileService;
  final FileShareService _fileShareService;

  const ImportDataUseCase({
    required SettingsRepository settingsRepository,
    required TaskRepository taskRepository,
    required FileService fileService,
    required FileShareService fileShareService,
  }) : _taskRepository = taskRepository,
       _fileService = fileService,
       _fileShareService = fileShareService;

  Future<Outcome<ImportResult, ImportDataError>> executeWithFilePicker() async {
    try {
      final filePickerOutcome = await _fileShareService.pickFile(
        allowedExtensions: ['json'],
        dialogTitle: 'Selecione o arquivo de backup',
      );

      return await filePickerOutcome.when(
        success: (filePath) async {
          if (filePath != null) {
            return await executeFromFile(filePath);
          } else {
            return Outcome.failure(
              error: ImportDataError.fileNotFound,
              message: 'Nenhum arquivo selecionado',
            );
          }
        },
        failure: (error, message, throwable) async {
          if (error.isUserCancellation) {
            return Outcome.failure(
              error: ImportDataError.userCancelled,
              message: 'Seleção cancelada pelo usuário',
            );
          }
          return Outcome.failure(
            error: ImportDataError.fileSelectionFailed,
            message: message ?? 'Erro ao selecionar arquivo',
            throwable: throwable,
          );
        },
      );
    } catch (e) {
      return Outcome.failure(
        error: ImportDataError.unexpectedError,
        message: 'Erro inesperado: ${e.toString()}',
        throwable: e,
      );
    }
  }

  Future<Outcome<ImportResult, ImportDataError>> executeFromFile(
    String filePath,
  ) async {
    try {
      final fileReadOutcome = await _fileService.readFile(filePath);

      return await fileReadOutcome.when(
        success: (fileContent) async {
          final Map<String, dynamic> data;

          try {
            data = jsonDecode(fileContent ?? '') as Map<String, dynamic>;
          } catch (e) {
            return Outcome.failure(
              error: ImportDataError.invalidJsonFormat,
              message: 'Formato JSON inválido: ${e.toString()}',
              throwable: e,
            );
          }

          if (!_isValidBackupFile(data)) {
            return Outcome.failure(
              error: ImportDataError.invalidBackupFormat,
              message: 'Formato de backup inválido',
            );
          }

          int tasksImported = 0;
          bool settingsImported = false;

          if (data.containsKey('tasks')) {
            try {
              final tasksData = data['tasks'] as List<dynamic>;
              log("Importing ${tasksData.length} tasks");

              final tasks = tasksData.map((taskJson) {
                  final taskMap = taskJson as Map<String, dynamic>;
                  return TaskModel(
                    id: taskMap['id'] as int?,
                    title: taskMap['title'] as String,
                    description: taskMap['description'] as String?,
                    status: TaskStatus.values.firstWhere(
                      (e) => e.toString() == 'TaskStatus.${taskMap['status']}',
                      orElse: () => TaskStatus.backlog,
                    ),
                    priority: TaskPriority.values.firstWhere(
                      (e) =>
                          e.toString() == 'TaskPriority.${taskMap['priority']}',
                      orElse: () => TaskPriority.medium,
                    ),
                    complexity: TaskComplexity.values.firstWhere(
                      (e) =>
                          e.toString() ==
                          'TaskComplexity.${taskMap['complexity']}',
                      orElse: () => TaskComplexity.medium,
                    ),
                    type: TaskType.values.firstWhere(
                      (e) => e.toString() == 'TaskType.${taskMap['type']}',
                      orElse: () => TaskType.feature,
                    ),
                    isActive: taskMap['isActive'] as bool? ?? true,
                    color: TaskColors.values.firstWhere(
                      (e) => e.toString() == 'TaskColors.${taskMap['color']}',
                      orElse: () => TaskColors.defaultColor,
                    ),
                    dueDate: taskMap['dueDate'] != null
                        ? DateTime.parse(taskMap['dueDate'] as String)
                        : null,
                    createdAt: taskMap['createdAt'] != null
                        ? DateTime.parse(taskMap['createdAt'] as String)
                        : DateTime.now(),
                  );
                }).toList();

              final result = await _taskRepository.createTasks(
                tasks,
              );

              result.when(success: (value) {
                tasksImported = tasksData.length;
              }, failure: (error, message, throwable) {
                log('Error importing tasks: $message throwable: $throwable');
              },);
            } catch (e) {
              return Outcome.failure(
                error: ImportDataError.tasksImportFailed,
                message: 'Erro ao importar tarefas: ${e.toString()}',
                throwable: e,
              );
            }
          }

          return Outcome.success(
            value: ImportResult(
              tasksImported: tasksImported,
              settingsImported: settingsImported,
            ),
          );
        },
        failure: (error, message, throwable) async {
          return Outcome.failure(
            error: ImportDataError.fileNotFound,
            message: message ?? 'Erro ao ler arquivo: $filePath',
            throwable: throwable,
          );
        },
      );
    } catch (e) {
      return Outcome.failure(
        error: ImportDataError.unexpectedError,
        message: 'Erro inesperado durante a importação: ${e.toString()}',
        throwable: e,
      );
    }
  }

  bool _isValidBackupFile(Map<String, dynamic> data) {
    return data.containsKey('app') &&
        data.containsKey('version') &&
        data.containsKey('exportDate') &&
        (data.containsKey('settings') || data.containsKey('tasks'));
  }
}

class ImportResult {
  final int tasksImported;
  final bool settingsImported;

  const ImportResult({
    required this.tasksImported,
    required this.settingsImported,
  });

  int get totalImported => tasksImported + (settingsImported ? 1 : 0);
}

enum ImportDataError {
  fileNotFound,
  invalidJsonFormat,
  invalidBackupFormat,
  settingsImportFailed,
  tasksImportFailed,
  userCancelled,
  fileSelectionFailed,
  unexpectedError,
}

extension ImportDataErrorExtension on ImportDataError {
  String get message {
    switch (this) {
      case ImportDataError.fileNotFound:
        return 'Arquivo não encontrado';
      case ImportDataError.invalidJsonFormat:
        return 'Formato JSON inválido';
      case ImportDataError.invalidBackupFormat:
        return 'Formato de backup inválido';
      case ImportDataError.settingsImportFailed:
        return 'Falha ao importar configurações';
      case ImportDataError.tasksImportFailed:
        return 'Falha ao importar tarefas';
      case ImportDataError.userCancelled:
        return 'Operação cancelada pelo usuário';
      case ImportDataError.fileSelectionFailed:
        return 'Falha ao selecionar arquivo';
      case ImportDataError.unexpectedError:
        return 'Erro inesperado';
    }
  }
}
