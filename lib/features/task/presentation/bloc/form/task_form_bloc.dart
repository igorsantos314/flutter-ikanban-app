import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/task_event.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/form/task_form_state.dart';

class TaskFormBloc extends Bloc<TaskEvent, TaskFormState> {
  final TaskRepository taskRepository;
  TaskFormBloc(this.taskRepository) : super(TaskFormState.initial()) {
    
  }
}
