import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/utils/messages.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/task_repository.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/list/task_list_state.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/task_event.dart';

/// TaskListBloc com implementação senior:
/// - Stream para mudanças em tempo real (primeira página)
/// - Paginação por API para páginas adicionais
/// - Controle robusto de estado e erro
/// - Performance otimizada
class TaskListBloc extends Bloc<TaskEvent, TaskListState> {
  final TaskRepository taskRepository;

  // Stream management
  StreamSubscription? _taskStreamSubscription;

  // Pagination control
  static const int _pageSize = 20;
  bool _isLoadingTasks = false;
  bool _isLoadingMore = false;

  // Search and filter state
  String? _currentSearch;

  TaskListBloc(this.taskRepository) : super(TaskListState.initial()) {
    // Core events
    on<LoadTasksEvent>(_onLoadTasks);
    on<LoadMoreTasksEvent>(_onLoadMoreTasks);
    on<RefreshTasksEvent>(_onRefreshTasks);
    on<SearchTasksEvent>(_onSearchTasks);

    // Data handling events
    on<TasksStreamDataReceived>(_onTasksStreamDataReceived);
    on<TasksPageDataReceived>(_onTasksPageDataReceived);

    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
    on<TaskSelectedEvent>(_onTaskSelected);

    // UI events
    on<TaskFormResetEvent>(_onTaskFormReset);
    on<TaskListUpdateStatus>(_onTaskListUpdateStatus);
    on<TaskListUpdateStatusFilter>(_onTaskListUpdateStatusFilter);
  }

  @override
  Future<void> close() {
    _taskStreamSubscription?.cancel();
    return super.close();
  }

  /// Carrega primeira página + inicia stream para mudanças em tempo real
  void _onLoadTasks(LoadTasksEvent event, Emitter<TaskListState> emit) {
    log('[TaskListBloc] Loading initial tasks...');

    // Evita múltiplas chamadas simultâneas
    if (_isLoadingTasks) {
      log('[TaskListBloc] Already loading, skipping...');
      return;
    }

    _isLoadingTasks = true;
    emit(
      state.copyWith(
        isLoading: true,
        hasError: false,
        errorMessage: '',
        currentPage: 1,
      ),
    );

    // Cancela stream anterior se existir
    _taskStreamSubscription?.cancel();

    // Inicia stream para primeira página (observa mudanças em tempo real)
    _taskStreamSubscription = taskRepository
        .watchTasks(
          page: 1,
          limitPerPage: _pageSize,
          search: _currentSearch,
          onlyActive: true,
          ascending: false, // Mais recentes primeiro
        )
        .listen(
          (outcome) {
            log('[TaskListBloc] Stream data received');
            add(TasksStreamDataReceived(outcome));
          },
          onError: (error, stackTrace) {
            log(
              '[TaskListBloc] Stream error: $error',
              error: error,
              stackTrace: stackTrace,
            );
            // Nota: Como não temos construtor failure direto, vamos tratar no handler
            if (!isClosed) {
              emit(
                state.copyWith(
                  isLoading: false,
                  hasError: true,
                  errorMessage: 'Erro no stream de dados',
                  showNotification: true,
                  notificationMessage: 'Erro de conexão',
                  notificationType: NotificationType.error,
                ),
              );
              _isLoadingTasks = false;
            }
          },
          onDone: () {
            log('[TaskListBloc] Stream completed');
            _isLoadingTasks = false;
          },
        );
  }

