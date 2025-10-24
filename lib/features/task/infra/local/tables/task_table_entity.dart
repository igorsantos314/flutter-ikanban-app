import 'package:drift/drift.dart';
import 'package:flutter_ikanban_app/core/utils/mapper/generic_sql_type_converter.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';

@DataClassName('TaskData')
class TaskEntity extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get description => text().nullable()();
  TextColumn get status => text().map(GenericSqlTypeConverter(TaskStatus.values))();
  TextColumn get priority => text().map(GenericSqlTypeConverter(TaskPriority.values))();
  DateTimeColumn get dueDate => dateTime().named('due_date').nullable()();
  TextColumn get complexity => text().map(GenericSqlTypeConverter(TaskComplexity.values))();
  TextColumn get type => text().map(GenericSqlTypeConverter(TaskType.values))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
