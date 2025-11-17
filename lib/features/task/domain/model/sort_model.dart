import 'package:flutter_ikanban_app/features/task/domain/enums/task_sort.dart';

class SortOption {
  final SortField field;
  final SortOrder order;

  const SortOption({
    required this.field,
    required this.order,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortOption &&
          runtimeType == other.runtimeType &&
          field == other.field &&
          order == other.order;

  @override
  int get hashCode => field.hashCode ^ order.hashCode;
}
