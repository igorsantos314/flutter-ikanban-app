import 'package:flutter_ikanban_app/core/app/app_startup/domain/errors/task_list_preferences_error.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/domain/repository/task_list_preferences_repository.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/infra/local/task_list_preferences_data_source.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/presentation/enums/task_layout.dart';

class TaskListPreferencesRepositoryImpl
    implements TaskListPreferencesRepository {
  final TaskListPreferencesLocalDataSource _dataSource;

  TaskListPreferencesRepositoryImpl(this._dataSource);

  @override
  Future<Outcome<TaskStatus?, TaskListPreferencesError>>
  getSelectedStatus() async {
    try {
      final status = await _dataSource.getSelectedStatus();
      return Outcome.success(value: status);
    } catch (e) {
      return Outcome.failure(error: TaskListPreferencesError.genericError());
    }
  }

  @override
  Future<Outcome<List<TaskType>, TaskListPreferencesError>>
  getTaskListTypeFilter() async {
    try {
      final taskTypes = await _dataSource.getTaskListTypeFilter();
      return Outcome.success(value: taskTypes);
    } catch (e) {
      return Outcome.failure(error: TaskListPreferencesError.genericError());
    }
  }

  @override
  Future<Outcome<void, TaskListPreferencesError>> setSelectedStatus(
    TaskStatus taskStatus,
  ) async {
    try {
      await _dataSource.setSelectedStatus(taskStatus);
      return const Outcome.success();
    } catch (e) {
      return Outcome.failure(error: TaskListPreferencesError.genericError());
    }
  }

  @override
  Future<Outcome<void, TaskListPreferencesError>> setTaskListTypeFilter(
    List<TaskType> taskTypes,
  ) async {
    try {
      await _dataSource.setTaskListTypeFilter(taskTypes);
      return const Outcome.success();
    } catch (e) {
      return Outcome.failure(error: TaskListPreferencesError.genericError());
    }
  }

  @override
  Future<Outcome<TaskLayout, TaskListPreferencesError>> getLayoutMode() async {
    try {
      final layoutMode = await _dataSource.getLayoutMode();
      return Outcome.success(value: layoutMode);
    } catch (e) {
      return Outcome.failure(error: TaskListPreferencesError.genericError());
    }
  }

  @override
  Future<Outcome<void, TaskListPreferencesError>> setLayoutMode(
    TaskLayout layoutMode,
  ) async {
    try {
      await _dataSource.setLayoutMode(layoutMode);
      return const Outcome.success();
    } catch (e) {
      return Outcome.failure(error: TaskListPreferencesError.genericError());
    }
  }
}
