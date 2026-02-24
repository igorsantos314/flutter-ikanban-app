import 'package:flutter_ikanban_app/core/utils/messages.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_sort.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/presentation/enums/task_layout.dart';
import 'package:flutter_ikanban_app/features/task/presentation/enums/task_size.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_list_state.freezed.dart';

@freezed
abstract class TaskListState with _$TaskListState {
  const factory TaskListState({
    int? boardId,
    
    TaskModel? selectedTask,
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

    @Default(TaskStatus.todo) TaskStatus statusFilter,
    @Default(false) bool showFilterOptions,
    @Default([]) List<TaskType> typeFilters,

    @Default(false) bool showSortOptions,
    @Default(SortField.createdAt) SortField sortBy,
    @Default(SortOrder.ascending) SortOrder sortOrder,

    @Default(TaskSize.comfortable) TaskSize taskSize,

    @Default(false) bool showStatusSelector,
    @Default(false) bool showTaskDetails,
    @Default(TaskLayout.list) TaskLayout layoutMode,
  }) = _TaskListState;

  factory TaskListState.initial() => const TaskListState();
}
