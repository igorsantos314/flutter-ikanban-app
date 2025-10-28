import 'package:flutter/material.dart';

class ColorSelector extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onColorSelected;
  final List<Color> availableColors;

  const ColorSelector({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    required this.availableColors,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: availableColors.map((color) {
        final isSelected = color == selectedColor;
        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.black, width: 3)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}
  