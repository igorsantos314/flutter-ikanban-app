import 'package:flutter_ikanban_app/features/board/domain/model/board_model.dart';

class BoardSelectionService {
  BoardModel? _selectedBoard;

  BoardModel? get selectedBoard => _selectedBoard;

  void selectBoard(BoardModel board) {
    _selectedBoard = board;
  }

  void clearSelection() {
    _selectedBoard = null;
  }

  String get selectedBoardName => _selectedBoard?.title ?? 'Tarefas';
}
