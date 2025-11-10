import 'package:flutter/material.dart';

enum TaskComplexity {
  trivial,    // Trivial
  easy,       // Fácil
  medium,     // Médio
  hard,       // Difícil
  veryHard,   // Muito Difícil
}

extension TaskComplexityExtension on TaskComplexity {
  // Nome em português
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

  // Cor
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

  // Ícone
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

  // Valor numérico (1-5)
  int get complexityValue {
    switch (this) {
      case TaskComplexity.trivial:
        return 10;
      case TaskComplexity.easy:
        return 20;
      case TaskComplexity.medium:
        return 30;
      case TaskComplexity.hard:
        return 40;
      case TaskComplexity.veryHard:
        return 50;
    }
  }

  // Story Points sugerido
  int get suggestedStoryPoints {
    switch (this) {
      case TaskComplexity.trivial:
        return 1;
      case TaskComplexity.easy:
        return 2;
      case TaskComplexity.medium:
        return 3;
      case TaskComplexity.hard:
        return 5;
      case TaskComplexity.veryHard:
        return 8;
    }
  }

  // Descrição
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

  // Emoji
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