  /// Carrega mais páginas (sem stream - apenas API call)
  void _onLoadMoreTasks(
    LoadMoreTasksEvent event,
    Emitter<TaskListState> emit,
  ) async {
    log('[TaskListBloc] Loading more tasks...');

    // Validações
    if (_isLoadingMore || !state.hasMorePages || state.isLoading) {
      log(
        '[TaskListBloc] Cannot load more: isLoadingMore=$_isLoadingMore, hasMorePages=${state.hasMorePages}, isLoading=${state.isLoading}',
      );
      return;
    }

    _isLoadingMore = true;
    final nextPage = state.currentPage + 1;

    emit(state.copyWith(isLoadingMore: true));

    try {
      // Usa método direto do repository (não stream) para paginação
      final stream = taskRepository.watchTasks(
        page: nextPage,
        limitPerPage: _pageSize,
        search: _currentSearch,
        onlyActive: true,
        ascending: false,
      );

      // Pega apenas o primeiro resultado do stream (single call)
      final outcome = await stream.first;

      add(TasksPageDataReceived(outcome, nextPage));
    } catch (e, stackTrace) {
      log(
        '[TaskListBloc] Error loading more tasks: $e',
        error: e,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          isLoadingMore: false,
          hasError: true,
          errorMessage: 'Erro ao carregar mais tarefas',
          showNotification: true,
          notificationMessage: 'Erro ao carregar mais tarefas',
          notificationType: NotificationType.error,
        ),
      );
      _isLoadingMore = false;
    }
  }

  /// Refresh completo - reinicia tudo
  void _onRefreshTasks(RefreshTasksEvent event, Emitter<TaskListState> emit) {
    log('[TaskListBloc] Refreshing tasks...');

    // Reset completo do estado
    _taskStreamSubscription?.cancel();
    _taskStreamSubscription = null;
    _isLoadingTasks = false;
    _isLoadingMore = false;

    // Limpa estado e recarrega
    emit(TaskListState.initial().copyWith(searchQuery: _currentSearch ?? ''));

    add(const LoadTasksEvent());
  }

  /// Busca com filtro
  void _onSearchTasks(SearchTasksEvent event, Emitter<TaskListState> emit) {
    log('[TaskListBloc] Searching tasks: "${event.query}"');

    _currentSearch = event.query.isEmpty ? null : event.query;

    emit(state.copyWith(searchQuery: event.query));

    // Reinicia busca com novo filtro
    add(const RefreshTasksEvent());
  }

  /// Processa dados do stream (primeira página + mudanças em tempo real)
  void _onTasksStreamDataReceived(
    TasksStreamDataReceived event,
    Emitter<TaskListState> emit,
  ) {
    log('[TaskListBloc] Processing stream data...');

    final outcome = event.outcome as Outcome;

    outcome.when(
      success: (resultPage) {
        if (resultPage == null) {
          log('[TaskListBloc] Received null result page');
          emit(
            state.copyWith(
              isLoading: false,
              hasError: false,
              tasks: [],
              hasMorePages: false,
            ),
          );
          _isLoadingTasks = false;
          return;
        }

        final newTasks = resultPage.items ?? [];
        log('[TaskListBloc] Stream loaded ${newTasks.length} tasks for page 1');

        // Para stream data: substitui apenas os itens da primeira página
        // Mantém itens das páginas 2+ se existirem
        final existingTasksFromOtherPages = state.tasks.length > _pageSize
            ? state.tasks.skip(_pageSize).toList()
            : <TaskModel>[];

        final updatedTasks = <TaskModel>[
          ...newTasks,
          ...existingTasksFromOtherPages,
        ];
        final hasMore = newTasks.length >= _pageSize;

        emit(
          state.copyWith(
            tasks: updatedTasks,
            isLoading: false,
            hasError: false,
            errorMessage: '',
            hasMorePages: hasMore,
            currentPage: 1,
          ),
        );

        _isLoadingTasks = false;
      },
      failure: (error, message, throwable) {
        log('[TaskListBloc] Stream error: $error, message: $message');

        emit(
          state.copyWith(
            isLoading: false,
            hasError: true,
            errorMessage: message ?? 'Erro ao carregar tarefas',
            showNotification: true,
            notificationMessage:
                message ?? 'Não foi possível carregar as tarefas',
            notificationType: NotificationType.error,
          ),
        );

        _isLoadingTasks = false;
      },
    );
  }

  /// Processa dados da paginação (páginas 2+)
  void _onTasksPageDataReceived(
    TasksPageDataReceived event,
    Emitter<TaskListState> emit,
  ) {
    log('[TaskListBloc] Processing page data for page ${event.page}...');

    final outcome = event.outcome as Outcome;

    outcome.when(
      success: (resultPage) {
        if (resultPage == null) {
          log(
            '[TaskListBloc] Received null result page for page ${event.page}',
          );
          emit(state.copyWith(isLoadingMore: false, hasMorePages: false));
          _isLoadingMore = false;
          return;
        }

        final newTasks = resultPage.items ?? [];
        log(
          '[TaskListBloc] Page ${event.page} loaded ${newTasks.length} tasks',
        );

        // Adiciona novos itens à lista existente
        final updatedTasks = <TaskModel>[...state.tasks, ...newTasks];
        final hasMore = newTasks.length >= _pageSize;

        emit(
          state.copyWith(
            tasks: updatedTasks,
            isLoadingMore: false,
            hasMorePages: hasMore,
            currentPage: event.page,
            hasError: false,
          ),
        );

        _isLoadingMore = false;
      },
      failure: (error, message, throwable) {
        log(
          '[TaskListBloc] Page ${event.page} error: $error, message: $message',
        );

        emit(
          state.copyWith(
            isLoadingMore: false,
            hasError: true,
            errorMessage: message ?? 'Erro ao carregar mais tarefas',
            showNotification: true,
            notificationMessage: message ?? 'Erro ao carregar mais tarefas',
            notificationType: NotificationType.error,
          ),
        );

        _isLoadingMore = false;
      },
    );
  }

  /// Reset de notificações e outros estados da UI
  void _onTaskFormReset(TaskFormResetEvent event, Emitter<TaskListState> emit) {
    emit(
      state.copyWith(
        showNotification: event.showNotification ?? state.showNotification,
        showStatusSelector:
            event.showStatusSelector ?? state.showStatusSelector,
      ),
    );
  }

  /// Métodos utilitários para debugging e monitoramento
  void logCurrentState() {
    log('[TaskListBloc] Current State:');
    log('  - Tasks: ${state.tasks.length}');
    log('  - Current Page: ${state.currentPage}');
    log('  - Has More: ${state.hasMorePages}');
    log('  - Loading: ${state.isLoading}');
    log('  - Loading More: ${state.isLoadingMore}');
    log('  - Search: "${state.searchQuery}"');
    log('  - Has Error: ${state.hasError}');
  }

  FutureOr<void> _onToggleTaskCompletion(
    ToggleTaskCompletion event,
    Emitter<TaskListState> emit,
  ) async {
    final task = state.tasks.firstWhere((t) => t.id == event.id);
    final updatedStatus = task.status == TaskStatus.done
        ? TaskStatus.todo
        : TaskStatus.done;
    final updatedTask = task.copyWith(status: updatedStatus);

    // Atualiza no repositório
    var outcome = await taskRepository.updateTask(updatedTask);

    outcome.when(
      success: (_) {
        // Atualiza localmente o estado
        final updatedTasks = state.tasks
            .map((t) => t.id == updatedTask.id ? updatedTask : t)
            .toList();
        emit(state.copyWith(tasks: updatedTasks));
      },
      failure: (error, message, throwable) {
        log(
          '[TaskListBloc] Error toggling task completion: $error, message: $message',
        );
        emit(
          state.copyWith(
            showNotification: true,
            notificationMessage: message ?? 'Erro ao atualizar tarefa',
            notificationType: NotificationType.error,
          ),
        );
      },
    );

    log('[TaskListBloc] Toggled task ${task.id} to status $updatedStatus');
  }

  FutureOr<void> _onTaskSelected(
    TaskSelectedEvent event,
    Emitter<TaskListState> emit,
  ) {
    emit(state.copyWith(selectedTask: event.task, showStatusSelector: true));
  }

  FutureOr<void> _onTaskListUpdateStatus(
    TaskListUpdateStatus event,
    Emitter<TaskListState> emit,
  ) async {
    final task = state.selectedTask;
    if (task == null) return;

    final updatedTask = task.copyWith(status: event.status);

    // Atualiza no repositório
    await taskRepository.updateTask(updatedTask).then((outcome) {
      outcome.when(
        success: (_) {
          // Atualiza localmente o estado
          final updatedTasks = state.tasks
              .map((t) => t.id == updatedTask.id ? updatedTask : t)
              .toList();
          emit(
            state.copyWith(
              tasks: updatedTasks,
              selectedTask: null,
              showStatusSelector: false,
            ),
          );
        },
        failure: (error, message, throwable) {
          log(
            '[TaskListBloc] Error updating task status: $error, message: $message',
          );
          emit(
            state.copyWith(
              showNotification: true,
              notificationMessage: message ?? 'Erro ao atualizar tarefa',
              notificationType: NotificationType.error,
              showStatusSelector: false,
            ),
          );
        },
      );
    });
  }

  FutureOr<void> _onTaskListUpdateStatusFilter(
    TaskListUpdateStatusFilter event,
    Emitter<TaskListState> emit,
  ) {
    emit(state.copyWith(statusFilter: event.statusFilter));
  }
}
