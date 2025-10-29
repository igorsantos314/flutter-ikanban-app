import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/presentation/colors/task_colors.dart';

class TaskItemList extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onToggleCompletion;
  final VoidCallback? onStatusTap;
  final Color? cardColor;
  final Color? borderColor;

  const TaskItemList({
    super.key,
    required this.task,
    this.onTap,
    this.onLongPress,
    this.onToggleCompletion,
    this.onStatusTap,
    this.cardColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      //color: task.color == TaskColors.defaultColor ? theme.colorScheme.surface : task.color.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: task.color.color, width: 2)
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            SizedBox(
              height: 35,
              child: Container(
                decoration: BoxDecoration(
                  color: task.priority.color.withAlpha(150),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(task.priority.icon, size: 20),
                      SizedBox(width: 4),
                      Text(
                        task.priority.displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Conteúdo principal
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (onToggleCompletion != null) ...[
                              const SizedBox(height: 8),
                              IconButton(
                                onPressed: onToggleCompletion,
                                icon: Icon(
                                  task.status == TaskStatus.done
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: task.status == TaskStatus.done
                                      ? Colors.green
                                      : theme.colorScheme.onSurface,
                                ),
                                visualDensity: VisualDensity.compact,
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                              ),
                            ],
                            // Título
                            Text(
                              task.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        // Descrição
                        if (task.description != null &&
                            task.description!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            task.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withAlpha(150),
                              fontSize: 14,
                            ),
                          ),
                        ],

                        // Data de vencimento
                        if (task.dueDate != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 14,
                                color: task.dueDate!.isBefore(DateTime.now())
                                    ? theme.colorScheme.error
                                    : theme.colorScheme.onSurface.withAlpha(
                                        150,
                                      ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Vence em ${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: task.dueDate!.isBefore(DateTime.now())
                                      ? theme.colorScheme.error
                                      : theme.colorScheme.onSurface.withAlpha(
                                          150,
                                        ),
                                  fontWeight:
                                      task.dueDate!.isBefore(DateTime.now())
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface.withAlpha(100),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.onSurface.withAlpha(
                                  20,
                                ),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 4,
                            children: [
                              Icon(
                                task.type.icon,
                                size: 24,
                                color: task.type.color,
                              ),
                              Icon(
                                task.complexity.icon,
                                size: 24,
                                color: task.complexity.color,
                              ),
                              Text(
                                '${task.complexity.index + 1} pts',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Status e Prioridade
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withAlpha(100),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.onSurface.withAlpha(20),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              task.status.icon,
                              size: 18,
                              color: task.status.color,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              task.status.displayName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
