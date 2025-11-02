import 'dart:convert';
import 'dart:io';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/settings/domain/repository/settings_repository.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';

/// Caso de uso responsável por importar dados para o app
/// Segue os princípios da Clean Architecture não dependendo de features específicas
class ImportDataUseCase {
  final SettingsRepository _settingsRepository;
  final TaskRepository _taskRepository;

  const ImportDataUseCase({
    required SettingsRepository settingsRepository,
    required TaskRepository taskRepository,
  })  : _settingsRepository = settingsRepository,
        _taskRepository = taskRepository;

  /// Importa dados de um arquivo JSON
  /// 
  /// Parameters:
  /// - [filePath]: Caminho do arquivo a ser importado
  /// 
  /// Returns:
  /// - Success: Número de itens importados
  /// - Failure: Erro ocorrido durante a importação
  Future<Outcome<ImportResult, ImportDataError>> execute(String filePath) async {
    try {
      // 1. Ler arquivo
      final file = File(filePath);
      if (!await file.exists()) {
        return Outcome.failure(
          error: ImportDataError.fileNotFound,
          message: 'Arquivo não encontrado: $filePath',
        );
      }

      final jsonString = await file.readAsString();
      final Map<String, dynamic> data;
      
      try {
        data = json.decode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        return Outcome.failure(
          error: ImportDataError.invalidJsonFormat,
          message: 'Formato JSON inválido',
          throwable: e,
        );
      }

      // 2. Validar estrutura básica
      if (!_isValidBackupFile(data)) {
        return Outcome.failure(
          error: ImportDataError.invalidBackupFormat,
          message: 'Formato de backup inválido',
        );
      }

      int importedTasks = 0;
      bool settingsImported = false;

      // 3. Importar configurações (se existir)
      if (data.containsKey('settings') && data['settings'] != null) {
        // Implementar importação de settings
        // final settingsResult = await _importSettings(data['settings']);
        // if (settingsResult.isSuccess) {
        //   settingsImported = true;
        // }
        settingsImported = true; // Placeholder
      }

      // 4. Importar tarefas (se existir)
      if (data.containsKey('tasks') && data['tasks'] is List) {
        final tasksData = data['tasks'] as List;
        for (final taskData in tasksData) {
          try {
            // TODOImplementar criação de tarefa a partir do JSON
            // final task = TaskModel.fromJson(taskData);
            // final result = await _taskRepository.createTask(task);
            // if (result.isSuccess) {
            //   importedTasks++;
            // }
            importedTasks++; // Placeholder
          } catch (e) {
            // Continue importando outras tarefas mesmo se uma falhar
            continue;
          }
        }
      }

      return Outcome.success(
        value: ImportResult(
          tasksImported: importedTasks,
          settingsImported: settingsImported,
        ),
      );
    } catch (e) {
      return Outcome.failure(
        error: ImportDataError.unexpectedError,
        message: 'Erro inesperado durante a importação: ${e.toString()}',
        throwable: e,
      );
    }
  }

  /// Valida se o arquivo tem a estrutura básica esperada
  bool _isValidBackupFile(Map<String, dynamic> data) {
    return data.containsKey('app') &&
           data.containsKey('version') &&
           data.containsKey('exportDate') &&
           (data.containsKey('settings') || data.containsKey('tasks'));
  }
}

/// Resultado da importação
class ImportResult {
  final int tasksImported;
  final bool settingsImported;

  const ImportResult({
    required this.tasksImported,
    required this.settingsImported,
  });

  int get totalImported => tasksImported + (settingsImported ? 1 : 0);
}

/// Erros possíveis durante a importação
enum ImportDataError {
  fileNotFound,
  invalidJsonFormat,
  invalidBackupFormat,
  settingsImportFailed,
  tasksImportFailed,
  unexpectedError,
}

/// Extensão para facilitar o uso dos erros
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
      case ImportDataError.unexpectedError:
        return 'Erro inesperado';
    }
  }
}