import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/domain/usecases/check_onboarding_completed_use_case.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/domain/usecases/complete_onboarding_use_case.dart';
import 'package:flutter_ikanban_app/core/utils/messages.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/onboarding/presentation/events/on_boarding_event.dart';
import 'package:flutter_ikanban_app/features/onboarding/presentation/states/on_boarding_states.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  final CompleteOnBoardingUseCase _completeOnBoarding;
  final CheckOnboardingCompletedUseCase _checkOnboardingCompletionUseCase;

  OnBoardingBloc(this._completeOnBoarding, this._checkOnboardingCompletionUseCase)
    : super(OnBoardingState()) {
    on<LoadOnBoardingEvent>(_mapLoadOnBoardingEventToState);
    on<CompleteOnBoardingEvent>(_mapCompleteOnBoardingEventToState);
  }

  Future<void> _mapLoadOnBoardingEventToState(
    LoadOnBoardingEvent event,
    Emitter<OnBoardingState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _checkOnboardingCompletionUseCase.execute();
    result.when(
      success: (isCompleted) {
        if (isCompleted == null) {
          emit(
            state.copyWith(
              isLoading: false,
              notificationType: NotificationType.error,
              notificationMessage: 'Status do onboarding não encontrado.',
              showNotification: true,
            ),
          );
          return;
        }

        emit(
          state.copyWith(isLoading: false, isOnBoardingCompleted: isCompleted),
        );
      },
      failure: (error, message, throwable) {
        emit(
          state.copyWith(
            isLoading: false,
            notificationType: NotificationType.error,
            notificationMessage: 'Falha ao carregar o status do onboarding.',
            showNotification: true,
          ),
        );
      },
    );
  }

  FutureOr<void> _mapCompleteOnBoardingEventToState(
    CompleteOnBoardingEvent event,
    Emitter<OnBoardingState> emit,
  ) {
    emit(state.copyWith(isLoading: true));
    _completeOnBoarding.execute().then((result) {
      result.when(
        success: (_) {
          emit(state.copyWith(isLoading: false, isOnBoardingCompleted: true));
        },
        failure: (error, message, throwable) {
          emit(
            state.copyWith(
              isLoading: false,
              notificationType: NotificationType.error,
              notificationMessage: 'Falha ao completar o onboarding.',
              showNotification: true,
            ),
          );
        },
      );
    });
  }
}
