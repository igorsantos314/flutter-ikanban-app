import 'package:drift/drift.dart';

class GenericSqlTypeConverter<T extends Enum> extends TypeConverter<T, String> {
  final List<T> values;
  
  const GenericSqlTypeConverter(this.values);

  @override
  T fromSql(String fromDb) =>
      values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(T value) => value.name;
}
