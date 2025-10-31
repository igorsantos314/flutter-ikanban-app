import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

@freezed
abstract class  SettingsState with _$SettingsState {

  const factory SettingsState({
    required bool isDarkMode,
    required String language,
  }) = _SettingsState;

  const factory SettingsState.initial() = _Initial;
}
