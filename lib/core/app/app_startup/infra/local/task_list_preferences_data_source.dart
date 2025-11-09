import 'package:flutter_ikanban_app/core/services/shared_prefs_service.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/presentation/enums/task_layout.dart';

class TaskListPreferencesLocalDataSource {
  final SharedPrefsService _preferences = SharedPrefsService.instance;
  
  static const String taskListTypeFilterKey = 'task_list_type_filter';
  static const String selectedStatusKey = 'selected_status';
  static const String layoutModeKey = 'layout_mode';

  Future<List<TaskType>> getTaskListTypeFilter() async {
    final stringList =
        await _preferences.getStringList(taskListTypeFilterKey) ?? [];
    return stringList
        .map((e) => TaskType.values.firstWhere((type) => type.name == e))
        .toList();
  }

  Future<void> setTaskListTypeFilter(List<TaskType> taskTypes) async {
    await _preferences.setStringList(
      taskListTypeFilterKey,
      taskTypes.map((e) => e.name).toList(),
    );
  }

  Future<TaskStatus> getSelectedStatus() async {
    final statusString = await _preferences.getString(selectedStatusKey);
    if (statusString == null) {
      return TaskStatus.todo;
    }
    return TaskStatus.values.firstWhere(
      (status) => status.name == statusString,
    );
  }

  Future<void> setSelectedStatus(TaskStatus taskStatus) async {
    await _preferences.setString(selectedStatusKey, taskStatus.name);
  }

  Future<void> setLayoutMode(TaskLayout layoutMode) async {
    await _preferences.setString(layoutModeKey, layoutMode.name);
  }

  Future<TaskLayout> getLayoutMode() async {
    final layoutString = await _preferences.getString(layoutModeKey);
    if (layoutString == null) {
      return TaskLayout.list;
    }
    return TaskLayout.values.firstWhere(
      (layout) => layout.name == layoutString,
    );
  }
}
