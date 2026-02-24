import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/board/domain/model/board_model.dart';
import 'package:flutter_ikanban_app/features/board/domain/repository/board_repository.dart';

enum GetOrCreateDefaultBoardUseCaseError { genericError }

class GetOrCreateDefaultBoardUseCase {
  final BoardRepository boardRepository;
  
  GetOrCreateDefaultBoardUseCase(this.boardRepository);

  Future<Outcome<BoardModel, GetOrCreateDefaultBoardUseCaseError>> execute() async {
    // Tenta obter boards existentes
    final result = await boardRepository.getBoards(
      page: 1,
      limitPerPage: 1,
      onlyActive: true,
    );

    return await result.when(
      success: (resultPage) async {
        // Se já existe um board, retorna o primeiro
        if (resultPage != null && resultPage.items.isNotEmpty) {
          return Outcome.success(value: resultPage.items.first);
        }

        // Se não existe, cria um board padrão
        final defaultBoard = BoardModel(
          id: 0, // Será gerado pelo autoincrement
          title: 'Meu Quadro',
          description: 'Quadro principal para organizar suas tarefas',
          color: '#FF6B6B',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isActive: true,
        );

        final createResult = await boardRepository.createBoard(defaultBoard);
        
        return await createResult.when(
          success: (_) async {
            // Busca o board recém criado
            final boardsResult = await boardRepository.getBoards(
              page: 1,
              limitPerPage: 1,
              onlyActive: true,
            );
            
            return boardsResult.when(
              success: (page) {
                if (page != null && page.items.isNotEmpty) {
                  return Outcome.success(value: page.items.first);
                }
                return const Outcome.failure(
                  error: GetOrCreateDefaultBoardUseCaseError.genericError,
                );
              },
              failure: (_, __, ___) => const Outcome.failure(
                error: GetOrCreateDefaultBoardUseCaseError.genericError,
              ),
            );
          },
          failure: (_, __, ___) => const Outcome.failure(
            error: GetOrCreateDefaultBoardUseCaseError.genericError,
          ),
        );
      },
      failure: (_, __, ___) => const Outcome.failure(
        error: GetOrCreateDefaultBoardUseCaseError.genericError,
      ),
    );
  }
}
