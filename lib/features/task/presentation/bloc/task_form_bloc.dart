import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/di/app_locator.dart';
import 'package:flutter_ikanban_app/core/utils/messages.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/board/domain/services/board_selection_service.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/checklist_item_model.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/checklist_item_repository.dart';
import 'package:flutter_ikanban_app/features/task/domain/use_cases/create_task_use_case.dart';
import 'package:flutter_ikanban_app/features/task/domain/use_cases/delete_task_use_case.dart';
import 'package:flutter_ikanban_app/features/task/domain/use_cases/get_task_by_id_use_case.dart';
import 'package:flutter_ikanban_app/features/task/domain/use_cases/update_task_use_case.dart';
import 'package:flutter_ikanban_app/features/task/presentation/events/form/task_form_events.dart';
import 'package:flutter_ikanban_app/features/task/presentation/events/shared/task_shared_events.dart';
import 'package:flutter_ikanban_app/features/task/presentation/states/form/task_form_state.dart';

class TaskFormBloc extends Bloc<TaskEvent, TaskFormState> {
  final CreateTaskUseCase _createTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final GetTaskByIdUseCase _getTaskByIdUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final ChecklistItemRepository _checklistRepository;
  StreamSubscription? _checklistSubscription;

  static const int maxChecklistItems = 50;

  TaskFormBloc(
    this._createTaskUseCase,
    this._updateTaskUseCase,
    this._getTaskByIdUseCase,
    this._deleteTaskUseCase,
    this._checklistRepository,
  ) : super(TaskFormState.initial()) {
    on<TaskFormUpdateFieldsEvent>(_onUpdateFields);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<TaskFormResetEvent>(_onResetForm);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<LoadTaskFormEvent>(_onLoadTaskForm);
    on<LoadChecklistItemsEvent>(_onLoadChecklistItems);
    on<AddChecklistItemEvent>(_onAddChecklistItem);
    on<ToggleChecklistItemEvent>(_onToggleChecklistItem);
    on<DeleteChecklistItemEvent>(_onDeleteChecklistItem);
    on<EditChecklistItemEvent>(_onEditChecklistItem);
    on<UpdateChecklistItemsInternalEvent>(_onUpdateChecklistItemsInternal);
  }

  void _onResetForm(TaskFormResetEvent event, Emitter<TaskFormState> emit) {
    emit(
      state.copyWith(
        showNotification: event.showNotification ?? state.showNotification,
        closeScreen: event.closeScreen ?? state.closeScreen,
      ),
    );
  }

  void _onUpdateFields(
    TaskFormUpdateFieldsEvent event,
    Emitter<TaskFormState> emit,
  ) {
    emit(
      state.copyWith(
        title: event.title ?? state.title,
        description: event.description ?? state.description,
        status: event.status ?? state.status,
        priority: event.priority ?? state.priority,
        complexity: event.complexity ?? state.complexity,
        type: event.type ?? state.type,
        dueDate: event.dueDate ?? state.dueDate,
        dueTime: event.dueTime ?? state.dueTime,
        color: event.color ?? state.color,
      ),
    );
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TaskFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    if (state.title.isEmpty) {
      emit(
        state.copyWith(isLoading: false, titleError: 'O título é obrigatório.'),
      );
      return;
    }

    try {
      // Get the selected board ID from the service
      final boardId = getIt<BoardSelectionService>().selectedBoard?.id;
      final task = TaskModel(
        id: state.taskId,
        title: state.title,
        description: state.description,
        status: state.status,
        priority: state.priority,
        complexity: state.complexity,
        type: state.type,
        dueDate: state.dueDate,
        dueTime: state.dueTime,
        color: state.color,
        createdAt: DateTime.now(),
        boardId: boardId,
      );
      
      Outcome<dynamic, dynamic> outcome;

      if (state.taskId != null) {
        // If taskId is not null, we are updating an existing task
        outcome = await _updateTaskUseCase.execute(task);
      } else {
        // Criando nova tarefa - salvar com transação incluindo checklists
        final createOutcome = await _createTaskUseCase.execute(task);
        outcome = createOutcome;
        
        // Se temos checklists pendentes, salvar com transação
        createOutcome.when(
          success: (taskId) {
            if (taskId != null && state.checklistItems.isNotEmpty) {
              // Atualizar taskId dos itens e salvar
              final itemsToSave = state.checklistItems
                  .map((item) => item.copyWith(taskId: taskId))
                  .toList();
              
              // Salvar checklists de forma assíncrona (não bloqueante)
              _checklistRepository.createChecklistItems(itemsToSave).then((checklistOutcome) {
                checklistOutcome.when(
                  success: (_) {
                    log('Checklist items saved successfully');
                  },
                  failure: (error, message, throwable) {
                    log('Failed to save checklist items: $message');
                  },
                );
              });
            }
          },
          failure: (error, message, throwable) {
            // Não faz nada, será tratado abaixo
          },
        );
      }

      outcome.when(
        success: (result) {
          log('Action completed successfully');
          emit(
            state.copyWith(
              isLoading: false,
              showNotification: true,
              notificationType: NotificationType.success,
              notificationMessage:
                  'Tarefa ${state.taskId == null ? 'criada' : 'atualizada'} com sucesso!',
              closeScreen: true,
            ),
          );
        },
        failure: (error, message, throwable) {
          log('Failed to create task: $message');
          _handleTaskRepositoryError(createError: error, emit: emit);
        },
      );
    } catch (e) {
      log('Error creating task: $e');
      _handleTaskRepositoryError(
        createError: CreateTaskUseCaseError.genericError,
        emit: emit,
      );
    }
  }

