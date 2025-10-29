import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';

class TaskStatusFilter extends StatelessWidget {
  final List<TaskStatus> selectedStatuses;
  final Function(List<TaskStatus>) onChanged;
  final bool showSelectAll;

  const TaskStatusFilter({
    super.key,
    required this.selectedStatuses,
    required this.onChanged,
    this.showSelectAll = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAllSelected = selectedStatuses.length == TaskStatus.values.length;
    
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
                label: const Text('Todos'),
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
                selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                checkmarkColor: Theme.of(context).primaryColor,
                avatar: Icon(
                  isAllSelected ? Icons.check_box : Icons.check_box_outline_blank,
                  size: 18,
                  color: isAllSelected ? Theme.of(context).primaryColor : null,
                ),
              ),
            ),
          
          // Chips dos status
          ...TaskStatus.values.map((status) {
            final bool isSelected = selectedStatuses.contains(status);
            
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: Text(status.displayName),
                selected: isSelected,
                onSelected: (selected) {
                  List<TaskStatus> newSelection = List.from(selectedStatuses);
                  
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
                avatar: Icon(
                  status.icon,
                  size: 16,
                  color: isSelected ? status.color : Colors.grey[600],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
