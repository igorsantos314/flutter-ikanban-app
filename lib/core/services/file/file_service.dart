import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';

/// Serviço multiplataforma para operações de arquivo
/// Abstrai as diferenças entre Android, iOS, Desktop
class FileService {
  /// Obtém o diretório temporário para salvar backups (sem permissões especiais)
  /// - Android/iOS: Diretório temporário da app
  /// - Desktop: Diretório temporário do sistema
  Future<Outcome<Directory, FileServiceError>> getBackupDirectory() async {
    try {
      Directory directory;
      
      if (Platform.isAndroid || Platform.isIOS) {
        // Mobile: usa diretório temporário (sem permissões especiais)
        final tempDir = await getTemporaryDirectory();
        directory = Directory('${tempDir.path}/backups');
      } else {
        // Desktop: usa diretório temporário do sistema
        final tempDir = await getTemporaryDirectory();
        directory = Directory('${tempDir.path}/iKanban');
      }
      
      // Cria o diretório se não existir
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      
      return Outcome.success(value: directory);
    } catch (e) {
      return Outcome.failure(
        error: FileServiceError.directoryAccessFailed,
        message: 'Erro ao acessar diretório: ${e.toString()}',
        throwable: e,
      );
    }
  }

  /// Salva dados em arquivo
  Future<Outcome<File, FileServiceError>> saveFile({
    required String fileName,
    required String content,
  }) async {
    try {
      final directoryOutcome = await getBackupDirectory();
      
      return await directoryOutcome.when(
        success: (directory) async {
          final file = File('${directory!.path}/$fileName');
          await file.writeAsString(content);
          
          return Outcome.success(value: file);
        },
        failure: (error, message, throwable) async {
          return Outcome.failure(
            error: error,
            message: message,
            throwable: throwable,
          );
        },
      );
    } catch (e) {
      return Outcome.failure(
        error: FileServiceError.fileSaveFailed,
        message: 'Erro ao salvar arquivo: ${e.toString()}',
        throwable: e,
      );
    }
  }

  /// Lê conteúdo de um arquivo
  Future<Outcome<String, FileServiceError>> readFile(String filePath) async {
    try {
      final file = File(filePath);
      
      if (!await file.exists()) {
        return Outcome.failure(
          error: FileServiceError.fileNotFound,
          message: 'Arquivo não encontrado: $filePath',
        );
      }
      
      final content = await file.readAsString();
      return Outcome.success(value: content);
    } catch (e) {
      return Outcome.failure(
        error: FileServiceError.fileReadFailed,
        message: 'Erro ao ler arquivo: ${e.toString()}',
        throwable: e,
      );
    }
  }

  /// Lista arquivos de backup disponíveis
  Future<Outcome<List<File>, FileServiceError>> listBackupFiles() async {
    try {
      final directoryOutcome = await getBackupDirectory();
      
      return await directoryOutcome.when(
        success: (directory) async {
          final files = await directory!
              .list()
              .where((entity) => entity is File && entity.path.endsWith('.json'))
              .cast<File>()
              .toList();
          
          // Ordena por data de modificação (mais recente primeiro)
          files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
          
          return Outcome.success(value: files);
        },
        failure: (error, message, throwable) async {
          return Outcome.failure(
            error: error,
            message: message,
            throwable: throwable,
          );
        },
      );
    } catch (e) {
      return Outcome.failure(
        error: FileServiceError.directoryListFailed,
        message: 'Erro ao listar arquivos: ${e.toString()}',
        throwable: e,
      );
    }
  }

  /// Obtém informações sobre um arquivo
  Future<Outcome<FileInfo, FileServiceError>> getFileInfo(String filePath) async {
    try {
      final file = File(filePath);
      
      if (!await file.exists()) {
        return Outcome.failure(
          error: FileServiceError.fileNotFound,
          message: 'Arquivo não encontrado: $filePath',
        );
      }
      
      final stat = await file.stat();
      final fileInfo = FileInfo(
        path: filePath,
        name: file.uri.pathSegments.last,
        size: stat.size,
        lastModified: stat.modified,
      );
      
      return Outcome.success(value: fileInfo);
    } catch (e) {
      return Outcome.failure(
        error: FileServiceError.fileInfoFailed,
        message: 'Erro ao obter informações do arquivo: ${e.toString()}',
        throwable: e,
      );
    }
  }


}

/// Informações sobre um arquivo
class FileInfo {
  final String path;
  final String name;
  final int size;
  final DateTime lastModified;

  const FileInfo({
    required this.path,
    required this.name,
    required this.size,
    required this.lastModified,
  });

  String get formattedSize {
    if (size < 1024) return '${size}B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)}KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  String get formattedDate {
    return '${lastModified.day}/${lastModified.month}/${lastModified.year} '
           '${lastModified.hour}:${lastModified.minute.toString().padLeft(2, '0')}';
  }
}

/// Erros do serviço de arquivo
enum FileServiceError {
  platformNotSupported,
  directoryNotFound,
  directoryAccessFailed,
  directoryListFailed,
  fileNotFound,
  fileReadFailed,
  fileSaveFailed,
  fileInfoFailed,
  permissionDenied,
}

extension FileServiceErrorExtension on FileServiceError {
  String get message {
    switch (this) {
      case FileServiceError.platformNotSupported:
        return 'Plataforma não suportada';
      case FileServiceError.directoryNotFound:
        return 'Diretório não encontrado';
      case FileServiceError.directoryAccessFailed:
        return 'Falha ao acessar diretório';
      case FileServiceError.directoryListFailed:
        return 'Falha ao listar arquivos do diretório';
      case FileServiceError.fileNotFound:
        return 'Arquivo não encontrado';
      case FileServiceError.fileReadFailed:
        return 'Falha ao ler arquivo';
      case FileServiceError.fileSaveFailed:
        return 'Falha ao salvar arquivo';
      case FileServiceError.fileInfoFailed:
        return 'Falha ao obter informações do arquivo';
      case FileServiceError.permissionDenied:
        return 'Permissão negada';
    }
  }
}