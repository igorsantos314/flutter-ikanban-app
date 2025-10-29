// widgets/priority_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';

class PrioritySelector extends StatelessWidget {
  final TaskPriority selectedPriority;
  final Function(TaskPriority) onPrioritySelected;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prioridade',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TaskPriority.values.map((priority) {
            final isSelected = priority == selectedPriority;
            return ChoiceChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    priority.icon,
                    size: 16,
                    color: isSelected ? Colors.white : priority.color,
                  ),
                  const SizedBox(width: 4),
                  Text(priority.displayName),
                ],
              ),
              backgroundColor: Colors.grey[200],
              selectedColor: priority.color,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
              ),
              onSelected: (selected) {
                if (selected) {
                  onPrioritySelected(priority);
                }
              },
            );
          }).toList(),
        ),
        ...[
        const SizedBox(height: 8),
        Text(
          selectedPriority.description,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
      ],
    );
  }
}