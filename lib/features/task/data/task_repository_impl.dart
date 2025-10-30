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
import 'package:flutter_ikanban_app/features/task/infra/local/mapper/task_mapper.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource _localDataSource;
  TaskRepositoryImpl(this._localDataSource);

  @override
  Future<Outcome<void, TaskRepositoryErrors>> createTask(TaskModel task) async {
    try {
      final entity = TaskMapper.toEntity(task);
      await _localDataSource.insertTask(entity);
      return const Outcome.success();
    } catch (e) {
      return Outcome.failure(
        error: GenericError(),
        message: 'Failed to create task',
        throwable: e,
      );
    }
  }

  @override
  Future<Outcome<void, TaskRepositoryErrors>> deleteTask(int id) async {
    try {
      await _localDataSource.deleteTask(id);
      return const Outcome.success();
    } catch (e) {
      return Outcome.failure(
        error: GenericError(),
        message: 'Failed to delete task',
        throwable: e,
      );
    }
  }

  @override
  Future<Outcome<void, TaskRepositoryErrors>> updateTask(TaskModel task) async {
    try {
      final entity = TaskMapper.toEntity(task);
      await _localDataSource.updateTask(entity);
      return const Outcome.success();
    } catch (e) {
      return Outcome.failure(
        error: GenericError(),
        message: 'Failed to update task',
        throwable: e,
      );
    }
  }

  @override
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
  }) {
    return _localDataSource
        .watchTasks(
          page: page,
          limitPerPage: limitPerPage,
          search: search,
          startDate: startDate,
          endDate: endDate,
          orderBy: orderBy,
          status: status,
          priority: priority,
          complexity: complexity,
          type: type,
          onlyActive: onlyActive,
          ascending: ascending,
        )
        .map<ResultPage<TaskModel>>((event) {
          final result = event.items
              .map((data) => TaskMapper.fromEntity(data))
              .toList();

          return ResultPage(
            items: result,
            totalItems: event.totalItems,
            number: page,
            totalPages: event.totalPages,
            limitPerPage: limitPerPage,
          );
        })
        .map<Outcome<ResultPage<TaskModel>, TaskRepositoryErrors>>((
          pageResult,
        ) {
          return Outcome<ResultPage<TaskModel>, TaskRepositoryErrors>.success(
            value: pageResult,
          );
        })
        .handleError((error, stack) {
          return Outcome<ResultPage<TaskModel>, TaskRepositoryErrors>.failure(
            error: TaskRepositoryErrors.databaseError(),
          );
        });
  }

  @override
  Future<Outcome<TaskModel, TaskRepositoryErrors>> getTaskById(
    int taskId,
  ) async {
    try {
      final entity = await _localDataSource.getTaskById(taskId);
      if (entity == null) {
        return Outcome.failure(
          error: TaskRepositoryErrors.notFound(
            message: 'Task not found',
            throwable: null,
          ),
        );
      }
      return Outcome.success(value: TaskMapper.fromEntity(entity));
    } catch (e) {
      return Outcome.failure(
        error: GenericError(),
        message: 'Failed to get task',
        throwable: e,
      );
    }
  }
}
