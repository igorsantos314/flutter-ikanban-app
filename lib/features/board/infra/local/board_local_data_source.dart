
import 'package:drift/drift.dart';
import 'package:flutter_ikanban_app/core/database/app_database.dart';
import 'package:flutter_ikanban_app/core/utils/result/result_page.dart';
import 'package:flutter_ikanban_app/features/board/infra/local/tables/board_entity_table.dart';

part 'board_local_data_source.g.dart';

@DriftAccessor(tables: [BoardEntity])
class BoardLocalDataSource extends DatabaseAccessor<AppDatabase> with _$BoardLocalDataSourceMixin {
  final AppDatabase db;

  BoardLocalDataSource(this.db) : super(db);

  Future<int> insertBoard(BoardEntityCompanion board) {
    return into(db.boardEntity).insert(
      board,
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<List<BoardData>> getAllBoards() {
    return select(db.boardEntity).get();
  }

  Future<BoardData?> getBoardById(int id) {
    return (select(db.boardEntity)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<bool> updateBoard(BoardEntityCompanion board) {
    return update(db.boardEntity).replace(board);
  }

  Future<int> deleteBoard(int id) {
    return (delete(db.boardEntity)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> deleteAllBoards() {
    return delete(db.boardEntity).go();
  }

  Future<void> resetAutoIncrement() async {
    await db.customStatement(
      "DELETE FROM sqlite_sequence WHERE name='board_entity'",
    );
  }

  Future<List<BoardData>> getBoardsList({
    String? search,
    DateTime? startDate,
    DateTime? endDate,
    String? orderBy,
    bool onlyActive = true,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    final query = select(db.boardEntity);

    // Aplicar filtros
    if (onlyActive) {
      query.where((tbl) => tbl.isActive.equals(true));
    }

    if (search != null && search.isNotEmpty) {
      query.where((tbl) => tbl.title.contains(search));
    }

    if (startDate != null) {
      query.where((tbl) => tbl.createdAt.isBiggerOrEqualValue(startDate));
    }

    if (endDate != null) {
      query.where((tbl) => tbl.createdAt.isSmallerOrEqualValue(endDate));
    }

    // Aplicar ordenação
    if (orderBy != null) {
      final column = db.boardEntity.$columns.firstWhere(
        (col) => col.$name == orderBy,
        orElse: () => db.boardEntity.id,
      );
      query.orderBy([(tbl) => ascending ? OrderingTerm.asc(column) : OrderingTerm.desc(column)]);
    }

    // Aplicar paginação se especificada
    if (limit != null) {
      query.limit(limit, offset: offset ?? 0);
    }

    return query.get();
  }

  Future<ResultPage<BoardData>> getBoards({
    required int page,
    required int limitPerPage,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
    String? orderBy,
    bool onlyActive = true,
    bool ascending = true,
  }) async {
    final query = select(db.boardEntity);

    // Aplicar filtros
    if (onlyActive) {
      query.where((tbl) => tbl.isActive.equals(true));
    }

    if (search != null && search.isNotEmpty) {
      query.where((tbl) => tbl.title.contains(search));
    }

    if (startDate != null) {
      query.where((tbl) => tbl.createdAt.isBiggerOrEqualValue(startDate));
    }

    if (endDate != null) {
      query.where((tbl) => tbl.createdAt.isSmallerOrEqualValue(endDate));
    }

    // Aplicar ordenação
    if (orderBy != null) {
      final column = db.boardEntity.$columns.firstWhere(
        (col) => col.$name == orderBy,
        orElse: () => db.boardEntity.id,
      );
      query.orderBy([(tbl) => ascending ? OrderingTerm.asc(column) : OrderingTerm.desc(column)]);
    }

    // Contagem total com os mesmos filtros
    final totalItemsQuery = db.selectOnly(db.boardEntity)
      ..addColumns([db.boardEntity.id.count()]);

    if (onlyActive) {
      totalItemsQuery.where(db.boardEntity.isActive.equals(true));
    }

    if (search != null && search.isNotEmpty) {
      totalItemsQuery.where(db.boardEntity.title.like('%$search%'));
    }

    if (startDate != null) {
      totalItemsQuery.where(
        db.boardEntity.createdAt.isBiggerOrEqualValue(startDate),
      );
    }

    if (endDate != null) {
      totalItemsQuery.where(
        db.boardEntity.createdAt.isSmallerOrEqualValue(endDate),
      );
    }

    final totalItems = (await totalItemsQuery.getSingle())
        .read(db.boardEntity.id.count()) ?? 0;

    // Aplicar paginação
    final start = (page - 1) * limitPerPage;
    query.limit(limitPerPage, offset: start);

    final items = await query.get();

    return ResultPage<BoardData>(
      items: items,
      totalItems: totalItems,
      number: page,
      totalPages: (totalItems / limitPerPage).ceil(),
      limitPerPage: limitPerPage,
    );
  }

  Stream<ResultPage<BoardData>> watchBoards({
    required int page,
    required int limitPerPage,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
    String? orderBy,
    bool onlyActive = true,
    bool ascending = true,
  }) async* {
    final query = select(db.boardEntity);

    if (onlyActive) {
      query.where((tbl) => tbl.isActive.equals(true));
    }

    if (search != null && search.isNotEmpty) {
      query.where((tbl) => tbl.title.contains(search));
    }

    if (startDate != null) {
      query.where((tbl) => tbl.createdAt.isBiggerOrEqualValue(startDate));
    }

    if (endDate != null) {
      query.where((tbl) => tbl.createdAt.isSmallerOrEqualValue(endDate));
    }

    if (orderBy != null) {
      final column = db.boardEntity.$columns.firstWhere(
        (col) => col.$name == orderBy,
        orElse: () => db.boardEntity.id,
      );
      query.orderBy([(tbl) => ascending ? OrderingTerm.asc(column) : OrderingTerm.desc(column)]);
    }
    
    await for (final items in query.watch().map((rows) {
      final start = (page - 1) * limitPerPage;
      final end = start + limitPerPage;
      return rows.sublist(start, end > rows.length ? rows.length : end);
    })) {
      // Contagem total
      final totalItemsQuery = db.selectOnly(db.boardEntity)
        ..addColumns([db.boardEntity.id.count()]);

      // Reaplica filtros iguais na query de contagem
      if (search != null && search.isNotEmpty) {
        totalItemsQuery.where(db.boardEntity.title.like('%$search%'));
      }

      if (startDate != null) {
        totalItemsQuery.where(
          db.boardEntity.createdAt.isBiggerOrEqualValue(startDate),
        );
      }

      if (endDate != null) {
        totalItemsQuery.where(
          db.boardEntity.createdAt.isSmallerOrEqualValue(endDate),
        );
      }

      if (onlyActive) {
        totalItemsQuery.where(
          db.boardEntity.isActive.equals(true),
        );
      }

      final totalItems =
          (await totalItemsQuery.getSingle()).read(
            db.boardEntity.id.count(),
          ) ??
          0;

      yield ResultPage(
        items: items,
        totalItems: totalItems,
        number: page,
        totalPages: (totalItems / limitPerPage).ceil(),
        limitPerPage: limitPerPage,
      );
    }
  }
}
