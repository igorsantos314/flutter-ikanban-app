import 'package:flutter_ikanban_app/features/settings/domain/use_cases/import_data_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ImportDataUseCase', () {
    group('ImportResult', () {
      test('should create result with correct properties', () {
        final result = ImportResult(
          tasksImported: 42,
          settingsImported: true,
        );
        expect(result.tasksImported, 42);
        expect(result.settingsImported, true);
      });

      test('should calculate total imported correctly with settings', () {
        final result = ImportResult(
          tasksImported: 10,
          settingsImported: true,
        );
        expect(result.totalImported, 11);
      });

      test('should calculate total imported correctly without settings', () {
        final result = ImportResult(
          tasksImported: 10,
          settingsImported: false,
        );
        expect(result.totalImported, 10);
      });

      test('should handle zero tasks imported', () {
        final result = ImportResult(
          tasksImported: 0,
          settingsImported: false,
        );
        expect(result.totalImported, 0);
      });

      test('should handle only settings imported', () {
        final result = ImportResult(
          tasksImported: 0,
          settingsImported: true,
        );
        expect(result.totalImported, 1);
      });
    });

    group('ImportDataError', () {
      test('should return correct message for fileNotFound', () {
        expect(ImportDataError.fileNotFound.message, 'Arquivo não encontrado');
      });

      test('should return correct message for invalidJsonFormat', () {
        expect(ImportDataError.invalidJsonFormat.message, 'Formato JSON inválido');
      });

      test('should return correct message for invalidBackupFormat', () {
        expect(ImportDataError.invalidBackupFormat.message, 'Formato de backup inválido');
      });

      test('should return correct message for settingsImportFailed', () {
        expect(ImportDataError.settingsImportFailed.message, 'Falha ao importar configurações');
      });

      test('should return correct message for tasksImportFailed', () {
        expect(ImportDataError.tasksImportFailed.message, 'Falha ao importar tarefas');
      });

      test('should return correct message for userCancelled', () {
        expect(ImportDataError.userCancelled.message, 'Operação cancelada pelo usuário');
      });

      test('should return correct message for fileSelectionFailed', () {
        expect(ImportDataError.fileSelectionFailed.message, 'Falha ao selecionar arquivo');
      });

      test('should return correct message for unexpectedError', () {
        expect(ImportDataError.unexpectedError.message, 'Erro inesperado');
      });

      test('should have all error types defined', () {
        expect(ImportDataError.values.length, 8);
        expect(ImportDataError.values, contains(ImportDataError.fileNotFound));
        expect(ImportDataError.values, contains(ImportDataError.invalidJsonFormat));
        expect(ImportDataError.values, contains(ImportDataError.invalidBackupFormat));
        expect(ImportDataError.values, contains(ImportDataError.settingsImportFailed));
        expect(ImportDataError.values, contains(ImportDataError.tasksImportFailed));
        expect(ImportDataError.values, contains(ImportDataError.userCancelled));
        expect(ImportDataError.values, contains(ImportDataError.fileSelectionFailed));
        expect(ImportDataError.values, contains(ImportDataError.unexpectedError));
      });
    });
  });
}
