import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_list_preferences_error.freezed.dart';

@freezed
abstract class TaskListPreferencesError with _$TaskListPreferencesError {
  const factory TaskListPreferencesError.notFound({
    String? message,
    Object? throwable,
  }) = _NotFound;
  const factory TaskListPreferencesError.databaseError({
    String? message,
    Object? throwable,
  }) = _DatabaseError;
  const factory TaskListPreferencesError.validationError({
    String? message,
    Object? throwable,
  }) = _ValidationError;
  const factory TaskListPreferencesError.networkError({
    String? message,
    Object? throwable,
  }) = _NetworkError;
  const factory TaskListPreferencesError.genericError({
    String? message,
    Object? throwable,
  }) = _GenericError;
}
