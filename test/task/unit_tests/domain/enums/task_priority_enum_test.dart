import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';
import 'package:flutter_ikanban_app/features/task/presentation/extensions/task_priority_enum_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("TaskPriority enum", () {
    test("should contain all expected values", () {
      expect(TaskPriority.values.length, 6);
      expect(TaskPriority.values, containsAll([
        TaskPriority.lowest,
        TaskPriority.low,
        TaskPriority.medium,
        TaskPriority.high,
        TaskPriority.highest,
        TaskPriority.critical,
      ]));
    });

    test("should have correct priorityValue values", () {
      expect(TaskPriority.lowest.priorityValue, 0);
      expect(TaskPriority.low.priorityValue, 10);
      expect(TaskPriority.medium.priorityValue, 20);
      expect(TaskPriority.high.priorityValue, 30);
      expect(TaskPriority.highest.priorityValue, 40);
      expect(TaskPriority.critical.priorityValue, 50);
    });

    test("should have correct value for ordering", () {
      expect(TaskPriority.lowest.value, 1);
      expect(TaskPriority.low.value, 2);
      expect(TaskPriority.medium.value, 3);
      expect(TaskPriority.high.value, 4);
      expect(TaskPriority.highest.value, 5);
      expect(TaskPriority.critical.value, 6);
    });

    test("should have correct display names", () {
      expect(TaskPriority.lowest.displayName, "Mínima");
      expect(TaskPriority.low.displayName, "Baixa");
      expect(TaskPriority.medium.displayName, "Média");
      expect(TaskPriority.high.displayName, "Alta");
      expect(TaskPriority.highest.displayName, "Máxima");
      expect(TaskPriority.critical.displayName, "Crítica");
    });

    test("should have correct description values", () {
      expect(TaskPriority.lowest.description, "Pode esperar, sem urgência");
      expect(TaskPriority.low.description, "Prioridade baixa, fazer quando possível");
      expect(TaskPriority.medium.description, "Prioridade normal");
      expect(TaskPriority.high.description, "Importante, fazer em breve");
      expect(TaskPriority.highest.description, "Muito importante, priorizar");
      expect(TaskPriority.critical.description, "Crítico, fazer imediatamente!");
    });

    test("should have correct icon values", () {
      expect(TaskPriority.lowest.icon, Icons.arrow_downward);
      expect(TaskPriority.low.icon, Icons.low_priority);
      expect(TaskPriority.medium.icon, Icons.drag_handle);
      expect(TaskPriority.high.icon, Icons.priority_high);
      expect(TaskPriority.highest.icon, Icons.keyboard_double_arrow_up);
      expect(TaskPriority.critical.icon, Icons.emergency);
    });

    test("should have correct color", () {
      expect(TaskPriority.lowest.color, Colors.grey);
      expect(TaskPriority.low.color, Colors.blue);
      expect(TaskPriority.medium.color, Colors.green);
      expect(TaskPriority.high.color, Colors.orange);
      expect(TaskPriority.highest.color, Colors.deepOrange);
      expect(TaskPriority.critical.color, Colors.red);
    });

    test("priorityValue should be unique for each TaskPriority", () {
      final priorityValues = TaskPriority.values.map((e) => e.priorityValue).toList();
      final uniquePriorityValues = priorityValues.toSet();
      expect(priorityValues.length, uniquePriorityValues.length);
    });

    test("value should be unique for each TaskPriority", () {
      final values = TaskPriority.values.map((e) => e.value).toList();
      final uniqueValues = values.toSet();
      expect(values.length, uniqueValues.length);
    });

    test("displayName should be unique for each TaskPriority", () {
      final displayNames = TaskPriority.values.map((e) => e.displayName).toList();
      final uniqueDisplayNames = displayNames.toSet();
      expect(displayNames.length, uniqueDisplayNames.length);
    });

    test("description should be unique for each TaskPriority", () {
      final descriptions = TaskPriority.values.map((e) => e.description).toList();
      final uniqueDescriptions = descriptions.toSet();
      expect(descriptions.length, uniqueDescriptions.length);
    });

    test("value should be in ascending order", () {
      expect(TaskPriority.lowest.value < TaskPriority.low.value, true);
      expect(TaskPriority.low.value < TaskPriority.medium.value, true);
      expect(TaskPriority.medium.value < TaskPriority.high.value, true);
      expect(TaskPriority.high.value < TaskPriority.highest.value, true);
      expect(TaskPriority.highest.value < TaskPriority.critical.value, true);
    });

    test("priorityValue should be in ascending order", () {
      expect(TaskPriority.lowest.priorityValue < TaskPriority.low.priorityValue, true);
      expect(TaskPriority.low.priorityValue < TaskPriority.medium.priorityValue, true);
      expect(TaskPriority.medium.priorityValue < TaskPriority.high.priorityValue, true);
      expect(TaskPriority.high.priorityValue < TaskPriority.highest.priorityValue, true);
      expect(TaskPriority.highest.priorityValue < TaskPriority.critical.priorityValue, true);
    });
  });
}
