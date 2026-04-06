import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/core/ui/enums/layout_mode.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/presentation/enums/task_size.dart';
import 'package:flutter_ikanban_app/features/task/presentation/colors/task_colors.dart';
import 'package:intl/intl.dart';

class TaskItemList extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onToggleCompletion;
  final VoidCallback? onStatusTap;
  final Color? cardColor;
  final Color? borderColor;
  final LayoutMode layoutMode;
  final TaskSize taskSize;

  const TaskItemList({
    super.key,
    required this.task,
    this.onTap,
    this.onLongPress,
    this.onToggleCompletion,
    this.onStatusTap,
    this.cardColor,
    this.borderColor,
    this.layoutMode = LayoutMode.fullWidth,
    this.taskSize = TaskSize.comfortable,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCompact = taskSize == TaskSize.compact;

    // Determinar cor da badge de prioridade
    Color priorityBadgeColor;
    String priorityLabel;
    
    switch (task.priority) {
      case TaskPriority.critical:
      case TaskPriority.highest:
      case TaskPriority.high:
        priorityBadgeColor = const Color(0xFFFFE5E5);
        priorityLabel = 'Alta';
        break;
      case TaskPriority.medium:
        priorityBadgeColor = const Color(0xFFFFF4E5);
        priorityLabel = 'Média';
        break;
      case TaskPriority.low:
      case TaskPriority.lowest:
        priorityBadgeColor = const Color(0xFFE5F4FF);
        priorityLabel = 'Baixa';
        break;
    }

    Color priorityTextColor;
    switch (task.priority) {
      case TaskPriority.critical:
      case TaskPriority.highest:
      case TaskPriority.high:
        priorityTextColor = const Color(0xFFD32F2F);
        break;
      case TaskPriority.medium:
        priorityTextColor = const Color(0xFFFF9800);
        break;
      case TaskPriority.low:
      case TaskPriority.lowest:
        priorityTextColor = const Color(0xFF2196F3);
        break;
    }

    // Determinar cor da barra de progresso
    Color progressColor;
    if (task.status == TaskStatus.done) {
      progressColor = const Color(0xFF4CAF50);
    } else if (task.status == TaskStatus.inProgress) {
      progressColor = const Color(0xFF2196F3);
    } else {
      progressColor = colorScheme.outline.withOpacity(0.3);
    }

    return Card(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Barra de cor lateral
                Container(
                  width: 4,
                  color: task.color.color,
                ),
                // Conteúdo do card
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(isCompact ? 10 : 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Título e Badge de Prioridade
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                isCompact && task.title.length > 40
                                    ? '${task.title.substring(0, 40)}...'
                                    : task.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: isCompact ? 13 : 16,
                                  color: colorScheme.onSurface,
                                  height: isCompact ? 1.2 : null,
                                ),
                                maxLines: isCompact ? 1 : 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: isCompact ? 8 : 12),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isCompact ? 6 : 12,
                                vertical: isCompact ? 3 : 6,
                              ),
                              decoration: BoxDecoration(
                                color: priorityBadgeColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: isCompact ? 5 : 8,
                                    color: priorityTextColor,
                                  ),
                                  SizedBox(width: isCompact ? 3 : 4),
                                  Text(
                                    priorityLabel,
                                    style: TextStyle(
                                      fontSize: isCompact ? 9 : 12,
                                      fontWeight: FontWeight.w500,
                                      color: priorityTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Descrição (apenas no modo comfortable)
                        if (!isCompact &&
                            task.description != null &&
                            task.description!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            task.description!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                              fontSize: 14,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],

                        // Checklist Progress
                        if (task.checklistTotal > 0) ...[
                          SizedBox(height: isCompact ? 6 : 16),
                          
                          // Modo Compacto: Apenas barra de progresso
                          if (isCompact) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: task.checklistTotal > 0
                                    ? task.checklistCompleted / task.checklistTotal
                                    : 0.0,
                                backgroundColor: colorScheme.outline.withOpacity(0.1),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  task.checklistCompleted == task.checklistTotal
                                      ? const Color(0xFF4CAF50)
                                      : progressColor,
                                ),
                                minHeight: 5,
                              ),
                            ),
                          ],
                          
                          // Modo Normal: Textos + Barra
                          if (!isCompact) ...[
                            Row(
                              children: [
                                Icon(
                                  task.checklistCompleted == task.checklistTotal
                                      ? Icons.check_circle
                                      : Icons.check_circle_outline,
                                  size: 16,
                                  color: task.checklistCompleted == task.checklistTotal
                                      ? const Color(0xFF4CAF50)
                                      : colorScheme.onSurface.withOpacity(0.6),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    task.checklistCompleted == task.checklistTotal
                                        ? 'Checklist Completo'
                                        : 'Progresso do Checklist',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 13,
                                      color: task.checklistCompleted == task.checklistTotal
                                          ? const Color(0xFF4CAF50)
                                          : colorScheme.onSurface.withOpacity(0.6),
                                      fontWeight: task.checklistCompleted == task.checklistTotal
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${task.checklistCompleted}/${task.checklistTotal}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: task.checklistCompleted == task.checklistTotal
                                        ? const Color(0xFF4CAF50)
                                        : colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Barra de Progresso
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: task.checklistTotal > 0
                                    ? task.checklistCompleted / task.checklistTotal
                                    : 0.0,
                                backgroundColor: colorScheme.outline.withOpacity(0.1),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  task.checklistCompleted == task.checklistTotal
                                      ? const Color(0xFF4CAF50)
                                      : progressColor,
                                ),
                                minHeight: 8,
                              ),
                            ),
                          ],
                        ],

                        // Data de Vencimento
                        if (task.dueDate != null) ...[
                          SizedBox(height: isCompact ? 6 : 12),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: isCompact ? 11 : 14,
                                color: task.dueDate!.isBefore(DateTime.now())
                                    ? colorScheme.error
                                    : colorScheme.onSurface.withOpacity(0.6),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  isCompact
                                      ? DateFormat('dd/MM/yy').format(task.dueDate!)
                                      : 'Vencimento: ${DateFormat('dd/MM/yyyy').format(task.dueDate!)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: isCompact ? 9 : 12,
                                    color: task.dueDate!.isBefore(DateTime.now())
                                        ? colorScheme.error
                                        : colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
