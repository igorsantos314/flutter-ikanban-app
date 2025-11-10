import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/utils/messages.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/domain/use_cases/create_task_use_case.dart';
import 'package:flutter_ikanban_app/features/task/domain/use_cases/delete_task_use_case.dart';
import 'package:flutter_ikanban_app/features/task/domain/use_cases/get_task_by_id_use_case.dart';
import 'package:flutter_ikanban_app/features/task/domain/use_cases/update_task_use_case.dart';
import 'package:flutter_ikanban_app/features/task/presentation/events/form/task_form_events.dart';
import 'package:flutter_ikanban_app/features/task/presentation/events/shared/task_shared_events.dart';
import 'package:flutter_ikanban_app/features/task/presentation/states/form/task_form_state.dart';

class TaskFormBloc extends Bloc<TaskEvent, TaskFormState> {
  final CreateTaskUseCase _createTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final GetTaskByIdUseCase _getTaskByIdUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;

  TaskFormBloc(
    this._createTaskUseCase,
    this._updateTaskUseCase,
    this._getTaskByIdUseCase,
    this._deleteTaskUseCase,
  ) : super(TaskFormState.initial()) {
    on<TaskFormUpdateFieldsEvent>(_onUpdateFields);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<TaskFormResetEvent>(_onResetForm);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<LoadTaskFormEvent>(_onLoadTaskForm);
  }

  void _onResetForm(TaskFormResetEvent event, Emitter<TaskFormState> emit) {
    emit(
      state.copyWith(
        showNotification: event.showNotification ?? state.showNotification,
        closeScreen: event.closeScreen ?? state.closeScreen,
      ),
    );
  }

  void _onUpdateFields(
    TaskFormUpdateFieldsEvent event,
    Emitter<TaskFormState> emit,
  ) {
    log(
      'Updating fields: title=${event.title}, description=${event.description}, status=${event.status}, priority=${event.priority}, complexity=${event.complexity}, type=${event.type}, dueDate=${event.dueDate}',
    );
    emit(
      state.copyWith(
        title: event.title ?? state.title,
        description: event.description ?? state.description,
        status: event.status ?? state.status,
        priority: event.priority ?? state.priority,
        complexity: event.complexity ?? state.complexity,
        type: event.type ?? state.type,
        dueDate: event.dueDate ?? state.dueDate,
        color: event.color ?? state.color,
      ),
    );
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TaskFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    if (state.title.isEmpty) {
      emit(
        state.copyWith(isLoading: false, titleError: 'O título é obrigatório.'),
      );
      return;
    }

    try {
      final task = TaskModel(
        id: state.taskId,
        title: state.title,
        description: state.description,
        status: state.status,
        priority: state.priority,
        complexity: state.complexity,
        type: state.type,
        dueDate: state.dueDate,
        color: state.color,
        createdAt: DateTime.now(),
      );
      Outcome<void, dynamic> outcome;

      outcome = await _createTaskUseCase.execute(task);
      if (state.taskId != null) {
        // If taskId is not null, we are updating an existing task
        outcome = await _updateTaskUseCase.execute(task);
      }

      outcome.when(
        success: (task) {
          log('Action completed successfully');
          emit(
            state.copyWith(
              isLoading: false,
              showNotification: true,
              notificationType: NotificationType.success,
              notificationMessage:
                  'Tarefa ${state.taskId == null ? 'criada' : 'atualizada'} com sucesso!',
              closeScreen: true,
            ),
          );
        },
        failure: (error, message, throwable) {
          log('Failed to create task: $message');
          _handleTaskRepositoryError(createError: error, emit: emit);
        },
      );
    } catch (e) {
      log('Error creating task: $e');
      _handleTaskRepositoryError(
        createError: CreateTaskUseCaseError.genericError,
        emit: emit,
      );
    }
  }

  FutureOr<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    if (state.title.isEmpty) {
      emit(
        state.copyWith(isLoading: false, titleError: 'O título é obrigatório.'),
      );
      return;
    }

