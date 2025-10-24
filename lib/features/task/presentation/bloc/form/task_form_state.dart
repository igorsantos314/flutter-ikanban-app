import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_form_state.freezed.dart';

@freezed
abstract class TaskFormState with _$TaskFormState {
  const factory TaskFormState({
    @Default("") String title,
    @Default("") String description,


    @Default(TaskStatus.backlog) TaskStatus status,
    @Default(TaskPriority.low) TaskPriority priority,
    @Default("") String dueDate,


    @Default(TaskComplexity.easy) TaskComplexity complexity,
    @Default(TaskType.personal) TaskType type,

    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _TaskFormState;

  factory TaskFormState.initial() =>
      const TaskFormState();
}
