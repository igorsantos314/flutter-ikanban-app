import 'dart:developer';
import 'dart:io';

import 'package:flutter_ikanban_app/core/utils/mapper/generic_sql_int_conveter.dart';
import 'package:flutter_ikanban_app/core/utils/mapper/generic_sql_type_converter.dart';
import 'package:flutter_ikanban_app/features/board/infra/local/tables/board_entity_table.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/infra/local/mapper/complexity_sql_converter.dart';
import 'package:flutter_ikanban_app/features/task/infra/local/mapper/priority_sql_converter.dart';
import 'package:flutter_ikanban_app/features/task/presentation/colors/task_colors.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_ikanban_app/features/task/infra/local/tables/task_table_entity.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [TaskEntity, BoardEntity])
class AppDatabase extends _$AppDatabase {
  static const String dbName = 'ikanban_app.db';
  AppDatabase() : super(_openConnection(dbName));

  @override
  int get schemaVersion => 2;
}

LazyDatabase _openConnection(String dbName) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();

    log('Database path: ${p.join(dbFolder.path, dbName)}');

    final file = File(p.join(dbFolder.path, dbName));
    return NativeDatabase.createInBackground(file);
  });
}
