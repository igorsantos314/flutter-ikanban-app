import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/board/domain/errors/board_repository_errors.dart';
import 'package:flutter_ikanban_app/features/board/domain/model/board_model.dart';
import 'package:flutter_ikanban_app/features/board/domain/repository/board_repository.dart';

enum UpdateBoardUseCaseError { invalidDataError, notFoundError, genericError }

class UpdateBoardUseCase {
  final BoardRepository boardRepository;
  UpdateBoardUseCase(this.boardRepository);

  Future<Outcome<void, UpdateBoardUseCaseError>> execute(BoardModel board) async {
    final result = await boardRepository.updateBoard(board);
    return result.when(
      success: (_) => const Outcome.success(),
      failure: (error, message, throwable) {
        switch (error) {
          case BoardRepositoryErrors.validationError:
            return const Outcome.failure(
              error: UpdateBoardUseCaseError.invalidDataError,
            );
          case BoardRepositoryErrors.notFound:
            return const Outcome.failure(
              error: UpdateBoardUseCaseError.notFoundError,
            );
          default:
            return const Outcome.failure(
              error: UpdateBoardUseCaseError.genericError,
            );
        }
      },
    );
  }
}
