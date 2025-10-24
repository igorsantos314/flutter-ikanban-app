import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/list/task_list_state.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/task_event.dart';

class TaskListBloc extends Bloc<TaskEvent, TaskListState> {
  final TaskRepository taskRepository;
  TaskListBloc(this.taskRepository) : super(TaskListState.initial()) {
    on<LoadTasksEvent>(_onLoadTasks);
  }

  void _onLoadTasks(LoadTasksEvent event, Emitter<TaskListState> emit) {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    taskRepository.watchTasks(page: 1, limitPerPage: 20).listen((outcome) {
      outcome.when(
        success: (resultPage) {
          if (resultPage == null) {
            emit(state.copyWith(isLoading: false));
            return;
          }

          emit(state.copyWith(tasks: resultPage.items, isLoading: false));
        },
        failure: (error, message, throwable) {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: message ?? 'Failed to load tasks',
            ),
          );
        },
      );
    });
  }
}
