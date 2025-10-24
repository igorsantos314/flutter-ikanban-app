import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_list_state.freezed.dart';

@freezed
abstract class TaskListState with _$TaskListState {
  const factory TaskListState({
    @Default("") String searchQuery,
    @Default([]) List<TaskModel> tasks,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _TaskListState;

  factory TaskListState.initial() =>
      const TaskListState();
}