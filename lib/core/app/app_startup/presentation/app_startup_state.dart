import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_startup_state.freezed.dart';

@freezed
abstract class AppStartupState with _$AppStartupState {
  const factory AppStartupState.initial() = _AppStartupStateInitial;
  const factory AppStartupState.loading() = _AppStartupStateLoading;
  const factory AppStartupState.loaded({
    required bool isOnboardingComplete,
  }) = _AppStartupStateLoaded;
  const factory AppStartupState.error({String? message}) = _AppStartupStateError;
}
