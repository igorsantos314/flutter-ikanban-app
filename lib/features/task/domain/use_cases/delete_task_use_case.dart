import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/errors/task_repository_errors.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';

enum DeleteTaskUseCaseError {
  genericError,
  taskNotFoundError,
  invalidDataError
}

class DeleteTaskUseCase {
  final TaskRepository _taskRepository;

  DeleteTaskUseCase(this._taskRepository);

  Future<Outcome<void, DeleteTaskUseCaseError>> execute(int taskId) async {
    try {
      final outcome = await _taskRepository.deleteTask(taskId);
      return outcome.when(
        success: (_) => Outcome.success(),
        failure: (error, message, throwable) {
          switch(error) {
            case TaskRepositoryErrors.notFound:
              return Outcome.failure(
                error: DeleteTaskUseCaseError.taskNotFoundError,
              );
            case TaskRepositoryErrors.validationError:
              return Outcome.failure(
                error: DeleteTaskUseCaseError.invalidDataError,
              );
            default:
              return Outcome.failure(
                error: DeleteTaskUseCaseError.genericError,
              );
          }
        },
      );
    } catch (e) {
      return Outcome.failure(
        error: DeleteTaskUseCaseError.genericError,
        message: 'Unexpected error occurred',
        throwable: e,
      );
    }
  }
}