import 'package:drift/drift.dart';
import 'package:flutter_ikanban_app/core/database/app_database.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';

class TaskMapper {
  static TaskEntityCompanion toEntity(TaskModel model) {
    return TaskEntityCompanion(
      id: model.id != null ? Value(model.id!) : const Value.absent(),
      title: Value(model.title),
      description: Value(model.description),
      status: Value(model.status),
      priority: Value(model.priority),
      dueDate: model.dueDate != null ? Value(model.dueDate!) : const Value.absent(),
      complexity: Value(model.complexity),
      type: Value(model.type),
      color: Value(model.color),
      isActive: Value(model.isActive),
      createdAt: Value(model.createdAt),
      boardId: model.boardId != null ? Value(model.boardId!) : const Value.absent(),
    );
  }
  
  static TaskModel fromEntity(TaskData entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      status: entity.status,
      priority: entity.priority,
      dueDate: entity.dueDate,
      complexity: entity.complexity,
      type: entity.type,
      color: entity.color,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      boardId: entity.boardId,
    );
  }
}