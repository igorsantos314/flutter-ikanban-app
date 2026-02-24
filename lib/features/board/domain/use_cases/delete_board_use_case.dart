import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/board/domain/errors/board_repository_errors.dart';
import 'package:flutter_ikanban_app/features/board/domain/repository/board_repository.dart';

enum DeleteBoardUseCaseError { notFoundError, genericError }

class DeleteBoardUseCase {
  final BoardRepository boardRepository;
  DeleteBoardUseCase(this.boardRepository);

  Future<Outcome<void, DeleteBoardUseCaseError>> execute(String boardId) async {
    final result = await boardRepository.deleteBoard(boardId);
    return result.when(
      success: (_) => const Outcome.success(),
      failure: (error, message, throwable) {
        switch (error) {
          case BoardRepositoryErrors.notFound:
            return const Outcome.failure(
              error: DeleteBoardUseCaseError.notFoundError,
            );
          default:
            return const Outcome.failure(
              error: DeleteBoardUseCaseError.genericError,
            );
        }
      },
    );
  }
}
