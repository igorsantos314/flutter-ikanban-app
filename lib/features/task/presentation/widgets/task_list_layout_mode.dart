import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/presentation/enums/task_layout.dart';

class TaskListLayoutMode extends StatelessWidget {
  final TaskLayout taskLayout;
  final VoidCallback onToggle;

  const TaskListLayoutMode({
    super.key,
    required this.taskLayout,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(taskLayout == TaskLayout.grid ? Icons.view_list : Icons.grid_view),
          onPressed: onToggle,
          tooltip: taskLayout == TaskLayout.grid ? 'Switch to List View' : 'Switch to Grid View',
        ),
      ],
    );
  }
}
