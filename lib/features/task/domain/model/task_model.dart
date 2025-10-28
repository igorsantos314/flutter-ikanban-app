import 'package:flutter/rendering.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
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
    @Default(TaskComplexity.easy) TaskComplexity complexity,
    @Default(TaskType.personal) TaskType type,
    Color? color,
    @Default(true) bool isActive,
  }) = _TaskModel;
}
