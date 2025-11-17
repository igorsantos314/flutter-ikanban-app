// lib/core/outcome/outcome.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'outcome.freezed.dart';

@freezed
sealed class Outcome<SuccessResultType, ErrorType> with _$Outcome<SuccessResultType, ErrorType> {
  const factory Outcome.success({
    SuccessResultType? value,
  }) = _Success;

  const factory Outcome.failure({
    required ErrorType error, 
    String? message,
    Object? throwable,
  }) = _Failure;
}