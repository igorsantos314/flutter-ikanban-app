import 'package:flutter_ikanban_app/core/theme/theme_enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_model.freezed.dart';

@freezed
abstract class SettingsModel with _$SettingsModel {
  
  const factory SettingsModel({
    @Default(AppTheme.system) AppTheme appTheme,
    required String language,
    required String appVersion,
  }) = _SettingsModel;
}
