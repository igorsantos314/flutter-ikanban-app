import 'package:drift/drift.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';

class StatusSqlConverter extends TypeConverter<TaskStatus, int> {
  const StatusSqlConverter();

  @override
  TaskStatus fromSql(int fromDb) {
    return TaskStatus.values.firstWhere((e) => e.statusValue == fromDb);
  }

  @override
  int toSql(TaskStatus value) => value.statusValue;
}