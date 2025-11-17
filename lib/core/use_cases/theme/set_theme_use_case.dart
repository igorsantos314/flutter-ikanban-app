import 'package:flutter_ikanban_app/shared/theme/presentation/theme_enum.dart';
import 'package:flutter_ikanban_app/shared/theme/domain/errors/theme_errors.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/shared/theme/repository/theme_repository.dart';

class SetThemeUseCase {
  final ThemeRepository _themeRepository;

  const SetThemeUseCase(this._themeRepository);

  Future<Outcome<AppTheme, SetThemeError>> execute(AppTheme theme) async {
    try {
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

