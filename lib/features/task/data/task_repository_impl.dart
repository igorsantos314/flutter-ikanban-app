import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/core/utils/result/result_page.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/domain/errors/task_repository_errors.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';
import 'package:flutter_ikanban_app/features/task/infra/local/task_local_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource _localDataSource;
  TaskRepositoryImpl(this._localDataSource);

  @override
  Future<Outcome<void, TaskRepositoryError>> createTask(TaskModel task) {
    // TODO: implement createTask
    throw UnimplementedError();
  }

  @override
  Future<Outcome<void, TaskRepositoryError>> deleteTask(int id) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<Outcome<void, TaskRepositoryError>> updateTask(TaskModel task) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }

  @override
  Stream<Outcome<ResultPage<TaskModel>, TaskRepositoryError>> watchTasks({
    required int page,
    required int limitPerPage,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
    String? orderBy,
    TaskStatus? status,
    TaskPriority? priority,
    TaskComplexity? complexity,
    TaskType? type,
    bool onlyActive = true,
    bool ascending = true,
  }) {
    // TODO: implement watchTasks
    throw UnimplementedError();
  }
}
