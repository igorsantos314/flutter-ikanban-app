import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/errors/task_repository_errors.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';
import 'package:flutter_ikanban_app/features/task/domain/use_cases/delete_task_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockRepository;
  late DeleteTaskUseCase useCase;

  setUp(() {
    mockRepository = MockTaskRepository();
    useCase = DeleteTaskUseCase(mockRepository);
  });

  group('DeleteTaskUseCase', () {
    group('execute', () {
      test('should return success when repository deletes task successfully', () async {
        // Arrange
        const taskId = 1;
        when(() => mockRepository.deleteTask(any()))
            .thenAnswer((_) async => const Outcome.success());

        // Act
        final result = await useCase.execute(taskId);

        // Assert
        result.when(
          success: (_) => expect(true, true),
          failure: (_, __, ___) => fail('Should return success'),
        );
        verify(() => mockRepository.deleteTask(taskId)).called(1);
      });

      test('should return genericError when repository returns any error', () async {
        // Arrange
        const taskId = 1;
        when(() => mockRepository.deleteTask(any()))
            .thenAnswer((_) async => const Outcome.failure(
                  error: TaskRepositoryErrors.databaseError(),
                ));

        // Act
        final result = await useCase.execute(taskId);

        // Assert
        result.when(
          success: (_) => fail('Should return failure'),
          failure: (error, message, throwable) {
            expect(error, DeleteTaskUseCaseError.genericError);
          },
        );
        verify(() => mockRepository.deleteTask(taskId)).called(1);
      });

      test('should call repository with correct taskId', () async {
        // Arrange
        const specificTaskId = 42;
        when(() => mockRepository.deleteTask(any()))
            .thenAnswer((_) async => const Outcome.success());

        // Act
        await useCase.execute(specificTaskId);

        // Assert
        verify(() => mockRepository.deleteTask(specificTaskId)).called(1);
      });
    });
  });
}
