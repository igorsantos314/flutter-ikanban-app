import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/presentation/extensions/task_status_enum_extensions.dart';

class TaskStatusFilter extends StatelessWidget {
  final TaskStatus selectedStatus;
  final Function(TaskStatus) onChanged;
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

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Chips dos status
          ...TaskStatus.values.map((status) {
            final bool isSelected = selectedStatus == status;

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
                  onChanged(status);
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
