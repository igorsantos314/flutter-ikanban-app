import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_boarding_errors.freezed.dart';

@freezed
abstract class OnBoardingError with _$OnBoardingError {
  const factory OnBoardingError.notFound({
    String? message,
    Object? throwable,
  }) = _NotFound;
  const factory OnBoardingError.databaseError({
    String? message,
    Object? throwable,
  }) = _DatabaseError;
  const factory OnBoardingError.validationError({
    String? message,
    Object? throwable,
  }) = _ValidationError;
  const factory OnBoardingError.networkError({
    String? message,
    Object? throwable,
  }) = _NetworkError;
  const factory OnBoardingError.genericError({
    String? message,
    Object? throwable,
  }) = GenericError;
}
