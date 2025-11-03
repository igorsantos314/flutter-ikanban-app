import 'package:flutter_ikanban_app/shared/theme/presentation/theme_enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_preference_model.freezed.dart';
part 'theme_preference_model.g.dart';

/// Modelo que representa a preferência de tema do usuário
@freezed
abstract class ThemePreferenceModel with _$ThemePreferenceModel {
  const ThemePreferenceModel._();
  
  const factory ThemePreferenceModel({
    @Default(AppTheme.system) AppTheme selectedTheme,
    @Default(true) bool followSystemTheme,
    DateTime? lastUpdated,
  }) = _ThemePreferenceModel;

  factory ThemePreferenceModel.fromJson(Map<String, dynamic> json) =>
      _$ThemePreferenceModelFromJson(json);
}

extension ThemePreferenceModelX on ThemePreferenceModel {
  /// Verifica se deve usar tema do sistema
  bool get shouldFollowSystem => followSystemTheme && selectedTheme == AppTheme.system;
  
  /// Retorna o tema efetivo considerando as configurações
  AppTheme get effectiveTheme {
    if (shouldFollowSystem) {
      return AppTheme.system;
    }
    return selectedTheme;
  }
  
  /// Cria uma cópia com nova configuração de tema
  ThemePreferenceModel withTheme(AppTheme theme) {
    return copyWith(
      selectedTheme: theme,
      followSystemTheme: theme == AppTheme.system,
      lastUpdated: DateTime.now(),
    );
  }
}