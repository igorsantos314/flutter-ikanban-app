import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';
import 'package:flutter_ikanban_app/features/task/presentation/extensions/task_complexity_enum_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("TaskComplexity enum success", () {
    test("displayName returns correct Portuguese names", () {
      expect(TaskComplexity.trivial.displayName, 'Trivial');
      expect(TaskComplexity.easy.displayName, 'Fácil');
      expect(TaskComplexity.medium.displayName, 'Médio');
      expect(TaskComplexity.hard.displayName, 'Difícil');
      expect(TaskComplexity.veryHard.displayName, 'Muito Difícil');
    });

    test("color returns correct colors", () {
      expect(TaskComplexity.trivial.color, Colors.lightGreen);
      expect(TaskComplexity.easy.color, Colors.green);
      expect(TaskComplexity.medium.color, Colors.orange);
      expect(TaskComplexity.hard.color, Colors.deepOrange);
      expect(TaskComplexity.veryHard.color, Colors.red);
    });

    test("icon returns correct icons", () {
      expect(TaskComplexity.trivial.icon, Icons.sentiment_very_satisfied);
      expect(TaskComplexity.easy.icon, Icons.sentiment_satisfied);
      expect(TaskComplexity.medium.icon, Icons.sentiment_neutral);
      expect(TaskComplexity.hard.icon, Icons.sentiment_dissatisfied);
      expect(TaskComplexity.veryHard.icon, Icons.sentiment_very_dissatisfied);
    });
  });
}