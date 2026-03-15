import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/ui/widgets/bloc_text_field.dart';
import 'package:flutter_ikanban_app/core/ui/widgets/multi_line_bloc_text_field.dart';
import 'package:flutter_ikanban_app/core/services/notification/task_notification_service.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/task_form_bloc.dart';
import 'package:flutter_ikanban_app/features/task/presentation/events/form/task_form_events.dart';
import 'package:flutter_ikanban_app/features/task/presentation/extensions/task_complexity_enum_extensions.dart';
import 'package:flutter_ikanban_app/features/task/presentation/extensions/task_priority_enum_extensions.dart';
import 'package:flutter_ikanban_app/features/task/presentation/extensions/task_status_enum_extensions.dart';
import 'package:flutter_ikanban_app/features/task/presentation/extensions/task_type_enum_extensions.dart';
import 'package:flutter_ikanban_app/features/task/presentation/states/form/task_form_state.dart';
import 'package:flutter_ikanban_app/features/task/presentation/colors/task_colors.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/selectors/color_selector.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/selectors/form_selector_field.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/selectors/date_selector_field.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/selectors/task_form_selectors_mixin.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';

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
  final TaskNotificationService _notificationService = TaskNotificationService();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Handle notification toggle with permission requests
  Future<void> _handleNotificationToggle(bool value, TaskFormBloc bloc) async {
    print('[🔔 TOGGLE] User toggled notification switch to: $value');
    
    // Se o usuário está tentando DESATIVAR a notificação, apenas desative
    if (!value) {
      print('[🔔 TOGGLE] Disabling notification (user turned off)');
      bloc.add(TaskFormUpdateFieldsEvent(shouldNotify: false));
      return;
    }
    
    print('[🔔 TOGGLE] Attempting to enable notification - requesting permissions...');

    // Se o usuário está tentando ATIVAR a notificação, solicite permissões
    try {
      // Solicita todas as permissões necessárias (notificação + exact alarm)
      print('[🔔 TOGGLE] Calling requestAllPermissions...');
      final allPermissionsGranted = await _notificationService.requestAllPermissions(
        context: mounted ? context : null,
      );
      print('[🔔 TOGGLE] requestAllPermissions result: $allPermissionsGranted');

      if (!allPermissionsGranted) {
        // Permissão de notificação negada - NÃO ativa o switch
        print('[🔔 TOGGLE] ❌ Notification permission DENIED - reverting switch to false');
        if (mounted) {
          _showPermissionDeniedDialog();
        }
        // Garante que o switch permaneça desativado
        bloc.add(TaskFormUpdateFieldsEvent(shouldNotify: false));
        return;
      }
      
      print('[🔔 TOGGLE] ✅ Notification permission GRANTED');

      // Permissão de notificação concedida, agora verifica exact alarm
      print('[🔔 TOGGLE] Checking exact alarm permission...');
      final canScheduleExact = await _notificationService.canScheduleExactAlarms();
      print('[🔔 TOGGLE] Can schedule exact alarms: $canScheduleExact');
      
      if (!canScheduleExact) {
        print('[🔔 TOGGLE] ⚠️ Exact alarm permission not granted - showing dialog');
        // Mostra diálogo explicando a importância da permissão de alarmes exatos
        if (!mounted) {
          print('[🔔 TOGGLE] Widget not mounted - reverting to false');
          bloc.add(TaskFormUpdateFieldsEvent(shouldNotify: false));
          return;
        }

        final shouldProceed = await _showExactAlarmPermissionDialog();
        print('[🔔 TOGGLE] User response to exact alarm dialog: $shouldProceed');
        
        if (!shouldProceed) {
          // Usuário cancelou, NÃO ativa
          print('[🔔 TOGGLE] User cancelled exact alarm - reverting to false');
          bloc.add(TaskFormUpdateFieldsEvent(shouldNotify: false));
          return;
        }

        // Tenta solicitar permissão de exact alarm
        print('[🔔 TOGGLE] Requesting exact alarm permission (opening settings)...');
        await _notificationService.requestExactAlarmPermission();
        
        // Verifica novamente se foi concedida
        final nowCanSchedule = await _notificationService.canScheduleExactAlarms();
        print('[🔔 TOGGLE] After settings, can schedule exact: $nowCanSchedule');
        
        if (nowCanSchedule) {
          // Tudo certo, ativa a notificação
          print('[🔔 TOGGLE] ✅ ALL PERMISSIONS OK - Setting shouldNotify = true');
          bloc.add(TaskFormUpdateFieldsEvent(shouldNotify: true));
        } else {
          // Permissão negada, mas permite ativar com aviso
          print('[🔔 TOGGLE] ⚠️ Exact alarm still denied - activating with warning');
          if (mounted) {
            _showWarningDialog(
              'Aviso',
              'As notificações foram ativadas, mas sem a permissão de "Alarmes e lembretes", '
              'elas podem não funcionar corretamente quando o dispositivo estiver em modo de economia de energia.\n\n'
              'Para garantir que as notificações funcionem, vá em Configurações > Apps > iKanban > Alarmes e lembretes e ative a permissão.',
            );
          }
          print('[🔔 TOGGLE] Setting shouldNotify = true (with warning)');
          bloc.add(TaskFormUpdateFieldsEvent(shouldNotify: true));
        }
      } else {
        // Todas as permissões OK, ativa normalmente
        print('[🔔 TOGGLE] ✅ ALL PERMISSIONS OK (exact alarm granted) - Setting shouldNotify = true');
        bloc.add(TaskFormUpdateFieldsEvent(shouldNotify: true));
      }
    } catch (e, stackTrace) {
      // Erro ao solicitar permissões - NÃO ativa
      print('[🔔 TOGGLE] ❌ ERROR during permission request: $e');
      print('[🔔 TOGGLE] Stack trace: $stackTrace');
      if (mounted) {
        _showErrorDialog('Erro ao solicitar permissões: $e');
      }
      bloc.add(TaskFormUpdateFieldsEvent(shouldNotify: false));
    }
  }

  /// Show dialog explaining the importance of exact alarm permission
  Future<bool> _showExactAlarmPermissionDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.alarm, color: Colors.orange),
            SizedBox(width: 12),
            Expanded(child: Text('Permissão Adicional')),
          ],
        ),
        content: const Text(
          'Para que as notificações funcionem de forma precisa e confiável, '
          'é necessário ativar a permissão de "Alarmes e lembretes".\n\n'
          'Sem essa permissão, as notificações podem ser atrasadas ou não serem exibidas '
          'quando o dispositivo estiver em modo de economia de energia.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Agora não'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: const Text('Ativar'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Show permission denied dialog
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 12),
            const Expanded(child: Text('Permissão Negada')),
          ],
        ),
        content: const Text(
          'A permissão de notificações é necessária para enviar lembretes sobre suas tarefas.\n\n'
          'Para ativar notificações, você precisa conceder a permissão de notificações nas configurações do app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show warning dialog
  void _showWarningDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.orange),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  /// Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 12),
            const Expanded(child: Text('Erro')),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onRequestDeleteTask({required VoidCallback onDeleteEvent}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Tarefa'),
        content: const Text(
          'Tem certeza que deseja excluir esta tarefa? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              onDeleteEvent();
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
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
                _onRequestDeleteTask(
                  onDeleteEvent: () => bloc.add(DeleteTaskEvent()),
                );
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
                        _removeFocus();
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
                      onTap: () {
                        _removeFocus();
                        showPrioritySelector(context, state);
                      }
                    ),
                    const SizedBox(height: 16),
                    ComplexitySelectorField(
                      title: 'Complexidade',
                      displayText: state.complexity.displayName,
                      description: state.complexity.description,
                      icon: state.complexity.icon,
                      iconColor: state.complexity.color,
                      storyPoints: state.complexity.suggestedStoryPoints,
                      onTap: () {
                        _removeFocus();
                        showComplexitySelector(context, state);
                      }
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
                      onTap: () {
                        _removeFocus();
                        showTypeSelector(context, state);
                      },
                    ),
                    const SizedBox(height: 16),
                    DateSelectorField<TaskFormBloc, TaskFormState>(
                      title: 'Data de Vencimento',
                      selectedDate: state.dueDate,
                      selectedTime: state.dueTime,
                      onTap: () {
                        _removeFocus();
                        showDueDateSelector(context, state);
                      },
                    ),
                    
                    // Notification settings (only show if dueDate and dueTime are set)
                    if (state.dueDate != null && state.dueTime != null) ...[
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      
                      // Notification header
                      Row(
                        children: [
                          Icon(
                            Icons.notifications_active,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Notificação',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Enable notification switch
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: state.shouldNotify
                                ? theme.colorScheme.primary.withValues(alpha: 0.3)
                                : theme.colorScheme.outline.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              state.shouldNotify
                                  ? Icons.notifications_active
                                  : Icons.notifications_off,
                              color: state.shouldNotify
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ativar notificação',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  Text(
                                    'Receba um lembrete sobre esta tarefa',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: state.shouldNotify,
                              onChanged: (value) async {
                                await _handleNotificationToggle(value, bloc);
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      // Notify minutes before selector
                      if (state.shouldNotify) ...[
                        const SizedBox(height: 16),
                        FormSelectorField(
                          title: 'Notificar antes',
                          displayText: _getNotifyBeforeText(state.notifyMinutesBefore ?? 0),
                          icon: Icons.schedule,
                          iconColor: theme.colorScheme.primary,
                          onTap: () {
                            _removeFocus();
                            _showNotifyBeforeSelector(context, state);
                          },
                        ),
                      ],
                    ],
                    
                    // Space for floating action buttons
                    const SizedBox(height: 128),
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

  String _getNotifyBeforeText(int minutes) {
    if (minutes == 0) {
      return 'No horário da tarefa';
    }

    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (hours > 0 && mins > 0) {
      return '$hours hora${hours > 1 ? 's' : ''} e $mins minuto${mins > 1 ? 's' : ''} antes';
    } else if (hours > 0) {
      return '$hours hora${hours > 1 ? 's' : ''} antes';
    } else {
      return '$mins minuto${mins > 1 ? 's' : ''} antes';
    }
  }

  void _showNotifyBeforeSelector(BuildContext context, TaskFormState state) {
    final options = [
      {'label': 'No horário da tarefa', 'value': 0},
      {'label': '5 minutos antes', 'value': 5},
      {'label': '10 minutos antes', 'value': 10},
      {'label': '15 minutos antes', 'value': 15},
      {'label': '30 minutos antes', 'value': 30},
      {'label': '1 hora antes', 'value': 60},
      {'label': '2 horas antes', 'value': 120},
      {'label': '1 dia antes', 'value': 1440},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notificar antes',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        final isSelected =
                            (state.notifyMinutesBefore ?? 0) == option['value'];
                        return ListTile(
                          leading: Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          title: Text(option['label'] as String),
                          selected: isSelected,
                          onTap: () {
                            context.read<TaskFormBloc>().add(
                                  TaskFormUpdateFieldsEvent(
                                    notifyMinutesBefore: option['value'] as int,
                                  ),
                                );
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
