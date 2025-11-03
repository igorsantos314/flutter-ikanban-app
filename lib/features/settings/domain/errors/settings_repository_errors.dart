import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_repository_errors.freezed.dart';

@freezed
abstract class SettingsRepositoryErrors with _$SettingsRepositoryErrors {
  const factory SettingsRepositoryErrors.notFound({
    String? message,
    Object? throwable,
  }) = _NotFound;
  const factory SettingsRepositoryErrors.databaseError({
    String? message,
    Object? throwable,
  }) = _DatabaseError;
  const factory SettingsRepositoryErrors.validationError({
    String? message,
    Object? throwable,
  }) = _ValidationError;
  const factory SettingsRepositoryErrors.networkError({
    String? message,
    Object? throwable,
  }) = _NetworkError;
  const factory SettingsRepositoryErrors.genericError({
    String? message,
    Object? throwable,
  }) = _GenericError;
}