import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/presentation/colors/task_colors.dart';
import 'package:flutter_ikanban_app/features/task/presentation/events/shared/task_shared_events.dart';

class TaskFormUpdateFieldsEvent extends TaskEvent {
  final String? title;
  final String? description;
  final TaskStatus? status;
  final TaskPriority? priority;
  final DateTime? dueDate;
  final TaskComplexity? complexity;
  final TaskType? type;
  final TaskColors? color;

  const TaskFormUpdateFieldsEvent({
    this.title,
    this.description,
    this.status,
    this.priority,
    this.dueDate,
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

  const TaskFormResetEvent({
    this.closeScreen,
    this.showNotification,
    this.showStatusSelector,
    this.showFilterOptions,
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
