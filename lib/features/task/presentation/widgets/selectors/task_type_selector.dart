// widgets/task_type_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';

// ============================================================================
// VERSÃO 5: Bottom Sheet (Para tela cheia)
// ============================================================================

class TaskTypeBottomSheet extends StatelessWidget {
  final TaskType selectedType;
  final Function(TaskType) onTypeSelected;
  final bool showTechnicalTypes;

  const TaskTypeBottomSheet({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
    this.showTechnicalTypes = false,
  });

  static Future<TaskType?> show({
    required BuildContext context,
    required TaskType selectedType,
    bool showTechnicalTypes = false,
  }) {
    return showModalBottomSheet<TaskType>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => TaskTypeBottomSheet(
        selectedType: selectedType,
        onTypeSelected: (type) => Navigator.pop(context, type),
        showTechnicalTypes: showTechnicalTypes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final types = _getFilteredTypes();

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Título
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selecione o Tipo',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Lista de tipos
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: types.length,
                itemBuilder: (context, index) {
                  final type = types[index];
                  final isSelected = type == selectedType;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () => onTypeSelected(type),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? type.color.withAlpha(50) 
                              : Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected 
                                ? type.color 
                                : Colors.grey[200]!,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: type.color.withAlpha(50),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                type.icon,
                                color: type.color,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    type.displayName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected 
                                          ? FontWeight.bold 
                                          : FontWeight.w500,
                                      color: isSelected 
                                          ? type.color 
                                          : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    type.description,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: type.color,
                                size: 28,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  List<TaskType> _getFilteredTypes() {
    if (showTechnicalTypes) {
      return TaskType.values;
    }
    
    return TaskType.values.where((type) => 
      type != TaskType.feature &&
      type != TaskType.bug &&
      type != TaskType.improvement &&
      type != TaskType.documentation
    ).toList();
  }
}