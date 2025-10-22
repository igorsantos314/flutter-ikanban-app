// lib/core/outcome/outcome.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'outcome.freezed.dart';

@freezed
sealed class Outcome<SuccessResultType, ErrorType> with _$Outcome<SuccessResultType, ErrorType> {
  const factory Outcome.success({
    SuccessResultType? value, // O valor retornado em caso de sucesso
  }) = _Success;

  const factory Outcome.failure({
    required ErrorType error, // O tipo de erro que ocorreu
    String? message, // Uma mensagem descritiva do erro (opcional)
    Object? throwable, // A exceção/erro original que causou a falha (opcional)
  }) = _Failure;
}