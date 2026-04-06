import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/presentation/colors/task_colors.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';

@freezed
abstract class TaskModel with _$TaskModel {
  const factory TaskModel({
    int? id,
    required String title,
    String? description,
    @Default(TaskStatus.backlog) TaskStatus status,
    @Default(TaskPriority.low) TaskPriority priority,
    DateTime? dueDate,
    DateTime? dueTime,
    @Default(TaskComplexity.easy) TaskComplexity complexity,
    @Default(TaskType.personal) TaskType type,
    @Default(TaskColors.defaultColor) TaskColors color,
    @Default(true) bool isActive,
    required DateTime createdAt,
    int? boardId,
    // Notification fields
    @Default(false) bool shouldNotify,
    int? notifyMinutesBefore,
    // Checklist fields
    @Default(0) int checklistTotal,
    @Default(0) int checklistCompleted,
  }) = _TaskModel;
}
