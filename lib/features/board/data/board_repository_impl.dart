import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/core/utils/result/result_page.dart';
import 'package:flutter_ikanban_app/features/board/domain/errors/board_repository_errors.dart';
import 'package:flutter_ikanban_app/features/board/domain/model/board_model.dart';
import 'package:flutter_ikanban_app/features/board/domain/repository/board_repository.dart';
import 'package:flutter_ikanban_app/features/board/infra/local/board_local_data_source.dart';
import 'package:flutter_ikanban_app/features/board/infra/local/mapper/board_mapper.dart';

class BoardRepositoryImpl implements BoardRepository {
  final BoardLocalDataSource _localDataSource;
  
  BoardRepositoryImpl(this._localDataSource);

  @override
  Future<Outcome<void, BoardRepositoryErrors>> createBoard(BoardModel board) async {
    try {
      final entity = BoardMapper.toEntity(board);
      await _localDataSource.insertBoard(entity);
      return const Outcome.success();
    } catch (e) {
      return Outcome.failure(
        error: const BoardRepositoryErrors.genericError(),
        message: 'Failed to create board',
        throwable: e,
      );
    }
  }

  @override
  Future<Outcome<void, BoardRepositoryErrors>> deleteBoard(String id) async {
    try {
      await _localDataSource.deleteBoard(int.parse(id));
      return const Outcome.success();
    } catch (e) {
      return Outcome.failure(
        error: const BoardRepositoryErrors.genericError(),
        message: 'Failed to delete board',
        throwable: e,
      );
    }
  }

  @override
  Future<Outcome<void, BoardRepositoryErrors>> deleteAllBoards() async {
    try {
      await _localDataSource.deleteAllBoards();
      await _localDataSource.resetAutoIncrement();
      return const Outcome.success();
    } catch (e) {
      return Outcome.failure(
        error: const BoardRepositoryErrors.genericError(),
        message: 'Failed to delete all boards',
        throwable: e,
      );
    }
  }

  @override
  Future<Outcome<BoardModel, BoardRepositoryErrors>> getBoardById(String boardId) async {
    try {
      final entity = await _localDataSource.getBoardById(int.parse(boardId));
      if (entity == null) {
        return const Outcome.failure(
          error: BoardRepositoryErrors.notFound(),
          message: 'Board not found',
        );
      }
      return Outcome.success(value: BoardMapper.fromEntity(entity));
    } catch (e) {
      return Outcome.failure(
        error: const BoardRepositoryErrors.genericError(),
        message: 'Failed to get board',
        throwable: e,
      );
    }
  }

  @override
  Future<Outcome<void, BoardRepositoryErrors>> updateBoard(BoardModel board) async {
    try {
      final entity = BoardMapper.toEntity(board, isUpdate: true);
      await _localDataSource.updateBoard(entity);
      return const Outcome.success();
    } catch (e) {
      return Outcome.failure(
        error: const BoardRepositoryErrors.genericError(),
        message: 'Failed to update board',
        throwable: e,
      );
    }
  }

  @override
  Stream<Outcome<ResultPage<BoardModel>, BoardRepositoryErrors>> watchBoards({
    required int page,
    required int limitPerPage,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
    String? orderBy,
    bool onlyActive = true,
    bool ascending = true,
  }) async* {
    try {
      await for (final resultPage in _localDataSource.watchBoards(
        page: page,
        limitPerPage: limitPerPage,
        search: search,
        startDate: startDate,
        endDate: endDate,
        orderBy: orderBy,
        onlyActive: onlyActive,
        ascending: ascending,
      )) {
        final boards = resultPage.items.map(BoardMapper.fromEntity).toList();
        yield Outcome.success(value: ResultPage<BoardModel>(
          items: boards,
          totalItems: resultPage.totalItems,
          number: resultPage.number,
          totalPages: resultPage.totalPages,
          limitPerPage: resultPage.limitPerPage,
        ));
      }
    } catch (e) {
      yield Outcome.failure(
        error: const BoardRepositoryErrors.genericError(),
        message: 'Failed to watch boards',
        throwable: e,
      );
    }
  }
  
  @override
  Future<Outcome<ResultPage<BoardModel>, BoardRepositoryErrors>> getBoards({required int page, required int limitPerPage, String? search, DateTime? startDate, DateTime? endDate, String? orderBy, bool onlyActive = true, bool ascending = true}) async {
    try {
      final resultPage = await _localDataSource.getBoards(
        page: page,
        limitPerPage: limitPerPage,
        search: search,
        startDate: startDate,
        endDate: endDate,
        orderBy: orderBy,
        onlyActive: onlyActive,
        ascending: ascending,
      );
      final boards = resultPage.items.map(BoardMapper.fromEntity).toList();
      return Outcome.success(value: ResultPage<BoardModel>(
        items: boards,
        totalItems: resultPage.totalItems,
        number: resultPage.number,
        totalPages: resultPage.totalPages,
        limitPerPage: resultPage.limitPerPage,
      ));
    } catch (e) {
      return Outcome.failure(
        error: const BoardRepositoryErrors.genericError(),
        message: 'Failed to get boards',
        throwable: e,
      );
    }
  }

  @override
  Future<Outcome<List<BoardModel>, BoardRepositoryErrors>> getAllBoards() async {
    try {
      final entities = await _localDataSource.getAllBoards();
      final boards = entities.map((entity) => BoardMapper.fromEntity(entity)).toList();
      return Outcome.success(value: boards);
    } catch (e) {
      return Outcome.failure(
        error: const BoardRepositoryErrors.genericError(),
        message: 'Failed to get all boards',
        throwable: e,
      );
    }
  }
}