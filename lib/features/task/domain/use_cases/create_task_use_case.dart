import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/errors/task_repository_errors.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';

enum CreateTaskUseCaseError { invalidDataError, genericError }

class CreateTaskUseCase {
  final TaskRepository taskRepository;
  CreateTaskUseCase(this.taskRepository);
  Future<Outcome<void, CreateTaskUseCaseError>> execute(TaskModel task) async {
    final result = await taskRepository.createTask(task);
    return result.when(
      success: (_) => const Outcome.success(),
      failure: (error, message, throwable) {
        switch (error) {
          case TaskRepositoryErrors.validationError:
            return const Outcome.failure(
              error: CreateTaskUseCaseError.invalidDataError,
            );
          default:
            return const Outcome.failure(
              error: CreateTaskUseCaseError.genericError,
            );
        }
      },
    );
  }
}
