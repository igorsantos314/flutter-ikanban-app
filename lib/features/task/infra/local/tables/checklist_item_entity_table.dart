import 'package:drift/drift.dart';
import 'package:flutter_ikanban_app/features/task/infra/local/tables/task_table_entity.dart';

@DataClassName('ChecklistItemData')
class ChecklistItemEntity extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().withLength(max: 200).nullable()();
  BoolColumn get isCompleted => boolean().named('is_completed').withDefault(const Constant(false))();
  IntColumn get taskId => integer().named('task_id').references(TaskEntity, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt => dateTime().named('created_at').withDefault(currentDateAndTime)();
}
