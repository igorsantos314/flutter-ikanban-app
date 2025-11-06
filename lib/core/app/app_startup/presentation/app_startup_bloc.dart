import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/domain/usecases/check_onboarding_completed_use_case.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/presentation/app_startup_event.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/presentation/app_startup_state.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';

class AppStartupBloc extends Bloc<AppStartupEvent, AppStartupState> {
  final CheckOnboardingCompletedUseCase checkOnboardingCompletedUseCase;

  AppStartupBloc({required this.checkOnboardingCompletedUseCase})
    : super(const AppStartupState.initial()) {
    on<InitializeApp>(_onInitializeApp);
  }

  Future<void> _onInitializeApp(
    InitializeApp event,
    Emitter<AppStartupState> emit,
  ) async {
    emit(const AppStartupState.loading());

    final result = await checkOnboardingCompletedUseCase.execute();
    result.when(
      success: (isOnboardingComplete) {
        if (isOnboardingComplete == null) {
          emit(
            const AppStartupState.error(
              message: 'Status do onboarding não encontrado.',
            ),
          );
          return;
        }
        log('[AppStatupBloc] App initialized. Onboarding complete: $isOnboardingComplete');
        emit(
          AppStartupState.loaded(isOnboardingComplete: isOnboardingComplete),
        );
      },
      failure: (error, message, throwable) {
        log('[AppStartupBloc] App initialization failed: $error');
        emit(
          const AppStartupState.error(
            message: 'Erro ao inicializar o aplicativo.',
          ),
        );
      },
    );
  }
}
