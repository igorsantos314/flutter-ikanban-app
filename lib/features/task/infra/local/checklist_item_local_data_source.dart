import 'package:drift/drift.dart';
import 'package:flutter_ikanban_app/core/database/app_database.dart';
import 'package:flutter_ikanban_app/features/task/infra/local/tables/checklist_item_entity_table.dart';
import 'package:flutter_ikanban_app/features/task/infra/local/tables/task_table_entity.dart';

part 'checklist_item_local_data_source.g.dart';

@DriftAccessor(tables: [ChecklistItemEntity, TaskEntity])
class ChecklistItemLocalDataSource extends DatabaseAccessor<AppDatabase>
    with _$ChecklistItemLocalDataSourceMixin {
  final AppDatabase db;

  ChecklistItemLocalDataSource(this.db) : super(db);

  Future<int> insertChecklistItem(ChecklistItemEntityCompanion item) {
    return into(db.checklistItemEntity).insert(
      item,
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<List<ChecklistItemData>> getAllChecklistItems() {
    return select(db.checklistItemEntity).get();
  }

  Future<ChecklistItemData?> getChecklistItemById(int id) {
    return (select(db.checklistItemEntity)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Stream<List<ChecklistItemData>> watchChecklistItemsByTaskId(int taskId) {
    return (select(db.checklistItemEntity)
          ..where((tbl) => tbl.taskId.equals(taskId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
        .watch();
  }

  Future<int> getChecklistItemsCountByTaskId(int taskId) async {
    final countQuery = db.selectOnly(db.checklistItemEntity)
      ..addColumns([db.checklistItemEntity.id.count()])
      ..where(db.checklistItemEntity.taskId.equals(taskId));

    final result = await countQuery.getSingle();
    return result.read(db.checklistItemEntity.id.count()) ?? 0;
  }

  Future<bool> updateChecklistItem(ChecklistItemEntityCompanion item) {
    return update(db.checklistItemEntity).replace(item);
  }

  Future<int> deleteChecklistItem(int id) {
    return (delete(db.checklistItemEntity)..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  Future<int> deleteAllChecklistItemsByTaskId(int taskId) {
    return (delete(db.checklistItemEntity)
          ..where((tbl) => tbl.taskId.equals(taskId)))
        .go();
  }

  Future<void> insertChecklistItemsInTransaction(
    List<ChecklistItemEntityCompanion> items,
  ) async {
    await db.transaction(() async {
      for (final item in items) {
        await into(db.checklistItemEntity).insert(
          item,
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  // Transactional methods to update task stats automatically

  /// Inserts a checklist item and updates task stats in a transaction
  Future<int> insertChecklistItemWithTaskUpdate(
    ChecklistItemEntityCompanion item,
    int taskId,
  ) async {
    return await db.transaction(() async {
      // Insert the checklist item
      final itemId = await into(db.checklistItemEntity).insert(
        item,
        mode: InsertMode.insertOrReplace,
      );

      // Recalculate and update task stats
      await _updateTaskChecklistStats(taskId);

      return itemId;
    });
  }

  /// Updates a checklist item and updates task stats in a transaction
  Future<bool> updateChecklistItemWithTaskUpdate(
    ChecklistItemEntityCompanion item,
    int taskId,
  ) async {
    return await db.transaction(() async {
      // Update the checklist item
      final updated = await update(db.checklistItemEntity).replace(item);

      // Recalculate and update task stats
      await _updateTaskChecklistStats(taskId);

      return updated;
    });
  }

  /// Deletes a checklist item and updates task stats in a transaction
  Future<int> deleteChecklistItemWithTaskUpdate(int id, int taskId) async {
    return await db.transaction(() async {
      // Delete the checklist item
      final deleted = await (delete(db.checklistItemEntity)
            ..where((tbl) => tbl.id.equals(id)))
          .go();

      // Recalculate and update task stats
      await _updateTaskChecklistStats(taskId);

      return deleted;
    });
  }

  /// Recalculates and updates task checklist statistics
  Future<void> _updateTaskChecklistStats(int taskId) async {
    // Count total items
    final totalQuery = db.selectOnly(db.checklistItemEntity)
      ..addColumns([db.checklistItemEntity.id.count()])
      ..where(db.checklistItemEntity.taskId.equals(taskId));

    final total = (await totalQuery.getSingle())
            .read(db.checklistItemEntity.id.count()) ??
        0;

    // Count completed items
    final completedQuery = db.selectOnly(db.checklistItemEntity)
      ..addColumns([db.checklistItemEntity.id.count()])
      ..where(db.checklistItemEntity.taskId.equals(taskId) &
          db.checklistItemEntity.isCompleted.equals(true));

    final completed = (await completedQuery.getSingle())
            .read(db.checklistItemEntity.id.count()) ??
        0;

    // Update task stats
    await (update(db.taskEntity)..where((tbl) => tbl.id.equals(taskId))).write(
      TaskEntityCompanion(
        checklistTotal: Value(total),
        checklistCompleted: Value(completed),
      ),
    );
  }
}
