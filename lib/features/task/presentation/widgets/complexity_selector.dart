// widgets/complexity_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';

class ComplexitySelector extends StatelessWidget {
  final TaskComplexity selectedComplexity;
  final Function(TaskComplexity) onComplexitySelected;

  const ComplexitySelector({
    super.key,
    required this.selectedComplexity,
    required this.onComplexitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Complexidade',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: TaskComplexity.values.map((complexity) {
            final isSelected = complexity == selectedComplexity;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: InkWell(
                  onTap: () => onComplexitySelected(complexity),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? complexity.color 
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: complexity.color,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          complexity.icon,
                          color: isSelected ? Colors.white : complexity.color,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          complexity.value.toString(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Text(
          '${selectedComplexity.emoji} ${selectedComplexity.displayName}: ${selectedComplexity.description}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}