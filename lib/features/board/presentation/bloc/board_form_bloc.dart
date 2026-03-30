import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/board/domain/model/board_model.dart';
import 'package:flutter_ikanban_app/features/board/domain/use_cases/create_board_use_case.dart';
import 'package:flutter_ikanban_app/features/board/domain/use_cases/update_board_use_case.dart';
import 'package:flutter_ikanban_app/features/board/presentation/events/board_form_event.dart';
import 'package:flutter_ikanban_app/features/board/presentation/states/board_form_state.dart';

class BoardFormBloc extends Bloc<BoardFormEvent, BoardFormState> {
  final CreateBoardUseCase _createBoardUseCase;
  final UpdateBoardUseCase _updateBoardUseCase;

  BoardFormBloc(
    this._createBoardUseCase,
    this._updateBoardUseCase,
  ) : super(BoardFormState.initial()) {
    on<BoardFormInitializeEvent>(_onInitialize);
    on<BoardFormUpdateFieldsEvent>(_onUpdateFields);
    on<CreateBoardEvent>(_onCreateBoard);
    on<UpdateBoardEvent>(_onUpdateBoard);
    on<BoardFormResetEvent>(_onResetForm);
  }

  void _onInitialize(
    BoardFormInitializeEvent event,
    Emitter<BoardFormState> emit,
  ) {
    log('[BoardFormBloc] Initializing form: boardId=${event.boardId}, title=${event.title}');
    emit(
      state.copyWith(
        boardId: event.boardId,
        title: event.title ?? '',
        description: event.description ?? '',
        color: event.color ?? '#FF6B6B',
      ),
    );
  }

  void _onResetForm(BoardFormResetEvent event, Emitter<BoardFormState> emit) {
    emit(
      state.copyWith(
        showNotification: event.showNotification ?? state.showNotification,
        closeDialog: event.closeDialog ?? state.closeDialog,
      ),
    );
  }

  void _onUpdateFields(
    BoardFormUpdateFieldsEvent event,
    Emitter<BoardFormState> emit,
  ) {
    log('[BoardFormBloc] Updating fields: title=${event.title}, description=${event.description}, color=${event.color}');
    emit(
      state.copyWith(
        title: event.title ?? state.title,
        description: event.description ?? state.description,
        color: event.color ?? state.color,
      ),
    );
  }

  Future<void> _onCreateBoard(
    CreateBoardEvent event,
    Emitter<BoardFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    if (state.title.isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          titleError: 'O título é obrigatório.',
        ),
      );
      return;
    }

    try {
      final board = BoardModel(
        id: 0, // Will be auto-generated
        title: state.title,
        description: state.description,
        color: state.color,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: true,
      );

      final outcome = await _createBoardUseCase.execute(board);

      outcome.when(
        success: (_) {
          log('[BoardFormBloc] Board created successfully');
          emit(
            state.copyWith(
              isLoading: false,
              showNotification: true,
              closeDialog: true,
            ),
          );
        },
        failure: (error, message, throwable) {
          log('[BoardFormBloc] Error creating board: $message');
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: 'Erro ao criar quadro',
            ),
          );
        },
      );
    } catch (e) {
      log('[BoardFormBloc] Exception creating board: $e');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Erro inesperado ao criar quadro',
        ),
      );
    }
  }

  Future<void> _onUpdateBoard(
    UpdateBoardEvent event,
    Emitter<BoardFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    if (state.title.isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          titleError: 'O título é obrigatório.',
        ),
      );
      return;
    }

    if (state.boardId == null) {
      log('[BoardFormBloc] Cannot update board: boardId is null');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Erro: ID do quadro não encontrado',
        ),
      );
      return;
    }

    try {
      final board = BoardModel(
        id: state.boardId!,
        title: state.title,
        description: state.description,
        color: state.color,
        createdAt: DateTime.now(), // Will be preserved by repository
        updatedAt: DateTime.now(),
        isActive: true,
      );

      final outcome = await _updateBoardUseCase.execute(board);

      outcome.when(
        success: (_) {
          log('[BoardFormBloc] Board updated successfully');
          emit(
            state.copyWith(
              isLoading: false,
              showNotification: true,
              closeDialog: true,
            ),
          );
        },
        failure: (error, message, throwable) {
          log('[BoardFormBloc] Error updating board: $message');
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: 'Erro ao atualizar quadro',
            ),
          );
        },
      );
    } catch (e) {
      log('[BoardFormBloc] Exception updating board: $e');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Erro inesperado ao atualizar quadro',
        ),
      );
    }
  }
}
