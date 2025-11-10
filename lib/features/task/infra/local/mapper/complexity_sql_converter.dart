import 'package:drift/drift.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';

class ComplexitySqlConverter extends TypeConverter<TaskComplexity, int> {
  const ComplexitySqlConverter();

  @override
  TaskComplexity fromSql(int fromDb) {
    return TaskComplexity.values.firstWhere((e) => e.complexityValue == fromDb);
  }

  @override
  int toSql(TaskComplexity value) => value.complexityValue;
}
