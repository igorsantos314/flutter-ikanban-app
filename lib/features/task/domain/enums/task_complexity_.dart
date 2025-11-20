enum TaskComplexity {
  trivial,
  easy,
  medium,
  hard,
  veryHard,
}

extension TaskComplexityExtension on TaskComplexity {
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

  // Suggested Story Points
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