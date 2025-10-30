import 'package:flutter_ikanban_app/core/utils/messages.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/presentation/colors/task_colors.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_form_state.freezed.dart';

@freezed
abstract class TaskFormState with _$TaskFormState {
  const factory TaskFormState({
    int? taskId,
    
    @Default("") String title,
    @Default(null) String? titleError,

    @Default("") String description,
    @Default(null) String? descriptionError,

    @Default(TaskStatus.backlog) TaskStatus status,
    @Default(TaskPriority.low) TaskPriority priority,
    DateTime? dueDate,

    @Default(TaskComplexity.easy) TaskComplexity complexity,
    @Default(TaskType.personal) TaskType type,

    @Default(TaskColors.defaultColor) TaskColors color,

    @Default(false) bool showNotification,
    @Default(NotificationType.info) NotificationType notificationType,
    @Default("") String notificationMessage,
    
    @Default(false) bool closeScreen,
    
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _TaskFormState;

  factory TaskFormState.initial() =>
      const TaskFormState();
}
