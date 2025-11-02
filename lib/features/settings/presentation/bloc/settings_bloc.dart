import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/services/data_backup_service.dart';
import 'package:flutter_ikanban_app/core/utils/messages.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/settings/domain/repository/settings_repository.dart';
import 'package:flutter_ikanban_app/features/settings/presentation/events/settings_events.dart';
import 'package:flutter_ikanban_app/features/settings/presentation/states/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;
  final DataBackupService dataBackupService;

  SettingsBloc({
    required this.settingsRepository,
    required this.dataBackupService,
  }) : super(SettingsState.initial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateThemeEvent>(_onUpdateTheme);
    on<ExportDataEvent>(_onExportData);
    on<ImportDataEvent>(_onImportData);
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    log("Loading settings...");
    final outcome = await settingsRepository.loadSettings();

    outcome.when(
      success: (settings) {
        if (settings == null) {
          log("No settings found");
          emit(
            state.copyWith(
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

    final outcome = await settingsRepository.saveSettings(
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
    
    final outcome = await dataBackupService.exportAllData();
    
    outcome.when(
      success: (filePath) {
        log("Data exported to: $filePath");
        emit(
          state.copyWith(
            isLoading: false,
            showNotification: true,
            notificationType: NotificationType.success,
            notificationMessage: "Dados exportados com sucesso!\nArquivo: $filePath",
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
    
    final outcome = await dataBackupService.importDataFromFile(event.filePath);
    
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
