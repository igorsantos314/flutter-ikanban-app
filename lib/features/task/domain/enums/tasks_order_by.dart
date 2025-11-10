enum SortField {
  createdAt,
  title,
  priority,
  complexity,
  dueDate,
}

enum SortOrder {
  ascending,
  descending,
}

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
