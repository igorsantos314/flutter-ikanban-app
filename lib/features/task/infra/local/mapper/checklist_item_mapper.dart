import 'package:drift/drift.dart';
import 'package:flutter_ikanban_app/core/database/app_database.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/checklist_item_model.dart';

class ChecklistItemMapper {
  static ChecklistItemEntityCompanion toEntity(ChecklistItemModel model) {
    return ChecklistItemEntityCompanion(
      id: model.id != null ? Value(model.id!) : const Value.absent(),
      title: Value(model.title),
      description: Value(model.description),
      isCompleted: Value(model.isCompleted),
      taskId: Value(model.taskId),
      createdAt: Value(model.createdAt),
    );
  }

  static ChecklistItemModel fromEntity(ChecklistItemData entity) {
    return ChecklistItemModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      isCompleted: entity.isCompleted,
      taskId: entity.taskId,
      createdAt: entity.createdAt,
    );
  }
}
