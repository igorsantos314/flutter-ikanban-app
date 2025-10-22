import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:flutter_ikanban_app/core/database/app_database.dart';
import 'package:flutter_ikanban_app/core/utils/result/result_page.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/infra/local/tables/task_table_entity.dart';

part 'task_local_data_source.g.dart';

@DriftAccessor(tables: [TaskEntity])
class TaskLocalDataSource extends DatabaseAccessor<AppDatabase> with _$TaskLocalDataSourceMixin {
  final AppDatabase db;

  TaskLocalDataSource(this.db) : super(db);

  Future<int> insertTask(TaskEntityCompanion task) {
    return into(db.taskEntity).insert(task);
  }

  Future<List<TaskData>> getAllTasks() {
    return select(db.taskEntity).get();
  }

  Future<TaskData?> getTaskById(int id) {
    return (select(db.taskEntity)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<bool> updateTask(TaskData task) {
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
    String? orderBy,
    TaskStatus? status,
    TaskPriority? priority,
    TaskComplexity? complexity,
    TaskType? type,
    bool onlyActive = true,
    bool ascending = true,
  }) async* {
    final query = select(db.taskEntity);

    if (onlyActive) {
      query.where((tbl) => tbl.isActive.equals(true));
    }

    if (search != null && search.isNotEmpty) {
      query.where((tbl) => tbl.title.contains(search) | tbl.description.contains(search));
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
      query.where((tbl) => tbl.priority.equals(priority.name));
    }

    if (complexity != null) {
      query.where((tbl) => tbl.complexity.equals(complexity.name));
    }

    if (type != null) {
      query.where((tbl) => tbl.type.equals(type.name));
    }

    if (orderBy != null) {
      final column = db.taskEntity.$columns.firstWhere(
        (col) => col.$name == orderBy,
        orElse: () => db.taskEntity.id,
      );
      query.orderBy([(tbl) => ascending ? OrderingTerm.asc(column) : OrderingTerm.desc(column)]);
    }
    
    await for (final items in query.watch().map((rows) {
      final start = (page - 1) * limitPerPage;
      final end = start + limitPerPage;
      return rows.sublist(start, end > rows.length ? rows.length : end);
    })) {
      // 4. Contagem total
      final totalItemsQuery = db.selectOnly(db.taskEntity)
        ..addColumns([db.taskEntity.id.count()]);

      // reaplica filtros iguais na query de contagem
      if (search != null && search.isNotEmpty) {
        final description = db.taskEntity.description;
        final title = db.taskEntity.title;
        final searchExpression =
            description.like('%$search%') |
            title.like('%$search%');
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
        totalItemsQuery.where(
          db.taskEntity.status.equals(status.name),
        );
      }
      if (priority != null) {
        totalItemsQuery.where(
          db.taskEntity.priority.equals(priority.name),
        );
      }
      if (complexity != null) {
        totalItemsQuery.where(
          db.taskEntity.complexity.equals(complexity.name),
        );
      }
      if (type != null) {
        totalItemsQuery.where(
          db.taskEntity.type.equals(type.name),
        );
      } 
      if (onlyActive) {
        totalItemsQuery.where(
          db.taskEntity.isActive.equals(true),
        );
      }

      final totalItems =
          (await totalItemsQuery.getSingle()).read(
            db.taskEntity.id.count(),
          ) ??
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
}