  FutureOr<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    if (state.title.isEmpty) {
      emit(
        state.copyWith(isLoading: false, titleError: 'O título é obrigatório.'),
      );
      return;
    }

    try {
      // Get the selected board ID from the service (use existing boardId if updating)
      final boardId = state.boardId ?? getIt<BoardSelectionService>().selectedBoard?.id;
      
      final task = TaskModel(
        id: state.taskId,
        title: state.title,
        description: state.description,
        status: state.status,
        priority: state.priority,
        complexity: state.complexity,
        type: state.type,
        dueDate: state.dueDate,
        dueTime: state.dueTime,
        color: state.color,
        createdAt: DateTime.now(),
        boardId: boardId,
      );

      final outcome = await _updateTaskUseCase.execute(task);

      outcome.when(
        success: (task) {
          log('Update completed successfully');
          emit(
            state.copyWith(
              isLoading: false,
              showNotification: true,
              notificationType: NotificationType.success,
              notificationMessage: 'Tarefa atualizada com sucesso!',
              closeScreen: true,
            ),
          );
        },
        failure: (error, message, throwable) {
          log('Failed to update task: $message');
          _handleTaskRepositoryError(updateError: error, emit: emit);
        },
      );
    } catch (e) {
      log('Error to update task: $e');
      _handleTaskRepositoryError(
        updateError: UpdateTaskUseCaseError.genericError,
        emit: emit,
      );
    }
  }

  FutureOr<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      if (state.taskId == null) {
        log('Task ID is null, cannot delete task');
        _handleTaskRepositoryError(
          deleteError: DeleteTaskUseCaseError.invalidDataError,
          emit: emit,
        );
        return;
      }

      final outcome = await _deleteTaskUseCase.execute(state.taskId!);

      outcome.when(
        success: (_) {
          log('Task deleted successfully');
          emit(
            state.copyWith(
              isLoading: false,
              showNotification: true,
              notificationType: NotificationType.success,
              notificationMessage: 'Tarefa deletada com sucesso!',
              closeScreen: true,
            ),
          );
        },
        failure: (error, message, throwable) {
          log('Failed to delete task: $message');
          _handleTaskRepositoryError(
            deleteError: DeleteTaskUseCaseError.genericError,
            emit: emit,
          );
        },
      );
    } catch (e) {
      log('Error deleting task: $e');
      _handleTaskRepositoryError(
        deleteError: DeleteTaskUseCaseError.genericError,
        emit: emit,
      );
    }
  }

  FutureOr<void> _onLoadTaskForm(
    LoadTaskFormEvent event,
    Emitter<TaskFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final outcome = await _getTaskByIdUseCase.execute(event.taskId);

      outcome.when(
        success: (task) {
          log('Task loaded successfully $task');

          if (task == null) {
            log('Task not found with id: ${event.taskId}');
            _handleTaskRepositoryError(
              getError: GetTaskByIdUseCaseError.taskNotFoundError,
              emit: emit,
            );
            return;
          }

          emit(
            state.copyWith(
              isLoading: false,
              taskId: task.id,
              boardId: task.boardId,
              title: task.title,
              description: task.description ?? "",
              status: task.status,
              priority: task.priority,
              complexity: task.complexity,
              color: task.color,
              type: task.type,
              dueDate: task.dueDate,
              dueTime: task.dueTime,
            ),
          );
        },
        failure: (error, message, throwable) {
          log('Failed to load task: $message');
          _handleTaskRepositoryError(
            getError: GetTaskByIdUseCaseError.genericError,
            emit: emit,
          );
        },
      );
    } catch (e) {
      log('Error loading task: $e');
      _handleTaskRepositoryError(
        getError: GetTaskByIdUseCaseError.genericError,
        emit: emit,
      );
    }
  }

  // Checklist handlers
  Future<void> _onLoadChecklistItems(
    LoadChecklistItemsEvent event,
    Emitter<TaskFormState> emit,
  ) async {
    await _checklistSubscription?.cancel();

    // Set taskId in state
    emit(state.copyWith(taskId: event.taskId));

    _checklistSubscription = _checklistRepository
        .watchChecklistItemsByTaskId(event.taskId)
        .listen((outcome) {
      outcome.when(
        success: (items) {
          if (items == null) return;
          
          // Use add to trigger internal event instead of direct emit
          add(UpdateChecklistItemsInternalEvent(items));
        },
        failure: (error, message, throwable) {
          log('Failed to load checklist items: $message');
        },
      );
    });
  }

  Future<void> _onAddChecklistItem(
    AddChecklistItemEvent event,
    Emitter<TaskFormState> emit,
  ) async {
    if (state.checklistItemCount >= maxChecklistItems) {
      emit(state.copyWith(
        errorMessage: 'Máximo de $maxChecklistItems itens atingido',
      ));
      return;
    }

    // Se taskId é null, tarefa ainda não foi salva, adiciona à lista em memória
    if (state.taskId == null) {
      final newItem = ChecklistItemModel(
        title: event.title,
        description: event.description,
        taskId: 0, // Temporário, será atualizado ao salvar
        createdAt: DateTime.now(),
      );

      final updatedItems = [...state.checklistItems, newItem];
      emit(state.copyWith(
        checklistItems: updatedItems,
        checklistItemCount: updatedItems.length,
      ));
      return;
    }

    // Tarefa já foi salva, adiciona no banco
    final newItem = ChecklistItemModel(
      title: event.title,
      description: event.description,
      taskId: state.taskId!,
      createdAt: DateTime.now(),
    );

    // Emit optimistic add
    final updatedItems = [...state.checklistItems, newItem];
    emit(state.copyWith(
      checklistItems: updatedItems,
      checklistItemCount: updatedItems.length,
    ));

    final outcome = await _checklistRepository.createChecklistItem(newItem);

    outcome.when(
      success: (id) {
        log('Checklist item added successfully with id: $id');
        // Update item with the real ID from database
        final itemsWithId = state.checklistItems.map((item) {
          if (item.id == null && 
              item.title == newItem.title && 
              item.taskId == newItem.taskId &&
              item.createdAt == newItem.createdAt) {
            return item.copyWith(id: id);
          }
          return item;
        }).toList();
        emit(state.copyWith(checklistItems: itemsWithId));
      },
      failure: (error, message, throwable) {
        // Revert on failure
        final revertedItems = state.checklistItems
            .where((item) => item.id != null || item != newItem)
            .toList();
        emit(state.copyWith(
          checklistItems: revertedItems,
          checklistItemCount: revertedItems.length,
          errorMessage: message ?? 'Falha ao adicionar item',
        ));
      },
    );
  }

  Future<void> _onToggleChecklistItem(
    ToggleChecklistItemEvent event,
    Emitter<TaskFormState> emit,
  ) async {
    // Se taskId é null, atualiza apenas no state local usando o índice
    if (state.taskId == null) {
      final updatedItems = List<ChecklistItemModel>.from(state.checklistItems);
      if (event.index >= 0 && event.index < updatedItems.length) {
        updatedItems[event.index] = updatedItems[event.index].copyWith(
          isCompleted: !updatedItems[event.index].isCompleted,
        );
        emit(state.copyWith(checklistItems: updatedItems));
      }
      return;
    }

    final item = state.checklistItems.firstWhere(
      (item) => item.id == event.itemId,
      orElse: () => throw Exception('Item not found'),
    );

    final updatedItem = item.copyWith(
      isCompleted: !item.isCompleted,
    );

    // Emit optimistic update
    final updatedItems = state.checklistItems.map((item) {
      if (item.id == event.itemId) {
        return updatedItem;
      }
      return item;
    }).toList();
    
    emit(state.copyWith(checklistItems: updatedItems));

    final outcome = await _checklistRepository.updateChecklistItem(updatedItem);

    outcome.when(
      success: (_) {
        log('Checklist item toggled successfully');
      },
      failure: (error, message, throwable) {
        // Revert on failure
        emit(state.copyWith(
          checklistItems: state.checklistItems,
          errorMessage: message ?? 'Falha ao atualizar status',
        ));
      },
    );
  }

  Future<void> _onDeleteChecklistItem(
    DeleteChecklistItemEvent event,
    Emitter<TaskFormState> emit,
  ) async {
    // Se taskId é null, remove apenas do state local usando o índice
    if (state.taskId == null) {
      final updatedItems = List<ChecklistItemModel>.from(state.checklistItems);
      if (event.index >= 0 && event.index < updatedItems.length) {
        updatedItems.removeAt(event.index);
        emit(state.copyWith(
          checklistItems: updatedItems,
          checklistItemCount: updatedItems.length,
        ));
      }
      return;
    }

    // Emit optimistic delete
    final updatedItems = state.checklistItems
        .where((item) => item.id != event.itemId)
        .toList();
    
    emit(state.copyWith(
      checklistItems: updatedItems,
      checklistItemCount: updatedItems.length,
    ));

    final outcome = await _checklistRepository.deleteChecklistItem(event.itemId);

    outcome.when(
      success: (_) {
        log('Checklist item deleted successfully');
      },
      failure: (error, message, throwable) {
        // Revert on failure
        emit(state.copyWith(
          checklistItems: state.checklistItems,
          errorMessage: message ?? 'Falha ao deletar item',
        ));
      },
    );
  }

  Future<void> _onEditChecklistItem(
    EditChecklistItemEvent event,
    Emitter<TaskFormState> emit,
  ) async {
    // Se taskId é null, atualiza apenas no state local usando o índice
    if (state.taskId == null) {
      final updatedItems = List<ChecklistItemModel>.from(state.checklistItems);
      if (event.index >= 0 && event.index < updatedItems.length) {
        updatedItems[event.index] = updatedItems[event.index].copyWith(
          title: event.title,
          description: event.description,
          isCompleted: event.isCompleted,
        );
        emit(state.copyWith(checklistItems: updatedItems));
      }
      return;
    }

    final item = state.checklistItems.firstWhere(
      (item) => item.id == event.itemId,
      orElse: () => throw Exception('Item not found'),
    );

    final updatedItem = item.copyWith(
      title: event.title,
      description: event.description,
      isCompleted: event.isCompleted,
    );

    // Emit optimistic update
    final updatedItems = state.checklistItems.map((item) {
      if (item.id == event.itemId) {
        return updatedItem;
      }
      return item;
    }).toList();
    
    emit(state.copyWith(checklistItems: updatedItems));

    final outcome = await _checklistRepository.updateChecklistItem(updatedItem);

    outcome.when(
      success: (_) {
        log('Checklist item updated successfully');
      },
      failure: (error, message, throwable) {
        // Revert on failure
        emit(state.copyWith(
          checklistItems: state.checklistItems,
          errorMessage: message ?? 'Falha ao atualizar item',
        ));
      },
    );
  }

  @override
  Future<void> close() {
    _checklistSubscription?.cancel();
    return super.close();
  }

  void _onUpdateChecklistItemsInternal(
    UpdateChecklistItemsInternalEvent event,
    Emitter<TaskFormState> emit,
  ) {
    final items = event.items.cast<ChecklistItemModel>();
    emit(state.copyWith(
      checklistItems: items,
      checklistItemCount: items.length,
    ));
  }

  void _handleTaskRepositoryError({
    CreateTaskUseCaseError? createError,
    UpdateTaskUseCaseError? updateError,
    GetTaskByIdUseCaseError? getError,
    DeleteTaskUseCaseError? deleteError,
    required Emitter<TaskFormState> emit,
  }) {
    String message = "";
    if (createError != null) {
      switch (createError) {
        case CreateTaskUseCaseError.genericError:
          message = 'Ocorreu um erro inesperado.';
          break;
        case CreateTaskUseCaseError.invalidDataError:
          message = 'Verifique os campos e tente novamente.';
          break;
      }

      return;
    }

    if (updateError != null) {
      switch (updateError) {
        case UpdateTaskUseCaseError.genericError:
          message = 'Ocorreu um erro inesperado.';
          break;
        case UpdateTaskUseCaseError.taskNotFoundError:
          message = 'Tarefa não encontrada.';
          break;
        case UpdateTaskUseCaseError.invalidDataError:
          message = 'Verifique os campos e tente novamente.';
          break;
      }

      return;
    }

    if (getError != null) {
      switch (getError) {
        case GetTaskByIdUseCaseError.genericError:
          message = 'Ocorreu um erro inesperado.';
          break;
        case GetTaskByIdUseCaseError.taskNotFoundError:
          message = 'Tarefa não encontrada.';
          break;
      }

      return;
    }

    if (deleteError != null) {
      switch (deleteError) {
        case DeleteTaskUseCaseError.genericError:
          message = 'Ocorreu um erro inesperado.';
          break;
        case DeleteTaskUseCaseError.taskNotFoundError:
          message = 'Tarefa não encontrada.';
          break;
        case DeleteTaskUseCaseError.invalidDataError:
          message = 'Dados inválidos para deletar a tarefa.';
          break;
      }
    }
    emit(state.copyWith(isLoading: false, errorMessage: message));
  }
}
