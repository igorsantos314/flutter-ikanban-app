import 'dart:convert';
import 'package:flutter_ikanban_app/core/services/file/file_service.dart';
import 'package:flutter_ikanban_app/core/services/file/file_share_service.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/settings/domain/repository/settings_repository.dart';
import 'package:flutter_ikanban_app/features/settings/domain/model/settings_model.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';
import 'package:flutter_ikanban_app/shared/theme/presentation/theme_enum.dart';

/// Caso de uso responsável por importar dados para o app
/// Segue os princípios da Clean Architecture não dependendo de features específicas
class ImportDataUseCase {
  final SettingsRepository _settingsRepository;
  final TaskRepository _taskRepository;
  final FileService _fileService;
  final FileShareService _fileShareService;

  const ImportDataUseCase({
    required SettingsRepository settingsRepository,
    required TaskRepository taskRepository,
    required FileService fileService,
    required FileShareService fileShareService,
  })  : _settingsRepository = settingsRepository,
        _taskRepository = taskRepository,
        _fileService = fileService,
        _fileShareService = fileShareService;

  /// Permite ao usuário selecionar um arquivo e importa os dados
  /// 
  /// Returns:
  /// - Success: Resultado da importação
  /// - Failure: Erro ocorrido durante a seleção ou importação
  Future<Outcome<ImportResult, ImportDataError>> executeWithFilePicker() async {
    try {
      // 1. Permitir que o usuário selecione um arquivo
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

  /// Importa dados de um arquivo JSON específico
  /// 
  /// Parameters:
  /// - [filePath]: Caminho do arquivo a ser importado
  /// 
  /// Returns:
  /// - Success: Resultado da importação
  /// - Failure: Erro ocorrido durante a importação
  Future<Outcome<ImportResult, ImportDataError>> executeFromFile(String filePath) async {
    try {
      // 1. Ler o arquivo usando o FileService
      final fileReadOutcome = await _fileService.readFile(filePath);
      
      return await fileReadOutcome.when(
        success: (fileContent) async {
          // 2. Decodificar o arquivo JSON
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

          // 3. Validar estrutura do backup
          if (!_isValidBackupFile(data)) {
            return Outcome.failure(
              error: ImportDataError.invalidBackupFormat,
              message: 'Formato de backup inválido',
            );
          }

          // 4. Importar dados
          int tasksImported = 0;
          bool settingsImported = false;

          // 4a. Importar configurações se existirem
          if (data.containsKey('settings')) {
            try {
              final settingsData = data['settings'] as Map<String, dynamic>;
              
              // Carregar configurações atuais
              final currentSettingsOutcome = await _settingsRepository.loadSettings();
              
              await currentSettingsOutcome.when(
                success: (currentSettings) async {
                  final newSettings = SettingsModel(
                    appTheme: _parseTheme(settingsData['theme'] as String?),
                    language: settingsData['language'] as String? ?? (currentSettings?.language ?? 'pt'),
                    appVersion: currentSettings?.appVersion ?? '1.0.0',
                  );
                  
                  await _settingsRepository.saveSettings(newSettings);
                },
                failure: (error, message, throwable) async {
                  // Se não conseguir carregar as configurações atuais, usar valores padrão
                  final newSettings = SettingsModel(
                    appTheme: _parseTheme(settingsData['theme'] as String?),
                    language: settingsData['language'] as String? ?? 'pt',
                    appVersion: '1.0.0',
                  );
                  
                  await _settingsRepository.saveSettings(newSettings);
                },
              );
              
              settingsImported = true;
            } catch (e) {
              return Outcome.failure(
                error: ImportDataError.settingsImportFailed,
                message: 'Erro ao importar configurações: ${e.toString()}',
                throwable: e,
              );
            }
          }

          // 4b. Importar tarefas se existirem
          if (data.containsKey('tasks')) {
            try {
              final tasksData = data['tasks'] as List<dynamic>;
              
              // Processar cada tarefa
              // TODO: Implementar Task.fromJson e _taskRepository.createTask
              // for (final taskJson in tasksData) {
              //   final taskData = taskJson as Map<String, dynamic>;
              //   final task = Task.fromJson(taskData);
              //   await _taskRepository.createTask(task);
              // }
              
              // Por enquanto, apenas contamos as tarefas
              tasksImported = tasksData.length;
            } catch (e) {
              return Outcome.failure(
                error: ImportDataError.tasksImportFailed,
                message: 'Erro ao importar tarefas: ${e.toString()}',
                throwable: e,
              );
            }
          }

          // 5. Retornar resultado
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

  /// Valida se o arquivo tem a estrutura básica esperada
  bool _isValidBackupFile(Map<String, dynamic> data) {
    return data.containsKey('app') &&
           data.containsKey('version') &&
           data.containsKey('exportDate') &&
           (data.containsKey('settings') || data.containsKey('tasks'));
  }
  
  /// Converte string do tema para AppTheme enum
  AppTheme _parseTheme(String? themeString) {
    if (themeString == null) return AppTheme.system;
    
    switch (themeString.toLowerCase()) {
      case 'light':
        return AppTheme.light;
      case 'dark':
        return AppTheme.dark;
      case 'system':
      default:
        return AppTheme.system;
    }
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
  userCancelled,
  fileSelectionFailed,
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
      case ImportDataError.userCancelled:
        return 'Operação cancelada pelo usuário';
      case ImportDataError.fileSelectionFailed:
        return 'Falha ao selecionar arquivo';
      case ImportDataError.unexpectedError:
        return 'Erro inesperado';
    }
  }
}