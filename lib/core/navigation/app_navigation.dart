import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/core/navigation/ui/scaffold_with_nav_bar.dart';
import 'package:flutter_ikanban_app/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter_ikanban_app/features/task/presentation/pages/task_create_page.dart';
import 'package:flutter_ikanban_app/features/task/presentation/pages/task_edit_page.dart';
import 'package:flutter_ikanban_app/features/task/presentation/pages/task_list_page.dart';
import 'package:go_router/go_router.dart';

class AppNavigation {
  static const String home = '/';
  static const String createTask = '/create-task';
  static const String editTask = '/edit-task/:id';
  static const String settings = '/settings';

  static GoRouter get router => GoRouter(
    initialLocation: home,
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
            path: createTask,
            builder: (context, state) => const TaskCreatePage(),
          ),
          GoRoute(
            path: editTask,
            builder: (context, state) => const TaskEditPage(),
          ),
          GoRoute(
            path: settings,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );

  static void navigateToHome(BuildContext context) {
    context.go(home);
  }

  static void navigateToTask(BuildContext context, {String? taskId}) {
    context.push(
      taskId == null ? createTask : editTask.replaceFirst(':id', taskId),
    );
  }

  static void navigateToSettings(BuildContext context) {
    context.go(settings);
  }
}

