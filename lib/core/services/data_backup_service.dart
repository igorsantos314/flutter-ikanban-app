import 'package:flutter_ikanban_app/core/use_cases/export_data_use_case.dart';
import 'package:flutter_ikanban_app/core/use_cases/import_data_use_case.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';

/// Serviço de aplicação responsável por coordenar operações de backup/restore
/// Este serviço atua como uma facade para os use cases de import/export
class DataBackupService {
  final ExportDataUseCase _exportDataUseCase;
  final ImportDataUseCase _importDataUseCase;

  const DataBackupService({
    required ExportDataUseCase exportDataUseCase,
    required ImportDataUseCase importDataUseCase,
  })  : _exportDataUseCase = exportDataUseCase,
        _importDataUseCase = importDataUseCase;

  /// Exporta todos os dados do aplicativo
  Future<Outcome<String, ExportDataError>> exportAllData() {
    return _exportDataUseCase.execute();
  }

  /// Importa dados de um arquivo
  Future<Outcome<ImportResult, ImportDataError>> importDataFromFile(String filePath) {
    return _importDataUseCase.execute(filePath);
  }

  /// Limpa todos os dados do aplicativo
  /// TODO: Implementar caso de uso específico para limpeza
  Future<Outcome<void, String>> clearAllData() async {
    // Este método seria implementado com um ClearAllDataUseCase
    // que coordenaria a limpeza de todas as features
    return Outcome.failure(
      error: 'Funcionalidade não implementada',
      message: 'A limpeza de dados ainda não foi implementada',
    );
  }

  /// Valida se um arquivo é um backup válido
  Future<Outcome<bool, ImportDataError>> validateBackupFile(String filePath) async {
    // Reutiliza a lógica de importação apenas para validar
    final result = await _importDataUseCase.execute(filePath);
    return result.when(
      success: (importResult) => Outcome.success(value: true),
      failure: (error, message, throwable) => Outcome.failure(
        error: error,
        message: message,
        throwable: throwable,
      ),
    );
  }
}