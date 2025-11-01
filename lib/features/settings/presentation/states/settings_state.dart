import 'package:flutter_ikanban_app/core/theme/theme_enum.dart';
import 'package:flutter_ikanban_app/core/utils/messages.dart';
import 'package:flutter_ikanban_app/features/settings/domain/model/settings_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    SettingsModel? settingsModel,

    @Default(AppTheme.system) AppTheme appTheme,
    @Default('pt') String language,
    @Default('0.0.1') String appVersion,

    @Default(false) bool showNotification,
    @Default(NotificationType.info) NotificationType notificationType,
    @Default("") String notificationMessage,
  }) = _SettingsState;

  factory SettingsState.initial() => const SettingsState();
}
