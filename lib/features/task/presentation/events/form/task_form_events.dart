import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/checklist_item_model.dart';
import 'package:flutter_ikanban_app/features/task/presentation/colors/task_colors.dart';
import 'package:flutter_ikanban_app/features/task/presentation/events/shared/task_shared_events.dart';

class TaskFormUpdateFieldsEvent extends TaskEvent {
  final String? title;
  final String? description;
  final TaskStatus? status;
  final TaskPriority? priority;
  final DateTime? dueDate;
  final DateTime? dueTime;
  final TaskComplexity? complexity;
  final TaskType? type;
  final TaskColors? color;

  const TaskFormUpdateFieldsEvent({
    this.title,
    this.description,
    this.status,
    this.priority,
    this.dueDate,
    this.dueTime,
    this.complexity,
    this.type,
    this.color,
  });

  @override
  List<Object> get props => [
    ?title,
    ?description,
    ?status,
    ?priority,
    ?dueDate,
    ?dueTime,
    ?complexity,
    ?type,
    ?color,
  ];
}

class LoadTaskFormEvent extends TaskEvent {
  final int taskId;

  const LoadTaskFormEvent(this.taskId);

  @override
  List<Object> get props => [taskId];
}

class TaskFormResetEvent extends TaskEvent {
  final bool? closeScreen;
  final bool? showNotification;
  final bool? showStatusSelector;
  final bool? showFilterOptions;
  final bool? showSortOptions;
  final bool? showTaskDetails;

  const TaskFormResetEvent({
    this.closeScreen,
    this.showNotification,
    this.showStatusSelector,
    this.showFilterOptions,
    this.showSortOptions,
    this.showTaskDetails,
  });

  @override
  List<Object> get props => [];
}

class CreateTaskEvent extends TaskEvent {
  final TaskModel? taskModel;

  const CreateTaskEvent({this.taskModel});

  @override
  List<Object> get props => [?taskModel];
}

class UpdateTaskEvent extends TaskEvent {
  final TaskModel? taskModel;

  const UpdateTaskEvent({this.taskModel});

  @override
  List<Object> get props => [?taskModel];
}

class DeleteTaskEvent extends TaskEvent {
  const DeleteTaskEvent();

  @override
  List<Object> get props => [];
}

// Checklist events
class LoadChecklistItemsEvent extends TaskEvent {
  final int taskId;

  const LoadChecklistItemsEvent(this.taskId);

  @override
  List<Object> get props => [taskId];
}

class AddChecklistItemEvent extends TaskEvent {
  final String title;
  final String? description;

  const AddChecklistItemEvent({
    required this.title,
    this.description,
  });

  @override
  List<Object> get props => [title, if (description != null) description!];
}

class ToggleChecklistItemEvent extends TaskEvent {
  final int itemId;
  final int index;

  const ToggleChecklistItemEvent({
    required this.itemId,
    required this.index,
  });

  @override
  List<Object> get props => [itemId, index];
}

class DeleteChecklistItemEvent extends TaskEvent {
  final int itemId;
  final int index;

  const DeleteChecklistItemEvent({
    required this.itemId,
    required this.index,
  });

  @override
  List<Object> get props => [itemId, index];
}

class EditChecklistItemEvent extends TaskEvent {
  final int itemId;
  final int index;
  final String title;
  final String? description;
  final bool isCompleted;

  const EditChecklistItemEvent({
    required this.itemId,
    required this.index,
    required this.title,
    this.description,
    required this.isCompleted,
  });

  @override
  List<Object> get props => [
        itemId,
        index,
        title,
        if (description != null) description!,
        isCompleted,
      ];
}

// Internal event for updating checklist items from stream
class UpdateChecklistItemsInternalEvent extends TaskEvent {
  final List<ChecklistItemModel> items;

  const UpdateChecklistItemsInternalEvent(this.items);

  @override
  List<Object> get props => [items];
}
