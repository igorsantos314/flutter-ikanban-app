import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/di/app_locator.dart';
import 'package:flutter_ikanban_app/features/board/presentation/bloc/board_form_bloc.dart';
import 'package:flutter_ikanban_app/features/board/presentation/events/board_form_event.dart';
import 'package:flutter_ikanban_app/features/board/presentation/states/board_form_state.dart';

class BoardCreateDialog extends StatelessWidget {
  const BoardCreateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoardFormBloc(getIt()),
      child: const BoardCreateDialogContent(),
    );
  }
}

class BoardCreateDialogContent extends StatefulWidget {
  const BoardCreateDialogContent({super.key});

  @override
  State<BoardCreateDialogContent> createState() =>
      _BoardCreateDialogContentState();
}

class _BoardCreateDialogContentState extends State<BoardCreateDialogContent> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<Color> _availableColors = [
    const Color(0xFFFF6B6B), // Red
    const Color(0xFF4ECDC4), // Teal
    const Color(0xFF45B7D1), // Blue
    const Color(0xFFFFA07A), // Orange
    const Color(0xFF98D8C8), // Mint
    const Color(0xFFB19CD9), // Purple
    const Color(0xFFFFD93D), // Yellow
    const Color(0xFF6BCF7F), // Green
  ];

  Color _selectedColor = const Color(0xFFFF6B6B);

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<BoardFormBloc, BoardFormState>(
      listener: (context, state) {
        if (state.closeDialog) {
          Navigator.of(context).pop();
          if (state.showNotification) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Quadro criado com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }

        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _selectedColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.dashboard,
                            color: _selectedColor,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Novo Quadro',
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Title field
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Título *',
                        hintText: 'Ex: Projeto 2024',
                        prefixIcon: const Icon(Icons.title),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorText: state.titleError,
                      ),
                      maxLength: 255,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'O título é obrigatório';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        context.read<BoardFormBloc>().add(
                              BoardFormUpdateFieldsEvent(title: value),
                            );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Description field
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Descrição',
                        hintText: 'Descreva o propósito deste quadro',
                        prefixIcon: const Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 3,
                      maxLength: 500,
                      onChanged: (value) {
                        context.read<BoardFormBloc>().add(
                              BoardFormUpdateFieldsEvent(description: value),
                            );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Color picker
                    Text(
                      'Cor do Quadro',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _availableColors.map((color) {
                        final isSelected = _selectedColor == color;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColor = color;
                            });
                            context.read<BoardFormBloc>().add(
                                  BoardFormUpdateFieldsEvent(
                                    color: '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
                                  ),
                                );
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: color.withOpacity(0.4),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: state.isLoading
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: const Text('Cancelar'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context
                                        .read<BoardFormBloc>()
                                        .add(CreateBoardEvent());
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                          ),
                          child: state.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text('Criar Quadro'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
