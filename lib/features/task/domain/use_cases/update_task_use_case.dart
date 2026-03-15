import 'package:flutter_ikanban_app/core/services/notification/task_notification_service.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';

enum UpdateTaskUseCaseError {
  genericError,
  taskNotFoundError,
  invalidDataError,
}

class UpdateTaskUseCase {
  final TaskRepository taskRepository;
  final TaskNotificationService notificationService;
  
  UpdateTaskUseCase(this.taskRepository, this.notificationService);
  
  Future<Outcome<void, UpdateTaskUseCaseError>> execute(TaskModel task) async {
    final result = await taskRepository.updateTask(task);
    return result.when(
      success: (_) async {
        if (task.id == null) {
          return const Outcome.success();
        }
        
        // Cancel notification if task is done or cancelled
        if (task.status == TaskStatus.done || task.status == TaskStatus.cancelled) {
          await notificationService.cancelTaskNotification(task.id!);
        } else if (task.shouldNotify && task.dueDate != null && task.dueTime != null) {
          // Reschedule notification with updated data
          // Permissions were already requested when user enabled the notification toggle
          await notificationService.cancelTaskNotification(task.id!);
          await notificationService.scheduleTaskNotification(task);
        } else {
          // If notification was disabled or dueDate/dueTime was removed, cancel notification
          await notificationService.cancelTaskNotification(task.id!);
        }
        
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
