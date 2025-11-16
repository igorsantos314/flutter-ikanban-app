import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';

extension TaskStatusExtension on TaskStatus {
  // Nome em português
  String get displayName {
    switch (this) {
      case TaskStatus.all:
        return 'Todos';
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
      case TaskStatus.archived:
        return 'Arquivado';
    }
  }

  // Cor
  Color get color {
    switch (this) {
      case TaskStatus.all:
        return Colors.grey;
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
      case TaskStatus.archived:
        return Colors.brown;
    }
  }

  // Ícone
  IconData get icon {
    switch (this) {
      case TaskStatus.all:
        return Icons.list;
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
      case TaskStatus.archived:
        return Icons.archive;
    }
  }

  // Descrição
  String get description {
    switch (this) {
      case TaskStatus.all:
        return 'Todos os status';
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
      case TaskStatus.archived:
        return 'Tarefa arquivada';
    }
  }
}
