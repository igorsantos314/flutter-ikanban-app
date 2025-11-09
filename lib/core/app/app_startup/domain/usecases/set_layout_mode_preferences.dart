import 'package:flutter_ikanban_app/core/app/app_startup/domain/repository/task_list_preferences_repository.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/presentation/enums/task_layout.dart';

enum SetLayoutModePreferencesError { genericError }

class SetLayoutModePreferencesUseCase {
  final TaskListPreferencesRepository repository;

  SetLayoutModePreferencesUseCase(this.repository);

  Future<Outcome<void, SetLayoutModePreferencesError>> execute(
    TaskLayout layoutMode,
  ) async {
    final result = await repository.setLayoutMode(layoutMode);
    return result.when(
      success: (_) => Outcome.success(value: null),
      failure: (error, message, throwable) {
        return Outcome.failure(
          error: SetLayoutModePreferencesError.genericError,
        );
      },
    );
  }
}
