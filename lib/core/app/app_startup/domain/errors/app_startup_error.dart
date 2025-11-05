import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_startup_error.freezed.dart';

@freezed
abstract class AppStartupError with _$AppStartupError {
  const factory AppStartupError.notFound({
    String? message,
    Object? throwable,
  }) = _NotFound;
  const factory AppStartupError.databaseError({
    String? message,
    Object? throwable,
  }) = _DatabaseError;
  const factory AppStartupError.validationError({
    String? message,
    Object? throwable,
  }) = _ValidationError;
  const factory AppStartupError.networkError({
    String? message,
    Object? throwable,
  }) = _NetworkError;
  const factory AppStartupError.genericError({
    String? message,
    Object? throwable,
  }) = GenericError;
}
