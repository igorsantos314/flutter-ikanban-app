import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/presentation/extensions/task_status_enum_extensions.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/selectors/status_selector.dart';

class StatusSelectorBottomSheet extends StatelessWidget {
  final TaskStatus selectedStatus;
  final Function(TaskStatus) onStatusSelected;
  final bool isShowArchived;

  const StatusSelectorBottomSheet({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
    this.isShowArchived = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            'Selecione o Status',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Status atual: ${selectedStatus.displayName}',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: SingleChildScrollView(
              child: StatusSelector(
                selectedStatus: selectedStatus,
                isShowArchived: isShowArchived,
                onStatusSelected: (status) {
                  onStatusSelected(status);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ),
        ],
      ),
    );
  }

  static void show({
    required BuildContext context,
    required TaskStatus selectedStatus,
    required Function(TaskStatus) onStatusSelected,
    bool isShowArchived = false,
    VoidCallback? onDismissed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: StatusSelectorBottomSheet(
          selectedStatus: selectedStatus,
          onStatusSelected: onStatusSelected,
          isShowArchived: isShowArchived,
        ),
      ),
    );
  }
}
