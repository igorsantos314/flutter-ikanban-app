import 'package:flutter/material.dart';

class TaskCreatePage extends StatelessWidget {
  const TaskCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
      ),
      body: const Center(
        child: Text('Task Creation Form Goes Here'),
      ),
    );
  }
}