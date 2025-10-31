import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_model.freezed.dart';

@freezed
abstract class SettingsModel with _$SettingsModel {
  
  const factory SettingsModel({
    required bool isDarkMode,
    required String language,
  }) = _SettingsModel;
}
