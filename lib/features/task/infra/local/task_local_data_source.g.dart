// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_local_data_source.dart';

// ignore_for_file: type=lint
mixin _$TaskLocalDataSourceMixin on DatabaseAccessor<AppDatabase> {
  $BoardEntityTable get boardEntity => attachedDatabase.boardEntity;
  $TaskEntityTable get taskEntity => attachedDatabase.taskEntity;
  TaskLocalDataSourceManager get managers => TaskLocalDataSourceManager(this);
}

class TaskLocalDataSourceManager {
  final _$TaskLocalDataSourceMixin _db;
  TaskLocalDataSourceManager(this._db);
  $$BoardEntityTableTableManager get boardEntity =>
      $$BoardEntityTableTableManager(_db.attachedDatabase, _db.boardEntity);
  $$TaskEntityTableTableManager get taskEntity =>
      $$TaskEntityTableTableManager(_db.attachedDatabase, _db.taskEntity);
}
