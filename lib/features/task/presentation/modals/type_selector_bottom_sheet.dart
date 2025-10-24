import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';

class TypeSelectorBottomSheet extends StatelessWidget {
  final TaskType selectedType;
  final Function(TaskType) onTypeSelected;

  const TypeSelectorBottomSheet({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });
  
  @override
  Widget build(BuildContext context) {
    // Organiza os tipos em categorias
    final technicalTypes = [
      TaskType.feature,
      TaskType.bug,
      TaskType.improvement,
      TaskType.documentation,
    ];
    
    final domesticTypes = [
      TaskType.housework,
      TaskType.shopping,
      TaskType.maintenance,
      TaskType.health,
      TaskType.finance,
      TaskType.cooking,
    ];
    
    final personalTypes = [
      TaskType.study,
      TaskType.personal,
      TaskType.family,
      TaskType.exercise,
      TaskType.hobby,
      TaskType.social,
    ];
    
    final otherTypes = TaskType.values
        .where((type) => 
            !technicalTypes.contains(type) && 
            !domesticTypes.contains(type) && 
            !personalTypes.contains(type))
        .toList();

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
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            'Selecione o Tipo',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tipo atual: ${selectedType.displayName}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategory(context, 'Técnico', technicalTypes),
                  const SizedBox(height: 16),
                  _buildCategory(context, 'Doméstico', domesticTypes),
                  const SizedBox(height: 16),
                  _buildCategory(context, 'Pessoal', personalTypes),
                  const SizedBox(height: 16),
                  _buildCategory(context, 'Outros', otherTypes),
                ],
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

  Widget _buildCategory(BuildContext context, String categoryName, List<TaskType> types) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          categoryName,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        ...types.map((type) {
          final isSelected = type == selectedType;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () {
                onTypeSelected(type);
                Navigator.of(context).pop();
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? type.color.withValues(alpha: 0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? type.color : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      type.icon,
                      color: type.color,
                      size: 24,
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
                              color: type.color,
                            ),
                          ),
                          if (type.description.isNotEmpty)
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
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  static void show({
    required BuildContext context,
    required TaskType selectedType,
    required Function(TaskType) onTypeSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: TypeSelectorBottomSheet(
          selectedType: selectedType,
          onTypeSelected: onTypeSelected,
        ),
      ),
    );
  }
}