import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_ikanban_app/features/task/infra/local/tables/task_table_entity.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [TaskEntity])
class AppDatabase extends _$AppDatabase {
  static const String dbName = 'ikanban_app.db';
  AppDatabase() : super(_openConnection(dbName));

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection(String dbName) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();

    log('Database path: ${p.join(dbFolder.path, dbName)}');

    final file = File(p.join(dbFolder.path, dbName));
    return NativeDatabase.createInBackground(file);
  });
}
