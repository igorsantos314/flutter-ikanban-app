import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';

class TaskStatusFilter extends StatelessWidget {
  final List<TaskStatus> selectedStatus;
  final Function(List<TaskStatus>) onChanged;
  final bool showSelectAll;

  const TaskStatusFilter({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
    this.showSelectAll = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isAllSelected =
        selectedStatus.length == TaskStatus.values.length;

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Chip "Todos"
          if (showSelectAll)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: Row(
                  children: [
                    Icon(
                      isAllSelected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 18,
                      color: isAllSelected ? theme.primaryColor : null,
                    ),
                    Text('Todos'),
                  ],
                ),
                selected: isAllSelected,
                onSelected: (selected) {
                  if (selected) {
                    // Selecionar todos
                    onChanged(List.from(TaskStatus.values));
                  } else {
                    // Deselecionar todos
                    onChanged([]);
                  }
                },
                selectedColor: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                checkmarkColor: theme.colorScheme.onSurface,
              ),
            ),

          // Chips dos status
          ...TaskStatus.values.map((status) {
            final bool isSelected = selectedStatus.contains(status);

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: Row(
                  children: [
                    Icon(
                      status.icon,
                      size: 16,
                      color: isSelected ? status.color : theme.disabledColor,
                    ),
                    Text(status.displayName),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  List<TaskStatus> newSelection = List.from(selectedStatus);

                  if (selected) {
                    // Adicionar status
                    if (!newSelection.contains(status)) {
                      newSelection.add(status);
                    }
                  } else {
                    // Remover status
                    newSelection.remove(status);
                  }

                  onChanged(newSelection);
                },
                selectedColor: status.color.withValues(alpha: 0.3),
                checkmarkColor: status.color,
              ),
            );
          }),
        ],
      ),
    );
  }
}
