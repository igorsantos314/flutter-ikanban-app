import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/core/utils/result/result_page.dart';
import 'package:flutter_ikanban_app/features/board/domain/model/board_model.dart';
import 'package:flutter_ikanban_app/features/board/domain/repository/board_repository.dart';

enum ListBoardUseCaseError { genericError }

class ListBoardUseCase {
  final BoardRepository boardRepository;
  ListBoardUseCase(this.boardRepository);

  Stream<Outcome<ResultPage<BoardModel>, ListBoardUseCaseError>> execute({
    required int page,
    required int limitPerPage,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
    String? orderBy,
    bool onlyActive = true,
    bool ascending = true,
  }) {
    final streamResult = boardRepository.watchBoards(
      page: page,
      limitPerPage: limitPerPage,
      search: search,
      startDate: startDate,
      endDate: endDate,
      orderBy: orderBy,
      onlyActive: onlyActive,
      ascending: ascending,
    );

    return streamResult.map((outcome) {
      return outcome.when(
        success: (value) => Outcome.success(value: value),
        failure: (error, message, throwable) {
          return const Outcome.failure(
            error: ListBoardUseCaseError.genericError,
          );
        },
      );
    });
  }
}
