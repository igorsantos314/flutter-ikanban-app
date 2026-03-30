import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';

enum UpdateTaskUseCaseError {
  genericError,
  taskNotFoundError,
  invalidDataError,
}

class UpdateTaskUseCase {
  final TaskRepository taskRepository;
  
  UpdateTaskUseCase(this.taskRepository);
  
  Future<Outcome<void, UpdateTaskUseCaseError>> execute(TaskModel task) async {
    print('[📝 UPDATE USE CASE] Updating task: ${task.title}');
    print('[📝 UPDATE USE CASE] status: ${task.status}');
    
    final result = await taskRepository.updateTask(task);
    return result.when(
      success: (_) async {
        print('[📝 UPDATE USE CASE] ✅ Task updated successfully');
        return const Outcome.success();
      },
      failure: (error, message, throwable) {
        return const Outcome.failure(
          error: UpdateTaskUseCaseError.genericError,
        );
      },
    );
  }
}
