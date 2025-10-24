import 'package:equatable/equatable.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasksEvent extends TaskEvent {
  const LoadTasksEvent();
}

class CreateTaskEvent extends TaskEvent {
  final TaskModel taskModel;

  const CreateTaskEvent({required this.taskModel});

  @override
  List<Object> get props => [taskModel];
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