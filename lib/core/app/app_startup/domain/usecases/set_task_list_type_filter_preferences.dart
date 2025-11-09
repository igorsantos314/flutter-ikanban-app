import 'package:flutter_ikanban_app/core/app/app_startup/domain/repository/task_list_preferences_repository.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';

enum SetTaskListTypeFilterPreferencesError { genericError }

class SetTaskListTypeFilterPreferencesUsecase {
  final TaskListPreferencesRepository repository;

  SetTaskListTypeFilterPreferencesUsecase(this.repository);

  Future<Outcome<void, SetTaskListTypeFilterPreferencesError>> call(
    List<TaskType> taskTypes,
  ) async {
    final result = await repository.setTaskListTypeFilter(taskTypes);
    return result.when(
      success: (_) => const Outcome.success(value: null),
      failure: (error, message, throwable) {
        return const Outcome.failure(
          error: SetTaskListTypeFilterPreferencesError.genericError,
        );
      },
    );
  }
}
