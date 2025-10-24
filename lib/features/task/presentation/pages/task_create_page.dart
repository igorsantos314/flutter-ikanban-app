import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/di/app_locator.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/form/task_form_bloc.dart';

class TaskCreatePage extends StatelessWidget {
  const TaskCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TaskFormBloc(getIt.get()),
      child: const TaskCreatePageContent(),
    );
  }
}

class TaskCreatePageContent extends StatelessWidget {
  const TaskCreatePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
      ),
      body: const Center(
        child: Text('Task Creation Form Goes Here'),
      ),
    );
  }
}
