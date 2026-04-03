import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/checklist_item_model.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/checklist_item_repository.dart';
import 'package:flutter_ikanban_app/features/task/infra/local/checklist_item_local_data_source.dart';
import 'package:flutter_ikanban_app/features/task/infra/local/mapper/checklist_item_mapper.dart';

class ChecklistItemRepositoryImpl implements ChecklistItemRepository {
  final ChecklistItemLocalDataSource _localDataSource;

  ChecklistItemRepositoryImpl(this._localDataSource);

  @override
  Future<Outcome<int, ChecklistItemRepositoryErrors>> createChecklistItem(
    ChecklistItemModel item,
  ) async {
    try {
      final entity = ChecklistItemMapper.toEntity(item);
      final generatedId = await _localDataSource.insertChecklistItem(entity);
      return Outcome.success(value: generatedId);
    } catch (e) {
      return Outcome.failure(
        error: GenericError(),
        message: 'Failed to create checklist item',
        throwable: e,
      );
    }
  }

  @override
  Future<Outcome<void, ChecklistItemRepositoryErrors>> createChecklistItems(
    List<ChecklistItemModel> items,
  ) async {
    try {
      final entities = items
          .map((item) => ChecklistItemMapper.toEntity(item))
          .toList();
      await _localDataSource.insertChecklistItemsInTransaction(entities);
      return const Outcome.success();
    } catch (e) {
      return Outcome.failure(
        error: GenericError(),
        message: 'Failed to create checklist items',
        throwable: e,
      );
    }
  }

  @override
  Future<Outcome<void, ChecklistItemRepositoryErrors>> deleteChecklistItem(
    int id,
  ) async {
    try {
      await _localDataSource.deleteChecklistItem(id);
      return const Outcome.success();
    } catch (e) {
      return Outcome.failure(
        error: GenericError(),
        message: 'Failed to delete checklist item',
        throwable: e,
      );
    }
  }

  @override
  Future<Outcome<void, ChecklistItemRepositoryErrors>> updateChecklistItem(
    ChecklistItemModel item,
  ) async {
    try {
      final entity = ChecklistItemMapper.toEntity(item);
      await _localDataSource.updateChecklistItem(entity);
      return const Outcome.success();
    } catch (e) {
      return Outcome.failure(
        error: GenericError(),
        message: 'Failed to update checklist item',
        throwable: e,
      );
    }
  }

  @override
  Stream<Outcome<List<ChecklistItemModel>, ChecklistItemRepositoryErrors>>
      watchChecklistItemsByTaskId(int taskId) {
    return _localDataSource
        .watchChecklistItemsByTaskId(taskId)
        .map<List<ChecklistItemModel>>((items) {
          return items
              .map((item) => ChecklistItemMapper.fromEntity(item))
              .toList();
        })
        .map<Outcome<List<ChecklistItemModel>, ChecklistItemRepositoryErrors>>(
          (items) {
        return Outcome<List<ChecklistItemModel>,
            ChecklistItemRepositoryErrors>.success(
          value: items,
        );
      },
    ).handleError((error, stack) {
      return Outcome<List<ChecklistItemModel>,
          ChecklistItemRepositoryErrors>.failure(
        error: GenericError(),
      );
    });
  }

  @override
  Future<Outcome<int, ChecklistItemRepositoryErrors>>
      getChecklistItemsCountByTaskId(int taskId) async {
    try {
      final count =
          await _localDataSource.getChecklistItemsCountByTaskId(taskId);
      return Outcome.success(value: count);
    } catch (e) {
      return Outcome.failure(
        error: GenericError(),
        message: 'Failed to get checklist items count',
        throwable: e,
      );
    }
  }
}
