import 'package:equatable/equatable.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class TaskFormUpdateFieldsEvent extends TaskEvent {
  final String? title;
  final String? description;
  final TaskStatus? status;
  final TaskPriority? priority;
  final DateTime? dueDate;
  final TaskComplexity? complexity;
  final TaskType? type;

  const TaskFormUpdateFieldsEvent({this.title, this.description, this.status, this.priority, this.dueDate, this.complexity, this.type});

  @override
  List<Object> get props => [?title, ?description];
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

  const TaskFormResetEvent({this.closeScreen, this.showNotification});

  @override
  List<Object> get props => [];
}

class LoadTasksEvent extends TaskEvent {
  const LoadTasksEvent();
}

class CreateTaskEvent extends TaskEvent {
  final TaskModel? taskModel;

  const CreateTaskEvent({this.taskModel});

  @override
  List<Object> get props => [?taskModel];
}

class UpdateTaskEvent extends TaskEvent {
  final TaskModel taskModel;

  const UpdateTaskEvent({required this.taskModel});

  @override
  List<Object> get props => [taskModel];
}

class DeleteTaskEvent extends TaskEvent {
  final int id;

  const DeleteTaskEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class ToggleTaskCompletion extends TaskEvent {
  final int id;

  const ToggleTaskCompletion({required this.id});

  @override
  List<Object> get props => [id];
}

class SearchTasksEvent extends TaskEvent {
  final String query;

  const SearchTasksEvent({required this.query});

  @override
  List<Object> get props => [query];
}