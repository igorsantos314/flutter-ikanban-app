import 'package:flutter_ikanban_app/core/app/app_startup/domain/repository/task_list_preferences_repository.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';

enum SetTaskListStatusPreferencesUseCaseError { genericError }

class SetTaskListStatusPreferencesUseCase {
  final TaskListPreferencesRepository repository;

  SetTaskListStatusPreferencesUseCase(this.repository);

  Future<Outcome<void, SetTaskListStatusPreferencesUseCaseError>> execute(
    TaskStatus taskStatus,
  ) async {
    final result = await repository.setSelectedStatus(taskStatus);
    return result.when(
      success: (_) => Outcome.success(value: null),
      failure: (error, message, throwable) {
        return Outcome.failure(
          error: SetTaskListStatusPreferencesUseCaseError.genericError,
        );
      },
    );
  }
}
