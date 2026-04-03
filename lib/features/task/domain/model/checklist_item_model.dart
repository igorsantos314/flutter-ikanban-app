import 'package:freezed_annotation/freezed_annotation.dart';

part 'checklist_item_model.freezed.dart';

@freezed
abstract class ChecklistItemModel with _$ChecklistItemModel {
  const factory ChecklistItemModel({
    int? id,
    required String title,
    String? description,
    @Default(false) bool isCompleted,
    required int taskId,
    required DateTime createdAt,
  }) = _ChecklistItemModel;
}
