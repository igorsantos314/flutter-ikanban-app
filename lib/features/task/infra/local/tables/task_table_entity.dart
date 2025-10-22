import 'package:drift/drift.dart';

@DataClassName('TaskData')
class TaskEntity extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get description => text().nullable()();
  TextColumn get status => text().withLength(min: 1, max: 50)();
  TextColumn get priority => text().withLength(min: 1, max: 50)();
  DateTimeColumn get dueDate => dateTime().named('due_date').nullable()();
  TextColumn get complexity => text().withLength(min: 1, max: 50)();
  TextColumn get type => text().withLength(min: 1, max: 50)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
