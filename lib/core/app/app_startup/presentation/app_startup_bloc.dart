import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/domain/usecases/check_onboarding_completed_use_case.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/presentation/app_startup_event.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/presentation/app_startup_state.dart';
import 'package:flutter_ikanban_app/core/di/app_locator.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/board/domain/services/board_selection_service.dart';
import 'package:flutter_ikanban_app/features/board/domain/use_cases/get_or_create_default_board_use_case.dart';

class AppStartupBloc extends Bloc<AppStartupEvent, AppStartupState> {
  final CheckOnboardingCompletedUseCase checkOnboardingCompletedUseCase;
  final GetOrCreateDefaultBoardUseCase getOrCreateDefaultBoardUseCase;

  AppStartupBloc({
    required this.checkOnboardingCompletedUseCase,
    required this.getOrCreateDefaultBoardUseCase,
  }) : super(const AppStartupState.initial()) {
    on<InitializeApp>(_onInitializeApp);
  }

  Future<void> _onInitializeApp(
    InitializeApp event,
    Emitter<AppStartupState> emit,
  ) async {
    emit(const AppStartupState.loading());

    final result = await checkOnboardingCompletedUseCase.execute();
    await result.when(
      success: (isOnboardingComplete) async {
        if (isOnboardingComplete == null) {
          emit(
            const AppStartupState.error(
              message: 'Status do onboarding não encontrado.',
            ),
          );
          return;
        }
        
        log('[AppStatupBloc] App initialized. Onboarding complete: $isOnboardingComplete');
        
        // Se o onboarding foi completado, garante que existe um board default
        if (isOnboardingComplete) {
          log('[AppStartupBloc] Creating/getting default board...');
          final boardResult = await getOrCreateDefaultBoardUseCase.execute();
          
          boardResult.when(
            success: (board) {
              log('[AppStartupBloc] Default board ready: ${board?.title ?? "Unknown"}');
              // Set the default board as selected
              if (board != null) {
                getIt<BoardSelectionService>().selectBoard(board);
              }
              emit(
                AppStartupState.loaded(isOnboardingComplete: isOnboardingComplete),
              );
            },
            failure: (error, message, throwable) {
              log('[AppStartupBloc] Failed to setup default board: $error');
              // Mesmo se falhar, continua com a inicialização
              emit(
                AppStartupState.loaded(isOnboardingComplete: isOnboardingComplete),
              );
            },
          );
        } else {
          emit(
            AppStartupState.loaded(isOnboardingComplete: isOnboardingComplete),
          );
        }
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
