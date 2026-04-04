import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/di/app_locator.dart';
import 'package:flutter_ikanban_app/core/ui/widgets/snackbars.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/task_form_bloc.dart';
import 'package:flutter_ikanban_app/features/task/presentation/events/form/task_form_events.dart';
import 'package:flutter_ikanban_app/features/task/presentation/states/form/task_form_state.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/task_form_page.dart';

class TaskEditPage extends StatelessWidget {
  final int taskId;
  const TaskEditPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = TaskFormBloc(getIt.get(), getIt.get(), getIt.get(), getIt.get(), getIt.get(), getIt.get());
        bloc.add(LoadTaskFormEvent(taskId));
        return bloc;
      },
      child: const TaskEditPageContent(),
    );
  }
}

class TaskEditPageContent extends StatelessWidget {
  const TaskEditPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TaskFormBloc, TaskFormState>(
          listenWhen: (previous, current) =>
              previous.showNotification != current.showNotification,
          listener: (context, state) {
            if (state.showNotification) {
              showCustomSnackBar(
                context,
                state.notificationMessage,
                state.notificationType,
              );
              context.read<TaskFormBloc>().add(
                TaskFormResetEvent(showNotification: false),
              );
            }
          },
        ),
        BlocListener<TaskFormBloc, TaskFormState>(
          listenWhen: (previous, current) =>
              previous.closeScreen != current.closeScreen,
          listener: (context, state) {
            if (state.closeScreen) {
              Navigator.of(context).pop();
              context.read<TaskFormBloc>().add(
                TaskFormResetEvent(closeScreen: false),
              );
            }
          },
        ),
        BlocListener<TaskFormBloc, TaskFormState>(
          listenWhen: (previous, current) =>
              previous.isLoading != current.isLoading,
          listener: (context, state) {
            if (state.isLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              // Fecha o dialog de loading se estiver aberto
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            }
          },
        ),
      ],
      child: const TaskFormPage(title: 'Editar tarefa', isEditMode: true),
    );
  }
}
