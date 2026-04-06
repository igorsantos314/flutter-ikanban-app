import 'package:flutter/material.dart';

class AddChecklistItemBottomSheet extends StatefulWidget {
  final int? taskId;
  final Function(String title, String? description) onAdd;

  const AddChecklistItemBottomSheet({
    super.key,
    this.taskId,
    required this.onAdd,
  });

  @override
  State<AddChecklistItemBottomSheet> createState() =>
      _AddChecklistItemBottomSheetState();

  static void show({
    required BuildContext context,
    int? taskId,
    required Function(String title, String? description) onAdd,
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
        child: AddChecklistItemBottomSheet(
          taskId: taskId,
          onAdd: onAdd,
        ),
      ),
    );
  }
}

class _AddChecklistItemBottomSheetState
    extends State<AddChecklistItemBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 200;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    widget.onAdd(
      _titleController.text.trim(),
      _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    // Wait a bit for the item to be added
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      Navigator.of(context).pop();
    }
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
                'Adicionar Item',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 20),

              // Title field
              TextFormField(
                controller: _titleController,
                maxLength: maxTitleLength,
                decoration: InputDecoration(
                  labelText: 'Título *',
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
                  if (value.trim().length > maxTitleLength) {
                    return 'O título deve ter no máximo $maxTitleLength caracteres';
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
                  labelText: 'Descrição',
                  hintText: 'Digite a descrição (opcional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  counterText:
                      '${_descriptionController.text.length}/$maxDescriptionLength',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value != null && value.trim().length > maxDescriptionLength) {
                    return 'A descrição deve ter no máximo $maxDescriptionLength caracteres';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {}),
              ),

              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : const Text('Adicionar'),
                    ),
                  ),
                ],
              ),

              // Padding bottom for safe area
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
