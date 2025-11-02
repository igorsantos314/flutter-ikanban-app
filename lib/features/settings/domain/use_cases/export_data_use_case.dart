import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_ikanban_app/core/services/file/file_service.dart';
import 'package:flutter_ikanban_app/core/services/file/file_share_service.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/settings/domain/repository/settings_repository.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';

/// Caso de uso responsável por exportar todos os dados do app
/// Segue os princípios da Clean Architecture não dependendo de features específicas
class ExportDataUseCase {
  final SettingsRepository _settingsRepository;
  final TaskRepository _taskRepository;
  final FileService _fileService;
  final FileShareService _fileShareService;

  const ExportDataUseCase({
    required SettingsRepository settingsRepository,
    required TaskRepository taskRepository,
    required FileService fileService,
    required FileShareService fileShareService,
  })  : _settingsRepository = settingsRepository,
        _taskRepository = taskRepository,
        _fileService = fileService,
        _fileShareService = fileShareService;

  /// Exporta todos os dados do aplicativo
  /// 
  /// Parameters:
  /// - [shareAfterExport]: Se true, abre dialog de compartilhamento após exportar
  /// 
  /// Returns:
  /// - Success: ExportResult com caminho do arquivo e informações
  /// - Failure: Erro ocorrido durante a exportação
  Future<Outcome<ExportResult, ExportDataError>> execute({
    bool shareAfterExport = false,
  }) async {
    try {
      // 1. Buscar configurações
      final settingsOutcome = await _settingsRepository.loadSettings();
      
      Map<String, dynamic>? settingsData;
      settingsOutcome.when(
        success: (settings) {
          settingsData = {
            'theme': 'light', // Placeholder - adaptar conforme modelo
            'language': 'pt-BR',
          };
        },
        failure: (error, message, throwable) {
          settingsData = null; // Continue sem settings se não conseguir carregar
        },
      );

      // 2. Buscar tarefas
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
            tasksData = resultPage.items.map((task) => {
              'id': task.id,
              'title': task.title,
              'description': task.description,
              'status': task.status.name,
              'priority': task.priority.name,
              'complexity': task.complexity.name,
              'type': task.type.name,
              'dueDate': task.dueDate?.toIso8601String(),
              'isActive': task.isActive,
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
        'metadata': {
          'exportedBy': 'iKanban Flutter App',
          'platform': 'mobile/desktop',
          'dataVersion': '1.0',
        }
      };

      // 4. Converter para JSON
      final jsonData = const JsonEncoder.withIndent('  ').convert(exportData);

      // 5. Salvar arquivo usando FileService
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'ikanban_backup_$timestamp.json';
      
      final fileOutcome = await _fileService.saveFile(
        fileName: fileName,
        content: jsonData,
      );

      return await fileOutcome.when(
        success: (file) async {
          // 6. Copiar para clipboard como backup
          await Clipboard.setData(ClipboardData(text: jsonData));

          // 7. Compartilhar se solicitado
          if (shareAfterExport && _fileShareService.canShare) {
            final shareOutcome = await _fileShareService.shareFile(
              filePath: file!.path,
              subject: 'Backup iKanban - $fileName',
              text: 'Backup dos dados do iKanban criado em ${DateTime.now().toString()}',
            );
            
            // Se o compartilhamento falhar, não é erro crítico
            shareOutcome.when(
              success: (_) {},
              failure: (error, message, throwable) {
                // Log do erro mas continue
                print('Aviso: Falha no compartilhamento: $message');
              },
            );
          }

          final result = ExportResult(
            filePath: file!.path,
            fileName: fileName,
            fileSize: jsonData.length,
            tasksCount: totalTasks,
            hasSettings: settingsData != null,
            shareAttempted: shareAfterExport,
          );

          return Outcome.success(value: result);
        },
        failure: (error, message, throwable) async {
          return Outcome.failure(
            error: ExportDataError.fileSaveFailed,
            message: message ?? 'Erro ao salvar arquivo de backup',
            throwable: throwable,
          );
        },
      );
    } catch (e) {
      return Outcome.failure(
        error: ExportDataError.unexpectedError,
        message: 'Erro inesperado durante a exportação: ${e.toString()}',
        throwable: e,
      );
    }
  }
}

/// Resultado da exportação
class ExportResult {
  final String filePath;
  final String fileName;
  final int fileSize;
  final int tasksCount;
  final bool hasSettings;
  final bool shareAttempted;

  const ExportResult({
    required this.filePath,
    required this.fileName,
    required this.fileSize,
    required this.tasksCount,
    required this.hasSettings,
    required this.shareAttempted,
  });

  String get formattedSize {
    if (fileSize < 1024) return '${fileSize}B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)}KB';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  String get summary => 
      '$tasksCount tarefas exportadas • ${formattedSize}';
}

/// Erros possíveis durante a exportação
enum ExportDataError {
  settingsLoadFailed,
  tasksLoadFailed,
  fileWriteFailed,
  fileSaveFailed,
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
      case ExportDataError.fileSaveFailed:
        return 'Falha ao salvar arquivo';
      case ExportDataError.unexpectedError:
        return 'Erro inesperado';
    }
  }
}