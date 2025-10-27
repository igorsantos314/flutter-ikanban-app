import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/core/utils/result/result_page.dart';
import 'package:flutter_ikanban_app/features/board/domain/errors/board_repository_errors.dart';
import 'package:flutter_ikanban_app/features/board/domain/model/board_model.dart';

abstract class BoardRepository {
  Stream<Outcome<ResultPage<BoardModel>, BoardRepositoryErrors>> watchBoards({
    required int page,
    required int limitPerPage,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
    String? orderBy,
    bool onlyActive = true,
    bool ascending = true,
  });
  Future<Outcome<ResultPage<BoardModel>, BoardRepositoryErrors>> getBoards({
    required int page,
    required int limitPerPage,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
    String? orderBy,
    bool onlyActive = true,
    bool ascending = true,
  });
  Future<Outcome<void, BoardRepositoryErrors>> createBoard(BoardModel board);
  Future<Outcome<void, BoardRepositoryErrors>> updateBoard(BoardModel board);
  Future<Outcome<void, BoardRepositoryErrors>> deleteBoard(String id);
  Future<Outcome<BoardModel, BoardRepositoryErrors>> getBoardById(String boardId);
}
