import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/di/app_locator.dart';
import 'package:flutter_ikanban_app/core/navigation/app_navigation.dart';
import 'package:flutter_ikanban_app/core/ui/widgets/snackbars.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/list/task_list_bloc.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/list/task_list_state.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/task_event.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/task_item_list.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskListBloc(getIt.get()),
      child: const TaskListPageContent(),
    );
  }
}

class TaskListPageContent extends StatefulWidget {
  const TaskListPageContent({super.key});

  @override
  State<TaskListPageContent> createState() => _TaskListPageContentState();
}

class _TaskListPageContentState extends State<TaskListPageContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskListBloc>().add(LoadTasksEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TaskListBloc, TaskListState>(
          listenWhen: (previous, current) =>
              previous.showNotification != current.showNotification &&
              current.showNotification == true,
          listener: (context, state) {
            showCustomSnackBar(
              context,
              state.notificationMessage,
              state.notificationType,
            );
            // Usar Future.microtask para evitar problemas de timing
            Future.microtask(() {
              if (context.mounted) {
                context.read<TaskListBloc>().add(
                  TaskFormResetEvent(showNotification: false),
                );
              }
            });
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Task List')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AppNavigation.navigateToTask(context);
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Buscar tarefas...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  context.read<TaskListBloc>().add(
                    SearchTasksEvent(query: value),
                  );
                },
              ),
            ),
            // Task List
            Expanded(
              child: BlocBuilder<TaskListBloc, TaskListState>(
                buildWhen: (previous, current) =>
                    previous.tasks != current.tasks ||
                    previous.isLoading != current.isLoading ||
                    previous.isLoadingMore != current.isLoadingMore ||
                    previous.hasError != current.hasError,
                builder: (context, state) {
                  // Loading inicial
                  if (state.isLoading && state.tasks.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Carregando tarefas...'),
                        ],
                      ),
                    );
                  }

                  // Estado vazio
                  if (state.tasks.isEmpty && !state.isLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.task_alt,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.searchQuery.isNotEmpty
                                ? 'Nenhuma tarefa encontrada para "${state.searchQuery}"'
                                : 'Nenhuma tarefa encontrada',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<TaskListBloc>().add(
                                const RefreshTasksEvent(),
                              );
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Atualizar'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Lista com scroll infinito
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<TaskListBloc>().add(
                        const RefreshTasksEvent(),
                      );
                    },
                    child: ListView.builder(
                      itemCount:
                          state.tasks.length + (state.hasMorePages ? 1 : 0),
                      itemBuilder: (context, index) {
                        // Item de loading no final (scroll infinito)
                        if (index == state.tasks.length) {
                          if (state.isLoadingMore) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 8),
                                    Text('Carregando mais tarefas...'),
                                  ],
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }

                        // Trigger para load more (quando chegar perto do fim)
                        if (index == state.tasks.length - 3 &&
                            state.hasMorePages &&
                            !state.isLoadingMore) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            context.read<TaskListBloc>().add(
                              const LoadMoreTasksEvent(),
                            );
                          });
                        }

                        // Item da tarefa
                        final task = state.tasks[index];
                        return TaskItemList(
                          task: task,
                          onTap: () {
                            AppNavigation.navigateToTask(context, taskId: task.id);
                          },
                          onToggleCompletion: () {
                            context.read<TaskListBloc>().add(
                              ToggleTaskCompletion(id: task.id!),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
