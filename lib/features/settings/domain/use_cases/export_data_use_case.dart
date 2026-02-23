import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_ikanban_app/core/services/file/file_service.dart';
import 'package:flutter_ikanban_app/core/services/file/file_share_service.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/settings/domain/repository/settings_repository.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';

class ExportDataUseCase {
  final TaskRepository _taskRepository;
  final FileService _fileService;
  final FileShareService _fileShareService;

  const ExportDataUseCase({
    required SettingsRepository settingsRepository,
    required TaskRepository taskRepository,
    required FileService fileService,
    required FileShareService fileShareService,
  }) : _taskRepository = taskRepository,
       _fileService = fileService,
       _fileShareService = fileShareService;

  Future<Outcome<ExportResult, ExportDataError>> execute({
    bool shareAfterExport = false,
  }) async {
    try {
      List<Map<String, dynamic>> tasksData = [];
      int totalTasks = 0;
      int currentPage = 1;
      const int pageSize = 100;
      bool hasMorePages = true;

      while (hasMorePages) {
        final tasksStream = _taskRepository.watchTasks(
          boardId: 0, // 0 = exportar tarefas de todos os boards
          page: currentPage,
          limitPerPage: pageSize,
          onlyActive: false,
        );

        final tasksOutcome = await tasksStream.first;

        final success = tasksOutcome.when(
          success: (resultPage) {
            if (resultPage != null) {
              // Adds the tasks from the current page to the complete list
              final pageTasksData = resultPage.items
                  .map(
                    (task) => {
                      'id': task.id,
                      'title': task.title,
                      'description': task.description,
                      'status': task.status.name,
                      'priority': task.priority.name,
                      'complexity': task.complexity.name,
                      'type': task.type.name,
                      'dueDate': task.dueDate?.toIso8601String(),
                      'isActive': task.isActive,
                      'createdAt': task.createdAt
                          .toIso8601String(), // Adds creation timestamp
                      'color': task.color.name, // Adds task color
                    },
                  )
                  .toList();

              tasksData.addAll(pageTasksData);
              totalTasks = resultPage.totalItems;

              // Check if there are more pages
              final totalPages = (totalTasks / pageSize).ceil();
              hasMorePages =
                  currentPage < totalPages && resultPage.items.isNotEmpty;

              log(
                'Page $currentPage of $totalPages loaded - ${resultPage.items.length} tasks',
              );

              return true;
            }
            return false;
          },
          failure: (error, message, throwable) {
            log('Error loading page $currentPage: $message');
            return false;
          },
        );

        if (!success) {
          return Outcome.failure(
            error: ExportDataError.tasksLoadFailed,
            message: 'Erro ao carregar tarefas na página $currentPage',
          );
        }

        currentPage++;

        // Proteção contra loop infinito
        if (currentPage > 1000) {
          log('Limite de páginas atingido (1000) - interrompendo busca');
          break;
        }
      }

      log(
        'Exportação completa: ${tasksData.length} de $totalTasks tarefas carregadas',
      );

      final exportData = {
        'app': 'iKanban',
        'version': '1.0.0+1',
        'exportDate': DateTime.now().toIso8601String(),
        'tasks': tasksData,
        'totalTasks': totalTasks,
        'exportedTasks': tasksData.length,
        'metadata': {
          'exportedBy': 'iKanban Flutter App',
          'platform': 'mobile/desktop',
          'dataVersion': '1.0',
          'paginationInfo': {
            'pageSize': pageSize,
            'totalPages': currentPage - 1,
            'isComplete': tasksData.length == totalTasks,
          },
        },
      };

      final jsonData = const JsonEncoder.withIndent('  ').convert(exportData);

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'ikanban_backup_$timestamp.json';

      final fileOutcome = await _fileService.saveFile(
        fileName: fileName,
        content: jsonData,
      );

      return await fileOutcome.when(
        success: (file) async {
          await Clipboard.setData(ClipboardData(text: jsonData));

          if (shareAfterExport && _fileShareService.canShare) {
            final shareOutcome = await _fileShareService.shareFile(
              filePath: file!.path,
              subject: 'Backup iKanban - $fileName',
              text:
                  'Backup dos dados do iKanban criado em ${DateTime.now().toString()}',
            );

            shareOutcome.when(
              success: (_) {},
              failure: (error, message, throwable) {
                log('Aviso: Falha no compartilhamento: $message');
              },
            );
          }

          final result = ExportResult(
            filePath: file!.path,
            fileName: fileName,
            fileSize: jsonData.length,
            tasksCount: tasksData.length,
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
  final bool shareAttempted;

  const ExportResult({
    required this.filePath,
    required this.fileName,
    required this.fileSize,
    required this.tasksCount,
    required this.shareAttempted,
  });

  String get formattedSize {
    if (fileSize < 1024) return '${fileSize}B';
    if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)}KB';
    }
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
  
  String get summary => '$tasksCount tasks exported • $formattedSize';
}

enum ExportDataError {
  settingsLoadFailed,
  tasksLoadFailed,
  fileWriteFailed,
  fileSaveFailed,
  unexpectedError,
}

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
