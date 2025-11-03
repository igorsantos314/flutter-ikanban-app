import 'package:flutter_ikanban_app/shared/theme/presentation/theme_enum.dart';
import 'package:flutter_ikanban_app/shared/theme/domain/errors/theme_errors.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/shared/theme/repository/theme_repository.dart';

/// Caso de uso para gerenciar preferências de tema
/// Centraliza a lógica de negócio relacionada a temas
class SetThemeUseCase {
  final ThemeRepository _themeRepository;

  const SetThemeUseCase(this._themeRepository);

  /// Define um novo tema e persiste a preferência
  Future<Outcome<AppTheme, SetThemeError>> execute(AppTheme theme) async {
    try {
      // 1. Carrega preferência atual
      await _themeRepository.setTheme(theme);
      return Outcome.success(value: theme);
    } catch (e) {
      return Outcome.failure(
        error: SetThemeError.unexpectedError,
        message: 'Erro inesperado ao definir tema: ${e.toString()}',
        throwable: e,
      );
    }
  }
}

