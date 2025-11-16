import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/presentation/extensions/task_type_enum_extensions.dart';

class FilterSelectorBottomSheet extends StatefulWidget {
  final List<TaskType> initialSelectedTypes;
  final Function(List<TaskType>) onApply;
  final VoidCallback? onClear;

  const FilterSelectorBottomSheet({
    super.key,
    this.initialSelectedTypes = const [],
    required this.onApply,
    this.onClear,
  });

  static Future<void> show({
    required BuildContext context,
    List<TaskType> initialSelectedTypes = const [],
    required Function(List<TaskType>) onApply,
    VoidCallback? onClear,
  }) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterSelectorBottomSheet(
        initialSelectedTypes: initialSelectedTypes,
        onApply: onApply,
        onClear: onClear,
      ),
      useSafeArea: true
    );
  }

  @override
  State<FilterSelectorBottomSheet> createState() =>
      _FilterSelectorBottomSheetState();
}

class _FilterSelectorBottomSheetState extends State<FilterSelectorBottomSheet> {
  late Set<TaskType> _selectedTypes;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedTypes = Set.from(widget.initialSelectedTypes);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleType(TaskType type) {
    setState(() {
      if (_selectedTypes.contains(type)) {
        _selectedTypes.remove(type);
      } else {
        _selectedTypes.add(type);
      }
    });
  }

  void _removeType(TaskType type) {
    setState(() {
      _selectedTypes.remove(type);
    });
  }

  void _clearAll() {
    setState(() {
      _selectedTypes.clear();
    });
    widget.onClear?.call();
  }

  void _applyFilters() {
    widget.onApply(_selectedTypes.toList());
    Navigator.of(context).pop();
  }

  Widget _buildSelectedChips() {
    if (_selectedTypes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selecionados (${_selectedTypes.length})',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              if (_selectedTypes.isNotEmpty)
                TextButton.icon(
                  onPressed: _clearAll,
                  icon: Icon(
                    Icons.clear_all,
                    size: 16,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  label: Text(
                    'Limpar Tudo',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedTypes.map((type) {
              return Chip(
                avatar: Icon(type.icon, size: 16, color: type.color),
                label: Text(
                  type.displayName,
                  style: const TextStyle(fontSize: 12),
                ),
                deleteIcon: Icon(
                  Icons.close,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onDeleted: () => _removeType(type),
                backgroundColor: type.color.withValues(alpha: 0.1),
                side: BorderSide(
                  color: type.color.withValues(alpha: 0.3),
                  width: 1,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption(TaskType type) {
    final isSelected = _selectedTypes.contains(type);
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _toggleType(type),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? type.color
                  : theme.colorScheme.outline.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
            color: isSelected
                ? type.color.withValues(alpha: 0.1)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: type.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(type.icon, color: type.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.displayName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected
                            ? type.color
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      type.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: type.color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 16,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height * 0.85;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle indicator
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filtrar por Tipo',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: theme.colorScheme.onSurface,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.surface,
                    minimumSize: const Size(32, 32),
                  ),
                ),
              ],
            ),
          ),

          // Selected chips section
          _buildSelectedChips(),

          // Divider
          if (_selectedTypes.isNotEmpty)
            Divider(
              height: 1,
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),

          // Scrollable list of types
          Flexible(
            child: Scrollbar(
              controller: _scrollController,
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                itemCount: TaskType.values.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final type = TaskType.values[index];
                  return _buildTypeOption(type);
                },
              ),
            ),
          ),

          // Bottom action buttons
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 16 + mediaQuery.padding.bottom,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clearAll,
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Limpar'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: _applyFilters,
                    icon: const Icon(Icons.filter_list),
                    label: Text(
                      _selectedTypes.isEmpty
                          ? 'Aplicar'
                          : 'Aplicar (${_selectedTypes.length})',
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
