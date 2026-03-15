import 'package:flutter_ikanban_app/core/services/notification/task_notification_service.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/errors/task_repository_errors.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';

enum CreateTaskUseCaseError { invalidDataError, genericError }

class CreateTaskUseCase {
  final TaskRepository taskRepository;
  final TaskNotificationService notificationService;
  
  CreateTaskUseCase(this.taskRepository, this.notificationService);
  
  Future<Outcome<void, CreateTaskUseCaseError>> execute(TaskModel task) async {
    final result = await taskRepository.createTask(task);
    return result.when(
      success: (_) async {
        // Schedule notification only if user requested it and task has dueDate and dueTime
        // Permissions were already requested when user enabled the notification toggle
        if (task.shouldNotify && 
            task.id != null && 
            task.dueDate != null && 
            task.dueTime != null) {
          await notificationService.scheduleTaskNotification(task);
        }
        return const Outcome.success();
      },
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
