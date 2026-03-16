import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/di/app_locator.dart';
import 'package:flutter_ikanban_app/features/board/domain/model/board_model.dart';
import 'package:flutter_ikanban_app/features/board/presentation/bloc/board_form_bloc.dart';
import 'package:flutter_ikanban_app/features/board/presentation/events/board_form_event.dart';
import 'package:flutter_ikanban_app/features/board/presentation/states/board_form_state.dart';

class BoardFormBottomSheet extends StatelessWidget {
  final BoardModel? board; // null = create, non-null = edit

  const BoardFormBottomSheet({
    super.key,
    this.board,
  });

  /// Show the board form bottom sheet for creating a new board
  static Future<bool?> showCreate({
    required BuildContext context,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const BoardFormBottomSheet(),
    );
  }

  /// Show the board form bottom sheet for editing an existing board
  static Future<bool?> showEdit({
    required BuildContext context,
    required BoardModel board,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BoardFormBottomSheet(board: board),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = board != null;

    return BlocProvider(
      create: (context) {
        final bloc = BoardFormBloc(
          getIt(),
          getIt(),
        );
        
        // Initialize with board data if editing
        if (isEditMode) {
          bloc.add(
            BoardFormInitializeEvent(
              boardId: board!.id,
              title: board!.title,
              description: board!.description,
              color: board!.color,
            ),
          );
        }
        
        return bloc;
      },
      child: BoardFormBottomSheetContent(isEditMode: isEditMode),
    );
  }
}

class BoardFormBottomSheetContent extends StatefulWidget {
  final bool isEditMode;

  const BoardFormBottomSheetContent({
    super.key,
    required this.isEditMode,
  });

  @override
  State<BoardFormBottomSheetContent> createState() =>
      _BoardFormBottomSheetContentState();
}

class _BoardFormBottomSheetContentState
    extends State<BoardFormBottomSheetContent> {
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
  bool _isInitialized = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _initializeFields(BoardFormState state) {
    if (_isInitialized) return;

    if (widget.isEditMode && state.boardId != null) {
      _titleController.text = state.title;
      _descriptionController.text = state.description ?? '';
      
      // Parse and set color
      if (state.color != null) {
        try {
          final colorString = state.color!.replaceAll('#', '');
          final colorValue = int.parse('FF$colorString', radix: 16);
          _selectedColor = Color(colorValue);
        } catch (e) {
          _selectedColor = _availableColors.first;
        }
      }
      
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return BlocConsumer<BoardFormBloc, BoardFormState>(
      listener: (context, state) {
        if (state.closeDialog) {
          Navigator.of(context).pop(true);
          if (state.showNotification) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  widget.isEditMode
                      ? 'Quadro atualizado com sucesso!'
                      : 'Quadro criado com sucesso!',
                ),
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
        // Initialize fields when editing
        _initializeFields(state);

        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurfaceVariant
                                .withOpacity(0.4),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _selectedColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.dashboard,
                              color: _selectedColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.isEditMode
                                      ? 'Editar Quadro'
                                      : 'Novo Quadro',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                if (widget.isEditMode)
                                  Text(
                                    'Atualize as informações do quadro',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                              ],
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
                                      color:
                                          '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
                                    ),
                                  );
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(12),
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
                      const SizedBox(height: 32),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: state.isLoading
                                  ? null
                                  : () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Cancelar'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: state.isLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        if (widget.isEditMode) {
                                          context
                                              .read<BoardFormBloc>()
                                              .add(UpdateBoardEvent());
                                        } else {
                                          context
                                              .read<BoardFormBloc>()
                                              .add(CreateBoardEvent());
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: state.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      widget.isEditMode
                                          ? 'Atualizar Quadro'
                                          : 'Criar Quadro',
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
