import 'package:drift/drift.dart';
import 'package:flutter_ikanban_app/core/database/app_database.dart';
import 'package:flutter_ikanban_app/features/board/domain/model/board_model.dart';

class BoardMapper {
  static BoardEntityCompanion toEntity(BoardModel model, {bool isUpdate = false}) {
    return BoardEntityCompanion(
      id: isUpdate ? Value(int.parse(model.id)) : const Value.absent(),
      title: Value(model.title),
      description: Value(model.description),
      color: Value(model.color),
      createdAt: Value(model.createdAt),
      updatedAt: Value(model.updatedAt),
      isActive: Value(model.isActive),
    );
  }
  
  static BoardModel fromEntity(BoardData entity) {
    return BoardModel(
      id: entity.id.toString(),
      title: entity.title,
      description: entity.description,
      color: entity.color,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isActive: entity.isActive,
    );
  }
}