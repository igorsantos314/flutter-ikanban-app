import 'package:flutter_ikanban_app/features/board/domain/model/board_model.dart';

class BoardListState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<BoardModel> boards;
  final String? errorMessage;
  final String? search;
  final int currentPage;
  final bool hasMore;
  final BoardModel? selectedBoard;
  final bool showCreateDialog;

  const BoardListState({
    required this.isLoading,
    required this.isLoadingMore,
    required this.boards,
    this.errorMessage,
    this.search,
    required this.currentPage,
    required this.hasMore,
    this.selectedBoard,
    this.showCreateDialog = false,
  });

  factory BoardListState.initial() {
    return const BoardListState(
      isLoading: false,
      isLoadingMore: false,
      boards: [],
      currentPage: 1,
      hasMore: true,
      showCreateDialog: false,
    );
  }

  BoardListState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<BoardModel>? boards,
    String? errorMessage,
    String? search,
    int? currentPage,
    bool? hasMore,
    BoardModel? selectedBoard,
    bool? showCreateDialog,
  }) {
    return BoardListState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      boards: boards ?? this.boards,
      errorMessage: errorMessage ?? this.errorMessage,
      search: search ?? this.search,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      selectedBoard: selectedBoard ?? this.selectedBoard,
      showCreateDialog: showCreateDialog ?? this.showCreateDialog,
    );
  }
}
