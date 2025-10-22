// widgets/task_type_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';

// ============================================================================
// VERSÃO 1: Chips Horizontais (Wrap)
// ============================================================================

class TaskTypeSelector extends StatelessWidget {
  final TaskType selectedType;
  final Function(TaskType) onTypeSelected;
  final bool showTechnicalTypes;

  const TaskTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
    this.showTechnicalTypes = false,
  });

  @override
  Widget build(BuildContext context) {
    final types = _getFilteredTypes();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de Tarefa',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: types.map((type) {
            final isSelected = type == selectedType;
            return FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    type.icon,
                    size: 16,
                    color: isSelected ? Colors.white : type.color,
                  ),
                  const SizedBox(width: 4),
                  Text(type.displayName),
                ],
              ),
              backgroundColor: Colors.grey[200],
              selectedColor: type.color,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (selected) {
                if (selected) {
                  onTypeSelected(type);
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        // Informação sobre o tipo selecionado
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selectedType.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selectedType.color.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                selectedType.icon,
                color: selectedType.color,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedType.displayName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedType.color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      selectedType.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<TaskType> _getFilteredTypes() {
    if (showTechnicalTypes) {
      return TaskType.values;
    }
    
    // Filtrar apenas tipos domésticos
    return TaskType.values.where((type) => 
      type != TaskType.feature &&
      type != TaskType.bug &&
      type != TaskType.improvement &&
      type != TaskType.documentation
    ).toList();
  }
}

// ============================================================================
// VERSÃO 2: Grid de Cards (Mais Visual)
// ============================================================================

class TaskTypeGridSelector extends StatelessWidget {
  final TaskType selectedType;
  final Function(TaskType) onTypeSelected;
  final bool showTechnicalTypes;
  final int crossAxisCount;

  const TaskTypeGridSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
    this.showTechnicalTypes = false,
    this.crossAxisCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    final types = _getFilteredTypes();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: types.length,
          itemBuilder: (context, index) {
            final type = types[index];
            final isSelected = type == selectedType;

            return InkWell(
              onTap: () => onTypeSelected(type),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? type.color : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? type.color : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: type.color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      type.icon,
                      size: 32,
                      color: isSelected ? Colors.white : type.color,
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        type.displayName,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        // Descrição do tipo selecionado
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selectedType.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selectedType.color.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                selectedType.icon,
                color: selectedType.color,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  selectedType.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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

// ============================================================================
// VERSÃO 3: Lista Expansível (Melhor para muitas opções)
// ============================================================================

class TaskTypeListSelector extends StatelessWidget {
  final TaskType selectedType;
  final Function(TaskType) onTypeSelected;
  final bool showTechnicalTypes;

  const TaskTypeListSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
    this.showTechnicalTypes = false,
  });

  @override
  Widget build(BuildContext context) {
    final types = _getFilteredTypes();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de Tarefa',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: types.map((type) {
              final isSelected = type == selectedType;
              final isLast = type == types.last;

              return InkWell(
                onTap: () => onTypeSelected(type),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? type.color.withOpacity(0.1) 
                        : Colors.transparent,
                    border: isLast
                        ? null
                        : Border(
                            bottom: BorderSide(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: type.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          type.icon,
                          color: type.color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              type.displayName,
                              style: TextStyle(
                                fontWeight: isSelected 
                                    ? FontWeight.bold 
                                    : FontWeight.normal,
                                color: isSelected ? type.color : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              type.description,
                              style: TextStyle(
                                fontSize: 11,
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
                          size: 24,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
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

// ============================================================================
// VERSÃO 4: Dropdown (Compacto)
// ============================================================================

class TaskTypeDropdownSelector extends StatelessWidget {
  final TaskType selectedType;
  final Function(TaskType) onTypeSelected;
  final bool showTechnicalTypes;

  const TaskTypeDropdownSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
    this.showTechnicalTypes = false,
  });

  @override
  Widget build(BuildContext context) {
    final types = _getFilteredTypes();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de Tarefa',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<TaskType>(
          value: selectedType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: Icon(
              selectedType.icon,
              color: selectedType.color,
            ),
          ),
          items: types.map((type) {
            return DropdownMenuItem<TaskType>(
              value: type,
              child: Row(
                children: [
                  Icon(
                    type.icon,
                    color: type.color,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          type.displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          type.description,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (type) {
            if (type != null) {
              onTypeSelected(type);
            }
          },
        ),
      ],
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
                              ? type.color.withOpacity(0.1) 
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
                                color: type.color.withOpacity(0.2),
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