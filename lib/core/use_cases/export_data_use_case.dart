import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/settings/domain/repository/settings_repository.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';
import 'package:path_provider/path_provider.dart';

/// Caso de uso responsável por exportar todos os dados do app
/// Segue os princípios da Clean Architecture não dependendo de features específicas
class ExportDataUseCase {
  final SettingsRepository _settingsRepository;
  final TaskRepository _taskRepository;

  const ExportDataUseCase({
    required SettingsRepository settingsRepository,
    required TaskRepository taskRepository,
  })  : _settingsRepository = settingsRepository,
        _taskRepository = taskRepository;

  /// Exporta todos os dados do aplicativo
  /// 
  /// Returns:
  /// - Success: Caminho do arquivo exportado
  /// - Failure: Erro ocorrido durante a exportação
  Future<Outcome<String, ExportDataError>> execute() async {
    try {
      // 1. Buscar configurações
      final settingsOutcome = await _settingsRepository.loadSettings();
      
      Map<String, dynamic>? settingsData;
      settingsOutcome.when(
        success: (settings) {
          // settingsData = settings?.toJson();
          settingsData = {
            'theme': 'light', // Placeholder - adaptar conforme modelo
            'language': 'pt-BR',
          };
        },
        failure: (error, message, throwable) {
          // Continue sem settings se não conseguir carregar
          settingsData = null;
        },
      );

      // 2. Buscar tarefas (primeira página para exemplo - em produção seria paginado)
      final tasksStream = _taskRepository.watchTasks(
        page: 1,
        limitPerPage: 1000, // Em produção, implementar paginação
        onlyActive: false, // Incluir todas as tarefas
      );

      final tasksOutcome = await tasksStream.first;
      
      List<Map<String, dynamic>> tasksData = [];
      int totalTasks = 0;
      
      tasksOutcome.when(
        success: (resultPage) {
          if (resultPage != null) {
            // tasksData = resultPage.items.map((task) => task.toJson()).toList();
            // Placeholder - adaptar conforme modelo TaskModel
            tasksData = resultPage.items.map((task) => {
              'id': task.id,
              'title': task.title,
              'description': task.description,
              'status': task.status.name,
              'priority': task.priority.name,
              'createdAt': DateTime.now().toIso8601String(),
            }).toList();
            totalTasks = resultPage.totalItems;
          }
        },
        failure: (error, message, throwable) {
          return Outcome.failure(
            error: ExportDataError.tasksLoadFailed,
            message: 'Erro ao carregar tarefas: $message',
            throwable: throwable,
          );
        },
      );

      // 3. Montar dados para exportação
      final exportData = {
        'app': 'iKanban',
        'version': '1.0.0+1',
        'exportDate': DateTime.now().toIso8601String(),
        'settings': settingsData,
        'tasks': tasksData,
        'totalTasks': totalTasks,
      };

      // 4. Converter para JSON
      final jsonData = const JsonEncoder.withIndent('  ').convert(exportData);

      // 5. Salvar arquivo
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'ikanban_backup_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(jsonData);

      // 6. Copiar para clipboard como backup
      await Clipboard.setData(ClipboardData(text: jsonData));

      return Outcome.success(value: file.path);
    } catch (e) {
      return Outcome.failure(
        error: ExportDataError.unexpectedError,
        message: 'Erro inesperado durante a exportação: ${e.toString()}',
        throwable: e,
      );
    }
  }
}

/// Erros possíveis durante a exportação
enum ExportDataError {
  settingsLoadFailed,
  tasksLoadFailed,
  fileWriteFailed,
  unexpectedError,
}

/// Extensão para facilitar o uso dos erros
extension ExportDataErrorExtension on ExportDataError {
  String get message {
    switch (this) {
      case ExportDataError.settingsLoadFailed:
        return 'Falha ao carregar configurações';
      case ExportDataError.tasksLoadFailed:
        return 'Falha ao carregar tarefas';
      case ExportDataError.fileWriteFailed:
        return 'Falha ao escrever arquivo';
      case ExportDataError.unexpectedError:
        return 'Erro inesperado';
    }
  }
}