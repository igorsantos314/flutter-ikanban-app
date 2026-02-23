import 'package:drift/drift.dart';
import 'package:flutter_ikanban_app/core/utils/mapper/generic_sql_int_conveter.dart';
import 'package:flutter_ikanban_app/core/utils/mapper/generic_sql_type_converter.dart';
import 'package:flutter_ikanban_app/features/board/infra/local/tables/board_entity_table.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/infra/local/mapper/complexity_sql_converter.dart';
import 'package:flutter_ikanban_app/features/task/infra/local/mapper/priority_sql_converter.dart';
import 'package:flutter_ikanban_app/features/task/presentation/colors/task_colors.dart';

@DataClassName('TaskData')
class TaskEntity extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get description => text().nullable()();
  TextColumn get status => text().map(GenericSqlTypeConverter(TaskStatus.values))();
  IntColumn get priority => integer().map(PrioritySqlConverter())();
  DateTimeColumn get dueDate => dateTime().named('due_date').nullable()();
  IntColumn get complexity => integer().map(ComplexitySqlConverter())();

  TextColumn get color => text().map(GenericSqlTypeConverter(TaskColors.values))();
  IntColumn get type => integer().map(GenericSqlIntConverter(TaskType.values))();

  BoolColumn get isActive => boolean().named('is_active').withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().named('created_at').withDefault(currentDateAndTime)();
  
  IntColumn get boardId => integer().named('board_id').nullable().references(BoardEntity, #id)();
}
