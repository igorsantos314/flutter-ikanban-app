import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/utils/messages.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/errors/task_repository_errors.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/task_event.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/form/task_form_state.dart';

class TaskFormBloc extends Bloc<TaskEvent, TaskFormState> {
  final TaskRepository taskRepository;
  TaskFormBloc(this.taskRepository) : super(TaskFormState.initial()) {
    on<TaskFormUpdateFieldsEvent>(_onUpdateFields);
    on<CreateTaskEvent>(_onCreateTask);
    on<TaskFormResetEvent>(_onResetForm);
  }

  void _onResetForm(
    TaskFormResetEvent event,
    Emitter<TaskFormState> emit,
  ) {
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
        dueDate: event.dueDate,
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
      final outcome = await taskRepository.createTask(
        TaskModel(
          title: state.title,
          description: state.description,
          status: state.status,
          priority: state.priority,
          complexity: state.complexity,
          type: state.type,
          dueDate: state.dueDate,
        ),
      );

      outcome.when(
        success: (task) {
          log('Task created successfully');
          emit(
            state.copyWith(
              isLoading: false,
              showNotification: true,
              notificationType: NotificationType.success,
              notificationMessage: 'Tarefa criada com sucesso!',
              closeScreen: true,
            ),
          );
        },
        failure: (error, message, throwable) {
          log('Failed to create task: $message');
          _handleTaskRepositoryError(error, emit);
        },
      );
    } catch (e) {
      log('Error creating task: $e');
      _handleTaskRepositoryError(GenericError(), emit);
    }
  }

  void _handleTaskRepositoryError(
    TaskRepositoryErrors error,
    Emitter<TaskFormState> emit,
  ) {
    String message = "";
    error.when(
      genericError: (message, throwable) {
        message = 'Ocorreu um erro inesperado.';
      },
      validationError: (message, throwable) {
        message = 'Verifique os campos e tente novamente.';
      },
      databaseError: (message, throwable) {
        message = 'Erro ao acessar o banco de dados.';
      },
      networkError: (message, throwable) {
        message = 'Erro de rede. Verifique sua conexão.';
      },
      notFound: (message, throwable) {
        message = 'Recurso não encontrado.';
      },
    );
    emit(state.copyWith(isLoading: false, errorMessage: message));
  }
}
