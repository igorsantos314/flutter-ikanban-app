import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/task_form_bloc.dart';
import 'package:flutter_ikanban_app/features/task/presentation/events/form/task_form_events.dart';
import 'package:flutter_ikanban_app/features/task/presentation/states/form/task_form_state.dart';
import 'package:flutter_ikanban_app/features/task/presentation/modals/status_selector_bottom_sheet.dart';
import 'package:flutter_ikanban_app/features/task/presentation/modals/complexity_selector_bottom_sheet.dart';
import 'package:flutter_ikanban_app/features/task/presentation/modals/priority_selector_bottom_sheet.dart';
import 'package:flutter_ikanban_app/features/task/presentation/modals/type_selector_bottom_sheet.dart';
import 'package:flutter_ikanban_app/features/task/presentation/modals/due_date_selector_bottom_sheet.dart';

/// Mixin que contém todos os métodos de exibição dos seletores de modal
/// 
/// Este mixin elimina a duplicação de código para os métodos que abrem
/// os bottom sheets de seleção no formulário de tarefas.
mixin TaskFormSelectorsMixin {
  /// Abre o seletor de status
  void showStatusSelector(BuildContext context, TaskFormState state) {
    final bloc = context.read<TaskFormBloc>();

    StatusSelectorBottomSheet.show(
      context: context,
      selectedStatus: state.status,
      onStatusSelected: (status) {
        bloc.add(TaskFormUpdateFieldsEvent(status: status));
      },
    );
  }

  /// Abre o seletor de prioridade
  void showPrioritySelector(BuildContext context, TaskFormState state) {
    final bloc = context.read<TaskFormBloc>();

    PrioritySelectorBottomSheet.show(
      context: context,
      selectedPriority: state.priority,
      onPrioritySelected: (priority) {
        bloc.add(TaskFormUpdateFieldsEvent(priority: priority));
      },
    );
  }

  /// Abre o seletor de complexidade
  void showComplexitySelector(BuildContext context, TaskFormState state) {
    final bloc = context.read<TaskFormBloc>();

    ComplexitySelectorBottomSheet.show(
      context: context,
      selectedComplexity: state.complexity,
      onComplexitySelected: (complexity) {
        bloc.add(TaskFormUpdateFieldsEvent(complexity: complexity));
      },
    );
  }

  /// Abre o seletor de tipo
  void showTypeSelector(BuildContext context, TaskFormState state) {
    final bloc = context.read<TaskFormBloc>();

    TypeSelectorBottomSheet.show(
      context: context,
      selectedType: state.type,
      onTypeSelected: (type) {
        bloc.add(TaskFormUpdateFieldsEvent(type: type));
      },
    );
  }

  /// Abre o seletor de data de vencimento
  void showDueDateSelector(BuildContext context, TaskFormState state) {
    final theme = Theme.of(context).colorScheme;
    final bloc = context.read<TaskFormBloc>();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: theme.surface,
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
}