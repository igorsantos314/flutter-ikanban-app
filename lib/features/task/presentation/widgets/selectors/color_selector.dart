import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/presentation/colors/task_colors.dart';

class ColorSelector extends StatelessWidget {
  final TaskColors? selectedColor;
  final Function(TaskColors) onColorSelected;
  final List<TaskColors> availableColors;

  const ColorSelector({
    super.key,
    this.selectedColor,
    required this.onColorSelected,
    required this.availableColors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cores',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: availableColors.map((color) {
              final isSelected = color == selectedColor;
              return GestureDetector(
              onTap: () => onColorSelected(color),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.black, width: 3)
                        : null,
                  ),
                ),
              ),
            );
          }).toList(),
          ),
        ),
      ],
    );
  }
}
  