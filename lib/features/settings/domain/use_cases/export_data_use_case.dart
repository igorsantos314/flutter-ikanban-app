import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_ikanban_app/core/services/file/file_service.dart';
import 'package:flutter_ikanban_app/core/services/file/file_share_service.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/board/domain/repository/board_repository.dart';
import 'package:flutter_ikanban_app/features/settings/domain/repository/settings_repository.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';

class ExportDataUseCase {
  final TaskRepository _taskRepository;
  final BoardRepository _boardRepository;
  final SettingsRepository _settingsRepository;
  final FileService _fileService;
  final FileShareService _fileShareService;

  const ExportDataUseCase({
    required SettingsRepository settingsRepository,
    required TaskRepository taskRepository,
    required BoardRepository boardRepository,
    required FileService fileService,
    required FileShareService fileShareService,
  }) : _taskRepository = taskRepository,
       _boardRepository = boardRepository,
       _settingsRepository = settingsRepository,
       _fileService = fileService,
       _fileShareService = fileShareService;

  Future<Outcome<ExportResult, ExportDataError>> execute({
    bool shareAfterExport = false,
  }) async {
    try {
      // Export Tasks
      log('Starting tasks export...');
      final tasksOutcome = await _taskRepository.getAllTasks();
      
      List<Map<String, dynamic>> tasksData = [];
      tasksOutcome.when(
        success: (tasks) {
          if (tasks != null) {
            tasksData = tasks
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
                    'createdAt': task.createdAt.toIso8601String(),
                    'color': task.color.name,
                    'boardId': task.boardId,
                  },
                )
                .toList();
            log('Tasks exported: ${tasksData.length}');
          }
        },
        failure: (error, message, throwable) {
          log('Error loading tasks: $message');
        },
      );

      // Export Boards
      log('Starting boards export...');
      final boardsOutcome = await _boardRepository.getAllBoards();
      
      List<Map<String, dynamic>> boardsData = [];
      boardsOutcome.when(
        success: (boards) {
          if (boards != null) {
            boardsData = boards
                .map(
                  (board) => {
                    'id': board.id,
                    'title': board.title,
                    'description': board.description,
                    'color': board.color,
                    'createdAt': board.createdAt.toIso8601String(),
                    'updatedAt': board.updatedAt.toIso8601String(),
                    'isActive': board.isActive,
                  },
                )
                .toList();
            log('Boards exported: ${boardsData.length}');
          }
        },
        failure: (error, message, throwable) {
          log('Error loading boards: $message');
        },
      );

      // Export Settings
      log('Starting settings export...');
      final settingsOutcome = await _settingsRepository.loadSettings();
      
      Map<String, dynamic>? settingsData;
      settingsOutcome.when(
        success: (settings) {
          if (settings != null) {
            settingsData = {
              'appTheme': settings.appTheme.name,
              'language': settings.language,
              'appVersion': settings.appVersion,
            };
            log('Settings exported');
          }
        },
        failure: (error, message, throwable) {
          log('Error loading settings: $message');
        },
      );

      final exportData = {
        'app': 'iKanban',
        'version': '1.0.0+1',
        'exportDate': DateTime.now().toIso8601String(),
        'tasks': tasksData,
        'boards': boardsData,
        'settings': settingsData,
        'metadata': {
          'exportedBy': 'iKanban Flutter App',
          'platform': 'mobile/desktop',
          'dataVersion': '1.0',
          'totalTasks': tasksData.length,
          'totalBoards': boardsData.length,
          'hasSettings': settingsData != null,
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
            boardsCount: boardsData.length,
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
  final int boardsCount;
  final bool hasSettings;
  final bool shareAttempted;

  const ExportResult({
    required this.filePath,
    required this.fileName,
    required this.fileSize,
    required this.tasksCount,
    required this.boardsCount,
    required this.hasSettings,
    required this.shareAttempted,
  });

  String get formattedSize {
    if (fileSize < 1024) return '${fileSize}B';
    if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)}KB';
    }
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
  
  String get summary => '$tasksCount tasks, $boardsCount boards • $formattedSize';
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
