
import 'package:flutter_ikanban_app/shared/theme/domain/errors/theme_errors.dart';

/// Extensions para facilitar o uso dos erros
extension SetThemeErrorExtension on SetThemeError {
  String get message {
    switch (this) {
      case SetThemeError.saveFailed:
        return 'Falha ao salvar preferências de tema';
      case SetThemeError.unexpectedError:
        return 'Erro inesperado';
    }
  }
}

extension GetThemeErrorExtension on GetThemeError {
  String get message {
    switch (this) {
      case GetThemeError.loadFailed:
        return 'Falha ao carregar preferências de tema';
    }
  }
}