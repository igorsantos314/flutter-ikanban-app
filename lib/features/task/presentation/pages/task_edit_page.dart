import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/di/app_locator.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/form/task_form_bloc.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/form/task_form_state.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/task_event.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/task_form_page.dart';

class TaskEditPage extends StatelessWidget {
  final int taskId;
  const TaskEditPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskFormBloc(getIt.get()),
      child: TaskEditPageContent(taskId: taskId),
    );
  }
}

class TaskEditPageContent extends StatelessWidget {
  final int taskId;
  const TaskEditPageContent({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    context.read<TaskFormBloc>().add(LoadTaskFormEvent(taskId));
    return MultiBlocListener(
      listeners: [
        BlocListener<TaskFormBloc, TaskFormState>(
          listener: (context, state) {},
        ),
      ],
      child: const TaskFormPage(title: 'Editar tarefa', isEditMode: true),
    );
  }
}
