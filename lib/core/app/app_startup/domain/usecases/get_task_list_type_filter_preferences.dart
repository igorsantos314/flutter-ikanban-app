import 'package:flutter_ikanban_app/core/app/app_startup/domain/repository/task_list_preferences_repository.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';

enum GetTaskListTypeFilterPreferencesError { genericError }

class GetTaskListTypeFilterPreferencesUsecase {
  final TaskListPreferencesRepository repository;
  GetTaskListTypeFilterPreferencesUsecase(this.repository);

  Future<Outcome<List<TaskType>, GetTaskListTypeFilterPreferencesError>>
  execute() async {
    final result = await repository.getTaskListTypeFilter();
    return result.when(
      success: (data) => Outcome.success(value: data),
      failure: (error, message, throwable) {
        return const Outcome.failure(
          error: GetTaskListTypeFilterPreferencesError.genericError,
        );
      },
    );
  }
}