    try {
      final task = TaskModel(
        id: state.taskId,
        title: state.title,
        description: state.description,
        status: state.status,
        priority: state.priority,
        complexity: state.complexity,
        type: state.type,
        dueDate: state.dueDate,
        color: state.color,
        createdAt: DateTime.now(),
      );

      final outcome = await _updateTaskUseCase.execute(task);

      outcome.when(
        success: (task) {
          log('Update completed successfully');
          emit(
            state.copyWith(
              isLoading: false,
              showNotification: true,
              notificationType: NotificationType.success,
              notificationMessage: 'Tarefa atualizada com sucesso!',
              closeScreen: true,
            ),
          );
        },
        failure: (error, message, throwable) {
          log('Failed to update task: $message');
          _handleTaskRepositoryError(updateError: error, emit: emit);
        },
      );
    } catch (e) {
      log('Error to update task: $e');
      _handleTaskRepositoryError(
        updateError: UpdateTaskUseCaseError.genericError,
        emit: emit,
      );
    }
  }

  FutureOr<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      if (state.taskId == null) {
        log('Task ID is null, cannot delete task');
        _handleTaskRepositoryError(
          deleteError: DeleteTaskUseCaseError.invalidDataError,
          emit: emit,
        );
        return;
      }

      final outcome = await _deleteTaskUseCase.execute(state.taskId!);

      outcome.when(
        success: (_) {
          log('Task deleted successfully');
          emit(
            state.copyWith(
              isLoading: false,
              showNotification: true,
              notificationType: NotificationType.success,
              notificationMessage: 'Tarefa deletada com sucesso!',
              closeScreen: true,
            ),
          );
        },
        failure: (error, message, throwable) {
          log('Failed to delete task: $message');
          _handleTaskRepositoryError(
            deleteError: DeleteTaskUseCaseError.genericError,
            emit: emit,
          );
        },
      );
    } catch (e) {
      log('Error deleting task: $e');
      _handleTaskRepositoryError(
        deleteError: DeleteTaskUseCaseError.genericError,
        emit: emit,
      );
    }
  }

  FutureOr<void> _onLoadTaskForm(
    LoadTaskFormEvent event,
    Emitter<TaskFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final outcome = await _getTaskByIdUseCase.execute(event.taskId);

      outcome.when(
        success: (task) {
          log('Task loaded successfully $task');

          if (task == null) {
            log('Task not found with id: ${event.taskId}');
            _handleTaskRepositoryError(
              getError: GetTaskByIdUseCaseError.taskNotFoundError,
              emit: emit,
            );
            return;
          }

          emit(
            state.copyWith(
              isLoading: false,
              taskId: task.id,
              title: task.title,
              description: task.description ?? "",
              status: task.status,
              priority: task.priority,
              complexity: task.complexity,
              color: task.color,
              type: task.type,
              dueDate: task.dueDate,
            ),
          );
        },
        failure: (error, message, throwable) {
          log('Failed to load task: $message');
          _handleTaskRepositoryError(
            getError: GetTaskByIdUseCaseError.genericError,
            emit: emit,
          );
        },
      );
    } catch (e) {
      log('Error loading task: $e');
      _handleTaskRepositoryError(
        getError: GetTaskByIdUseCaseError.genericError,
        emit: emit,
      );
    }
  }

  void _handleTaskRepositoryError({
    CreateTaskUseCaseError? createError,
    UpdateTaskUseCaseError? updateError,
    GetTaskByIdUseCaseError? getError,
    DeleteTaskUseCaseError? deleteError,
    required Emitter<TaskFormState> emit,
  }) {
    String message = "";
    if (createError != null) {
      switch (createError) {
        case CreateTaskUseCaseError.genericError:
          message = 'Ocorreu um erro inesperado.';
          break;
        case CreateTaskUseCaseError.invalidDataError:
          message = 'Verifique os campos e tente novamente.';
          break;
      }

      return;
    }

    if (updateError != null) {
      switch (updateError) {
        case UpdateTaskUseCaseError.genericError:
          message = 'Ocorreu um erro inesperado.';
          break;
        case UpdateTaskUseCaseError.taskNotFoundError:
          message = 'Tarefa não encontrada.';
          break;
        case UpdateTaskUseCaseError.invalidDataError:
          message = 'Verifique os campos e tente novamente.';
          break;
      }

      return;
    }

    if (getError != null) {
      switch (getError) {
        case GetTaskByIdUseCaseError.genericError:
          message = 'Ocorreu um erro inesperado.';
          break;
        case GetTaskByIdUseCaseError.taskNotFoundError:
          message = 'Tarefa não encontrada.';
          break;
      }

      return;
    }

    if (deleteError != null) {
      switch (deleteError) {
        case DeleteTaskUseCaseError.genericError:
          message = 'Ocorreu um erro inesperado.';
          break;
        case DeleteTaskUseCaseError.taskNotFoundError:
          message = 'Tarefa não encontrada.';
          break;
        case DeleteTaskUseCaseError.invalidDataError:
          message = 'Dados inválidos para deletar a tarefa.';
          break;
      }
    }
    emit(state.copyWith(isLoading: false, errorMessage: message));
  }
}
