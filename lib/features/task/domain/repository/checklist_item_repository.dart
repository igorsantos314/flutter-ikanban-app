import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/checklist_item_model.dart';

abstract class ChecklistItemRepositoryErrors {}

class GenericError extends ChecklistItemRepositoryErrors {}

class NotFoundError extends ChecklistItemRepositoryErrors {}

class MaxItemsReachedError extends ChecklistItemRepositoryErrors {}

abstract class ChecklistItemRepository {
  Future<Outcome<int, ChecklistItemRepositoryErrors>> createChecklistItem(
    ChecklistItemModel item,
  );

  Future<Outcome<void, ChecklistItemRepositoryErrors>> createChecklistItems(
    List<ChecklistItemModel> items,
  );

  Future<Outcome<void, ChecklistItemRepositoryErrors>> updateChecklistItem(
    ChecklistItemModel item,
  );

  Future<Outcome<void, ChecklistItemRepositoryErrors>> deleteChecklistItem(
    int id,
  );

  Future<Outcome<void, ChecklistItemRepositoryErrors>> deleteAllChecklistItemsByTaskId(
    int taskId,
  );

  Stream<Outcome<List<ChecklistItemModel>, ChecklistItemRepositoryErrors>>
      watchChecklistItemsByTaskId(int taskId);

  Future<Outcome<int, ChecklistItemRepositoryErrors>>
      getChecklistItemsCountByTaskId(int taskId);
}
