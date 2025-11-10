import 'package:drift/drift.dart';

class GenericSqlIntConverter<T extends Enum> extends TypeConverter<T, int> {
  final List<T> values;

  const GenericSqlIntConverter(this.values);

  @override
  T fromSql(int fromDb) =>
      values.firstWhere((e) => e.index == fromDb);

  @override
  int toSql(T value) => value.index;
}
