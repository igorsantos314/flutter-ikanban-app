import 'package:flutter_ikanban_app/core/services/shared_prefs_service.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';

class TaskListPreferencesLocalDataSource {
  final SharedPrefsService _preferences = SharedPrefsService.instance;
  static const String taskListTypeFilter = 'task_list_type_filter';
  static const String selectedStatus = 'selected_status';

  Future<List<TaskType>> getTaskListTypeFilter() async {
    final stringList =
        await _preferences.getStringList(taskListTypeFilter) ?? [];
    return stringList
        .map((e) => TaskType.values.firstWhere((type) => type.name == e))
        .toList();
  }

  Future<void> setTaskListTypeFilter(List<TaskType> taskTypes) async {
    await _preferences.setStringList(
      taskListTypeFilter,
      taskTypes.map((e) => e.name).toList(),
    );
  }

  Future<TaskStatus> getSelectedStatus() async {
    final statusString = await _preferences.getString(selectedStatus);
    if (statusString == null) {
      return TaskStatus.todo;
    }
    return TaskStatus.values.firstWhere(
      (status) => status.name == statusString,
    );
  }

  Future<void> setSelectedStatus(TaskStatus taskStatus) async {
    await _preferences.setString(selectedStatus, taskStatus.name);
  }
}
