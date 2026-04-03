// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_item_local_data_source.dart';

// ignore_for_file: type=lint
mixin _$ChecklistItemLocalDataSourceMixin on DatabaseAccessor<AppDatabase> {
  $BoardEntityTable get boardEntity => attachedDatabase.boardEntity;
  $TaskEntityTable get taskEntity => attachedDatabase.taskEntity;
  $ChecklistItemEntityTable get checklistItemEntity =>
      attachedDatabase.checklistItemEntity;
  ChecklistItemLocalDataSourceManager get managers =>
      ChecklistItemLocalDataSourceManager(this);
}

class ChecklistItemLocalDataSourceManager {
  final _$ChecklistItemLocalDataSourceMixin _db;
  ChecklistItemLocalDataSourceManager(this._db);
  $$BoardEntityTableTableManager get boardEntity =>
      $$BoardEntityTableTableManager(_db.attachedDatabase, _db.boardEntity);
  $$TaskEntityTableTableManager get taskEntity =>
      $$TaskEntityTableTableManager(_db.attachedDatabase, _db.taskEntity);
  $$ChecklistItemEntityTableTableManager get checklistItemEntity =>
      $$ChecklistItemEntityTableTableManager(
        _db.attachedDatabase,
        _db.checklistItemEntity,
      );
}
