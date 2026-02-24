import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/domain/usecases/get_layout_mode_preferences.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/domain/usecases/get_task_list_status_preferences_use_case.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/domain/usecases/get_task_list_type_filter_preferences.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/domain/usecases/set_layout_mode_preferences.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/domain/usecases/set_task_list_status_preferences_use_case.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/domain/usecases/set_task_list_type_filter_preferences.dart';
import 'package:flutter_ikanban_app/core/di/app_locator.dart';
import 'package:flutter_ikanban_app/core/utils/messages.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/board/domain/services/board_selection_service.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_sort.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/domain/use_cases/list_task_use_case.dart';
import 'package:flutter_ikanban_app/features/task/domain/use_cases/update_task_use_case.dart';
import 'package:flutter_ikanban_app/features/task/presentation/enums/task_layout.dart';
import 'package:flutter_ikanban_app/features/task/presentation/events/form/task_form_events.dart';
import 'package:flutter_ikanban_app/features/task/presentation/events/list/task_list_events.dart';
import 'package:flutter_ikanban_app/features/task/presentation/events/shared/task_shared_events.dart';
import 'package:flutter_ikanban_app/features/task/presentation/extensions/task_status_enum_extensions.dart';
import 'package:flutter_ikanban_app/features/task/presentation/states/list/task_list_state.dart';

class TaskListBloc extends Bloc<TaskEvent, TaskListState> {
  final UpdateTaskUseCase _updateTaskUseCase;
  final ListTaskUseCase _listTaskUseCase;

  final SetTaskListStatusPreferencesUseCase _setStatusPreferencesUseCase;
  final GetTaskListStatusPreferencesUseCase _getStatusUseCase;
  final SetTaskListTypeFilterPreferencesUsecase
  _setTypeFilterPreferencesUsecase;
  final GetTaskListTypeFilterPreferencesUsecase
  _getTypeFilterPreferencesUsecase;
  final SetLayoutModePreferencesUseCase _setLayoutModePreferencesUsecase;
  final GetLayoutModePreferencesUseCase _getLayoutModePreferencesUsecase;

  // Stream management
  StreamSubscription? _taskStreamSubscription;

  // Pagination control
  static const int _pageSize = 20;
  bool _isLoadingTasks = false;
  bool _isLoadingMore = false;

  // Search and filter state
  String? _currentSearch;

  TaskListBloc(
    this._updateTaskUseCase,
    this._listTaskUseCase,
    this._setStatusPreferencesUseCase,
    this._getStatusUseCase,
    this._setTypeFilterPreferencesUsecase,
    this._getTypeFilterPreferencesUsecase,
    this._setLayoutModePreferencesUsecase,
    this._getLayoutModePreferencesUsecase,
  ) : super(TaskListState.initial()) {
    // Core events
    on<LoadTasksEvent>(_onLoadTasks);
    on<LoadMoreTasksEvent>(_onLoadMoreTasks);
    on<RefreshTasksEvent>(_onRefreshTasks);
    on<SearchTasksEvent>(_onSearchTasks);

    // Data handling events
    on<TasksPageDataReceived>(_onTasksPageDataReceived);

    on<ToggleTaskCompletionEvent>(_onToggleTaskCompletion);
    on<TaskSelectedEvent>(_onTaskSelected);

    // UI events
    on<TaskFormResetEvent>(_onTaskFormReset);
    on<TaskListUpdateStatus>(_onTaskListUpdateStatus);
    on<TaskListUpdateStatusFilterEvent>(_onTaskListUpdateStatusFilter);
    on<ToggleLayoutModeEvent>(_onToggleLayoutMode);
    on<FilterTasksClickEvent>(_onFilterTasksClick);
    on<FilterTasksApplyEvent>(_onFilterTasksApply);
    on<SortTasksClickEvent>(_onSortTasksClick);
    on<ApplySortEvent>(_onApplySort);
    on<ShowTaskDetailsEvent>(_onShowTaskDetails);

    on<WatchTaskListEditsEvent>(_globalTaskListObserver);
    on<WatchTaskListDataReceivedEvent>(_updateTasks);
  }

  @override
  Future<void> close() {
    _taskStreamSubscription?.cancel();
    return super.close();
  }

