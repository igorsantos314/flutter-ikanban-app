import 'package:equatable/equatable.dart';
import 'package:flutter_ikanban_app/core/theme/theme_enum.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {}

class UpdateThemeEvent extends SettingsEvent {
  final AppTheme appTheme;

  const UpdateThemeEvent(this.appTheme);

  @override
  List<Object> get props => [appTheme];
}

class ExportDataEvent extends SettingsEvent {
  const ExportDataEvent();
}

class ImportDataEvent extends SettingsEvent {
  const ImportDataEvent();
}

class ClearDataEvent extends SettingsEvent {
  const ClearDataEvent();
}

class ResetSettingsEvent extends SettingsEvent {
  const ResetSettingsEvent();
}

