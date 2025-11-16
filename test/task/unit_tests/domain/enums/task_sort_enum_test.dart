import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_sort.dart';
import 'package:flutter_ikanban_app/features/task/presentation/extensions/sort_options_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SortField enum', () {
    test('should contain all expected values', () {
      expect(SortField.values.length, 5);
      expect(SortField.values, containsAll([
        SortField.createdAt,
        SortField.title,
        SortField.priority,
        SortField.complexity,
        SortField.dueDate,
      ]));
    });

    test('should have correct index values', () {
      expect(SortField.createdAt.index, 0);
      expect(SortField.title.index, 1);
      expect(SortField.priority.index, 2);
      expect(SortField.complexity.index, 3);
      expect(SortField.dueDate.index, 4);
    });

    test('should have correct string values', () {
      expect(SortField.createdAt.displayName, 'Data de Criação');
      expect(SortField.title.displayName, 'Título');
      expect(SortField.priority.displayName, 'Prioridade');
      expect(SortField.complexity.displayName, 'Complexidade');
      expect(SortField.dueDate.displayName, 'Data de Vencimento');
    });

    test('should have correct icon values', () {
      expect(SortField.createdAt.icon, Icons.access_time);
      expect(SortField.title.icon, Icons.title);
      expect(SortField.priority.icon, Icons.priority_high);
      expect(SortField.complexity.icon, Icons.speed);
      expect(SortField.dueDate.icon, Icons.event);
    });

    test('should have correct description values', () {
      expect(SortField.createdAt.description, 'Ordenar pela data de criação');
      expect(SortField.title.description, 'Ordenar alfabeticamente pelo título');
      expect(SortField.priority.description, 'Ordenar pelo nível de prioridade');
      expect(SortField.complexity.description, 'Ordenar pelo nível de complexidade');
      expect(SortField.dueDate.description, 'Ordenar pela data de entrega');
    });
  });
}