  FutureOr<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskListState> emit,
  ) async {
    log('[TaskListBloc] Loading initial tasks...');

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

    await _loadPreferences(emit);

    final int boardId = state.boardId ?? getIt<BoardSelectionService>().selectedBoard?.id ?? -1;

    final tasks = await _listTaskUseCase
        .execute(
          boardId: boardId,
          page: 1,
          limitPerPage: _pageSize,
          search: _currentSearch,
          status: state.statusFilter == TaskStatus.all
              ? null
              : state.statusFilter,
          type: state.typeFilters.isNotEmpty ? state.typeFilters : null,
          onlyActive: true,
          orderBy: state.sortBy,
          ascending: state.sortOrder == SortOrder.ascending,
        )
        .first;

    tasks.when(
      success: (resultPage) {
        if (resultPage == null) {
          log('[TaskListBloc] Received null result page');
          emit(
            state.copyWith(
              boardId: boardId,
              isLoading: false,
              hasError: false,
              tasks: [],
              hasMorePages: false,
            ),
          );
          _isLoadingTasks = false;
          return;
        }

        final newTasks = resultPage.items;
        log('[TaskListBloc] Stream loaded ${newTasks.length} tasks for page 1');

        // Se já temos tarefas carregadas de outras páginas, atualizar apenas a página 1
        final updatedTasks = <TaskModel>[];
        if (state.tasks.length > _pageSize) {
          // Substituir apenas os itens da página 1, manter o resto
          updatedTasks.addAll(newTasks);
          updatedTasks.addAll(state.tasks.skip(_pageSize));
        } else {
          // Primeira carga ou refresh completo
          updatedTasks.addAll(newTasks);
        }

        final hasMore = resultPage.totalPages > 1;

        emit(
          state.copyWith(
            tasks: updatedTasks,
            isLoading: false,
            hasError: false,
            errorMessage: '',
            hasMorePages: hasMore,
            currentPage: state.currentPage > resultPage.totalPages
                ? 1
                : state.currentPage,
          ),
        );

        _isLoadingTasks = false;
        add(const WatchTaskListEditsEvent());
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

  FutureOr<void> _globalTaskListObserver(
    WatchTaskListEditsEvent event,
    Emitter<TaskListState> emit,
  ) {
    final int boardId = state.boardId ?? getIt<BoardSelectionService>().selectedBoard?.id ?? -1;

    _taskStreamSubscription?.cancel();
    final stream = _listTaskUseCase.execute(
      boardId: boardId,
      page: 1,
      limitPerPage: state.currentPage * _pageSize,
      search: _currentSearch,
      status: state.statusFilter == TaskStatus.all ? null : state.statusFilter,
      type: state.typeFilters.isNotEmpty ? state.typeFilters : null,
      onlyActive: true,
      orderBy: state.sortBy,
      ascending: state.sortOrder == SortOrder.ascending,
    );

    _taskStreamSubscription = stream.listen((event) {
      add(WatchTaskListDataReceivedEvent(event));
    });
  }

  FutureOr<void> _updateTasks(
    WatchTaskListDataReceivedEvent event,
    Emitter<TaskListState> emit,
  ) {
    final outcome = event.outcome as Outcome;
    outcome.when(
      success: (resultPage) {
        if (resultPage == null) return;

        final newTasks = resultPage.items;
        emit(state.copyWith(tasks: newTasks));

        log(
          '[TaskListBloc] [Global Observer] Loaded ${newTasks.length} tasks for page 1',
        );
      },
      failure: (error, message, throwable) {
        log(
          '[TaskListBloc] [Global Observer] Error: $error, message: $message',
        );
      },
    );
  }

  FutureOr<void> _loadPreferences(Emitter<TaskListState> emit) async {
    final statusOutcome = await _getStatusUseCase.execute();
    statusOutcome.when(
      success: (status) {
        log('[TaskListBloc] Loaded status preference: $status');
        if (status != null) {
          emit(state.copyWith(statusFilter: status));
        }
      },
      failure: (error, message, throwable) {
        log(
          '[TaskListBloc] Error loading status preference: $error, message: $message',
        );
      },
    );

    final typeOutcome = await _getTypeFilterPreferencesUsecase.execute();
    typeOutcome.when(
      success: (types) {
        log('[TaskListBloc] Loaded type filter preferences: $types');
        if (types != null) {
          emit(state.copyWith(typeFilters: types));
        }
      },
      failure: (error, message, throwable) {
        log(
          '[TaskListBloc] Error loading type filter preferences: $error, message: $message',
        );
      },
    );

    final layoutOutcome = await _getLayoutModePreferencesUsecase.execute();
    layoutOutcome.when(
      success: (layout) {
        log('[TaskListBloc] Loaded layout mode preference: $layout');
        if (layout != null) {
          emit(state.copyWith(layoutMode: layout));
        }
      },
      failure: (error, message, throwable) {
        log(
          '[TaskListBloc] Error loading layout mode preference: $error, message: $message',
        );
      },
    );
  }

  void _onLoadMoreTasks(
    LoadMoreTasksEvent event,
    Emitter<TaskListState> emit,
  ) async {
    log('[TaskListBloc] Loading more tasks...');

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
      int boardId = state.boardId ?? getIt<BoardSelectionService>().selectedBoard?.id ?? -1;
      final stream = _listTaskUseCase.execute(
        boardId: boardId,
        page: nextPage,
        limitPerPage: _pageSize,
        search: _currentSearch,
        status: state.statusFilter == TaskStatus.all
            ? null
            : state.statusFilter,
        type: state.typeFilters.isNotEmpty ? state.typeFilters : null,
        onlyActive: true,
        orderBy: state.sortBy,
        ascending: state.sortOrder == SortOrder.ascending,
      );
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

  void _onRefreshTasks(RefreshTasksEvent event, Emitter<TaskListState> emit) {
    log('[TaskListBloc] Refreshing tasks...');

    _taskStreamSubscription?.cancel();
    _taskStreamSubscription = null;
    _isLoadingTasks = false;
    _isLoadingMore = false;

    emit(TaskListState.initial().copyWith(searchQuery: _currentSearch ?? ''));

    add(const LoadTasksEvent());
  }

  void _onSearchTasks(SearchTasksEvent event, Emitter<TaskListState> emit) {
    log('[TaskListBloc] Searching tasks: "${event.query}"');

    _currentSearch = event.query.isEmpty ? null : event.query;
    emit(state.copyWith(searchQuery: event.query));

    add(const LoadTasksEvent());
  }

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
        add(WatchTaskListEditsEvent());
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

  void _onTaskFormReset(TaskFormResetEvent event, Emitter<TaskListState> emit) {
    emit(
      state.copyWith(
        showNotification: event.showNotification ?? state.showNotification,
        showStatusSelector:
            event.showStatusSelector ?? state.showStatusSelector,
        showFilterOptions: event.showFilterOptions ?? state.showFilterOptions,
        showSortOptions: event.showSortOptions ?? state.showSortOptions,
        showTaskDetails: event.showTaskDetails ?? state.showTaskDetails,
      ),
    );
  }

  FutureOr<void> _onToggleTaskCompletion(
    ToggleTaskCompletionEvent event,
    Emitter<TaskListState> emit,
  ) async {
    final task = state.tasks.firstWhere((t) => t.id == event.id);
    final updatedStatus = task.status == TaskStatus.done
        ? TaskStatus.todo
        : TaskStatus.done;
    final updatedTask = task.copyWith(status: updatedStatus);

    var outcome = await _updateTaskUseCase.execute(updatedTask);

    outcome.when(
      success: (_) {
        emit(
          state.copyWith(
            notificationType: NotificationType.success,
            showNotification: true,
            notificationMessage:
                'Tarefa marcada como ${updatedStatus.displayName}',
          ),
        );
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

    await _updateTaskUseCase.execute(updatedTask).then((outcome) {
      outcome.when(
        success: (_) {
          emit(state.copyWith(selectedTask: null, showStatusSelector: false));
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
    TaskListUpdateStatusFilterEvent event,
    Emitter<TaskListState> emit,
  ) async {
    emit(state.copyWith(statusFilter: event.status));
    final result = await _setStatusPreferencesUseCase.execute(event.status);

    result.when(
      success: (_) {
        log('[TaskListBloc] Task status filter saved successfully');
      },
      failure: (error, message, throwable) {
        log(
          '[TaskListBloc] Error saving task status filter: $error, message: $message',
        );
      },
    );

    add(const LoadTasksEvent());
  }

  FutureOr<void> _onToggleLayoutMode(
    ToggleLayoutModeEvent event,
    Emitter<TaskListState> emit,
  ) async {
    final newLayout = state.layoutMode == TaskLayout.list
        ? TaskLayout.grid
        : TaskLayout.list;

    emit(state.copyWith(layoutMode: newLayout));

    final result = await _setLayoutModePreferencesUsecase.execute(newLayout);

    result.when(
      success: (_) {
        log('[TaskListBloc] Layout mode preference saved successfully');
      },
      failure: (error, message, throwable) {
        log(
          '[TaskListBloc] Error saving layout mode preference: $error, message: $message',
        );
      },
    );
  }

  FutureOr<void> _onFilterTasksClick(
    FilterTasksClickEvent event,
    Emitter<TaskListState> emit,
  ) {
    emit(state.copyWith(showFilterOptions: true));
  }

  FutureOr<void> _onFilterTasksApply(
    FilterTasksApplyEvent event,
    Emitter<TaskListState> emit,
  ) async {
    emit(state.copyWith(typeFilters: event.selectedTypes));
    final result = await _setTypeFilterPreferencesUsecase.call(
      event.selectedTypes,
    );

    result.when(
      success: (_) {
        log('[TaskListBloc] Task type filters saved successfully');
      },
      failure: (error, message, throwable) {
        log(
          '[TaskListBloc] Error saving task type filters: $error, message: $message',
        );
      },
    );

    add(const LoadTasksEvent());
  }

  FutureOr<void> _onSortTasksClick(
    SortTasksClickEvent event,
    Emitter<TaskListState> emit,
  ) {
    emit(state.copyWith(showSortOptions: true));
  }

  FutureOr<void> _onApplySort(
    ApplySortEvent event,
    Emitter<TaskListState> emit,
  ) {
    emit(
      state.copyWith(
        sortBy: event.sortBy,
        sortOrder: event.sortOrder,
        showSortOptions: false,
      ),
    );

    add(const LoadTasksEvent());
  }

  FutureOr<void> _onShowTaskDetails(
    ShowTaskDetailsEvent event,
    Emitter<TaskListState> emit,
  ) {
    emit(state.copyWith(selectedTask: event.task, showTaskDetails: true));
  }
}
