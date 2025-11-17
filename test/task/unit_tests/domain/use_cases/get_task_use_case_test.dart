import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/errors/task_repository_errors.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';
import 'package:flutter_ikanban_app/features/task/domain/use_cases/get_task_by_id_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockRepository;
  late GetTaskByIdUseCase useCase;

  final testTask = TaskModel(
    id: 1,
    title: 'Test Task',
    description: 'Test Description',
    status: TaskStatus.todo,
    createdAt: DateTime(2024, 1, 1),
  );

  setUp(() {
    mockRepository = MockTaskRepository();
    useCase = GetTaskByIdUseCase(mockRepository);
  });

  group('GetTaskByIdUseCase', () {
    group('execute', () {
      test('should return task when repository finds it successfully', () async {
        // Arrange
        const taskId = 1;
        when(() => mockRepository.getTaskById(any()))
            .thenAnswer((_) async => Outcome.success(value: testTask));

        // Act
        final result = await useCase.execute(taskId);

        // Assert
        result.when(
          success: (task) {
            expect(task, testTask);
            expect(task?.id, 1);
            expect(task?.title, 'Test Task');
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
        verify(() => mockRepository.getTaskById(taskId)).called(1);
      });

      test('should return genericError when repository returns any error', () async {
        // Arrange
        const taskId = 1;
        when(() => mockRepository.getTaskById(any()))
            .thenAnswer((_) async => const Outcome.failure(
                  error: TaskRepositoryErrors.databaseError(),
                ));

        // Act
        final result = await useCase.execute(taskId);

        // Assert
        result.when(
          success: (_) => fail('Should return failure'),
          failure: (error, message, throwable) {
            expect(error, GetTaskByIdUseCaseError.genericError);
          },
        );
        verify(() => mockRepository.getTaskById(taskId)).called(1);
      });

      test('should call repository with correct taskId', () async {
        // Arrange
        const specificTaskId = 42;
        when(() => mockRepository.getTaskById(any()))
            .thenAnswer((_) async => Outcome.success(value: testTask));

        // Act
        await useCase.execute(specificTaskId);

        // Assert
        verify(() => mockRepository.getTaskById(specificTaskId)).called(1);
      });
    });
  });
}
