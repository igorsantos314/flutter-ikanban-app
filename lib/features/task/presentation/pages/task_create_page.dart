import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/di/app_locator.dart';
import 'package:flutter_ikanban_app/core/ui/widgets/snackbars.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/task_form_bloc.dart';
import 'package:flutter_ikanban_app/features/task/presentation/events/form/task_form_events.dart';
import 'package:flutter_ikanban_app/features/task/presentation/states/form/task_form_state.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/task_form_page.dart';

class TaskCreatePage extends StatelessWidget {
  const TaskCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TaskFormBloc(getIt.get(), getIt.get(), getIt.get(), getIt.get()),
      child: const TaskCreatePageContent(),
    );
  }
}

class TaskCreatePageContent extends StatelessWidget {
  const TaskCreatePageContent({super.key});

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
      ],
      child: const TaskFormPage(title: 'Criar nova tarefa', isEditMode: false),
    );
  }
}
