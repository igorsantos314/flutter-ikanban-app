import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_boarding_states.freezed.dart';

@freezed
abstract class OnBoardingState with _$OnBoardingState {
  const factory OnBoardingState({
    @Default(false) bool isOnBoardingCompleted,
    @Default(false) bool isLoading,
  }) = _OnBoardingState;
}
