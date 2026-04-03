import 'package:drift/drift.dart';
import 'package:flutter_ikanban_app/core/database/app_database.dart';
import 'package:flutter_ikanban_app/features/task/infra/local/tables/checklist_item_entity_table.dart';

part 'checklist_item_local_data_source.g.dart';

@DriftAccessor(tables: [ChecklistItemEntity])
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
}
