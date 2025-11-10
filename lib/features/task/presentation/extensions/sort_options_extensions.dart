import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/tasks_order_by.dart';

extension SortFieldExtension on SortField {
  String get fieldName {
    switch (this) {
      case SortField.title:
        return 'title';
      case SortField.status:
        return 'status';
      case SortField.priority:
        return 'priority';
      case SortField.complexity:
        return 'complexity';
      case SortField.type:
        return 'type';
      case SortField.dueDate:
        return 'dueDate';
      case SortField.createdAt:
        return 'createdAt';
    }
  }

  String get displayName {
    switch (this) {
      case SortField.title:
        return 'Título';
      case SortField.status:
        return 'Status';
      case SortField.priority:
        return 'Prioridade';
      case SortField.complexity:
        return 'Complexidade';
      case SortField.type:
        return 'Tipo';
      case SortField.dueDate:
        return 'Data de Entrega';
      case SortField.createdAt:
        return 'Data de Criação';
    }
  }

  IconData get icon {
    switch (this) {
      case SortField.title:
        return Icons.title;
      case SortField.status:
        return Icons.toggle_on;
      case SortField.priority:
        return Icons.priority_high;
      case SortField.complexity:
        return Icons.speed;
      case SortField.type:
        return Icons.category;
      case SortField.dueDate:
        return Icons.event;
      case SortField.createdAt:
        return Icons.access_time;
    }
  }

  String get description {
    switch (this) {
      case SortField.title:
        return 'Ordenar alfabeticamente pelo título';
      case SortField.status:
        return 'Ordenar pelo status da tarefa';
      case SortField.priority:
        return 'Ordenar pelo nível de prioridade';
      case SortField.complexity:
        return 'Ordenar pelo nível de complexidade';
      case SortField.type:
        return 'Ordenar por tipo de tarefa';
      case SortField.dueDate:
        return 'Ordenar pela data de entrega';
      case SortField.createdAt:
        return 'Ordenar pela data de criação';
    }
  }
}
