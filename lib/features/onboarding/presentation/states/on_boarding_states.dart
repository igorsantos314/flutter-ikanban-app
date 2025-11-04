import 'package:flutter_ikanban_app/core/utils/messages.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_boarding_states.freezed.dart';

@freezed
abstract class OnBoardingState with _$OnBoardingState {
  const factory OnBoardingState({
    @Default(0) int currentPage,
    @Default(false) bool isLastPage,

    @Default(false) bool isOnBoardingCompleted,
    @Default(false) bool isLoading,
    @Default(NotificationType.info) NotificationType notificationType,
    @Default("") String notificationMessage,
    @Default(false) bool showNotification,
  }) = _OnBoardingState;
}
