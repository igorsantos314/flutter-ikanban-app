import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/core/utils/result/result_page.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';

enum ListTaskUseCaseError { genericError }

class ListTaskUseCase {
  final TaskRepository taskRepository;
  ListTaskUseCase(this.taskRepository);
  Stream<Outcome<ResultPage<TaskModel>, ListTaskUseCaseError>> execute({
    required int page,
    required int limitPerPage,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
    String? orderBy,
    TaskStatus? status,
    TaskPriority? priority,
    TaskComplexity? complexity,
    List<TaskType>? type,
    bool onlyActive = true,
    bool ascending = true,
  }) {
    final streamResult = taskRepository.watchTasks(
      page: page,
      limitPerPage: limitPerPage,
      search: search,
      startDate: startDate,
      endDate: endDate,
      orderBy: orderBy,
      status: status,
      priority: priority,
      complexity: complexity,
      type: type,
      onlyActive: onlyActive,
      ascending: ascending,
    );

    return streamResult.map((outcome) {
      return outcome.when(
        success: (value) => Outcome.success(value: value),
        failure: (error, message, throwable) {
          return const Outcome.failure(
            error: ListTaskUseCaseError.genericError,
          );
        },
      );
    });
  }
}
