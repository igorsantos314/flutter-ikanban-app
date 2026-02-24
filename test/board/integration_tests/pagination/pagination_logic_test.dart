import 'package:flutter_ikanban_app/core/database/app_database.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/core/utils/result/result_page.dart';
import 'package:flutter_ikanban_app/features/board/data/board_repository_impl.dart';
import 'package:flutter_ikanban_app/features/board/domain/errors/board_repository_errors.dart';
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
      totalPages: allItems.isEmpty
          ? 0
          : (allItems.length / limitPerPage).ceil(),
      limitPerPage: limitPerPage,
    );
  }

  group('Board Repository Pagination Tests', () {
    late List<BoardData> allBoardEntities;

    setUp(() {
      allBoardEntities = createTestBoardEntities(25); // 25 boards de teste
    });

    group('Basic Pagination', () {
      test(
        'should return first page with correct items from repository',
        () async {
          // Arrange
          final expectedPage = paginateEntities(
            page: 1,
            limitPerPage: 5,
            allItems: allBoardEntities,
          );

          when(
            () => mockDataSource.getBoards(
              page: 1,
              limitPerPage: 5,
              onlyActive: true,
              ascending: true,
            ),
          ).thenAnswer((_) async => expectedPage);

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

          verify(
            () => mockDataSource.getBoards(
              page: 1,
              limitPerPage: 5,
              onlyActive: true,
              ascending: true,
            ),
          ).called(1);
        },
      );

      test(
        'should return second page with correct items from repository',
        () async {
          // Arrange
          final expectedPage = paginateEntities(
            page: 2,
            limitPerPage: 5,
            allItems: allBoardEntities,
          );

          when(
            () => mockDataSource.getBoards(
              page: 2,
              limitPerPage: 5,
              onlyActive: true,
              ascending: true,
            ),
          ).thenAnswer((_) async => expectedPage);

          // Act
          final result = await repository.getBoards(
            page: 2,
            limitPerPage: 5,
            onlyActive: true,
            ascending: true,
          );

          // Assert
          result.when(
            success: (page) {
              expect(page, isNotNull);
              expect(page!.items.length, 5);
              expect(page.number, 2);
              expect(page.items[0].title, 'Board 6');
              expect(page.items[4].title, 'Board 10');
            },
            failure: (_, __, ___) => fail('Should return success'),
          );
        },
      );

      test(
        'should return last page with correct items from repository',
        () async {
          // Arrange
          final expectedPage = paginateEntities(
            page: 5,
            limitPerPage: 5,
            allItems: allBoardEntities,
          );

          when(
            () => mockDataSource.getBoards(
              page: 5,
              limitPerPage: 5,
              onlyActive: true,
              ascending: true,
            ),
          ).thenAnswer((_) async => expectedPage);

          // Act
          final result = await repository.getBoards(
            page: 5,
            limitPerPage: 5,
            onlyActive: true,
            ascending: true,
          );

          // Assert
          result.when(
            success: (page) {
              expect(page, isNotNull);
              expect(page!.items.length, 5);
              expect(page.number, 5);
              expect(page.items[0].title, 'Board 21');
              expect(page.items[4].title, 'Board 25');
            },
            failure: (_, __, ___) => fail('Should return success'),
          );
        },
      );
    });

    group('Edge Cases', () {
      test('should handle incomplete last page through repository', () async {
        // Arrange - 25 itens, 10 por página
        final expectedPage = paginateEntities(
          page: 3,
          limitPerPage: 10,
          allItems: allBoardEntities,
        );

        when(
          () => mockDataSource.getBoards(
            page: 3,
            limitPerPage: 10,
            onlyActive: true,
            ascending: true,
          ),
        ).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 3,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        );

        result.when(
          success: (page) {
            expect(page, isNotNull);
            expect(page!.items.length, 5); // Última página com apenas 5 itens
            expect(page.number, 3);
            expect(page.totalPages, 3); // 25 / 10 = 2.5 -> 3 páginas
            expect(page.items[0].title, 'Board 21');
            expect(page.items[4].title, 'Board 25');
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
      });

      test('should return empty page when page exceeds total', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 10,
          limitPerPage: 5,
          allItems: allBoardEntities,
        );

        when(
          () => mockDataSource.getBoards(
            page: 10,
            limitPerPage: 5,
            onlyActive: true,
            ascending: true,
          ),
        ).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 10,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        );

        // Assert
        result.when(
          success: (page) {
            expect(page, isNotNull);
            expect(page!.items.length, 0);
            expect(page.totalItems, 25);
            expect(page.totalPages, 5);
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
      });

      test('should handle single item per page', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 1,
          limitPerPage: 1,
          allItems: allBoardEntities,
        );

        when(
          () => mockDataSource.getBoards(
            page: 1,
            limitPerPage: 1,
            onlyActive: true,
            ascending: true,
          ),
        ).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 1,
          onlyActive: true,
          ascending: true,
        );

        result.when(
          success: (page) {
            expect(page, isNotNull);
            expect(page!.items.length, 1);
            expect(page.totalItems, 25);
            expect(page.totalPages, 25); // 25 itens / 1 por página
            expect(page.items[0].title, 'Board 1');
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
      });

      test('should handle limit greater than total items', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 1,
          limitPerPage: 100,
          allItems: allBoardEntities,
        );

        when(
          () => mockDataSource.getBoards(
            page: 1,
            limitPerPage: 100,
            onlyActive: true,
            ascending: true,
          ),
        ).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 100,
          onlyActive: true,
          ascending: true,
        );

        result.when(
          success: (page) {
            expect(page, isNotNull);
            expect(page!.items.length, 25); // Todos os itens
            expect(page.totalItems, 25);
            expect(page.totalPages, 1); // Tudo em uma página
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
      });

      test('should handle empty list', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 1,
          limitPerPage: 10,
          allItems: [],
        );

        when(
          () => mockDataSource.getBoards(
            page: 1,
            limitPerPage: 10,
            onlyActive: true,
            ascending: true,
          ),
        ).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        );

        result.when(
          success: (page) {
            expect(page, isNotNull);
            expect(page!.items.length, 0);
            expect(page.totalItems, 0);
            expect(page.totalPages, 0);
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
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

          when(
            () => mockDataSource.getBoards(
              page: page,
              limitPerPage: limitPerPage,
              onlyActive: true,
              ascending: true,
            ),
          ).thenAnswer((_) async => expectedPage);
        }

        // Act & Assert - Navega por todas as páginas
        for (int page = 1; page <= 5; page++) {
          final result = await repository.getBoards(
            page: page,
            limitPerPage: limitPerPage,
            onlyActive: true,
            ascending: true,
          );

          result.when(
            success: (page) {
              expect(page, isNotNull);
              expect(page!.items.length, page.number == 5 ? 5 : limitPerPage);
              allIds.addAll(page.items.map((board) => board.id));
            },
            failure: (_, __, ___) => fail('Should return success'),
          );
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

        when(
          () => mockDataSource.getBoards(
            page: 1,
            limitPerPage: 10,
            onlyActive: true,
            ascending: true,
          ),
        ).thenAnswer((_) async => page1With10);

        when(
          () => mockDataSource.getBoards(
            page: 1,
            limitPerPage: 5,
            onlyActive: true,
            ascending: true,
          ),
        ).thenAnswer((_) async => page1With5);

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

        result10.when(
          success: (page) {
            expect(page, isNotNull);
            expect(page!.items.length, 10);
            expect(page.number, 1);
            expect(page.limitPerPage, 10);
            expect(page.totalItems, 25);
            expect(page.totalPages, 3);
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
        result5.when(
          success: (page) {
            expect(page, isNotNull);
            expect(page!.items.length, 5);
            expect(page.number, 1);
            expect(page.limitPerPage, 5);
            expect(page.totalItems, 25);
            expect(page.totalPages, 5);
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
      });

      test('should calculate correct page for middle items', () async {
        // Arrange - Item 13 está na página 3 (limite 5)
        final expectedPage = paginateEntities(
          page: 3,
          limitPerPage: 5,
          allItems: allBoardEntities,
        );

        when(
          () => mockDataSource.getBoards(
            page: 3,
            limitPerPage: 5,
            onlyActive: true,
            ascending: true,
          ),
        ).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 3,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        );

        // Assert
        result.when(
          success: (page) {
            expect(page, isNotNull);
            expect(page!.items.length, 5);
            expect(page.number, 3);
            expect(page.limitPerPage, 5);
            expect(page.totalItems, 25);
            expect(page.totalPages, 5);
            // Verifica se o item 13 está na página 3
            expect(page.items.any((board) => board.id == 13), true);
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
      });
    });

    group('TotalPages Calculation', () {
      test(
        'should calculate totalPages correctly for exact division',
        () async {
          // Arrange
          final expectedPage = paginateEntities(
            page: 1,
            limitPerPage: 5,
            allItems: allBoardEntities,
          );

          when(
            () => mockDataSource.getBoards(
              page: 1,
              limitPerPage: 5,
              onlyActive: true,
              ascending: true,
            ),
          ).thenAnswer((_) async => expectedPage);

          // Act
          final result = await repository.getBoards(
            page: 1,
            limitPerPage: 5,
            onlyActive: true,
            ascending: true,
          );

          // Assert - 25 / 5 = 5 páginas exatas
          result.when(
            success: (page) {
              expect(page, isNotNull);
              expect(page!.totalPages, 5);
            },
            failure: (_, __, ___) => fail('Should return success'),
          );
        },
      );

      test('should calculate totalPages correctly with remainder', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 1,
          limitPerPage: 10,
          allItems: allBoardEntities,
        );

        when(
          () => mockDataSource.getBoards(
            page: 1,
            limitPerPage: 10,
            onlyActive: true,
            ascending: true,
          ),
        ).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        );

        // Assert - 25 / 10 = 2.5 -> 3 páginas
        result.when(
          success: (page) {
            expect(page, isNotNull);
            expect(page!.totalPages, 3);
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
      });

      test('should calculate totalPages correctly for single item', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 1,
          limitPerPage: 1,
          allItems: allBoardEntities,
        );

        when(
          () => mockDataSource.getBoards(
            page: 1,
            limitPerPage: 1,
            onlyActive: true,
            ascending: true,
          ),
        ).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 1,
          onlyActive: true,
          ascending: true,
        );

        // Assert - 25 / 1 = 25 páginas
        result.when(
          success: (page) {
            expect(page, isNotNull);
            expect(page!.totalPages, 25);
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
      });

      test(
        'should calculate totalPages as 1 when limit exceeds items',
        () async {
          // Arrange
          final expectedPage = paginateEntities(
            page: 1,
            limitPerPage: 1000,
            allItems: allBoardEntities,
          );

          when(
            () => mockDataSource.getBoards(
              page: 1,
              limitPerPage: 1000,
              onlyActive: true,
              ascending: true,
            ),
          ).thenAnswer((_) async => expectedPage);

          // Act
          final result = await repository.getBoards(
            page: 1,
            limitPerPage: 1000,
            onlyActive: true,
            ascending: true,
          );

          // Assert
          result.when(
            success: (page) {
              expect(page, isNotNull);
              expect(page!.totalPages, 1);
            },
            failure: (_, __, ___) => fail('Should return success'),
          );
        },
      );
    });

    group('Boundary Tests', () {
      test('should handle first item correctly', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 1,
          limitPerPage: 10,
          allItems: allBoardEntities,
        );

        when(
          () => mockDataSource.getBoards(
            page: 1,
            limitPerPage: 10,
            onlyActive: true,
            ascending: true,
          ),
        ).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        );

        // Assert
        result.when(
          success: (page) {
            expect(page, isNotNull);
            expect(page!.items.first.id, 1);
            expect(page.items.first.title, 'Board 1');
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
      });

      test('should handle last item correctly', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 3,
          limitPerPage: 10,
          allItems: allBoardEntities,
        );

        when(
          () => mockDataSource.getBoards(
            page: 3,
            limitPerPage: 10,
            onlyActive: true,
            ascending: true,
          ),
        ).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 3,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        );

        // Assert
        result.when(
          success: (page) {
            expect(page, isNotNull);
            expect(page!.items.last.id, 25);
            expect(page.items.last.title, 'Board 25');
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
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

        when(
          () => mockDataSource.getBoards(
            page: 1,
            limitPerPage: 10,
            onlyActive: true,
            ascending: true,
          ),
        ).thenAnswer((_) async => page1Data);

        when(
          () => mockDataSource.getBoards(
            page: 2,
            limitPerPage: 10,
            onlyActive: true,
            ascending: true,
          ),
        ).thenAnswer((_) async => page2Data);

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
        result1.when(
          success: (page) {
            expect(page, isNotNull);
            expect(page!.items.last.id, 10);
            expect(page.items.last.title, 'Board 10');
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
        result2.when(
          success: (page) {
            expect(page, isNotNull);
            expect(page!.items.first.id, 11);
            expect(page.items.first.title, 'Board 11');
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
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

        when(
          () => mockDataSource.getBoards(
            page: 1,
            limitPerPage: 5,
            onlyActive: true,
            ascending: true,
          ),
        ).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        );

        // Assert - Verifica que propriedades do board são mantidas
        result.when(
          success: (page) {
            expect(page, isNotNull);
            expect(page!.items.length, 5);
            final board = page.items.first;
            expect(board.id, 1);
            expect(board.title, 'Board 1');
            expect(board.description, 'Description 1');
            expect(board.createdAt, DateTime(2024, 1, 1));
            expect(board.updatedAt, DateTime(2024, 1, 1));
            expect(board.isActive, true);
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
      });

      test(
        'should paginate only active boards when filter is applied',
        () async {
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

          when(
            () => mockDataSource.getBoards(
              page: 1,
              limitPerPage: 5,
              onlyActive: true,
              ascending: true,
            ),
          ).thenAnswer((_) async => expectedPage);

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
              expect(page.totalItems, 10); // Apenas 10 boards ativos
              expect(page.items.every((board) => board.isActive), true);
            },
            failure: (_, __, ___) => fail('Should return success'),
          );
        },
      );

      test('should handle boards with different colors', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 1,
          limitPerPage: 8,
          allItems: allBoardEntities,
        );

        when(
          () => mockDataSource.getBoards(
            page: 1,
            limitPerPage: 8,
            onlyActive: true,
            ascending: true,
          ),
        ).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 8,
          onlyActive: true,
          ascending: true,
        );

        // Assert - Verifica que cada board tem uma cor
        result.when(
          success: (page) {
            expect(page, isNotNull);
            expect(page!.items.length, 8);
            final colors = page.items.map((b) => b.color).toSet();
            expect(colors.length, 8); // Cada board tem uma cor diferente
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
      });

      test('should maintain chronological order by creation date', () async {
        // Arrange
        final expectedPage = paginateEntities(
          page: 1,
          limitPerPage: 10,
          allItems: allBoardEntities,
        );

        when(
          () => mockDataSource.getBoards(
            page: 1,
            limitPerPage: 10,
            onlyActive: true,
            ascending: true,
          ),
        ).thenAnswer((_) async => expectedPage);

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 10,
          onlyActive: true,
          ascending: true,
        );

        // Assert - Verifica ordem cronológica
        result.when(
          success: (page) {
            expect(page, isNotNull);
            expect(page!.items.length, 10);
            for (int i = 0; i < page.items.length - 1; i++) {
              expect(
                page.items[i].createdAt.isBefore(page.items[i + 1].createdAt) ||
                    page.items[i].createdAt.isAtSameMomentAs(
                      page.items[i + 1].createdAt,
                    ),
                true,
                reason: 'Boards should be in chronological order',
              );
            }
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
      });

      test('should handle repository errors gracefully', () async {
        // Arrange
        when(
          () => mockDataSource.getBoards(
            page: 1,
            limitPerPage: 5,
            onlyActive: true,
            ascending: true,
          ),
        ).thenThrow(BoardRepositoryErrors.databaseError(message: 'Database error'));

        // Act
        final result = await repository.getBoards(
          page: 1,
          limitPerPage: 5,
          onlyActive: true,
          ascending: true,
        );

        // Assert
        result.when(
          success: (_) => fail('Should return failure'),
          failure: (error, _, __) {
            expect(error, isA<BoardRepositoryErrors>());
          },
        );
      });
    });
  });
}
