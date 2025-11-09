import 'package:flutter_ikanban_app/core/app/app_startup/domain/repository/task_list_preferences_repository.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';

enum GetTaskListStatusUseCaseError { genericError }

class GetTaskListStatusPreferencesUseCase {
  final TaskListPreferencesRepository repository;
  GetTaskListStatusPreferencesUseCase(this.repository);

  Future<Outcome<TaskStatus, GetTaskListStatusUseCaseError>> execute() async {
    final result = await repository.getSelectedStatus();
    return result.when(
      success: (data) => Outcome.success(value: data),
      failure: (error, message, throwable) {
        return Outcome.failure(
          error: GetTaskListStatusUseCaseError.genericError,
        );
      },
    );
  }
}
