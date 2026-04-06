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
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';
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
  final TaskRepository _taskRepository;
  StreamSubscription? _checklistSubscription;

  static const int maxChecklistItems = 50;

  TaskFormBloc(
    this._createTaskUseCase,
    this._updateTaskUseCase,
    this._getTaskByIdUseCase,
    this._deleteTaskUseCase,
    this._checklistRepository,
    this._taskRepository,
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
    // Immediate checklist events
    on<AddChecklistItemImmediateEvent>(_onAddChecklistItemImmediate);
    on<ToggleChecklistItemImmediateEvent>(_onToggleChecklistItemImmediate);
    on<DeleteChecklistItemImmediateEvent>(_onDeleteChecklistItemImmediate);
    on<EditChecklistItemImmediateEvent>(_onEditChecklistItemImmediate);
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
        hasUnsavedChanges: true,
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
      
      // Criar a tarefa
      final createOutcome = await _createTaskUseCase.execute(task);
      
      await createOutcome.when(
        success: (taskId) async {
          // Salvar checklists se houver algum
          if (taskId != null && state.checklistItems.isNotEmpty) {
            final itemsToSave = state.checklistItems
                .map((item) => item.copyWith(taskId: taskId))
                .toList();
            
            final checklistOutcome = await _checklistRepository.createChecklistItems(itemsToSave);
            
            checklistOutcome.when(
              success: (_) {
                log('Checklist items saved successfully');
              },
              failure: (error, message, throwable) {
                log('Failed to save checklist items: $message');
              },
            );
          }
          
          log('Task created successfully');
          emit(
            state.copyWith(
              isLoading: false,
              showNotification: true,
              notificationType: NotificationType.success,
              notificationMessage: 'Tarefa criada com sucesso!',
              closeScreen: true,
              hasUnsavedChanges: false,
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

      await outcome.when(
        success: (task) async {
          // Sincronizar checklists se a tarefa foi atualizada
          if (state.taskId != null) {
            // Deletar todos os checklists antigos
            await _checklistRepository.deleteAllChecklistItemsByTaskId(state.taskId!);
            
            // Criar novos checklists se houver algum
            if (state.checklistItems.isNotEmpty) {
              final itemsToSave = state.checklistItems
                  .map((item) => item.copyWith(taskId: state.taskId!))
                  .toList();
              
              final checklistOutcome = await _checklistRepository.createChecklistItems(itemsToSave);
              
              checklistOutcome.when(
                success: (_) {
                  log('Checklist items synchronized successfully');
                },
                failure: (error, message, throwable) {
                  log('Failed to synchronize checklist items: $message');
                },
              );
            }
            
            // Atualizar os stats do checklist após as operações batch
            await _taskRepository.updateTaskChecklistStats(state.taskId!);
          }
          
          log('Update completed successfully');
          emit(
            state.copyWith(
              isLoading: false,
              showNotification: true,
              notificationType: NotificationType.success,
              notificationMessage: 'Tarefa atualizada com sucesso!',
              closeScreen: true,
              hasUnsavedChanges: false,
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

      await outcome.when(
        success: (task) async {
          log('Task loaded successfully $task');

          if (task == null) {
            log('Task not found with id: ${event.taskId}');
            _handleTaskRepositoryError(
              getError: GetTaskByIdUseCaseError.taskNotFoundError,
              emit: emit,
            );
            return;
          }

          // Atualizar o state com os dados da task, mas manter loading=true
          emit(
            state.copyWith(
              isLoading: true, // Manter loading enquanto carrega checklist
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
          
          // Carregar os itens do checklist e aguardar antes de desativar loading
          if (task.id != null) {
            // Carregar checklist items de forma síncrona
            final checklistOutcome = await _checklistRepository
                .watchChecklistItemsByTaskId(task.id!)
                .first;
            
            await checklistOutcome.when(
              success: (items) async {
                if (items != null) {
                  emit(state.copyWith(
                    checklistItems: items.cast<ChecklistItemModel>(),
                    checklistItemCount: items.length,
                    isLoading: false, // Agora sim desativa loading
                  ));
                } else {
                  emit(state.copyWith(isLoading: false));
                }
              },
              failure: (error, message, throwable) {
                log('Failed to load checklist items: $message');
                emit(state.copyWith(isLoading: false));
              },
            );
            
            // Agora sim inicia o watch stream para mudanças futuras
            add(LoadChecklistItemsEvent(task.id!));
          } else {
            emit(state.copyWith(isLoading: false));
          }
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

    // Apenas adiciona ao state local - será salvo quando a tarefa for salva
    final newItem = ChecklistItemModel(
      title: event.title,
      description: event.description,
      taskId: state.taskId ?? 0, // Será atualizado ao salvar
      createdAt: DateTime.now(),
    );

    final updatedItems = [...state.checklistItems, newItem];
    emit(state.copyWith(
      checklistItems: updatedItems,
      checklistItemCount: updatedItems.length,
      hasUnsavedChanges: true,
    ));
  }

  Future<void> _onToggleChecklistItem(
    ToggleChecklistItemEvent event,
    Emitter<TaskFormState> emit,
  ) async {
    // Atualiza apenas no state local usando o índice - será salvo quando a tarefa for salva
    final updatedItems = List<ChecklistItemModel>.from(state.checklistItems);
    if (event.index >= 0 && event.index < updatedItems.length) {
      updatedItems[event.index] = updatedItems[event.index].copyWith(
        isCompleted: !updatedItems[event.index].isCompleted,
      );
      emit(state.copyWith(
        checklistItems: updatedItems,
        hasUnsavedChanges: true,
      ));
    }
  }

  Future<void> _onDeleteChecklistItem(
    DeleteChecklistItemEvent event,
    Emitter<TaskFormState> emit,
  ) async {
    // Remove apenas do state local usando o índice - será salvo quando a tarefa for salva
    final updatedItems = List<ChecklistItemModel>.from(state.checklistItems);
    if (event.index >= 0 && event.index < updatedItems.length) {
      updatedItems.removeAt(event.index);
      emit(state.copyWith(
        checklistItems: updatedItems,
        checklistItemCount: updatedItems.length,
        hasUnsavedChanges: true,
      ));
    }
  }

  Future<void> _onEditChecklistItem(
    EditChecklistItemEvent event,
    Emitter<TaskFormState> emit,
  ) async {
    // Atualiza apenas no state local usando o índice - será salvo quando a tarefa for salva
    final updatedItems = List<ChecklistItemModel>.from(state.checklistItems);
    if (event.index >= 0 && event.index < updatedItems.length) {
      updatedItems[event.index] = updatedItems[event.index].copyWith(
        title: event.title,
        description: event.description,
        isCompleted: event.isCompleted,
      );
      emit(state.copyWith(
        checklistItems: updatedItems,
        hasUnsavedChanges: true,
      ));
    }
  }

  // Immediate checklist handlers (persist to database immediately)
  Future<void> _onAddChecklistItemImmediate(
    AddChecklistItemImmediateEvent event,
    Emitter<TaskFormState> emit,
  ) async {
    if (state.checklistItemCount >= maxChecklistItems) {
      emit(state.copyWith(
        errorMessage: 'Máximo de $maxChecklistItems itens atingido',
      ));
      return;
    }

    if (state.taskId == null) {
      log('Cannot add checklist item immediately without taskId');
      return;
    }

    final newItem = ChecklistItemModel(
      title: event.title,
      description: event.description,
      taskId: state.taskId!,
      createdAt: DateTime.now(),
    );

    final outcome = await _checklistRepository.createChecklistItem(newItem);

    outcome.when(
      success: (id) {
        log('Checklist item added immediately with id: $id');
      },
      failure: (error, message, throwable) {
        log('Failed to add checklist item immediately: $message');
        emit(state.copyWith(
          errorMessage: message ?? 'Falha ao adicionar item',
        ));
      },
    );
  }

  Future<void> _onToggleChecklistItemImmediate(
    ToggleChecklistItemImmediateEvent event,
    Emitter<TaskFormState> emit,
  ) async {
    if (state.taskId == null) {
      log('Cannot toggle checklist item immediately without taskId');
      return;
    }

    final item = state.checklistItems.firstWhere(
      (item) => item.id == event.itemId,
      orElse: () {
        log('Item not found with id: ${event.itemId}');
        return ChecklistItemModel(
          title: '',
          taskId: 0,
          createdAt: DateTime.now(),
        );
      },
    );

    if (item.id == null) {
      log('Item has no id, cannot toggle');
      return;
    }

    final updatedItem = item.copyWith(
      isCompleted: !item.isCompleted,
    );

    final outcome = await _checklistRepository.updateChecklistItem(updatedItem);

    outcome.when(
      success: (_) {
        log('Checklist item toggled immediately');
      },
      failure: (error, message, throwable) {
        log('Failed to toggle checklist item immediately: $message');
        emit(state.copyWith(
          errorMessage: message ?? 'Falha ao atualizar status',
        ));
      },
    );
  }

  Future<void> _onDeleteChecklistItemImmediate(
    DeleteChecklistItemImmediateEvent event,
    Emitter<TaskFormState> emit,
  ) async {
    if (state.taskId == null) {
      log('Cannot delete checklist item immediately without taskId');
      return;
    }

    final outcome = await _checklistRepository.deleteChecklistItem(event.itemId);

    outcome.when(
      success: (_) {
        log('Checklist item deleted immediately');
      },
      failure: (error, message, throwable) {
        log('Failed to delete checklist item immediately: $message');
        emit(state.copyWith(
          errorMessage: message ?? 'Falha ao deletar item',
        ));
      },
    );
  }

  Future<void> _onEditChecklistItemImmediate(
    EditChecklistItemImmediateEvent event,
    Emitter<TaskFormState> emit,
  ) async {
    if (state.taskId == null) {
      log('Cannot edit checklist item immediately without taskId');
      return;
    }

    final item = state.checklistItems.firstWhere(
      (item) => item.id == event.itemId,
      orElse: () {
        log('Item not found with id: ${event.itemId}');
        return ChecklistItemModel(
          title: '',
          taskId: 0,
          createdAt: DateTime.now(),
        );
      },
    );

    if (item.id == null) {
      log('Item has no id, cannot edit');
      return;
    }

    final updatedItem = item.copyWith(
      title: event.title,
      description: event.description,
      isCompleted: event.isCompleted,
    );

    final outcome = await _checklistRepository.updateChecklistItem(updatedItem);

    outcome.when(
      success: (_) {
        log('Checklist item updated immediately');
      },
      failure: (error, message, throwable) {
        log('Failed to update checklist item immediately: $message');
        emit(state.copyWith(
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
