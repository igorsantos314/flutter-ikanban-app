import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/errors/task_repository_errors.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';
import 'package:flutter_ikanban_app/features/task/domain/use_cases/update_task_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class FakeTaskModel extends Fake implements TaskModel {}

void main() {
  late MockTaskRepository mockRepository;
  late UpdateTaskUseCase useCase;

  final testTask = TaskModel(
    id: 1,
    title: 'Test Task',
    description: 'Test Description',
    status: TaskStatus.todo,
    createdAt: DateTime(2024, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(FakeTaskModel());
  });

  setUp(() {
    mockRepository = MockTaskRepository();
    useCase = UpdateTaskUseCase(mockRepository);
  });

  group('UpdateTaskUseCase', () {
    group('execute', () {
      test('should return success when repository updates task successfully', () async {
        // Arrange
        when(() => mockRepository.updateTask(any()))
            .thenAnswer((_) async => const Outcome.success());

        // Act
        final result = await useCase.execute(testTask);

        // Assert
        result.when(
          success: (_) => expect(true, true),
          failure: (_, __, ___) => fail('Should return success'),
        );
        verify(() => mockRepository.updateTask(testTask)).called(1);
      });

      test('should return genericError when repository returns any error', () async {
        // Arrange
        when(() => mockRepository.updateTask(any()))
            .thenAnswer((_) async => const Outcome.failure(
                  error: TaskRepositoryErrors.databaseError(),
                ));

        // Act
        final result = await useCase.execute(testTask);

        // Assert
        result.when(
          success: (_) => fail('Should return failure'),
          failure: (error, message, throwable) {
            expect(error, UpdateTaskUseCaseError.genericError);
          },
        );
        verify(() => mockRepository.updateTask(testTask)).called(1);
      });

      test('should call repository with correct task', () async {
        // Arrange
        final specificTask = TaskModel(
          id: 42,
          title: 'Specific Task',
          description: 'Specific Description',
          status: TaskStatus.done,
          createdAt: DateTime(2024, 12, 25),
        );
        when(() => mockRepository.updateTask(any()))
            .thenAnswer((_) async => const Outcome.success());

        // Act
        await useCase.execute(specificTask);

        // Assert
        verify(() => mockRepository.updateTask(specificTask)).called(1);
      });
    });
  });
}
