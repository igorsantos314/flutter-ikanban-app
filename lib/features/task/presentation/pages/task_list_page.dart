import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/core/navigation/app_navigation.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppNavigation.navigateToTask(context);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: const Text('Task List')),
      body: const Center(child: Text('List of Tasks Goes Here')),
    );
  }
}
