import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_state.freezed.dart';

@freezed
abstract class PaginationState with _$PaginationState {
  const factory PaginationState({
    @Default(10) int itemsPerPage,
    @Default(1) int currentPage,
    @Default(0) int pageSize,
    @Default(0) int totalItems,
    @Default(0) int totalPages,
  }) = _PaginationState;
}