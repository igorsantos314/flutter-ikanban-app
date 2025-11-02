import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/errors/task_repository_errors.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';

enum GetTaskByIdUseCaseError { taskNotFoundError, genericError }

class GetTaskByIdUseCase {
  final TaskRepository taskRepository;
  GetTaskByIdUseCase(this.taskRepository);
  Future<Outcome<TaskModel, GetTaskByIdUseCaseError>> execute(int id) async {
    final result = await taskRepository.getTaskById(id);

    return result.when(
      success: (value) => Outcome.success(value: value),
      failure: (error, message, throwable) {
        switch (error) {
          case TaskRepositoryErrors.notFound:
            return const Outcome.failure(
              error: GetTaskByIdUseCaseError.taskNotFoundError,
            );
          default:
            return const Outcome.failure(
              error: GetTaskByIdUseCaseError.genericError,
            );
        }
      },
    );
  }
}
