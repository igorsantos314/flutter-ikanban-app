import 'package:flutter/material.dart';

enum TaskStatus {
  backlog,      // Backlog (ideias/futuro)
  todo,         // A Fazer
  inProgress,   // Em Progresso
  blocked,      // Bloqueado
  review,       // Em Revisão
  testing,      // Em Teste
  done,         // Concluído
  cancelled,    // Cancelado
}

extension TaskStatusExtension on TaskStatus {
  // Nome em português
  String get displayName {
    switch (this) {
      case TaskStatus.backlog:
        return 'Backlog';
      case TaskStatus.todo:
        return 'A Fazer';
      case TaskStatus.inProgress:
        return 'Em Progresso';
      case TaskStatus.blocked:
        return 'Bloqueado';
      case TaskStatus.review:
        return 'Em Revisão';
      case TaskStatus.testing:
        return 'Em Teste';
      case TaskStatus.done:
        return 'Concluído';
      case TaskStatus.cancelled:
        return 'Cancelado';
    }
  }

  // Cor
  Color get color {
    switch (this) {
      case TaskStatus.backlog:
        return Colors.grey;
      case TaskStatus.todo:
        return Colors.blue;
      case TaskStatus.inProgress:
        return Colors.orange;
      case TaskStatus.blocked:
        return Colors.red;
      case TaskStatus.review:
        return Colors.purple;
      case TaskStatus.testing:
        return Colors.amber;
      case TaskStatus.done:
        return Colors.green;
      case TaskStatus.cancelled:
        return Colors.grey[700]!;
    }
  }

  // Ícone
  IconData get icon {
    switch (this) {
      case TaskStatus.backlog:
        return Icons.inventory_2;
      case TaskStatus.todo:
        return Icons.playlist_add_check;
      case TaskStatus.inProgress:
        return Icons.hourglass_empty;
      case TaskStatus.blocked:
        return Icons.block;
      case TaskStatus.review:
        return Icons.rate_review;
      case TaskStatus.testing:
        return Icons.science;
      case TaskStatus.done:
        return Icons.check_circle;
      case TaskStatus.cancelled:
        return Icons.cancel;
    }
  }

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
    }
  }

  // Descrição
  String get description {
    switch (this) {
      case TaskStatus.backlog:
        return 'Ideias e tarefas futuras';
      case TaskStatus.todo:
        return 'Pronto para começar';
      case TaskStatus.inProgress:
        return 'Trabalhando nisso';
      case TaskStatus.blocked:
        return 'Impedido de continuar';
      case TaskStatus.review:
        return 'Aguardando revisão';
      case TaskStatus.testing:
        return 'Em fase de testes';
      case TaskStatus.done:
        return 'Tarefa finalizada';
      case TaskStatus.cancelled:
        return 'Tarefa cancelada';
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
    }
  }
}