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
        return const Color.fromARGB(255, 158, 158, 158); // Gray
      case TaskColors.red:
        return const Color.fromARGB(255, 255, 179, 186);
      case TaskColors.green:
        return const Color.fromARGB(255, 186, 255, 201);
      case TaskColors.blue:
        return const Color.fromARGB(255, 186, 225, 255);
      case TaskColors.yellow:
        return const Color.fromARGB(255, 255, 255, 186);
      case TaskColors.purple:
        return const Color.fromARGB(255, 186, 147, 255);
      case TaskColors.orange:
        return const Color.fromARGB(255, 255, 223, 186);
      case TaskColors.teal:
        return const Color.fromARGB(255, 141, 255, 244);
      case TaskColors.lavender:
        return const Color.fromARGB(255, 230, 190, 255);
      case TaskColors.blueGrey:
        return const Color.fromARGB(255, 96, 125, 139);
    }
  }

  static List<Color> get availableColors =>
      TaskColors.values.map((e) => e.color).toList();
}
