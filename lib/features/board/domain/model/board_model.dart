import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_model.freezed.dart';

@freezed
abstract class BoardModel with _$BoardModel {
  const factory BoardModel({
    required int id,
    required String title,
    String? description,
    String? color,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(true) bool isActive,
  }) = _BoardModel;
}
