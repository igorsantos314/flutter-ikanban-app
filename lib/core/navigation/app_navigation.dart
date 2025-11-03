import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/core/di/app_locator.dart';
import 'package:flutter_ikanban_app/core/navigation/ui/scaffold_with_nav_bar.dart';
import 'package:flutter_ikanban_app/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter_ikanban_app/features/task/presentation/pages/task_create_page.dart';
import 'package:flutter_ikanban_app/features/task/presentation/pages/task_edit_page.dart';
import 'package:flutter_ikanban_app/features/task/presentation/pages/task_list_page.dart';
import 'package:flutter_ikanban_app/shared/theme/presentation/theme_provider.dart';
import 'package:go_router/go_router.dart';

class AppNavigation {
  static const String home = '/';
  static const String createTask = '/create-task';
  static const String editTask = '/edit-task/:id';
  static const String settings = '/settings';

  static final ThemeProvider _themeProvider = getIt<ThemeProvider>();
  static late final GoRouter router;

  static void initRouter() {
    router = getRouter();
  }

  static GoRouter getRouter() {
    print('AppNavigation created - themeProvider hash: ${identityHashCode(getIt<ThemeProvider>())}');

    return GoRouter(
    initialLocation: home,
    refreshListenable: _themeProvider,
    routes: [
      // Default route to mantain unique Scaffold structure
      ShellRoute(
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(
            path: home,
            builder: (context, state) => const TaskListPage(),
          ),

          GoRoute(
            path: settings,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
      GoRoute(
        path: createTask,
        builder: (context, state) => const TaskCreatePage(),
      ),
      GoRoute(
        path: editTask,
        builder: (context, state) {
          final taskId = state.pathParameters['id'];

          if (taskId == null) {
            throw Exception('Task ID is required to edit a task.');
          }

          return TaskEditPage(taskId: int.parse(taskId) );
        },
      ),
    ],
  );}

  static void navigateToHome(BuildContext context) {
    context.go(home);
  }

  static void navigateToTask(BuildContext context, {int? taskId}) {
    context.push(
      taskId == null ? createTask : editTask.replaceFirst(':id', taskId.toString()),
    );
  }

  static void navigateToSettings(BuildContext context) {
    context.go(settings);
  }
}
