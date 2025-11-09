import 'package:flutter_ikanban_app/core/app/app_startup/domain/repository/task_list_preferences_repository.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/presentation/enums/task_layout.dart';

enum GetLayoutModePreferencesError { genericError }

class GetLayoutModePreferencesUseCase {
  final TaskListPreferencesRepository repository;

  GetLayoutModePreferencesUseCase(this.repository);

  Future<Outcome<TaskLayout, GetLayoutModePreferencesError>> execute() async {
    final result = await repository.getLayoutMode();
    return result.when(
      success: (layoutMode) => Outcome.success(value: layoutMode),
      failure: (error, message, throwable) {
        return Outcome.failure(
          error: GetLayoutModePreferencesError.genericError,
        );
      },
    );
  }
}
