import 'package:drift/drift.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';

class TaskSqlConverter extends TypeConverter<TaskType, int> {
  const TaskSqlConverter();

  @override
  TaskType fromSql(int fromDb) {
    return TaskType.values.firstWhere((e) => e.typeValue == fromDb);
  }

  @override
  int toSql(TaskType value) => value.typeValue;
}
