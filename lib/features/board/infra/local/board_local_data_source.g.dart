// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_local_data_source.dart';

// ignore_for_file: type=lint
mixin _$BoardLocalDataSourceMixin on DatabaseAccessor<AppDatabase> {
  $BoardEntityTable get boardEntity => attachedDatabase.boardEntity;
  BoardLocalDataSourceManager get managers => BoardLocalDataSourceManager(this);
}

class BoardLocalDataSourceManager {
  final _$BoardLocalDataSourceMixin _db;
  BoardLocalDataSourceManager(this._db);
  $$BoardEntityTableTableManager get boardEntity =>
      $$BoardEntityTableTableManager(_db.attachedDatabase, _db.boardEntity);
}
