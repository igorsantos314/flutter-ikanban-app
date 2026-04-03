import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/task/domain/repository/checklist_item_repository.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/checklist_item_model.dart';
import 'package:flutter_ikanban_app/features/task/presentation/events/checklist/checklist_item_events.dart';
import 'package:flutter_ikanban_app/features/task/presentation/states/checklist/checklist_item_state.dart';

class ChecklistItemBloc extends Bloc<ChecklistItemEvent, ChecklistItemState> {
  final ChecklistItemRepository _repository;
  StreamSubscription? _itemsSubscription;

  static const int maxChecklistItems = 50;

  ChecklistItemBloc(this._repository) : super(ChecklistItemState.initial()) {
    on<LoadChecklistItemsEvent>(_onLoadChecklistItems);
    on<AddChecklistItemEvent>(_onAddChecklistItem);
    on<UpdateChecklistItemEvent>(_onUpdateChecklistItem);
    on<ToggleChecklistItemEvent>(_onToggleChecklistItem);
    on<DeleteChecklistItemEvent>(_onDeleteChecklistItem);
    on<_UpdateItemsInternalEvent>(_onUpdateItemsInternal);
    on<_SetErrorEvent>(_onSetError);
  }

  Future<void> _onLoadChecklistItems(
    LoadChecklistItemsEvent event,
    Emitter<ChecklistItemState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    await _itemsSubscription?.cancel();

    _itemsSubscription = _repository
        .watchChecklistItemsByTaskId(event.taskId)
        .listen((outcome) {
      outcome.when(
        success: (items) {
          if (items == null) {
            add(_SetErrorEvent('Nenhum item encontrado'));
            return;
          }
          
          add(_UpdateItemsInternalEvent(items));
        },
        failure: (error, message, throwable) {
          add(_SetErrorEvent(message ?? 'Failed to load checklist items'));
        },
      );
    });
  }

  Future<void> _onAddChecklistItem(
    AddChecklistItemEvent event,
    Emitter<ChecklistItemState> emit,
  ) async {
    // Check if max items reached
    if (state.itemCount >= maxChecklistItems) {
      emit(state.copyWith(
        errorMessage: 'Máximo de $maxChecklistItems itens atingido',
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    final newItem = ChecklistItemModel(
      title: event.title,
      description: event.description,
      taskId: event.taskId,
      createdAt: DateTime.now(),
    );

    final outcome = await _repository.createChecklistItem(newItem);

    outcome.when(
      success: (id) {
        emit(state.copyWith(isLoading: false));
      },
      failure: (error, message, throwable) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: message ?? 'Falha ao adicionar item',
        ));
      },
    );
  }

  Future<void> _onUpdateChecklistItem(
    UpdateChecklistItemEvent event,
    Emitter<ChecklistItemState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final outcome = await _repository.updateChecklistItem(event.item);

    outcome.when(
      success: (_) {
        emit(state.copyWith(isLoading: false));
      },
      failure: (error, message, throwable) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: message ?? 'Falha ao atualizar item',
        ));
      },
    );
  }

  Future<void> _onToggleChecklistItem(
    ToggleChecklistItemEvent event,
    Emitter<ChecklistItemState> emit,
  ) async {
    final updatedItem = event.item.copyWith(
      isCompleted: !event.item.isCompleted,
    );

    final outcome = await _repository.updateChecklistItem(updatedItem);

    outcome.when(
      success: (_) {
        // Items will be updated via stream
      },
      failure: (error, message, throwable) {
        emit(state.copyWith(
          errorMessage: message ?? 'Falha ao atualizar status',
        ));
      },
    );
  }

  Future<void> _onDeleteChecklistItem(
    DeleteChecklistItemEvent event,
    Emitter<ChecklistItemState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final outcome = await _repository.deleteChecklistItem(event.id);

    outcome.when(
      success: (_) {
        emit(state.copyWith(isLoading: false));
      },
      failure: (error, message, throwable) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: message ?? 'Falha ao deletar item',
        ));
      },
    );
  }

  @override
  Future<void> close() {
    _itemsSubscription?.cancel();
    return super.close();
  }

  void _onUpdateItemsInternal(
    _UpdateItemsInternalEvent event,
    Emitter<ChecklistItemState> emit,
  ) {
    emit(state.copyWith(
      items: event.items,
      itemCount: event.items.length,
      isLoading: false,
    ));
  }

  void _onSetError(
    _SetErrorEvent event,
    Emitter<ChecklistItemState> emit,
  ) {
    emit(state.copyWith(
      errorMessage: event.message,
      isLoading: false,
    ));
  }
}

// Internal events for stream updates
class _UpdateItemsInternalEvent extends ChecklistItemEvent {
  final List<ChecklistItemModel> items;

  _UpdateItemsInternalEvent(this.items);
}

class _SetErrorEvent extends ChecklistItemEvent {
  final String message;

  _SetErrorEvent(this.message);
}
