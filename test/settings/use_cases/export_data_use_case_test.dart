import 'package:flutter_ikanban_app/features/settings/domain/use_cases/export_data_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

// Nota: Os testes de integração completos para ExportDataUseCase são complexos
// pois dependem de múltiplos serviços (FileService, FileShareService, TaskRepository, etc.)
// Aqui testamos apenas as funcionalidades unitárias e de formatação.

void main() {
  group('ExportDataUseCase', () {
    group('ExportResult', () {
      test('should format file size correctly for bytes', () {
        final result = ExportResult(
          boardsCount: 5,
          hasSettings: true,
          filePath: '/path/to/file',
          fileName: 'backup.json',
          fileSize: 512,
          tasksCount: 10,
          shareAttempted: false,
        );
        expect(result.formattedSize, '512B');
      });

      test('should format file size correctly for KB', () {
        final result = ExportResult(
          boardsCount: 5,
          hasSettings: true,
          filePath: '/path/to/file',
          fileName: 'backup.json',
          fileSize: 2048,
          tasksCount: 10,
          shareAttempted: false,
        );
        expect(result.formattedSize, '2.0KB');
      });

      test('should format file size correctly for MB', () {
        final result = ExportResult(
          boardsCount: 5,
          hasSettings: true,
          filePath: '/path/to/file',
          fileName: 'backup.json',
          fileSize: 2097152,
          tasksCount: 10,
          shareAttempted: false,
        );
        expect(result.formattedSize, '2.0MB');
      });

      test('should create correct summary', () {
        final result = ExportResult(
          boardsCount: 5,
          hasSettings: true,
          filePath: '/path/to/file',
          fileName: 'backup.json',
          fileSize: 1024,
          tasksCount: 42,
          shareAttempted: false,
        );
        expect(result.summary, '42 tasks, 5 boards • 1.0KB');
      });

      test('should have correct file path', () {
        final result = ExportResult(
          boardsCount: 5,
          hasSettings: true,
          filePath: '/storage/backups/backup.json',
          fileName: 'backup.json',
          fileSize: 1024,
          tasksCount: 10,
          shareAttempted: false,
        );
        expect(result.filePath, '/storage/backups/backup.json');
        expect(result.fileName, 'backup.json');
      });

      test('should track share attempted status', () {
        final resultWithShare = ExportResult(
          boardsCount: 5,
          hasSettings: true,
          filePath: '/path/to/file',
          fileName: 'backup.json',
          fileSize: 1024,
          tasksCount: 10,
          shareAttempted: true,
        );
        expect(resultWithShare.shareAttempted, true);

        final resultWithoutShare = ExportResult(
          filePath: '/path/to/file',
          fileName: 'backup.json',
          boardsCount: 5,
          hasSettings: true,
          fileSize: 1024,
          tasksCount: 10,
          shareAttempted: false,
        );
        expect(resultWithoutShare.shareAttempted, false);
      });
    });

    group('ExportDataError', () {
      test('should return correct message for each error type', () {
        expect(
          ExportDataError.settingsLoadFailed.message,
          'Falha ao carregar configurações',
        );
        expect(
          ExportDataError.tasksLoadFailed.message,
          'Falha ao carregar tarefas',
        );
        expect(
          ExportDataError.fileWriteFailed.message,
          'Falha ao escrever arquivo',
        );
        expect(
          ExportDataError.fileSaveFailed.message,
          'Falha ao salvar arquivo',
        );
        expect(
          ExportDataError.unexpectedError.message,
          'Erro inesperado',
        );
      });

      test('should have all error types defined', () {
        expect(ExportDataError.values.length, 5);
        expect(ExportDataError.values, contains(ExportDataError.settingsLoadFailed));
        expect(ExportDataError.values, contains(ExportDataError.tasksLoadFailed));
        expect(ExportDataError.values, contains(ExportDataError.fileWriteFailed));
        expect(ExportDataError.values, contains(ExportDataError.fileSaveFailed));
        expect(ExportDataError.values, contains(ExportDataError.unexpectedError));
      });
    });
  });
}
