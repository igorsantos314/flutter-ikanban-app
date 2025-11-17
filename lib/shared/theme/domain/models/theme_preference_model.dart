import 'package:flutter_ikanban_app/shared/theme/presentation/theme_enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_preference_model.freezed.dart';
part 'theme_preference_model.g.dart';

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
  bool get shouldFollowSystem => followSystemTheme && selectedTheme == AppTheme.system;
  
  AppTheme get effectiveTheme {
    if (shouldFollowSystem) {
      return AppTheme.system;
    }
    return selectedTheme;
  }
  
  ThemePreferenceModel withTheme(AppTheme theme) {
    return copyWith(
      selectedTheme: theme,
      followSystemTheme: theme == AppTheme.system,
      lastUpdated: DateTime.now(),
    );
  }
}