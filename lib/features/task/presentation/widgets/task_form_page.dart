import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/ui/widgets/bloc_text_field.dart';
import 'package:flutter_ikanban_app/core/ui/widgets/multi_line_bloc_text_field.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/task_form_bloc.dart';
import 'package:flutter_ikanban_app/features/task/presentation/events/form/task_form_events.dart';
import 'package:flutter_ikanban_app/features/task/presentation/states/form/task_form_state.dart';
import 'package:flutter_ikanban_app/features/task/presentation/colors/task_colors.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/selectors/color_selector.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/selectors/form_selector_field.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/selectors/date_selector_field.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/selectors/task_form_selectors_mixin.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';

class TaskFormPage extends StatefulWidget {
  final String title;
  final bool isEditMode;

  const TaskFormPage({
    super.key,
    required this.title,
    required this.isEditMode,
  });

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage>
    with TaskFormSelectorsMixin {
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'save_button',
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            onPressed: () {
              bloc.add(
                widget.isEditMode ? UpdateTaskEvent() : CreateTaskEvent(),
              );
            },
            child: const Icon(Icons.save),
          ),
          if (widget.isEditMode) ...[
            const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: 'delete_button',
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
              onPressed: () {
                bloc.add(DeleteTaskEvent());
              },
              child: const Icon(Icons.delete),
            ),
          ],
        ],
      ),
      body: BlocListener<TaskFormBloc, TaskFormState>(
        listener: (context, state) {},
        child: BlocBuilder<TaskFormBloc, TaskFormState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocTextField<TaskFormBloc, TaskFormState>(
                      valueSelector: (state) => state.title,
                      errorSelector: (state) => state.titleError,
                      onChanged: (value) =>
                          bloc.add(TaskFormUpdateFieldsEvent(title: value)),
                      controller: _titleController,
                      label: "Título",
                    ),
                    const SizedBox(height: 16),
                    MultilineBlocTextField<TaskFormBloc, TaskFormState>(
                      valueSelector: (state) => state.description,
                      errorSelector: (state) => state.descriptionError,
                      onChanged: (value) => bloc.add(
                        TaskFormUpdateFieldsEvent(description: value),
                      ),
                      controller: _descriptionController,
                      label: "Descrição",
                    ),
                    const SizedBox(height: 24),

                    ColorSelector(
                      selectedColor: state.color,
                      onColorSelected: (color) {
                        bloc.add(TaskFormUpdateFieldsEvent(color: color));
                      },
                      availableColors: TaskColors.values,
                    ),
                    const SizedBox(height: 16),

                    FormSelectorField(
                      title: 'Status',
                      displayText: state.status.displayName,
                      description: state.status.description,
                      icon: state.status.icon,
                      iconColor: state.status.color,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        showStatusSelector(context, state);
                      },
                    ),
                    const SizedBox(height: 16),
                    FormSelectorField(
                      title: 'Prioridade',
                      displayText: state.priority.displayName,
                      description: state.priority.description,
                      icon: state.priority.icon,
                      iconColor: state.priority.color,
                      onTap: () => showPrioritySelector(context, state),
                    ),
                    const SizedBox(height: 16),
                    ComplexitySelectorField(
                      title: 'Complexidade',
                      displayText: state.complexity.displayName,
                      description: state.complexity.description,
                      icon: state.complexity.icon,
                      iconColor: state.complexity.color,
                      storyPoints: state.complexity.suggestedStoryPoints,
                      onTap: () => showComplexitySelector(context, state),
                    ),
                    const SizedBox(height: 16),
                    FormSelectorField(
                      title: 'Tipo',
                      displayText: state.type.displayName,
                      description: state.type.description.isNotEmpty
                          ? state.type.description
                          : null,
                      icon: state.type.icon,
                      iconColor: state.type.color,
                      onTap: () => showTypeSelector(context, state),
                    ),
                    const SizedBox(height: 16),
                    DateSelectorField<TaskFormBloc, TaskFormState>(
                      title: 'Data de Vencimento',
                      selectedDate: state.dueDate,
                      onTap: () {
                        _removeFocus();
                        showDueDateSelector(context, state);
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _removeFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
