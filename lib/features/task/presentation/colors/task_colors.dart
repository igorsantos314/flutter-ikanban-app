import 'package:flutter/material.dart';

enum TaskColors {  
  defaultColor, // Gray
  red,
  green,
  blue,
  yellow,
  purple,
  orange,
  teal,
  lavender,
  blueGrey,
}

extension TaskColorsExtension on TaskColors {
  Color get color {
    switch (this) {
      case TaskColors.defaultColor:
        return const Color(0xFF9E9E9E); // Gray
      case TaskColors.red:
        return const Color(0xFFF44336);
      case TaskColors.green:
        return const Color(0xFF4CAF50);
      case TaskColors.blue:
        return const Color(0xFF2196F3);
      case TaskColors.yellow:
        return const Color(0xFFFFEB3B);
      case TaskColors.purple:
        return const Color(0xFF9C27B0);
      case TaskColors.orange:
        return const Color(0xFFFF9800);
      case TaskColors.teal:
        return const Color(0xFF009688);
      case TaskColors.lavender:
        return const Color(0xFFE1BEE7);
      case TaskColors.blueGrey:
        return const Color(0xFF607D8B);
    }
  }

  static List<Color> get availableColors =>
      TaskColors.values.map((e) => e.color).toList();
}