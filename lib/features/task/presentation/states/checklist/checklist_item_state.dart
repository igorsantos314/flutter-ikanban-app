import 'package:flutter_ikanban_app/features/task/domain/model/checklist_item_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'checklist_item_state.freezed.dart';

@freezed
abstract class ChecklistItemState with _$ChecklistItemState {
  const factory ChecklistItemState({
    @Default([]) List<ChecklistItemModel> items,
    @Default(false) bool isLoading,
    @Default(0) int itemCount,
    String? errorMessage,
  }) = _ChecklistItemState;

  factory ChecklistItemState.initial() => const ChecklistItemState();
}
