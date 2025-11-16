import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/domain/usecases/get_layout_mode_preferences.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/domain/usecases/get_task_list_status_preferences_use_case.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/domain/usecases/get_task_list_type_filter_preferences.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/domain/usecases/set_layout_mode_preferences.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/domain/usecases/set_task_list_status_preferences_use_case.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/domain/usecases/set_task_list_type_filter_preferences.dart';
import 'package:flutter_ikanban_app/core/di/app_locator.dart';
import 'package:flutter_ikanban_app/core/navigation/app_navigation.dart';
import 'package:flutter_ikanban_app/core/ui/enums/layout_mode.dart';
import 'package:flutter_ikanban_app/core/ui/widgets/appbar/custom_app_bar.dart';
import 'package:flutter_ikanban_app/core/ui/widgets/snackbars.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/sort_model.dart';
import 'package:flutter_ikanban_app/features/task/domain/use_cases/list_task_use_case.dart';
import 'package:flutter_ikanban_app/features/task/domain/use_cases/update_task_use_case.dart';
import 'package:flutter_ikanban_app/features/task/presentation/bloc/task_list_bloc.dart';
import 'package:flutter_ikanban_app/features/task/presentation/enums/task_layout.dart';
import 'package:flutter_ikanban_app/features/task/presentation/events/form/task_form_events.dart';
import 'package:flutter_ikanban_app/features/task/presentation/events/list/task_list_events.dart';
import 'package:flutter_ikanban_app/features/task/presentation/extensions/task_type_enum_extensions.dart';
import 'package:flutter_ikanban_app/features/task/presentation/modals/filter_selector_bottom_sheet.dart';
import 'package:flutter_ikanban_app/features/task/presentation/modals/sort_selector_bottom_sheet.dart';
import 'package:flutter_ikanban_app/features/task/presentation/modals/task_details_bottom_sheet.dart';
import 'package:flutter_ikanban_app/features/task/presentation/states/list/task_list_state.dart';
import 'package:flutter_ikanban_app/features/task/presentation/modals/status_selector_bottom_sheet.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/selectors/task_form_selectors_mixin.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/task_item_list.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/task_status_filter.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskListBloc(
        getIt.get<UpdateTaskUseCase>(),
        getIt.get<ListTaskUseCase>(),
        getIt.get<SetTaskListStatusPreferencesUseCase>(),
        getIt.get<GetTaskListStatusPreferencesUseCase>(),
        getIt.get<SetTaskListTypeFilterPreferencesUsecase>(),
        getIt.get<GetTaskListTypeFilterPreferencesUsecase>(),
        getIt.get<SetLayoutModePreferencesUseCase>(),
        getIt.get<GetLayoutModePreferencesUseCase>(),
      ),
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

  void _showFilterModal(BuildContext context, TaskListState state) {
    FilterSelectorBottomSheet.show(
      context: context,
      initialSelectedTypes: state.typeFilters,
      onApply: (selectedTypes) {
        context.read<TaskListBloc>().add(
          FilterTasksApplyEvent(selectedTypes: selectedTypes),
        );
      },
      onClear: () {
        context.read<TaskListBloc>().add(
          const FilterTasksApplyEvent(selectedTypes: []),
        );
      },
    );
  }

  void _showSortModal(BuildContext context, TaskListState state) {
    SortSelectorBottomSheet.show(
      context: context,
      initialSort: SortOption(field: state.sortBy, order: state.sortOrder),
      onApply: (sortOption) {
        context.read<TaskListBloc>().add(
          ApplySortEvent(sortBy: sortOption.field, sortOrder: sortOption.order),
        );
      },
    );
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
                isShowArchived: true,
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
        BlocListener<TaskListBloc, TaskListState>(
          listenWhen: (previous, current) =>
              previous.showFilterOptions != current.showFilterOptions,
          listener: (context, state) {
            if (state.showFilterOptions) {
              _showFilterModal(context, state);
              context.read<TaskListBloc>().add(
                const TaskFormResetEvent(showFilterOptions: false),
              );
            }
          },
        ),
        BlocListener<TaskListBloc, TaskListState>(
          listenWhen: (previous, current) =>
              previous.showSortOptions != current.showSortOptions,
          listener: (context, state) {
            if (state.showSortOptions) {
              _showSortModal(context, state);
              context.read<TaskListBloc>().add(
                const TaskFormResetEvent(showSortOptions: false),
              );
            }
          },
        ),
        BlocListener<TaskListBloc, TaskListState>(
          listenWhen: (previous, current) =>
              previous.showTaskDetails != current.showTaskDetails &&
              current.showTaskDetails == true,
          listener: (context, state) {
            final task = state.selectedTask;
            if (task == null) return;

            TaskDetailsBottomSheet.show(context: context, task: task, onEdit: () {
              AppNavigation.navigateToTask(
                context,
                taskId: task.id,
              );
            },);

            // Fechar detalhes da tarefa ao voltar
            context.read<TaskListBloc>().add(
              TaskFormResetEvent(showTaskDetails: false),
            );
          },
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          onClose: () {
            context.read<TaskListBloc>().add(const SearchTasksEvent(query: ''));
          },
          onSubmit: (query) {
            context.read<TaskListBloc>().add(SearchTasksEvent(query: query));
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
            BlocSelector<TaskListBloc, TaskListState, TaskStatus>(
              selector: (state) => state.statusFilter,
              builder: (context, selectedStatus) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TaskStatusFilter(
                    selectedStatus: selectedStatus,
                    onChanged: (newSelection) {
                      context.read<TaskListBloc>().add(
                        TaskListUpdateStatusFilterEvent(status: newSelection),
                      );
                    },
                    showSelectAll: true,
                  ),
                );
              },
            ),

            // Type Filters Display
            BlocSelector<TaskListBloc, TaskListState, List<TaskType>>(
              selector: (state) => state.typeFilters,
              builder: (context, typeFilters) {
                if (typeFilters.isEmpty) return const SizedBox.shrink();

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filtros ativos (${typeFilters.length})',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<TaskListBloc>().add(
                                const FilterTasksApplyEvent(selectedTypes: []),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Limpar',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: typeFilters.map((type) {
                          return Chip(
                            avatar: Icon(
                              type.icon,
                              size: 12,
                              color: type.color,
                            ),
                            label: Text(
                              type.displayName,
                              style: const TextStyle(fontSize: 10),
                            ),
                            backgroundColor: type.color.withValues(alpha: .1),
                            side: BorderSide(
                              color: type.color.withValues(alpha: .3),
                              width: 1,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          );
                        }).toList(),
                      ),
                    ],
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
                    previous.hasError != current.hasError ||
                    previous.layoutMode != current.layoutMode,
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
                                : 'Nenhuma tarefa encontrada',
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // Layout Toggle
                          _buildOptions(theme),
                          const SizedBox(height: 8),
                          Expanded(
                            child: state.layoutMode == TaskLayout.grid
                                ? GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisSpacing: 8.0,
                                          crossAxisSpacing: 8.0,
                                          crossAxisCount: 2,
                                          childAspectRatio: 1.2,
                                        ),
                                    itemCount:
                                        state.tasks.length +
                                        (state.hasMorePages ? 1 : 0),
                                    itemBuilder: (context, index) =>
                                        _taskItemBuilder(context, state, index),
                                  )
                                : ListView.builder(
                                    itemCount:
                                        state.tasks.length +
                                        (state.hasMorePages ? 1 : 0),
                                    itemBuilder: (context, index) =>
                                        _taskItemBuilder(context, state, index),
                                  ),
                          ),
                        ],
                      ),
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

  Widget _taskItemBuilder(
    BuildContext context,
    TaskListState state,
    int index,
  ) {
    {
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
          context.read<TaskListBloc>().add(const LoadMoreTasksEvent());
        });
      }

      final task = state.tasks[index];
      return TaskItemList(
        task: task,
        layoutMode: state.layoutMode == TaskLayout.list
            ? LayoutMode.fullWidth
            : LayoutMode.compact,
        onTap: () {
          context.read<TaskListBloc>().add(ShowTaskDetailsEvent(task: task));
        },
        onLongPress: () {
          context.read<TaskListBloc>().add(TaskSelectedEvent(task: task));
        },
        onToggleCompletion: () {
          context.read<TaskListBloc>().add(
            ToggleTaskCompletionEvent(id: task.id!),
          );
        },
      );
    }
  }

  Widget _buildOptions(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 2.0),
            child: Text(
              'Opções:',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter Button
                GestureDetector(
                  onTap: () {
                    context.read<TaskListBloc>().add(
                      const FilterTasksClickEvent(),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: theme.colorScheme.onSurface.withAlpha(30),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.filter_list),
                        const SizedBox(width: 4),
                        Text('Filtrar'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Sort Button
                GestureDetector(
                  onTap: () {
                    context.read<TaskListBloc>().add(
                      const SortTasksClickEvent(),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: theme.colorScheme.onSurface.withAlpha(30),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.sort),
                        const SizedBox(width: 4),
                        Text('Ordenar por'),
                      ],
                    ),
                  ),
                ),

                // Toggle Layout Mode
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    context.read<TaskListBloc>().add(ToggleLayoutModeEvent());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: theme.colorScheme.onSurface.withAlpha(30),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.view_module),
                        const SizedBox(width: 4),
                        Text('Layout'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
