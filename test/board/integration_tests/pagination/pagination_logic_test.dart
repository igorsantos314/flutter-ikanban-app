import 'package:flutter_ikanban_app/core/database/app_database.dart';
import 'package:flutter_ikanban_app/core/utils/result/result_page.dart';
import 'package:flutter_ikanban_app/features/board/data/board_repository_impl.dart';
import 'package:flutter_ikanban_app/features/board/domain/model/board_model.dart';
import 'package:flutter_ikanban_app/features/board/infra/local/board_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockBoardLocalDataSource extends Mock implements BoardLocalDataSource {}

void main() {
  late MockBoardLocalDataSource mockDataSource;
  late BoardRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockBoardLocalDataSource();
    repository = BoardRepositoryImpl(mockDataSource);
  });

  /// Helper para criar boards de teste
  List<BoardModel> createTestBoards(int count) {
    return List.generate(
      count,
      (index) => BoardModel(
        id: index + 1,
        title: 'Board ${index + 1}',
        description: 'Description ${index + 1}',
        color: '#${(index % 8 + 1).toString().padLeft(6, '0')}FF',
        createdAt: DateTime(2024, 1, 1).add(Duration(days: index)),
        updatedAt: DateTime(2024, 1, 1).add(Duration(days: index)),
        isActive: true,
      ),
    );
  }

  /// Helper para criar entidades de teste do banco
  List<BoardData> createTestBoardEntities(int count) {
    return List.generate(
      count,
      (index) => BoardData(
        id: index + 1,
        title: 'Board ${index + 1}',
        description: 'Description ${index + 1}',
        color: '#${(index % 8 + 1).toString().padLeft(6, '0')}FF',
        createdAt: DateTime(2024, 1, 1).add(Duration(days: index)),
        updatedAt: DateTime(2024, 1, 1).add(Duration(days: index)),
        isActive: true,
      ),
    );
  }

  /// Helper para paginar entidades manualmente
  ResultPage<BoardData> paginateEntities({
    required int page,
    required int limitPerPage,
    required List<BoardData> allItems,
  }) {
    final start = (page - 1) * limitPerPage;
    final end = start + limitPerPage;
    
    final items = start >= allItems.length
        ? <BoardData>[]
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

  group('Board Repository Pagination Tests', () {
    late List<BoardData> allBoardEntities;

    setUp(() {
      allBoardEntities = createTestBoardEntities(25); // 25 boards de teste
    });

    group('Basic Pagination', () {
      test('should return first page with correct items from repository', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 1,
          limitPerPage: 5,
          allItems: allBoardEntities,
        );

        when(() => mockDataSource.getBoards(
          page: 1,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        );

        // Assert
        result.when(
          success: (page) {
            expect(page, isNotNull);
            expect(page!.items.length, 5);
            expect(page.number, 1);
            expect(page.limitPerPage, 5);
            expect(page.totalItems, 25);
            expect(page.totalPages, 5);
            expect(page.items[0].title, 'Board 1');
            expect(page.items[4].title, 'Board 5');
          },
          failure: (_, __, ___) => fail('Should return success'),
        );

        verify(() => mockDataSource.getBoards(
          page: 1,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        )).called(1);
      });

      test('should return second page with correct items from repository', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 2,
          limitPerPage: 5,
          allItems: allBoardEntities,
        );

        when(() => mockDataSource.getBoards(
          page: 2,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 2,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        );

        // Assert
        expect(result.isSuccess, true);
        final page = result.getSuccess();
        expect(page!.items.length, 5);
        expect(page.number, 2);
        expect(page.items[0].title, 'Board 6');
        expect(page.items[4].title, 'Board 10');
      });

      test('should return last page with correct items from repository', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 5,
          limitPerPage: 5,
          allItems: allBoardEntities,
        );

        when(() => mockDataSource.getBoards(
          page: 5,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 5,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        );

        // Assert
        expect(result.isSuccess, true);
        final page = result.getSuccess();
        expect(page!.items.length, 5);
        expect(page.number, 5);
        expect(page.items[0].title, 'Board 21');
        expect(page.items[4].title, 'Board 25');
      });
    });

    group('Edge Cases', () {
      test('should handle incomplete last page through repository', () async {
        // Arrange - 25 itens, 10 por página
        final expectedPage = paginateEntities(
          page: 3,
          limitPerPage: 10,
          allItems: allBoardEntities,
        );

        when(() => mockDataSource.getBoards(
          page: 3,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 3,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        );

        // Assert
        expect(result.isSuccess, true);
        final page = result.getSuccess();
        expect(page!.items.length, 5); // Última página com apenas 5 itens
        expect(page.totalPages, 3); // 25 / 10 = 2.5 -> 3 páginas
        expect(page.items[0].title, 'Board 21');
        expect(page.items[4].title, 'Board 25');
      });

      test('should return empty page when page exceeds total', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 10,
          limitPerPage: 5,
          allItems: allBoardEntities,
        );

        when(() => mockDataSource.getBoards(
          page: 10,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 10,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        );

        // Assert
        expect(result.isSuccess, true);
        final page = result.getSuccess();
        expect(page!.items.length, 0);
        expect(page.totalItems, 25);
        expect(page.totalPages, 5);
      });

      test('should handle single item per page', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 1,
          limitPerPage: 1,
          allItems: allBoardEntities,
        );

        when(() => mockDataSource.getBoards(
          page: 1,
          limitPerPage: 1,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 1,
          onlyActive: true,
          ascending: true,
        );

        // Assert
        expect(result.isSuccess, true);
        final page = result.getSuccess();
        expect(page!.items.length, 1);
        expect(page.totalPages, 25); // 25 itens / 1 por página
        expect(page.items[0].title, 'Board 1');
      });

      test('should handle limit greater than total items', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 1,
          limitPerPage: 100,
          allItems: allBoardEntities,
        );

        when(() => mockDataSource.getBoards(
          page: 1,
          limitPerPage: 100,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 100,
          onlyActive: true,
          ascending: true,
        );

        // Assert
        expect(result.isSuccess, true);
        final page = result.getSuccess();
        expect(page!.items.length, 25); // Todos os itens
        expect(page.totalPages, 1);
        expect(page.number, 1);
      });

      test('should handle empty list', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 1,
          limitPerPage: 10,
          allItems: [],
        );

        when(() => mockDataSource.getBoards(
          page: 1,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        );

        // Assert
        expect(result.isSuccess, true);
        final page = result.getSuccess();
        expect(page!.items.length, 0);
        expect(page.totalItems, 0);
        expect(page.totalPages, 0);
      });
    });

    group('Navigation Scenarios', () {
      test('should navigate through all pages without duplicates', () async {
        // Arrange
        const limitPerPage = 5;
        final allIds = <int>{};

        // Mock todas as páginas
        for (int page = 1; page <= 5; page++) {
          final expectedPage = paginateEntities(
            page: page,
            limitPerPage: limitPerPage,
            allItems: allBoardEntities,
          );

          when(() => mockDataSource.getBoards(
            page: page,
            limitPerPage: limitPerPage,
            onlyActive: true,
            ascending: true,
          )).thenAnswer((_) async => expectedPage);
        }

        // Act & Assert - Navega por todas as páginas
        for (int page = 1; page <= 5; page++) {
          final result = await repository.getBoards(
            page: page,
            limitPerPage: limitPerPage,
            onlyActive: true,
            ascending: true,
          );

          expect(result.isSuccess, true);
          final resultPage = result.getSuccess()!;

          for (final board in resultPage.items) {
            // Assert - Verifica que não há duplicatas
            expect(allIds.contains(board.id), false,
                reason: 'Board ${board.id} is duplicated');
            allIds.add(board.id);
          }
        }

        // Assert - Todos os itens foram paginados
        expect(allIds.length, 25);
      });

      test('should maintain consistency when changing page size', () async {
        // Arrange
        final page1With10 = paginateEntities(
          page: 1,
          limitPerPage: 10,
          allItems: allBoardEntities,
        );

        final page1With5 = paginateEntities(
          page: 1,
          limitPerPage: 5,
          allItems: allBoardEntities,
        );

        when(() => mockDataSource.getBoards(
          page: 1,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => page1With10);

        when(() => mockDataSource.getBoards(
          page: 1,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => page1With5);

        // Act
        final result10 = await repository.getBoards(
          page: 1,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        );

        final result5 = await repository.getBoards(
          page: 1,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        );

        // Assert - Primeiro item deve ser o mesmo
        expect(result10.isSuccess, true);
        expect(result5.isSuccess, true);
        final page10 = result10.getSuccess()!;
        final page5 = result5.getSuccess()!;
        expect(page10.items[0].id, page5.items[0].id);
        expect(page10.totalItems, page5.totalItems);
      });

      test('should calculate correct page for middle items', () async {
        // Arrange - Item 13 está na página 3 (limite 5)
        final expectedPage = paginateEntities(
          page: 3,
          limitPerPage: 5,
          allItems: allBoardEntities,
        );

        when(() => mockDataSource.getBoards(
          page: 3,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 3,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        );

        // Assert
        expect(result.isSuccess, true);
        final page = result.getSuccess()!;
        expect(page.items.any((board) => board.id == 13), true);
        expect(page.items[0].id, 11); // Primeiro item da página 3
        expect(page.items[4].id, 15); // Último item da página 3
      });
    });

    group('TotalPages Calculation', () {
      test('should calculate totalPages correctly for exact division', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 1,
          limitPerPage: 5,
          allItems: allBoardEntities,
        );

        when(() => mockDataSource.getBoards(
          page: 1,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        );

        // Assert - 25 / 5 = 5 páginas exatas
        expect(result.isSuccess, true);
        expect(result.getSuccess()!.totalPages, 5);
      });

      test('should calculate totalPages correctly with remainder', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 1,
          limitPerPage: 10,
          allItems: allBoardEntities,
        );

        when(() => mockDataSource.getBoards(
          page: 1,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        );

        // Assert - 25 / 10 = 2.5 -> 3 páginas
        expect(result.isSuccess, true);
        expect(result.getSuccess()!.totalPages, 3);
      });

      test('should calculate totalPages correctly for single item', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 1,
          limitPerPage: 1,
          allItems: allBoardEntities,
        );

        when(() => mockDataSource.getBoards(
          page: 1,
          limitPerPage: 1,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 1,
          onlyActive: true,
          ascending: true,
        );

        // Assert - 25 / 1 = 25 páginas
        expect(result.isSuccess, true);
        expect(result.getSuccess()!.totalPages, 25);
      });

      test('should calculate totalPages as 1 when limit exceeds items', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 1,
          limitPerPage: 1000,
          allItems: allBoardEntities,
        );

        when(() => mockDataSource.getBoards(
          page: 1,
          limitPerPage: 1000,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 1000,
          onlyActive: true,
          ascending: true,
        );

        // Assert
        expect(result.isSuccess, true);
        expect(result.getSuccess()!.totalPages, 1);
      });
    });

    group('Boundary Tests', () {
      test('should handle first item correctly', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 1,
          limitPerPage: 10,
          allItems: allBoardEntities,
        );

        when(() => mockDataSource.getBoards(
          page: 1,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        );

        // Assert
        expect(result.isSuccess, true);
        final page = result.getSuccess()!;
        expect(page.items.first.id, 1);
        expect(page.items.first.title, 'Board 1');
      });

      test('should handle last item correctly', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 3,
          limitPerPage: 10,
          allItems: allBoardEntities,
        );

        when(() => mockDataSource.getBoards(
          page: 3,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 3,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        );

        // Assert
        expect(result.isSuccess, true);
        final page = result.getSuccess()!;
        expect(page.items.last.id, 25);
        expect(page.items.last.title, 'Board 25');
      });

      test('should handle page boundaries correctly', () async {
        // Arrange - Limites entre páginas 1 e 2
        final page1Data = paginateEntities(
          page: 1,
          limitPerPage: 10,
          allItems: allBoardEntities,
        );

        final page2Data = paginateEntities(
          page: 2,
          limitPerPage: 10,
          allItems: allBoardEntities,
        );

        when(() => mockDataSource.getBoards(
          page: 1,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => page1Data);

        when(() => mockDataSource.getBoards(
          page: 2,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => page2Data);

        // Act
        final result1 = await repository.getBoards(
          page: 1,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        );

        final result2 = await repository.getBoards(
          page: 2,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        );

        // Assert
        expect(result1.isSuccess, true);
        expect(result2.isSuccess, true);
        final page1 = result1.getSuccess()!;
        final page2 = result2.getSuccess()!;
        expect(page1.items.last.id, 10);
        expect(page2.items.first.id, 11);
      });
    });

    group('Board Specific Tests', () {
      test('should maintain board properties through pagination', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 1,
          limitPerPage: 5,
          allItems: allBoardEntities,
        );

        when(() => mockDataSource.getBoards(
          page: 1,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        );

        // Assert - Verifica que propriedades do board são mantidas
        expect(result.isSuccess, true);
        final page = result.getSuccess()!;
        expect(page.items[0].description, 'Description 1');
        expect(page.items[0].isActive, true);
        expect(page.items[0].color, isNotEmpty);
        expect(page.items[0].createdAt, isA<DateTime>());
        expect(page.items[0].updatedAt, isA<DateTime>());
      });

      test('should paginate only active boards when filter is applied', () async {
        // Arrange - Cria boards com alguns inativos
        final mixedBoards = List.generate(
          20,
          (index) => BoardData(
            id: index + 1,
            title: 'Board ${index + 1}',
            description: 'Description ${index + 1}',
            color: '#FF0000',
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
            isActive: index % 2 == 0, // Apenas pares são ativos
          ),
        );

        final activeBoards = mixedBoards.where((b) => b.isActive).toList();

        final expectedPage = paginateEntities(
          page: 1,
          limitPerPage: 5,
          allItems: activeBoards,
        );

        when(() => mockDataSource.getBoards(
          page: 1,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        );

        // Assert
        expect(result.isSuccess, true);
        final page = result.getSuccess()!;
        expect(page.items.every((board) => board.isActive), true);
        expect(page.totalItems, 10); // Apenas 10 boards ativos
      });

      test('should handle boards with different colors', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 1,
          limitPerPage: 8,
          allItems: allBoardEntities,
        );

        when(() => mockDataSource.getBoards(
          page: 1,
          limitPerPage: 8,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 8,
          onlyActive: true,
          ascending: true,
        );

        // Assert - Verifica que cada board tem uma cor
        expect(result.isSuccess, true);
        final page = result.getSuccess()!;
        expect(page.items.every((board) => board.color != null), true);
        expect(page.items.every((board) => board.color!.isNotEmpty), true);
      });

      test('should maintain chronological order by creation date', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 1,
          limitPerPage: 10,
          allItems: allBoardEntities,
        );

        when(() => mockDataSource.getBoards(
          page: 1,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        )).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        );

        // Assert - Verifica ordem cronológica
        expect(result.isSuccess, true);
        final page = result.getSuccess()!;
        for (int i = 0; i < page.items.length - 1; i++) {
          expect(
            page.items[i].createdAt.isBefore(page.items[i + 1].createdAt) ||
            page.items[i].createdAt.isAtSameMomentAs(page.items[i + 1].createdAt),
            true,
            reason: 'Boards should be in chronological order',
          );
        }
      });

      test('should handle repository errors gracefully', () async {
        // Arrange
        when(() => mockDataSource.getBoards(
          page: 1,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        )).thenThrow(Exception('Database error'));

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        );

        // Assert
        expect(result.isFailure, true);
        expect(result.getFailureObject()?.message, 'Failed to get boards');
      });
    });
  });
}
