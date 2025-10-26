import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';

class TaskItemList extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleCompletion;
  final VoidCallback? onStatusTap;
  final Color? cardColor;
  final Color? borderColor;

  const TaskItemList({
    super.key, 
    required this.task, 
    this.onTap, 
    this.onToggleCompletion,
    this.onStatusTap,
    this.cardColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveCardColor = cardColor ?? theme.cardColor;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: effectiveCardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: borderColor != null 
            ? BorderSide(color: borderColor!, width: 1.5)
            : BorderSide.none,
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Conteúdo principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    
                    // Descrição
                    if (task.description != null && task.description!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        task.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
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
                                ? Colors.red
                                : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Vence em ${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                            style: TextStyle(
                              fontSize: 12,
                              color: task.dueDate!.isBefore(DateTime.now())
                                  ? Colors.red
                                  : Colors.grey[600],
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
              
              const SizedBox(width: 12),
              
              // Status e Prioridade
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Status Chip (clicável)
                  GestureDetector(
                    onTap: onStatusTap,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: onStatusTap != null 
                            ? Border.all(color: task.status.color.withOpacity(0.3))
                            : null,
                      ),
                      child: Chip(
                        label: Text(
                          task.status.displayName,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: task.status.color.withAlpha(50),
                        avatar: Icon(
                          task.status.icon,
                          size: 14,
                          color: task.status.color,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ),
                  
                  // Indicador de Prioridade
                  if (task.priority.name != 'low') ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: task.priority.name == 'high'
                            ? Colors.red.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: task.priority.name == 'high'
                              ? Colors.red.withOpacity(0.3)
                              : Colors.orange.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.priority_high,
                            size: 12,
                            color: task.priority.name == 'high'
                                ? Colors.red
                                : Colors.orange,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            task.priority.name == 'high' ? 'Alta' : 'Média',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: task.priority.name == 'high'
                                  ? Colors.red[700]
                                  : Colors.orange[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  // Botão de toggle completion (se fornecido)
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
                            : Colors.grey,
                      ),
                      visualDensity: VisualDensity.compact,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
