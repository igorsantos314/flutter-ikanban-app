import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';

class FileShareService {
  Future<Outcome<void, FileShareError>> shareFile({
    required String filePath,
    String? subject,
    String? text,
  }) async {
    try {
      if (kIsWeb) {
        return Outcome.failure(
          error: FileShareError.platformNotSupported,
          message: 'Web não suporta compartilhamento de arquivos',
        );
      }

      final file = File(filePath);
      if (!await file.exists()) {
        return Outcome.failure(
          error: FileShareError.fileNotFound,
          message: 'Arquivo não encontrado: $filePath',
        );
      }

      final xFile = XFile(filePath);
      
      await Share.shareXFiles(
        [xFile],
        subject: subject ?? 'Backup iKanban',
        text: text ?? 'Backup dos dados do iKanban',
      );

      return Outcome.success();
    } catch (e) {
      return Outcome.failure(
        error: FileShareError.shareFailed,
        message: 'Erro ao compartilhar arquivo: ${e.toString()}',
        throwable: e,
      );
    }
  }

  Future<Outcome<String, FileShareError>> pickFile({
    List<String>? allowedExtensions,
    String? dialogTitle,
  }) async {
    try {
      if (kIsWeb) {
        return Outcome.failure(
          error: FileShareError.platformNotSupported,
          message: 'Web não suporta seleção de arquivos local',
        );
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions ?? ['json'],
        dialogTitle: dialogTitle ?? 'Selecione o arquivo de backup',
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        return Outcome.success(value: result.files.single.path!);
      } else {
        return Outcome.failure(
          error: FileShareError.userCancelled,
          message: 'Usuário cancelou a seleção',
        );
      }
    } catch (e) {
      return Outcome.failure(
        error: FileShareError.pickFailed,
        message: 'Erro ao selecionar arquivo: ${e.toString()}',
        throwable: e,
      );
    }
  }

  /// Permite ao usuário selecionar onde salvar um arquivo (Desktop principalmente)
  Future<Outcome<String, FileShareError>> pickSaveLocation({
    String? fileName,
    String? dialogTitle,
    List<String>? allowedExtensions,
  }) async {
    try {
      if (kIsWeb) {
        return Outcome.failure(
          error: FileShareError.platformNotSupported,
          message: 'Web não suporta seleção de local para salvar',
        );
      }

      // No mobile, retorna um caminho padrão
      if (Platform.isAndroid || Platform.isIOS) {
        return Outcome.failure(
          error: FileShareError.featureNotAvailableOnPlatform,
          message: 'Use o compartilhamento no mobile',
        );
      }

      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: dialogTitle ?? 'Salvar backup como...',
        fileName: fileName ?? 'ikanban_backup.json',
        type: FileType.custom,
        allowedExtensions: allowedExtensions ?? ['json'],
      );

      if (outputFile != null) {
        return Outcome.success(value: outputFile);
      } else {
        return Outcome.failure(
          error: FileShareError.userCancelled,
          message: 'Usuário cancelou o salvamento',
        );
      }
    } catch (e) {
      return Outcome.failure(
        error: FileShareError.saveLocationFailed,
        message: 'Erro ao selecionar local para salvar: ${e.toString()}',
        throwable: e,
      );
    }
  }

  bool get canShare {
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);
  }

  bool get canPickSaveLocation {
    return !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
  }

  bool get canPickFiles {
    return !kIsWeb;
  }

  Future<Outcome<void, FileShareError>> shareText({
    required String text,
    String? subject,
  }) async {
    try {
      await Share.share(
        text,
        subject: subject,
      );
      return Outcome.success();
    } catch (e) {
      return Outcome.failure(
        error: FileShareError.shareFailed,
        message: 'Erro ao compartilhar texto: ${e.toString()}',
        throwable: e,
      );
    }
  }
}

enum FileShareError {
  platformNotSupported,
  featureNotAvailableOnPlatform,
  fileNotFound,
  shareFailed,
  pickFailed,
  saveLocationFailed,
  userCancelled,
  permissionDenied,
}

extension FileShareErrorExtension on FileShareError {
  String get message {
    switch (this) {
      case FileShareError.platformNotSupported:
        return 'Plataforma não suportada';
      case FileShareError.featureNotAvailableOnPlatform:
        return 'Recurso não disponível nesta plataforma';
      case FileShareError.fileNotFound:
        return 'Arquivo não encontrado';
      case FileShareError.shareFailed:
        return 'Falha ao compartilhar';
      case FileShareError.pickFailed:
        return 'Falha ao selecionar arquivo';
      case FileShareError.saveLocationFailed:
        return 'Falha ao selecionar local para salvar';
      case FileShareError.userCancelled:
        return 'Operação cancelada pelo usuário';
      case FileShareError.permissionDenied:
        return 'Permissão negada';
    }
  }

  bool get isUserCancellation => this == FileShareError.userCancelled;
}