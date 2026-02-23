import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/board/domain/model/board_model.dart';
import 'package:flutter_ikanban_app/features/board/domain/use_cases/create_board_use_case.dart';
import 'package:flutter_ikanban_app/features/board/presentation/events/board_form_event.dart';
import 'package:flutter_ikanban_app/features/board/presentation/states/board_form_state.dart';

class BoardFormBloc extends Bloc<BoardFormEvent, BoardFormState> {
  final CreateBoardUseCase _createBoardUseCase;

  BoardFormBloc(this._createBoardUseCase) : super(BoardFormState.initial()) {
    on<BoardFormUpdateFieldsEvent>(_onUpdateFields);
    on<CreateBoardEvent>(_onCreateBoard);
    on<BoardFormResetEvent>(_onResetForm);
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
}
