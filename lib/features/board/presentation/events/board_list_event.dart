import 'package:flutter_ikanban_app/features/board/domain/model/board_model.dart';
import 'package:flutter_ikanban_app/core/utils/result/result_page.dart';

abstract class BoardListEvent {}

class LoadBoardsEvent extends BoardListEvent {}

class LoadMoreBoardsEvent extends BoardListEvent {}

class RefreshBoardsEvent extends BoardListEvent {}

class SearchBoardsEvent extends BoardListEvent {
  final String? search;
  SearchBoardsEvent(this.search);
}

class BoardsPageDataReceived extends BoardListEvent {
  final ResultPage<BoardModel> data;
  BoardsPageDataReceived(this.data);
}

class BoardSelectedEvent extends BoardListEvent {
  final BoardModel board;
  BoardSelectedEvent(this.board);
}

class ShowCreateBoardDialogEvent extends BoardListEvent {}

class DeleteBoardEvent extends BoardListEvent {
  final String boardId;
  DeleteBoardEvent(this.boardId);
}
