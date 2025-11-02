import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/features/settings/domain/use_cases/export_data_use_case.dart';
import 'package:flutter_ikanban_app/features/settings/domain/use_cases/import_data_use_case.dart';
import 'package:flutter_ikanban_app/core/utils/messages.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/settings/domain/use_cases/load_settings_use_case.dart';
import 'package:flutter_ikanban_app/features/settings/domain/use_cases/save_settings_use_case.dart';
import 'package:flutter_ikanban_app/features/settings/presentation/events/settings_events.dart';
import 'package:flutter_ikanban_app/features/settings/presentation/states/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SaveSettingsUseCase saveSettingsUseCase;
  final LoadSettingsUseCase loadSettingsUseCase;
  final ExportDataUseCase exportDataUseCase;
  final ImportDataUseCase importDataUseCase;

  SettingsBloc({
    required this.saveSettingsUseCase,
    required this.loadSettingsUseCase,
    required this.exportDataUseCase,
    required this.importDataUseCase,
  }) : super(SettingsState.initial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateThemeEvent>(_onUpdateTheme);
    on<ExportDataEvent>(_onExportData);
    on<ImportDataEvent>(_onImportData);

    on<SettingsResetNotification>((event, emit) {
      emit(state.copyWith(showNotification: false));
    });
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    log("Loading settings...");
    emit(state.copyWith(isLoading: true));
    
    final outcome = await loadSettingsUseCase.execute();

    outcome.when(
      success: (settings) {
        if (settings == null) {
          log("No settings found");
          emit(
            state.copyWith(
              isLoading: false,
              showNotification: true,
              notificationType: NotificationType.info,
              notificationMessage: "Nenhuma configuração encontrada",
            ),
          );
          return;
        }

        log("Settings loaded: $settings");
        
        emit(
          state.copyWith(
            settingsModel: settings,
            appTheme: settings.appTheme,
            language: settings.language,
            appVersion: settings.appVersion,
            isLoading: false,
          ),
        );
      },
      failure: (error, message, throwable) {
        log("Failed to load settings: $message");
        emit(
          state.copyWith(
            showNotification: true,
            notificationType: NotificationType.error,
            notificationMessage: "Erro ao carregar configurações",
            isLoading: false,
          ),
        );
      },
    );
  }

  Future<void> _onUpdateTheme(
    UpdateThemeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state.settingsModel == null) {
      log("Settings model is null, cannot update theme");
      emit(
        state.copyWith(
          showNotification: true,
          notificationType: NotificationType.error,
          notificationMessage: "Configurações não carregadas",
        ),
      );
      return;
    }

    final outcome = await saveSettingsUseCase.execute(
      state.settingsModel!.copyWith(appTheme: event.appTheme),
    );

    outcome.when(
      success: (value) {
        emit(state.copyWith(appTheme: event.appTheme));
        log("Theme updated to ${event.appTheme}");
      },
      failure: (error, message, throwable) {
        log("Failed to update theme: $message");
        emit(
          state.copyWith(
            showNotification: true,
            notificationType: NotificationType.error,
            notificationMessage: "Erro ao atualizar tema",
          ),
        );
      },
    );
  }

  Future<void> _onExportData(
    ExportDataEvent event,
    Emitter<SettingsState> emit,
  ) async {
    log("Exporting data...");
    emit(state.copyWith(isLoading: true));
    
    final outcome = await exportDataUseCase.execute();
    
    outcome.when(
      success: (result) {
        log("Data exported to: $result");
        emit(
          state.copyWith(
            isLoading: false,
            showNotification: true,
            notificationType: NotificationType.success,
            notificationMessage: "Dados exportados com sucesso!\nArquivo: ${result?.filePath}",
          ),
        );
      },
      failure: (error, message, throwable) {
        log("Export failed: $message");
        emit(
          state.copyWith(
            isLoading: false,
            showNotification: true,
            notificationType: NotificationType.error,
            notificationMessage: message ?? "Erro ao exportar dados",
          ),
        );
      },
    );
  }

  Future<void> _onImportData(
    ImportDataEvent event,
    Emitter<SettingsState> emit,
  ) async {
    log("Importing data from: ${event.filePath}");
    emit(state.copyWith(isLoading: true));

    final outcome = await importDataUseCase.executeWithFilePicker();

    outcome.when(
      success: (importResult) {
        if (importResult != null) {
          log("Data imported: ${importResult.totalImported} items");
          emit(
            state.copyWith(
              isLoading: false,
              showNotification: true,
              notificationType: NotificationType.success,
              notificationMessage: "Dados importados com sucesso!\n"
                  "${importResult.tasksImported} tarefas importadas",
            ),
          );
        } else {
          log("Import result is null");
          emit(
            state.copyWith(
              isLoading: false,
              showNotification: true,
              notificationType: NotificationType.error,
              notificationMessage: "Erro ao processar resultado da importação",
            ),
          );
        }
      },
      failure: (error, message, throwable) {
        log("Import failed: $message");
        emit(
          state.copyWith(
            isLoading: false,
            showNotification: true,
            notificationType: NotificationType.error,
            notificationMessage: message ?? "Erro ao importar dados",
          ),
        );
      },
    );
  }
}
