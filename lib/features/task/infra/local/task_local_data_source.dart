import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:flutter_ikanban_app/core/database/app_database.dart';
import 'package:flutter_ikanban_app/core/utils/result/result_page.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_sort.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/infra/local/tables/task_table_entity.dart';
import 'package:flutter_ikanban_app/features/task/presentation/extensions/task_priority_enum_extensions.dart';

part 'task_local_data_source.g.dart';

@DriftAccessor(tables: [TaskEntity])
class TaskLocalDataSource extends DatabaseAccessor<AppDatabase>
    with _$TaskLocalDataSourceMixin {
  final AppDatabase db;

  TaskLocalDataSource(this.db) : super(db);

  Future<int> insertTask(TaskEntityCompanion task) {
    return into(db.taskEntity).insert(
      task,
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<List<TaskData>> getAllTasks() {
    return select(db.taskEntity).get();
  }

  Future<TaskData?> getTaskById(int id) {
    return (select(
      db.taskEntity,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<bool> updateTask(TaskEntityCompanion task) {
    return update(db.taskEntity).replace(task);
  }

  Future<int> deleteTask(int id) {
    return (delete(db.taskEntity)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> deleteAllTasks() {
    return delete(db.taskEntity).go();
  }

  Future<void> resetAutoIncrement() async {
    await db.customStatement(
      "DELETE FROM sqlite_sequence WHERE name='task_entity'",
    );
  }

  Stream<ResultPage<TaskData>> watchTasks({
    required int boardId,
    required int page,
    required int limitPerPage,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
    SortField? orderBy,
    TaskStatus? status,
    TaskPriority? priority,
    TaskComplexity? complexity,
    List<TaskType>? type,
    bool onlyActive = true,
    bool ascending = true,
  }) async* {
    final offset = (page - 1) * limitPerPage;

    final query = select(db.taskEntity)
      ..limit(limitPerPage, offset: offset);

    // Filtros aplicados à query principal
    // Se boardId > 0, filtra por board específico; caso contrário, busca de todos os boards
    if (boardId > 0) {
      query.where((tbl) => tbl.boardId.equals(boardId));
    }

    if (onlyActive) {
      query.where((tbl) => tbl.isActive.equals(true));
    }

    if (search != null && search.isNotEmpty) {
      query.where(
        (tbl) => tbl.title.like('%$search%') | tbl.description.like('%$search%'),
      );
    }

    if (startDate != null) {
      query.where((tbl) => tbl.dueDate.isBiggerOrEqualValue(startDate));
    }

    if (endDate != null) {
      query.where((tbl) => tbl.dueDate.isSmallerOrEqualValue(endDate));
    }

    if (status != null) {
      query.where((tbl) => tbl.status.equals(status.name));
    }

    if (priority != null) {
      query.where((tbl) => tbl.priority.equals(priority.priorityValue));
    }

    if (complexity != null) {
      query.where((tbl) => tbl.complexity.equals(complexity.complexityValue));
    }

    if (type != null && type.isNotEmpty) {
      query.where((tbl) => tbl.type.isIn(type.map((e) => e.typeValue)));
    }

    // Ordenação
    if (orderBy != null) {
      final column = _getOrderByColumn(orderBy, ascending);
      query.orderBy([(tbl) => column]);
    }

    await for (final items in query.watch()) {
      // COUNT separado com os mesmos filtros
      final countQuery = db.selectOnly(db.taskEntity)
        ..addColumns([db.taskEntity.id.count()]);

      // Se boardId > 0, filtra por board específico; caso contrário, busca de todos os boards
      if (boardId > 0) {
        countQuery.where(db.taskEntity.boardId.equals(boardId));
      }

      if (onlyActive) {
        countQuery.where(db.taskEntity.isActive.equals(true));
      }

      if (search != null && search.isNotEmpty) {
        countQuery.where(
          db.taskEntity.title.like('%$search%') |
              db.taskEntity.description.like('%$search%'),
        );
      }

      if (startDate != null) {
        countQuery.where(
          db.taskEntity.dueDate.isBiggerOrEqualValue(startDate),
        );
      }

      if (endDate != null) {
        countQuery.where(
          db.taskEntity.dueDate.isSmallerOrEqualValue(endDate),
        );
      }

      if (status != null) {
        countQuery.where(db.taskEntity.status.equals(status.name));
      }

      if (priority != null) {
        countQuery.where(
          db.taskEntity.priority.equals(priority.priorityValue),
        );
      }

      if (complexity != null) {
        countQuery.where(
          db.taskEntity.complexity.equals(complexity.complexityValue),
        );
      }

      if (type != null && type.isNotEmpty) {
        countQuery.where(
          db.taskEntity.type.isIn(type.map((e) => e.typeValue)),
        );
      }

      final totalItems =
          (await countQuery.getSingle()).read(db.taskEntity.id.count()) ?? 0;

      log("Total items for current filters: $totalItems");

      yield ResultPage(
        number: page,
        limitPerPage: limitPerPage,
        totalItems: totalItems,
        totalPages: (totalItems / limitPerPage).ceil(),
        items: items,
      );
    }
  }

  Future<void> insertTasks(List<TaskEntityCompanion> entities) async {
    await db.transaction(() async {
      for (final entity in entities) {
        await into(db.taskEntity).insert(
          entity,
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  OrderingTerm _getOrderByColumn(SortField? orderBy, bool ascending) {
    log('[TaskLocalDataSource] Ordering by: $orderBy, ascending: $ascending');

    // Para campos de texto, usar collate nocase para ordenação case-insensitive
    if (orderBy == SortField.title) {
      return ascending
          ? OrderingTerm(expression: db.taskEntity.title.collate(Collate.noCase))
          : OrderingTerm(expression: db.taskEntity.title.collate(Collate.noCase), mode: OrderingMode.desc);
    }

    final Expression<Object> orderByColumn = switch (orderBy) {
      SortField.dueDate => db.taskEntity.dueDate,
      SortField.priority => db.taskEntity.priority,
      SortField.complexity => db.taskEntity.complexity,
      SortField.createdAt => db.taskEntity.createdAt,
      _ => db.taskEntity.id,
    };

    return ascending
        ? OrderingTerm.asc(orderByColumn)
        : OrderingTerm.desc(orderByColumn);
  }
}
