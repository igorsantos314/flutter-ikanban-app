import 'package:drift/drift.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';
import 'package:flutter_ikanban_app/features/task/presentation/extensions/task_priority_enum_extensions.dart';

class PrioritySqlConverter extends TypeConverter<TaskPriority, int> {
  const PrioritySqlConverter();

  @override
  TaskPriority fromSql(int fromDb) {
    return TaskPriority.values.firstWhere((e) => e.priorityValue == fromDb);
  }

  @override
  int toSql(TaskPriority value) => value.priorityValue;
}
