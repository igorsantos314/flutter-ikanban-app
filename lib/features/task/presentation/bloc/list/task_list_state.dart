import 'package:flutter_ikanban_app/core/utils/messages.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_list_state.freezed.dart';

@freezed
abstract class TaskListState with _$TaskListState {
  const factory TaskListState({
    @Default("") String searchQuery,
    @Default([]) List<TaskModel> tasks,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMorePages,
    @Default(1) int currentPage,
    @Default(false) bool hasError,
    @Default("") String errorMessage,

    @Default(false) bool showNotification,
    @Default("") String notificationMessage,
    @Default(NotificationType.info) NotificationType notificationType,
  }) = _TaskListState;

  factory TaskListState.initial() =>
      const TaskListState();
}