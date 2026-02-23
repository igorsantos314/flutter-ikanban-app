import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/board/domain/errors/board_repository_errors.dart';
import 'package:flutter_ikanban_app/features/board/domain/model/board_model.dart';
import 'package:flutter_ikanban_app/features/board/domain/repository/board_repository.dart';

enum CreateBoardUseCaseError { invalidDataError, genericError }

class CreateBoardUseCase {
  final BoardRepository boardRepository;
  CreateBoardUseCase(this.boardRepository);

  Future<Outcome<void, CreateBoardUseCaseError>> execute(BoardModel board) async {
    final result = await boardRepository.createBoard(board);
    return result.when(
      success: (_) => const Outcome.success(),
      failure: (error, message, throwable) {
        switch (error) {
          case BoardRepositoryErrors.validationError:
            return const Outcome.failure(
              error: CreateBoardUseCaseError.invalidDataError,
            );
          default:
            return const Outcome.failure(
              error: CreateBoardUseCaseError.genericError,
            );
        }
      },
    );
  }
}
