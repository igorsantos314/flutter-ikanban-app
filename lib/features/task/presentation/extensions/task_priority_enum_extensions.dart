import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';

extension TaskPriorityExtension on TaskPriority {
  // Nome em português
  String get displayName {
    switch (this) {
      case TaskPriority.lowest:
        return 'Mínima';
      case TaskPriority.low:
        return 'Baixa';
      case TaskPriority.medium:
        return 'Média';
      case TaskPriority.high:
        return 'Alta';
      case TaskPriority.highest:
        return 'Máxima';
      case TaskPriority.critical:
        return 'Crítica';
    }
  }

  // Cor
  Color get color {
    switch (this) {
      case TaskPriority.lowest:
        return Colors.grey;
      case TaskPriority.low:
        return Colors.blue;
      case TaskPriority.medium:
        return Colors.green;
      case TaskPriority.high:
        return Colors.orange;
      case TaskPriority.highest:
        return Colors.deepOrange;
      case TaskPriority.critical:
        return Colors.red;
    }
  }

  // Ícone
  IconData get icon {
    switch (this) {
      case TaskPriority.lowest:
        return Icons.arrow_downward;
      case TaskPriority.low:
        return Icons.low_priority;
      case TaskPriority.medium:
        return Icons.drag_handle;
      case TaskPriority.high:
        return Icons.priority_high;
      case TaskPriority.highest:
        return Icons.keyboard_double_arrow_up;
      case TaskPriority.critical:
        return Icons.emergency;
    }
  }

  // Valor numérico (para ordenação)
  int get value {
    switch (this) {
      case TaskPriority.lowest:
        return 1;
      case TaskPriority.low:
        return 2;
      case TaskPriority.medium:
        return 3;
      case TaskPriority.high:
        return 4;
      case TaskPriority.highest:
        return 5;
      case TaskPriority.critical:
        return 6;
    }
  }

  // Descrição
  String get description {
    switch (this) {
      case TaskPriority.lowest:
        return 'Pode esperar, sem urgência';
      case TaskPriority.low:
        return 'Prioridade baixa, fazer quando possível';
      case TaskPriority.medium:
        return 'Prioridade normal';
      case TaskPriority.high:
        return 'Importante, fazer em breve';
      case TaskPriority.highest:
        return 'Muito importante, priorizar';
      case TaskPriority.critical:
        return 'Crítico, fazer imediatamente!';
    }
  }

  int get priorityValue {
    switch (this) {
      case TaskPriority.lowest:
        return 0;
      case TaskPriority.low:
        return 10;
      case TaskPriority.medium:
        return 20;
      case TaskPriority.high:
        return 30;
      case TaskPriority.highest:
        return 40;
      case TaskPriority.critical:
        return 50;
    }
  }
}