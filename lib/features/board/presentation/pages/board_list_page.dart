import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/di/app_locator.dart';
import 'package:flutter_ikanban_app/core/navigation/app_navigation.dart';
import 'package:flutter_ikanban_app/core/ui/widgets/appbar/custom_app_bar.dart';
import 'package:flutter_ikanban_app/features/board/domain/services/board_selection_service.dart';
import 'package:flutter_ikanban_app/features/board/presentation/bloc/board_list_bloc.dart';
import 'package:flutter_ikanban_app/features/board/presentation/events/board_list_event.dart';
import 'package:flutter_ikanban_app/features/board/presentation/states/board_list_state.dart';
import 'package:flutter_ikanban_app/features/board/presentation/widgets/board_create_dialog.dart';

class BoardListPage extends StatelessWidget {
  const BoardListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoardListBloc(getIt())..add(LoadBoardsEvent()),
      child: const BoardListPageContent(),
    );
  }
}

class BoardListPageContent extends StatefulWidget {
  const BoardListPageContent({super.key});

  @override
  State<BoardListPageContent> createState() => _BoardListPageContentState();
}

class _BoardListPageContentState extends State<BoardListPageContent> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<BoardListBloc>().add(LoadMoreBoardsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        onClose: () {
          _searchController.clear();
          context.read<BoardListBloc>().add(SearchBoardsEvent(null));
        },
        onSubmit: (query) {
          context.read<BoardListBloc>().add(
            SearchBoardsEvent(query.isEmpty ? null : query),
          );
        },
        onChanged: (query) {
          if (query.isEmpty) {
            context.read<BoardListBloc>().add(SearchBoardsEvent(null));
          }
        },
      ),
      body: BlocConsumer<BoardListBloc, BoardListState>(
        listener: (context, state) {
          if (state.showCreateDialog) {
            _showCreateBoardDialog(context);
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.boards.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null && state.boards.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage!,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<BoardListBloc>().add(RefreshBoardsEvent()),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<BoardListBloc>().add(RefreshBoardsEvent());
            },
            child: Column(
              children: [
                // Boards list
                Expanded(
                  child: state.boards.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.dashboard_outlined,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhum quadro encontrado',
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Crie seu primeiro quadro!',
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.boards.length +
                              (state.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= state.boards.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final board = state.boards[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                leading: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: board.color != null
                                        ? Color(int.parse(
                                            board.color!.replaceAll('#', '0xFF')))
                                        : theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.dashboard,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  board.title,
                                  style: theme.textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                subtitle: board.description != null
                                    ? Text(
                                        board.description!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : null,
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  context
                                      .read<BoardListBloc>()
                                      .add(BoardSelectedEvent(board));
                                  // Save selected board to service
                                  getIt<BoardSelectionService>().selectBoard(board);
                                  // Navigate to tasks page
                                  AppNavigation.navigateToTasks(context);
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateBoardDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Novo Quadro'),
      ),
    );
  }

  void _showCreateBoardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => const BoardCreateDialog(),
    ).then((_) {
      // Refresh the boards list after dialog closes
      context.read<BoardListBloc>().add(RefreshBoardsEvent());
    });
  }
}
