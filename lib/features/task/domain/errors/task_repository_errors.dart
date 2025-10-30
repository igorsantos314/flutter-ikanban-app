import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_repository_errors.freezed.dart';

@freezed
abstract class TaskRepositoryErrors with _$TaskRepositoryErrors {
  const factory TaskRepositoryErrors.notFound({
    String? message,
    Object? throwable,
  }) = _NotFound;
  const factory TaskRepositoryErrors.databaseError({
    String? message,
    Object? throwable,
  }) = _DatabaseError;
  const factory TaskRepositoryErrors.validationError({
    String? message,
    Object? throwable,
  }) = _ValidationError;
  const factory TaskRepositoryErrors.networkError({
    String? message,
    Object? throwable,
  }) = _NetworkError;
  const factory TaskRepositoryErrors.genericError({
    String? message,
    Object? throwable,
  }) = GenericError;
}
