import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/core/ui/widgets/bloc_text_field.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/form/task_form_bloc.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/form/task_form_state.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/task_event.dart';
import 'package:provider/provider.dart';

class TaskFormPage extends StatefulWidget {
  final String title;
  final bool isEditMode;

  const TaskFormPage({super.key, required this.title, required this.isEditMode});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TaskFormBloc>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(padding: EdgeInsetsGeometry.all(16.0), child: 
      SingleChildScrollView(
        child: Column(
          children: [
            BlocTextField<TaskFormBloc, TaskFormState>(
                valueSelector: (state) => state.title,
                errorSelector: (state) => state.titleError,
                onChanged: (value) => bloc.add(TaskFormUpdateFieldsEvent(title: value)),
                controller: _titleController,
                label: "Titulo",
              ),
              BlocTextField<TaskFormBloc, TaskFormState>(
                valueSelector: (state) => state.description,
                errorSelector: (state) => state.descriptionError,
                onChanged: (value) => bloc.add(TaskFormUpdateFieldsEvent(description: value)),
                controller: _descriptionController,
                label: "Descrição",
              ),
          ],
        ),
      )),
    );
  }
}