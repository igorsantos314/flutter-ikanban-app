import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/core/ui/enums/layout_mode.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/presentation/colors/task_colors.dart';
import 'package:flutter_ikanban_app/features/task/presentation/enums/task_size.dart';
import 'package:flutter_ikanban_app/features/task/presentation/extensions/task_complexity_enum_extensions.dart';
import 'package:flutter_ikanban_app/features/task/presentation/extensions/task_priority_enum_extensions.dart';
import 'package:flutter_ikanban_app/features/task/presentation/extensions/task_status_enum_extensions.dart';
import 'package:flutter_ikanban_app/features/task/presentation/extensions/task_type_enum_extensions.dart';

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

    Color borderColor;
    Color cardColor;
    Color priorityColor;
    Color textColor = theme.colorScheme.onSurface;

    if (task.status == TaskStatus.done) {
      priorityColor = TaskColors.green.color;
      borderColor = TaskColors.green.color;
      cardColor = TaskColors.green.color;
      textColor = Colors.black;
    } else if (task.status == TaskStatus.cancelled) {
      priorityColor = Colors.grey;
      borderColor = Colors.grey;
      cardColor = Colors.grey;
      textColor = Colors.black87;
    } else {
      priorityColor = task.priority.color;
      borderColor = task.color.color;
      cardColor = theme.colorScheme.surface;
    }

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 2),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com prioridade e ícones
            Container(
              decoration: BoxDecoration(
                color: priorityColor.withAlpha(150),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 6.0,
                ),
                child: Row(
                  children: [
                    Icon(task.priority.icon, size: 18, color: textColor),
                    const SizedBox(width: 4),
                    Text(
                      task.priority.displayName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: textColor,
                      ),
                    ),
                    const Spacer(),
                    // Ícones do lado direito
                    Icon(task.type.icon, size: 18, color: textColor),
                    const SizedBox(width: 6),
                    Icon(task.complexity.icon, size: 18, color: textColor),
                    const SizedBox(width: 4),
                    Text(
                      '${task.complexity.index + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(task.status.icon, size: 18, color: textColor),
                  ],
                ),
              ),
            ),
            // Conteúdo compacto (máximo 3 linhas)
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                height: taskSize == TaskSize.comfortable ? 70 : 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Linha 1: Título
                    Text(
                      task.title,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: textColor,
                      ),
                    ),

                    // Linha 2: Descrição (se houver)
                    if (task.description != null &&
                        task.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description!,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textColor.withAlpha(180),
                          fontSize: 12,
                        ),
                      ),
                    ],

                    // Linha 3: Data de entrega (se houver)
                    if (task.dueDate != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 12,
                            color: task.dueDate!.isBefore(DateTime.now())
                                ? theme.colorScheme.error
                                : textColor.withAlpha(180),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 11,
                              color: task.dueDate!.isBefore(DateTime.now())
                                  ? theme.colorScheme.error
                                  : textColor.withAlpha(180),
                              fontWeight: task.dueDate!.isBefore(DateTime.now())
                                  ? FontWeight.w600
                                  : FontWeight.normal,
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
    );
  }
}
