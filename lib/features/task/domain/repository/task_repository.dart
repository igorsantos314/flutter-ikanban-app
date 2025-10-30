import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/core/utils/result/result_page.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/domain/errors/task_repository_errors.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';

abstract class TaskRepository {
  Stream<Outcome<ResultPage<TaskModel>, TaskRepositoryErrors>> watchTasks({
    required int page,
    required int limitPerPage,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
    String? orderBy,
    List<TaskStatus>? status,
    TaskPriority? priority,
    TaskComplexity? complexity,
    TaskType? type,
    bool onlyActive = true,
    bool ascending = true,
  });
  Future<Outcome<void, TaskRepositoryErrors>> createTask(TaskModel task);
  Future<Outcome<void, TaskRepositoryErrors>> updateTask(TaskModel task);
  Future<Outcome<void, TaskRepositoryErrors>> deleteTask(int id);
  Future<Outcome<TaskModel, TaskRepositoryErrors>> getTaskById(int taskId);
}
