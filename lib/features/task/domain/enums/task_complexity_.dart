enum TaskComplexity {
  trivial,    // Trivial
  easy,       // Fácil
  medium,     // Médio
  hard,       // Difícil
  veryHard,   // Muito Difícil
}

extension TaskComplexityExtension on TaskComplexity {
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
}