import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/board/domain/use_cases/delete_board_use_case.dart';
import 'package:flutter_ikanban_app/features/board/domain/use_cases/list_board_use_case.dart';
import 'package:flutter_ikanban_app/features/board/presentation/events/board_list_event.dart';
import 'package:flutter_ikanban_app/features/board/presentation/states/board_list_state.dart';

class BoardListBloc extends Bloc<BoardListEvent, BoardListState> {
  final ListBoardUseCase _listBoardUseCase;
  final DeleteBoardUseCase _deleteBoardUseCase;

  StreamSubscription? _boardStreamSubscription;

  static const int _pageSize = 20;
  bool _isLoadingBoards = false;
  bool _isLoadingMore = false;

  String? _currentSearch;

  BoardListBloc(this._listBoardUseCase, this._deleteBoardUseCase) : super(BoardListState.initial()) {
    on<LoadBoardsEvent>(_onLoadBoards);
    on<LoadMoreBoardsEvent>(_onLoadMoreBoards);
    on<RefreshBoardsEvent>(_onRefreshBoards);
    on<SearchBoardsEvent>(_onSearchBoards);
    on<BoardsPageDataReceived>(_onBoardsPageDataReceived);
    on<BoardSelectedEvent>(_onBoardSelected);
    on<ShowCreateBoardDialogEvent>(_onShowCreateBoardDialog);
    on<DeleteBoardEvent>(_onDeleteBoard);
  }

  @override
  Future<void> close() {
    _boardStreamSubscription?.cancel();
    return super.close();
  }

  FutureOr<void> _onLoadBoards(
    LoadBoardsEvent event,
    Emitter<BoardListState> emit,
  ) async {
    log('[BoardListBloc] Loading initial boards...');

    if (_isLoadingBoards) {
      log('[BoardListBloc] Already loading, skipping...');
      return;
    }

    _isLoadingBoards = true;
    emit(state.copyWith(isLoading: true, currentPage: 1));

    await _boardStreamSubscription?.cancel();

    final stream = _listBoardUseCase.execute(
      page: 1,
      limitPerPage: _pageSize,
      search: _currentSearch,
      onlyActive: true,
    );

    _boardStreamSubscription = stream.listen(
      (outcome) {
        outcome.when(
          success: (resultPage) {
            add(BoardsPageDataReceived(resultPage!));
          },
          failure: (error, message, throwable) {
            log('[BoardListBloc] Error loading boards: $message');
            emit(state.copyWith(
              isLoading: false,
              errorMessage: 'Erro ao carregar quadros',
            ));
            _isLoadingBoards = false;
          },
        );
      },
      onError: (error) {
        log('[BoardListBloc] Stream error: $error');
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Erro ao carregar quadros',
        ));
        _isLoadingBoards = false;
      },
    );
  }

  FutureOr<void> _onBoardsPageDataReceived(
    BoardsPageDataReceived event,
    Emitter<BoardListState> emit,
  ) {
    log('[BoardListBloc] Received ${event.data.items.length} boards');

    final hasMore = event.data.items.length >= _pageSize;

    emit(state.copyWith(
      boards: event.data.items,
      isLoading: false,
      isLoadingMore: false,
      hasMore: hasMore,
    ));

    _isLoadingBoards = false;
    _isLoadingMore = false;
  }

  FutureOr<void> _onLoadMoreBoards(
    LoadMoreBoardsEvent event,
    Emitter<BoardListState> emit,
  ) async {
    if (_isLoadingMore || !state.hasMore) {
      log('[BoardListBloc] Cannot load more: loading=$_isLoadingMore, hasMore=${state.hasMore}');
      return;
    }

    _isLoadingMore = true;
    final nextPage = state.currentPage + 1;
    emit(state.copyWith(isLoadingMore: true, currentPage: nextPage));

    final stream = _listBoardUseCase.execute(
      page: nextPage,
      limitPerPage: _pageSize,
      search: _currentSearch,
      onlyActive: true,
    );

    await for (final outcome in stream) {
      outcome.when(
        success: (resultPage) {
          if (resultPage == null) return;
          final updatedBoards = [...state.boards, ...resultPage.items];
          final hasMore = resultPage.items.length >= _pageSize;

          emit(state.copyWith(
            boards: updatedBoards,
            isLoadingMore: false,
            hasMore: hasMore,
          ));
          _isLoadingMore = false;
          return;
        },
        failure: (error, message, throwable) {
          log('[BoardListBloc] Error loading more boards: $message');
          emit(state.copyWith(isLoadingMore: false));
          _isLoadingMore = false;
          return;
        },
      );
    }
  }

  FutureOr<void> _onRefreshBoards(
    RefreshBoardsEvent event,
    Emitter<BoardListState> emit,
  ) {
    log('[BoardListBloc] Refreshing boards...');
    _isLoadingBoards = false;
    _isLoadingMore = false;
    add(LoadBoardsEvent());
  }

  FutureOr<void> _onSearchBoards(
    SearchBoardsEvent event,
    Emitter<BoardListState> emit,
  ) {
    log('[BoardListBloc] Searching boards: ${event.search}');
    _currentSearch = event.search;
    _isLoadingBoards = false;
    _isLoadingMore = false;
    add(LoadBoardsEvent());
  }

  FutureOr<void> _onBoardSelected(
    BoardSelectedEvent event,
    Emitter<BoardListState> emit,
  ) {
    log('[BoardListBloc] Board selected: ${event.board.title}');
    emit(state.copyWith(selectedBoard: event.board));
  }

  FutureOr<void> _onShowCreateBoardDialog(
    ShowCreateBoardDialogEvent event,
    Emitter<BoardListState> emit,
  ) {
    emit(state.copyWith(showCreateDialog: true));
  }

  FutureOr<void> _onDeleteBoard(
    DeleteBoardEvent event,
    Emitter<BoardListState> emit,
  ) async {
    log('[BoardListBloc] Deleting board: ${event.boardId}');
    
    emit(state.copyWith(isLoading: true));
    
    final result = await _deleteBoardUseCase.execute(event.boardId);
    
    result.when(
      success: (_) {
        log('[BoardListBloc] Board deleted successfully');
        // Refresh the list after deletion
        add(RefreshBoardsEvent());
      },
      failure: (error, message, throwable) {
        log('[BoardListBloc] Error deleting board: $message');
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Erro ao excluir quadro',
        ));
      },
    );
  }
}
