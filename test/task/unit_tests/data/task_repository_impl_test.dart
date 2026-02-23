import 'package:flutter_ikanban_app/core/database/app_database.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/core/utils/result/result_page.dart';
import 'package:flutter_ikanban_app/features/task/data/task_repository_impl.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/infra/local/task_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskLocalDataSource extends Mock implements TaskLocalDataSource {}

class FakeTaskEntityCompanion extends Fake implements TaskEntityCompanion {}

class FakeTaskData extends Fake implements TaskData {
  @override
  final int id;
  @override
  final String title;
  @override
  final String description;
  @override
  final TaskStatus status;
  @override
  final DateTime createdAt;
  @override
  final bool isActive;

  FakeTaskData({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    this.isActive = true,
  });
}

void main() {
  late MockTaskLocalDataSource mockDataSource;
  late TaskRepositoryImpl repository;

  final testTask = TaskModel(
    id: 1,
    title: 'Test Task',
    description: 'Test Description',
    status: TaskStatus.todo,
    createdAt: DateTime(2024, 1, 1),
  );

  final testTaskData = FakeTaskData(
    id: 1,
    title: 'Test Task',
    description: 'Test Description',
    status: TaskStatus.todo,
    createdAt: DateTime(2024, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(FakeTaskEntityCompanion());
  });

  setUp(() {
    mockDataSource = MockTaskLocalDataSource();
    repository = TaskRepositoryImpl(mockDataSource);
  });

  group('TaskRepositoryImpl', () {
    group('createTask', () {
      test('should return success when data source inserts task successfully', () async {
        // Arrange
        when(() => mockDataSource.insertTask(any()))
            .thenAnswer((_) async => 1);

        // Act
        final result = await repository.createTask(testTask);

        // Assert
        result.when(
          success: (_) => expect(true, true),
          failure: (_, __, ___) => fail('Should return success'),
        );
        verify(() => mockDataSource.insertTask(any())).called(1);
      });

      test('should return genericError when data source throws exception', () async {
        // Arrange
        when(() => mockDataSource.insertTask(any()))
            .thenThrow(Exception('Database error'));

        // Act
        final result = await repository.createTask(testTask);

        // Assert
        result.when(
          success: (_) => fail('Should return failure'),
          failure: (error, message, throwable) {
            expect(message, 'Failed to create task');
          },
        );
        verify(() => mockDataSource.insertTask(any())).called(1);
      });
    });

    group('deleteTask', () {
      test('should return success when data source deletes task successfully', () async {
        // Arrange
        const taskId = 1;
        when(() => mockDataSource.deleteTask(any()))
            .thenAnswer((_) async => 1);

        // Act
        final result = await repository.deleteTask(taskId);

        // Assert
        result.when(
          success: (_) => expect(true, true),
          failure: (_, __, ___) => fail('Should return success'),
        );
        verify(() => mockDataSource.deleteTask(taskId)).called(1);
      });

      test('should return genericError when data source throws exception', () async {
        // Arrange
        const taskId = 1;
        when(() => mockDataSource.deleteTask(any()))
            .thenThrow(Exception('Database error'));

        // Act
        final result = await repository.deleteTask(taskId);

        // Assert
        result.when(
          success: (_) => fail('Should return failure'),
          failure: (error, message, throwable) {
            expect(message, 'Failed to delete task');
          },
        );
        verify(() => mockDataSource.deleteTask(taskId)).called(1);
      });
    });

    group('updateTask', () {
      test('should return success when data source updates task successfully', () async {
        // Arrange
        when(() => mockDataSource.updateTask(any()))
            .thenAnswer((_) async => true);

        // Act
        final result = await repository.updateTask(testTask);

        // Assert
        result.when(
          success: (_) => expect(true, true),
          failure: (_, __, ___) => fail('Should return success'),
        );
        verify(() => mockDataSource.updateTask(any())).called(1);
      });

      test('should return genericError when data source throws exception', () async {
        // Arrange
        when(() => mockDataSource.updateTask(any()))
            .thenThrow(Exception('Database error'));

        // Act
        final result = await repository.updateTask(testTask);

        // Assert
        result.when(
          success: (_) => fail('Should return failure'),
          failure: (error, message, throwable) {
            expect(message, 'Failed to update task');
          },
        );
        verify(() => mockDataSource.updateTask(any())).called(1);
      });
    });

    group('getTaskById', () {
      test('should call data source with correct id', () async {
        // Arrange
        const taskId = 1;
        when(() => mockDataSource.getTaskById(any()))
            .thenAnswer((_) async => testTaskData);

        // Act
        await repository.getTaskById(taskId);

        // Assert
        verify(() => mockDataSource.getTaskById(taskId)).called(1);
      });

      test('should return notFound when data source returns null', () async {
        // Arrange
        const taskId = 999;
        when(() => mockDataSource.getTaskById(any()))
            .thenAnswer((_) async => null);

        // Act
        final result = await repository.getTaskById(taskId);

        // Assert
        result.when(
          success: (_) => fail('Should return failure'),
          failure: (error, message, throwable) => expect(true, true),
        );
        verify(() => mockDataSource.getTaskById(taskId)).called(1);
      });

      test('should return genericError when data source throws exception', () async {
        // Arrange
        const taskId = 1;
        when(() => mockDataSource.getTaskById(any()))
            .thenThrow(Exception('Database error'));

        // Act
        final result = await repository.getTaskById(taskId);

        // Assert
        result.when(
          success: (_) => fail('Should return failure'),
          failure: (error, message, throwable) {
            expect(message, 'Failed to get task');
          },
        );
        verify(() => mockDataSource.getTaskById(taskId)).called(1);
      });
    });

    group('watchTasks', () {
      test('should call data source with correct parameters', () {
        // Arrange
        final resultPage = ResultPage<TaskData>(
          items: [testTaskData],
          totalItems: 1,
          number: 1,
          limitPerPage: 10,
          totalPages: 1,
        );
        when(() => mockDataSource.watchTasks(
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
            )).thenAnswer((_) => Stream.value(resultPage));

        // Act
        repository.watchTasks(
          boardId: 1,
          page: 1,
          limitPerPage: 10,
        );

        // Assert
        verify(() => mockDataSource.watchTasks(
              boardId: 1,
              page: 1,
              limitPerPage: 10,
              search: null,
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

    group('createTasks', () {
      test('should return success when data source inserts all tasks', () async {
        // Arrange
        final tasks = [testTask, testTask.copyWith(id: 2)];
        when(() => mockDataSource.insertTask(any()))
            .thenAnswer((_) async => 1);

        // Act
        final result = await repository.createTasks(tasks);

        // Assert
        result.when(
          success: (_) => expect(true, true),
          failure: (_, __, ___) => fail('Should return success'),
        );
        verify(() => mockDataSource.insertTask(any())).called(2);
      });

      test('should return genericError when data source throws exception', () async {
        // Arrange
        final tasks = [testTask];
        when(() => mockDataSource.insertTask(any()))
            .thenThrow(Exception('Database error'));

        // Act
        final result = await repository.createTasks(tasks);

        // Assert
        result.when(
          success: (_) => fail('Should return failure'),
          failure: (error, message, throwable) {
            expect(message, 'Failed to create tasks');
          },
        );
      });
    });
  });
}
