import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';

extension TaskComplexityExtension on TaskComplexity {
  String get displayName {
    switch (this) {
      case TaskComplexity.trivial:
        return 'Trivial';
      case TaskComplexity.easy:
        return 'Fácil';
      case TaskComplexity.medium:
        return 'Médio';
      case TaskComplexity.hard:
        return 'Difícil';
      case TaskComplexity.veryHard:
        return 'Muito Difícil';
    }
  }

  Color get color {
    switch (this) {
      case TaskComplexity.trivial:
        return Colors.lightGreen;
      case TaskComplexity.easy:
        return Colors.green;
      case TaskComplexity.medium:
        return Colors.orange;
      case TaskComplexity.hard:
        return Colors.deepOrange;
      case TaskComplexity.veryHard:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case TaskComplexity.trivial:
        return Icons.sentiment_very_satisfied;
      case TaskComplexity.easy:
        return Icons.sentiment_satisfied;
      case TaskComplexity.medium:
        return Icons.sentiment_neutral;
      case TaskComplexity.hard:
        return Icons.sentiment_dissatisfied;
      case TaskComplexity.veryHard:
        return Icons.sentiment_very_dissatisfied;
    }
  }

  String get description {
    switch (this) {
      case TaskComplexity.trivial:
        return 'Muito simples, poucos minutos';
      case TaskComplexity.easy:
        return 'Simples, até 1 hora';
      case TaskComplexity.medium:
        return 'Requer algum esforço, algumas horas';
      case TaskComplexity.hard:
        return 'Complexo, pode levar dias';
      case TaskComplexity.veryHard:
        return 'Muito complexo, grande esforço';
    }
  }

  String get emoji {
    switch (this) {
      case TaskComplexity.trivial:
        return '😊';
      case TaskComplexity.easy:
        return '🙂';
      case TaskComplexity.medium:
        return '😐';
      case TaskComplexity.hard:
        return '😰';
      case TaskComplexity.veryHard:
        return '😱';
    }
  }
}