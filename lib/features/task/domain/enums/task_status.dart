enum TaskStatus {
  all,          // Todos os status
  backlog,      // Backlog (ideias/futuro)
  todo,         // A Fazer
  inProgress,   // Em Progresso
  blocked,      // Bloqueado
  review,       // Em Revisão
  testing,      // Em Teste
  done,         // Concluído
  cancelled,    // Cancelado
  archived,    // Arquivado (não usado atualmente)
}

extension TaskStatusExtension on TaskStatus {
  // Status está ativo?
  bool get isActive {
    return this != TaskStatus.done && this != TaskStatus.cancelled;
  }

  // Status está finalizado?
  bool get isFinished {
    return this == TaskStatus.done || this == TaskStatus.cancelled;
  }

  // Status está em andamento?
  bool get isInProgress {
    return this == TaskStatus.inProgress || 
           this == TaskStatus.review || 
           this == TaskStatus.testing;
  }

  // Progresso em percentual
  double get progressPercentage {
    switch (this) {
      case TaskStatus.backlog:
        return 0.0;
      case TaskStatus.todo:
        return 0.1;
      case TaskStatus.inProgress:
        return 0.5;
      case TaskStatus.blocked:
        return 0.3;
      case TaskStatus.review:
        return 0.75;
      case TaskStatus.testing:
        return 0.85;
      case TaskStatus.done:
        return 1.0;
      case TaskStatus.cancelled:
        return 0.0;
      case TaskStatus.archived:
        return 0.0;
      default:
        return 0.0;
    }
  }

  // Próximo status sugerido
  TaskStatus? get nextStatus {
    switch (this) {
      case TaskStatus.backlog:
        return TaskStatus.todo;
      case TaskStatus.todo:
        return TaskStatus.inProgress;
      case TaskStatus.inProgress:
        return TaskStatus.review;
      case TaskStatus.blocked:
        return TaskStatus.inProgress;
      case TaskStatus.review:
        return TaskStatus.done;
      case TaskStatus.testing:
        return TaskStatus.done;
      case TaskStatus.done:
        return null;
      case TaskStatus.cancelled:
        return null;
      case TaskStatus.archived:
        return null;
      default:
        return null;
    }
  }

  // Status anterior sugerido
  TaskStatus? get previousStatus {
    switch (this) {
      case TaskStatus.backlog:
        return null;
      case TaskStatus.todo:
        return TaskStatus.backlog;
      case TaskStatus.inProgress:
        return TaskStatus.todo;
      case TaskStatus.blocked:
        return TaskStatus.todo;
      case TaskStatus.review:
        return TaskStatus.inProgress;
      case TaskStatus.testing:
        return TaskStatus.review;
      case TaskStatus.done:
        return TaskStatus.review;
      case TaskStatus.cancelled:
        return null;
      case TaskStatus.archived:
        return null;
      default:
        return null;
    }
  }

  int get statusValue {
    switch (this) {
      case TaskStatus.all:
        return 0;
      case TaskStatus.backlog:
        return 10;
      case TaskStatus.todo:
        return 20;
      case TaskStatus.inProgress:
        return 30;
      case TaskStatus.blocked:
        return 40;
      case TaskStatus.review:
        return 50;
      case TaskStatus.testing:
        return 60;
      case TaskStatus.done:
        return 70;
      case TaskStatus.cancelled:
        return 80;
      case TaskStatus.archived:
        return 90;
    }
  }

  TaskStatus? fromValue(int value) {
    for (var status in TaskStatus.values) {
      if (status.statusValue == value) {
        return status;
      }
    }
    return null;
  }
}
