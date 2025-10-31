import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/features/settings/domain/repository/settings_repository.dart';
import 'package:flutter_ikanban_app/features/settings/presentation/events/settings_events.dart';
import 'package:flutter_ikanban_app/features/settings/presentation/states/settings_state.dart';

class SettingsCubit extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsCubit({required this.settingsRepository}) : super(const SettingsState.initial()) {
    // Event handlers go here
  }
}
