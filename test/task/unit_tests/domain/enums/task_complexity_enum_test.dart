import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';
import 'package:flutter_ikanban_app/features/task/presentation/extensions/task_complexity_enum_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("TaskComplexity enum", () {
    test("should contain all expected values", () {
      expect(TaskComplexity.values.length, 5);
      expect(TaskComplexity.values, containsAll([
        TaskComplexity.trivial,
        TaskComplexity.easy,
        TaskComplexity.medium,
        TaskComplexity.hard,
        TaskComplexity.veryHard,
      ]));
    });

    test("should have correct complexityValue values", () {
      expect(TaskComplexity.trivial.complexityValue, 10);
      expect(TaskComplexity.easy.complexityValue, 20);
      expect(TaskComplexity.medium.complexityValue, 30);
      expect(TaskComplexity.hard.complexityValue, 40);
      expect(TaskComplexity.veryHard.complexityValue, 50);
    });

    test("should have correct suggestedStoryPoints values", () {
      expect(TaskComplexity.trivial.suggestedStoryPoints, 1);
      expect(TaskComplexity.easy.suggestedStoryPoints, 2);
      expect(TaskComplexity.medium.suggestedStoryPoints, 3);
      expect(TaskComplexity.hard.suggestedStoryPoints, 5);
      expect(TaskComplexity.veryHard.suggestedStoryPoints, 8);
    });

    test("should have correct display names", () {
      expect(TaskComplexity.trivial.displayName, 'Trivial');
      expect(TaskComplexity.easy.displayName, 'Fácil');
      expect(TaskComplexity.medium.displayName, 'Médio');
      expect(TaskComplexity.hard.displayName, 'Difícil');
      expect(TaskComplexity.veryHard.displayName, 'Muito Difícil');
    });

    test("should have correct description values", () {
      expect(TaskComplexity.trivial.description, 'Muito simples, poucos minutos');
      expect(TaskComplexity.easy.description, 'Simples, até 1 hora');
      expect(TaskComplexity.medium.description, 'Requer algum esforço, algumas horas');
      expect(TaskComplexity.hard.description, 'Complexo, pode levar dias');
      expect(TaskComplexity.veryHard.description, 'Muito complexo, grande esforço');
    });

    test("should have correct icon values", () {
      expect(TaskComplexity.trivial.icon, Icons.sentiment_very_satisfied);
      expect(TaskComplexity.easy.icon, Icons.sentiment_satisfied);
      expect(TaskComplexity.medium.icon, Icons.sentiment_neutral);
      expect(TaskComplexity.hard.icon, Icons.sentiment_dissatisfied);
      expect(TaskComplexity.veryHard.icon, Icons.sentiment_very_dissatisfied);
    });

    test("should have correct color", () {
      expect(TaskComplexity.trivial.color, Colors.lightGreen);
      expect(TaskComplexity.easy.color, Colors.green);
      expect(TaskComplexity.medium.color, Colors.orange);
      expect(TaskComplexity.hard.color, Colors.deepOrange);
      expect(TaskComplexity.veryHard.color, Colors.red);
    });

    test("should have correct emoji values", () {
      expect(TaskComplexity.trivial.emoji, '😊');
      expect(TaskComplexity.easy.emoji, '🙂');
      expect(TaskComplexity.medium.emoji, '😐');
      expect(TaskComplexity.hard.emoji, '😰');
      expect(TaskComplexity.veryHard.emoji, '😱');
    });

    test("complexityValue should be unique for each TaskComplexity", () {
      final complexityValues = TaskComplexity.values.map((e) => e.complexityValue).toList();
      final uniqueComplexityValues = complexityValues.toSet();
      expect(complexityValues.length, uniqueComplexityValues.length);
    });

    test("suggestedStoryPoints should be unique for each TaskComplexity", () {
      final storyPoints = TaskComplexity.values.map((e) => e.suggestedStoryPoints).toList();
      final uniqueStoryPoints = storyPoints.toSet();
      expect(storyPoints.length, uniqueStoryPoints.length);
    });

    test("displayName should be unique for each TaskComplexity", () {
      final displayNames = TaskComplexity.values.map((e) => e.displayName).toList();
      final uniqueDisplayNames = displayNames.toSet();
      expect(displayNames.length, uniqueDisplayNames.length);
    });

    test("description should be unique for each TaskComplexity", () {
      final descriptions = TaskComplexity.values.map((e) => e.description).toList();
      final uniqueDescriptions = descriptions.toSet();
      expect(descriptions.length, uniqueDescriptions.length);
    });

    test("complexityValue should be in ascending order", () {
      expect(TaskComplexity.trivial.complexityValue < TaskComplexity.easy.complexityValue, true);
      expect(TaskComplexity.easy.complexityValue < TaskComplexity.medium.complexityValue, true);
      expect(TaskComplexity.medium.complexityValue < TaskComplexity.hard.complexityValue, true);
      expect(TaskComplexity.hard.complexityValue < TaskComplexity.veryHard.complexityValue, true);
    });

    test("suggestedStoryPoints should follow Fibonacci-like sequence", () {
      expect(TaskComplexity.trivial.suggestedStoryPoints, 1);
      expect(TaskComplexity.easy.suggestedStoryPoints, 2);
      expect(TaskComplexity.medium.suggestedStoryPoints, 3);
      expect(TaskComplexity.hard.suggestedStoryPoints, 5);
      expect(TaskComplexity.veryHard.suggestedStoryPoints, 8);
    });
  });
}