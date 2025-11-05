import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/domain/usecases/complete_onboarding_use_case.dart';
import 'package:flutter_ikanban_app/features/onboarding/presentation/events/on_boarding_event.dart';
import 'package:flutter_ikanban_app/features/onboarding/presentation/states/on_boarding_states.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  final CompleteOnBoardingUseCase _completeOnBoarding;

  OnBoardingBloc(this._completeOnBoarding) : super(const OnBoardingState()) {
    on<CompleteOnBoardingEvent>(_mapCompleteOnBoardingEventToState);
  }

  FutureOr<void> _mapCompleteOnBoardingEventToState(
    CompleteOnBoardingEvent event,
    Emitter<OnBoardingState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    
    await _completeOnBoarding.execute();

    // Send user to home screen
    emit(state.copyWith(isOnBoardingCompleted: true));
  }
}
