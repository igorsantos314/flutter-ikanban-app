import 'package:flutter_ikanban_app/core/app/app_startup/domain/errors/task_list_preferences_error.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/presentation/enums/task_layout.dart';

abstract class TaskListPreferencesRepository {
  Future<Outcome<List<TaskType>, TaskListPreferencesError>> getTaskListTypeFilter();
  Future<Outcome<void, TaskListPreferencesError>> setTaskListTypeFilter(List<TaskType> taskTypes);
  Future<Outcome<TaskStatus?, TaskListPreferencesError>> getSelectedStatus();
  Future<Outcome<void, TaskListPreferencesError>> setSelectedStatus(TaskStatus taskStatus);
  Future<Outcome<void, TaskListPreferencesError>> setLayoutMode(TaskLayout layoutMode);
  Future<Outcome<TaskLayout, TaskListPreferencesError>> getLayoutMode();
}
