import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/task_event.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/form/task_form_state.dart';

class TaskFormBloc extends Bloc<TaskEvent, TaskFormState> {
  final TaskRepository taskRepository;
  TaskFormBloc(this.taskRepository) : super(TaskFormState.initial()) {
    on<TaskFormUpdateFieldsEvent>(_onUpdateFields);
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
}
