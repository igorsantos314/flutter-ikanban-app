import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/checklist_item_model.dart';

class EditChecklistItemBottomSheet extends StatefulWidget {
  final ChecklistItemModel item;
  final Function(String title, String? description, bool isCompleted) onSave;
  final VoidCallback onDelete;

  const EditChecklistItemBottomSheet({
    super.key,
    required this.item,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<EditChecklistItemBottomSheet> createState() =>
      _EditChecklistItemBottomSheetState();

  static void show({
    required BuildContext context,
    required ChecklistItemModel item,
    required Function(String title, String? description, bool isCompleted) onSave,
    required VoidCallback onDelete,
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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: EditChecklistItemBottomSheet(
          item: item,
          onSave: onSave,
          onDelete: onDelete,
        ),
      ),
    );
  }
}

class _EditChecklistItemBottomSheetState
    extends State<EditChecklistItemBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late bool _isCompleted;
  bool _isLoading = false;

  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 200;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item.title);
    _descriptionController = TextEditingController(text: widget.item.description ?? '');
    _isCompleted = widget.item.isCompleted;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    widget.onSave(
      _titleController.text.trim(),
      _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      _isCompleted,
    );

    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _handleDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Item'),
        content: const Text(
          'Tem certeza que deseja excluir este item do checklist?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              widget.onDelete();
              Navigator.of(context).pop(); // Close bottom sheet
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: .3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title
              Text(
                'Editar Item',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 20),

              // Completed toggle
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isCompleted
                        ? colorScheme.primary.withValues(alpha: 0.3)
                        : colorScheme.onSurface.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isCompleted ? Icons.check_circle : Icons.circle_outlined,
                      color: _isCompleted
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isCompleted ? 'Concluído' : 'Não concluído',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Switch(
                      value: _isCompleted,
                      onChanged: (value) {
                        setState(() => _isCompleted = value);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Title field
              TextFormField(
                controller: _titleController,
                maxLength: maxTitleLength,
                decoration: InputDecoration(
                  labelText: 'Título',
                  hintText: 'Digite o título do item',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  counterText: '${_titleController.text.length}/$maxTitleLength',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'O título é obrigatório';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {}),
              ),

              const SizedBox(height: 16),

              // Description field
              TextFormField(
                controller: _descriptionController,
                maxLength: maxDescriptionLength,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Descrição (opcional)',
                  hintText: 'Digite a descrição do item',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  counterText:
                      '${_descriptionController.text.length}/$maxDescriptionLength',
                ),
                onChanged: (value) => setState(() {}),
              ),

              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  // Delete button
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _handleDelete,
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text(
                      'Excluir',
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Save button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Salvar'),
                    ),
                  ),
                ],
              ),

              // Bottom padding for safe area
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
