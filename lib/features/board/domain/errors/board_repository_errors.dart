import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_repository_errors.freezed.dart';

@freezed
abstract class BoardRepositoryErrors with _$BoardRepositoryErrors {
  const factory BoardRepositoryErrors.notFound({
    String? message,
    Object? throwable,
  }) = _NotFound;
  const factory BoardRepositoryErrors.databaseError({
    String? message,
    Object? throwable,
  }) = _DatabaseError;
  const factory BoardRepositoryErrors.validationError({
    String? message,
    Object? throwable,
  }) = _ValidationError;
  const factory BoardRepositoryErrors.networkError({
    String? message,
    Object? throwable,
  }) = _NetworkError;
  const factory BoardRepositoryErrors.genericError({
    String? message,
    Object? throwable,
  }) = GenericError;
}
