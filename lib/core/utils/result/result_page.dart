import 'package:freezed_annotation/freezed_annotation.dart';

part 'result_page.freezed.dart';

@freezed
abstract class ResultPage <T> with _$ResultPage<T> {
  const factory ResultPage({
    required int number,
    required int limitPerPage,
    required int totalItems,
    required int totalPages,
    required List<T> items,
  }) = _ResultPage<T>;
}
