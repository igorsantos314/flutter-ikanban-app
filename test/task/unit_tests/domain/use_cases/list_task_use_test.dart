import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/core/utils/result/result_page.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/errors/task_repository_errors.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';
import 'package:flutter_ikanban_app/features/task/domain/use_cases/list_task_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockRepository;
  late ListTaskUseCase useCase;

  final testTasks = [
    TaskModel(
      id: 1,
      title: 'Task 1',
      description: 'Description 1',
      status: TaskStatus.todo,
      createdAt: DateTime(2024, 1, 1),
    ),
    TaskModel(
      id: 2,
      title: 'Task 2',
      description: 'Description 2',
      status: TaskStatus.inProgress,
      createdAt: DateTime(2024, 1, 2),
    ),
  ];

  setUp(() {
    mockRepository = MockTaskRepository();
    useCase = ListTaskUseCase(mockRepository);
  });

  group('ListTaskUseCase', () {
    group('execute', () {
      test('should return stream with tasks when repository returns success', () async {
        // Arrange
        final resultPage = ResultPage<TaskModel>(
          items: testTasks,
          totalItems: 2,
          number: 1,
          limitPerPage: 10,
          totalPages: 1,
        );
        when(() => mockRepository.watchTasks(
              boardId: any(named: 'boardId'),
              page: any(named: 'page'),
              limitPerPage: any(named: 'limitPerPage'),
              search: any(named: 'search'),
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate'),
              orderBy: any(named: 'orderBy'),
              status: any(named: 'status'),
              priority: any(named: 'priority'),
              complexity: any(named: 'complexity'),
              type: any(named: 'type'),
              onlyActive: any(named: 'onlyActive'),
              ascending: any(named: 'ascending'),
            )).thenAnswer(
          (_) => Stream.value(Outcome.success(value: resultPage)),
        );

        // Act
        final stream = useCase.execute(
          boardId: 1,
          page: 1,
          limitPerPage: 10,
        );

        // Assert
        await expectLater(
          stream,
          emits(
            predicate<Outcome<ResultPage<TaskModel>, ListTaskUseCaseError>>(
              (outcome) {
                return outcome.when(
                  success: (page) {
                    expect(page?.items.length, 2);
                    expect(page?.totalItems, 2);
                    expect(page?.items.first.title, 'Task 1');
                    return true;
                  },
                  failure: (_, __, ___) => false,
                );
              },
            ),
          ),
        );
      });

      test('should return stream with genericError when repository returns error', () async {
        // Arrange
        when(() => mockRepository.watchTasks(
              boardId: any(named: 'boardId'),
              page: any(named: 'page'),
              limitPerPage: any(named: 'limitPerPage'),
              search: any(named: 'search'),
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate'),
              orderBy: any(named: 'orderBy'),
              status: any(named: 'status'),
              priority: any(named: 'priority'),
              complexity: any(named: 'complexity'),
              type: any(named: 'type'),
              onlyActive: any(named: 'onlyActive'),
              ascending: any(named: 'ascending'),
            )).thenAnswer(
          (_) => Stream.value(const Outcome.failure(
            error: TaskRepositoryErrors.databaseError(),
          )),
        );

        // Act
        final stream = useCase.execute(
          boardId: 1,
          page: 1,
          limitPerPage: 10,
        );

        // Assert
        await expectLater(
          stream,
          emits(
            predicate<Outcome<ResultPage<TaskModel>, ListTaskUseCaseError>>(
              (outcome) {
                return outcome.when(
                  success: (_) => false,
                  failure: (error, __, ___) {
                    expect(error, ListTaskUseCaseError.genericError);
                    return true;
                  },
                );
              },
            ),
          ),
        );
      });

      test('should call repository with correct parameters', () async {
        // Arrange
        final resultPage = ResultPage<TaskModel>(
          items: testTasks,
          totalItems: 2,
          number: 1,
          limitPerPage: 10,
          totalPages: 1,
        );
        when(() => mockRepository.watchTasks(
              boardId: any(named: 'boardId'),
              page: any(named: 'page'),
              limitPerPage: any(named: 'limitPerPage'),
              search: any(named: 'search'),
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate'),
              orderBy: any(named: 'orderBy'),
              status: any(named: 'status'),
              priority: any(named: 'priority'),
              complexity: any(named: 'complexity'),
              type: any(named: 'type'),
              onlyActive: any(named: 'onlyActive'),
              ascending: any(named: 'ascending'),
            )).thenAnswer(
          (_) => Stream.value(Outcome.success(value: resultPage)),
        );

        // Act
        final stream = useCase.execute(
          boardId: 1,
          page: 2,
          limitPerPage: 20,
          search: 'test',
        );
        await stream.first;

        // Assert
        verify(() => mockRepository.watchTasks(
              boardId: 1,
              page: 2,
              limitPerPage: 20,
              search: 'test',
              startDate: null,
              endDate: null,
              orderBy: null,
              status: null,
              priority: null,
              complexity: null,
              type: null,
              onlyActive: true,
              ascending: true,
            )).called(1);
      });
    });
  });
}
