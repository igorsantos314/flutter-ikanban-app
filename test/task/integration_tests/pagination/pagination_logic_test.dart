import 'package:flutter_ikanban_app/core/utils/result/result_page.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Helper para criar tasks de teste
  List<TaskModel> createTestTasks(int count) {
    return List.generate(
      count,
      (index) => TaskModel(
        id: index + 1,
        title: 'Task ${index + 1}',
        description: 'Description ${index + 1}',
        status: TaskStatus.todo,
        createdAt: DateTime(2024, 1, 1).add(Duration(days: index)),
      ),
    );
  }

  /// Helper para simular paginação
  ResultPage<TaskModel> paginateItems({
    required int page,
    required int limitPerPage,
    required List<TaskModel> allItems,
  }) {
    final start = (page - 1) * limitPerPage;
    final end = start + limitPerPage;
    
    // Se start está além do tamanho da lista, retorna vazio
    final items = start >= allItems.length
        ? <TaskModel>[]
        : allItems.sublist(
            start,
            end > allItems.length ? allItems.length : end,
          );

    return ResultPage(
      items: items,
      totalItems: allItems.length,
      number: page,
      totalPages: allItems.isEmpty ? 0 : (allItems.length / limitPerPage).ceil(),
      limitPerPage: limitPerPage,
    );
  }

  group('Pagination Logic Tests', () {
    late List<TaskModel> allTasks;

    setUp(() {
      allTasks = createTestTasks(25); // 25 tasks de teste
    });

    group('Basic Pagination', () {
      test('should return first page with correct items', () {
        // Arrange & Act
        final result = paginateItems(
          page: 1,
          limitPerPage: 5,
          allItems: allTasks,
        );

        // Assert
        expect(result.items.length, 5);
        expect(result.number, 1);
        expect(result.limitPerPage, 5);
        expect(result.totalItems, 25);
        expect(result.totalPages, 5); // 25 / 5 = 5 páginas
        expect(result.items[0].title, 'Task 1');
        expect(result.items[4].title, 'Task 5');
      });

      test('should return second page with correct items', () {
        // Arrange & Act
        final result = paginateItems(
          page: 2,
          limitPerPage: 5,
          allItems: allTasks,
        );

        // Assert
        expect(result.items.length, 5);
        expect(result.number, 2);
        expect(result.items[0].title, 'Task 6');
        expect(result.items[4].title, 'Task 10');
      });

      test('should return last page with correct items', () {
        // Arrange & Act
        final result = paginateItems(
          page: 5,
          limitPerPage: 5,
          allItems: allTasks,
        );

        // Assert
        expect(result.items.length, 5);
        expect(result.number, 5);
        expect(result.items[0].title, 'Task 21');
        expect(result.items[4].title, 'Task 25');
      });
    });

    group('Edge Cases', () {
      test('should handle incomplete last page', () {
        // Arrange & Act - 25 itens, 10 por página
        final result = paginateItems(
          page: 3,
          limitPerPage: 10,
          allItems: allTasks,
        );

        // Assert
        expect(result.items.length, 5); // Última página com apenas 5 itens
        expect(result.totalPages, 3); // 25 / 10 = 2.5 -> 3 páginas
        expect(result.items[0].title, 'Task 21');
        expect(result.items[4].title, 'Task 25');
      });

      test('should return empty page when page exceeds total', () {
        // Arrange & Act
        final result = paginateItems(
          page: 10,
          limitPerPage: 5,
          allItems: allTasks,
        );

        // Assert
        expect(result.items.length, 0);
        expect(result.totalItems, 25);
        expect(result.totalPages, 5);
      });

      test('should handle single item per page', () {
        // Arrange & Act
        final result = paginateItems(
          page: 1,
          limitPerPage: 1,
          allItems: allTasks,
        );

        // Assert
        expect(result.items.length, 1);
        expect(result.totalPages, 25); // 25 itens / 1 por página
        expect(result.items[0].title, 'Task 1');
      });

      test('should handle limit greater than total items', () {
        // Arrange & Act
        final result = paginateItems(
          page: 1,
          limitPerPage: 100,
          allItems: allTasks,
        );

        // Assert
        expect(result.items.length, 25); // Todos os itens
        expect(result.totalPages, 1);
        expect(result.number, 1);
      });

      test('should handle empty list', () {
        // Arrange & Act
        final result = paginateItems(
          page: 1,
          limitPerPage: 10,
          allItems: [],
        );

        // Assert
        expect(result.items.length, 0);
        expect(result.totalItems, 0);
        expect(result.totalPages, 0);
      });
    });

    group('Navigation Scenarios', () {
      test('should navigate through all pages without duplicates', () {
        // Arrange
        const limitPerPage = 5;
        final allIds = <int>{};

        // Act - Navega por todas as páginas
        for (int page = 1; page <= 5; page++) {
          final result = paginateItems(
            page: page,
            limitPerPage: limitPerPage,
            allItems: allTasks,
          );

          for (final task in result.items) {
            // Assert - Verifica que não há duplicatas
            expect(allIds.contains(task.id), false,
                reason: 'Task ${task.id} is duplicated');
            allIds.add(task.id!);
          }
        }

        // Assert - Todos os itens foram paginados
        expect(allIds.length, 25);
      });

      test('should maintain consistency when changing page size', () {
        // Arrange & Act
        final page1With10 = paginateItems(
          page: 1,
          limitPerPage: 10,
          allItems: allTasks,
        );

        final page1With5 = paginateItems(
          page: 1,
          limitPerPage: 5,
          allItems: allTasks,
        );

        // Assert - Primeiro item deve ser o mesmo
        expect(page1With10.items[0].id, page1With5.items[0].id);
        expect(page1With10.totalItems, page1With5.totalItems);
      });

      test('should calculate correct page for middle items', () {
        // Arrange & Act - Item 13 está na página 3 (limite 5)
        final result = paginateItems(
          page: 3,
          limitPerPage: 5,
          allItems: allTasks,
        );

        // Assert
        expect(result.items.any((task) => task.id == 13), true);
        expect(result.items[0].id, 11); // Primeiro item da página 3
        expect(result.items[4].id, 15); // Último item da página 3
      });
    });

    group('TotalPages Calculation', () {
      test('should calculate totalPages correctly for exact division', () {
        // Arrange & Act
        final result = paginateItems(
          page: 1,
          limitPerPage: 5,
          allItems: allTasks,
        );

        // Assert - 25 / 5 = 5 páginas exatas
        expect(result.totalPages, 5);
      });

      test('should calculate totalPages correctly with remainder', () {
        // Arrange & Act
        final result = paginateItems(
          page: 1,
          limitPerPage: 10,
          allItems: allTasks,
        );

        // Assert - 25 / 10 = 2.5 -> 3 páginas
        expect(result.totalPages, 3);
      });

      test('should calculate totalPages correctly for single item', () {
        // Arrange & Act
        final result = paginateItems(
          page: 1,
          limitPerPage: 1,
          allItems: allTasks,
        );

        // Assert - 25 / 1 = 25 páginas
        expect(result.totalPages, 25);
      });

      test('should calculate totalPages as 1 when limit exceeds items', () {
        // Arrange & Act
        final result = paginateItems(
          page: 1,
          limitPerPage: 1000,
          allItems: allTasks,
        );

        // Assert
        expect(result.totalPages, 1);
      });
    });

    group('Boundary Tests', () {
      test('should handle first item correctly', () {
        // Arrange & Act
        final result = paginateItems(
          page: 1,
          limitPerPage: 10,
          allItems: allTasks,
        );

        // Assert
        expect(result.items.first.id, 1);
        expect(result.items.first.title, 'Task 1');
      });

      test('should handle last item correctly', () {
        // Arrange & Act
        final result = paginateItems(
          page: 3,
          limitPerPage: 10,
          allItems: allTasks,
        );

        // Assert
        expect(result.items.last.id, 25);
        expect(result.items.last.title, 'Task 25');
      });

      test('should handle page boundaries correctly', () {
        // Arrange & Act - Limites entre páginas 1 e 2
        final page1 = paginateItems(
          page: 1,
          limitPerPage: 10,
          allItems: allTasks,
        );

        final page2 = paginateItems(
          page: 2,
          limitPerPage: 10,
          allItems: allTasks,
        );

        // Assert
        expect(page1.items.last.id, 10);
        expect(page2.items.first.id, 11);
      });
    });
  });
}
