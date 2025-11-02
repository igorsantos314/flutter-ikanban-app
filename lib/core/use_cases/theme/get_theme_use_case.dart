import 'package:flutter_ikanban_app/shared/theme/presentation/theme_enum.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/shared/theme/repository/theme_repository.dart';
import 'package:flutter_ikanban_app/shared/theme/domain/errors/theme_errors.dart';

/// Caso de uso para carregar preferências de tema
class GetThemeUseCase {
  final ThemeRepository _themeRepository;

  const GetThemeUseCase(this._themeRepository);

  /// Carrega as preferências de tema do usuário
  Future<Outcome<AppTheme, GetThemeError>> execute() async {
    final theme = await _themeRepository.getTheme();
    
    return Outcome.success(value: theme);
  }
}
