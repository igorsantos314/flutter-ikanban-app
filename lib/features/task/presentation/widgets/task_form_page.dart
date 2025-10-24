import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/ui/widgets/bloc_text_field.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/form/task_form_bloc.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/form/task_form_state.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/task_event.dart';
import 'package:flutter_ikanban_app/features/task/presentation/modals/status_selector_bottom_sheet.dart';
import 'package:flutter_ikanban_app/features/task/presentation/modals/complexity_selector_bottom_sheet.dart';
import 'package:flutter_ikanban_app/features/task/presentation/modals/priority_selector_bottom_sheet.dart';
import 'package:flutter_ikanban_app/features/task/presentation/modals/type_selector_bottom_sheet.dart';
import 'package:flutter_ikanban_app/features/task/presentation/modals/due_date_selector_bottom_sheet.dart';
import 'package:intl/intl.dart';
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
      appBar: AppBar(title: Text(widget.title)),
      body: BlocListener<TaskFormBloc, TaskFormState>(
        listener: (context, state) {
          // Sincroniza os controllers com o estado quando necessário
          if (_titleController.text != state.title) {
            _titleController.text = state.title;
          }
          if (_descriptionController.text != state.description) {
            _descriptionController.text = state.description;
          }
        },
        child: BlocBuilder<TaskFormBloc, TaskFormState>(
          builder: (context, state) {
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
                  BlocTextField<TaskFormBloc, TaskFormState>(
                    valueSelector: (state) => state.description,
                    errorSelector: (state) => state.descriptionError,
                    onChanged: (value) =>
                        bloc.add(TaskFormUpdateFieldsEvent(description: value)),
                    controller: _descriptionController,
                    label: "Descrição",
                  ),
                  const SizedBox(height: 24),
                  _buildStatusSection(context, state),
                  const SizedBox(height: 16),
                  _buildPrioritySection(context, state),
                  const SizedBox(height: 16),
                  _buildComplexitySection(context, state),
                  const SizedBox(height: 16),
                  _buildTypeSection(context, state),
                  const SizedBox(height: 16),
                  _buildDueDateSection(context, state),
                  const SizedBox(height: 32),
                  _buildActionButtons(context, state),
                ],
              ),
            ),
          );
        },
        ),
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, TaskFormState state) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showStatusSelector(context, state),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.onSurface.withAlpha(300)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: state.status.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    state.status.icon,
                    color: state.status.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.status.displayName,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        state.status.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(600),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: theme.colorScheme.onSurface.withAlpha(600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showStatusSelector(BuildContext context, TaskFormState state) {
    final bloc = context.read<TaskFormBloc>();
    
    StatusSelectorBottomSheet.show(
      context: context,
      selectedStatus: state.status,
      onStatusSelected: (status) {
        bloc.add(TaskFormUpdateFieldsEvent(status: status));
      },
    );
  }

  void _showPrioritySelector(BuildContext context, TaskFormState state) {
    final bloc = context.read<TaskFormBloc>();
    
    PrioritySelectorBottomSheet.show(
      context: context,
      selectedPriority: state.priority,
      onPrioritySelected: (priority) {
        bloc.add(TaskFormUpdateFieldsEvent(priority: priority));
      },
    );
  }

  void _showComplexitySelector(BuildContext context, TaskFormState state) {
    final bloc = context.read<TaskFormBloc>();
    
    ComplexitySelectorBottomSheet.show(
      context: context,
      selectedComplexity: state.complexity,
      onComplexitySelected: (complexity) {
        bloc.add(TaskFormUpdateFieldsEvent(complexity: complexity));
      },
    );
  }

  void _showTypeSelector(BuildContext context, TaskFormState state) {
    final bloc = context.read<TaskFormBloc>();
    
    TypeSelectorBottomSheet.show(
      context: context,
      selectedType: state.type,
      onTypeSelected: (type) {
        bloc.add(TaskFormUpdateFieldsEvent(type: type));
      },
    );
  }

  void _showDueDateSelector(BuildContext context, TaskFormState state) {
    final bloc = context.read<TaskFormBloc>(); // Captura o bloc antes de abrir o modal
    
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: DueDateSelectorBottomSheet(
          selectedDueDate: state.dueDate,
          onDueDateSelected: (dueDate) {
            bloc.add(TaskFormUpdateFieldsEvent(dueDate: dueDate));
          },
        ),
      ),
    );
  }

  Widget _buildDueDateSection(BuildContext context, TaskFormState state) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data de Vencimento',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<TaskFormBloc, TaskFormState>(
          builder: (context, currentState) {
            final dateFormat = DateFormat('dd/MM/yyyy');
            final now = DateTime.now();
            

            
            // Calcula se a data está atrasada
            final isOverdue = currentState.dueDate != null && 
                currentState.dueDate!.isBefore(DateTime(now.year, now.month, now.day));
            
            // Calcula se é hoje
            final isToday = currentState.dueDate != null &&
                currentState.dueDate!.year == now.year &&
                currentState.dueDate!.month == now.month &&
                currentState.dueDate!.day == now.day;
                
            // Calcula se é amanhã
            final tomorrow = now.add(const Duration(days: 1));
            final isTomorrow = currentState.dueDate != null &&
                currentState.dueDate!.year == tomorrow.year &&
                currentState.dueDate!.month == tomorrow.month &&
                currentState.dueDate!.day == tomorrow.day;
            
            Color getDateColor() {
              if (isOverdue) return Colors.red;
              if (isToday) return Colors.orange;
              if (isTomorrow) return Colors.blue;
              return Colors.green;
            }
            
            String getDateText() {
              if (currentState.dueDate == null) return 'Definir data de vencimento';
              if (isOverdue) return 'Atrasada - ${dateFormat.format(currentState.dueDate!)}';
              if (isToday) return 'Hoje - ${dateFormat.format(currentState.dueDate!)}';
              if (isTomorrow) return 'Amanhã - ${dateFormat.format(currentState.dueDate!)}';
              return dateFormat.format(currentState.dueDate!);
            }
            
            IconData getDateIcon() {
              if (currentState.dueDate == null) return Icons.calendar_today;
              if (isOverdue) return Icons.warning;
              if (isToday) return Icons.today;
              if (isTomorrow) return Icons.wb_sunny;
              return Icons.schedule;
            }

            return InkWell(
              onTap: () => _showDueDateSelector(context, currentState),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: currentState.dueDate != null 
                        ? getDateColor().withAlpha(100)
                        : theme.colorScheme.onSurface.withAlpha(300)
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: currentState.dueDate != null 
                      ? getDateColor().withValues(alpha: 0.05)
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (currentState.dueDate != null ? getDateColor() : Colors.grey)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        getDateIcon(),
                        color: currentState.dueDate != null ? getDateColor() : Colors.grey,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getDateText(),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: currentState.dueDate != null ? getDateColor() : null,
                            ),
                          ),
                          if (currentState.dueDate != null)
                            Text(
                              isOverdue 
                                  ? 'Esta tarefa está atrasada'
                                  : isToday
                                      ? 'Vence hoje'
                                      : isTomorrow
                                          ? 'Vence amanhã'
                                          : 'Vencimento futuro',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: getDateColor().withAlpha(180),
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          else
                            Text(
                              'Clique para definir quando a tarefa deve ser concluída',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withAlpha(600),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: currentState.dueDate != null 
                          ? getDateColor().withAlpha(150)
                          : theme.colorScheme.onSurface.withAlpha(600),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }  Widget _buildPrioritySection(BuildContext context, TaskFormState state) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prioridade',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showPrioritySelector(context, state),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.onSurface.withAlpha(300)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: state.priority.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    state.priority.icon,
                    color: state.priority.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.priority.displayName,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        state.priority.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(600),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: theme.colorScheme.onSurface.withAlpha(600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComplexitySection(BuildContext context, TaskFormState state) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Complexidade',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showComplexitySelector(context, state),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.onSurface.withAlpha(300)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: state.complexity.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    state.complexity.icon,
                    color: state.complexity.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            state.complexity.displayName,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: state.complexity.color.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${state.complexity.suggestedStoryPoints} pts',
                              style: TextStyle(
                                fontSize: 10,
                                color: state.complexity.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        state.complexity.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(600),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: theme.colorScheme.onSurface.withAlpha(600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSection(BuildContext context, TaskFormState state) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showTypeSelector(context, state),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.onSurface.withAlpha(300)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: state.type.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    state.type.icon,
                    color: state.type.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.type.displayName,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (state.type.description.isNotEmpty)
                        Text(
                          state.type.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(600),
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: theme.colorScheme.onSurface.withAlpha(600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, TaskFormState state) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.isLoading ? null : () => _onSave(context, state),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: state.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    widget.isEditMode ? 'Atualizar Tarefa' : 'Criar Tarefa',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
        if (widget.isEditMode) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: state.isLoading ? null : () => _onDelete(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: Colors.red),
              ),
              child: const Text(
                'Excluir Tarefa',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _onSave(BuildContext context, TaskFormState state) {
    // TODO: Implementar lógica de salvamento
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isEditMode
              ? 'Tarefa atualizada com sucesso!'
              : 'Tarefa criada com sucesso!',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _onDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja excluir esta tarefa? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implementar lógica de exclusão
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tarefa excluída com sucesso!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
