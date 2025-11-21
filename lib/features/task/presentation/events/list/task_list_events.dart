import 'package:flutter_ikanban_app/core/utils/result/result_page.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_sort.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/presentation/events/shared/task_shared_events.dart';

class TaskListUpdateStatusFilterEvent extends TaskEvent {
  final TaskStatus status;

  const TaskListUpdateStatusFilterEvent({
    this.status = TaskStatus.all,
  });

  @override
  List<Object> get props => [status];
}
  
class LoadTasksEvent extends TaskEvent {
  const LoadTasksEvent();
}

class TaskSelectedEvent extends TaskEvent {
  final TaskModel task;

  const TaskSelectedEvent({required this.task});

  @override
  List<Object> get props => [task];
}

class ToggleTaskCompletionEvent extends TaskEvent {
  final int id;

  const ToggleTaskCompletionEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class SearchTasksEvent extends TaskEvent {
  final String query;

  const SearchTasksEvent({required this.query});

  @override
  List<Object> get props => [query];
}

// Novos eventos para paginação híbrida
class LoadMoreTasksEvent extends TaskEvent {
  const LoadMoreTasksEvent();
}

class RefreshTasksEvent extends TaskEvent {
  const RefreshTasksEvent();
}

class TasksStreamDataReceived extends TaskEvent {
  final ResultPage<TaskModel> outcome; // Outcome from stream

  const TasksStreamDataReceived(this.outcome);

  @override
  List<Object> get props => [outcome];
}

class TasksPageDataReceived extends TaskEvent {
  final dynamic outcome; // Outcome from pagination API
  final int page;

  const TasksPageDataReceived(this.outcome, this.page);

  @override
  List<Object> get props => [outcome, page];
}

class TaskListUpdateStatus extends TaskEvent {
  final TaskStatus status;

  const TaskListUpdateStatus({required this.status});

  @override
  List<Object> get props => [status];
}

class TaskListUpdateFilter extends TaskEvent {
  final List<TaskType> types;

  const TaskListUpdateFilter({required this.types});

  @override
  List<Object> get props => [types];
}

class ToggleLayoutModeEvent extends TaskEvent {
  const ToggleLayoutModeEvent();
}

class ToggleTaskItemSizeEvent extends TaskEvent {
  const ToggleTaskItemSizeEvent();
}


class FilterTasksClickEvent extends TaskEvent {
  const FilterTasksClickEvent();
}

class FilterTasksApplyEvent extends TaskEvent {
  final List<TaskType> selectedTypes;

  const FilterTasksApplyEvent({
    required this.selectedTypes,
  });

  @override
  List<Object> get props => [selectedTypes];
}

class SortTasksClickEvent extends TaskEvent {
  const SortTasksClickEvent();
}

class ApplySortEvent extends TaskEvent {
  final SortField sortBy;
  final SortOrder sortOrder;

  const ApplySortEvent({
    required this.sortBy,
    required this.sortOrder,
  });

  @override
  List<Object> get props => [sortBy, sortOrder];
}

class ShowTaskDetailsEvent extends TaskEvent {
  final TaskModel task;

  const ShowTaskDetailsEvent({required this.task});

  @override
  List<Object> get props => [task];
}
