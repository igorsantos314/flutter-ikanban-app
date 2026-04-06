import 'package:flutter_ikanban_app/features/task/domain/model/checklist_item_model.dart';

abstract class ChecklistItemEvent {}

class LoadChecklistItemsEvent extends ChecklistItemEvent {
  final int taskId;

  LoadChecklistItemsEvent(this.taskId);
}

class AddChecklistItemEvent extends ChecklistItemEvent {
  final String title;
  final String? description;
  final int taskId;

  AddChecklistItemEvent({
    required this.title,
    this.description,
    required this.taskId,
  });
}

class UpdateChecklistItemEvent extends ChecklistItemEvent {
  final ChecklistItemModel item;

  UpdateChecklistItemEvent(this.item);
}

class ToggleChecklistItemEvent extends ChecklistItemEvent {
  final ChecklistItemModel item;

  ToggleChecklistItemEvent(this.item);
}

class DeleteChecklistItemEvent extends ChecklistItemEvent {
  final int id;

  DeleteChecklistItemEvent(this.id);
}
