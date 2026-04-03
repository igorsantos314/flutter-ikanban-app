import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/checklist_item_model.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/task_form_bloc.dart';
import 'package:flutter_ikanban_app/features/task/presentation/states/form/task_form_state.dart';

class ChecklistSection extends StatelessWidget {
  final int? taskId;
  final VoidCallback onAddItem;
  final Function(int itemId, int index) onToggleItem;
  final Function(int itemId, int index) onDeleteItem;
  final Function(ChecklistItemModel item, int index)? onTapItem;

  const ChecklistSection({
    super.key,
    this.taskId,
    required this.onAddItem,
    required this.onToggleItem,
    required this.onDeleteItem,
    this.onTapItem,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<TaskFormBloc, TaskFormState>(
      builder: (context, state) {
        final items = state.checklistItems;
        final itemCount = state.checklistItemCount;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Checklist',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (items.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${items.where((i) => i.isCompleted).length}/${items.length}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: itemCount >= TaskFormBloc.maxChecklistItems
                      ? null
                      : onAddItem,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Adicionar'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),

            if (itemCount >= TaskFormBloc.maxChecklistItems)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Máximo de ${TaskFormBloc.maxChecklistItems} itens atingido',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.orange,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

            const SizedBox(height: 12),

            // Items list
            if (items.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.onSurface.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.checklist,
                      size: 48,
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Nenhum item no checklist',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Adicione itens para organizar suas tarefas',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _ChecklistItemTile(
                    item: item,
                    onToggle: () => onToggleItem(item.id ?? -1, index),
                    onDelete: () => onDeleteItem(item.id ?? -1, index),
                    onTap: onTapItem != null
                        ? () => onTapItem!(item, index)
                        : null,
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

class _ChecklistItemTile extends StatelessWidget {
  final ChecklistItemModel item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const _ChecklistItemTile({
    required this.item,
    required this.onToggle,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isCompleted
              ? colorScheme.primary.withValues(alpha: 0.3)
              : colorScheme.onSurface.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? onToggle,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox
                GestureDetector(
                  onTap: onToggle,
                  child: Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: item.isCompleted
                          ? colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: item.isCompleted
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.4),
                        width: 2,
                      ),
                    ),
                    child: item.isCompleted
                        ? Icon(
                            Icons.check,
                            size: 14,
                            color: colorScheme.onPrimary,
                          )
                        : null,
                  ),
                ),

                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                          decoration: item.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                      if (item.description != null &&
                          item.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.description!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            decoration: item.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: colorScheme.onSurface
                                .withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Delete button
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  iconSize: 20,
                  color: Colors.red.withValues(alpha: 0.7),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
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
