import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/di/app_locator.dart';
import 'package:flutter_ikanban_app/core/navigation/app_navigation.dart';
import 'package:flutter_ikanban_app/core/ui/widgets/appbar/custom_app_bar.dart';
import 'package:flutter_ikanban_app/core/ui/widgets/snackbars.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/list/task_list_bloc.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/list/task_list_state.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/task_event.dart';
import 'package:flutter_ikanban_app/features/task/presentation/modals/status_selector_bottom_sheet.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/selectors/task_form_selectors_mixin.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/task_item_list.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/task_status_filter.dart';

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

class _TaskListPageContentState extends State<TaskListPageContent>
    with TaskFormSelectorsMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskListBloc>().add(LoadTasksEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        BlocListener<TaskListBloc, TaskListState>(
          listenWhen: (previous, current) =>
              previous.showStatusSelector != current.showStatusSelector,
          listener: (context, state) {
            if (state.showStatusSelector) {
              final task = state.selectedTask;
              if (task == null) return;

              StatusSelectorBottomSheet.show(
                context: context,
                selectedStatus: task.status,
                onStatusSelected: (status) {
                  context.read<TaskListBloc>().add(
                    TaskListUpdateStatus(status: status),
                  );
                },
              );
              context.read<TaskListBloc>().add(
                TaskFormResetEvent(showStatusSelector: false),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          onClose: () {
            context.read<TaskListBloc>().add(
              const SearchTasksEvent(query: ''),
            );
          },
          onSubmit: (query) {
            context.read<TaskListBloc>().add(
              SearchTasksEvent(query: query),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AppNavigation.navigateToTask(context);
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            // Filter Bar
            BlocSelector<TaskListBloc, TaskListState, List<TaskStatus>>(
              selector: (state) => state.statusFilter,
              builder: (context, selectedStatuses) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TaskStatusFilter(
                    selectedStatus: selectedStatuses,
                    onChanged: (newSelection) {
                      context.read<TaskListBloc>().add(
                        TaskListUpdateStatusFilter(statusFilter: newSelection),
                      );
                    },
                    showSelectAll: true,
                  ),
                );
              },
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
                          Icon(
                            Icons.task_alt,
                            size: 64,
                            color: theme.colorScheme.onSurface.withAlpha(100),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.searchQuery.isNotEmpty
                                ? 'Nenhuma tarefa encontrada para "${state.searchQuery}"'
                                : 'Você ainda não registrou nenhuma tarefa',
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.onSurface,
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.center,
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
                            AppNavigation.navigateToTask(
                              context,
                              taskId: task.id,
                            );
                          },
                          onLongPress: () {
                            context.read<TaskListBloc>().add(
                              TaskSelectedEvent(task: task),
                            );
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
