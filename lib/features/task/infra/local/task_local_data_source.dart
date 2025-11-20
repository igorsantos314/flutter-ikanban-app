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
    return into(db.taskEntity).insert(task);
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

  Stream<ResultPage<TaskData>> watchTasks({
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
    final query = select(db.taskEntity);

    if (onlyActive) {
      query.where((tbl) => tbl.isActive.equals(true));
    }

    if (search != null && search.isNotEmpty) {
      query.where(
        (tbl) => tbl.title.contains(search) | tbl.description.contains(search),
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

    if (type != null) {
      query.where((tbl) => tbl.type.isIn(type.map((e) => e.typeValue)));
    }

    final column = _getOrderByColumn(orderBy, ascending);
    query.orderBy([(tbl) => column]);
    
    // Aplicar paginação na query SQL, não em memória
    query.limit(limitPerPage, offset: (page - 1) * limitPerPage);

    await for (final items in query.watch()) {
      final totalItemsQuery = db.selectOnly(db.taskEntity)
        ..addColumns([db.taskEntity.id.count()]);

      if (search != null && search.isNotEmpty) {
        final description = db.taskEntity.description;
        final title = db.taskEntity.title;
        final searchExpression =
            description.like('%$search%') | title.like('%$search%');
        totalItemsQuery.where(searchExpression);
      }

      if (startDate != null) {
        totalItemsQuery.where(
          db.taskEntity.dueDate.isBiggerOrEqualValue(startDate),
        );
      }

      if (endDate != null) {
        totalItemsQuery.where(
          db.taskEntity.dueDate.isSmallerOrEqualValue(endDate),
        );
      }

      if (status != null) {
        totalItemsQuery.where(db.taskEntity.status.equals(status.name));
      }
      if (priority != null) {
        totalItemsQuery.where(db.taskEntity.priority.equals(priority.priorityValue));
      }
      if (complexity != null) {
        totalItemsQuery.where(db.taskEntity.complexity.equals(complexity.complexityValue));
      }
      if (type != null) {
        totalItemsQuery.where(db.taskEntity.type.isIn(type.map((e) => e.typeValue)));
      }
      if (onlyActive) {
        totalItemsQuery.where(db.taskEntity.isActive.equals(true));
      }

      final totalItems =
          (await totalItemsQuery.getSingle()).read(db.taskEntity.id.count()) ??
          0;

      log("Total items for current filters: $totalItems");

      yield ResultPage(
        items: items,
        totalItems: totalItems,
        number: page,
        totalPages: (totalItems / limitPerPage).ceil(),
        limitPerPage: limitPerPage,
      );
    }
  }

  Future<void> insertTasks(List<TaskEntityCompanion> entities) async {
    await db.transaction(() async {
      for (final entity in entities) {
        await into(db.taskEntity).insert(entity);
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
